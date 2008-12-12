Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYLLFWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYLLFWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbYLLFVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:21:39 -0500
Received: from sh.osrg.net ([192.16.179.4]:37945 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757925AbYLLFVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:21:37 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Joern Engel <joern@logfs.org>
Subject: [PATCH mmotm 4/5] nilfs2: insert explanations in gcinode file
Date: Fri, 12 Dec 2008 14:17:00 +0900
Message-Id: <1229059021-9538-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1229059021-9538-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1229059021-9538-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1229059021-9538-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file gcinode.c gives buffer cache functions for on-disk blocks
moved in garbage collection.  Joern Engel has suggested inserting its
explanations in the source file (Message-ID:
<20080917144146.GD8750@logfs.org> and
<20080917224953.GB14644@logfs.org>).

This follows the comment.

Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/gcinode.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 0013952..77615aa 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -1,5 +1,5 @@
 /*
- * gcinode.c - NILFS memory inode for GC
+ * gcinode.c - dummy inodes to buffer blocks for garbage collection
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
@@ -22,6 +22,25 @@
  * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
  *
  */
+/*
+ * This file adds the cache of on-disk blocks to be moved in garbage
+ * collection.  The disk blocks are held with dummy inodes (called
+ * gcinodes), and this file provides lookup function of the dummy
+ * inodes and their buffer read function.
+ *
+ * Since NILFS2 keeps up multiple checkpoints/snapshots accross GC, it
+ * has to treat blocks that belong to a same file but have different
+ * checkpoint numbers.  To avoid interference among generations, dummy
+ * inodes are managed separatly from actual inodes, and their lookup
+ * function (nilfs_gc_iget) is designed to be specified with a
+ * checkpoint number argument as well as an inode number.
+ *
+ * Buffers and pages held by the dummy inodes will be released each
+ * time after they are copied to a new log.  Dirty blocks made on the
+ * current generation and the blocks to be moved by GC never overlap
+ * because the dirty blocks make a new generation; they rather must be
+ * written individually.
+ */
 
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
-- 
1.5.6.5

