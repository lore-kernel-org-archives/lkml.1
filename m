Return-Path: <linux-kernel-owner+w=401wt.eu-S1765185AbXHDQkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765185AbXHDQkH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 12:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764295AbXHDQjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 12:39:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38487 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764185AbXHDQjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 12:39:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 4 Aug 2007 18:39:34 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit DMA mapping"
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.f06cfd50476dd0f7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Wed, 1 Aug 2007 20:30:36 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: revert "sbp2: enforce 32bit DMA mapping"

Revert commit 0555659d63c285ceb7ead3115532e1b71b0f27a7 from 2.6.22-rc1.
The dma_set_mask call somehow failed on a PowerMac G5, PPC64:
http://lkml.org/lkml/2007/8/1/344

Should there ever occur a DMA mapping beyond the physical DMA range, a
proper SBP-2 firmware will report transport errors.  So let's leave it
at that.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Tested-by: Olaf Hering <olh@suse.de>
---
Same as commit a9c2f18800753c82c45fc13b27bdc148849bdbb2.

 drivers/ieee1394/sbp2.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-2.6.22/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.22.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.22/drivers/ieee1394/sbp2.c
@@ -774,11 +774,6 @@ static struct sbp2_lu *sbp2_alloc_device
 			SBP2_ERR("failed to register lower 4GB address range");
 			goto failed_alloc;
 		}
-#else
-		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
-			SBP2_ERR("failed to set 4GB DMA mask");
-			goto failed_alloc;
-		}
 #endif
 	}
 

-- 
Stefan Richter
-=====-=-=== =--- --=--
http://arcgraph.de/sr/

