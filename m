Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYHUDWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYHUDWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYHUDQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:39 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50103 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbYHUDQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:07 -0400
Date: Wed, 20 Aug 2008 20:50:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2oaOJ028340@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 18/27] mdb: add mdb-proc.h function prototype includes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add mdb-proc.h function prototype includes


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb/mdb-proc.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb/mdb-proc.h	2008-08-19 16:41:53.000000000 -0600
@@ -0,0 +1,147 @@
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
+*   Free Software Foundation, version 2.
+*
+*   This program is distributed in the hope that it will be useful, but
+*   WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+*   General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright
+*   contained in this code is required to be present in any derivative
+*   works and you are required to provide the source code for this
+*   program as part of any commercial or non-commercial distribution.
+*   You are required to respect the rights of the Copyright holders
+*   named within this code.
+*
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   DESCRIP  :  Merkey's Linux Debugger
+*
+***************************************************************************/
+
+#ifndef _MDB_PROC_H
+#define _MDB_PROC_H
+
+#define MAX_PROCESSORS           NR_CPUS
+#define SYMBOL_DEBUG             0
+
+/* mdb-base.c */
+extern volatile unsigned long needs_proceed;
+extern volatile unsigned long jmp_active;
+extern unsigned long general_toggle;
+extern unsigned long line_info_toggle;
+extern unsigned long control_toggle;
+extern unsigned long segment_toggle;
+extern unsigned long numeric_toggle;
+extern unsigned long reason_toggle;
+
+extern unsigned long MajorVersion;
+extern unsigned long MinorVersion;
+extern unsigned long BuildVersion;
+extern unsigned char *IA32Flags[];
+extern unsigned char *BreakDescription[];
+extern unsigned char *BreakLengthDescription[];
+extern unsigned char *ExceptionDescription[];
+extern NUMERIC_FRAME npx[MAX_PROCESSORS];
+extern StackFrame ReferenceFrame[MAX_PROCESSORS];
+
+extern atomic_t focusActive;
+extern atomic_t debuggerActive;
+extern atomic_t debuggerProcessors[MAX_PROCESSORS];
+extern atomic_t nmiProcessors[MAX_PROCESSORS];
+extern atomic_t traceProcessors[MAX_PROCESSORS];
+extern volatile unsigned long ProcessorHold[MAX_PROCESSORS];
+extern volatile unsigned long ProcessorState[MAX_PROCESSORS];
+extern unsigned char *procState[];
+
+// mdb-ia32.c
+extern volatile unsigned char *lastDumpAddress;
+extern volatile unsigned char *lastLinkAddress;
+extern volatile unsigned long lastUnasmAddress;
+extern volatile unsigned long displayLength;
+extern volatile unsigned long lastCommand;
+extern volatile unsigned long lastCommandEntry;
+extern volatile unsigned char lastDebugCommand[100];
+extern volatile unsigned long lastDisplayLength;
+extern volatile unsigned char debugCommand[100];
+extern volatile unsigned long nextUnasmAddress;
+extern volatile unsigned long pic1Value;
+extern volatile unsigned long pic2Value;
+extern volatile unsigned long BreakReserved[4];
+extern volatile unsigned long BreakPoints[4];
+extern volatile unsigned long BreakType[4];
+extern volatile unsigned long BreakLength[4];
+extern volatile unsigned long BreakTemp[4];
+extern volatile unsigned long BreakGo[4];
+extern volatile unsigned long BreakProceed[4];
+extern volatile unsigned long BreakMask[MAX_PROCESSORS];
+extern volatile StackFrame *CurrentFrame[MAX_PROCESSORS];
+extern volatile unsigned long NestedInterrupts[MAX_PROCESSORS];
+extern volatile unsigned long ConditionalBreakpoint[4];
+extern volatile unsigned char BreakCondition[4][256];
+extern volatile StackFrame lastStackFrame;
+extern volatile unsigned long lastCR0;
+extern volatile unsigned long lastCR2;
+extern volatile unsigned long lastCR4;
+extern volatile unsigned long CurrentDR7;
+extern volatile unsigned long CurrentDR6[MAX_PROCESSORS];
+extern volatile unsigned long repeatCommand;
+extern volatile unsigned long totalLines;
+extern volatile unsigned long debuggerInitialized;
+//extern volatile unsigned long ssbmode[MAX_PROCESSORS];
+extern volatile unsigned long ssbmode;
+extern volatile int nextline;
+
+extern unsigned long disassemble(StackFrame *stackFrame, unsigned long p, unsigned long count,
+                         unsigned long use);
+extern void ClearDebuggerState(void);
+extern void displayMTRRRegisters(void);
+extern void DisplayGDT(unsigned char *GDT_ADDRESS);
+extern void DisplayIDT(unsigned char *IDT_ADDRESS);
+extern void SetDebugRegisters(void);
+extern void LoadDebugRegisters(void);
+extern void ClearTempBreakpoints(void);
+extern unsigned long ValidBreakpoint(unsigned long address);
+extern unsigned char *dump(unsigned char *p, unsigned long count);
+extern unsigned char *dumpWord(unsigned char *p, unsigned long count);
+extern unsigned char *dumpDouble(unsigned char *p, unsigned long count);
+extern unsigned char *dumpLinkedList(unsigned char *p, unsigned long count, unsigned long offset);
+extern unsigned char *dumpDoubleStack(StackFrame *stackFrame, unsigned char *p, unsigned long count);
+extern unsigned char *dumpStack(StackFrame *stackFrame, unsigned char *p, unsigned long count);
+extern unsigned long debugger_setup(unsigned long processor, unsigned long Exception, StackFrame *stackFrame, unsigned char *panicMsg);
+extern unsigned long debugger_entry(unsigned long Exception, StackFrame *stackFrame, unsigned long processor);
+extern unsigned long debugger_command_entry(unsigned long processor, unsigned long Exception, StackFrame *stackFrame);
+extern unsigned long ConsoleDisplayBreakReason(StackFrame *stackFrame,
+			       unsigned long reason, unsigned long processor,
+			       unsigned long lastCommand);
+extern unsigned long EvaluateExpression(StackFrame *stackFrame, unsigned char **p, unsigned long *type);
+extern unsigned long EvaluateNumericExpression(StackFrame *stackFrame, unsigned char **p,
+                                       unsigned long *type);
+extern unsigned long unassemble(StackFrame *stackFrame, unsigned long ip, unsigned long use,
+                        unsigned long *ret);
+extern void DisplayASCIITable(void);
+extern unsigned char *UpcaseString(unsigned char *);
+extern unsigned long validate_address(unsigned long addr);
+extern unsigned long ScreenInputFromKeyboard(unsigned char *buffer, unsigned long Start, unsigned long Length);
+
+extern unsigned long GetIP(StackFrame *);
+extern unsigned long GetStackAddress(StackFrame *);
+extern unsigned long GetStackSegment(StackFrame *);
+extern unsigned short read_memory(void *, void *, unsigned);
+extern unsigned long SSBUpdate(StackFrame *stackFrame, unsigned long processor);
+extern void mdb_breakpoint(void);
+
+#endif
