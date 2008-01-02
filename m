Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYABRxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYABRxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 12:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYABRxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 12:53:20 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57784 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYABRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 12:53:19 -0500
To: jdike@addtoit.com
CC: akpm@linux-foundation.org, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: UML woes in 2.6.24-rc6-mm1
Message-Id: <E1JA7m0-0007nP-Fi@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Jan 2008 18:53:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch was needed to make UML compile in latest -mm.

But sometimes it doesn't boot and does weird things (this is a sample
with init=/bin/bash):

[    0.420000] EXT3-fs: mounted filesystem with ordered data mode.
[    0.420000] VFS: Mounted root (ext3 filesystem) readonly.
(none):/# ls
(none):/# ls -al
total 70
drwxr-xr-x 23 root root   1024 May  4  2007 .
drwxr-xr-x 23 root root   1024 May  4  2007 ..
drwxr-xr-x  2 root root   2048 Feb 18  2007 bin
drwxr-xr-x  2 root root   1024 May 16  2005 boot
[...]
(none):/# ls
Segmentation fault
(none):/# ls -l
: : No such file or directory

Miklos
----

Index: linux/arch/um/Kconfig
===================================================================
--- linux.orig/arch/um/Kconfig	2008-01-02 14:54:04.000000000 +0100
+++ linux/arch/um/Kconfig	2008-01-02 17:01:36.000000000 +0100
@@ -223,6 +223,10 @@ config KERNEL_STACK_ORDER
 
 endmenu
 
+config HZ
+	int
+	default 100
+
 source "init/Kconfig"
 
 source "drivers/block/Kconfig"
Index: linux/include/asm-um/param.h
===================================================================
--- linux.orig/include/asm-um/param.h	2007-10-09 22:31:38.000000000 +0200
+++ linux/include/asm-um/param.h	2008-01-02 17:02:31.000000000 +0100
@@ -10,7 +10,7 @@
 #define MAXHOSTNAMELEN  64      /* max length of hostname */
 
 #ifdef __KERNEL__
-#define HZ 100
+#define HZ CONFIG_HZ
 #define USER_HZ	100	   /* .. some user interfaces are in "ticks" */
 #define CLOCKS_PER_SEC (USER_HZ)  /* frequency at which times() counts */
 #endif
