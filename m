Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbYAZFHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbYAZFHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYAZFFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:05:52 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47453 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYAZFFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:05:34 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/4] Unionfs: remove unnecessary call to d_iput
Date: Sat, 26 Jan 2008 00:05:00 -0500
Message-Id: <12013239031044-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12013239022656-git-send-email-ezk@cs.sunysb.edu>
References: <12013239022656-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This old code was to fix a bug which has long since been fixed in our
copyup_permission and unionfs_d_iput.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 16b2c7c..8663224 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -807,19 +807,6 @@ begin:
 						 lower_dentry);
 		unlock_dir(lower_parent_dentry);
 		if (err) {
-			struct inode *inode = lower_dentry->d_inode;
-			/*
-			 * If we get here, it means that we created a new
-			 * dentry+inode, but copying permissions failed.
-			 * Therefore, we should delete this inode and dput
-			 * the dentry so as not to leave cruft behind.
-			 */
-			if (lower_dentry->d_op && lower_dentry->d_op->d_iput)
-				lower_dentry->d_op->d_iput(lower_dentry,
-							   inode);
-			else
-				iput(inode);
-			lower_dentry->d_inode = NULL;
 			dput(lower_dentry);
 			lower_dentry = ERR_PTR(err);
 			goto out;
-- 
1.5.2.2

