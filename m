Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbXD0MH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbXD0MH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbXD0MH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:07:56 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:37053 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbXD0MHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:07:55 -0400
Message-Id: <20070427120545.085978086@szeredi.hu>
References: <20070427120417.110164241@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 27 Apr 2007 14:04:23 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com, kzak@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 06/10] unprivileged mounts: put declaration of put_filesystem() in fs.h
Content-Disposition: inline; filename=unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Declarations go into headers.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c	2007-04-26 13:08:34.000000000 +0200
+++ linux/fs/super.c	2007-04-26 13:46:26.000000000 +0200
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
--- linux.orig/include/linux/fs.h	2007-04-26 13:17:13.000000000 +0200
+++ linux/include/linux/fs.h	2007-04-26 13:46:26.000000000 +0200
@@ -1919,6 +1919,8 @@ extern int vfs_fstat(unsigned int, struc
 
 extern int vfs_ioctl(struct file *, unsigned int, unsigned int, unsigned long);
 
+extern void get_filesystem(struct file_system_type *fs);
+extern void put_filesystem(struct file_system_type *fs);
 extern struct file_system_type *get_fs_type(const char *name);
 extern struct super_block *get_super(struct block_device *);
 extern struct super_block *user_get_super(dev_t);

--
