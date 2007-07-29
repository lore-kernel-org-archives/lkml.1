Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXG2PQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXG2PQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765346AbXG2PC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:02:29 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47903 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764272AbXG2PC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:02:27 -0400
Date: Sun, 29 Jul 2007 17:02:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: dwmw2@infradead.org
Cc: jffs-dev@axis.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove fs/jffs2/ioctl.c
Message-ID: <20070729150204.GR16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/jffs2/ioctl.c is already for so long in the "might be used later" 
state that I doubt it will ever be actually used...

And if it will ever be used, reverting this patch will be trivial.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/jffs2/Makefile   |    2 +-
 fs/jffs2/dir.c      |    1 -
 fs/jffs2/file.c     |    1 -
 fs/jffs2/ioctl.c    |   21 ---------------------
 fs/jffs2/os-linux.h |    3 ---
 5 files changed, 1 insertion(+), 27 deletions(-)

--- linux-2.6.14-rc5-mm1-full/fs/jffs2/os-linux.h.old	2005-11-01 20:28:24.000000000 +0100
+++ linux-2.6.14-rc5-mm1-full/fs/jffs2/os-linux.h	2005-11-01 20:28:31.000000000 +0100
@@ -147,9 +147,6 @@
 int jffs2_fsync(struct file *, struct dentry *, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
 
-/* ioctl.c */
-int jffs2_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
-
 /* symlink.c */
 extern struct inode_operations jffs2_symlink_inode_operations;
 
--- linux-2.6.14-rc5-mm1-full/fs/jffs2/dir.c.old	2005-11-01 20:28:39.000000000 +0100
+++ linux-2.6.14-rc5-mm1-full/fs/jffs2/dir.c	2005-11-01 20:28:43.000000000 +0100
@@ -41,7 +41,6 @@
 {
 	.read =		generic_read_dir,
 	.readdir =	jffs2_readdir,
-	.ioctl =	jffs2_ioctl,
 	.fsync =	jffs2_fsync
 };
 
--- linux-2.6.14-rc5-mm1-full/fs/jffs2/Makefile.old	2005-11-01 20:31:23.000000000 +0100
+++ linux-2.6.14-rc5-mm1-full/fs/jffs2/Makefile	2005-11-01 20:31:41.000000000 +0100
@@ -6,7 +6,7 @@
 
 obj-$(CONFIG_JFFS2_FS) += jffs2.o
 
-jffs2-y	:= compr.o dir.o file.o ioctl.o nodelist.o malloc.o
+jffs2-y	:= compr.o dir.o file.o nodelist.o malloc.o
 jffs2-y	+= read.o nodemgmt.o readinode.o write.o scan.o gc.o
 jffs2-y	+= symlink.o build.o erase.o background.o fs.o writev.o
 jffs2-y	+= super.o
--- linux-2.6.19-rc6-mm1/fs/jffs2/file.c.old	2006-11-26 05:55:29.000000000 +0100
+++ linux-2.6.19-rc6-mm1/fs/jffs2/file.c	2006-11-26 05:53:06.000000000 +0100
@@ -46,5 +46,4 @@
  	.write =	do_sync_write,
  	.aio_write =	generic_file_aio_write,
-	.ioctl =	jffs2_ioctl,
 	.mmap =		generic_file_readonly_mmap,
 	.fsync =	jffs2_fsync,

--- linux-2.6.23-rc1-mm1/fs/jffs2/ioctl.c	2007-07-09 01:32:17.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,21 +0,0 @@
-/*
- * JFFS2 -- Journalling Flash File System, Version 2.
- *
- * Copyright © 2001-2007 Red Hat, Inc.
- *
- * Created by David Woodhouse <dwmw2@infradead.org>
- *
- * For licensing information, see the file 'LICENCE' in this directory.
- *
- */
-
-#include <linux/fs.h>
-
-int jffs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		unsigned long arg)
-{
-	/* Later, this will provide for lsattr.jffs2 and chattr.jffs2, which
-	   will include compression support etc. */
-	return -ENOTTY;
-}
-
