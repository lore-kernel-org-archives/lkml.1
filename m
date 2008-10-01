Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbYJAJ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbYJAJ4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYJAJ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:56:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44764 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYJAJ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:56:10 -0400
Date: Wed, 1 Oct 2008 12:52:24 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] udf: typedef removal
Message-ID: <Pine.LNX.4.64.0810011251170.29644@sbz-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Remove struct typedefs from fs/udf/ecma_167.h et al.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/udf/balloc.c    |   38 +++---
 fs/udf/dir.c       |    8 +-
 fs/udf/directory.c |   32 ++--
 fs/udf/ecma_167.h  |  416 ++++++++++++++++++++++++++--------------------------
 fs/udf/inode.c     |  140 +++++++++---------
 fs/udf/misc.c      |   26 ++--
 fs/udf/namei.c     |   54 ++++----
 fs/udf/osta_udf.h  |   22 ++--
 fs/udf/partition.c |    2 +-
 fs/udf/super.c     |   48 +++---
 fs/udf/truncate.c  |   24 ++--
 fs/udf/udf_i.h     |    6 +-
 fs/udf/udfdecl.h   |   36 +++---
 fs/udf/udfend.h    |   28 ++--
 fs/udf/udftime.c   |    6 +-
 15 files changed, 444 insertions(+), 442 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 1b809bd..51bc2b3 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -87,7 +87,7 @@ static int read_block_bitmap(struct super_block *sb,
 {
 	struct buffer_head *bh = NULL;
 	int retval = 0;
-	kernel_lb_addr loc;
+	struct kernel_lb_addr loc;
 
 	loc.logicalBlockNum = bitmap->s_extPosition;
 	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
@@ -156,7 +156,7 @@ static bool udf_add_free_space(struct udf_sb_info *sbi,
 static void udf_bitmap_free_blocks(struct super_block *sb,
 				   struct inode *inode,
 				   struct udf_bitmap *bitmap,
-				   kernel_lb_addr bloc, uint32_t offset,
+				   struct kernel_lb_addr bloc, uint32_t offset,
 				   uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
@@ -425,13 +425,13 @@ error_return:
 static void udf_table_free_blocks(struct super_block *sb,
 				  struct inode *inode,
 				  struct inode *table,
-				  kernel_lb_addr bloc, uint32_t offset,
+				  struct kernel_lb_addr bloc, uint32_t offset,
 				  uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	uint32_t start, end;
 	uint32_t elen;
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	struct extent_position oepos, epos;
 	int8_t etype;
 	int i;
@@ -532,8 +532,8 @@ static void udf_table_free_blocks(struct super_block *sb,
 		 */
 
 		int adsize;
-		short_ad *sad = NULL;
-		long_ad *lad = NULL;
+		struct short_ad *sad = NULL;
+		struct long_ad *lad = NULL;
 		struct allocExtDesc *aed;
 
 		eloc.logicalBlockNum = start;
@@ -541,9 +541,9 @@ static void udf_table_free_blocks(struct super_block *sb,
 			(count << sb->s_blocksize_bits);
 
 		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-			adsize = sizeof(short_ad);
+			adsize = sizeof(struct short_ad);
 		else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-			adsize = sizeof(long_ad);
+			adsize = sizeof(struct long_ad);
 		else {
 			brelse(oepos.bh);
 			brelse(epos.bh);
@@ -601,15 +601,15 @@ static void udf_table_free_blocks(struct super_block *sb,
 			if (sbi->s_udfrev >= 0x0200)
 				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED,
 					    3, 1, epos.block.logicalBlockNum,
-					    sizeof(tag));
+					    sizeof(struct tag));
 			else
 				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED,
 					    2, 1, epos.block.logicalBlockNum,
-					    sizeof(tag));
+					    sizeof(struct tag));
 
 			switch (iinfo->i_alloc_type) {
 			case ICBTAG_FLAG_AD_SHORT:
-				sad = (short_ad *)sptr;
+				sad = (struct short_ad *)sptr;
 				sad->extLength = cpu_to_le32(
 					EXT_NEXT_EXTENT_ALLOCDECS |
 					sb->s_blocksize);
@@ -617,7 +617,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 					cpu_to_le32(epos.block.logicalBlockNum);
 				break;
 			case ICBTAG_FLAG_AD_LONG:
-				lad = (long_ad *)sptr;
+				lad = (struct long_ad *)sptr;
 				lad->extLength = cpu_to_le32(
 					EXT_NEXT_EXTENT_ALLOCDECS |
 					sb->s_blocksize);
@@ -666,7 +666,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	int alloc_count = 0;
 	uint32_t elen, adsize;
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	struct extent_position epos;
 	int8_t etype = -1;
 	struct udf_inode_info *iinfo;
@@ -677,9 +677,9 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
 
 	iinfo = UDF_I(table);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(short_ad);
+		adsize = sizeof(struct short_ad);
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(long_ad);
+		adsize = sizeof(struct long_ad);
 	else
 		return 0;
 
@@ -735,7 +735,7 @@ static int udf_table_new_block(struct super_block *sb,
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	uint32_t newblock = 0, adsize;
 	uint32_t elen, goal_elen = 0;
-	kernel_lb_addr eloc, uninitialized_var(goal_eloc);
+	struct kernel_lb_addr eloc, uninitialized_var(goal_eloc);
 	struct extent_position epos, goal_epos;
 	int8_t etype;
 	struct udf_inode_info *iinfo = UDF_I(table);
@@ -743,9 +743,9 @@ static int udf_table_new_block(struct super_block *sb,
 	*err = -ENOSPC;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(short_ad);
+		adsize = sizeof(struct short_ad);
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(long_ad);
+		adsize = sizeof(struct long_ad);
 	else
 		return newblock;
 
@@ -830,7 +830,7 @@ static int udf_table_new_block(struct super_block *sb,
 
 inline void udf_free_blocks(struct super_block *sb,
 			    struct inode *inode,
-			    kernel_lb_addr bloc, uint32_t offset,
+			    struct kernel_lb_addr bloc, uint32_t offset,
 			    uint32_t count)
 {
 	uint16_t partition = bloc.partitionReferenceNum;
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 62dc270..19d3ae4 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -51,7 +51,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 	uint8_t lfi;
 	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	struct buffer_head *tmp, *bha[16];
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
 	int i, num, ret = 0;
@@ -83,10 +83,10 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-				epos.offset -= sizeof(short_ad);
+				epos.offset -= sizeof(struct short_ad);
 			else if (iinfo->i_alloc_type ==
 					ICBTAG_FLAG_AD_LONG)
-				epos.offset -= sizeof(long_ad);
+				epos.offset -= sizeof(struct long_ad);
 		} else {
 			offset = 0;
 		}
@@ -161,7 +161,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 			memcpy(fname, "..", flen);
 			dt_type = DT_DIR;
 		} else {
-			kernel_lb_addr tloc = lelb_to_cpu(cfi.icb.extLocation);
+			struct kernel_lb_addr tloc = lelb_to_cpu(cfi.icb.extLocation);
 
 			iblock = udf_get_lb_pblock(dir->i_sb, tloc, 0);
 			flen = udf_get_filename(dir->i_sb, nameptr, fname, lfi);
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 2820f8f..0ab251d 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -20,7 +20,7 @@
 
 #if 0
 static uint8_t *udf_filead_read(struct inode *dir, uint8_t *tmpad,
-				uint8_t ad_size, kernel_lb_addr fe_loc,
+				uint8_t ad_size, struct kernel_lb_addr fe_loc,
 				int *pos, int *offset, struct buffer_head **bh,
 				int *error)
 {
@@ -75,7 +75,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 					 struct udf_fileident_bh *fibh,
 					 struct fileIdentDesc *cfi,
 					 struct extent_position *epos,
-					 kernel_lb_addr *eloc, uint32_t *elen,
+					 struct kernel_lb_addr *eloc, uint32_t *elen,
 					 sector_t *offset)
 {
 	struct fileIdentDesc *fi;
@@ -249,9 +249,9 @@ struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize, int *offset)
 }
 
 #if 0
-static extent_ad *udf_get_fileextent(void *buffer, int bufsize, int *offset)
+static struct extent_ad *udf_get_fileextent(void *buffer, int bufsize, int *offset)
 {
-	extent_ad *ext;
+	struct extent_ad *ext;
 	struct fileEntry *fe;
 	uint8_t *ptr;
 
@@ -274,54 +274,54 @@ static extent_ad *udf_get_fileextent(void *buffer, int bufsize, int *offset)
 	if ((*offset > 0) && (*offset < le32_to_cpu(fe->lengthAllocDescs)))
 		ptr += *offset;
 
-	ext = (extent_ad *)ptr;
+	ext = (struct extent_ad *)ptr;
 
-	*offset = *offset + sizeof(extent_ad);
+	*offset = *offset + sizeof(struct extent_ad);
 	return ext;
 }
 #endif
 
-short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, uint32_t *offset,
+struct short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, uint32_t *offset,
 			      int inc)
 {
-	short_ad *sa;
+	struct short_ad *sa;
 
 	if ((!ptr) || (!offset)) {
 		printk(KERN_ERR "udf: udf_get_fileshortad() invalidparms\n");
 		return NULL;
 	}
 
-	if ((*offset + sizeof(short_ad)) > maxoffset)
+	if ((*offset + sizeof(struct short_ad)) > maxoffset)
 		return NULL;
 	else {
-		sa = (short_ad *)ptr;
+		sa = (struct short_ad *)ptr;
 		if (sa->extLength == 0)
 			return NULL;
 	}
 
 	if (inc)
-		*offset += sizeof(short_ad);
+		*offset += sizeof(struct short_ad);
 	return sa;
 }
 
-long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, uint32_t *offset, int inc)
+struct long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, uint32_t *offset, int inc)
 {
-	long_ad *la;
+	struct long_ad *la;
 
 	if ((!ptr) || (!offset)) {
 		printk(KERN_ERR "udf: udf_get_filelongad() invalidparms\n");
 		return NULL;
 	}
 
-	if ((*offset + sizeof(long_ad)) > maxoffset)
+	if ((*offset + sizeof(struct long_ad)) > maxoffset)
 		return NULL;
 	else {
-		la = (long_ad *)ptr;
+		la = (struct long_ad *)ptr;
 		if (la->extLength == 0)
 			return NULL;
 	}
 
 	if (inc)
-		*offset += sizeof(long_ad);
+		*offset += sizeof(struct long_ad);
 	return la;
 }
diff --git a/fs/udf/ecma_167.h b/fs/udf/ecma_167.h
index a0974df..4792b77 100644
--- a/fs/udf/ecma_167.h
+++ b/fs/udf/ecma_167.h
@@ -38,10 +38,10 @@
 #define _ECMA_167_H 1
 
 /* Character set specification (ECMA 167r3 1/7.2.1) */
-typedef struct {
+struct charspec {
 	uint8_t		charSetType;
 	uint8_t		charSetInfo[63];
-} __attribute__ ((packed)) charspec;
+} __attribute__ ((packed));
 
 /* Character Set Type (ECMA 167r3 1/7.2.1.1) */
 #define CHARSPEC_TYPE_CS0		0x00	/* (1/7.2.2) */
@@ -57,7 +57,7 @@ typedef struct {
 typedef uint8_t		dstring;
 
 /* Timestamp (ECMA 167r3 1/7.3) */
-typedef struct {
+struct timestamp {
 	__le16		typeAndTimezone;
 	__le16		year;
 	uint8_t		month;
@@ -68,7 +68,7 @@ typedef struct {
 	uint8_t		centiseconds;
 	uint8_t		hundredsOfMicroseconds;
 	uint8_t		microseconds;
-} __attribute__ ((packed)) timestamp;
+} __attribute__ ((packed));
 
 /* Type and Time Zone (ECMA 167r3 1/7.3.1) */
 #define TIMESTAMP_TYPE_MASK		0xF000
@@ -78,11 +78,11 @@ typedef struct {
 #define TIMESTAMP_TIMEZONE_MASK		0x0FFF
 
 /* Entity identifier (ECMA 167r3 1/7.4) */
-typedef struct {
+struct regid {
 	uint8_t		flags;
 	uint8_t		ident[23];
 	uint8_t		identSuffix[8];
-} __attribute__ ((packed)) regid;
+} __attribute__ ((packed));
 
 /* Flags (ECMA 167r3 1/7.4.1) */
 #define ENTITYID_FLAGS_DIRTY		0x00
@@ -126,38 +126,38 @@ struct terminatingExtendedAreaDesc {
 
 /* Boot Descriptor (ECMA 167r3 2/9.4) */
 struct bootDesc {
-	uint8_t		structType;
-	uint8_t		stdIdent[VSD_STD_ID_LEN];
-	uint8_t		structVersion;
-	uint8_t		reserved1;
-	regid		archType;
-	regid		bootIdent;
-	__le32		bootExtLocation;
-	__le32		bootExtLength;
-	__le64		loadAddress;
-	__le64		startAddress;
-	timestamp	descCreationDateAndTime;
-	__le16		flags;
-	uint8_t		reserved2[32];
-	uint8_t		bootUse[1906];
+	uint8_t			structType;
+	uint8_t			stdIdent[VSD_STD_ID_LEN];
+	uint8_t			structVersion;
+	uint8_t			reserved1;
+	struct regid		archType;
+	struct regid		bootIdent;
+	__le32			bootExtLocation;
+	__le32			bootExtLength;
+	__le64			loadAddress;
+	__le64			startAddress;
+	struct timestamp	descCreationDateAndTime;
+	__le16			flags;
+	uint8_t			reserved2[32];
+	uint8_t			bootUse[1906];
 } __attribute__ ((packed));
 
 /* Flags (ECMA 167r3 2/9.4.12) */
 #define BOOT_FLAGS_ERASE		0x01
 
 /* Extent Descriptor (ECMA 167r3 3/7.1) */
-typedef struct {
+struct extent_ad {
 	__le32		extLength;
 	__le32		extLocation;
-} __attribute__ ((packed)) extent_ad;
+} __attribute__ ((packed));
 
-typedef struct {
+struct kernel_extent_ad {
 	uint32_t	extLength;
 	uint32_t	extLocation;
-} kernel_extent_ad;
+};
 
 /* Descriptor Tag (ECMA 167r3 3/7.2) */
-typedef struct {
+struct tag {
 	__le16		tagIdent;
 	__le16		descVersion;
 	uint8_t		tagChecksum;
@@ -166,7 +166,7 @@ typedef struct {
 	__le16		descCRC;
 	__le16		descCRCLength;
 	__le32		tagLocation;
-} __attribute__ ((packed)) tag;
+} __attribute__ ((packed));
 
 /* Tag Identifier (ECMA 167r3 3/7.2.1) */
 #define TAG_IDENT_PVD			0x0001
@@ -190,28 +190,28 @@ struct NSRDesc {
 
 /* Primary Volume Descriptor (ECMA 167r3 3/10.1) */
 struct primaryVolDesc {
-	tag		descTag;
-	__le32		volDescSeqNum;
-	__le32		primaryVolDescNum;
-	dstring		volIdent[32];
-	__le16		volSeqNum;
-	__le16		maxVolSeqNum;
-	__le16		interchangeLvl;
-	__le16		maxInterchangeLvl;
-	__le32		charSetList;
-	__le32		maxCharSetList;
-	dstring		volSetIdent[128];
-	charspec	descCharSet;
-	charspec	explanatoryCharSet;
-	extent_ad	volAbstract;
-	extent_ad	volCopyright;
-	regid		appIdent;
-	timestamp	recordingDateAndTime;
-	regid		impIdent;
-	uint8_t		impUse[64];
-	__le32		predecessorVolDescSeqLocation;
-	__le16		flags;
-	uint8_t		reserved[22];
+	struct tag		descTag;
+	__le32			volDescSeqNum;
+	__le32			primaryVolDescNum;
+	dstring			volIdent[32];
+	__le16			volSeqNum;
+	__le16			maxVolSeqNum;
+	__le16			interchangeLvl;
+	__le16			maxInterchangeLvl;
+	__le32			charSetList;
+	__le32			maxCharSetList;
+	dstring			volSetIdent[128];
+	struct charspec		descCharSet;
+	struct charspec		explanatoryCharSet;
+	struct extent_ad	volAbstract;
+	struct extent_ad	volCopyright;
+	struct regid		appIdent;
+	struct timestamp	recordingDateAndTime;
+	struct regid		impIdent;
+	uint8_t			impUse[64];
+	__le32			predecessorVolDescSeqLocation;
+	__le16			flags;
+	uint8_t			reserved[22];
 } __attribute__ ((packed));
 
 /* Flags (ECMA 167r3 3/10.1.21) */
@@ -219,40 +219,40 @@ struct primaryVolDesc {
 
 /* Anchor Volume Descriptor Pointer (ECMA 167r3 3/10.2) */
 struct anchorVolDescPtr {
-	tag		descTag;
-	extent_ad	mainVolDescSeqExt;
-	extent_ad	reserveVolDescSeqExt;
-	uint8_t	 	reserved[480];
+	struct tag		descTag;
+	struct extent_ad	mainVolDescSeqExt;
+	struct extent_ad	reserveVolDescSeqExt;
+	uint8_t	 		reserved[480];
 } __attribute__ ((packed));
 
 /* Volume Descriptor Pointer (ECMA 167r3 3/10.3) */
 struct volDescPtr {
-	tag		descTag;
-	__le32		volDescSeqNum;
-	extent_ad	nextVolDescSeqExt;
-	uint8_t		reserved[484];
+	struct tag		descTag;
+	__le32			volDescSeqNum;
+	struct extent_ad	nextVolDescSeqExt;
+	uint8_t			reserved[484];
 } __attribute__ ((packed));
 
 /* Implementation Use Volume Descriptor (ECMA 167r3 3/10.4) */
 struct impUseVolDesc {
-	tag		descTag;
+	struct tag	descTag;
 	__le32		volDescSeqNum;
-	regid		impIdent;
+	struct regid	impIdent;
 	uint8_t		impUse[460];
 } __attribute__ ((packed));
 
 /* Partition Descriptor (ECMA 167r3 3/10.5) */
 struct partitionDesc {
-	tag descTag;
+	struct tag descTag;
 	__le32 volDescSeqNum;
 	__le16 partitionFlags;
 	__le16 partitionNumber;
-	regid partitionContents;
+	struct regid partitionContents;
 	uint8_t partitionContentsUse[128];
 	__le32 accessType;
 	__le32 partitionStartingLocation;
 	__le32 partitionLength;
-	regid impIdent;
+	struct regid impIdent;
 	uint8_t impUse[128];
 	uint8_t reserved[156];
 } __attribute__ ((packed));
@@ -278,19 +278,19 @@ struct partitionDesc {
 
 /* Logical Volume Descriptor (ECMA 167r3 3/10.6) */
 struct logicalVolDesc {
-	tag		descTag;
-	__le32		volDescSeqNum;
-	charspec	descCharSet;
-	dstring		logicalVolIdent[128];
-	__le32		logicalBlockSize;
-	regid		domainIdent;
-	uint8_t		logicalVolContentsUse[16];
-	__le32		mapTableLength;
-	__le32		numPartitionMaps;
-	regid		impIdent;
-	uint8_t		impUse[128];
-	extent_ad	integritySeqExt;
-	uint8_t		partitionMaps[0];
+	struct tag		descTag;
+	__le32			volDescSeqNum;
+	struct charspec		descCharSet;
+	dstring			logicalVolIdent[128];
+	__le32			logicalBlockSize;
+	struct regid		domainIdent;
+	uint8_t			logicalVolContentsUse[16];
+	__le32			mapTableLength;
+	__le32			numPartitionMaps;
+	struct regid		impIdent;
+	uint8_t			impUse[128];
+	struct extent_ad	integritySeqExt;
+	uint8_t			partitionMaps[0];
 } __attribute__ ((packed));
 
 /* Generic Partition Map (ECMA 167r3 3/10.7.1) */
@@ -322,30 +322,30 @@ struct genericPartitionMap2 {
 
 /* Unallocated Space Descriptor (ECMA 167r3 3/10.8) */
 struct unallocSpaceDesc {
-	tag		descTag;
-	__le32		volDescSeqNum;
-	__le32		numAllocDescs;
-	extent_ad	allocDescs[0];
+	struct tag		descTag;
+	__le32			volDescSeqNum;
+	__le32			numAllocDescs;
+	struct extent_ad	allocDescs[0];
 } __attribute__ ((packed));
 
 /* Terminating Descriptor (ECMA 167r3 3/10.9) */
 struct terminatingDesc {
-	tag		descTag;
+	struct tag	descTag;
 	uint8_t		reserved[496];
 } __attribute__ ((packed));
 
 /* Logical Volume Integrity Descriptor (ECMA 167r3 3/10.10) */
 struct logicalVolIntegrityDesc {
-	tag		descTag;
-	timestamp	recordingDateAndTime;
-	__le32		integrityType;
-	extent_ad	nextIntegrityExt;
-	uint8_t		logicalVolContentsUse[32];
-	__le32		numOfPartitions;
-	__le32		lengthOfImpUse;
-	__le32		freeSpaceTable[0];
-	__le32		sizeTable[0];
-	uint8_t		impUse[0];
+	struct tag		descTag;
+	struct timestamp	recordingDateAndTime;
+	__le32			integrityType;
+	struct extent_ad	nextIntegrityExt;
+	uint8_t			logicalVolContentsUse[32];
+	__le32			numOfPartitions;
+	__le32			lengthOfImpUse;
+	__le32			freeSpaceTable[0];
+	__le32			sizeTable[0];
+	uint8_t			impUse[0];
 } __attribute__ ((packed));
 
 /* Integrity Type (ECMA 167r3 3/10.10.3) */
@@ -353,50 +353,50 @@ struct logicalVolIntegrityDesc {
 #define LVID_INTEGRITY_TYPE_CLOSE	0x00000001
 
 /* Recorded Address (ECMA 167r3 4/7.1) */
-typedef struct {
+struct lb_addr {
 	__le32		logicalBlockNum;
 	__le16	 	partitionReferenceNum;
-} __attribute__ ((packed)) lb_addr;
+} __attribute__ ((packed));
 
 /* ... and its in-core analog */
-typedef struct {
+struct kernel_lb_addr {
 	uint32_t		logicalBlockNum;
 	uint16_t	 	partitionReferenceNum;
-} kernel_lb_addr;
+};
 
 /* Short Allocation Descriptor (ECMA 167r3 4/14.14.1) */
-typedef struct {
+struct short_ad {
         __le32		extLength;
         __le32		extPosition;
-} __attribute__ ((packed)) short_ad;
+} __attribute__ ((packed));
 
 /* Long Allocation Descriptor (ECMA 167r3 4/14.14.2) */
-typedef struct {
+struct long_ad {
 	__le32		extLength;
-	lb_addr		extLocation;
+	struct lb_addr	extLocation;
 	uint8_t		impUse[6];
-} __attribute__ ((packed)) long_ad;
+} __attribute__ ((packed));
 
-typedef struct {
-	uint32_t	extLength;
-	kernel_lb_addr	extLocation;
-	uint8_t		impUse[6];
-} kernel_long_ad;
+struct kernel_long_ad {
+	uint32_t		extLength;
+	struct kernel_lb_addr	extLocation;
+	uint8_t			impUse[6];
+};
 
 /* Extended Allocation Descriptor (ECMA 167r3 4/14.14.3) */
-typedef struct {
+struct ext_ad {
 	__le32		extLength;
 	__le32		recordedLength;
 	__le32		informationLength;
-	lb_addr		extLocation;
-} __attribute__ ((packed)) ext_ad;
+	struct lb_addr	extLocation;
+} __attribute__ ((packed));
 
-typedef struct {
-	uint32_t	extLength;
-	uint32_t	recordedLength;
-	uint32_t	informationLength;
-	kernel_lb_addr	extLocation;
-} kernel_ext_ad;
+struct kernel_ext_ad {
+	uint32_t		extLength;
+	uint32_t		recordedLength;
+	uint32_t		informationLength;
+	struct kernel_lb_addr	extLocation;
+};
 
 /* Descriptor Tag (ECMA 167r3 4/7.2 - See 3/7.2) */
 
@@ -415,44 +415,44 @@ typedef struct {
 
 /* File Set Descriptor (ECMA 167r3 4/14.1) */
 struct fileSetDesc {
-	tag		descTag;
-	timestamp	recordingDateAndTime;
-	__le16		interchangeLvl;
-	__le16		maxInterchangeLvl;
-	__le32		charSetList;
-	__le32		maxCharSetList;
-	__le32		fileSetNum;
-	__le32		fileSetDescNum;
-	charspec	logicalVolIdentCharSet;
-	dstring		logicalVolIdent[128];
-	charspec	fileSetCharSet;
-	dstring		fileSetIdent[32];
-	dstring		copyrightFileIdent[32];
-	dstring		abstractFileIdent[32];
-	long_ad		rootDirectoryICB;
-	regid		domainIdent;
-	long_ad		nextExt;
-	long_ad		streamDirectoryICB;
-	uint8_t		reserved[32];
+	struct tag		descTag;
+	struct timestamp	recordingDateAndTime;
+	__le16			interchangeLvl;
+	__le16			maxInterchangeLvl;
+	__le32			charSetList;
+	__le32			maxCharSetList;
+	__le32			fileSetNum;
+	__le32			fileSetDescNum;
+	struct charspec		logicalVolIdentCharSet;
+	dstring			logicalVolIdent[128];
+	struct charspec		fileSetCharSet;
+	dstring			fileSetIdent[32];
+	dstring			copyrightFileIdent[32];
+	dstring			abstractFileIdent[32];
+	struct long_ad		rootDirectoryICB;
+	struct regid		domainIdent;
+	struct long_ad		nextExt;
+	struct long_ad		streamDirectoryICB;
+	uint8_t			reserved[32];
 } __attribute__ ((packed));
 
 /* Partition Header Descriptor (ECMA 167r3 4/14.3) */
 struct partitionHeaderDesc {
-	short_ad	unallocSpaceTable;
-	short_ad	unallocSpaceBitmap;
-	short_ad	partitionIntegrityTable;
-	short_ad	freedSpaceTable;
-	short_ad	freedSpaceBitmap;
+	struct short_ad	unallocSpaceTable;
+	struct short_ad	unallocSpaceBitmap;
+	struct short_ad	partitionIntegrityTable;
+	struct short_ad	freedSpaceTable;
+	struct short_ad	freedSpaceBitmap;
 	uint8_t		reserved[88];
 } __attribute__ ((packed));
 
 /* File Identifier Descriptor (ECMA 167r3 4/14.4) */
 struct fileIdentDesc {
-	tag		descTag;
+	struct tag	descTag;
 	__le16		fileVersionNum;
 	uint8_t		fileCharacteristics;
 	uint8_t		lengthFileIdent;
-	long_ad		icb;
+	struct long_ad	icb;
 	__le16		lengthOfImpUse;
 	uint8_t		impUse[0];
 	uint8_t		fileIdent[0];
@@ -468,22 +468,22 @@ struct fileIdentDesc {
 
 /* Allocation Ext Descriptor (ECMA 167r3 4/14.5) */
 struct allocExtDesc {
-	tag		descTag;
+	struct tag	descTag;
 	__le32		previousAllocExtLocation;
 	__le32		lengthAllocDescs;
 } __attribute__ ((packed));
 
 /* ICB Tag (ECMA 167r3 4/14.6) */
-typedef struct {
+struct icbtag {
 	__le32		priorRecordedNumDirectEntries;
 	__le16		strategyType;
 	__le16		strategyParameter;
 	__le16		numEntries;
 	uint8_t		reserved;
 	uint8_t		fileType;
-	lb_addr		parentICBLocation;
+	struct lb_addr	parentICBLocation;
 	__le16		flags;
-} __attribute__ ((packed)) icbtag;
+} __attribute__ ((packed));
 
 /* Strategy Type (ECMA 167r3 4/14.6.2) */
 #define ICBTAG_STRATEGY_TYPE_UNDEF	0x0000
@@ -528,41 +528,41 @@ typedef struct {
 
 /* Indirect Entry (ECMA 167r3 4/14.7) */
 struct indirectEntry {
-	tag		descTag;
-	icbtag		icbTag;
-	long_ad		indirectICB;
+	struct tag	descTag;
+	struct icbtag	icbTag;
+	struct long_ad	indirectICB;
 } __attribute__ ((packed));
 
 /* Terminal Entry (ECMA 167r3 4/14.8) */
 struct terminalEntry {
-	tag		descTag;
-	icbtag		icbTag;
+	struct tag	descTag;
+	struct icbtag	icbTag;
 } __attribute__ ((packed));
 
 /* File Entry (ECMA 167r3 4/14.9) */
 struct fileEntry {
-	tag		descTag;
-	icbtag		icbTag;
-	__le32		uid;
-	__le32		gid;
-	__le32		permissions;
-	__le16		fileLinkCount;
-	uint8_t		recordFormat;
-	uint8_t		recordDisplayAttr;
-	__le32		recordLength;
-	__le64		informationLength;
-	__le64		logicalBlocksRecorded;
-	timestamp	accessTime;
-	timestamp	modificationTime;
-	timestamp	attrTime;
-	__le32		checkpoint;
-	long_ad		extendedAttrICB;
-	regid		impIdent;
-	__le64		uniqueID;
-	__le32		lengthExtendedAttr;
-	__le32		lengthAllocDescs;
-	uint8_t		extendedAttr[0];
-	uint8_t		allocDescs[0];
+	struct tag		descTag;
+	struct icbtag		icbTag;
+	__le32			uid;
+	__le32			gid;
+	__le32			permissions;
+	__le16			fileLinkCount;
+	uint8_t			recordFormat;
+	uint8_t			recordDisplayAttr;
+	__le32			recordLength;
+	__le64			informationLength;
+	__le64			logicalBlocksRecorded;
+	struct timestamp	accessTime;
+	struct timestamp	modificationTime;
+	struct timestamp	attrTime;
+	__le32			checkpoint;
+	struct long_ad		extendedAttrICB;
+	struct regid		impIdent;
+	__le64			uniqueID;
+	__le32			lengthExtendedAttr;
+	__le32			lengthAllocDescs;
+	uint8_t			extendedAttr[0];
+	uint8_t			allocDescs[0];
 } __attribute__ ((packed));
 
 /* Permissions (ECMA 167r3 4/14.9.5) */
@@ -604,7 +604,7 @@ struct fileEntry {
 
 /* Extended Attribute Header Descriptor (ECMA 167r3 4/14.10.1) */
 struct extendedAttrHeaderDesc {
-	tag		descTag;
+	struct tag	descTag;
 	__le32		impAttrLocation;
 	__le32		appAttrLocation;
 } __attribute__ ((packed));
@@ -687,7 +687,7 @@ struct impUseExtAttr {
 	uint8_t		reserved[3];
 	__le32		attrLength;
 	__le32		impUseLength;
-	regid		impIdent;
+	struct regid	impIdent;
 	uint8_t		impUse[0];
 } __attribute__ ((packed));
 
@@ -698,7 +698,7 @@ struct appUseExtAttr {
 	uint8_t		reserved[3];
 	__le32		attrLength;
 	__le32		appUseLength;
-	regid		appIdent;
+	struct regid	appIdent;
 	uint8_t		appUse[0];
 } __attribute__ ((packed));
 
@@ -712,15 +712,15 @@ struct appUseExtAttr {
 
 /* Unallocated Space Entry (ECMA 167r3 4/14.11) */
 struct unallocSpaceEntry {
-	tag		descTag;
-	icbtag		icbTag;
+	struct tag	descTag;
+	struct icbtag	icbTag;
 	__le32		lengthAllocDescs;
 	uint8_t		allocDescs[0];
 } __attribute__ ((packed));
 
 /* Space Bitmap Descriptor (ECMA 167r3 4/14.12) */
 struct spaceBitmapDesc {
-	tag		descTag;
+	struct tag	descTag;
 	__le32		numOfBits;
 	__le32		numOfBytes;
 	uint8_t		bitmap[0];
@@ -728,13 +728,13 @@ struct spaceBitmapDesc {
 
 /* Partition Integrity Entry (ECMA 167r3 4/14.13) */
 struct partitionIntegrityEntry {
-	tag		descTag;
-	icbtag		icbTag;
-	timestamp	recordingDateAndTime;
-	uint8_t		integrityType;
-	uint8_t		reserved[175];
-	regid		impIdent;
-	uint8_t		impUse[256];
+	struct tag		descTag;
+	struct icbtag		icbTag;
+	struct timestamp	recordingDateAndTime;
+	uint8_t			integrityType;
+	uint8_t			reserved[175];
+	struct regid		impIdent;
+	uint8_t			impUse[256];
 } __attribute__ ((packed));
 
 /* Short Allocation Descriptor (ECMA 167r3 4/14.14.1) */
@@ -765,32 +765,32 @@ struct pathComponent {
 
 /* File Entry (ECMA 167r3 4/14.17) */
 struct extendedFileEntry {
-	tag		descTag;
-	icbtag		icbTag;
-	__le32		uid;
-	__le32		gid;
-	__le32		permissions;
-	__le16		fileLinkCount;
-	uint8_t		recordFormat;
-	uint8_t		recordDisplayAttr;
-	__le32		recordLength;
-	__le64		informationLength;
-	__le64		objectSize;
-	__le64		logicalBlocksRecorded;
-	timestamp	accessTime;
-	timestamp	modificationTime;
-	timestamp	createTime;
-	timestamp	attrTime;
-	__le32		checkpoint;
-	__le32		reserved;
-	long_ad		extendedAttrICB;
-	long_ad		streamDirectoryICB;
-	regid		impIdent;
-	__le64		uniqueID;
-	__le32		lengthExtendedAttr;
-	__le32		lengthAllocDescs;
-	uint8_t		extendedAttr[0];
-	uint8_t		allocDescs[0];
+	struct tag		descTag;
+	struct icbtag		icbTag;
+	__le32			uid;
+	__le32			gid;
+	__le32			permissions;
+	__le16			fileLinkCount;
+	uint8_t			recordFormat;
+	uint8_t			recordDisplayAttr;
+	__le32			recordLength;
+	__le64			informationLength;
+	__le64			objectSize;
+	__le64			logicalBlocksRecorded;
+	struct timestamp	accessTime;
+	struct timestamp	modificationTime;
+	struct timestamp	createTime;
+	struct timestamp	attrTime;
+	__le32			checkpoint;
+	__le32			reserved;
+	struct long_ad		extendedAttrICB;
+	struct long_ad		streamDirectoryICB;
+	struct regid		impIdent;
+	__le64			uniqueID;
+	__le32			lengthExtendedAttr;
+	__le32			lengthAllocDescs;
+	uint8_t			extendedAttr[0];
+	uint8_t			allocDescs[0];
 } __attribute__ ((packed));
 
 #endif /* _ECMA_167_H */
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6e74b11..3d1cbd1 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -55,15 +55,15 @@ static int udf_alloc_i_data(struct inode *inode, size_t size);
 static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
 					sector_t *, int *);
 static int8_t udf_insert_aext(struct inode *, struct extent_position,
-			      kernel_lb_addr, uint32_t);
+			      struct kernel_lb_addr, uint32_t);
 static void udf_split_extents(struct inode *, int *, int, int,
-			      kernel_long_ad[EXTENT_MERGE_SIZE], int *);
+			      struct kernel_long_ad[EXTENT_MERGE_SIZE], int *);
 static void udf_prealloc_extents(struct inode *, int, int,
-				 kernel_long_ad[EXTENT_MERGE_SIZE], int *);
+				 struct kernel_long_ad[EXTENT_MERGE_SIZE], int *);
 static void udf_merge_extents(struct inode *,
-			      kernel_long_ad[EXTENT_MERGE_SIZE], int *);
+			      struct kernel_long_ad[EXTENT_MERGE_SIZE], int *);
 static void udf_update_extents(struct inode *,
-			       kernel_long_ad[EXTENT_MERGE_SIZE], int, int,
+			       struct kernel_long_ad[EXTENT_MERGE_SIZE], int, int,
 			       struct extent_position *);
 static int udf_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
@@ -199,7 +199,7 @@ struct buffer_head *udf_expand_dir_adinicb(struct inode *inode, int *block,
 {
 	int newblock;
 	struct buffer_head *dbh = NULL;
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	uint8_t alloctype;
 	struct extent_position epos;
@@ -358,12 +358,12 @@ static struct buffer_head *udf_getblk(struct inode *inode, long block,
 
 /* Extend the file by 'blocks' blocks, return the number of extents added */
 int udf_extend_file(struct inode *inode, struct extent_position *last_pos,
-		    kernel_long_ad *last_ext, sector_t blocks)
+		    struct kernel_long_ad *last_ext, sector_t blocks)
 {
 	sector_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
-	kernel_lb_addr prealloc_loc = {};
+	struct kernel_lb_addr prealloc_loc = {};
 	int prealloc_len = 0;
 	struct udf_inode_info *iinfo;
 
@@ -458,9 +458,9 @@ out:
 
 	/* last_pos should point to the last written extent... */
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		last_pos->offset -= sizeof(short_ad);
+		last_pos->offset -= sizeof(struct short_ad);
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		last_pos->offset -= sizeof(long_ad);
+		last_pos->offset -= sizeof(struct long_ad);
 	else
 		return -1;
 
@@ -472,11 +472,11 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
 {
 	static sector_t last_block;
 	struct buffer_head *result = NULL;
-	kernel_long_ad laarr[EXTENT_MERGE_SIZE];
+	struct kernel_long_ad laarr[EXTENT_MERGE_SIZE];
 	struct extent_position prev_epos, cur_epos, next_epos;
 	int count = 0, startnum = 0, endnum = 0;
 	uint32_t elen = 0, tmpelen;
-	kernel_lb_addr eloc, tmpeloc;
+	struct kernel_lb_addr eloc, tmpeloc;
 	int c = 1;
 	loff_t lbcount = 0, b_off = 0;
 	uint32_t newblocknum, newblock;
@@ -571,7 +571,7 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
 		} else {
 			/* Create a fake extent when there's not one */
 			memset(&laarr[0].extLocation, 0x00,
-				sizeof(kernel_lb_addr));
+				sizeof(struct kernel_lb_addr));
 			laarr[0].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED;
 			/* Will udf_extend_file() create real extent from
 			   a fake one? */
@@ -601,7 +601,7 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
 			laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
 				inode->i_sb->s_blocksize;
 			memset(&laarr[c].extLocation, 0x00,
-				sizeof(kernel_lb_addr));
+				sizeof(struct kernel_lb_addr));
 			count++;
 			endnum++;
 		}
@@ -698,7 +698,7 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
 
 static void udf_split_extents(struct inode *inode, int *c, int offset,
 			      int newblocknum,
-			      kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+			      struct kernel_long_ad laarr[EXTENT_MERGE_SIZE],
 			      int *endnum)
 {
 	unsigned long blocksize = inode->i_sb->s_blocksize;
@@ -762,7 +762,7 @@ static void udf_split_extents(struct inode *inode, int *c, int offset,
 }
 
 static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
-				 kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+				 struct kernel_long_ad laarr[EXTENT_MERGE_SIZE],
 				 int *endnum)
 {
 	int start, length = 0, currlength = 0, i;
@@ -816,7 +816,7 @@ static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
 					 inode->i_sb->s_blocksize_bits);
 			else {
 				memmove(&laarr[c + 2], &laarr[c + 1],
-					sizeof(long_ad) * (*endnum - (c + 1)));
+					sizeof(struct long_ad) * (*endnum - (c + 1)));
 				(*endnum)++;
 				laarr[c + 1].extLocation.logicalBlockNum = next;
 				laarr[c + 1].extLocation.partitionReferenceNum =
@@ -845,7 +845,7 @@ static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
 					if (*endnum > (i + 1))
 						memmove(&laarr[i],
 							&laarr[i + 1],
-							sizeof(long_ad) *
+							sizeof(struct long_ad) *
 							(*endnum - (i + 1)));
 					i--;
 					(*endnum)--;
@@ -858,7 +858,7 @@ static void udf_prealloc_extents(struct inode *inode, int c, int lastblock,
 }
 
 static void udf_merge_extents(struct inode *inode,
-			      kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+			      struct kernel_long_ad laarr[EXTENT_MERGE_SIZE],
 			      int *endnum)
 {
 	int i;
@@ -866,8 +866,8 @@ static void udf_merge_extents(struct inode *inode,
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
 
 	for (i = 0; i < (*endnum - 1); i++) {
-		kernel_long_ad *li /*l[i]*/ = &laarr[i];
-		kernel_long_ad *lip1 /*l[i plus 1]*/ = &laarr[i + 1];
+		struct kernel_long_ad *li /*l[i]*/ = &laarr[i];
+		struct kernel_long_ad *lip1 /*l[i plus 1]*/ = &laarr[i + 1];
 
 		if (((li->extLength >> 30) == (lip1->extLength >> 30)) &&
 			(((li->extLength >> 30) ==
@@ -901,7 +901,7 @@ static void udf_merge_extents(struct inode *inode,
 					 blocksize - 1) & ~(blocksize - 1));
 				if (*endnum > (i + 2))
 					memmove(&laarr[i + 1], &laarr[i + 2],
-						sizeof(long_ad) *
+						sizeof(struct long_ad) *
 						(*endnum - (i + 2)));
 				i--;
 				(*endnum)--;
@@ -936,7 +936,7 @@ static void udf_merge_extents(struct inode *inode,
 					  blocksize - 1) & ~(blocksize - 1));
 				if (*endnum > (i + 2))
 					memmove(&laarr[i + 1], &laarr[i + 2],
-						sizeof(long_ad) *
+						sizeof(struct long_ad) *
 						(*endnum - (i + 2)));
 				i--;
 				(*endnum)--;
@@ -958,12 +958,12 @@ static void udf_merge_extents(struct inode *inode,
 }
 
 static void udf_update_extents(struct inode *inode,
-			       kernel_long_ad laarr[EXTENT_MERGE_SIZE],
+			       struct kernel_long_ad laarr[EXTENT_MERGE_SIZE],
 			       int startnum, int endnum,
 			       struct extent_position *epos)
 {
 	int start = 0, i;
-	kernel_lb_addr tmploc;
+	struct kernel_lb_addr tmploc;
 	uint32_t tmplen;
 
 	if (startnum > endnum) {
@@ -1101,7 +1101,7 @@ static void __udf_read_inode(struct inode *inode)
 					&ident);
 		if (ident == TAG_IDENT_IE && ibh) {
 			struct buffer_head *nbh = NULL;
-			kernel_lb_addr loc;
+			struct kernel_lb_addr loc;
 			struct indirectEntry *ie;
 
 			ie = (struct indirectEntry *)ibh->b_data;
@@ -1114,7 +1114,7 @@ static void __udf_read_inode(struct inode *inode)
 					ident == TAG_IDENT_EFE) {
 					memcpy(&iinfo->i_location,
 						&loc,
-						sizeof(kernel_lb_addr));
+						sizeof(struct kernel_lb_addr));
 					brelse(bh);
 					brelse(ibh);
 					brelse(nbh);
@@ -1415,13 +1415,13 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 		       iinfo->i_ext.i_data, inode->i_sb->s_blocksize -
 					sizeof(struct unallocSpaceEntry));
 		crclen = sizeof(struct unallocSpaceEntry) +
-				iinfo->i_lenAlloc - sizeof(tag);
+				iinfo->i_lenAlloc - sizeof(struct tag);
 		use->descTag.tagLocation = cpu_to_le32(
 						iinfo->i_location.
 							logicalBlockNum);
 		use->descTag.descCRCLength = cpu_to_le16(crclen);
 		use->descTag.descCRC = cpu_to_le16(crc_itu_t(0, (char *)use +
-							   sizeof(tag),
+							   sizeof(struct tag),
 							   crclen));
 		use->descTag.tagChecksum = udf_tag_checksum(&use->descTag);
 
@@ -1458,23 +1458,23 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	fe->informationLength = cpu_to_le64(inode->i_size);
 
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
-		regid *eid;
+		struct regid *eid;
 		struct deviceSpec *dsea =
 			(struct deviceSpec *)udf_get_extendedattr(inode, 12, 1);
 		if (!dsea) {
 			dsea = (struct deviceSpec *)
 				udf_add_extendedattr(inode,
 						     sizeof(struct deviceSpec) +
-						     sizeof(regid), 12, 0x3);
+						     sizeof(struct regid), 12, 0x3);
 			dsea->attrType = cpu_to_le32(12);
 			dsea->attrSubtype = 1;
 			dsea->attrLength = cpu_to_le32(
 						sizeof(struct deviceSpec) +
-						sizeof(regid));
-			dsea->impUseLength = cpu_to_le32(sizeof(regid));
+						sizeof(struct regid));
+			dsea->impUseLength = cpu_to_le32(sizeof(struct regid));
 		}
-		eid = (regid *)dsea->impUse;
-		memset(eid, 0, sizeof(regid));
+		eid = (struct regid *)dsea->impUse;
+		memset(eid, 0, sizeof(struct regid));
 		strcpy(eid->ident, UDF_ID_DEVELOPER);
 		eid->identSuffix[0] = UDF_OS_CLASS_UNIX;
 		eid->identSuffix[1] = UDF_OS_ID_LINUX;
@@ -1493,7 +1493,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 		udf_time_to_disk_stamp(&fe->accessTime, inode->i_atime);
 		udf_time_to_disk_stamp(&fe->modificationTime, inode->i_mtime);
 		udf_time_to_disk_stamp(&fe->attrTime, inode->i_ctime);
-		memset(&(fe->impIdent), 0, sizeof(regid));
+		memset(&(fe->impIdent), 0, sizeof(struct regid));
 		strcpy(fe->impIdent.ident, UDF_ID_DEVELOPER);
 		fe->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		fe->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
@@ -1532,7 +1532,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 		udf_time_to_disk_stamp(&efe->createTime, iinfo->i_crtime);
 		udf_time_to_disk_stamp(&efe->attrTime, inode->i_ctime);
 
-		memset(&(efe->impIdent), 0, sizeof(regid));
+		memset(&(efe->impIdent), 0, sizeof(struct regid));
 		strcpy(efe->impIdent.ident, UDF_ID_DEVELOPER);
 		efe->impIdent.identSuffix[0] = UDF_OS_CLASS_UNIX;
 		efe->impIdent.identSuffix[1] = UDF_OS_ID_LINUX;
@@ -1583,9 +1583,9 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	fe->descTag.tagLocation = cpu_to_le32(
 					iinfo->i_location.logicalBlockNum);
 	crclen += iinfo->i_lenEAttr + iinfo->i_lenAlloc -
-								sizeof(tag);
+								sizeof(struct tag);
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
-	fe->descTag.descCRC = cpu_to_le16(crc_itu_t(0, (char *)fe + sizeof(tag),
+	fe->descTag.descCRC = cpu_to_le16(crc_itu_t(0, (char *)fe + sizeof(struct tag),
 						  crclen));
 	fe->descTag.tagChecksum = udf_tag_checksum(&fe->descTag);
 
@@ -1605,7 +1605,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 	return err;
 }
 
-struct inode *udf_iget(struct super_block *sb, kernel_lb_addr ino)
+struct inode *udf_iget(struct super_block *sb, struct kernel_lb_addr ino)
 {
 	unsigned long block = udf_get_lb_pblock(sb, ino, 0);
 	struct inode *inode = iget_locked(sb, block);
@@ -1614,7 +1614,7 @@ struct inode *udf_iget(struct super_block *sb, kernel_lb_addr ino)
 		return NULL;
 
 	if (inode->i_state & I_NEW) {
-		memcpy(&UDF_I(inode)->i_location, &ino, sizeof(kernel_lb_addr));
+		memcpy(&UDF_I(inode)->i_location, &ino, sizeof(struct kernel_lb_addr));
 		__udf_read_inode(inode);
 		unlock_new_inode(inode);
 	}
@@ -1638,11 +1638,11 @@ struct inode *udf_iget(struct super_block *sb, kernel_lb_addr ino)
 }
 
 int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
-		    kernel_lb_addr eloc, uint32_t elen, int inc)
+		    struct kernel_lb_addr eloc, uint32_t elen, int inc)
 {
 	int adsize;
-	short_ad *sad = NULL;
-	long_ad *lad = NULL;
+	struct short_ad *sad = NULL;
+	struct long_ad *lad = NULL;
 	struct allocExtDesc *aed;
 	int8_t etype;
 	uint8_t *ptr;
@@ -1656,9 +1656,9 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 		ptr = epos->bh->b_data + epos->offset;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(short_ad);
+		adsize = sizeof(struct short_ad);
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(long_ad);
+		adsize = sizeof(struct long_ad);
 	else
 		return -1;
 
@@ -1666,7 +1666,7 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 		char *sptr, *dptr;
 		struct buffer_head *nbh;
 		int err, loffset;
-		kernel_lb_addr obloc = epos->block;
+		struct kernel_lb_addr obloc = epos->block;
 
 		epos->block.logicalBlockNum = udf_new_block(inode->i_sb, NULL,
 						obloc.partitionReferenceNum,
@@ -1711,20 +1711,20 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 		}
 		if (UDF_SB(inode->i_sb)->s_udfrev >= 0x0200)
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 3, 1,
-				    epos->block.logicalBlockNum, sizeof(tag));
+				    epos->block.logicalBlockNum, sizeof(struct tag));
 		else
 			udf_new_tag(nbh->b_data, TAG_IDENT_AED, 2, 1,
-				    epos->block.logicalBlockNum, sizeof(tag));
+				    epos->block.logicalBlockNum, sizeof(struct tag));
 		switch (iinfo->i_alloc_type) {
 		case ICBTAG_FLAG_AD_SHORT:
-			sad = (short_ad *)sptr;
+			sad = (struct short_ad *)sptr;
 			sad->extLength = cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
 						     inode->i_sb->s_blocksize);
 			sad->extPosition =
 				cpu_to_le32(epos->block.logicalBlockNum);
 			break;
 		case ICBTAG_FLAG_AD_LONG:
-			lad = (long_ad *)sptr;
+			lad = (struct long_ad *)sptr;
 			lad->extLength = cpu_to_le32(EXT_NEXT_EXTENT_ALLOCDECS |
 						     inode->i_sb->s_blocksize);
 			lad->extLocation = cpu_to_lelb(epos->block);
@@ -1768,12 +1768,12 @@ int8_t udf_add_aext(struct inode *inode, struct extent_position *epos,
 }
 
 int8_t udf_write_aext(struct inode *inode, struct extent_position *epos,
-		      kernel_lb_addr eloc, uint32_t elen, int inc)
+		      struct kernel_lb_addr eloc, uint32_t elen, int inc)
 {
 	int adsize;
 	uint8_t *ptr;
-	short_ad *sad;
-	long_ad *lad;
+	struct short_ad *sad;
+	struct long_ad *lad;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (!epos->bh)
@@ -1785,17 +1785,17 @@ int8_t udf_write_aext(struct inode *inode, struct extent_position *epos,
 
 	switch (iinfo->i_alloc_type) {
 	case ICBTAG_FLAG_AD_SHORT:
-		sad = (short_ad *)ptr;
+		sad = (struct short_ad *)ptr;
 		sad->extLength = cpu_to_le32(elen);
 		sad->extPosition = cpu_to_le32(eloc.logicalBlockNum);
-		adsize = sizeof(short_ad);
+		adsize = sizeof(struct short_ad);
 		break;
 	case ICBTAG_FLAG_AD_LONG:
-		lad = (long_ad *)ptr;
+		lad = (struct long_ad *)ptr;
 		lad->extLength = cpu_to_le32(elen);
 		lad->extLocation = cpu_to_lelb(eloc);
 		memset(lad->impUse, 0x00, sizeof(lad->impUse));
-		adsize = sizeof(long_ad);
+		adsize = sizeof(struct long_ad);
 		break;
 	default:
 		return -1;
@@ -1822,7 +1822,7 @@ int8_t udf_write_aext(struct inode *inode, struct extent_position *epos,
 }
 
 int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
-		     kernel_lb_addr *eloc, uint32_t *elen, int inc)
+		     struct kernel_lb_addr *eloc, uint32_t *elen, int inc)
 {
 	int8_t etype;
 
@@ -1844,13 +1844,13 @@ int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
 }
 
 int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
-			kernel_lb_addr *eloc, uint32_t *elen, int inc)
+			struct kernel_lb_addr *eloc, uint32_t *elen, int inc)
 {
 	int alen;
 	int8_t etype;
 	uint8_t *ptr;
-	short_ad *sad;
-	long_ad *lad;
+	struct short_ad *sad;
+	struct long_ad *lad;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (!epos->bh) {
@@ -1899,9 +1899,9 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
 }
 
 static int8_t udf_insert_aext(struct inode *inode, struct extent_position epos,
-			      kernel_lb_addr neloc, uint32_t nelen)
+			      struct kernel_lb_addr neloc, uint32_t nelen)
 {
-	kernel_lb_addr oeloc;
+	struct kernel_lb_addr oeloc;
 	uint32_t oelen;
 	int8_t etype;
 
@@ -1920,7 +1920,7 @@ static int8_t udf_insert_aext(struct inode *inode, struct extent_position epos,
 }
 
 int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
-		       kernel_lb_addr eloc, uint32_t elen)
+		       struct kernel_lb_addr eloc, uint32_t elen)
 {
 	struct extent_position oepos;
 	int adsize;
@@ -1935,9 +1935,9 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 
 	iinfo = UDF_I(inode);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(short_ad);
+		adsize = sizeof(struct short_ad);
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(long_ad);
+		adsize = sizeof(struct long_ad);
 	else
 		adsize = 0;
 
@@ -1955,7 +1955,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 			oepos.offset = epos.offset - adsize;
 		}
 	}
-	memset(&eloc, 0x00, sizeof(kernel_lb_addr));
+	memset(&eloc, 0x00, sizeof(struct kernel_lb_addr));
 	elen = 0;
 
 	if (epos.bh != oepos.bh) {
@@ -2003,7 +2003,7 @@ int8_t udf_delete_aext(struct inode *inode, struct extent_position epos,
 }
 
 int8_t inode_bmap(struct inode *inode, sector_t block,
-		  struct extent_position *pos, kernel_lb_addr *eloc,
+		  struct extent_position *pos, struct kernel_lb_addr *eloc,
 		  uint32_t *elen, sector_t *offset)
 {
 	unsigned char blocksize_bits = inode->i_sb->s_blocksize_bits;
@@ -2035,7 +2035,7 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
 
 long udf_block_map(struct inode *inode, sector_t block)
 {
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
 	struct extent_position epos = {};
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 84bf0fd..6e164c7 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -134,10 +134,10 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 			}
 		}
 		/* rewrite CRC + checksum of eahd */
-		crclen = sizeof(struct extendedAttrHeaderDesc) - sizeof(tag);
+		crclen = sizeof(struct extendedAttrHeaderDesc) - sizeof(struct tag);
 		eahd->descTag.descCRCLength = cpu_to_le16(crclen);
 		eahd->descTag.descCRC = cpu_to_le16(crc_itu_t(0, (char *)eahd +
-						sizeof(tag), crclen));
+						sizeof(struct tag), crclen));
 		eahd->descTag.tagChecksum = udf_tag_checksum(&eahd->descTag);
 		iinfo->i_lenEAttr += size;
 		return (struct genericFormat *)&ea[offset];
@@ -202,7 +202,7 @@ struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
 struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 				    uint32_t location, uint16_t *ident)
 {
-	tag *tag_p;
+	struct tag *tag_p;
 	struct buffer_head *bh = NULL;
 
 	/* Read the block */
@@ -216,7 +216,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 		return NULL;
 	}
 
-	tag_p = (tag *)(bh->b_data);
+	tag_p = (struct tag *)(bh->b_data);
 
 	*ident = le16_to_cpu(tag_p->tagIdent);
 
@@ -241,9 +241,9 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 	}
 
 	/* Verify the descriptor CRC */
-	if (le16_to_cpu(tag_p->descCRCLength) + sizeof(tag) > sb->s_blocksize ||
+	if (le16_to_cpu(tag_p->descCRCLength) + sizeof(struct tag) > sb->s_blocksize ||
 	    le16_to_cpu(tag_p->descCRC) == crc_itu_t(0,
-					bh->b_data + sizeof(tag),
+					bh->b_data + sizeof(struct tag),
 					le16_to_cpu(tag_p->descCRCLength)))
 		return bh;
 
@@ -255,7 +255,7 @@ error_out:
 	return NULL;
 }
 
-struct buffer_head *udf_read_ptagged(struct super_block *sb, kernel_lb_addr loc,
+struct buffer_head *udf_read_ptagged(struct super_block *sb, struct kernel_lb_addr loc,
 				     uint32_t offset, uint16_t *ident)
 {
 	return udf_read_tagged(sb, udf_get_lb_pblock(sb, loc, offset),
@@ -264,18 +264,18 @@ struct buffer_head *udf_read_ptagged(struct super_block *sb, kernel_lb_addr loc,
 
 void udf_update_tag(char *data, int length)
 {
-	tag *tptr = (tag *)data;
-	length -= sizeof(tag);
+	struct tag *tptr = (struct tag *)data;
+	length -= sizeof(struct tag);
 
 	tptr->descCRCLength = cpu_to_le16(length);
-	tptr->descCRC = cpu_to_le16(crc_itu_t(0, data + sizeof(tag), length));
+	tptr->descCRC = cpu_to_le16(crc_itu_t(0, data + sizeof(struct tag), length));
 	tptr->tagChecksum = udf_tag_checksum(tptr);
 }
 
 void udf_new_tag(char *data, uint16_t ident, uint16_t version, uint16_t snum,
 		 uint32_t loc, int length)
 {
-	tag *tptr = (tag *)data;
+	struct tag *tptr = (struct tag *)data;
 	tptr->tagIdent = cpu_to_le16(ident);
 	tptr->descVersion = cpu_to_le16(version);
 	tptr->tagSerialNum = cpu_to_le16(snum);
@@ -283,12 +283,12 @@ void udf_new_tag(char *data, uint16_t ident, uint16_t version, uint16_t snum,
 	udf_update_tag(data, length);
 }
 
-u8 udf_tag_checksum(const tag *t)
+u8 udf_tag_checksum(const struct tag *t)
 {
 	u8 *data = (u8 *)t;
 	u8 checksum = 0;
 	int i;
-	for (i = 0; i < sizeof(tag); ++i)
+	for (i = 0; i < sizeof(struct tag); ++i)
 		if (i != 4) /* position of checksum */
 			checksum += data[i];
 	return checksum;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index d323194..4926edd 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -47,7 +47,7 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 		 struct fileIdentDesc *sfi, struct udf_fileident_bh *fibh,
 		 uint8_t *impuse, uint8_t *fileident)
 {
-	uint16_t crclen = fibh->eoffset - fibh->soffset - sizeof(tag);
+	uint16_t crclen = fibh->eoffset - fibh->soffset - sizeof(struct tag);
 	uint16_t crc;
 	int offset;
 	uint16_t liu = le16_to_cpu(cfi->lengthOfImpUse);
@@ -99,18 +99,18 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}
 
-	crc = crc_itu_t(0, (uint8_t *)cfi + sizeof(tag),
-		      sizeof(struct fileIdentDesc) - sizeof(tag));
+	crc = crc_itu_t(0, (uint8_t *)cfi + sizeof(struct tag),
+		      sizeof(struct fileIdentDesc) - sizeof(struct tag));
 
 	if (fibh->sbh == fibh->ebh) {
 		crc = crc_itu_t(crc, (uint8_t *)sfi->impUse,
-			      crclen + sizeof(tag) -
+			      crclen + sizeof(struct tag) -
 			      sizeof(struct fileIdentDesc));
 	} else if (sizeof(struct fileIdentDesc) >= -fibh->soffset) {
 		crc = crc_itu_t(crc, fibh->ebh->b_data +
 					sizeof(struct fileIdentDesc) +
 					fibh->soffset,
-			      crclen + sizeof(tag) -
+			      crclen + sizeof(struct tag) -
 					sizeof(struct fileIdentDesc));
 	} else {
 		crc = crc_itu_t(crc, (uint8_t *)sfi->impUse,
@@ -154,7 +154,7 @@ static struct fileIdentDesc *udf_find_entry(struct inode *dir,
 	uint8_t lfi;
 	uint16_t liu;
 	loff_t size;
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
 	struct extent_position epos = {};
@@ -174,9 +174,9 @@ static struct fileIdentDesc *udf_find_entry(struct inode *dir,
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-				epos.offset -= sizeof(short_ad);
+				epos.offset -= sizeof(struct short_ad);
 			else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-				epos.offset -= sizeof(long_ad);
+				epos.offset -= sizeof(struct long_ad);
 		} else
 			offset = 0;
 
@@ -269,7 +269,7 @@ static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
 #ifdef UDF_RECOVERY
 	/* temporary shorthand for specifying files by inode number */
 	if (!strncmp(dentry->d_name.name, ".B=", 3)) {
-		kernel_lb_addr lb = {
+		struct kernel_lb_addr lb = {
 			.logicalBlockNum = 0,
 			.partitionReferenceNum =
 				simple_strtoul(dentry->d_name.name + 3,
@@ -314,7 +314,7 @@ static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 	uint8_t lfi;
 	uint16_t liu;
 	int block;
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen = 0;
 	sector_t offset;
 	struct extent_position epos = {};
@@ -359,9 +359,9 @@ static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-				epos.offset -= sizeof(short_ad);
+				epos.offset -= sizeof(struct short_ad);
 			else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-				epos.offset -= sizeof(long_ad);
+				epos.offset -= sizeof(struct long_ad);
 		} else
 			offset = 0;
 
@@ -410,9 +410,9 @@ add:
 	if (dinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB && elen) {
 		elen = (elen + sb->s_blocksize - 1) & ~(sb->s_blocksize - 1);
 		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-			epos.offset -= sizeof(short_ad);
+			epos.offset -= sizeof(struct short_ad);
 		else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-			epos.offset -= sizeof(long_ad);
+			epos.offset -= sizeof(struct long_ad);
 		udf_write_aext(dir, &epos, eloc, elen, 1);
 	}
 	f_pos += nfidlen;
@@ -495,10 +495,10 @@ add:
 	memset(cfi, 0, sizeof(struct fileIdentDesc));
 	if (UDF_SB(sb)->s_udfrev >= 0x0200)
 		udf_new_tag((char *)cfi, TAG_IDENT_FID, 3, 1, block,
-			    sizeof(tag));
+			    sizeof(struct tag));
 	else
 		udf_new_tag((char *)cfi, TAG_IDENT_FID, 2, 1, block,
-			    sizeof(tag));
+			    sizeof(struct tag));
 	cfi->fileVersionNum = cpu_to_le16(1);
 	cfi->lengthFileIdent = namelen;
 	cfi->lengthOfImpUse = cpu_to_le16(0);
@@ -531,7 +531,7 @@ static int udf_delete_entry(struct inode *inode, struct fileIdentDesc *fi,
 	cfi->fileCharacteristics |= FID_FILE_CHAR_DELETED;
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_STRICT))
-		memset(&(cfi->icb), 0x00, sizeof(long_ad));
+		memset(&(cfi->icb), 0x00, sizeof(struct long_ad));
 
 	return udf_write_fi(inode, cfi, fi, fibh, NULL, NULL);
 }
@@ -711,7 +711,7 @@ static int empty_dir(struct inode *dir)
 	loff_t f_pos;
 	loff_t size = udf_ext0_offset(dir) + dir->i_size;
 	int block;
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t offset;
 	struct extent_position epos = {};
@@ -728,9 +728,9 @@ static int empty_dir(struct inode *dir)
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
 		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
 			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-				epos.offset -= sizeof(short_ad);
+				epos.offset -= sizeof(struct short_ad);
 			else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-				epos.offset -= sizeof(long_ad);
+				epos.offset -= sizeof(struct long_ad);
 		} else
 			offset = 0;
 
@@ -779,7 +779,7 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc *fi, cfi;
-	kernel_lb_addr tloc;
+	struct kernel_lb_addr tloc;
 
 	retval = -ENOENT;
 	lock_kernel();
@@ -825,7 +825,7 @@ static int udf_unlink(struct inode *dir, struct dentry *dentry)
 	struct udf_fileident_bh fibh;
 	struct fileIdentDesc *fi;
 	struct fileIdentDesc cfi;
-	kernel_lb_addr tloc;
+	struct kernel_lb_addr tloc;
 
 	retval = -ENOENT;
 	lock_kernel();
@@ -898,7 +898,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 	inode->i_op = &page_symlink_inode_operations;
 
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
-		kernel_lb_addr eloc;
+		struct kernel_lb_addr eloc;
 		uint32_t bsize;
 
 		block = udf_new_block(inode->i_sb, inode,
@@ -1109,7 +1109,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct fileIdentDesc ocfi, ncfi;
 	struct buffer_head *dir_bh = NULL;
 	int retval = -ENOENT;
-	kernel_lb_addr tloc;
+	struct kernel_lb_addr tloc;
 	struct udf_inode_info *old_iinfo = UDF_I(old_inode);
 
 	lock_kernel();
@@ -1188,7 +1188,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 */
 	ncfi.fileVersionNum = ocfi.fileVersionNum;
 	ncfi.fileCharacteristics = ocfi.fileCharacteristics;
-	memcpy(&(ncfi.icb), &(ocfi.icb), sizeof(long_ad));
+	memcpy(&(ncfi.icb), &(ocfi.icb), sizeof(struct long_ad));
 	udf_write_fi(new_dir, &ncfi, nfi, &nfibh, NULL, NULL);
 
 	/* The old fid may have moved - find it again */
@@ -1284,7 +1284,7 @@ static struct dentry *udf_nfs_get_inode(struct super_block *sb, u32 block,
 {
 	struct inode *inode;
 	struct dentry *result;
-	kernel_lb_addr loc;
+	struct kernel_lb_addr loc;
 
 	if (block == 0)
 		return ERR_PTR(-ESTALE);
@@ -1335,7 +1335,7 @@ static int udf_encode_fh(struct dentry *de, __u32 *fh, int *lenp,
 {
 	int len = *lenp;
 	struct inode *inode =  de->d_inode;
-	kernel_lb_addr location = UDF_I(inode)->i_location;
+	struct kernel_lb_addr location = UDF_I(inode)->i_location;
 	struct fid *fid = (struct fid *)fh;
 	int type = FILEID_UDF_WITHOUT_PARENT;
 
diff --git a/fs/udf/osta_udf.h b/fs/udf/osta_udf.h
index 65ff479..fbff746 100644
--- a/fs/udf/osta_udf.h
+++ b/fs/udf/osta_udf.h
@@ -85,7 +85,7 @@ struct appIdentSuffix {
 /* Logical Volume Integrity Descriptor (UDF 2.50 2.2.6) */
 /* Implementation Use (UDF 2.50 2.2.6.4) */
 struct logicalVolIntegrityDescImpUse {
-	regid		impIdent;
+	struct regid	impIdent;
 	__le32		numFiles;
 	__le32		numDirs;
 	__le16		minUDFReadRev;
@@ -97,12 +97,12 @@ struct logicalVolIntegrityDescImpUse {
 /* Implementation Use Volume Descriptor (UDF 2.50 2.2.7) */
 /* Implementation Use (UDF 2.50 2.2.7.2) */
 struct impUseVolDescImpUse {
-	charspec	LVICharset;
+	struct charspec	LVICharset;
 	dstring		logicalVolIdent[128];
 	dstring		LVInfo1[36];
 	dstring		LVInfo2[36];
 	dstring		LVInfo3[36];
-	regid		impIdent;
+	struct regid	impIdent;
 	uint8_t		impUse[128];
 } __attribute__ ((packed));
 
@@ -110,7 +110,7 @@ struct udfPartitionMap2 {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	uint8_t		reserved1[2];
-	regid		partIdent;
+	struct regid	partIdent;
 	__le16		volSeqNum;
 	__le16		partitionNum;
 } __attribute__ ((packed));
@@ -120,7 +120,7 @@ struct virtualPartitionMap {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	uint8_t		reserved1[2];
-	regid		partIdent;
+	struct regid	partIdent;
 	__le16		volSeqNum;
 	__le16		partitionNum;
 	uint8_t		reserved2[24];
@@ -131,7 +131,7 @@ struct sparablePartitionMap {
 	uint8_t partitionMapType;
 	uint8_t partitionMapLength;
 	uint8_t reserved1[2];
-	regid partIdent;
+	struct regid partIdent;
 	__le16 volSeqNum;
 	__le16 partitionNum;
 	__le16 packetLength;
@@ -146,7 +146,7 @@ struct metadataPartitionMap {
 	uint8_t		partitionMapType;
 	uint8_t		partitionMapLength;
 	uint8_t		reserved1[2];
-	regid		partIdent;
+	struct regid	partIdent;
 	__le16		volSeqNum;
 	__le16		partitionNum;
 	__le32		metadataFileLoc;
@@ -161,7 +161,7 @@ struct metadataPartitionMap {
 /* Virtual Allocation Table (UDF 1.5 2.2.10) */
 struct virtualAllocationTable15 {
 	__le32		VirtualSector[0];
-	regid		vatIdent;
+	struct regid	vatIdent;
 	__le32		previousVATICBLoc;
 } __attribute__ ((packed));
 
@@ -192,8 +192,8 @@ struct sparingEntry {
 } __attribute__ ((packed));
 
 struct sparingTable {
-	tag 		descTag;
-	regid		sparingIdent;
+	struct tag	descTag;
+	struct regid	sparingIdent;
 	__le16		reallocationTableLen;
 	__le16		reserved;
 	__le32		sequenceNum;
@@ -206,7 +206,7 @@ struct sparingTable {
 #define ICBTAG_FILE_TYPE_MIRROR		0xFB
 #define ICBTAG_FILE_TYPE_BITMAP		0xFC
 
-/* struct long_ad ICB - ADImpUse (UDF 2.50 2.2.4.3) */
+/* struct struct long_ad ICB - ADImpUse (UDF 2.50 2.2.4.3) */
 struct allocDescImpUse {
 	__le16		flags;
 	uint8_t		impUse[4];
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index 96dfd20..4b540ee 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -273,7 +273,7 @@ static uint32_t udf_try_read_meta(struct inode *inode, uint32_t block,
 {
 	struct super_block *sb = inode->i_sb;
 	struct udf_part_map *map;
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	sector_t ext_offset;
 	struct extent_position epos = {};
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5698bbf..99a9369 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -85,12 +85,12 @@ static void udf_write_super(struct super_block *);
 static int udf_remount_fs(struct super_block *, int *, char *);
 static int udf_check_valid(struct super_block *, int, int);
 static int udf_vrs(struct super_block *sb, int silent);
-static void udf_load_logicalvolint(struct super_block *, kernel_extent_ad);
+static void udf_load_logicalvolint(struct super_block *, struct kernel_extent_ad);
 static void udf_find_anchor(struct super_block *);
-static int udf_find_fileset(struct super_block *, kernel_lb_addr *,
-			    kernel_lb_addr *);
+static int udf_find_fileset(struct super_block *, struct kernel_lb_addr *,
+			    struct kernel_lb_addr *);
 static void udf_load_fileset(struct super_block *, struct buffer_head *,
-			     kernel_lb_addr *);
+			     struct kernel_lb_addr *);
 static void udf_open_lvid(struct super_block *);
 static void udf_close_lvid(struct super_block *);
 static unsigned int udf_count_free(struct super_block *);
@@ -810,8 +810,8 @@ check_anchor:
 }
 
 static int udf_find_fileset(struct super_block *sb,
-			    kernel_lb_addr *fileset,
-			    kernel_lb_addr *root)
+			    struct kernel_lb_addr *fileset,
+			    struct kernel_lb_addr *root)
 {
 	struct buffer_head *bh = NULL;
 	long lastblock;
@@ -834,7 +834,7 @@ static int udf_find_fileset(struct super_block *sb,
 	sbi = UDF_SB(sb);
 	if (!bh) {
 		/* Search backwards through the partitions */
-		kernel_lb_addr newfileset;
+		struct kernel_lb_addr newfileset;
 
 /* --> cvg: FIXME - is it reasonable? */
 		return 1;
@@ -917,7 +917,7 @@ static int udf_load_pvoldesc(struct super_block *sb, sector_t block)
 	if (udf_disk_stamp_to_time(&UDF_SB(sb)->s_record_time,
 			      pvoldesc->recordingDateAndTime)) {
 #ifdef UDFFS_DEBUG
-		timestamp *ts = &pvoldesc->recordingDateAndTime;
+		struct timestamp *ts = &pvoldesc->recordingDateAndTime;
 		udf_debug("recording time %04u/%02u/%02u"
 			  " %02u:%02u (%x)\n",
 			  le16_to_cpu(ts->year), ts->month, ts->day, ts->hour,
@@ -946,7 +946,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
 	struct udf_meta_data *mdata;
-	kernel_lb_addr addr;
+	struct kernel_lb_addr addr;
 	int fe_error = 0;
 
 	map = &sbi->s_partmaps[partition];
@@ -1037,7 +1037,7 @@ error_exit:
 }
 
 static void udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
-			     kernel_lb_addr *root)
+			     struct kernel_lb_addr *root)
 {
 	struct fileSetDesc *fset;
 
@@ -1119,7 +1119,7 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 
 	phd = (struct partitionHeaderDesc *)p->partitionContentsUse;
 	if (phd->unallocSpaceTable.extLength) {
-		kernel_lb_addr loc = {
+		struct kernel_lb_addr loc = {
 			.logicalBlockNum = le32_to_cpu(
 				phd->unallocSpaceTable.extPosition),
 			.partitionReferenceNum = p_index,
@@ -1154,7 +1154,7 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		udf_debug("partitionIntegrityTable (part %d)\n", p_index);
 
 	if (phd->freedSpaceTable.extLength) {
-		kernel_lb_addr loc = {
+		struct kernel_lb_addr loc = {
 			.logicalBlockNum = le32_to_cpu(
 				phd->freedSpaceTable.extPosition),
 			.partitionReferenceNum = p_index,
@@ -1192,7 +1192,7 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map = &sbi->s_partmaps[p_index];
-	kernel_lb_addr ino;
+	struct kernel_lb_addr ino;
 	struct buffer_head *bh = NULL;
 	struct udf_inode_info *vati;
 	uint32_t pos;
@@ -1322,7 +1322,7 @@ out_bh:
 }
 
 static int udf_load_logicalvol(struct super_block *sb, sector_t block,
-			       kernel_lb_addr *fileset)
+			       struct kernel_lb_addr *fileset)
 {
 	struct logicalVolDesc *lvd;
 	int i, j, offset;
@@ -1471,7 +1471,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	}
 
 	if (fileset) {
-		long_ad *la = (long_ad *)&(lvd->logicalVolContentsUse[0]);
+		struct long_ad *la = (struct long_ad *)&(lvd->logicalVolContentsUse[0]);
 
 		*fileset = lelb_to_cpu(la->extLocation);
 		udf_debug("FileSet found in LogicalVolDesc at block=%d, "
@@ -1490,7 +1490,7 @@ out_bh:
  * udf_load_logicalvolint
  *
  */
-static void udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
+static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_ad loc)
 {
 	struct buffer_head *bh = NULL;
 	uint16_t ident;
@@ -1533,7 +1533,7 @@ static void udf_load_logicalvolint(struct super_block *sb, kernel_extent_ad loc)
  *	Written, tested, and released.
  */
 static noinline int udf_process_sequence(struct super_block *sb, long block,
-				long lastblock, kernel_lb_addr *fileset)
+				long lastblock, struct kernel_lb_addr *fileset)
 {
 	struct buffer_head *bh = NULL;
 	struct udf_vds_record vds[VDS_POS_LENGTH];
@@ -1678,7 +1678,7 @@ static int udf_check_valid(struct super_block *sb, int novrs, int silent)
 	return !block;
 }
 
-static int udf_load_sequence(struct super_block *sb, kernel_lb_addr *fileset)
+static int udf_load_sequence(struct super_block *sb, struct kernel_lb_addr *fileset)
 {
 	struct anchorVolDescPtr *anchor;
 	uint16_t ident;
@@ -1755,7 +1755,7 @@ static void udf_open_lvid(struct super_block *sb)
 	lvid->integrityType = LVID_INTEGRITY_TYPE_OPEN;
 
 	lvid->descTag.descCRC = cpu_to_le16(
-		crc_itu_t(0, (char *)lvid + sizeof(tag),
+		crc_itu_t(0, (char *)lvid + sizeof(struct tag),
 			le16_to_cpu(lvid->descTag.descCRCLength)));
 
 	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
@@ -1790,7 +1790,7 @@ static void udf_close_lvid(struct super_block *sb)
 	lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
 	lvid->descTag.descCRC = cpu_to_le16(
-			crc_itu_t(0, (char *)lvid + sizeof(tag),
+			crc_itu_t(0, (char *)lvid + sizeof(struct tag),
 				le16_to_cpu(lvid->descTag.descCRCLength)));
 
 	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
@@ -1848,7 +1848,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	int i;
 	struct inode *inode = NULL;
 	struct udf_options uopt;
-	kernel_lb_addr rootdir, fileset;
+	struct kernel_lb_addr rootdir, fileset;
 	struct udf_sb_info *sbi;
 
 	uopt.flags = (1 << UDF_FLAG_USE_AD_IN_ICB) | (1 << UDF_FLAG_STRICT);
@@ -1978,7 +1978,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	}
 
 	if (!silent) {
-		timestamp ts;
+		struct timestamp ts;
 		udf_time_to_disk_stamp(&ts, sbi->s_record_time);
 		udf_info("UDF: Mounting volume '%s', "
 			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
@@ -2114,7 +2114,7 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	unsigned int accum = 0;
 	int index;
 	int block = 0, newblock;
-	kernel_lb_addr loc;
+	struct kernel_lb_addr loc;
 	uint32_t bytes;
 	uint8_t *ptr;
 	uint16_t ident;
@@ -2170,7 +2170,7 @@ static unsigned int udf_count_free_table(struct super_block *sb,
 {
 	unsigned int accum = 0;
 	uint32_t elen;
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	int8_t etype;
 	struct extent_position epos;
 
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 65e19b4..f2fad30 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -28,10 +28,10 @@
 #include "udf_sb.h"
 
 static void extent_trunc(struct inode *inode, struct extent_position *epos,
-			 kernel_lb_addr eloc, int8_t etype, uint32_t elen,
+			 struct kernel_lb_addr eloc, int8_t etype, uint32_t elen,
 			 uint32_t nelen)
 {
-	kernel_lb_addr neloc = {};
+	struct kernel_lb_addr neloc = {};
 	int last_block = (elen + inode->i_sb->s_blocksize - 1) >>
 		inode->i_sb->s_blocksize_bits;
 	int first_block = (nelen + inode->i_sb->s_blocksize - 1) >>
@@ -68,7 +68,7 @@ static void extent_trunc(struct inode *inode, struct extent_position *epos,
 void udf_truncate_tail_extent(struct inode *inode)
 {
 	struct extent_position epos = {};
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen, nelen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
@@ -83,9 +83,9 @@ void udf_truncate_tail_extent(struct inode *inode)
 		return;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(short_ad);
+		adsize = sizeof(struct short_ad);
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(long_ad);
+		adsize = sizeof(struct long_ad);
 	else
 		BUG();
 
@@ -124,7 +124,7 @@ void udf_truncate_tail_extent(struct inode *inode)
 void udf_discard_prealloc(struct inode *inode)
 {
 	struct extent_position epos = { NULL, 0, {0, 0} };
-	kernel_lb_addr eloc;
+	struct kernel_lb_addr eloc;
 	uint32_t elen;
 	uint64_t lbcount = 0;
 	int8_t etype = -1, netype;
@@ -136,9 +136,9 @@ void udf_discard_prealloc(struct inode *inode)
 		return;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(short_ad);
+		adsize = sizeof(struct short_ad);
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(long_ad);
+		adsize = sizeof(struct long_ad);
 	else
 		adsize = 0;
 
@@ -200,7 +200,7 @@ static void udf_update_alloc_ext_desc(struct inode *inode,
 void udf_truncate_extents(struct inode *inode)
 {
 	struct extent_position epos;
-	kernel_lb_addr eloc, neloc = {};
+	struct kernel_lb_addr eloc, neloc = {};
 	uint32_t elen, nelen = 0, indirect_ext_len = 0, lenalloc;
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
@@ -210,9 +210,9 @@ void udf_truncate_extents(struct inode *inode)
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-		adsize = sizeof(short_ad);
+		adsize = sizeof(struct short_ad);
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-		adsize = sizeof(long_ad);
+		adsize = sizeof(struct long_ad);
 	else
 		BUG();
 
@@ -278,7 +278,7 @@ void udf_truncate_extents(struct inode *inode)
 			udf_update_alloc_ext_desc(inode, &epos, lenalloc);
 	} else if (inode->i_size) {
 		if (byte_offset) {
-			kernel_long_ad extent;
+			struct kernel_long_ad extent;
 
 			/*
 			 *  OK, there is not extent covering inode->i_size and
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index 4f86b1d..e58d1de 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -4,7 +4,7 @@
 struct udf_inode_info {
 	struct timespec		i_crtime;
 	/* Physical address of inode */
-	kernel_lb_addr		i_location;
+	struct kernel_lb_addr		i_location;
 	__u64			i_unique;
 	__u32			i_lenEAttr;
 	__u32			i_lenAlloc;
@@ -17,8 +17,8 @@ struct udf_inode_info {
 	unsigned		i_strat4096 : 1;
 	unsigned		reserved : 26;
 	union {
-		short_ad	*i_sad;
-		long_ad		*i_lad;
+		struct short_ad	*i_sad;
+		struct long_ad		*i_lad;
 		__u8		*i_data;
 	} i_ext;
 	struct inode vfs_inode;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 8ec865d..35f0b9b 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -65,7 +65,7 @@ static inline size_t udf_ext0_offset(struct inode *inode)
 #define udf_get_lb_pblock(sb,loc,offset) udf_get_pblock((sb), (loc).logicalBlockNum, (loc).partitionReferenceNum, (offset))
 
 /* computes tag checksum */
-u8 udf_tag_checksum(const tag *t);
+u8 udf_tag_checksum(const struct tag *t);
 
 struct dentry;
 struct inode;
@@ -95,7 +95,7 @@ struct udf_vds_record {
 };
 
 struct generic_desc {
-	tag		descTag;
+	struct tag	descTag;
 	__le32		volDescSeqNum;
 };
 
@@ -108,7 +108,7 @@ struct ustr {
 struct extent_position {
 	struct buffer_head *bh;
 	uint32_t offset;
-	kernel_lb_addr block;
+	struct kernel_lb_addr block;
 };
 
 /* super.c */
@@ -124,7 +124,7 @@ extern int udf_ioctl(struct inode *, struct file *, unsigned int,
 		     unsigned long);
 
 /* inode.c */
-extern struct inode *udf_iget(struct super_block *, kernel_lb_addr);
+extern struct inode *udf_iget(struct super_block *, struct kernel_lb_addr);
 extern int udf_sync_inode(struct inode *);
 extern void udf_expand_file_adinicb(struct inode *, int, int *);
 extern struct buffer_head *udf_expand_dir_adinicb(struct inode *, int *, int *);
@@ -136,19 +136,19 @@ extern void udf_clear_inode(struct inode *);
 extern int udf_write_inode(struct inode *, int);
 extern long udf_block_map(struct inode *, sector_t);
 extern int udf_extend_file(struct inode *, struct extent_position *,
-			   kernel_long_ad *, sector_t);
+			   struct kernel_long_ad *, sector_t);
 extern int8_t inode_bmap(struct inode *, sector_t, struct extent_position *,
-			 kernel_lb_addr *, uint32_t *, sector_t *);
+			 struct kernel_lb_addr *, uint32_t *, sector_t *);
 extern int8_t udf_add_aext(struct inode *, struct extent_position *,
-			   kernel_lb_addr, uint32_t, int);
+			   struct kernel_lb_addr, uint32_t, int);
 extern int8_t udf_write_aext(struct inode *, struct extent_position *,
-			     kernel_lb_addr, uint32_t, int);
+			     struct kernel_lb_addr, uint32_t, int);
 extern int8_t udf_delete_aext(struct inode *, struct extent_position,
-			      kernel_lb_addr, uint32_t);
+			      struct kernel_lb_addr, uint32_t);
 extern int8_t udf_next_aext(struct inode *, struct extent_position *,
-			    kernel_lb_addr *, uint32_t *, int);
+			    struct kernel_lb_addr *, uint32_t *, int);
 extern int8_t udf_current_aext(struct inode *, struct extent_position *,
-			       kernel_lb_addr *, uint32_t *, int);
+			       struct kernel_lb_addr *, uint32_t *, int);
 
 /* misc.c */
 extern struct buffer_head *udf_tgetblk(struct super_block *, int);
@@ -160,7 +160,7 @@ extern struct genericFormat *udf_get_extendedattr(struct inode *, uint32_t,
 extern struct buffer_head *udf_read_tagged(struct super_block *, uint32_t,
 					   uint32_t, uint16_t *);
 extern struct buffer_head *udf_read_ptagged(struct super_block *,
-					    kernel_lb_addr, uint32_t,
+					    struct kernel_lb_addr, uint32_t,
 					    uint16_t *);
 extern void udf_update_tag(char *, int);
 extern void udf_new_tag(char *, uint16_t, uint16_t, uint16_t, uint32_t, int);
@@ -200,7 +200,7 @@ extern void udf_truncate_extents(struct inode *);
 
 /* balloc.c */
 extern void udf_free_blocks(struct super_block *, struct inode *,
-			    kernel_lb_addr, uint32_t, uint32_t);
+			    struct kernel_lb_addr, uint32_t, uint32_t);
 extern int udf_prealloc_blocks(struct super_block *, struct inode *, uint16_t,
 			       uint32_t, uint32_t);
 extern int udf_new_block(struct super_block *, struct inode *, uint16_t,
@@ -214,16 +214,16 @@ extern struct fileIdentDesc *udf_fileident_read(struct inode *, loff_t *,
 						struct udf_fileident_bh *,
 						struct fileIdentDesc *,
 						struct extent_position *,
-						kernel_lb_addr *, uint32_t *,
+						struct kernel_lb_addr *, uint32_t *,
 						sector_t *);
 extern struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize,
 					       int *offset);
-extern long_ad *udf_get_filelongad(uint8_t *, int, uint32_t *, int);
-extern short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);
+extern struct long_ad *udf_get_filelongad(uint8_t *, int, uint32_t *, int);
+extern struct short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);
 
 /* udftime.c */
 extern struct timespec *udf_disk_stamp_to_time(struct timespec *dest,
-						timestamp src);
-extern timestamp *udf_time_to_disk_stamp(timestamp *dest, struct timespec src);
+						struct timestamp src);
+extern struct timestamp *udf_time_to_disk_stamp(struct timestamp *dest, struct timespec src);
 
 #endif				/* __UDF_DECL_H */
diff --git a/fs/udf/udfend.h b/fs/udf/udfend.h
index 489f52f..6a9f3a9 100644
--- a/fs/udf/udfend.h
+++ b/fs/udf/udfend.h
@@ -4,9 +4,9 @@
 #include <asm/byteorder.h>
 #include <linux/string.h>
 
-static inline kernel_lb_addr lelb_to_cpu(lb_addr in)
+static inline struct kernel_lb_addr lelb_to_cpu(struct lb_addr in)
 {
-	kernel_lb_addr out;
+	struct kernel_lb_addr out;
 
 	out.logicalBlockNum = le32_to_cpu(in.logicalBlockNum);
 	out.partitionReferenceNum = le16_to_cpu(in.partitionReferenceNum);
@@ -14,9 +14,9 @@ static inline kernel_lb_addr lelb_to_cpu(lb_addr in)
 	return out;
 }
 
-static inline lb_addr cpu_to_lelb(kernel_lb_addr in)
+static inline struct lb_addr cpu_to_lelb(struct kernel_lb_addr in)
 {
-	lb_addr out;
+	struct lb_addr out;
 
 	out.logicalBlockNum = cpu_to_le32(in.logicalBlockNum);
 	out.partitionReferenceNum = cpu_to_le16(in.partitionReferenceNum);
@@ -24,9 +24,9 @@ static inline lb_addr cpu_to_lelb(kernel_lb_addr in)
 	return out;
 }
 
-static inline short_ad lesa_to_cpu(short_ad in)
+static inline struct short_ad lesa_to_cpu(struct short_ad in)
 {
-	short_ad out;
+	struct short_ad out;
 
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extPosition = le32_to_cpu(in.extPosition);
@@ -34,9 +34,9 @@ static inline short_ad lesa_to_cpu(short_ad in)
 	return out;
 }
 
-static inline short_ad cpu_to_lesa(short_ad in)
+static inline struct short_ad cpu_to_lesa(struct short_ad in)
 {
-	short_ad out;
+	struct short_ad out;
 
 	out.extLength = cpu_to_le32(in.extLength);
 	out.extPosition = cpu_to_le32(in.extPosition);
@@ -44,9 +44,9 @@ static inline short_ad cpu_to_lesa(short_ad in)
 	return out;
 }
 
-static inline kernel_long_ad lela_to_cpu(long_ad in)
+static inline struct kernel_long_ad lela_to_cpu(struct long_ad in)
 {
-	kernel_long_ad out;
+	struct kernel_long_ad out;
 
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extLocation = lelb_to_cpu(in.extLocation);
@@ -54,9 +54,9 @@ static inline kernel_long_ad lela_to_cpu(long_ad in)
 	return out;
 }
 
-static inline long_ad cpu_to_lela(kernel_long_ad in)
+static inline struct long_ad cpu_to_lela(struct kernel_long_ad in)
 {
-	long_ad out;
+	struct long_ad out;
 
 	out.extLength = cpu_to_le32(in.extLength);
 	out.extLocation = cpu_to_lelb(in.extLocation);
@@ -64,9 +64,9 @@ static inline long_ad cpu_to_lela(kernel_long_ad in)
 	return out;
 }
 
-static inline kernel_extent_ad leea_to_cpu(extent_ad in)
+static inline struct kernel_extent_ad leea_to_cpu(struct extent_ad in)
 {
-	kernel_extent_ad out;
+	struct kernel_extent_ad out;
 
 	out.extLength = le32_to_cpu(in.extLength);
 	out.extLocation = le32_to_cpu(in.extLocation);
diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index 5f81165..b8c828c 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -85,7 +85,8 @@ extern struct timezone sys_tz;
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
 
-struct timespec *udf_disk_stamp_to_time(struct timespec *dest, timestamp src)
+struct timespec *
+udf_disk_stamp_to_time(struct timespec *dest, struct timestamp src)
 {
 	int yday;
 	u16 typeAndTimezone = le16_to_cpu(src.typeAndTimezone);
@@ -116,7 +117,8 @@ struct timespec *udf_disk_stamp_to_time(struct timespec *dest, timestamp src)
 	return dest;
 }
 
-timestamp *udf_time_to_disk_stamp(timestamp *dest, struct timespec ts)
+struct timestamp *
+udf_time_to_disk_stamp(struct timestamp *dest, struct timespec ts)
 {
 	long int days, rem, y;
 	const unsigned short int *ip;
-- 
1.5.4.3

