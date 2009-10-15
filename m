Return-Path: <linux-kernel-owner+w=401wt.eu-S935129AbZJOLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935129AbZJOLnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935120AbZJOLnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:43:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59881 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935119AbZJOLnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:43:17 -0400
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
To: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, vipin.bhandari@ti.com,
       akpm@linux-foundation.org, Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: [PATCH] DaVinci: MMC: Modify data types of EDMA related variables
Date: Thu, 15 Oct 2009 17:07:57 +0530
Message-Id: <1255606677-30219-1-git-send-email-sudhakar.raj@ti.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudhakar Rajashekhara <sudhakar.raj@ti.com> 

Currently DaVinci EDMA driver supports multiple EDMA channel
controller instances. edma_alloc_channel() api returns a 32
bit value which has the channel controller number in MSB and
the EDMA channel number in LSB. The variables which store the
value returned by edma_alloc_channel() have to be 32 bit wide
now.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Acked-by: Vipin Bhandari <vipin.bhandari@ti.com>
---
 This patch applies on top of the following patch submitted by
 Vipin Bhandari <vipin.bhandari@ti.com>,
 http://patchwork.kernel.org/patch/50914/.

 drivers/mmc/host/davinci_mmc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index fe8f613..6c76f64 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -178,7 +178,7 @@ struct mmc_davinci_host {
 	u32 buffer_bytes_left;
 	u32 bytes_left;
 
-	u8 rxdma, txdma;
+	u32 rxdma, txdma;
 	bool use_dma;
 	bool do_dma;
 
@@ -190,7 +190,7 @@ struct mmc_davinci_host {
 	struct edmacc_param	tx_template;
 	struct edmacc_param	rx_template;
 	unsigned		n_link;
-	u8			links[NR_SG - 1];
+	u32			links[NR_SG - 1];
 
 	/* For PIO we walk scatterlists one segment at a time. */
 	unsigned int		sg_len;
-- 
1.5.6

