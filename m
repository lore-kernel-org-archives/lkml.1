Return-Path: <linux-kernel-owner+w=401wt.eu-S1764436AbYF3VvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764436AbYF3VvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933480AbYF3Vl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:27 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50433 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933334AbYF3VlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:12 -0400
Message-Id: <20080630214111.148951956@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:35 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 12/16] MMC: S3C24XX: Fix use of msecs where jiffies are needed
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-detectchangefix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_detect_change() takes jiffies, not msecs. Convert the
previous value of msecs into jiffies before calling.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:55.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:57.000000000 +0100
@@ -584,7 +584,7 @@ static irqreturn_t s3cmci_irq_cd(int irq
 
 	dbg(host, dbg_irq, "card detect\n");
 
-	mmc_detect_change(host->mmc, 500);
+	mmc_detect_change(host->mmc, msecs_to_jiffies(500));
 
 	return IRQ_HANDLED;
 }

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
