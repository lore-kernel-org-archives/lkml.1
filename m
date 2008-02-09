Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYBICxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYBICxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 21:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYBICxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 21:53:23 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:21417 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYBICxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 21:53:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X5MRh9NooDMGY99HbXocFyzXI/mrxq1imZZqdCYKdW+TgqnSQFWUKaYiKAxyhO8qvqKqjm9KelMLav25ye81LUAaDWIqMcY/5EzGmUwZK7btjAG/8EnVUph7t1SP4+QvXEAnlDWnhFOd6Ems5BlnaqztFfCPe9htl0J5ev3mhdk=
Subject: [PATCH] affs: fix shadowed variable sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 18:53:19 -0800
Message-Id: <1202525599.8067.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce _tmp in the small if-blocks where this is shadowed.
fs/affs/file.c:573:8: warning: symbol 'tmp' shadows an earlier one
fs/affs/file.c:530:6: originally declared here
fs/affs/file.c:714:9: warning: symbol 'tmp' shadows an earlier one
fs/affs/file.c:661:6: originally declared here
fs/affs/file.c:746:9: warning: symbol 'tmp' shadows an earlier one
fs/affs/file.c:661:6: originally declared here

Remove declaration and assign to original variable as we are going
to return from the function at this point anyway.
fs/affs/file.c:831:7: warning: symbol 'size' shadows an earlier one
fs/affs/file.c:813:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Roman, any interest?

 fs/affs/file.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 6e0c939..ac05dc2 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -570,11 +570,11 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		bh->b_state &= ~(1UL << BH_New);
 		mark_buffer_dirty_inode(bh, inode);
 		if (prev_bh) {
-			u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-			if (tmp)
-				affs_warning(sb, "extent_file_ofs", "next block already set for %d (%d)", bidx, tmp);
+			u32 _tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+			if (_tmp)
+				affs_warning(sb, "extent_file_ofs", "next block already set for %d (%d)", bidx, _tmp);
 			AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+			affs_adjust_checksum(prev_bh, bh->b_blocknr - _tmp);
 			mark_buffer_dirty_inode(prev_bh, inode);
 			affs_brelse(prev_bh);
 		}
@@ -711,11 +711,11 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 			AFFS_DATA_HEAD(bh)->next = 0;
 			bh->b_state &= ~(1UL << BH_New);
 			if (prev_bh) {
-				u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-				if (tmp)
-					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, tmp);
+				u32 _tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+				if (_tmp)
+					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, _tmp);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+				affs_adjust_checksum(prev_bh, bh->b_blocknr - _tmp);
 				mark_buffer_dirty_inode(prev_bh, inode);
 			}
 		}
@@ -743,11 +743,11 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 			AFFS_DATA_HEAD(bh)->next = 0;
 			bh->b_state &= ~(1UL << BH_New);
 			if (prev_bh) {
-				u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-				if (tmp)
-					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, tmp);
+				u32 _tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+				if (_tmp)
+					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, _tmp);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+				affs_adjust_checksum(prev_bh, bh->b_blocknr - _tmp);
 				mark_buffer_dirty_inode(prev_bh, inode);
 			}
 		} else if (be32_to_cpu(AFFS_DATA_HEAD(bh)->size) < tmp)
@@ -828,8 +828,8 @@ affs_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		u32 size = inode->i_size;
 		int res;
+		size = inode->i_size;
 
 		res = mapping->a_ops->write_begin(NULL, mapping, size, 0, 0, &page, &fsdata);
 		if (!res)
-- 
1.5.4.1219.g65b9



