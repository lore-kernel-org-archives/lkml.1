Return-Path: <linux-kernel-owner+w=401wt.eu-S1765197AbYFFP6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765197AbYFFP6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760983AbYFFPzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:35 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51800 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758121AbYFFPz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:28 -0400
Message-Id: <20080606155527.250061367@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:31 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 14/15] MMC: Fix use of msecs where jiffies are needed
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-detectchangefix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_detect_change() takes jiffies, not msecs. Convert the
previous value of msecs into jiffies before calling.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:47:32.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:47:34.000000000 +0100
@@ -567,7 +567,7 @@ static irqreturn_t s3cmci_irq_cd(int irq
 
 	dbg(host, dbg_irq, "card detect\n");
 
-	mmc_detect_change(host->mmc, 500);
+	mmc_detect_change(host->mmc, msecs_to_jiffies(500));
 
 	return IRQ_HANDLED;
 }

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
