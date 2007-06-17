Return-Path: <linux-kernel-owner+w=401wt.eu-S1761818AbXFQXmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818AbXFQXmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760180AbXFQXm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:42:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37887 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759734AbXFQXm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:42:28 -0400
Date: Mon, 18 Jun 2007 01:42:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for proc_nr_files()
Message-ID: <20070617234242.GB3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for proc_nr_files() in 
include/linux/fs.h

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/fs.h |    5 +++++
 kernel/sysctl.c    |    4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc4-mm2/include/linux/fs.h.old	2007-06-17 03:50:01.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/fs.h	2007-06-17 03:56:37.000000000 +0200
@@ -302,6 +302,7 @@
 #include <linux/init.h>
 #include <linux/pid.h>
 #include <linux/mutex.h>
+#include <linux/sysctl.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -2116,5 +2117,9 @@
 { }
 #endif	/* CONFIG_SECURITY */
 
+int proc_nr_files(ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos);
+
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
--- linux-2.6.22-rc4-mm2/kernel/sysctl.c.old	2007-06-17 03:51:37.000000000 +0200
+++ linux-2.6.22-rc4-mm2/kernel/sysctl.c	2007-06-17 03:51:51.000000000 +0200
@@ -47,13 +47,11 @@
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
+#include <linux/fs.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 
-extern int proc_nr_files(ctl_table *table, int write, struct file *filp,
-                     void __user *buffer, size_t *lenp, loff_t *ppos);
-
 #ifdef CONFIG_X86
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>

