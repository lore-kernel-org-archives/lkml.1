Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYHDG45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYHDG45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbYHDG4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:56:49 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48687 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbYHDG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:56:48 -0400
Message-ID: <51973.166.70.238.45.1217831782.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:36:22 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 14/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
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

--- a/debug/mdb-list.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb-list.h	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,86 @@
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
+*   FILE     :  MDB-LIST.H
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#ifndef _MDB_LIST
+#define _MDB_LIST
+
+typedef struct _ACCELERATOR
+{
+    struct _ACCELERATOR *accelNext;
+    struct _ACCELERATOR *accelPrior;
+    ULONG (*accelRoutine)(ULONG key, void *p, struct _ACCELERATOR *parser);
+    ULONG (*accelRoutineHelp)(ULONG key, struct _ACCELERATOR *parser);
+    ULONG accelFlags;
+    ULONG key;
+    ULONG supervisorCommand;
+    BYTE *shortHelp;
+} ACCELERATOR;
+
+typedef struct _ALT_DEBUGGER
+{
+    struct _ALT_DEBUGGER *altDebugNext;
+    struct _ALT_DEBUGGER *altDebugPrior;
+    int (*AlternateDebugger)(int reason, int error, void *frame);
+} ALT_DEBUGGER;
+
+extern int AlternateDebuggerRoutine(int reason, int error, void *frame);
+extern ULONG AddAlternateDebugger(ALT_DEBUGGER *Debugger);
+extern ULONG RemoveAlternateDebugger(ALT_DEBUGGER *Debugger);
+
+typedef struct _DEBUGGER_PARSER {
+    struct _DEBUGGER_PARSER *debugNext;
+    struct _DEBUGGER_PARSER *debugPrior;
+    ULONG (*DebugCommandParser)(BYTE *commandLine,
+			       StackFrame *stackFrame, ULONG Exception,
+			       struct _DEBUGGER_PARSER *parser);
+    ULONG (*DebugCommandParserHelp)(BYTE *commandLine,
+				   struct _DEBUGGER_PARSER *parser);
+    ULONG parserFlags;
+    BYTE *debugCommandName;
+    ULONG debugCommandNameLength;
+    ULONG supervisorCommand;
+    BYTE *shortHelp;
+    ULONG controlTransfer;
+} DEBUGGER_PARSER;
+
+extern ULONG DebuggerParserRoutine(BYTE *command, BYTE *commandLine,
+			   StackFrame *stackFrame, ULONG Exception);
+extern ULONG DebuggerParserHelpRoutine(BYTE *command, BYTE *commandLine);
+extern ULONG AddDebuggerCommandParser(DEBUGGER_PARSER *parser);
+extern ULONG RemoveDebuggerCommandParser(DEBUGGER_PARSER *parser);
+
+#endif
+


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



