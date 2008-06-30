Return-Path: <linux-kernel-owner+w=401wt.eu-S1763142AbYF3Pbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763142AbYF3Pbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbYF3P16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:27:58 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60322 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbYF3P1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:27:50 -0400
Message-Id: <20080630152749.132139232@fluff.org.uk>
References: <20080630152547.755285683@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 16:25:58 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: tk@maintech.de, laforge@openmoko.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v4 11/17] MMC: S3C24XX: Fix s3c2410_dma_request() return code check.
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
