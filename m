Return-Path: <linux-kernel-owner+w=401wt.eu-S1761657AbYFES1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbYFES1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbYFES0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:26:39 -0400
Received: from smtp.movial.fi ([62.236.91.34]:51845 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507AbYFES0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:26:36 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] bfs: assorted cleanups
Date: Thu,  5 Jun 2008 21:26:36 +0300
Message-Id: <1212690397-25693-2-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1212690397-25693-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1212690397-25693-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following cleanups:

	o removing an unused variable from bfs_fill_super();
	o removing unneeded blank spaces from pointer
	  definitions.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 fs/bfs/bfs.h   |    4 ++--
 fs/bfs/inode.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 70f5d3a..d1a6cd1 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -16,8 +16,8 @@ struct bfs_sb_info {
 	unsigned long si_freei;
 	unsigned long si_lf_eblk;
 	unsigned long si_lasti;
-	unsigned long * si_imap;
-	struct buffer_head * si_sbh;		/* buffer header w/superblock */
+	unsigned long *si_imap;
+	struct buffer_head *si_sbh;		/* buffer header w/superblock */
 };
 
 /*
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 8db6238..c8b3982 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -380,7 +380,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 		struct bfs_inode *di;
 		int block = (i - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
 		int off = (i - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
-		unsigned long sblock, eblock;
+		unsigned long eblock;
 
 		if (!off) {
 			brelse(bh);
@@ -399,7 +399,6 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 		set_bit(i, info->si_imap);
 		info->si_freeb -= BFS_FILEBLOCKS(di);
 
-		sblock =  le32_to_cpu(di->i_sblock);
 		eblock =  le32_to_cpu(di->i_eblock);
 		if (eblock > info->si_lf_eblk)
 			info->si_lf_eblk = eblock;
-- 
1.5.5.GIT

