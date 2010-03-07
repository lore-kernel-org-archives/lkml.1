Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0CGLvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 06:51:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48305 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0CGLvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 06:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=epl9C3Ym+tEY+LION0QvJpvYJGUVnBoCMdzc9A00O8BpdSS0PXQRl3B4BAblGxP6Sn
         fmkmkVKTRlyMht3y+jeFYfhoaCJ+7dvqt4M9aM0bl5xYoSOJqpJ5rT4qm6j/8ja+P0Ig
         CIyCcq/XDQVDjhIuycQ6ltSG8cMwU+3RDl0Do=
From: Stewart Malik <mali0037@gmail.com>
To: aia21@cantab.net
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Stewart Malik <mali0037@gmail.com>
Subject: [PATCH] FS: NTFS: fix whitespace and pointer issues in mst.c
Date: Sun,  7 Mar 2010 22:20:51 +1030
Message-Id: <1267962651-11217-1-git-send-email-mali0037@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/ntfs/mst.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ntfs/mst.c b/fs/ntfs/mst.c
index 5a858d8..097a4c9 100644
--- a/fs/ntfs/mst.c
+++ b/fs/ntfs/mst.c
@@ -49,13 +49,13 @@ int post_read_mst_fixup(NTFS_RECORD *b, const u32 size)
 	/* Decrement usa_count to get number of fixups. */
 	usa_count = le16_to_cpu(b->usa_count) - 1;
 	/* Size and alignment checks. */
-	if ( size & (NTFS_BLOCK_SIZE - 1)	||
+	if (size & (NTFS_BLOCK_SIZE - 1)	||
 	     usa_ofs & 1			||
 	     usa_ofs + (usa_count * 2) > size	||
 	     (size >> NTFS_BLOCK_SIZE_BITS) != usa_count)
 		return 0;
 	/* Position of usn in update sequence array. */
-	usa_pos = (u16*)b + usa_ofs/sizeof(u16);
+	usa_pos = (u16 *)b + usa_ofs/sizeof(u16);
 	/*
 	 * The update sequence number which has to be equal to each of the
 	 * u16 values before they are fixed up. Note no need to care for
@@ -67,7 +67,7 @@ int post_read_mst_fixup(NTFS_RECORD *b, const u32 size)
 	/*
 	 * Position in protected data of first u16 that needs fixing up.
 	 */
-	data_pos = (u16*)b + NTFS_BLOCK_SIZE/sizeof(u16) - 1;
+	data_pos = (u16 *)b + NTFS_BLOCK_SIZE/sizeof(u16) - 1;
 	/*
 	 * Check for incomplete multi sector transfer(s).
 	 */
@@ -85,7 +85,7 @@ int post_read_mst_fixup(NTFS_RECORD *b, const u32 size)
 	}
 	/* Re-setup the variables. */
 	usa_count = le16_to_cpu(b->usa_count) - 1;
-	data_pos = (u16*)b + NTFS_BLOCK_SIZE/sizeof(u16) - 1;
+	data_pos = (u16 *)b + NTFS_BLOCK_SIZE/sizeof(u16) - 1;
 	/* Fixup all sectors. */
 	while (usa_count--) {
 		/*
@@ -135,13 +135,13 @@ int pre_write_mst_fixup(NTFS_RECORD *b, const u32 size)
 	/* Decrement usa_count to get number of fixups. */
 	usa_count = le16_to_cpu(b->usa_count) - 1;
 	/* Size and alignment checks. */
-	if ( size & (NTFS_BLOCK_SIZE - 1)	||
+	if (size & (NTFS_BLOCK_SIZE - 1)	||
 	     usa_ofs & 1			||
 	     usa_ofs + (usa_count * 2) > size	||
 	     (size >> NTFS_BLOCK_SIZE_BITS) != usa_count)
 		return -EINVAL;
 	/* Position of usn in update sequence array. */
-	usa_pos = (le16*)((u8*)b + usa_ofs);
+	usa_pos = (le16 *)((u8 *)b + usa_ofs);
 	/*
 	 * Cyclically increment the update sequence number
 	 * (skipping 0 and -1, i.e. 0xffff).
@@ -152,7 +152,7 @@ int pre_write_mst_fixup(NTFS_RECORD *b, const u32 size)
 	le_usn = cpu_to_le16(usn);
 	*usa_pos = le_usn;
 	/* Position in data of first u16 that needs fixing up. */
-	data_pos = (le16*)b + NTFS_BLOCK_SIZE/sizeof(le16) - 1;
+	data_pos = (le16 *)b + NTFS_BLOCK_SIZE/sizeof(le16) - 1;
 	/* Fixup all sectors. */
 	while (usa_count--) {
 		/*
@@ -184,10 +184,10 @@ void post_write_mst_fixup(NTFS_RECORD *b)
 	u16 usa_count = le16_to_cpu(b->usa_count) - 1;
 
 	/* Position of usn in update sequence array. */
-	usa_pos = (le16*)b + usa_ofs/sizeof(le16);
+	usa_pos = (le16 *)b + usa_ofs/sizeof(le16);
 
 	/* Position in protected data of first u16 that needs fixing up. */
-	data_pos = (le16*)b + NTFS_BLOCK_SIZE/sizeof(le16) - 1;
+	data_pos = (le16 *)b + NTFS_BLOCK_SIZE/sizeof(le16) - 1;
 
 	/* Fixup all sectors. */
 	while (usa_count--) {
-- 
1.6.0.4

