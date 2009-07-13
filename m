Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbZGMUsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbZGMUsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbZGMUse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:48:34 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42661 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbZGMUsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:48:33 -0400
Date: Mon, 13 Jul 2009 22:48:31 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/4] fs/btrfs: adjust NULL test
Message-ID: <Pine.LNX.4.64.0907132244330.12374@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Move the call to BUG_ON to before the dereference of the tested value.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
expression x,E,E1;
identifier f,l;
position p1,p2;
@@

*x@p1->f = E1;
... when != x = E
    when != goto l;
(
*x@p2 == NULL
|
*x@p2 != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/inode.c                    |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7ffa3d3..8cc6025 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2604,8 +2604,8 @@ noinline int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	if (root->ref_cows)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 	path = btrfs_alloc_path();
-	path->reada = -1;
 	BUG_ON(!path);
+	path->reada = -1;
 
 	/* FIXME, add redo link to tree so we don't leak on crash */
 	key.objectid = inode->i_ino;
