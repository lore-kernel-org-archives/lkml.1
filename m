Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZCJX5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZCJX5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZCJX5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:57:22 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:44871 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbZCJX5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:57:21 -0400
Subject: s3cmci: fix s3c2410_dma_config() arguments.
Message-Id: <20090310235711.185285440@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben@simtec.co.uk>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Content-Disposition: inline; filename=dma/dma-fix-s3cmci-dma-config.patch
Date: Tue, 10 Mar 2009 23:57:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben@simtec.co.uk>

The s3cmci driver is calling s3c2410_dma_config with incorrect data
for the DCON register. The S3C2410_DCON_HWTRIG is implicit in the
channel configuration and the device selection of S3C2410_DCON_CH0_SDI
is incorrect as the DMA system may not select channel 0.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>

Index: linux.git/drivers/mmc/host/s3cmci.c
===================================================================
--- linux.git.orig/drivers/mmc/host/s3cmci.c	2009-01-20 09:07:50.000000000 +0000
+++ linux.git/drivers/mmc/host/s3cmci.c	2009-01-20 09:08:11.000000000 +0000
@@ -793,8 +793,7 @@ static void s3cmci_dma_setup(struct s3cm
 			      host->mem->start + host->sdidata);
 
 	if (!setup_ok) {
-		s3c2410_dma_config(host->dma, 4,
-			(S3C2410_DCON_HWTRIG | S3C2410_DCON_CH0_SDI));
+		s3c2410_dma_config(host->dma, 4, 0);
 		s3c2410_dma_set_buffdone_fn(host->dma,
 					    s3cmci_dma_done_callback);
 		s3c2410_dma_setflags(host->dma, S3C2410_DMAF_AUTOSTART);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
