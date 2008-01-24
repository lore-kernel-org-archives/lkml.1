Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYAXWck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYAXWck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYAXWcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:19 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52027 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbYAXWcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:18 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 1/9] bfs: remove a useless variable
Date: Fri, 25 Jan 2008 01:32:00 +0300
Message-Id: <1201213928-18183-2-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the bfs_fill_super() routine, the "sblock" variable is declared
and assigned a value. However, this value is never used. This trivial
patch removes this useless variable.

This was compile-tested by building the bfs driver both as a module
and as a part of the kernel proper. Both build finished successfully.

Run time test was performed using a BFS image and verifying that the
filesystem remained functional after the change.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 fs/bfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index a64a71d..2284657 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -368,7 +368,7 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 		struct bfs_inode *di;
 		int block = (i - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
 		int off = (i - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
-		unsigned long sblock, eblock;
+		unsigned long eblock;
 
 		if (!off) {
 			brelse(bh);
@@ -387,7 +387,6 @@ static int bfs_fill_super(struct super_block *s, void *data, int silent)
 		set_bit(i, info->si_imap);
 		info->si_freeb -= BFS_FILEBLOCKS(di);
 
-		sblock =  le32_to_cpu(di->i_sblock);
 		eblock =  le32_to_cpu(di->i_eblock);
 		if (eblock > info->si_lf_eblk)
 			info->si_lf_eblk = eblock;
-- 
1.5.3

