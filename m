Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbYAXWcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbYAXWcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbYAXWcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:20 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52031 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994AbYAXWcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:19 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 2/9] bfs: coding style cleanup in fs/bfs/inode.c
Date: Fri, 25 Jan 2008 01:32:01 +0300
Message-Id: <1201213928-18183-3-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up errors found by checkpatch.pl.

Before the patch:

$ ./scripts/checkpatch.pl --file fs/bfs/inode.c  | grep total
total: 11 errors, 0 warnings, 445 lines checked

After the patch:

$ ./scripts/checkpatch.pl --file fs/bfs/inode.c  | grep total
total: 0 errors, 0 warnings, 446 lines checked

No functional changes introduced.

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 fs/bfs/inode.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 2284657..5191990 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -90,12 +90,12 @@ static void bfs_read_inode(struct inode *inode)
 static int bfs_write_inode(struct inode *inode, int unused)
 {
 	unsigned int ino = (u16)inode->i_ino;
-        unsigned long i_sblock;
+	unsigned long i_sblock;
 	struct bfs_inode *di;
 	struct buffer_head *bh;
 	int block, off;
 
-        dprintf("ino=%08x\n", ino);
+	dprintf("ino=%08x\n", ino);
 
 	if ((ino < BFS_ROOT_INO) || (ino > BFS_SB(inode->i_sb)->si_lasti)) {
 		printf("Bad inode number %s:%08x\n", inode->i_sb->s_id, ino);
@@ -128,7 +128,7 @@ static int bfs_write_inode(struct inode *inode, int unused)
 	di->i_atime = cpu_to_le32(inode->i_atime.tv_sec);
 	di->i_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
 	di->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
-        i_sblock = BFS_I(inode)->i_sblock;
+	i_sblock = BFS_I(inode)->i_sblock;
 	di->i_sblock = cpu_to_le32(i_sblock);
 	di->i_eblock = cpu_to_le32(BFS_I(inode)->i_eblock);
 	di->i_eoffset = cpu_to_le32(i_sblock * BFS_BSIZE + inode->i_size - 1);
@@ -157,7 +157,7 @@ static void bfs_delete_inode(struct inode *inode)
 		printf("invalid ino=%08lx\n", ino);
 		return;
 	}
-	
+
 	inode->i_size = 0;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 	lock_kernel();
@@ -177,13 +177,13 @@ static void bfs_delete_inode(struct inode *inode)
 	mark_buffer_dirty(bh);
 	brelse(bh);
 
-        if (bi->i_dsk_ino) {
+	if (bi->i_dsk_ino) {
 		if (bi->i_sblock)
 			info->si_freeb += bi->i_eblock + 1 - bi->i_sblock;
 		info->si_freei++;
 		clear_bit(ino, info->si_imap);
 		dump_imap("delete_inode", s);
-        }
+	}
 
 	/*
 	 * If this was the last file, make the previous block
@@ -293,7 +293,8 @@ void dump_imap(const char *prefix, struct super_block *s)
 	if (!tmpbuf)
 		return;
 	for (i = BFS_SB(s)->si_lasti; i >= 0; i--) {
-		if (i > PAGE_SIZE - 100) break;
+		if (i > PAGE_SIZE - 100)
+			break;
 		if (test_bit(i, BFS_SB(s)->si_imap))
 			strcat(tmpbuf, "1");
 		else
@@ -321,12 +322,12 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	sb_set_blocksize(s, BFS_BSIZE);
 
 	bh = sb_bread(s, 0);
-	if(!bh)
+	if (!bh)
 		goto out;
 	bfs_sb = (struct bfs_super_block *)bh->b_data;
 	if (le32_to_cpu(bfs_sb->s_magic) != BFS_MAGIC) {
 		if (!silent)
-			printf("No BFS filesystem on %s (magic=%08x)\n", 
+			printf("No BFS filesystem on %s (magic=%08x)\n",
 				s->s_id,  le32_to_cpu(bfs_sb->s_magic));
 		goto out;
 	}
@@ -395,7 +396,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 	if (!(s->s_flags & MS_RDONLY)) {
 		mark_buffer_dirty(info->si_sbh);
 		s->s_dirt = 1;
-	} 
+	}
 	dump_imap("read_super", s);
 	return 0;
 
@@ -425,7 +426,7 @@ static int __init init_bfs_fs(void)
 	int err = init_inodecache();
 	if (err)
 		goto out1;
-        err = register_filesystem(&bfs_fs_type);
+	err = register_filesystem(&bfs_fs_type);
 	if (err)
 		goto out;
 	return 0;
-- 
1.5.3

