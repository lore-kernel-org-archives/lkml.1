Return-Path: <linux-kernel-owner+w=401wt.eu-S1760440AbYAVDHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440AbYAVDHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758664AbYAVDE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:04:56 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65212 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758642AbYAVDEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:04:55 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 09/49] ext4: Rename i_file_acl to i_file_acl_lo
Date: Mon, 21 Jan 2008 22:01:48 -0500
Message-Id: <1200970948-17903-10-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-9-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Rename i_file_acl to i_file_acl_lo. This helps
in finding bugs where we use i_file_acl instead
of the combined i_file_acl_lo and i_file_acl_high

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c         |    4 ++--
 include/linux/ext4_fs.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 76ceba2..7bcec18 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2718,7 +2718,7 @@ void ext4_read_inode(struct inode * inode)
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
-	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
+	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl_lo);
 	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
 	    cpu_to_le32(EXT4_OS_HURD))
 		ei->i_file_acl |=
@@ -2866,7 +2866,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	    cpu_to_le32(EXT4_OS_HURD))
 		raw_inode->i_file_acl_high =
 			cpu_to_le16(ei->i_file_acl >> 32);
-	raw_inode->i_file_acl = cpu_to_le32(ei->i_file_acl);
+	raw_inode->i_file_acl_lo = cpu_to_le32(ei->i_file_acl);
 	if (!S_ISREG(inode->i_mode)) {
 		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
 	} else {
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 1a27433..6894f36 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -297,7 +297,7 @@ struct ext4_inode {
 	} osd1;				/* OS dependent 1 */
 	__le32	i_block[EXT4_N_BLOCKS];/* Pointers to blocks */
 	__le32	i_generation;	/* File version (for NFS) */
-	__le32	i_file_acl;	/* File ACL */
+	__le32	i_file_acl_lo;	/* File ACL */
 	__le32	i_dir_acl;	/* Directory ACL */
 	__le32	i_obso_faddr;	/* Obsoleted fragment address */
 	union {
-- 
1.5.4.rc3.31.g1271-dirty

