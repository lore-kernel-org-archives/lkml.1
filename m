Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbYF3VsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbYF3VsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933378AbYF3VlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:41:20 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50419 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933467AbYF3VlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:41:11 -0400
Message-Id: <20080630214110.221399865@fluff.org.uk>
References: <20080630214023.140288591@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 30 Jun 2008 22:40:31 +0100
From: ben@fluff.org.uk
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Cc: laforge@openmoko.org, tk@maintech.de, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v5 08/16] MMC: S3C24XX: Ensure host->mrq->data is valid
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-piotasklet-crashfix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a crash if host->mrq->data is NULL on ending a transfer.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc8-next20080627.orig/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:42.000000000 +0100
+++ linux-2.6.26-rc8-next20080627/drivers/mmc/host/s3cmci.c	2008-06-30 12:36:49.000000000 +0100
@@ -353,7 +353,8 @@ static void pio_tasklet(unsigned long da
 			    (host->pio_active == XFER_READ) ? "read" : "write",
 			    host->pio_count, host->pio_words);
 
-			host->mrq->data->error = -EINVAL;
+			if (host->mrq->data)
+				host->mrq->data->error = -EINVAL;
 		}
 
 		finalize_request(host);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
