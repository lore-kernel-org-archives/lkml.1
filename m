Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbXLWBxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbXLWBxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbXLWBxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:53:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139AbXLWBxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:53:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=fkRaZQ/aEcBD7n7+ZGFXnuy2asfWGDztVdF3/U5/3O5CIuKdT5VMN5I8xkIBV9R/FYr4FXWvYe0crp83g8l4ZV1RUaF9uKww5S8Nf9hk1a7DGrIfPf37rVMf3mcc5f/eyP/JUDTFjrxBErWXycUztNf+XxKAb6wFsAe5mSTSqqo=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 11/24] udf: convert UDF_SB_LVID macro to udf_sb_lvid function
Date: Sun, 23 Dec 2007 02:51:01 +0100
Message-Id: <1198374674-12128-12-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c |   24 ++++++++++++------------
 fs/udf/ialloc.c |    2 +-
 fs/udf/namei.c  |    4 ++--
 fs/udf/super.c  |   40 ++++++++++++++++++++--------------------
 fs/udf/udf_sb.h |    8 ++++++--
 5 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index d689d16..4c31666 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -189,8 +189,8 @@ do_more:
 			if (inode)
 				DQUOT_FREE_BLOCK(inode, 1);
 			if (udf_sb_lvid_bh(sb)) {
-				UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)] =
-					cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]) + 1);
+				udf_sb_lvid(sb)->freeSpaceTable[udf_sb_partition(sb)] =
+					cpu_to_le32(le32_to_cpu(udf_sb_lvid(sb)->freeSpaceTable[udf_sb_partition(sb)]) + 1);
 			}
 		}
 	}
@@ -262,8 +262,8 @@ repeat:
 		goto repeat;
 out:
 	if (udf_sb_lvid_bh(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - alloc_count);
+		udf_sb_lvid(sb)->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(udf_sb_lvid(sb)->freeSpaceTable[partition]) - alloc_count);
 		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 	sb->s_dirt = 1;
@@ -390,8 +390,8 @@ got_block:
 	mark_buffer_dirty(bh);
 
 	if (udf_sb_lvid_bh(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - 1);
+		udf_sb_lvid(sb)->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(udf_sb_lvid(sb)->freeSpaceTable[partition]) - 1);
 		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 	sb->s_dirt = 1;
@@ -433,8 +433,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 	if (inode)
 		DQUOT_FREE_BLOCK(inode, count);
 	if (udf_sb_lvid_bh(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]) + count);
+		udf_sb_lvid(sb)->freeSpaceTable[udf_sb_partition(sb)] =
+			cpu_to_le32(le32_to_cpu(udf_sb_lvid(sb)->freeSpaceTable[udf_sb_partition(sb)]) + count);
 		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 
@@ -671,8 +671,8 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 	brelse(epos.bh);
 
 	if (alloc_count && udf_sb_lvid_bh(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - alloc_count);
+		udf_sb_lvid(sb)->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(udf_sb_lvid(sb)->freeSpaceTable[partition]) - alloc_count);
 		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 		sb->s_dirt = 1;
 	}
