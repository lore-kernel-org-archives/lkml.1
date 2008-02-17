Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYBQDDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYBQDDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbYBQC6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:58:42 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36371 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690AbYBQC6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:58:33 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 15/17] Unionfs: embed a struct path into struct nameidata instead of nd dentrymnt
Date: Sat, 16 Feb 2008 21:57:24 -0500
Message-Id: <1203217053591-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 2e791fd..640969d 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -254,8 +254,8 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 
 	/* save the dentry & vfsmnt from namei */
 	if (nd) {
-		path_save.dentry = nd->dentry;
-		path_save.mnt = nd->mnt;
+		path_save.dentry = nd->path.dentry;
+		path_save.mnt = nd->path.mnt;
 	}
 
 	/*
@@ -266,8 +266,8 @@ static struct dentry *unionfs_lookup(struct inode *parent,
 
 	/* restore the dentry & vfsmnt in namei */
 	if (nd) {
-		nd->dentry = path_save.dentry;
-		nd->mnt = path_save.mnt;
+		nd->path.dentry = path_save.dentry;
+		nd->path.mnt = path_save.mnt;
 	}
 	if (!IS_ERR(ret)) {
 		if (ret)
@@ -885,7 +885,7 @@ static int unionfs_permission(struct inode *inode, int mask,
 	const int write_mask = (mask & MAY_WRITE) && !(mask & MAY_READ);
 
 	if (nd)
-		unionfs_lock_dentry(nd->dentry, UNIONFS_DMUTEX_CHILD);
+		unionfs_lock_dentry(nd->path.dentry, UNIONFS_DMUTEX_CHILD);
 
 	if (!UNIONFS_I(inode)->lower_inodes) {
 		if (is_file)	/* dirs can be unlinked but chdir'ed to */
@@ -960,7 +960,7 @@ out:
 	unionfs_check_inode(inode);
 	unionfs_check_nd(nd);
 	if (nd)
-		unionfs_unlock_dentry(nd->dentry);
+		unionfs_unlock_dentry(nd->path.dentry);
 	return err;
 }
 
-- 
1.5.2.2

