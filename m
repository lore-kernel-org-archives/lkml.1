Return-Path: <linux-kernel-owner+w=401wt.eu-S936235AbYEURRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936235AbYEURRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbYEURPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:15:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33053 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765972AbYEURPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:15:50 -0400
Message-Id: <20080521171545.131855179@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:01 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@linux.intel.com>
Subject: [patch 03/14] hppfs: remove hppfs_permission
Content-Disposition: inline; filename=hppfs_permission_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

hppfs_permission() is equivalent to the '.permission == NULL' case.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Jeff Dike <jdike@linux.intel.com>
---
 fs/hppfs/hppfs.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6/fs/hppfs/hppfs.c
===================================================================
--- linux-2.6.orig/fs/hppfs/hppfs.c	2008-05-21 13:13:29.000000000 +0200
+++ linux-2.6/fs/hppfs/hppfs.c	2008-05-21 13:41:20.000000000 +0200
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

--
