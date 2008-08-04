Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbYHDG71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbYHDG71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbYHDG7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:59:19 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50377 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbYHDG7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:59:18 -0400
Message-ID: <51985.166.70.238.45.1217831932.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:38:52 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 18/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/debug/mdb-proc.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb-proc.h	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,139 @@
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
+*   FILE     :  MDB-PROC.H
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#ifndef _MDB_PROC_H
+#define _MDB_PROC_H
+
+#define MAX_PROCESSORS           NR_CPUS
+#define SYMBOL_DEBUG             0
+
+// mdb-base.c
+extern ULONG needs_proceed;
+extern ULONG general_toggle;
+extern ULONG line_info_toggle;
+extern ULONG control_toggle;
+extern ULONG segment_toggle;
+extern ULONG numeric_toggle;
+extern ULONG reason_toggle;
+
+extern ULONG MajorVersion;
+extern ULONG MinorVersion;
+extern ULONG BuildVersion;
+extern BYTE *IA32Flags[];
+extern BYTE *BreakDescription[];
+extern BYTE *BreakLengthDescription[];
+extern BYTE *ExceptionDescription[];
+extern NUMERIC_FRAME npx[MAX_PROCESSORS];
+extern StackFrame ReferenceFrame[MAX_PROCESSORS];
+extern volatile ULONG debuggerActive;
+extern volatile ULONG ProcessorHold[MAX_PROCESSORS];
+extern volatile ULONG ProcessorState[MAX_PROCESSORS];
+extern volatile ULONG ProcessorMode[MAX_PROCESSORS];
+
+// mdb-ia32.c
+extern volatile BYTE *lastDumpAddress;
+extern volatile BYTE *lastLinkAddress;
+extern volatile ULONG lastUnasmAddress;
+extern volatile ULONG displayLength;
+extern volatile ULONG lastCommand;
+extern volatile ULONG lastCommandEntry;
+extern volatile BYTE lastDebugCommand[100];
+extern volatile ULONG lastDisplayLength;
+extern volatile BYTE debugCommand[100];
+extern volatile ULONG nextUnasmAddress;
+extern volatile ULONG pic1Value;
+extern volatile ULONG pic2Value;
+extern volatile ULONG BreakReserved[4];
+extern volatile ULONG BreakPoints[4];
+extern volatile ULONG BreakType[4];
+extern volatile ULONG BreakLength[4];
+extern volatile ULONG BreakTemp[4];
+extern volatile ULONG BreakGo[4];
+extern volatile ULONG BreakProceed[4];
+extern volatile ULONG BreakMask[MAX_PROCESSORS];
+extern volatile StackFrame *CurrentFrame[MAX_PROCESSORS];
+extern volatile ULONG NestedInterrupts[MAX_PROCESSORS];
+extern volatile ULONG ConditionalBreakpoint[4];
+extern volatile BYTE BreakCondition[4][256];
+extern volatile StackFrame lastStackFrame;
+extern volatile ULONG lastCR0;
+extern volatile ULONG lastCR2;
+extern volatile ULONG lastCR4;
+extern volatile ULONG CurrentDR7;
+extern volatile ULONG CurrentDR6[MAX_PROCESSORS];
+extern volatile ULONG repeatCommand;
+extern volatile ULONG totalLines;
+extern volatile ULONG debuggerInitialized;
+
+extern ULONG disassemble(StackFrame *stackFrame, ULONG p, ULONG count,
+                         ULONG use);
+extern void ClearDebuggerState(void);
+extern void displayMTRRRegisters(void);
+extern void DisplayGDT(BYTE *GDT_ADDRESS);
+extern void DisplayIDT(BYTE *IDT_ADDRESS);
+extern void SetDebugRegisters(void);
+extern void LoadDebugRegisters(void);
+extern void ClearTempBreakpoints(void);
+extern ULONG ValidBreakpoint(ULONG address);
+extern BYTE *dump(BYTE *p, ULONG count);
+extern BYTE *dumpWord(BYTE *p, ULONG count);
+extern BYTE *dumpDouble(BYTE *p, ULONG count);
+extern BYTE *dumpLinkedList(BYTE *p, ULONG count, ULONG offset);
+extern BYTE *dumpDoubleStack(StackFrame *stackFrame, BYTE *p, ULONG count);
+extern BYTE *dumpStack(StackFrame *stackFrame, BYTE *p, ULONG count);
+extern ULONG debugger_setup(ULONG processor, ULONG Exception, StackFrame
*stackFrame, BYTE *panicMsg);
+extern ULONG debugger_entry(ULONG Exception, StackFrame *stackFrame,
ULONG processor);
+extern ULONG debugger_command_entry(ULONG processor, ULONG Exception,
StackFrame *stackFrame);
+extern ULONG ConsoleDisplayBreakReason(StackFrame *stackFrame,
+			       ULONG reason, ULONG processor,
+			       ULONG lastCommand);
+extern ULONG EvaluateExpression(StackFrame *stackFrame, BYTE **p, ULONG
*type);
+extern ULONG EvaluateNumericExpression(StackFrame *stackFrame, BYTE **p,
+                                       ULONG *type);
+extern ULONG unassemble(StackFrame *stackFrame, ULONG ip, ULONG use,
+                        ULONG *ret);
+extern void DisplayASCIITable(void);
+extern BYTE *UpcaseString(BYTE *);
+extern ULONG validate_address(ULONG addr);
+extern ULONG ScreenInputFromKeyboard(BYTE *buffer, ULONG Start, ULONG
Length);
+
+extern ULONG GetIP(StackFrame *);
+extern ULONG GetStackAddress(StackFrame *);
+extern ULONG GetStackSegment(StackFrame *);
+extern WORD read_memory(void *, void *, unsigned);
+
+#endif
+


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



