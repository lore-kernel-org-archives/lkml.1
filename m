Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYB1GsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYB1GsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYB1Gpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:52 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52739 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756551AbYB1Gpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:46 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 08/12] kernel: Remove unnecessary inclusions of asm/semaphore.h
Date: Thu, 28 Feb 2008 01:33:57 -0500
Message-Id: <1204180441-8540-8-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-7-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
 <1204180441-8540-4-git-send-email-matthew@wil.cx>
 <1204180441-8540-5-git-send-email-matthew@wil.cx>
 <1204180441-8540-6-git-send-email-matthew@wil.cx>
 <1204180441-8540-7-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files use any of the functionality promised by
asm/semaphore.h.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 kernel/kexec.c        |    1 -
 kernel/kthread.c      |    1 -
 kernel/module.c       |    3 +--
 kernel/posix-timers.c |    1 -
 kernel/profile.c      |    1 -
 kernel/stop_machine.c |    1 -
 6 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 06a0e27..6782dce 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -29,7 +29,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/semaphore.h>
 #include <asm/sections.h>
 
 /* Per cpu memory for storing cpu states in case of system crash. */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 0ac8878..92dd1bc 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -13,7 +13,6 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <asm/semaphore.h>
 
 #define KTHREAD_NICE_LEVEL (-5)
 
diff --git a/kernel/module.c b/kernel/module.c
index 901cd6a..88092f7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -43,7 +43,6 @@
 #include <linux/mutex.h>
 #include <linux/unwind.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <asm/cacheflush.h>
 #include <linux/license.h>
 #include <asm/sections.h>
@@ -664,7 +663,7 @@ static void free_module(struct module *mod);
 
 static void wait_for_zero_refcount(struct module *mod)
 {
-	/* Since we might sleep for some time, drop the semaphore first */
+	/* Since we might sleep for some time, release the mutex first */
 	mutex_unlock(&module_mutex);
 	for (;;) {
 		DEBUGP("Looking at refcount...\n");
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index a9b0420..8476956 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -37,7 +37,6 @@
 #include <linux/mutex.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/compiler.h>
diff --git a/kernel/profile.c b/kernel/profile.c
index 3b7a1b0..606d738 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -23,7 +23,6 @@
 #include <linux/highmem.h>
 #include <linux/mutex.h>
 #include <asm/sections.h>
-#include <asm/semaphore.h>
 #include <asm/irq_regs.h>
 #include <asm/ptrace.h>
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 6f4e0e1..3da3c2c 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -11,7 +11,6 @@
 #include <linux/interrupt.h>
 
 #include <asm/atomic.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
 /* Since we effect priority and affinity (both of which are visible
-- 
1.5.4.1

