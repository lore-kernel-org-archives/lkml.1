Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYHUDXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYHUDXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbYHUDQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:16:40 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50110 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbYHUDQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:16:09 -0400
Date: Wed, 20 Aug 2008 20:50:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808210250.m7L2obNG028349@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc4 24/27] mdb: add notify_die handler to system panic 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add notify_die handler to system panic 


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/panic.c	2008-08-18 23:39:34.000000000 -0600
+++ b/kernel/panic.c	2008-08-18 23:43:21.000000000 -0600
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
