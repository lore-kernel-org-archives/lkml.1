Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbYAXWen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbYAXWen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbYAXWc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:26 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52041 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbYAXWcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:25 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 8/9] bfs: remove multiple assignments
Date: Fri, 25 Jan 2008 01:32:07 +0300
Message-Id: <1201213928-18183-9-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checkpatch.pl reported several warnings about multiple variable
assignments in the BFS driver sources. This trivial patch fixes these
warnings by giving each assignment its own line.

No functional changes introduced.

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 fs/bfs/dir.c   |   13 +++++++++----
 fs/bfs/file.c  |    6 ++++--
 fs/bfs/inode.c |    7 +++++--
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 2964505..94fed7a 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -104,7 +104,9 @@ static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	info->si_freei--;
 	inode->i_uid = current->fsuid;
 	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->fsgid;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_atime = CURRENT_TIME_SEC;
+	inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
 	inode->i_op = &bfs_file_inops;
 	inode->i_fop = &bfs_file_operations;
@@ -200,7 +202,8 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 	de->ino = 0;
 	mark_buffer_dirty(bh);
-	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
+	dir->i_ctime = CURRENT_TIME_SEC;
+	dir->i_mtime = CURRENT_TIME_SEC;
 	mark_inode_dirty(dir);
 	inode->i_ctime = dir->i_ctime;
 	inode_dec_link_count(inode);
@@ -220,7 +223,8 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct bfs_dirent *old_de, *new_de;
 	int error = -ENOENT;
 
-	old_bh = new_bh = NULL;
+	old_bh = NULL;
+	new_bh = NULL;
 	old_inode = old_dentry->d_inode;
 	if (S_ISDIR(old_inode->i_mode))
 		return -EINVAL;
@@ -252,7 +256,8 @@ static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	}
 	old_de->ino = 0;
-	old_dir->i_ctime = old_dir->i_mtime = CURRENT_TIME_SEC;
+	old_dir->i_ctime = CURRENT_TIME_SEC;
+	old_dir->i_mtime = CURRENT_TIME_SEC;
 	mark_inode_dirty(old_dir);
 	if (new_inode) {
 		new_inode->i_ctime = CURRENT_TIME_SEC;
diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index f32b2a2..ab2fa66 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -111,7 +111,8 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 				create, (unsigned long)block, phys);
 		map_bh(bh_result, sb, phys);
 		info->si_freeb -= phys - bi->i_eblock;
-		info->si_lf_eblk = bi->i_eblock = phys;
+		info->si_lf_eblk = phys;
+		bi->i_eblock = phys;
 		mark_inode_dirty(inode);
 		mark_buffer_dirty(sbh);
 		err = 0;
@@ -140,7 +141,8 @@ static int bfs_get_block(struct inode *inode, sector_t block,
 			create, (unsigned long)block, phys);
 	bi->i_sblock = phys;
 	phys += block;
-	info->si_lf_eblk = bi->i_eblock = phys;
+	info->si_lf_eblk = phys;
+	bi->i_eblock = phys;
 
 	/*
 	 * This assumes nothing can write the inode back while we are here
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 91d5686..7eefafb 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -157,7 +157,9 @@ static void bfs_delete_inode(struct inode *inode)
 	}
 
 	inode->i_size = 0;
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
+	inode->i_atime = CURRENT_TIME_SEC;
+	inode->i_mtime = CURRENT_TIME_SEC;
+	inode->i_ctime = CURRENT_TIME_SEC;
 	lock_kernel();
 	mark_inode_dirty(inode);
 
@@ -213,7 +215,8 @@ static int bfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_type = BFS_MAGIC;
 	buf->f_bsize = s->s_blocksize;
 	buf->f_blocks = info->si_blocks;
-	buf->f_bfree = buf->f_bavail = info->si_freeb;
+	buf->f_bfree = info->si_freeb;
+	buf->f_bavail = info->si_freeb;
 	buf->f_files = info->si_lasti + 1 - BFS_ROOT_INO;
 	buf->f_ffree = info->si_freei;
 	buf->f_fsid.val[0] = (u32)id;
-- 
1.5.3

