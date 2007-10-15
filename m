Return-Path: <linux-kernel-owner+w=401wt.eu-S1764715AbXJOPQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764715AbXJOPQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbXJOPPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:15:53 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47879 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729AbXJOPPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:15:52 -0400
Message-ID: <471384A9.9010203@suse.de>
Date: Mon, 15 Oct 2007 23:18:01 +0800
From: Coly Li <coyli@suse.de>
Reply-To: coyli@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: add bg_itable_unused_hi to group descriptor
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends bg_itable_unused of ext4 group descriptor from 16bit into 32bit. In order to add
bg_itable_unused_hi into struct ext4_group_desc, some extra fields which are already introduced into
e2fsprogs are also added in for consistency.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Andreas Dilger <adilger@clusterfs.com>
Cc: Mingming Cao <cmm@us.ibm.com>
---
 include/linux/ext4_fs.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 783c6f3..6acf418 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -145,6 +145,11 @@ struct ext4_group_desc
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
Coly Li
SuSE PRC Labs
