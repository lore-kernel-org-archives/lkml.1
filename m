Return-Path: <linux-kernel-owner+w=401wt.eu-S1764276AbYDVNdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764276AbYDVNdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758642AbYDVNdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:33:07 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:61779 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405AbYDVNdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=ConPjp+asfDnd9OeJcNg1BW/NmAq3fCAwDvd1WxV2Li1g8F56bKWYgBCvydE9JRZOjJ0z1+WD0HI2yzR1/AFK7z5GPNnXJniJqPXQyw2WdYSx9LNzJARPxr+a83PQwWPtu2req0lZ7sM1/hPu8DCbw5tZbED7eBzquszZS5gJ/o=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: [PATCH] xfs: remove unused params from functions in xfs_dir2_leaf.h
Date: Tue, 22 Apr 2008 15:32:22 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221320.54147.vda.linux@googlemail.com> <200804221351.03885.vda.linux@googlemail.com>
In-Reply-To: <200804221351.03885.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mjeDIbsEfOWYWhl"
Message-Id: <200804221532.22701.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_mjeDIbsEfOWYWhl
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

Inline functions xfs_dir2_dataptr_to_byte and xfs_dir2_byte_to_dataptr
are not using their 1st argument. gcc is able to optimize that out.

I still want to delete these parameters, as they serve no useful purpose
and by removing them I can make gcc to notice some additional
unused variables in the callers of these inlines, and warn me
about that.

There is no object code size difference from this change.

Compile tested only.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda 

--Boundary-00=_mjeDIbsEfOWYWhl
Content-Type: text/x-diff;
  charset="koi8-r";
  name="xfs7-xfs_dir2_leaf.h-remove_unused_params.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs7-xfs_dir2_leaf.h-remove_unused_params.patch"

diff -urpN linux-2.6-xfs5/fs/xfs/xfs_dir2_block.c linux-2.6-xfs6/fs/xfs/xfs_dir2_block.c
--- linux-2.6-xfs5/fs/xfs/xfs_dir2_block.c	2008-04-22 04:19:32.000000000 +0200
+++ linux-2.6-xfs6/fs/xfs/xfs_dir2_block.c	2008-04-22 12:19:44.000000000 +0200
@@ -397,7 +397,7 @@ xfs_dir2_block_addname(
 	 * Fill in the leaf entry.
 	 */
 	blp[mid].hashval = cpu_to_be32(args->hashval);
-	blp[mid].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
+	blp[mid].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)block));
 	xfs_dir2_block_log_leaf(tp, bp, lfloglow, lfloghigh);
 	/*
@@ -1124,7 +1124,7 @@ xfs_dir2_sf_to_block(
 	*tagp = cpu_to_be16((char *)dep - (char *)block);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
-	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
+	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)block));
 	/*
 	 * Create entry for ..
@@ -1138,7 +1138,7 @@ xfs_dir2_sf_to_block(
 	*tagp = cpu_to_be16((char *)dep - (char *)block);
 	xfs_dir2_data_log_entry(tp, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
-	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
+	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 				(char *)dep - (char *)block));
 	offset = XFS_DIR2_DATA_FIRST_OFFSET;
 	/*
@@ -1189,7 +1189,7 @@ xfs_dir2_sf_to_block(
 		xfs_dir2_data_log_entry(tp, bp, dep);
 		blp[2 + i].hashval = cpu_to_be32(xfs_da_hashname(
 					(char *)sfep->name, sfep->namelen));
-		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
+		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 						 (char *)dep - (char *)block));
 		offset = (int)((char *)(tagp + 1) - (char *)block);
 		if (++i == sfp->hdr.count)
diff -urpN linux-2.6-xfs5/fs/xfs/xfs_dir2_leaf.c linux-2.6-xfs6/fs/xfs/xfs_dir2_leaf.c
--- linux-2.6-xfs5/fs/xfs/xfs_dir2_leaf.c	2008-04-22 04:18:27.000000000 +0200
+++ linux-2.6-xfs6/fs/xfs/xfs_dir2_leaf.c	2008-04-22 12:19:21.000000000 +0200
@@ -804,7 +804,7 @@ xfs_dir2_leaf_getdents(
 	 * Inside the loop we keep the main offset value as a byte offset
 	 * in the directory file.
 	 */
