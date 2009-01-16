Return-Path: <linux-kernel-owner+w=401wt.eu-S936746AbZAPSMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936746AbZAPSMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbZAPSIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:08:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:47998 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762464AbZAPSIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:08:24 -0500
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 07/11] quota: Use inode->i_blkbits to get block bits
Date: Fri, 16 Jan 2009 19:08:15 +0100
Message-Id: <1232129299-22018-8-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232129299-22018-7-git-send-email-jack@suse.cz>
References: <yes>
 <1232129299-22018-1-git-send-email-jack@suse.cz>
 <1232129299-22018-2-git-send-email-jack@suse.cz>
 <1232129299-22018-3-git-send-email-jack@suse.cz>
 <1232129299-22018-4-git-send-email-jack@suse.cz>
 <1232129299-22018-5-git-send-email-jack@suse.cz>
 <1232129299-22018-6-git-send-email-jack@suse.cz>
 <1232129299-22018-7-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mingming Cao <cmm@us.ibm.com>

Andrew has suggested to use inode->i_blkbits to get the block bits info,
rather than use super block's blockbits. That should be faster and emit
less code.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/quotaops.h |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 7369d04..69b502e 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -410,38 +410,32 @@ static inline void vfs_dq_free_space(struct inode *inode, qsize_t nr)
 
 static inline int vfs_dq_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space_nodirty(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_prealloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_prealloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_prealloc_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_prealloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
- 	return vfs_dq_alloc_space_nodirty(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_alloc_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_alloc_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+	return vfs_dq_alloc_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_reserve_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_reserve_space(inode, nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_claim_block(struct inode *inode, qsize_t nr)
 {
-	return vfs_dq_claim_space(inode,
-			nr << inode->i_blkbits);
+	return vfs_dq_claim_space(inode, nr << inode->i_blkbits);
 }
 
 static inline
@@ -452,12 +446,12 @@ void vfs_dq_release_reservation_block(struct inode *inode, qsize_t nr)
 
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline void vfs_dq_free_block(struct inode *inode, qsize_t nr)
 {
-	vfs_dq_free_space(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space(inode, nr << inode->i_blkbits);
 }
 
 /*
-- 
1.6.0.2

