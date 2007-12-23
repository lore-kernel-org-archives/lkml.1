Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbXLWB5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbXLWB5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbXLWB4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:56:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbXLWB4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:56:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=oPaOf8xmqfgCSZWy2rHygk7TPQBUk91rk0bm2cEc5OTX4Kik1WzM9JxlPqbbfJK68AmUnjCe5vE1Co5xhhh2taDqXLEueMZnQHKiQuBEHqaVsaWWGPSR0g7uPLjYm+00A73pw1nmAEV+C6E3BIdMoR8Iw7nZSWBPRQ+z2ecmwsw=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 20/24] udf: convert UDF_UPDATE_UDFREV macro to udf_update_revision function
Date: Sun, 23 Dec 2007 02:51:10 +0100
Message-Id: <1198374674-12128-21-git-send-email-marcin.slusarz@gmail.com>
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
 fs/udf/ialloc.c |    2 +-
 fs/udf/udf_sb.h |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 269f588..4d1684c 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -123,7 +123,7 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
 	UDF_I_USE(inode) = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
 		UDF_I_EFE(inode) = 1;
-		UDF_UPDATE_UDFREV(inode->i_sb, UDF_VERS_USE_EXTENDED_FE);
+		udf_update_revision(inode->i_sb, UDF_VERS_USE_EXTENDED_FE);
 		UDF_I_DATA(inode) = kzalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
 	} else {
 		UDF_I_EFE(inode) = 0;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 565c9ef..aee5942 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -138,6 +138,12 @@ static inline struct inode *udf_sb_vat_inode(struct super_block *sb)
 	return udf_sb(sb)->s_vat_inode;
 }
 
+static inline void udf_update_revision(struct super_block *sb, __u16 revision)
+{
+	if (revision > udf_sb_revision(sb))
+		udf_sb(sb)->s_udfrev = revision;
+}
+
 #define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
 {\
 	int nr_groups = ((UDF_SB_PARTLEN((X),(Y)) + (sizeof(struct spaceBitmapDesc) << 3) +\
@@ -176,8 +182,6 @@ static inline struct inode *udf_sb_vat_inode(struct super_block *sb)
 #define UDF_SET_FLAG(X,Y)			( udf_sb(X)->s_flags |= ( 1 << (Y) ) )
 #define UDF_CLEAR_FLAG(X,Y)			( udf_sb(X)->s_flags &= ~( 1 << (Y) ) )
 
-#define UDF_UPDATE_UDFREV(X,Y)			( ((Y) > udf_sb_revision(X)) ? udf_sb(X)->s_udfrev = (Y) : udf_sb_revision(X) )
-
 #define UDF_SB_PARTTYPE(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_type )
 #define UDF_SB_PARTROOT(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_root )
 #define UDF_SB_PARTLEN(X,Y)			( udf_sb_partmaps(X)[(Y)].s_partition_len )
-- 
1.5.3.4

