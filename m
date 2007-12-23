Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbXLWBu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbXLWBu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbXLWBus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:50:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXLWBuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=KCENEKlz3i9zgBgt6EOGPD19kQMSVLtjyo9TzKdqOI2sp2IotVLaHyUE6XYdsKUAlgSqGHRFyU6K/osGB0mLrcbS0uB3KYj2rgZmu35HuT27Se9deDoGvLS++6N7CmPn+ZyRts72qG6QKyua5dEnUY+H+rXT2TeeqPW1FbpQ4w8=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 03/24] udf: convert some macros to inline functions
Date: Sun, 23 Dec 2007 02:50:53 +0100
Message-Id: <1198374674-12128-4-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

macro UDF_SB_PARTMAPS -> function udf_sb_partmaps
macro UDF_SB_FREE -> function udf_sb_free

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c |   24 ++++++++++----------
 fs/udf/super.c  |   52 ++++++++++++++++++++++----------------------
 fs/udf/udf_sb.h |   65 +++++++++++++++++++++++++++++-------------------------
 3 files changed, 73 insertions(+), 68 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 8374c91..b5d09ae 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -792,19 +792,19 @@ inline void udf_free_blocks(struct super_block *sb,
 
 	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-					      UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+					      udf_sb_partmaps(sb)[partition].s_uspace.s_bitmap,
 					      bloc, offset, count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-					     UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+					     udf_sb_partmaps(sb)[partition].s_uspace.s_table,
 					     bloc, offset, count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_free_blocks(sb, inode,
-					      UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+					      udf_sb_partmaps(sb)[partition].s_fspace.s_bitmap,
 					      bloc, offset, count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_free_blocks(sb, inode,
-					     UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+					     udf_sb_partmaps(sb)[partition].s_fspace.s_table,
 					     bloc, offset, count);
 	} else {
 		return;
@@ -818,19 +818,19 @@ inline int udf_prealloc_blocks(struct super_block *sb,
 {
 	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-						  UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+						  udf_sb_partmaps(sb)[partition].s_uspace.s_bitmap,
 						  partition, first_block, block_count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-						 UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+						 udf_sb_partmaps(sb)[partition].s_uspace.s_table,
 						 partition, first_block, block_count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_prealloc_blocks(sb, inode,
-						  UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+						  udf_sb_partmaps(sb)[partition].s_fspace.s_bitmap,
 						  partition, first_block, block_count);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_prealloc_blocks(sb, inode,
-						 UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+						 udf_sb_partmaps(sb)[partition].s_fspace.s_table,
 						 partition, first_block, block_count);
 	} else {
 		return 0;
@@ -845,20 +845,20 @@ inline int udf_new_block(struct super_block *sb,
 
 	if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		ret = udf_bitmap_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_bitmap,
+					   udf_sb_partmaps(sb)[partition].s_uspace.s_bitmap,
 					   partition, goal, err);
 		return ret;
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		return udf_table_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].s_uspace.s_table,
+					   udf_sb_partmaps(sb)[partition].s_uspace.s_table,
 					   partition, goal, err);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_BITMAP) {
 		return udf_bitmap_new_block(sb, inode,
-					    UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_bitmap,
+					    udf_sb_partmaps(sb)[partition].s_fspace.s_bitmap,
 					    partition, goal, err);
 	} else if (UDF_SB_PARTFLAGS(sb, partition) & UDF_PART_FLAG_FREED_TABLE) {
 		return udf_table_new_block(sb, inode,
-					   UDF_SB_PARTMAPS(sb)[partition].s_fspace.s_table,
+					   udf_sb_partmaps(sb)[partition].s_fspace.s_table,
 					   partition, goal, err);
 	} else {
 		*err = -EIO;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 76c7dc4..2c68272 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -909,8 +909,8 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 
 	for (i = 0; i < UDF_SB_NUMPARTS(sb); i++) {
 		udf_debug("Searching map: (%d == %d)\n",
-			  UDF_SB_PARTMAPS(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
-		if (UDF_SB_PARTMAPS(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber)) {
+			  udf_sb_partmaps(sb)[i].s_partition_num, le16_to_cpu(p->partitionNumber));
+		if (udf_sb_partmaps(sb)[i].s_partition_num == le16_to_cpu(p->partitionNumber)) {
 			UDF_SB_PARTLEN(sb, i) = le32_to_cpu(p->partitionLength); /* blocks */
 			UDF_SB_PARTROOT(sb, i) = le32_to_cpu(p->partitionStartingLocation);
 			if (le32_to_cpu(p->accessType) == PD_ACCESS_TYPE_READ_ONLY)
@@ -935,26 +935,26 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 						.partitionReferenceNum = i,
 					};
 
-					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
+					udf_sb_partmaps(sb)[i].s_uspace.s_table =
 						udf_iget(sb, loc);
-					if (!UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table) {
+					if (!udf_sb_partmaps(sb)[i].s_uspace.s_table) {
 						udf_debug("cannot load unallocSpaceTable (part %d)\n", i);
 						return 1;
 					}
 					UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_UNALLOC_TABLE;
 					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
-						  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
+						  i, udf_sb_partmaps(sb)[i].s_uspace.s_table->i_ino);
 				}
 				if (phd->unallocSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap != NULL) {
-						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extLength =
+					if (udf_sb_partmaps(sb)[i].s_uspace.s_bitmap != NULL) {
+						udf_sb_partmaps(sb)[i].s_uspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
-						UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition =
+						udf_sb_partmaps(sb)[i].s_uspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->unallocSpaceBitmap.extPosition);
 						UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_UNALLOC_BITMAP;
 						udf_debug("unallocSpaceBitmap (part %d) @ %d\n",
-							  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_bitmap->s_extPosition);
+							  i, udf_sb_partmaps(sb)[i].s_uspace.s_bitmap->s_extPosition);
 					}
 				}
 				if (phd->partitionIntegrityTable.extLength)
@@ -965,26 +965,26 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 						.partitionReferenceNum = i,
 					};
 
-					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
+					udf_sb_partmaps(sb)[i].s_fspace.s_table =
 						udf_iget(sb, loc);
-					if (!UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table) {
+					if (!udf_sb_partmaps(sb)[i].s_fspace.s_table) {
 						udf_debug("cannot load freedSpaceTable (part %d)\n", i);
 						return 1;
 					}
 					UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_FREED_TABLE;
 					udf_debug("freedSpaceTable (part %d) @ %ld\n",
-						  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
+						  i, udf_sb_partmaps(sb)[i].s_fspace.s_table->i_ino);
 				}
 				if (phd->freedSpaceBitmap.extLength) {
 					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
-					if (UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap != NULL) {
-						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extLength =
+					if (udf_sb_partmaps(sb)[i].s_fspace.s_bitmap != NULL) {
+						udf_sb_partmaps(sb)[i].s_fspace.s_bitmap->s_extLength =
 							le32_to_cpu(phd->freedSpaceBitmap.extLength);
-						UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition =
+						udf_sb_partmaps(sb)[i].s_fspace.s_bitmap->s_extPosition =
 							le32_to_cpu(phd->freedSpaceBitmap.extPosition);
 						UDF_SB_PARTFLAGS(sb, i) |= UDF_PART_FLAG_FREED_BITMAP;
 						udf_debug("freedSpaceBitmap (part %d) @ %d\n",
-							  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_bitmap->s_extPosition);
+							  i, udf_sb_partmaps(sb)[i].s_fspace.s_bitmap->s_extPosition);
 					}
 				}
 			}
