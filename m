Return-Path: <linux-kernel-owner+w=401wt.eu-S939162AbXHIJaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939162AbXHIJaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939053AbXHIJ0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:43 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45790 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939045AbXHIJ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:41 -0400
Message-Id: <20070809092521.329251093@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:54 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 8/9] UML: remove unnecessary hostfs_getattr()
Content-Disposition: inline; filename=uml_hostfs_getattr_cleanup.patch
CC: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Currently hostfs_getattr() just defines the default behavior.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/hostfs/hostfs_kern.c
===================================================================
--- linux.orig/fs/hostfs/hostfs_kern.c	2007-08-09 11:01:55.000000000 +0200
+++ linux/fs/hostfs/hostfs_kern.c	2007-08-09 11:04:35.000000000 +0200
@@ -874,13 +874,6 @@ int hostfs_setattr(struct dentry *dentry
 	return inode_setattr(dentry->d_inode, attr);
 }
 
-int hostfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-	   struct kstat *stat)
-{
-	generic_fillattr(dentry->d_inode, stat);
-	return 0;
-}
-
 static const struct inode_operations hostfs_iops = {
 	.create		= hostfs_create,
 	.link		= hostfs_link,
@@ -892,7 +885,6 @@ static const struct inode_operations hos
 	.rename		= hostfs_rename,
 	.permission	= hostfs_permission,
 	.setattr	= hostfs_setattr,
-	.getattr	= hostfs_getattr,
 };
 
 static const struct inode_operations hostfs_dir_iops = {
@@ -907,7 +899,6 @@ static const struct inode_operations hos
 	.rename		= hostfs_rename,
 	.permission	= hostfs_permission,
 	.setattr	= hostfs_setattr,
-	.getattr	= hostfs_getattr,
 };
 
 int hostfs_link_readpage(struct file *file, struct page *page)

--
