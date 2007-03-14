Return-Path: <linux-kernel-owner+w=401wt.eu-S1030805AbXCNJTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030805AbXCNJTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030803AbXCNJTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:19:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60493 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030796AbXCNJTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:19:10 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 8/17] cciss endian annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPdW-0003To-17@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:19:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/block/cciss.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0c716ee..072e18e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1439,7 +1439,7 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 
 		if (return_code == IO_OK) {
 			listlength =
-				be32_to_cpu(*(__u32 *) ld_buff->LUNListLength);
+				be32_to_cpu(*(__be32 *) ld_buff->LUNListLength);
 		} else {	/* reading number of logical volumes failed */
 			printk(KERN_WARNING "cciss: report logical volume"
 			       " command failed\n");
@@ -1961,8 +1961,8 @@ cciss_read_capacity(int ctlr, int logvol, int withirq, sector_t *total_size,
 				ctlr, buf, sizeof(ReadCapdata_struct),
 					1, logvol, 0, NULL, TYPE_CMD);
 	if (return_code == IO_OK) {
-		*total_size = be32_to_cpu(*(__u32 *) buf->total_size);
-		*block_size = be32_to_cpu(*(__u32 *) buf->block_size);
+		*total_size = be32_to_cpu(*(__be32 *) buf->total_size);
+		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
 	} else {		/* read capacity command failed */
 		printk(KERN_WARNING "cciss: read capacity failed\n");
 		*total_size = 0;
@@ -1997,8 +1997,8 @@ cciss_read_capacity_16(int ctlr, int logvol, int withirq, sector_t *total_size,
 				1, logvol, 0, NULL, TYPE_CMD);
 	}
 	if (return_code == IO_OK) {
-		*total_size = be64_to_cpu(*(__u64 *) buf->total_size);
-		*block_size = be32_to_cpu(*(__u32 *) buf->block_size);
+		*total_size = be64_to_cpu(*(__be64 *) buf->total_size);
+		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
 	} else {		/* read capacity command failed */
 		printk(KERN_WARNING "cciss: read capacity failed\n");
 		*total_size = 0;
-- 
1.5.0-rc2.GIT


