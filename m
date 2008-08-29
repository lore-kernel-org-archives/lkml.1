Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYH2GXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYH2GXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYH2GQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:03 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59513 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYH2GPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:33 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lg9V016141@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 26/29] mdb: add notify_die handler to system panic 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add notify_die handler to system panic 


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/panic.c	2008-08-28 14:19:32.000000000 -0600
+++ b/kernel/panic.c	2008-08-28 14:20:04.000000000 -0600
@@ -21,6 +21,8 @@
 #include <linux/debug_locks.h>
 #include <linux/random.h>
 #include <linux/kallsyms.h>
+#include <linux/kdebug.h>
+
 
 int panic_on_oops;
 int tainted;
@@ -75,6 +77,13 @@
 	 */
 	preempt_disable();
 
+        /* call the notify_die handler for any resident debuggers which
+        * may be active and pass the message string.   On a software
+        * fault return at least some sort of regs for a remote debugger
+        * to look at.
+        */
+	notify_die(DIE_PANIC, buf, get_irq_regs(), 0, -1, SIGTERM);
+
 	bust_spinlocks(1);
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
