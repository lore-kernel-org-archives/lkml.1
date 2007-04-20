Return-Path: <linux-kernel-owner+w=401wt.eu-S2992859AbXDTK2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992859AbXDTK2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992831AbXDTK2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:28:18 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:56615 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423049AbXDTK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:28:07 -0400
Message-Id: <20070420102644.127221418@szeredi.hu>
References: <20070420102532.385211890@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 20 Apr 2007 12:25:38 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 6/8] put declaration of put_filesystem() in fs.h
Content-Disposition: inline; filename=put_filesystem_in_header.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Declarations go into headers.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c	2007-04-20 11:55:02.000000000 +0200
+++ linux/fs/super.c	2007-04-20 11:55:11.000000000 +0200
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
--- linux.orig/include/linux/fs.h	2007-04-20 11:55:07.000000000 +0200
+++ linux/include/linux/fs.h	2007-04-20 11:55:11.000000000 +0200
@@ -1918,6 +1918,8 @@ extern int vfs_fstat(unsigned int, struc
 
 extern int vfs_ioctl(struct file *, unsigned int, unsigned int, unsigned long);
 
+extern void get_filesystem(struct file_system_type *fs);
+extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
 extern struct super_block *get_super(struct block_device *);
 extern struct super_block *user_get_super(dev_t);

--
