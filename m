Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbYDTA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbYDTA2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 20:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbYDTA1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 20:27:54 -0400
Received: from ozlabs.org ([203.10.76.45]:34477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbYDTA1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 20:27:47 -0400
To: David Airlie <airlied@linux.ie>
CC: <linux-kernel@vger.kernel.org>, <stevewin@us.ibm.com>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sun, 20 Apr 2008 10:26:31 +1000
Subject: [PATCH 2/2] drm: Remove unneeded dma sync in ATI pcigart alloc
Message-Id: <20080420002746.DDF2EDE36E@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the ATI pcigart code uses dma_alloc_coherent, we don't need
the dma_sync_single_for_device() that we used to have here.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Probably not stable material as it won't hurt not to remove it.

 drivers/char/drm/ati_pcigart.c |    7 -------
 1 file changed, 7 deletions(-)

--- linux-work.orig/drivers/char/drm/ati_pcigart.c	2008-04-19 16:52:23.000000000 +1000
+++ linux-work/drivers/char/drm/ati_pcigart.c	2008-04-19 16:54:00.000000000 +1000
@@ -167,13 +167,6 @@ int drm_ati_pcigart_init(struct drm_devi
 			page_base += ATI_PCIGART_PAGE_SIZE;
 		}
 	}
-
-	if (gart_info->gart_table_location == DRM_ATI_GART_MAIN)
-		dma_sync_single_for_device(&dev->pdev->dev,
-					   bus_address,
-					   max_pages * sizeof(u32),
-					   PCI_DMA_TODEVICE);
-
 	ret = 1;
 
 #if defined(__i386__) || defined(__x86_64__)
