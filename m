Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYF3Xxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYF3Xxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYF3XxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:53:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:64574 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbYF3XxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,729,1204531200"; 
   d="scan'208";a="403806298"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/5] MMC: fix spares errors of sdhci.c
Date: Tue,  1 Jul 2008 02:53:03 +0300
Message-Id: <1214869984-20115-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1214869984-20115-3-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
 <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
 <1214869984-20115-3-git-send-email-tomas.winkler@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/host/sdhci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6441e44..aa268e3 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -386,12 +386,12 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	}
 
 	if (host->flags & SDHCI_REQ_USE_DMA) {
-		int count;
+		int dma_cnt;
 
-		count = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+		dma_cnt = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
 				(data->flags & MMC_DATA_READ) ?
 					DMA_FROM_DEVICE : DMA_TO_DEVICE);
-		WARN_ON(count != 1);
+		WARN_ON(dma_cnt != 1);
 
 		writel(sg_dma_address(data->sg),
 			host->ioaddr + SDHCI_DMA_ADDRESS);
@@ -1224,7 +1224,7 @@ int sdhci_add_host(struct sdhci_host *host)
 
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

