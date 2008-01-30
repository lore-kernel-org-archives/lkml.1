Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbYA3IoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbYA3IoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbYA3Ing
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:43:36 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:50905 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbYA3Ind (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:43:33 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61202142"
From: Bryan Wu <bryan.wu@analog.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 3/4] [libata] Blackfin pata-bf54x driver: should cover all possible interrupt sources
Date: Wed, 30 Jan 2008 16:43:27 +0800
Message-Id: <1201682608-22827-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201682608-22827-1-git-send-email-bryan.wu@analog.com>
References: <1201682608-22827-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/ata/pata_bf54x.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index d86970a..d66f773 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1147,15 +1147,13 @@ static unsigned char bfin_bmdma_status(struct ata_port *ap)
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 	unsigned short int_status = ATAPI_GET_INT_STATUS(base);
 
-	if (ATAPI_GET_STATUS(base) & (MULTI_XFER_ON|ULTRA_XFER_ON)) {
+	if (ATAPI_GET_STATUS(base) & (MULTI_XFER_ON|ULTRA_XFER_ON))
 		host_stat |= ATA_DMA_ACTIVE;
-	}
-	if (int_status & (MULTI_DONE_INT|UDMAIN_DONE_INT|UDMAOUT_DONE_INT)) {
+	if (int_status & (MULTI_DONE_INT|UDMAIN_DONE_INT|UDMAOUT_DONE_INT|
+		ATAPI_DEV_INT))
 		host_stat |= ATA_DMA_INTR;
-	}
-	if (int_status & (MULTI_TERM_INT|UDMAIN_TERM_INT|UDMAOUT_TERM_INT)) {
-		host_stat |= ATA_DMA_ERR;
-	}
+	if (int_status & (MULTI_TERM_INT|UDMAIN_TERM_INT|UDMAOUT_TERM_INT))
+		host_stat |= ATA_DMA_ERR|ATA_DMA_INTR;
 
 	dev_dbg(ap->dev, "ATAPI: host_stat=0x%x\n", host_stat);
 
-- 
1.5.3.4
