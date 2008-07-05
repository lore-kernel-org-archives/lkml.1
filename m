Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYGEQwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYGEQwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 12:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYGEQwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 12:52:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:25039 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYGEQwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 12:52:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,307,1212390000"; 
   d="scan'208";a="349123510"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/2 V2] MMC: fix spares errors of sdhci.c
Date: Sat,  5 Jul 2008 19:52:04 +0300
Message-Id: <1215276725-15588-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. sdhci_prepare_data: fix shadowing of count variable
	u8 count
	int count -> sg_cnt;
2.  sdhci_add_host: assignment of integer to pointer
	dma_mask = 0 -> dma_mask = NULL;

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/host/sdhci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 2eabfac..59db3de 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -672,14 +672,14 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 					host->ioaddr + SDHCI_ADMA_ADDRESS);
 			}
 		} else {
-			int count;
+			int sg_cnt;
 
-			count = dma_map_sg(mmc_dev(host->mmc),
+			sg_cnt = dma_map_sg(mmc_dev(host->mmc),
 					data->sg, data->sg_len,
 					(data->flags & MMC_DATA_READ) ?
 						DMA_FROM_DEVICE :
 						DMA_TO_DEVICE);
-			if (count == 0) {
+			if (sg_cnt == 0) {
 				/*
 				 * This only happens when someone fed
 				 * us an invalid request.
@@ -1583,7 +1583,7 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	/* XXX: Hack to get MMC layer to avoid highmem */
 	if (!(host->flags & SDHCI_USE_DMA))
-		mmc_dev(host->mmc)->dma_mask = 0;
+		mmc_dev(host->mmc)->dma_mask = NULL;
 
 	host->max_clk =
 		(caps & SDHCI_CLOCK_BASE_MASK) >> SDHCI_CLOCK_BASE_SHIFT;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

