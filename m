Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYHHJzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYHHJzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYHHJzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:55:44 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50833 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753401AbYHHJzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:55:43 -0400
Subject: s3cmci: fix sparse errors from non-exported functions
Message-Id: <20080808095540.450997837@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/sparse/sparse-s3c24xx-mmc.patch
Date: Fri, 08 Aug 2008 10:55:41 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse errors by making the functions
static and fixing the check for host->base.

598:6: warning: symbol 's3cmci_dma_done_callback' was not declared. Should it be static?
744:6: warning: symbol 's3cmci_dma_setup' was not declared. Should it be static?
1209:20: warning: Using plain integer as NULL pointer

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.27-rc2-quilt1/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.27-rc2-quilt1.orig/drivers/mmc/host/s3cmci.c	2008-08-07 14:28:41.000000000 +0100
+++ linux-2.6.27-rc2-quilt1/drivers/mmc/host/s3cmci.c	2008-08-07 14:29:56.000000000 +0100
@@ -595,8 +595,9 @@ static irqreturn_t s3cmci_irq_cd(int irq
 	return IRQ_HANDLED;
 }
 
-void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch, void *buf_id,
-			      int size, enum s3c2410_dma_buffresult result)
+static void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch,
+				     void *buf_id, int size,
+				     enum s3c2410_dma_buffresult result)
 {
 	struct s3cmci_host *host = buf_id;
 	unsigned long iflags;
@@ -740,8 +741,8 @@ request_done:
 	mmc_request_done(host->mmc, mrq);
 }
 
-
-void s3cmci_dma_setup(struct s3cmci_host *host, enum s3c2410_dmasrc source)
+static void s3cmci_dma_setup(struct s3cmci_host *host,
+			     enum s3c2410_dmasrc source)
 {
 	static enum s3c2410_dmasrc last_source = -1;
 	static int setup_ok;
@@ -1206,7 +1207,7 @@ static int __devinit s3cmci_probe(struct
 	}
 
 	host->base = ioremap(host->mem->start, RESSIZE(host->mem));
-	if (host->base == 0) {
+	if (!host->base) {
 		dev_err(&pdev->dev, "failed to ioremap() io memory region.\n");
 		ret = -EINVAL;
 		goto probe_free_mem_region;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
