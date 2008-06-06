Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbYFFPzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbYFFPzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758698AbYFFPz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:28 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51772 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755623AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155525.118638579@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:20 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 03/15] MMC: DMA free fix for S3C24XX SD/MMC driver From: OpenMoko SVN Harald Welte <laforge@openmoko.org>
Content-Disposition: inline; filename=thirdparty/openmoko-mci/s3cmci-dma-free.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugfix to ensure DMA channel allocated is freed on exit.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:45:55.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:45:59.000000000 +0100
@@ -1245,6 +1245,7 @@ static int s3cmci_remove(struct platform
 	mmc_remove_host(mmc);
 	clk_disable(host->clk);
 	clk_put(host->clk);
+	s3c2410_dma_free(S3CMCI_DMA, &s3cmci_dma_client);
  	free_irq(host->irq_cd, host);
  	free_irq(host->irq, host);
 	iounmap(host->base);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
