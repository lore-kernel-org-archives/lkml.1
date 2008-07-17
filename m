Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbYGQV5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbYGQV5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbYGQV5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:57:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:6499 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbYGQV5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MNK3TUUbROj2kV4pDxDhFYuj3f6z/bxb94YUvnhjGpRtcbxBKXvEBGiRhGvywfCXp7
         dNiGFfnevH3R/XeXNGsVhMkmzQ4o3eDBtykMseoA6OVfJNJO2v2sJ9lYf+k+Z+qdm8RK
         5WrhXU7flb/R68hyYUiOrBBU6GXj7yH2sRlXI=
Subject: [PATCH] mtd: diskonchip.c fix sparse endian warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 14:57:01 -0700
Message-Id: <1216331821.6029.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Al, I know you won't like this for the same reasons as the dlm patch,
but I had it already done.

 drivers/mtd/nand/diskonchip.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index 765d4f0..e4226e0 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1125,9 +1125,9 @@ static inline int __init nftl_partscan(struct mtd_info *mtd, struct mtd_partitio
 		goto out;
 	mh = (struct NFTLMediaHeader *)buf;
 
-	mh->NumEraseUnits = le16_to_cpu(mh->NumEraseUnits);
-	mh->FirstPhysicalEUN = le16_to_cpu(mh->FirstPhysicalEUN);
-	mh->FormattedSize = le32_to_cpu(mh->FormattedSize);
+	le16_to_cpus(&mh->NumEraseUnits);
+	le16_to_cpus(&mh->FirstPhysicalEUN);
+	le32_to_cpus(&mh->FormattedSize);
 
 	printk(KERN_INFO "    DataOrgID        = %s\n"
 			 "    NumEraseUnits    = %d\n"
@@ -1235,12 +1235,12 @@ static inline int __init inftl_partscan(struct mtd_info *mtd, struct mtd_partiti
 	doc->mh1_page = doc->mh0_page + (4096 >> this->page_shift);
 	mh = (struct INFTLMediaHeader *)buf;
 
-	mh->NoOfBootImageBlocks = le32_to_cpu(mh->NoOfBootImageBlocks);
-	mh->NoOfBinaryPartitions = le32_to_cpu(mh->NoOfBinaryPartitions);
-	mh->NoOfBDTLPartitions = le32_to_cpu(mh->NoOfBDTLPartitions);
-	mh->BlockMultiplierBits = le32_to_cpu(mh->BlockMultiplierBits);
-	mh->FormatFlags = le32_to_cpu(mh->FormatFlags);
-	mh->PercentUsed = le32_to_cpu(mh->PercentUsed);
+	le32_to_cpus(&mh->NoOfBootImageBlocks);
+	le32_to_cpus(&mh->NoOfBinaryPartitions);
+	le32_to_cpus(&mh->NoOfBDTLPartitions);
+	le32_to_cpus(&mh->BlockMultiplierBits);
+	le32_to_cpus(&mh->FormatFlags);
+	le32_to_cpus(&mh->PercentUsed);
 
 	printk(KERN_INFO "    bootRecordID          = %s\n"
 			 "    NoOfBootImageBlocks   = %d\n"
@@ -1277,12 +1277,12 @@ static inline int __init inftl_partscan(struct mtd_info *mtd, struct mtd_partiti
 	/* Scan the partitions */
 	for (i = 0; (i < 4); i++) {
 		ip = &(mh->Partitions[i]);
-		ip->virtualUnits = le32_to_cpu(ip->virtualUnits);
-		ip->firstUnit = le32_to_cpu(ip->firstUnit);
-		ip->lastUnit = le32_to_cpu(ip->lastUnit);
-		ip->flags = le32_to_cpu(ip->flags);
-		ip->spareUnits = le32_to_cpu(ip->spareUnits);
-		ip->Reserved0 = le32_to_cpu(ip->Reserved0);
+		le32_to_cpus(&ip->virtualUnits);
+		le32_to_cpus(&ip->firstUnit);
+		le32_to_cpus(&ip->lastUnit);
+		le32_to_cpus(&ip->flags);
+		le32_to_cpus(&ip->spareUnits);
+		le32_to_cpus(&ip->Reserved0);
 
 		printk(KERN_INFO	"    PARTITION[%d] ->\n"
 			"        virtualUnits    = %d\n"
-- 
1.5.6.3.569.ga9185



