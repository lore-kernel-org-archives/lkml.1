Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbZCVT1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbZCVT1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZCVT0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:26:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbZCVT0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:26:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       hch@infradead.org, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 02/12] btrfs: get rid of current_is_pdflush() in btrfs_btree_balance_dirty
Date: Sun, 22 Mar 2009 20:25:54 +0100
Message-Id: <1237749964-8343-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.12.g83676
In-Reply-To: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
References: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris says it's safe to kill.

Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/btrfs/disk-io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e18175..6ec80c0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2385,7 +2385,7 @@ void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 	unsigned long thresh = 32 * 1024 * 1024;
 	tree = &BTRFS_I(root->fs_info->btree_inode)->io_tree;
 
-	if (current_is_pdflush() || current->flags & PF_MEMALLOC)
+	if (current->flags & PF_MEMALLOC)
 		return;
 
 	num_dirty = count_range_bits(tree, &start, (u64)-1,
-- 
1.6.2.12.g83676

