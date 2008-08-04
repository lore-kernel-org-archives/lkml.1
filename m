Return-Path: <linux-kernel-owner+w=401wt.eu-S1760620AbYHDCdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbYHDCdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760410AbYHDCce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:32:34 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44498 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760018AbYHDCcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:32:32 -0400
Message-ID: <57517.166.70.238.45.1217815930.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:12:10 -0600 (MDT)
Subject: [PATCH 2.6.26 10/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/debug/mdb-ia32-proc.h	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.26-mdb/debug/mdb-ia32-proc.h	2008-08-03 12:49:01.000000000
-0600
@@ -0,0 +1,514 @@
+
+/***************************************************************************
+*
+*   Copyright (c) 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah 84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 3.
+*
+*   This program is distributed in the hope that it will be useful, but
+*   WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU +* 
 General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright +*
  contained in this code is required to be present in any derivative +*  
works and you are required to provide the source code for this +*  
program as part of any commercial or non-commercial distribution. +*   You
are required to respect the rights of the Copyright holders +*   named
within this code.
+*
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   FILE     :  MDB-IA32-PROC.H
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#ifndef _MDB_IA32_PROC_H
+#define _MDB_IA32_PROC_H
+
+#define EXT_NMI_PORT             0x0461
+#define NMI_IO_PORT              0x0462
+#define NMI_CONTROL_PORT         0x0C6E
+#define NMI_PORT                 0x61
+#define PIC1_DEBUG_MASK          0xFC
+#define PIC2_DEBUG_MASK          0xFF
+#define EXCEPTION_ENTRIES        19
+#define RESUME                   0x00010000
+#define NESTED_TASK              0x00004000
+#define SINGLE_STEP              0x00000100
+#define INVALID_EXPRESSION       0
+#define NUMERIC_EXPRESSION       1
+#define BOOLEAN_EXPRESSION       2
+
+// DR7 Breakpoint Type and Length Fields
+
+#define BREAK_EXECUTE    0
+#define BREAK_WRITE      1
+#define BREAK_IOPORT     2
+#define BREAK_READWRITE  3
+#define ONE_BYTE_FIELD   0
+#define TWO_BYTE_FIELD   1
+#define UNDEFINED_FIELD  2
+#define FOUR_BYTE_FIELD  3
+
+// DR7 Register
+
+#define L0_BIT   0x00000001
+#define G0_BIT   0x00000002
+#define L1_BIT   0x00000004
+#define G1_BIT   0x00000008
+#define L2_BIT   0x00000010
+#define G2_BIT   0x00000020
+#define L3_BIT   0x00000040
+#define G3_BIT   0x00000080
+#define LEXACT   0x00000100
+#define GEXACT   0x00000200
+#define GDETECT  0x00002000
+#define DR7DEF   0x00000400
+
+// DR6 Register
+
+#define B0_BIT   0x00000001
+#define B1_BIT   0x00000002
+#define B2_BIT   0x00000004
+#define B3_BIT   0x00000008
+
+#define BD_BIT   0x00002000
+#define BS_BIT   0x00004000
+#define BT_BIT   0x00008000
+
+// Memory Type Range Registers (MTRR)
+
+#define MTRR_PHYS_BASE_0    0x200
+#define MTRR_PHYS_MASK_0    0x201
+#define MTRR_PHYS_BASE_1    0x202
+#define MTRR_PHYS_MASK_1    0x203
+#define MTRR_PHYS_BASE_2    0x204
+#define MTRR_PHYS_MASK_2    0x205
+#define MTRR_PHYS_BASE_3    0x206
+#define MTRR_PHYS_MASK_3    0x207
+#define MTRR_PHYS_BASE_4    0x208
+#define MTRR_PHYS_MASK_4    0x209
+#define MTRR_PHYS_BASE_5    0x20A
+#define MTRR_PHYS_MASK_5    0x20B
+#define MTRR_PHYS_BASE_6    0x20C
+#define MTRR_PHYS_MASK_6    0x20D
+#define MTRR_PHYS_BASE_7    0x20E
+#define MTRR_PHYS_MASK_7    0x20F
+
+// IA32 flags settings
+
+#define   CF_FLAG      0x00000001
+#define   PF_FLAG      0x00000004
+#define   AF_FLAG      0x00000010
+#define   ZF_FLAG      0x00000040
+#define   SF_FLAG      0x00000080
+#define   TF_FLAG      0x00000100  // ss flag
+#define   IF_FLAG      0x00000200
+#define   DF_FLAG      0x00000400
+#define   OF_FLAG      0x00000800
+#define   NT_FLAG      0x00004000
+#define   RF_FLAG      0x00010000  // resume flag
+#define   VM_FLAG      0x00020000
+#define   AC_FLAG      0x00040000
+#define   VIF_FLAG     0x00080000
+#define   VIP_FLAG     0x00100000
+#define   ID_FLAGS     0x00200000
+
+typedef struct _GDT {
+    WORD Limit;	    //	0xFFFF
+    WORD Base1;	    //  0
+    BYTE Base2;	    //	0
+    BYTE GDTType;   //	10010010b
+    BYTE OtherType; //	11001111b
+    BYTE Base3;	    //	0
+} GDT;
+
+typedef struct _IDT {
+    WORD IDTLow;     //	0
+    WORD IDTSegment; //	0x08
+    BYTE IDTSkip;    //	0
+    BYTE IDTFlags;   //	10001110b
+    WORD IDTHigh;    //	0
+} IDT;
+
+typedef struct _TSS {
+    WORD TSSLimit;	// 0x0080
+    WORD TSSBase1;	// 0
+    BYTE TSSBase2;	// 0
+    BYTE TSSType;	// 10001001b
+    BYTE TSSOtherType;	// 00000000b
+    BYTE TSSBase3;	// 0
+} TSS;
+
+typedef struct _TSS_GATE {
+    WORD TSSRes1;  	// 0
+    WORD TSSSelector;	// 0
+    BYTE TSSRes2; 	// 0
+    BYTE TSSFlags;	// 10000101b
+    WORD TSSRes3; 	// 0
+} TSS_GATE;
+
+typedef struct _LDT {
+    WORD LDTLimit;	// 0xFFFF
+    WORD LDTBase1;	// 0
+    BYTE LDTBase2;	// 0
+    BYTE LDTGDTType;	// 10000010b
+    BYTE LDTOtherType;	// 10001111b
+    BYTE LDTBase3;	// 0
+} LDT;
+
+extern ULONG ReadDR0(void);
+extern ULONG ReadDR1(void);
+extern ULONG ReadDR2(void);
+extern ULONG ReadDR3(void);
+extern ULONG ReadDR6(void);
+extern ULONG ReadDR7(void);
+extern void WriteDR0(ULONG);
+extern void WriteDR1(ULONG);
+extern void WriteDR2(ULONG);
+extern void WriteDR3(ULONG);
+extern void WriteDR6(ULONG);
+extern void WriteDR7(ULONG);
+extern ULONG ReadCR0(void);
+extern ULONG ReadCR2(void);
+extern ULONG ReadCR3(void);
+extern ULONG ReadCR4(void);
+extern void ReadGDTR(ULONG *);
+extern void ReadIDTR(ULONG *);
+extern ULONG ReadLDTR(void);
+extern ULONG ReadTR(void);
+
+extern void ReadMSR(ULONG msr, ULONG *val1, ULONG *val2);
+extern void WriteMSR(ULONG msr, ULONG *val1, ULONG *val2);
+extern void MTRROpen(void);
+extern void MTRRClose(void);
+extern void save_npx(NUMERIC_FRAME *npx);
+extern void load_npx(NUMERIC_FRAME *npx);
+
+extern ULONG get_processor_id(void);
+extern ULONG get_physical_processor(void);
+extern ULONG fpu_present(void);
+
+extern void DisplayTSS(StackFrame *stackFrame);
+extern void DisplayGeneralRegisters(StackFrame *stackFrame);
+extern void DisplaySegmentRegisters(StackFrame *stackFrame);
+extern void DisplayControlRegisters(ULONG processor, StackFrame
*stackFrame);
+extern double ldexp(double v, int e);
+extern void DisplayNPXRegisters(ULONG processor);
+
+extern ULONG processProceedACC(ULONG key, void *stackFrame,
+		  ACCELERATOR *accel);
+extern ULONG processTraceACC(ULONG key, void *stackFrame,
+		  ACCELERATOR *accel);
+extern ULONG processTraceSSBACC(ULONG key, void *stackFrame,
+		  ACCELERATOR *accel);
+extern ULONG processGoACC(ULONG key, void *stackFrame,
+		  ACCELERATOR *accel);
+
+extern ULONG executeCommandHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG processProceed(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser);
+extern ULONG processTrace(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+extern ULONG processTraceSSB(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+extern ULONG processGo(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+
+
+extern ULONG processorCommandHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG breakProcessor(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser);
+extern ULONG TSSDisplayHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG TSSDisplay(BYTE *cmd,
+                    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser);
+
+extern ULONG displayEAXHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeEAXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+extern ULONG ChangeORIGEAXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayEBXHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeEBXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayECXHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeECXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayEDXHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeEDXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayESIHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeESIRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayEDIHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeEDIRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayEBPHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeEBPRegister(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+
+extern ULONG displayESPHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeESPRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayEIPHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeEIPRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayCSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeCSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern ULONG displayDSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeDSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern ULONG displayESHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeESRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern ULONG displayFSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeFSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern ULONG displayGSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeGSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern ULONG displaySSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeSSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern ULONG displayRFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeRFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayTFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeTFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayZFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeZFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displaySFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeSFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayPFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangePFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayCFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeCFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayOFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeOFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayIFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeIFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayIDHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeIDFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayDFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeDFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayNTHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeNTFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayVMHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeVMFlag(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+
+extern ULONG displayVIFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeVIFFlag(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern ULONG displayVIPHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeVIPFlag(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern ULONG displayAFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeAFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayACHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ChangeACFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser);
+
+extern ULONG displayMTRRHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG DisplayMTRRRegisters(BYTE *cmd,
+			  StackFrame *stackFrame, ULONG Exception,
+			  DEBUGGER_PARSER *parser);
+
+extern ULONG displayGDTHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayGDT(BYTE *cmd,
+		StackFrame *stackFrame, ULONG Exception,
+		DEBUGGER_PARSER *parser);
+
+extern ULONG displayIDTHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayIDT(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern ULONG evaluateExpressionHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG evaluateExpression(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern ULONG displayDOSTableHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG displayDOSTable(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern ULONG portCommandHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG inputWordPort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG inputDoublePort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG inputBytePort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG inputPort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG outputWordPort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG outputDoublePort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG outputBytePort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG outputPort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+
+
+extern ULONG breakpointCommandHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG breakpointClearAll(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser);
+extern ULONG breakpointClear(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+extern ULONG breakpointMask(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser);
+extern ULONG breakpointWord1(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+extern ULONG breakpointWord2(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+extern ULONG breakpointWord4(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+extern ULONG breakpointWord(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser);
+extern ULONG breakpointRead1(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+extern ULONG breakpointRead2(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+extern ULONG breakpointRead4(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG breakpointRead(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG breakpointIO1(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG breakpointIO2(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG breakpointIO4(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG breakpointIO(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG breakpointExecute(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG breakpointShowTemp(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser);
+extern ULONG dump_ef(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+extern ULONG dump_uf(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+
+#endif
+


By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey




