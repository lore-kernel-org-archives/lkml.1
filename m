Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYA3Iom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYA3Iom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbYA3Inj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:43:39 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:25724 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbYA3Inf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:43:35 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47621650"
From: Bryan Wu <bryan.wu@analog.com>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 4/4] [libata] Blackfin pata-bf54x driver: fix compiling bug - no ata_port struct in struct ata_device any more
Date: Wed, 30 Jan 2008 16:43:28 +0800
Message-Id: <1201682608-22827-5-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201682608-22827-1-git-send-email-bryan.wu@analog.com>
References: <1201682608-22827-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/ata/pata_bf54x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index d66f773..7f87f10 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -299,7 +299,7 @@ static void bfin_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	*/
 	n6 = num_clocks_min(t6min, fsclk);
 	if (mode >= 0 && mode <= 4 && n6 >= 1) {
-		dev_dbg(adev->ap->dev, "set piomode: mode=%d, fsclk=%ud\n", mode, fsclk);
+		dev_dbg(adev->link->ap->dev, "set piomode: mode=%d, fsclk=%ud\n", mode, fsclk);
 		/* calculate the timing values for register transfers. */
 		while (mode > 0 && pio_fsclk[mode] > fsclk)
 			mode--;
@@ -376,7 +376,7 @@ static void bfin_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	mode = adev->dma_mode - XFER_UDMA_0;
 	if (mode >= 0 && mode <= 5) {
-		dev_dbg(adev->ap->dev, "set udmamode: mode=%d\n", mode);
+		dev_dbg(adev->link->ap->dev, "set udmamode: mode=%d\n", mode);
 		/* the most restrictive timing value is t6 and tc,
 		 * the DIOW - data hold. If one SCLK pulse is longer
 		 * than this minimum value then register
@@ -433,7 +433,7 @@ static void bfin_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	mode = adev->dma_mode - XFER_MW_DMA_0;
 	if (mode >= 0 && mode <= 2) {
-		dev_dbg(adev->ap->dev, "set mdmamode: mode=%d\n", mode);
+		dev_dbg(adev->link->ap->dev, "set mdmamode: mode=%d\n", mode);
 		/* the most restrictive timing value is tf, the DMACK to
 		 * read data released. If one SCLK pulse is longer than
 		 * this maximum value then the MDMA mode
-- 
1.5.3.4
