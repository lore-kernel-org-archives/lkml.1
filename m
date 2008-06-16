Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbYFPOik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbYFPOik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYFPOf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:29 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50213 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753980AbYFPOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:15 -0400
Message-Id: <20080616143513.705507061@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:54 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 09/16] MMC: S3C24XX: Ensure host->mrq->data is valid
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-piotasklet-crashfix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a crash if host->mrq->data is NULL on ending a transfer.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-08 13:59:17.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-08 13:59:20.000000000 +0100
@@ -344,7 +344,8 @@ static void pio_tasklet(unsigned long da
 			    (host->pio_active == XFER_READ) ? "read" : "write",
 			    host->pio_count, host->pio_words);
 
-			host->mrq->data->error = MMC_ERR_DMA;
+			if (host->mrq->data)
+				host->mrq->data->error = MMC_ERR_DMA;
 		}
 
 		finalize_request(host);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
