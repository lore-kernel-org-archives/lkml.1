Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbYF3Pbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbYF3Pbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbYF3P15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:27:57 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:60331 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752873AbYF3P1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:27:50 -0400
Message-Id: <20080630152749.575618127@fluff.org.uk>
References: <20080630152547.755285683@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 16:26:00 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: tk@maintech.de, laforge@openmoko.org, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v4 13/17] MMC: S3C24XX: Fix use of msecs where jiffies are needed
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
