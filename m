Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbXLWBy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbXLWBy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXLWByr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:54:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbXLWByq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=XiGffcCFYVyocITXtqeTtlQFUrujt1B2PV9qGTjEWSk76S1RRkXTgo37Hb/yGAImlb0aUl56AcgOOHQgI4U6KjX9dLNblZfNBqvzbKrgjf+QY/VMHcBH4NA155SYv8truYGTgVXgwcLsHQIfY1nl7liVOSyNao0u1ocRDFTeiIE=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 14/24] udf: convert UDF_SB_RECORDTIME macro to udf_sb_record_time function
Date: Sun, 23 Dec 2007 02:51:04 +0100
Message-Id: <1198374674-12128-15-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change UDF_SB_RECORDTIME macro to udf_sb_record_time inline function
- rename s_recordtime field to s_record_time

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c            |   14 +++++++-------
 fs/udf/super.c            |    6 +++---
 fs/udf/udf_sb.h           |    6 +++++-
 include/linux/udf_fs_sb.h |    2 +-
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 5afa19e..8c725e2 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1160,7 +1160,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			inode->i_atime.tv_sec = convtime;
 			inode->i_atime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_atime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_atime = udf_sb_record_time(inode->i_sb);
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1168,7 +1168,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			inode->i_mtime.tv_sec = convtime;
 			inode->i_mtime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_mtime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_mtime = udf_sb_record_time(inode->i_sb);
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1176,7 +1176,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			inode->i_ctime.tv_sec = convtime;
 			inode->i_ctime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_ctime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_ctime = udf_sb_record_time(inode->i_sb);
 		}
 
 		UDF_I_UNIQUE(inode) = le64_to_cpu(fe->uniqueID);
@@ -1192,7 +1192,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			inode->i_atime.tv_sec = convtime;
 			inode->i_atime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_atime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_atime = udf_sb_record_time(inode->i_sb);
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1200,7 +1200,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			inode->i_mtime.tv_sec = convtime;
 			inode->i_mtime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_mtime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_mtime = udf_sb_record_time(inode->i_sb);
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1208,7 +1208,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			UDF_I_CRTIME(inode).tv_sec = convtime;
 			UDF_I_CRTIME(inode).tv_nsec = convtime_usec * 1000;
 		} else {
-			UDF_I_CRTIME(inode) = UDF_SB_RECORDTIME(inode->i_sb);
+			UDF_I_CRTIME(inode) = udf_sb_record_time(inode->i_sb);
 		}
 
 		if (udf_stamp_to_time(&convtime, &convtime_usec,
@@ -1216,7 +1216,7 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 			inode->i_ctime.tv_sec = convtime;
 			inode->i_ctime.tv_nsec = convtime_usec * 1000;
 		} else {
-			inode->i_ctime = UDF_SB_RECORDTIME(inode->i_sb);
+			inode->i_ctime = udf_sb_record_time(inode->i_sb);
 		}
 
 		UDF_I_UNIQUE(inode) = le64_to_cpu(efe->uniqueID);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 6c14c4d..eb01f25 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -867,8 +867,8 @@ static void udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
 			  recording, recording_usec,
 			  ts.year, ts.month, ts.day, ts.hour,
 			  ts.minute, ts.typeAndTimezone);
-		UDF_SB_RECORDTIME(sb).tv_sec = recording;
-		UDF_SB_RECORDTIME(sb).tv_nsec = recording_usec * 1000;
+		udf_sb(sb)->s_record_time.tv_sec = recording;
+		udf_sb(sb)->s_record_time.tv_nsec = recording_usec * 1000;
 	}
 
 	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32)) {
@@ -1578,7 +1578,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
 	if (!silent) {
 		kernel_timestamp ts;
-		udf_time_to_stamp(&ts, UDF_SB_RECORDTIME(sb));
+		udf_time_to_stamp(&ts, udf_sb_record_time(sb));
 		udf_info("UDF %s (%s) Mounting volume '%s', "
 			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
 			 UDFFS_VERSION, UDFFS_DATE,
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 8683b71..e9346c2 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -103,6 +103,11 @@ static inline struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct super_b
 	return (struct logicalVolIntegrityDescImpUse *)&(lvid->impUse[offset]);
 }
 
+static inline struct timespec udf_sb_record_time(struct super_block *sb)
+{
+	return udf_sb(sb)->s_record_time;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -167,7 +172,6 @@ static inline struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct super_b
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_RECORDTIME(X)			( udf_sb(X)->s_recordtime )
 #define UDF_SB_SERIALNUM(X)			( udf_sb(X)->s_serialnum )
 #define UDF_SB_UDFREV(X)			( udf_sb(X)->s_udfrev )
 #define UDF_SB_VAT(X)				( udf_sb(X)->s_vat )
diff --git a/include/linux/udf_fs_sb.h b/include/linux/udf_fs_sb.h
index a9f19ab..adfecc6 100644
--- a/include/linux/udf_fs_sb.h
+++ b/include/linux/udf_fs_sb.h
@@ -94,7 +94,7 @@ struct udf_sb_info
 	uid_t			s_uid;
 
 	/* Root Info */
-	struct timespec		s_recordtime;
+	struct timespec		s_record_time;
 
 	/* Fileset Info */
 	__u16			s_serialnum;
-- 
1.5.3.4

