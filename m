Return-Path: <linux-kernel-owner+w=401wt.eu-S1030404AbXDPLJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030404AbXDPLJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030401AbXDPLIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:08:39 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:43685 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXDPLIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:08:22 -0400
Message-Id: <20070416110435.155438310@szeredi.hu>
References: <20070416110308.739051445@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 16 Apr 2007 13:03:16 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 08/10] put declaration of put_filesystem() in fs.h
Content-Disposition: inline; filename=put_filesystem_in_header.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Declarations go into headers.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c	2007-04-13 12:26:11.000000000 +0200
+++ linux/fs/super.c	2007-04-13 13:25:40.000000000 +0200
@@ -40,10 +40,6 @@
 #include <asm/uaccess.h>
 
 
-void get_filesystem(struct file_system_type *fs);
-void put_filesystem(struct file_system_type *fs);
-struct file_system_type *get_fs_type(const char *name);
-
 LIST_HEAD(super_blocks);
 DEFINE_SPINLOCK(sb_lock);
 
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-04-13 13:23:22.000000000 +0200
+++ linux/include/linux/fs.h	2007-04-13 13:25:40.000000000 +0200
@@ -1922,6 +1922,8 @@ extern int vfs_fstat(unsigned int, struc
 
 extern int vfs_ioctl(struct file *, unsigned int, unsigned int, unsigned long);
 
+extern void get_filesystem(struct file_system_type *fs);
+extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
 extern struct super_block *get_super(struct block_device *);
 extern struct super_block *user_get_super(dev_t);

--
