Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbYAVDS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbYAVDS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbYAVDHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:07:19 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32924 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759300AbYAVDHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:07:08 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <coyli@suse.de>, Andreas Dilger <adilger@clusterfs.com>,
       Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 18/49] ext4: sync up block group descriptor with e2fsprogs.
Date: Mon, 21 Jan 2008 22:01:57 -0500
Message-Id: <1200970948-17903-19-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-18-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Coly Li <coyli@suse.de>

This patch extends bg_itable_unused of ext4 group descriptor
from 16bit into 32bit. In order to add bg_itable_unused_hi into
struct ext4_group_desc, some extra fields which are already introduced into
e2fsprogs are also added in for consistency.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 include/linux/ext4_fs.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 6ae91f4..55a376e 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -118,6 +118,11 @@ struct ext4_group_desc
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
 	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
 	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
+	__le16	bg_free_blocks_count_hi;/* Free blocks count MSB */
+	__le16	bg_free_inodes_count_hi;/* Free inodes count MSB */
+	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
+	__le16	bg_itable_unused_hi;	/* Unused inodes count MSB */
+	__u32	bg_reserved2[3];
 };
 
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
-- 
1.5.4.rc3.31.g1271-dirty