-	curoff = xfs_dir2_dataptr_to_byte(mp, *offset);
+	curoff = xfs_dir2_dataptr_to_byte(*offset);
 
 	/*
 	 * Force this conversion through db so we truncate the offset
@@ -1091,7 +1091,7 @@ xfs_dir2_leaf_getdents(
 		 * Won't fit.  Return to caller.
 		 */
 		if (filldir(dirent, dep->name, dep->namelen,
-			    xfs_dir2_byte_to_dataptr(mp, curoff),
+			    xfs_dir2_byte_to_dataptr(curoff),
 			    ino, DT_UNKNOWN))
 			break;
 
@@ -1106,10 +1106,10 @@ xfs_dir2_leaf_getdents(
 	/*
 	 * All done.  Set output offset value to current offset.
 	 */
-	if (curoff > xfs_dir2_dataptr_to_byte(mp, XFS_DIR2_MAX_DATAPTR))
+	if (curoff > xfs_dir2_dataptr_to_byte(XFS_DIR2_MAX_DATAPTR))
 		*offset = XFS_DIR2_MAX_DATAPTR;
 	else
-		*offset = xfs_dir2_byte_to_dataptr(mp, curoff);
+		*offset = xfs_dir2_byte_to_dataptr(curoff);
 	kmem_free(map);
 	if (bp)
 		xfs_da_brelse(NULL, bp);
diff -urpN linux-2.6-xfs5/fs/xfs/xfs_dir2_leaf.h linux-2.6-xfs6/fs/xfs/xfs_dir2_leaf.h
--- linux-2.6-xfs5/fs/xfs/xfs_dir2_leaf.h	2008-04-22 04:06:43.000000000 +0200
+++ linux-2.6-xfs6/fs/xfs/xfs_dir2_leaf.h	2008-04-22 12:19:29.000000000 +0200
@@ -112,7 +112,7 @@ xfs_dir2_leaf_bests_p(xfs_dir2_leaf_tail
  * Convert dataptr to byte in file space
  */
 static inline xfs_dir2_off_t
-xfs_dir2_dataptr_to_byte(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
+xfs_dir2_dataptr_to_byte(xfs_dir2_dataptr_t dp)
 {
 	return (xfs_dir2_off_t)(dp) << XFS_DIR2_DATA_ALIGN_LOG;
 }
@@ -121,7 +121,7 @@ xfs_dir2_dataptr_to_byte(struct xfs_moun
  * Convert byte in file space to dataptr.  It had better be aligned.
  */
 static inline xfs_dir2_dataptr_t
-xfs_dir2_byte_to_dataptr(struct xfs_mount *mp, xfs_dir2_off_t by)
+xfs_dir2_byte_to_dataptr(xfs_dir2_off_t by)
 {
 	return (xfs_dir2_dataptr_t)((by) >> XFS_DIR2_DATA_ALIGN_LOG);
 }
@@ -142,7 +142,7 @@ xfs_dir2_byte_to_db(struct xfs_mount *mp
 static inline xfs_dir2_db_t
 xfs_dir2_dataptr_to_db(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
-	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(mp, dp));
+	return xfs_dir2_byte_to_db(mp, xfs_dir2_dataptr_to_byte(dp));
 }
 
 /*
@@ -161,7 +161,7 @@ xfs_dir2_byte_to_off(struct xfs_mount *m
 static inline xfs_dir2_data_aoff_t
 xfs_dir2_dataptr_to_off(struct xfs_mount *mp, xfs_dir2_dataptr_t dp)
 {
-	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(mp, dp));
+	return xfs_dir2_byte_to_off(mp, xfs_dir2_dataptr_to_byte(dp));
 }
 
 /*
@@ -200,7 +200,7 @@ static inline xfs_dir2_dataptr_t
 xfs_dir2_db_off_to_dataptr(struct xfs_mount *mp, xfs_dir2_db_t db,
 			   xfs_dir2_data_aoff_t o)
 {
-	return xfs_dir2_byte_to_dataptr(mp, xfs_dir2_db_off_to_byte(mp, db, o));
+	return xfs_dir2_byte_to_dataptr(xfs_dir2_db_off_to_byte(mp, db, o));
 }
 
 /*

--Boundary-00=_mjeDIbsEfOWYWhl--
