Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbYFFP4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbYFFP4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760129AbYFFPza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:30 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51788 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756920AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155526.468807471@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:27 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 10/15] MMC: Fix s3c24xx driver s3c2410_dma_request() return code check.
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-dma-retcode-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver should be checking for a negative error code from
s3c2410_dma_request(), not non-zero. Newer kernels now return
the DMA channel number that was allocated by the request.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:34.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:35.000000000 +0100
@@ -1214,7 +1214,7 @@ static int s3cmci_probe(struct platform_
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
