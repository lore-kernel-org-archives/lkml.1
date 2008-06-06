Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbYFFP5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbYFFP5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbYFFPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:32 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51782 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756565AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155526.079959028@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:25 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 08/15] MMC: Ensure host->mrq->data is valid in S3C24XX driver
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-piotasklet-crashfix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a crash if host->mrq->data is NULL on ending a transfer.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:30.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:46:32.000000000 +0100
@@ -330,7 +330,8 @@ static void pio_tasklet(unsigned long da
 				(host->pio_active == XFER_READ)?"read":"write",
 				host->pio_count, host->pio_words);
 
-			host->mrq->data->error = MMC_ERR_DMA;
+			if (host->mrq->data)
+				host->mrq->data->error = MMC_ERR_DMA;
 		}
 
 		finalize_request(host);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
