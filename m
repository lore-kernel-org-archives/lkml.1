Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYFFP6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYFFP6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbYFFPze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:55:34 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51794 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757151AbYFFPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:55:27 -0400
Message-Id: <20080606155526.851463798@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:51:29 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, Harald Welte <laforge@openmoko.org>,
       Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 12/15] MMC: S3C24XX MMC/SD driver fixes for sg_ access.
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-2624-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sg_ usage in the S3C24XX MMC driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q.orig/drivers/mmc/host/s3cmci.c	2008-06-06 15:47:28.000000000 +0100
+++ linux-2.6.26-rc5-q/drivers/mmc/host/s3cmci.c	2008-06-06 15:47:30.000000000 +0100
@@ -204,7 +204,7 @@ static inline int get_data_buffer(struct
 	sg = &host->mrq->data->sg[host->pio_sgptr];
 
 	*words	= sg->length >> 2;
-	*pointer= page_address(sg->page) + sg->offset;
+	*pointer= sg_virt(sg);
 
 	host->pio_sgptr++;
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
