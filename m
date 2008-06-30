Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbYF3Vw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbYF3Vw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933484AbYF3Vlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:31 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50427 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933307AbYF3VlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:22 -0400
Message-Id: <20080630214110.691100062@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:33 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 10/16] MMC: S3C24XX: Fix s3c2410_dma_request() return code check.
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-dma-retcode-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver should be checking for a negative error code from
s3c2410_dma_request(), not non-zero. Newer kernels now return
the DMA channel number that was allocated by the request.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:51.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:53.000000000 +0100
@@ -1215,7 +1215,7 @@ static int __devinit s3cmci_probe(struct
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
