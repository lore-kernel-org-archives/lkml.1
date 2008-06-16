Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYFPOjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYFPOjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbYFPOfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:33 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50235 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754152AbYFPOfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:16 -0400
Message-Id: <20080616143514.989414525@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:35:00 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 15/16] MMC: S3C24XX: Fix use of msecs where jiffies are needed
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-detectchangefix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_detect_change() takes jiffies, not msecs. Convert the
previous value of msecs into jiffies before calling.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-08 14:03:03.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-08 14:03:08.000000000 +0100
@@ -578,7 +578,7 @@ static irqreturn_t s3cmci_irq_cd(int irq
 
 	dbg(host, dbg_irq, "card detect\n");
 
-	mmc_detect_change(host->mmc, 500);
+	mmc_detect_change(host->mmc, msecs_to_jiffies(500));
 
 	return IRQ_HANDLED;
 }

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
