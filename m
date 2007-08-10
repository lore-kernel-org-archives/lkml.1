Return-Path: <linux-kernel-owner+w=401wt.eu-S936926AbXHJM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936926AbXHJM0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763532AbXHJM0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:26:14 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:53936 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196AbXHJM0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:26:12 -0400
Message-ID: <46BC591F.90505@csr.com>
Date: Fri, 10 Aug 2007 13:25:03 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: mmc: ignore bad max block size in sdhci
References: <46BC58E8.50300@csr.com>
In-Reply-To: <46BC58E8.50300@csr.com>
Content-Type: multipart/mixed;
 boundary="------------050800050304080407030303"
X-OriginalArrivalTime: 10 Aug 2007 12:25:16.0544 (UTC) FILETIME=[821DE000:01C7DB49]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050800050304080407030303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------050800050304080407030303
Content-Type: text/x-patch;
 name="mmc-sdhci-ignore-invalid-block-size.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="mmc-sdhci-ignore-invalid-block-size.patch"

mmc: ignore bad max block size in sdhci

Some SDHC cards report an invalid maximum block size, in these cases
assume they support block sizes up to 512 bytes instead of returning
an error.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/drivers/mmc/host/sdhci.c
===================================================================
--- mmc.orig/drivers/mmc/host/sdhci.c	2007-08-10 01:15:54.000000000 +0100
+++ mmc/drivers/mmc/host/sdhci.c	2007-08-10 01:15:58.000000000 +0100
@@ -1344,12 +1344,11 @@
 	 */
 	mmc->max_blk_size = (caps & SDHCI_MAX_BLOCK_MASK) >> SDHCI_MAX_BLOCK_SHIFT;
 	if (mmc->max_blk_size >= 3) {
-		printk(KERN_ERR "%s: Invalid maximum block size.\n",
+		printk(KERN_WARNING "%s: Invalid maximum block size, assuming 512\n",
 			host->slot_descr);
-		ret = -ENODEV;
-		goto unmap;
-	}
-	mmc->max_blk_size = 512 << mmc->max_blk_size;
+		mmc->max_blk_size = 512;
+	} else
+		mmc->max_blk_size = 512 << mmc->max_blk_size;
 
 	/*
 	 * Maximum block count.

--------------050800050304080407030303--
