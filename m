Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbZLBPFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbZLBPFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZLBPFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:05:50 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41618 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZLBPFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:05:48 -0500
Message-Id: <20091202150510.757093350@szeredi.hu>
References: <20091202150454.616582634@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 02 Dec 2009 16:04:55 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Trond.Myklebust@netapp.com
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 1/4] nfs: remove unnecessary check from nfs_rename()
Content-Disposition: inline; filename=nfs_rename_remove_unnecessary_check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

VFS already checks if both source and target are directories.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/nfs/dir.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2009-12-02 13:46:12.000000000 +0100
+++ linux-2.6/fs/nfs/dir.c	2009-12-02 15:10:33.000000000 +0100
@@ -1601,13 +1601,8 @@ static int nfs_rename(struct inode *old_
 	 * silly-rename. If the silly-rename succeeds, the
 	 * copied dentry is hashed and becomes the new target.
 	 */
-	if (!new_inode)
-		goto go_ahead;
-	if (S_ISDIR(new_inode->i_mode)) {
-		error = -EISDIR;
-		if (!S_ISDIR(old_inode->i_mode))
-			goto out;
-	} else if (atomic_read(&new_dentry->d_count) > 2) {
+	if (new_inode && !S_ISDIR(new_inode->i_mode) &&
+	    atomic_read(&new_dentry->d_count) > 2) {
 		int err;
 		/* copy the target dentry's name */
 		dentry = d_alloc(new_dentry->d_parent,
@@ -1627,7 +1622,6 @@ static int nfs_rename(struct inode *old_
 			goto out;
 	}
 
-go_ahead:
 	/*
 	 * ... prune child dentries and writebacks if needed.
 	 */

-- 
