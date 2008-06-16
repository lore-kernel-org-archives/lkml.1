Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYFPOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYFPOiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbYFPOfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:30 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50220 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752494AbYFPOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:15 -0400
Message-Id: <20080616143514.126310469@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:56 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 11/16] MMC: S3C24XX: Fix s3c2410_dma_request() return code check.
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-dma-retcode-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver should be checking for a negative error code from
s3c2410_dma_request(), not non-zero. Newer kernels now return
the DMA channel number that was allocated by the request.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-16 15:25:04.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-16 15:25:06.000000000 +0100
@@ -1206,7 +1206,7 @@ static int s3cmci_probe(struct platform_
 		s3c2410_gpio_cfgpin(host->pdata->gpio_wprotect,
 				    S3C2410_GPIO_INPUT);
 
-	if (s3c2410_dma_request(S3CMCI_DMA, &s3cmci_dma_client, NULL)) {
+	if (s3c2410_dma_request(S3CMCI_DMA, &s3cmci_dma_client, NULL) < 0) {
 		dev_err(&pdev->dev, "unable to get DMA channel.\n");
 		ret = -EBUSY;
 		goto probe_free_irq_cd;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
