Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbYG2A25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbYG2A25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYG2A2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:28:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:8079 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYG2A2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MDqcx2sMKBB5TGDWCxlNaWsabIRSB+xgzbCOGBwcYayoUyoBPb1pM1GMMQ7HgX2rsx
         pmDMxRVoHv/xlH3mBEKlxf+4vdmcFACdAH2H9siZylHGb9dWF6Jp3MNNscO03u3zvalL
         7nALBvUNb8QP2qbF8kOYM9Kg/c8qBLz6/R1i8=
Subject: [PATCH] omfs: sparse annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 17:28:46 -0700
Message-Id: <1217291327.23389.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing cpu_to_be64 on some constant assignments.
fs/omfs/dir.c:107:16: warning: incorrect type in assignment (different base types)
fs/omfs/dir.c:107:16:    expected restricted __be64 [usertype] i_sibling
fs/omfs/dir.c:107:16:    got unsigned long long
fs/omfs/file.c:33:13: warning: incorrect type in assignment (different base types)
fs/omfs/file.c:33:13:    expected restricted __be64 [usertype] e_next
fs/omfs/file.c:33:13:    got unsigned long long
fs/omfs/file.c:36:24: warning: incorrect type in assignment (different base types)
fs/omfs/file.c:36:24:    expected restricted __be64 [usertype] e_cluster
fs/omfs/file.c:36:24:    got unsigned long long
fs/omfs/file.c:37:23: warning: incorrect type in assignment (different base types)
fs/omfs/file.c:37:23:    expected restricted __be64 [usertype] e_blocks
fs/omfs/file.c:37:23:    got unsigned long long

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/omfs/dir.c  |    2 +-
 fs/omfs/file.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/omfs/dir.c b/fs/omfs/dir.c
index 05a5bc3..c0757e9 100644
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -104,7 +104,7 @@ int omfs_make_empty(struct inode *inode, struct super_block *sb)
 
 	oi = (struct omfs_inode *) bh->b_data;
 	oi->i_head.h_self = cpu_to_be64(inode->i_ino);
-	oi->i_sibling = ~0ULL;
+	oi->i_sibling = ~cpu_to_be64(0ULL);
 
 	mark_buffer_dirty(bh);
 	brelse(bh);
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 66e01fa..7e24990 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -30,11 +30,11 @@ void omfs_make_empty_table(struct buffer_head *bh, int offset)
 {
 	struct omfs_extent *oe = (struct omfs_extent *) &bh->b_data[offset];
 
-	oe->e_next = ~0ULL;
+	oe->e_next = ~cpu_to_be64(0ULL);
 	oe->e_extent_count = cpu_to_be32(1),
 	oe->e_fill = cpu_to_be32(0x22),
-	oe->e_entry.e_cluster = ~0ULL;
-	oe->e_entry.e_blocks = ~0ULL;
+	oe->e_entry.e_cluster = ~cpu_to_be64(0ULL);
+	oe->e_entry.e_blocks = ~cpu_to_be64(0ULL);
 }
 
 int omfs_shrink_inode(struct inode *inode)
-- 
1.6.0.rc1.154.ge3fc



