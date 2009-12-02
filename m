Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZLBPGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZLBPGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZLBPFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:05:39 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41615 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbZLBPFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:05:38 -0500
Message-Id: <20091202150512.430381174@szeredi.hu>
References: <20091202150454.616582634@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 02 Dec 2009 16:04:56 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Trond.Myklebust@netapp.com
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 2/4] nfs: fix comments in nfs_rename()
Content-Disposition: inline; filename=nfs_rename_fix_comments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Comments are wrong or out of date.  In particular d_drop() doesn't
free the inode it just unhashes the dentry.  And if target is a
directory then it is not checked for being busy.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2009-12-02 15:10:33.000000000 +0100
+++ linux-2.6/fs/nfs/dir.c	2009-12-02 15:10:44.000000000 +0100
@@ -1581,7 +1581,7 @@ static int nfs_rename(struct inode *old_
 
 	/*
 	 * To prevent any new references to the target during the rename,
-	 * we unhash the dentry and free the inode in advance.
+	 * we unhash the dentry in advance.
 	 */
 	if (!d_unhashed(new_dentry)) {
 		d_drop(new_dentry);
@@ -1594,12 +1594,10 @@ static int nfs_rename(struct inode *old_
 		 atomic_read(&new_dentry->d_count));
 
 	/*
-	 * First check whether the target is busy ... we can't
-	 * safely do _any_ rename if the target is in use.
-	 *
-	 * For files, make a copy of the dentry and then do a 
-	 * silly-rename. If the silly-rename succeeds, the
-	 * copied dentry is hashed and becomes the new target.
+	 * For non-directories, check whether the target is busy and if so,
+	 * make a copy of the dentry and then do a silly-rename. If the
+	 * silly-rename succeeds, the copied dentry is hashed and becomes
+	 * the new target.
 	 */
 	if (new_inode && !S_ISDIR(new_inode->i_mode) &&
 	    atomic_read(&new_dentry->d_count) > 2) {

-- 
