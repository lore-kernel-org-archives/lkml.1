Return-Path: <linux-kernel-owner+w=401wt.eu-S1764642AbXJRKvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764642AbXJRKvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764477AbXJRKvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:51:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44751 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764462AbXJRKvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:51:04 -0400
Date: Thu, 18 Oct 2007 12:51:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] pata_cs5536.c: fix array overrun
Message-ID: <20071018105132.GI3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an obvious array overrun spotted by the Coverity 
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9101f2e2691094244bd147a05225f6c84bdf7404 
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 53070f6..00039a1 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -214,7 +214,7 @@ static void cs5536_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		cs5536_read(pdev, DTC, &dtc);
 
 		dtc &= ~(IDE_DRV_MASK << dshift);
-		dtc |= mwdma_timings[mode] << dshift;
+		dtc |= mwdma_timings[mode - XFER_MW_DMA_0] << dshift;
 
 		cs5536_write(pdev, DTC, dtc);
 	}

