Return-Path: <linux-kernel-owner+w=401wt.eu-S934849AbXGaVtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934849AbXGaVtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934673AbXGaVtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:49:09 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2476 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934533AbXGaVtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:49:06 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 65] drivers/mtd/maps/pmcmsp-flash.c: kmalloc + memset conversion to k[cz]alloc
Date: Tue, 31 Jul 2007 23:49:06 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       dwmw2@infradead.org, linux-mtd@lists.infradead.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312349.07329.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mtd/maps/pmcmsp-flash.c | 5540 -> 5454 (-86 bytes)

 drivers/mtd/maps/pmcmsp-flash.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/mtd/maps/pmcmsp-flash.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/mtd/maps/pmcmsp-flash.c	2007-07-31 11:37:49.000000000 +0200
@@ -73,13 +73,16 @@ int __init init_msp_flash(void)
 		return -ENXIO;

 	printk(KERN_NOTICE "Found %d PMC flash devices\n", fcnt);
-	msp_flash = (struct mtd_info **)kmalloc(
-			fcnt * sizeof(struct map_info *), GFP_KERNEL);
-	msp_parts = (struct mtd_partition **)kmalloc(
-			fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
-	msp_maps = (struct map_info *)kmalloc(
-			fcnt * sizeof(struct mtd_info), GFP_KERNEL);
-	memset(msp_maps, 0, fcnt * sizeof(struct mtd_info));
+
+	msp_flash = kmalloc(fcnt * sizeof(struct map_info *), GFP_KERNEL);
+	msp_parts = kmalloc(fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
+	msp_maps = kcalloc(fcnt, sizeof(struct mtd_info), GFP_KERNEL);
+	if (!msp_flash || !msp_parts || !msp_maps) {
+		kfree(msp_maps);
+		kfree(msp_parts);
+		kfree(msp_flash);
+		return -ENOMEM;
+	}

 	/* loop over the flash devices, initializing each */
 	for (i = 0; i < fcnt; i++) {
@@ -95,9 +98,8 @@ int __init init_msp_flash(void)
 			continue;
 		}

-		msp_parts[i] = (struct mtd_partition *)kmalloc(
-			pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
-		memset(msp_parts[i], 0, pcnt * sizeof(struct mtd_partition));
+		msp_parts[i] = kcalloc(pcnt, sizeof(struct mtd_partition),
+				       GFP_KERNEL);

 		/* now initialize the devices proper */
 		flash_name[5] = '0' + i;
