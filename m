Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660Ab0ASICN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0ASICN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138Ab0ASICM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:02:12 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:57386 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0ASICL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:02:11 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mmc@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/3] mmc: bfin_sdh: fix unused sg warning on BF51x/BF52x systems
Date: Tue, 19 Jan 2010 03:02:09 -0500
Message-Id: <1263888131-25656-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local sg variable is only used with BF54x code.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mmc/host/bfin_sdh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 3343a57..f218a99 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -115,7 +115,6 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 	unsigned int length;
 	unsigned int data_ctl;
 	unsigned int dma_cfg;
-	struct scatterlist *sg;
 
 	dev_dbg(mmc_dev(host->mmc), "%s enter flags: 0x%x\n", __func__, data->flags);
 	host->data = data;
@@ -151,6 +150,7 @@ static int sdh_setup_data(struct sdh_host *host, struct mmc_data *data)
 #if defined(CONFIG_BF54x)
 	dma_cfg |= DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_32 | DMAEN;
 	{
+		struct scatterlist *sg;
 		int i;
 		for_each_sg(data->sg, sg, host->dma_len, i) {
 			host->sg_cpu[i].start_addr = sg_dma_address(sg);
-- 
1.6.6

