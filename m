Return-Path: <linux-kernel-owner+w=401wt.eu-S1751817Ab0ATMfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0ATMfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181Ab0ATMfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:35:20 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:61449 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081Ab0ATMfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:35:19 -0500
Date: Wed, 20 Jan 2010 13:35:40 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, ok@artecdesign.ee,
       sarah.a.sharp@linux.intel.com
Cc: siccegge@stud.informatik.uni-erlangen.de,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] Obsolete config in kernel source (USB_HCD_DMA)
Message-ID: <20100120123540.GB3580@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	Similar to the config Option USB_HCD_STAT there's another
Zombi called USB_HCD_DMA only present in
./drivers/usb/host/isp1362-hcd.c The attached patch would just drop
the unreachable parts if you agree that's the correct solution.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger


--IJpNTDwzlM2Ie8A6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-The-configuration-Option-USB_HCD_DMA-is-not-reachabl.patch"

>From 2e5a8a322a6cd74ecb77eda8f0a09a0a01c6dbc6 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 20 Jan 2010 13:32:36 +0100
Subject: [PATCH] The configuration Option USB_HCD_DMA is not reachable in KConfig so
 this piece of Code is effectively dead and useless. Remove it to avoid
 confusion.


Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/usb/host/isp1362-hcd.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 73352f3..341db2c 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2716,24 +2716,11 @@ static int __init isp1362_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-#ifdef CONFIG_USB_HCD_DMA
-	if (pdev->dev.dma_mask) {
-		struct resource *dma_res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-
-		if (!dma_res) {
-			retval = -ENODEV;
-			goto err1;
-		}
-		isp1362_hcd->data_dma = dma_res->start;
-		isp1362_hcd->max_dma_size = resource_len(dma_res);
-	}
-#else
 	if (pdev->dev.dma_mask) {
 		DBG(1, "won't do DMA");
 		retval = -ENODEV;
 		goto err1;
 	}
-#endif
 
 	if (!request_mem_region(addr->start, resource_len(addr), hcd_name)) {
 		retval = -EBUSY;
-- 
1.6.3.3


--IJpNTDwzlM2Ie8A6--