@@ -772,8 +772,8 @@ static int udf_table_new_block(struct super_block *sb,
 	brelse(goal_epos.bh);
 
 	if (udf_sb_lvid_bh(sb)) {
-		UDF_SB_LVID(sb)->freeSpaceTable[partition] =
-			cpu_to_le32(le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[partition]) - 1);
+		udf_sb_lvid(sb)->freeSpaceTable[partition] =
+			cpu_to_le32(le32_to_cpu(udf_sb_lvid(sb)->freeSpaceTable[partition]) - 1);
 		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
 
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 5cfac06..ddbf1e6 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -91,7 +91,7 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 	if (udf_sb_lvid_bh(sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(sb)->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(udf_sb_lvid(sb)->logicalVolContentsUse);
 		if (S_ISDIR(mode))
 			UDF_SB_LVIDIU(sb)->numDirs =
 				cpu_to_le32(le32_to_cpu(UDF_SB_LVIDIU(sb)->numDirs) + 1);
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 4122d2b..4a18bfc 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1017,7 +1017,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 	if (udf_sb_lvid_bh(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(udf_sb_lvid(inode->i_sb)->logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
 		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
@@ -1069,7 +1069,7 @@ static int udf_link(struct dentry *old_dentry, struct inode *dir,
 	if (udf_sb_lvid_bh(inode->i_sb)) {
 		struct logicalVolHeaderDesc *lvhd;
 		uint64_t uniqueID;
-		lvhd = (struct logicalVolHeaderDesc *)(UDF_SB_LVID(inode->i_sb)->logicalVolContentsUse);
+		lvhd = (struct logicalVolHeaderDesc *)(udf_sb_lvid(inode->i_sb)->logicalVolContentsUse);
 		uniqueID = le64_to_cpu(lvhd->uniqueID);
 		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
 			cpu_to_le32(uniqueID & 0x00000000FFFFFFFFUL);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index b1f02a4..f9109c5 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1099,9 +1099,9 @@ static void udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
 	       ident == TAG_IDENT_LVID) {
 		udf_sb(sb)->s_lvid_bh = bh;
 
-		if (UDF_SB_LVID(sb)->nextIntegrityExt.extLength)
+		if (udf_sb_lvid(sb)->nextIntegrityExt.extLength)
 			udf_load_logicalvolint(sb,
-				leea_to_cpu(UDF_SB_LVID(sb)->nextIntegrityExt));
+				leea_to_cpu(udf_sb_lvid(sb)->nextIntegrityExt));
 
 		if (udf_sb_lvid_bh(sb) != bh)
 			brelse(bh);
@@ -1384,17 +1384,17 @@ static void udf_open_lvid(struct super_block *sb)
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
-		UDF_SB_LVID(sb)->integrityType = LVID_INTEGRITY_TYPE_OPEN;
+			udf_sb_lvid(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
+		udf_sb_lvid(sb)->integrityType = LVID_INTEGRITY_TYPE_OPEN;
 
-		UDF_SB_LVID(sb)->descTag.descCRC = cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-								       le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
+		udf_sb_lvid(sb)->descTag.descCRC = cpu_to_le16(udf_crc((char *)udf_sb_lvid(sb) + sizeof(tag),
+								       le16_to_cpu(udf_sb_lvid(sb)->descTag.descCRCLength), 0));
 
-		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
+		udf_sb_lvid(sb)->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
-				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-					((uint8_t *) &(UDF_SB_LVID(sb)->descTag))[i];
+				udf_sb_lvid(sb)->descTag.tagChecksum +=
+					((uint8_t *) &(udf_sb_lvid(sb)->descTag))[i];
 
 		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
@@ -1406,28 +1406,28 @@ static void udf_close_lvid(struct super_block *sb)
 	int i;
 
 	if (udf_sb_lvid_bh(sb) &&
-	    UDF_SB_LVID(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
+	    udf_sb_lvid(sb)->integrityType == LVID_INTEGRITY_TYPE_OPEN) {
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		UDF_SB_LVIDIU(sb)->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
 		if (udf_time_to_stamp(&cpu_time, CURRENT_TIME))
-			UDF_SB_LVID(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
+			udf_sb_lvid(sb)->recordingDateAndTime = cpu_to_lets(cpu_time);
 		if (UDF_MAX_WRITE_VERSION > le16_to_cpu(UDF_SB_LVIDIU(sb)->maxUDFWriteRev))
 			UDF_SB_LVIDIU(sb)->maxUDFWriteRev = cpu_to_le16(UDF_MAX_WRITE_VERSION);
 		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev))
 			UDF_SB_LVIDIU(sb)->minUDFReadRev = cpu_to_le16(UDF_SB_UDFREV(sb));
 		if (UDF_SB_UDFREV(sb) > le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev))
 			UDF_SB_LVIDIU(sb)->minUDFWriteRev = cpu_to_le16(UDF_SB_UDFREV(sb));
-		UDF_SB_LVID(sb)->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
+		udf_sb_lvid(sb)->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
-		UDF_SB_LVID(sb)->descTag.descCRC =
-			cpu_to_le16(udf_crc((char *)UDF_SB_LVID(sb) + sizeof(tag),
-					    le16_to_cpu(UDF_SB_LVID(sb)->descTag.descCRCLength), 0));
+		udf_sb_lvid(sb)->descTag.descCRC =
+			cpu_to_le16(udf_crc((char *)udf_sb_lvid(sb) + sizeof(tag),
+					    le16_to_cpu(udf_sb_lvid(sb)->descTag.descCRCLength), 0));
 
-		UDF_SB_LVID(sb)->descTag.tagChecksum = 0;
+		udf_sb_lvid(sb)->descTag.tagChecksum = 0;
 		for (i = 0; i < 16; i++)
 			if (i != 4)
-				UDF_SB_LVID(sb)->descTag.tagChecksum +=
-					((uint8_t *)&(UDF_SB_LVID(sb)->descTag))[i];
+				udf_sb_lvid(sb)->descTag.tagChecksum +=
+					((uint8_t *)&(udf_sb_lvid(sb)->descTag))[i];
 
 		mark_buffer_dirty(udf_sb_lvid_bh(sb));
 	}
@@ -1838,8 +1838,8 @@ static unsigned int udf_count_free(struct super_block *sb)
 	unsigned int accum = 0;
 
 	if (udf_sb_lvid_bh(sb)) {
-		if (le32_to_cpu(UDF_SB_LVID(sb)->numOfPartitions) > udf_sb_partition(sb)) {
-			accum = le32_to_cpu(UDF_SB_LVID(sb)->freeSpaceTable[udf_sb_partition(sb)]);
+		if (le32_to_cpu(udf_sb_lvid(sb)->numOfPartitions) > udf_sb_partition(sb)) {
+			accum = le32_to_cpu(udf_sb_lvid(sb)->freeSpaceTable[udf_sb_partition(sb)]);
 			if (accum == 0xFFFFFFFF)
 				accum = 0;
 		}
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index dd0ba67..ac222f6 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -90,6 +90,11 @@ static inline struct buffer_head *udf_sb_lvid_bh(struct super_block *sb)
 	return udf_sb(sb)->s_lvid_bh;
 }
 
+static inline struct logicalVolIntegrityDesc *udf_sb_lvid(struct super_block *sb)
+{
+	return (struct logicalVolIntegrityDesc *)udf_sb_lvid_bh(sb)->b_data;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -154,8 +159,7 @@ static inline struct buffer_head *udf_sb_lvid_bh(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_LVID(X)				( (struct logicalVolIntegrityDesc *)udf_sb_lvid_bh(X)->b_data )
-#define UDF_SB_LVIDIU(X)			( (struct logicalVolIntegrityDescImpUse *)&(UDF_SB_LVID(X)->impUse[le32_to_cpu(UDF_SB_LVID(X)->numOfPartitions) * 2 * sizeof(uint32_t)/sizeof(uint8_t)]) )
+#define UDF_SB_LVIDIU(X)			( (struct logicalVolIntegrityDescImpUse *)&(udf_sb_lvid(X)->impUse[le32_to_cpu(udf_sb_lvid(X)->numOfPartitions) * 2 * sizeof(uint32_t)/sizeof(uint8_t)]) )
 
 #define UDF_SB_UMASK(X)				( udf_sb(X)->s_umask )
 #define UDF_SB_GID(X)				( udf_sb(X)->s_gid )
-- 
1.5.3.4

