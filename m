Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbYHUDUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbYHUDUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbYHUDQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:29 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50100 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbYHUDQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:06 -0400
Date: Wed, 20 Aug 2008 20:50:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2oai7028335@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 13/27] mdb: add mdb-list.h debugger parser function includes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add mdb-list.h debugger parser function includes

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb/mdb-list.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb/mdb-list.h	2008-08-18 23:40:26.000000000 -0600
@@ -0,0 +1,83 @@
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
+#ifndef _MDB_LIST
+#define _MDB_LIST
+
+typedef struct _ACCELERATOR
+{
+    struct _ACCELERATOR *accelNext;
+    struct _ACCELERATOR *accelPrior;
+    unsigned long (*accelRoutine)(unsigned long key, void *p, struct _ACCELERATOR *parser);
+    unsigned long (*accelRoutineHelp)(unsigned long key, struct _ACCELERATOR *parser);
+    unsigned long accelFlags;
+    unsigned long key;
+    unsigned long supervisorCommand;
+    unsigned char *shortHelp;
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
+extern unsigned long AddAlternateDebugger(ALT_DEBUGGER *Debugger);
+extern unsigned long RemoveAlternateDebugger(ALT_DEBUGGER *Debugger);
+
+typedef struct _DEBUGGER_PARSER {
+    struct _DEBUGGER_PARSER *debugNext;
+    struct _DEBUGGER_PARSER *debugPrior;
+    unsigned long (*DebugCommandParser)(unsigned char *commandLine,
+			       StackFrame *stackFrame, unsigned long Exception,
+			       struct _DEBUGGER_PARSER *parser);
+    unsigned long (*DebugCommandParserHelp)(unsigned char *commandLine,
+				   struct _DEBUGGER_PARSER *parser);
+    unsigned long parserFlags;
+    unsigned char *debugCommandName;
+    unsigned long debugCommandNameLength;
+    unsigned long supervisorCommand;
+    unsigned char *shortHelp;
+    unsigned long controlTransfer;
+} DEBUGGER_PARSER;
+
+extern unsigned long DebuggerParserRoutine(unsigned char *command, unsigned char *commandLine,
+			   StackFrame *stackFrame, unsigned long Exception);
+extern unsigned long DebuggerParserHelpRoutine(unsigned char *command, unsigned char *commandLine);
+extern unsigned long AddDebuggerCommandParser(DEBUGGER_PARSER *parser);
+extern unsigned long RemoveDebuggerCommandParser(DEBUGGER_PARSER *parser);
+
+#endif
