Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYAZFGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYAZFGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYAZFFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:05:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47449 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYAZFFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:05:32 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 3/4] Unionfs: d_parent related locking fixes
Date: Sat, 26 Jan 2008 00:05:01 -0500
Message-Id: <12013239041257-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12013239022656-git-send-email-ezk@cs.sunysb.edu>
References: <12013239022656-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/copyup.c |    3 +--
 fs/unionfs/union.h  |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 8663224..9beac01 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -716,8 +716,7 @@ struct dentry *create_parents(struct inode *dir, struct dentry *dentry,
 		child_dentry = parent_dentry;
 
 		/* find the parent directory dentry in unionfs */
-		parent_dentry = child_dentry->d_parent;
-		dget(parent_dentry);
+		parent_dentry = dget_parent(child_dentry);
 
 		/* find out the lower_parent_dentry in the given branch */
 		lower_parent_dentry =
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index d324f83..4b4d6c9 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -487,13 +487,13 @@ extern int parse_branch_mode(const char *name, int *perms);
 /* locking helpers */
 static inline struct dentry *lock_parent(struct dentry *dentry)
 {
-	struct dentry *dir = dget(dentry->d_parent);
+	struct dentry *dir = dget_parent(dentry);
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	return dir;
 }
 static inline struct dentry *lock_parent_wh(struct dentry *dentry)
 {
-	struct dentry *dir = dget(dentry->d_parent);
+	struct dentry *dir = dget_parent(dentry);
 
 	mutex_lock_nested(&dir->d_inode->i_mutex, UNIONFS_DMUTEX_WHITEOUT);
 	return dir;
-- 
1.5.2.2

