Return-Path: <linux-kernel-owner+w=401wt.eu-S1762586AbXGaNNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762586AbXGaNNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761851AbXGaNKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:10:11 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761834AbXGaNKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:10:09 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125442.002407000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:23 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [Patch 07/16] Remove unnecessary kmalloc casts in the mtd drivers.
Content-Disposition: inline; filename=drivers_mtd_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: David Woodhouse <dwmw2@infradead.org>

---
 drivers/mtd/maps/pmcmsp-flash.c |   11 ++++-------
 drivers/mtd/maps/tqm8xxl.c      |    2 +-
 2 files changed, 5 insertions(+), 8 deletions(-)

Index: b/drivers/mtd/maps/pmcmsp-flash.c
===================================================================
--- a/drivers/mtd/maps/pmcmsp-flash.c
+++ b/drivers/mtd/maps/pmcmsp-flash.c
@@ -73,12 +73,9 @@ int __init init_msp_flash(void)
 		return -ENXIO;
 
 	printk(KERN_NOTICE "Found %d PMC flash devices\n", fcnt);
-	msp_flash = (struct mtd_info **)kmalloc(
-			fcnt * sizeof(struct map_info *), GFP_KERNEL);
-	msp_parts = (struct mtd_partition **)kmalloc(
-			fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
-	msp_maps = (struct map_info *)kmalloc(
-			fcnt * sizeof(struct mtd_info), GFP_KERNEL);
+	msp_flash = kmalloc(fcnt * sizeof(struct map_info *), GFP_KERNEL);
+	msp_parts = kmalloc(fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
+	msp_maps  = kmalloc(fcnt * sizeof(struct mtd_info), GFP_KERNEL);
 	memset(msp_maps, 0, fcnt * sizeof(struct mtd_info));
 
 	/* loop over the flash devices, initializing each */
@@ -95,7 +92,7 @@ int __init init_msp_flash(void)
 			continue;
 		}
 
-		msp_parts[i] = (struct mtd_partition *)kmalloc(
+		msp_parts[i] = kmalloc(
 			pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
 		memset(msp_parts[i], 0, pcnt * sizeof(struct mtd_partition));
 
Index: b/drivers/mtd/maps/tqm8xxl.c
===================================================================
--- a/drivers/mtd/maps/tqm8xxl.c
+++ b/drivers/mtd/maps/tqm8xxl.c
@@ -141,7 +141,7 @@ int __init init_tqm_mtd(void)
 			goto error_mem;
 		}
 
-		map_banks[idx]->name = (char *)kmalloc(16, GFP_KERNEL);
+		map_banks[idx]->name = kmalloc(16, GFP_KERNEL);
 
 		if (!map_banks[idx]->name) {
 			ret = -ENOMEM;

-- 
