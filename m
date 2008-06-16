Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYFPOi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYFPOi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbYFPOf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:28 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50227 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754060AbYFPOfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:15 -0400
Message-Id: <20080616143514.557006971@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:58 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 13/16] MMC: S3C24XX: MMC/SD driver fix use of sg lists.
Content-Disposition: inline; filename=simtec/s3c24xx-sdmmc-2624-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sg_ usage in the S3C24XX MMC driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-08 14:02:34.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-08 14:02:36.000000000 +0100
@@ -205,7 +205,7 @@ static inline int get_data_buffer(struct
 	sg = &host->mrq->data->sg[host->pio_sgptr];
 
 	*words = sg->length >> 2;
-	*pointer = page_address(sg->page) + sg->offset;
+	*pointer = sg_virt(sg);
 
 	host->pio_sgptr++;
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
