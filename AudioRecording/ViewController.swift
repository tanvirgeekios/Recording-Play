//
//  ViewController.swift
//  AudioRecording
//
//  Created by MD Tanvir Alam on 30/3/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    
    var soundRecorder:AVAudioRecorder!
    var soundPlayer:AVAudioPlayer!
    
    var fileName : String = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        
        
        setupRecorder()
        playBTN.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Error", message: " Please add a microphone and record Otherwise App will Crash", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getDocumentDirectiory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecorder(){
        let audiofileName = getDocumentDirectiory().appendingPathComponent(fileName)
        let recordSetting = [AVFormatIDKey:kAudioFormatAppleLossless,
                             AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue,
                             AVEncoderBitRateKey:320000,
                             AVNumberOfChannelsKey:2,
                             AVSampleRateKey:44100.2] as [String : Any]
        do{
            soundRecorder = try AVAudioRecorder(url: audiofileName, settings: recordSetting)
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        }catch{
            print(error)
        }
    }
    
    func setUpPlayer(){
        let audiofileName = getDocumentDirectiory().appendingPathComponent(fileName)
        print("file Name:\(audiofileName)")
        do{
            
                soundPlayer = try AVAudioPlayer(contentsOf: audiofileName)
                soundPlayer.delegate = self
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 1
           
            
        }catch{
            print("SetupPlayer error:\(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBTN.isEnabled = true
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBTN.isEnabled = true
        playBTN.setTitle("Play", for: .normal)
    }
    
    @IBAction func recordAction(_ sender: UIButton) {
        if recordBTN.titleLabel?.text == "Record"{
            soundRecorder.record()
            recordBTN.setTitle("Stop", for: .normal)
            playBTN.isEnabled = false
        }else{
            soundRecorder.stop()
            recordBTN.setTitle("Record", for: .normal)
            playBTN.isEnabled = true
        }
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        //if soundPlayer != nil{
            if playBTN.titleLabel?.text == "Play"{
                playBTN.setTitle("Stop", for: .normal)
                recordBTN.isEnabled = false
                setUpPlayer()
                soundPlayer.play()
            }else{
                soundPlayer.stop()
                playBTN.setTitle("Play", for: .normal)
                recordBTN.isEnabled = true
            }
//        }else{
//            let alert = UIAlertController(title: "Error", message: "No microphone, Please add a microphone and record again", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true, completion: nil)
//        }
    }
}

