Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbYAXWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbYAXWdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYAXWcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:23 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52057 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbYAXWcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:22 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 4/9] bfs: coding style cleanup in fs/bfs/dir.c
Date: Fri, 25 Jan 2008 01:32:03 +0300
Message-Id: <1201213928-18183-5-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up errors found by checkpatch.pl.

Before the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/dir.c | grep total
total: 7 errors, 1 warnings, 370 lines checked

After the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/dir.c | grep total
total: 0 errors, 1 warnings, 370 lines checked

No functional changes introduced.

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 fs/bfs/dir.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 1fd056d..5462a5b 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -72,7 +72,7 @@ static int bfs_readdir(struct file *f, void *dirent, filldir_t filldir)
 	}
 
 	unlock_kernel();
-	return 0;	
+	return 0;
 }
 
 const struct file_operations bfs_dir_operations = {
@@ -117,7 +117,7 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	BFS_I(inode)->i_sblock = 0;
 	BFS_I(inode)->i_eblock = 0;
 	insert_inode_hash(inode);
-        mark_inode_dirty(inode);
+	mark_inode_dirty(inode);
 	dump_imap("create", s);
 
 	err = bfs_add_entry(dir, dentry->d_name.name, dentry->d_name.len,
@@ -228,8 +228,8 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -EINVAL;
 
 	lock_kernel();
-	old_bh = bfs_find_entry(old_dir, 
-				old_dentry->d_name.name, 
+	old_bh = bfs_find_entry(old_dir,
+				old_dentry->d_name.name,
 				old_dentry->d_name.len, &old_de);
 
 	if (!old_bh || (le16_to_cpu(old_de->ino) != old_inode->i_ino))
@@ -237,8 +237,8 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	error = -EPERM;
 	new_inode = new_dentry->d_inode;
-	new_bh = bfs_find_entry(new_dir, 
-				new_dentry->d_name.name, 
+	new_bh = bfs_find_entry(new_dir,
+				new_dentry->d_name.name,
 				new_dentry->d_name.len, &new_de);
 
 	if (new_bh && !new_inode) {
@@ -246,7 +246,7 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		new_bh = NULL;
 	}
 	if (!new_bh) {
-		error = bfs_add_entry(new_dir, 
+		error = bfs_add_entry(new_dir,
 					new_dentry->d_name.name,
 					new_dentry->d_name.len,
 					old_inode->i_ino);
-- 
1.5.3

