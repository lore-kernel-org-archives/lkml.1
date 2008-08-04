Return-Path: <linux-kernel-owner+w=401wt.eu-S1761082AbYHDGxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082AbYHDGxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759602AbYHDGxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:53:31 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48667 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357AbYHDGxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:53:30 -0400
Message-ID: <37454.166.70.238.45.1217831585.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:33:05 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 9/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
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

--- a/debug/mdb-ia32.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb-ia32.h	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,175 @@
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
+*   FILE     :  MDB-IA32.H
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#ifndef _MDB_IA32_H
+#define _MDB_IA32_H
+
+typedef struct _StackFrame {
+   ULONG tReserved[7];
+   ULONG *tCR3;
+   ULONG tEIP;
+   ULONG tSystemFlags;
+   ULONG tEAX;
+   ULONG tECX;
+   ULONG tEDX;
+   ULONG tEBX;
+   ULONG tESP;
+   ULONG tEBP;
+   ULONG tESI;
+   ULONG tEDI;
+   WORD tES;
+   WORD Res1;
+   WORD tCS;
+   WORD Res2;
+   WORD tSS;
+   WORD Res3;
+   WORD tDS;
+   WORD Res4;
+   WORD tFS;
+   WORD Res5;
+   WORD tGS;
+   WORD Res6;
+   WORD tLDT;
+   WORD Res7;
+   ULONG tIOMap;
+} StackFrame;
+
+//  128 bytes total size numeric register context
+
+typedef struct _NPXREG {
+  WORD sig0;        //  10 bytes total size this structure
+  WORD sig1;
+  WORD sig2;
+  WORD sig3;
+  WORD exponent:15;
+  WORD sign:1;
+} NUMERIC_REGISTER_CONTEXT;
+
+typedef struct _NPX {
+  ULONG control;
+  ULONG status;
+  ULONG tag;
+  ULONG eip;
+  ULONG cs;
+  ULONG dataptr;
+  ULONG datasel;
+  NUMERIC_REGISTER_CONTEXT reg[8];    // 80 bytes
+  ULONG pad[5];
+} NUMERIC_FRAME;
+
+//  128 bytes total size register context
+
+typedef struct _CONTEXT_FRAME {
+    WORD cBackLink;
+    WORD cTSSReserved;
+    ULONG cESP0;
+    WORD cSS0;
+    WORD cSS0res;
+    ULONG cESP1;
+    WORD cSS1;
+    WORD cSS1res;
+    ULONG cESP2;
+    WORD cSS2;
+    WORD cSS2res;
+    ULONG cCR3;
+    ULONG cEIP;
+    ULONG cSystemFlags;
+    ULONG cEAX;
+    ULONG cECX;
+    ULONG cEDX;
+    ULONG cEBX;
+    ULONG cESP;
+    ULONG cEBP;
+    ULONG cESI;
+    ULONG cEDI;
+    ULONG cES;
+    ULONG cCS;
+    ULONG cSS;
+    ULONG cDS;
+    ULONG cFS;
+    ULONG cGS;
+    ULONG cLDT;
+    ULONG cIOPermissMap;
+    ULONG pad[6];
+} CONTEXT_FRAME;
+
+static inline void _cli(void)
+{
+	__asm__ __volatile__("cli" : : : "memory");
+}
+
+static inline void _sti(void)
+{
+	__asm__ __volatile__("sti" : : : "memory");
+}
+
+static inline unsigned long get_flags(void)
+{
+	unsigned long flags;
+
+	__asm__ __volatile__(
+		"pushfl ; popl %0"
+		: "=g" (flags)
+		: /* no input */
+	);
+	return flags;
+}
+
+static inline unsigned long save_flags(void)
+{
+	unsigned long flags;
+
+	__asm__ __volatile__(
+		"pushfl ; popl %0"
+		: "=g" (flags)
+		: /* no input */
+	);
+	__asm__ __volatile__("cli" : : : "memory");
+	return flags;
+}
+
+static inline void restore_flags(unsigned long flags)
+{
+	__asm__ __volatile__(
+		"pushl %0 ; popfl"
+		:
+		:"g" (flags)
+		:"memory", "cc"
+	);
+}
+
+#endif
+


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



