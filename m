Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbXLWBui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbXLWBui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXLWBu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:50:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbXLWBuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:50:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=lJ0bgFpiw06B7IRkymnuoULPN2iTqx9wRlOKFutfQvFjj6AC2ajWX0GLeQxZHIBldaB75oJhP5ueMUb0X6TEQ9BwjgFZF19zAhFdrKN58B4BSlJBgIFHmJ9IVrulqxUPIRodyTOg7ivYbGuWaZVDPL1/lAKX0GuFX4Fx8oeIeHM=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 02/24] udf: rename UDF_SB to udf_sb
Date: Sun, 23 Dec 2007 02:50:52 +0100
Message-Id: <1198374674-12128-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename UDF_SB function to udf_sb

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/balloc.c  |   12 ++++++------
 fs/udf/ialloc.c  |    4 ++--
 fs/udf/inode.c   |    6 +++---
 fs/udf/super.c   |   32 ++++++++++++++++----------------
 fs/udf/udf_sb.h  |   42 +++++++++++++++++++++---------------------
 fs/udf/unicode.c |    4 ++--
 6 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index ab26176..8374c91 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -144,7 +144,7 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 				   kernel_lb_addr bloc, uint32_t offset,
 				   uint32_t count)
 {
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = udf_sb(sb);
 	struct buffer_head *bh = NULL;
 	unsigned long block;
 	unsigned long block_group;
@@ -214,7 +214,7 @@ static int udf_bitmap_prealloc_blocks(struct super_block *sb,
 				      uint16_t partition, uint32_t first_block,
 				      uint32_t block_count)
 {
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = udf_sb(sb);
 	int alloc_count = 0;
 	int bit, block, block_group, group_start;
 	int nr_groups, bitmap_nr;
@@ -276,7 +276,7 @@ static int udf_bitmap_new_block(struct super_block *sb,
 				struct udf_bitmap *bitmap, uint16_t partition,
 				uint32_t goal, int *err)
 {
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = udf_sb(sb);
 	int newbit, bit = 0, block, block_group, group_start;
 	int end_goal, nr_groups, bitmap_nr, i;
 	struct buffer_head *bh = NULL;
@@ -411,7 +411,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 				  kernel_lb_addr bloc, uint32_t offset,
 				  uint32_t count)
 {
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = udf_sb(sb);
 	uint32_t start, end;
 	uint32_t elen;
 	kernel_lb_addr eloc;
@@ -620,7 +620,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 				     struct inode *table, uint16_t partition,
 				     uint32_t first_block, uint32_t block_count)
 {
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = udf_sb(sb);
 	int alloc_count = 0;
 	uint32_t elen, adsize;
 	kernel_lb_addr eloc;
@@ -685,7 +685,7 @@ static int udf_table_new_block(struct super_block *sb,
 			       struct inode *table, uint16_t partition,
 			       uint32_t goal, int *err)
 {
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = udf_sb(sb);
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	uint32_t newblock = 0, adsize;
 	uint32_t elen, goal_elen = 0;
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 636d8f6..92dc9ae 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -31,7 +31,7 @@
 void udf_free_inode(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = udf_sb(sb);
 
 	/*
 	 * Note: we must free any quota before locking the superblock,
@@ -61,7 +61,7 @@ void udf_free_inode(struct inode *inode)
 struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 {
 	struct super_block *sb = dir->i_sb;
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi = udf_sb(sb);
 	struct inode *inode;
 	int block;
 	uint32_t start = UDF_I_LOCATION(dir).logicalBlockNum;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1178ae0..5afa19e 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1133,13 +1133,13 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	if (inode->i_uid == -1 ||
 	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_IGNORE) ||
 	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_UID_SET))
-		inode->i_uid = UDF_SB(inode->i_sb)->s_uid;
+		inode->i_uid = udf_sb(inode->i_sb)->s_uid;
 
 	inode->i_gid = le32_to_cpu(fe->gid);
 	if (inode->i_gid == -1 ||
 	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_IGNORE) ||
 	    UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_GID_SET))
-		inode->i_gid = UDF_SB(inode->i_sb)->s_gid;
+		inode->i_gid = udf_sb(inode->i_sb)->s_gid;
 
 	inode->i_nlink = le16_to_cpu(fe->fileLinkCount);
 	if (!inode->i_nlink)
@@ -1149,7 +1149,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	UDF_I_LENEXTENTS(inode) = inode->i_size;
 
 	inode->i_mode = udf_convert_permissions(fe);
-	inode->i_mode &= ~UDF_SB(inode->i_sb)->s_umask;
+	inode->i_mode &= ~udf_sb(inode->i_sb)->s_umask;
 
 	if (UDF_I_EFE(inode) == 0) {
 		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 57788f1..76c7dc4 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -462,18 +462,18 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 {
 	struct udf_options uopt;
 
-	uopt.flags = UDF_SB(sb)->s_flags;
-	uopt.uid   = UDF_SB(sb)->s_uid;
-	uopt.gid   = UDF_SB(sb)->s_gid;
-	uopt.umask = UDF_SB(sb)->s_umask;
+	uopt.flags = udf_sb(sb)->s_flags;
+	uopt.uid   = udf_sb(sb)->s_uid;
+	uopt.gid   = udf_sb(sb)->s_gid;
+	uopt.umask = udf_sb(sb)->s_umask;
 
 	if (!udf_parse_options(options, &uopt))
 		return -EINVAL;
 
-	UDF_SB(sb)->s_flags = uopt.flags;
-	UDF_SB(sb)->s_uid   = uopt.uid;
-	UDF_SB(sb)->s_gid   = uopt.gid;
-	UDF_SB(sb)->s_umask = uopt.umask;
+	udf_sb(sb)->s_flags = uopt.flags;
+	udf_sb(sb)->s_uid   = uopt.uid;
+	udf_sb(sb)->s_gid   = uopt.gid;
+	udf_sb(sb)->s_umask = uopt.umask;
 
 	if (UDF_SB_LVIDBH(sb)) {
 		int write_rev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFWriteRev);
@@ -1467,7 +1467,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		return -ENOMEM;
 
 	sb->s_fs_info = sbi;
-	memset(UDF_SB(sb), 0x00, sizeof(struct udf_sb_info));
+	memset(udf_sb(sb), 0x00, sizeof(struct udf_sb_info));
 
 	mutex_init(&sbi->s_alloc_mutex);
 
@@ -1495,11 +1495,11 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	fileset.logicalBlockNum = 0xFFFFFFFF;
 	fileset.partitionReferenceNum = 0xFFFF;
 
-	UDF_SB(sb)->s_flags = uopt.flags;
-	UDF_SB(sb)->s_uid = uopt.uid;
-	UDF_SB(sb)->s_gid = uopt.gid;
-	UDF_SB(sb)->s_umask = uopt.umask;
-	UDF_SB(sb)->s_nls_map = uopt.nls_map;
+	udf_sb(sb)->s_flags = uopt.flags;
+	udf_sb(sb)->s_uid = uopt.uid;
+	udf_sb(sb)->s_gid = uopt.gid;
+	udf_sb(sb)->s_umask = uopt.umask;
+	udf_sb(sb)->s_nls_map = uopt.nls_map;
 
 	/* Set the block size for all transfers */
 	if (!udf_set_blocksize(sb, uopt.blocksize))
@@ -1627,7 +1627,7 @@ error_out:
 	}
 #ifdef CONFIG_UDF_NLS
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-		unload_nls(UDF_SB(sb)->s_nls_map);
+		unload_nls(udf_sb(sb)->s_nls_map);
 #endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
@@ -1702,7 +1702,7 @@ static void udf_put_super(struct super_block *sb)
 	}
 #ifdef CONFIG_UDF_NLS
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
-		unload_nls(UDF_SB(sb)->s_nls_map);
+		unload_nls(udf_sb(sb)->s_nls_map);
 #endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 3c29820..e3cc83b 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -36,14 +36,14 @@
 #define UDF_PART_FLAG_REWRITABLE	0x0040
 #define UDF_PART_FLAG_OVERWRITABLE	0x0080
 
-static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
+static inline struct udf_sb_info *udf_sb(struct super_block *sb)
 {
 	return sb->s_fs_info;
 }
 
 #define UDF_SB_FREE(X)\
 {\
-	if (UDF_SB(X)) {\
+	if (udf_sb(X)) {\
 		kfree(UDF_SB_PARTMAPS(X));\
 		UDF_SB_PARTMAPS(X) = NULL;\
 	}\
@@ -95,13 +95,13 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
 		vfree(UDF_SB_PARTMAPS(X)[Y].Z.s_bitmap);\
 }
 
-#define UDF_QUERY_FLAG(X,Y)			( UDF_SB(X)->s_flags & ( 1 << (Y) ) )
-#define UDF_SET_FLAG(X,Y)			( UDF_SB(X)->s_flags |= ( 1 << (Y) ) )
-#define UDF_CLEAR_FLAG(X,Y)			( UDF_SB(X)->s_flags &= ~( 1 << (Y) ) )
+#define UDF_QUERY_FLAG(X,Y)			( udf_sb(X)->s_flags & ( 1 << (Y) ) )
+#define UDF_SET_FLAG(X,Y)			( udf_sb(X)->s_flags |= ( 1 << (Y) ) )
+#define UDF_CLEAR_FLAG(X,Y)			( udf_sb(X)->s_flags &= ~( 1 << (Y) ) )
 
 #define UDF_UPDATE_UDFREV(X,Y)			( ((Y) > UDF_SB_UDFREV(X)) ? UDF_SB_UDFREV(X) = (Y) : UDF_SB_UDFREV(X) )
 
-#define UDF_SB_PARTMAPS(X)			( UDF_SB(X)->s_partmaps )
+#define UDF_SB_PARTMAPS(X)			( udf_sb(X)->s_partmaps )
 #define UDF_SB_PARTTYPE(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_type )
 #define UDF_SB_PARTROOT(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_root )
 #define UDF_SB_PARTLEN(X,Y)			( UDF_SB_PARTMAPS(X)[(Y)].s_partition_len )
@@ -114,23 +114,23 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( UDF_SB_PARTMAPS(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_VOLIDENT(X)			( UDF_SB(X)->s_volident )
-#define UDF_SB_NUMPARTS(X)			( UDF_SB(X)->s_partitions )
-#define UDF_SB_PARTITION(X)			( UDF_SB(X)->s_partition )
-#define UDF_SB_SESSION(X)			( UDF_SB(X)->s_session )
-#define UDF_SB_ANCHOR(X)			( UDF_SB(X)->s_anchor )
-#define UDF_SB_LASTBLOCK(X)			( UDF_SB(X)->s_lastblock )
-#define UDF_SB_LVIDBH(X)			( UDF_SB(X)->s_lvidbh )
+#define UDF_SB_VOLIDENT(X)			( udf_sb(X)->s_volident )
+#define UDF_SB_NUMPARTS(X)			( udf_sb(X)->s_partitions )
+#define UDF_SB_PARTITION(X)			( udf_sb(X)->s_partition )
+#define UDF_SB_SESSION(X)			( udf_sb(X)->s_session )
+#define UDF_SB_ANCHOR(X)			( udf_sb(X)->s_anchor )
+#define UDF_SB_LASTBLOCK(X)			( udf_sb(X)->s_lastblock )
+#define UDF_SB_LVIDBH(X)			( udf_sb(X)->s_lvidbh )
 #define UDF_SB_LVID(X)				( (struct logicalVolIntegrityDesc *)UDF_SB_LVIDBH(X)->b_data )
 #define UDF_SB_LVIDIU(X)			( (struct logicalVolIntegrityDescImpUse *)&(UDF_SB_LVID(X)->impUse[le32_to_cpu(UDF_SB_LVID(X)->numOfPartitions) * 2 * sizeof(uint32_t)/sizeof(uint8_t)]) )
 
-#define UDF_SB_UMASK(X)				( UDF_SB(X)->s_umask )
-#define UDF_SB_GID(X)				( UDF_SB(X)->s_gid )
-#define UDF_SB_UID(X)				( UDF_SB(X)->s_uid )
-#define UDF_SB_RECORDTIME(X)			( UDF_SB(X)->s_recordtime )
-#define UDF_SB_SERIALNUM(X)			( UDF_SB(X)->s_serialnum )
-#define UDF_SB_UDFREV(X)			( UDF_SB(X)->s_udfrev )
-#define UDF_SB_FLAGS(X)				( UDF_SB(X)->s_flags )
-#define UDF_SB_VAT(X)				( UDF_SB(X)->s_vat )
+#define UDF_SB_UMASK(X)				( udf_sb(X)->s_umask )
+#define UDF_SB_GID(X)				( udf_sb(X)->s_gid )
+#define UDF_SB_UID(X)				( udf_sb(X)->s_uid )
+#define UDF_SB_RECORDTIME(X)			( udf_sb(X)->s_recordtime )
+#define UDF_SB_SERIALNUM(X)			( udf_sb(X)->s_serialnum )
+#define UDF_SB_UDFREV(X)			( udf_sb(X)->s_udfrev )
+#define UDF_SB_FLAGS(X)				( udf_sb(X)->s_flags )
+#define UDF_SB_VAT(X)				( udf_sb(X)->s_vat )
 
 #endif /* __LINUX_UDF_SB_H */
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 9e6099c..a050727 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -340,7 +340,7 @@ int udf_get_filename(struct super_block *sb, uint8_t *sname, uint8_t *dname,
 			return 0;
 		}
 	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename, &unifilename)) {
+		if (!udf_CS0toNLS(udf_sb(sb)->s_nls_map, &filename, &unifilename)) {
 			udf_debug("Failed in udf_get_filename: sname = %s\n", sname);
 			return 0;
 		}
@@ -373,7 +373,7 @@ int udf_put_filename(struct super_block *sb, const uint8_t *sname,
 			return 0;
 		}
 	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		namelen = udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname, &unifilename, UDF_NAME_LEN);
+		namelen = udf_NLStoCS0(udf_sb(sb)->s_nls_map, dname, &unifilename, UDF_NAME_LEN);
 		if (!namelen) {
 			return 0;
 		}
-- 
1.5.3.4

