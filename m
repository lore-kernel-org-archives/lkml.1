Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbYFPOfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbYFPOfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYFPOfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:15 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50192 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753871AbYFPOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:14 -0400
Message-Id: <20080616143512.624497674@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:49 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 04/16] MMC: DMA free fix for S3C24XX SD/MMC driver
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-dma-free.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@openmoko.org>

Bugfix to ensure DMA channel allocated is freed on exit.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-16 15:24:51.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-16 15:24:52.000000000 +0100
@@ -1245,6 +1245,7 @@ static int s3cmci_remove(struct platform
 	clk_put(host->clk);
 
 	tasklet_disable(&host->pio_tasklet);
+	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
 
 	free_irq(host->irq_cd, host);
 	free_irq(host->irq, host);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
