Return-Path: <linux-kernel-owner+w=401wt.eu-S1763697AbYF3Vqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763697AbYF3Vqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbYF3VlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:17 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50407 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933463AbYF3VlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:10 -0400
Message-Id: <20080630214109.196555247@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:26 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 03/16] MMC: DMA free fix for S3C24XX SD/MMC driver
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-dma-free.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harald Welte <laforge@openmoko.org>

Bugfix to ensure DMA channel allocated is freed on exit.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:19:04.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:19:13.000000000 +0100
@@ -1254,6 +1254,7 @@ static int s3cmci_remove(struct platform
 	clk_put(host->clk);
 
 	tasklet_disable(&host->pio_tasklet);
+	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
 
 	free_irq(host->irq_cd, host);
 	free_irq(host->irq, host);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
