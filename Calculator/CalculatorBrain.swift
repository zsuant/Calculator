//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 이수겸 on 2022/08/26.
//

import Foundation


class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : .Constant(.pi), //.pi,
        "e" : .Constant(M_E), //M_E,
        "√" : .UnaryOperation(sqrt),
        "sin" : .UnaryOperation(sin),
        "cos" : .UnaryOperation(cos),
        "tan" : .UnaryOperation(tan),
        "x²" : .UnaryOperation({ $0 * $0 }),
        "+" : .BinaryOperation({ $0 + $1 }),
        "−" : .BinaryOperation({ $0 - $1 }),
        "×" : .BinaryOperation({ $0 * $1 }),
        "÷" : .BinaryOperation({ $0 / $1 }),
        "=" : .Equals

    ]
    

    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> (Double))
        case Equals
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                excutePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                excutePendingBinaryOperation()
            }
        }
    }
    
    func excutePendingBinaryOperation() {
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }

    }
    
    private var pending: pendingBinaryOperationInfo?
    
    private struct pendingBinaryOperationInfo {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get{
            return accumulator
        }
    }
}
 
