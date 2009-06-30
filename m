Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZF3ADA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZF3ADA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbZF3ACT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:02:19 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3391 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbZF3ACR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:02:17 -0400
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, pierre@ossman.eu, swetland@google.com,
       Andrew Morton <akpm@linux-foundation.org>, San Mehat <san@google.com>
Subject: [PATCH 2/3] msm_sdcc.c: stylistic cleaning
Date: Mon, 29 Jun 2009 17:02:04 -0700
Message-Id: <8ffbdda89b1754b6406d5da385747d8a94626bb9.1246319479.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246319479.git.joe@perches.com>
References: <20090629214101.GA12043@elf.ucw.cz> <cover.1246319479.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a bit more like typical kernel style

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/host/msm_sdcc.c |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 31a2837..d4ce7b8 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -43,7 +43,6 @@
 #include <mach/dma.h>
 #include <mach/htc_pwrsink.h>
 
-
 #include "msm_sdcc.h"
 
 #define DRIVER_NAME "msm-sdcc"
@@ -96,16 +95,17 @@ msmsdcc_stop_data(struct msmsdcc_host *host)
 
 uint32_t msmsdcc_fifo_addr(struct msmsdcc_host *host)
 {
-	if (host->pdev_id == 1)
+	switch (host->pdev_id) {
+	case 1:
 		return MSM_SDC1_PHYS + MMCIFIFO;
-	else if (host->pdev_id == 2)
+	case 2:
 		return MSM_SDC2_PHYS + MMCIFIFO;
-	else if (host->pdev_id == 3)
+	case 3:
 		return MSM_SDC3_PHYS + MMCIFIFO;
-	else if (host->pdev_id == 4)
+	case 4:
 		return MSM_SDC4_PHYS + MMCIFIFO;
-	else
-		BUG();
+	}
+	BUG();
 	return 0;
 }
 
@@ -154,8 +154,8 @@ msmsdcc_dma_complete_func(struct msm_dmov_cmd *cmd,
 		struct scatterlist *sg = host->dma.sg;
 		int i;
 
-		for (i = 0; i < host->dma.num_ents; i++, sg++)
-			flush_dcache_page(sg_page(sg));
+		for (i = 0; i < host->dma.num_ents; i++)
+			flush_dcache_page(sg_page(sg++));
 	}
 
 	host->dma.sg = NULL;
@@ -220,15 +220,20 @@ static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
 
 	nc = host->dma.nc;
 
-	if (host->pdev_id == 1)
+	switch (host->pdev_id) {
+	case 1:
 		crci = MSMSDCC_CRCI_SDC1;
-	else if (host->pdev_id == 2)
+		break;
+	case 2:
 		crci = MSMSDCC_CRCI_SDC2;
-	else if (host->pdev_id == 3)
+		break;
+	case 3:
 		crci = MSMSDCC_CRCI_SDC3;
-	else if (host->pdev_id == 4)
+		break;
+	case 4:
 		crci = MSMSDCC_CRCI_SDC4;
-	else {
+		break;
+	default:
 		host->dma.sg = NULL;
 		host->dma.num_ents = 0;
 		return -ENOENT;
@@ -242,7 +247,7 @@ static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
 	host->curr.user_pages = 0;
 
 	n = dma_map_sg(mmc_dev(host->mmc), host->dma.sg,
-			host->dma.num_ents, host->dma.dir);
+		       host->dma.num_ents, host->dma.dir);
 
 	if (n != host->dma.num_ents) {
 		pr_err("%s: Unable to map in all sg elements\n",
@@ -316,7 +321,7 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data)
 	memset(&host->pio, 0, sizeof(host->pio));
 
 	clks = (unsigned long long)data->timeout_ns * host->clk_rate;
-	do_div(clks, 1000000000UL);
+	do_div(clks, NSECS_PER_SEC);
 	timeout = data->timeout_clks + (unsigned int)clks;
 	writel(timeout, base + MMCIDATATIMER);
 
@@ -369,9 +374,9 @@ msmsdcc_start_command(struct msmsdcc_host *host, struct mmc_command *cmd, u32 c)
 		c |= MCI_CPSM_RESPONSE;
 	}
 
-	if ((((cmd->opcode == 17) || (cmd->opcode == 18))  ||
-	     ((cmd->opcode == 24) || (cmd->opcode == 25))) ||
-	      (cmd->opcode == 53))
+	if (cmd->opcode == 17 || cmd->opcode == 18 ||
+	    cmd->opcode == 24 || cmd->opcode == 25 ||
+	    cmd->opcode == 53)
 		c |= MCI_CSPM_DATCMD;
 
 	if (cmd == cmd->mrq->stop)
-- 
1.6.3.1.10.g659a0.dirty