@@ -1613,9 +1613,9 @@ error_out:
 		iput(UDF_SB_VAT(sb));
 	if (UDF_SB_NUMPARTS(sb)) {
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
 			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
@@ -1632,7 +1632,7 @@ error_out:
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
 	brelse(UDF_SB_LVIDBH(sb));
-	UDF_SB_FREE(sb);
+	udf_sb_free(sb);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 
@@ -1688,9 +1688,9 @@ static void udf_put_super(struct super_block *sb)
 		iput(UDF_SB_VAT(sb));
 	if (UDF_SB_NUMPARTS(sb)) {
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE)
-			iput(UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+			iput(udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP)
 			UDF_SB_FREE_BITMAP(sb, UDF_SB_PARTITION(sb), s_uspace);
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
@@ -1707,7 +1707,7 @@ static void udf_put_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
 	brelse(UDF_SB_LVIDBH(sb));
-	UDF_SB_FREE(sb);
+	udf_sb_free(sb);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
@@ -1850,22 +1850,22 @@ static unsigned int udf_count_free(struct super_block *sb)
 
 	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
+					       udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_bitmap);
 	}
 	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP) {
 		accum += udf_count_free_bitmap(sb,
-					       UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
+					       udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_bitmap);
 	}
 	if (accum)
 		return accum;
 
 	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_UNALLOC_TABLE) {
 		accum += udf_count_free_table(sb,
-					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
+					      udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_uspace.s_table);
 	}
 	if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_TABLE) {
 		accum += udf_count_free_table(sb,
-					      UDF_SB_PARTMAPS(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
+					      udf_sb_partmaps(sb)[UDF_SB_PARTITION(sb)].s_fspace.s_table);
 	}
 
 	return accum;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index e3cc83b..46ddfb0 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -41,20 +41,26 @@ static inline struct udf_sb_info *udf_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-#define UDF_SB_FREE(X)\
-{\
-	if (udf_sb(X)) {\
-		kfree(UDF_SB_PARTMAPS(X));\
-		UDF_SB_PARTMAPS(X) = NULL;\
-	}\
+static inline struct udf_part_map *udf_sb_partmaps(struct super_block *sb)
+{
+	return udf_sb(sb)->s_partmaps;
+}
+
+static inline void udf_sb_free(struct super_block *sb)
+{
+	struct udf_sb_info *sb_info = udf_sb(sb);
+	if (sb_info) {
+		kfree(sb_info->s_partmaps);
+		sb_info->s_partmaps = NULL;
+	}
 }
 
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
-	UDF_SB_PARTMAPS(X) = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
-	if (UDF_SB_PARTMAPS(X) != NULL) {\
+	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
+	if (udf_sb_partmaps(X) != NULL) {\
 		UDF_SB_NUMPARTS(X) = Y;\
-		memset(UDF_SB_PARTMAPS(X), 0x00, sizeof(struct udf_part_map) * Y);\
+		memset(udf_sb_partmaps(X), 0x00, sizeof(struct udf_part_map) * Y);\
 	} else {\
 		UDF_SB_NUMPARTS(X) = 0;\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
@@ -67,14 +73,14 @@ static inline struct udf_sb_info *udf_sb(struct super_block *sb)
 		((X)->s_blocksize * 8) - 1) / ((X)->s_blocksize * 8));\
 	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
 	if (size <= PAGE_SIZE)\
-		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
+		udf_sb_partmaps(X)[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
 	else\
-		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap = vmalloc(size);\
-	if (UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap != NULL) {\
-		memset(UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap, 0x00, size);\
-		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_block_bitmap =\
-			(struct buffer_head **)(UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap + 1);\
-		UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
+		udf_sb_partmaps(X)[(Y)].Z.s_bitmap = vmalloc(size);\
+	if (udf_sb_partmaps(X)[(Y)].Z.s_bitmap != NULL) {\
+		memset(udf_sb_partmaps(X)[(Y)].Z.s_bitmap, 0x00, size);\
+		udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap =\
+			(struct buffer_head **)(udf_sb_partmaps(X)[(Y)].Z.s_bitmap + 1);\
+		udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
 	} else {\
 		udf_error(X, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);\
 	}\
@@ -90,9 +96,9 @@ static inline struct udf_sb_info *udf_sb(struct super_block *sb)
 			brelse(UDF_SB_BITMAP(X,Y,Z,i));\
 	}\
 	if (size <= PAGE_SIZE)\
-		kfree(UDF_SB_PARTMAPS(X)[Y].Z.s_bitmap);\
+		kfree(udf_sb_partmaps(X)[Y].Z.s_bitmap);\
 	else\
-		vfree(UDF_SB_PARTMAPS(X)[Y].Z.s_bitmap);\
+		vfree(udf_sb_partmaps(X)[Y].Z.s_bitmap);\
 }
 
 #define UDF_QUERY_FLAG(X,Y)			( udf_sb(X)->s_flags & ( 1 << (Y) ) )
@@ -101,18 +107,17 @@ static inline struct udf_sb_info *udf_sb(struct super_block *sb)
 
 #define UDF_UPDATE_UDFREV(X,Y)			( ((Y) > UDF_SB_UDFREV(X)) ? UDF_SB_UDFREV(X) = (Y) : UDF_SB_UDFREV(X) )
 
-#define UDF_SB_PARTMAPS(X)			( udf_sb(X)->s_partmaps )
-#define UDF_SB_PARTTYPE(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_type )
-#define UDF_SB_PARTROOT(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_root )
-#define UDF_SB_PARTLEN(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_len )
-#define UDF_SB_PARTVSN(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_volumeseqnum )
-#define UDF_SB_PARTNUM(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_num )
-#define UDF_SB_TYPESPAR(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_type_specific.s_sparing )
-#define UDF_SB_TYPEVIRT(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_type_specific.s_virtual )
-#define UDF_SB_PARTFUNC(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_func )
-#define UDF_SB_PARTFLAGS(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_flags )
-#define UDF_SB_BITMAP(X,Y,Z,I)			( UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
-#define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_nr_groups )
+#define UDF_SB_PARTTYPE(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_type )
+#define UDF_SB_PARTROOT(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_root )
+#define UDF_SB_PARTLEN(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_len )
+#define UDF_SB_PARTVSN(X,Y)			( udf_sb_partmaps(X)[(Y)].s_volumeseqnum )
+#define UDF_SB_PARTNUM(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_num )
+#define UDF_SB_TYPESPAR(X,Y)			( udf_sb_partmaps(X)[(Y)].s_type_specific.s_sparing )
+#define UDF_SB_TYPEVIRT(X,Y)			( udf_sb_partmaps(X)[(Y)].s_type_specific.s_virtual )
+#define UDF_SB_PARTFUNC(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_func )
+#define UDF_SB_PARTFLAGS(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_flags )
+#define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
+#define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
 #define UDF_SB_VOLIDENT(X)			( udf_sb(X)->s_volident )
 #define UDF_SB_NUMPARTS(X)			( udf_sb(X)->s_partitions )
-- 
1.5.3.4

