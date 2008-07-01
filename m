Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYGAVIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYGAVIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbYGAVIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:08:01 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59807 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbYGAVIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:08:00 -0400
To: jdike@linux.intel.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch] hppfs: remove hppfs_permission
Message-Id: <E1KDn4s-0006Q2-Qb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 01 Jul 2008 23:07:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

hppfs_permission() is equivalent to the '.permission == NULL' case.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/hppfs/hppfs.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6/fs/hppfs/hppfs.c
===================================================================
--- linux-2.6.orig/fs/hppfs/hppfs.c	2008-06-09 19:16:43.000000000 +0200
+++ linux-2.6/fs/hppfs/hppfs.c	2008-06-09 21:09:56.000000000 +0200
@@ -655,20 +655,13 @@ static void *hppfs_follow_link(struct de
 	return proc_dentry->d_inode->i_op->follow_link(proc_dentry, nd);
 }
 
-int hppfs_permission(struct inode *inode, int mask, struct nameidata *nd)
-{
-	return generic_permission(inode, mask, NULL);
-}
-
 static const struct inode_operations hppfs_dir_iops = {
 	.lookup		= hppfs_lookup,
-	.permission	= hppfs_permission,
 };
 
 static const struct inode_operations hppfs_link_iops = {
 	.readlink	= hppfs_readlink,
 	.follow_link	= hppfs_follow_link,
-	.permission	= hppfs_permission,
 };
 
 static struct inode *get_inode(struct super_block *sb, struct dentry *dentry)
