//
//  GameScene.swift
//  Project-23-Space-Race
//
//  Created by verebes on 04/10/2018.
//  Copyright © 2018 A&D Progress. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var startfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer!
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        setupGame()
    }
    
   
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        isGameOver = true
        
//        self.run(SKAction.wait(forDuration: 5.0))
//        self.removeAllChildren()
//        gameTimer.invalidate()
//        setupGame()
    }
    
    @objc private func createEnemy() {
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleEnemies) as! [String]
        let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 736)
        
        let sprite = SKSpriteNode(imageNamed: possibleEnemies[0])
        sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
    }
    
    private func setupGame() {
        backgroundColor = UIColor.black
        
        startfield = SKEmitterNode(fileNamed: "Starfield")
        startfield.position = CGPoint(x: 1024, y: 384)
        startfield.advanceSimulationTime(10)
        addChild(startfield)
        startfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody!.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        isGameOver = false
    }
}
