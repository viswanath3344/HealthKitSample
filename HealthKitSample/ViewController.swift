//
//  ViewController.swift
//  HealthKitSample
//
//  Created by Ming-En Liu on 18/07/18.
//  Copyright © 2018 Vedas labs. All rights reserved.
//


// Step1 : Enable  HealthKit in Project Capabilities
// Step2 : Add Two keys in Plist for writing and reading data from Apple Health App.


import UIKit
import HealthKit

class ViewController: UIViewController {

    var healthStore:HKHealthStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HKHealthStore.isHealthDataAvailable() {
            // Add code to use HealthKit here.
            print("Health Data available")
             healthStore = HKHealthStore()
            
            let readTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                                HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                                HKObjectType.quantityType(forIdentifier: .height)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
                                HKObjectType.characteristicType(forIdentifier: .bloodType)!,
                                HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                                HKObjectType.characteristicType(forIdentifier: .wheelchairUse)!,
                                ])
            
            
            let writeTypes = Set([HKObjectType.workoutType(),HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                  HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                  HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                  HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                                  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
                                  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!
                                  ])
            
            
            
            healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { (success, error) in
                if !success {
                    print(error.debugDescription)
                    // Handle the error here.
                }
                else
                {
                    self.readBioLogicalSex()
                    self.readBloodGroup()
                    self.readDateOfBirth()
                    self.readWheelChairStatus()
                    self.readHeight()
                    self.readWeight()
                    
                }
            }
        }
        else
        {
            print("Health Data not available")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func readBioLogicalSex()  {
        
        do {
            let biologicalSex = try healthStore.biologicalSex()
        
            switch biologicalSex.biologicalSex
            {
            case HKBiologicalSex.male:
                print("Male")
                break
            case HKBiologicalSex.female:
                print("Female")
                break
            case HKBiologicalSex.other:
                print("Others")
                break
            default:
                print("Not set")
                break
            }
            
        } catch let  error{
            print(error)
        }
    }

    func readBloodGroup()  {
        
        do {
            
            let bloodGroup = try healthStore.bloodType()
            
            switch bloodGroup.bloodType
            {
            case HKBloodType.aPositive:
                print("A+")
                break
            case HKBloodType.aNegative:
                print("A-")
                break
            case HKBloodType.bPositive:
                print("B+")
                break
            case HKBloodType.bNegative:
                print("B-")
                break
            case HKBloodType.oPositive:
                print("O+")
                break
            case HKBloodType.oNegative:
                print("O-")
                break
            case HKBloodType.abPositive:
                print("AB+")
                break
            case HKBloodType.abNegative:
                print("AB-")
                break
            default:
                print("Not set")
                break
            }
            
        }catch let error {
            print(error)
            
        }
    
    }
    
    func readDateOfBirth()  {
        do {
            let dateOfBirth = try healthStore.dateOfBirthComponents()
            
            if let date  = dateOfBirth.date
            {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                print(formatter.string(from: date))
            }
            
        }catch let error {
            print(error)
        }
    }
    
    func readWheelChairStatus()  {
        do {
            let wheelChairStatus = try healthStore.wheelchairUse()
          
            switch wheelChairStatus.wheelchairUse {
            case .yes:
                print("Wheel Chair Using")
                break
            case .no:
                print("No Wheel Chair Using")
                break
            default:
                print("Not set")
            }
            
        }catch let error {
            print(error)
        }
    }
    
    func readHeight(){
        let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample{
                print("Height => \(result.quantity)")
            }else{
                print("OOPS didnt get height \nResults => \(String(describing: results)), error => \(String(describing: error))")
            }
        }
        self.healthStore.execute(query)
    }
    func readWeight(){
        let bodyMass = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let query = HKSampleQuery(sampleType: bodyMass, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample{
                print("bodyMass => \(result.quantity)")
            }else{
                print("OOPS didnt get height \nResults => \(String(describing: results)), error => \(String(describing: error))")
            }
        }
        self.healthStore.execute(query)
        
    }
    
    
    func saveHeight() {
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) {
            let date = Date()
            let quantity = HKQuantity(unit: HKUnit.inch(), doubleValue: 100.0)
            let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
            self.healthStore.save(sample, withCompletion: { (success, error) in
                print("Saved \(success), error \(String(describing: error))")
            })
        }
    }
    
    
}

