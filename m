Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZLCTwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZLCTwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZLCTwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:52:40 -0500
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57923 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZLCTwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:52:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bdfzqoJdoyFYLtA6farO6dDbcQAnHWoGg0SOZJ7ZFXIdsUWyMyQprYL8ZpLOYjVotM
         ChgmwbJFz4/VpLjH53Zv2iAsLc/fD6T/B/yTisk9AwPSVYmtR1hfBBEPHTXsA1LxeYGG
         Xsw3EcAaCamxBEDAOXf1+WhwP6voGjSdZ/kMY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 03 Dec 2009 20:51:54 +0100
Message-Id: <20091203195154.9093.14693.sendpatchset@localhost>
In-Reply-To: <20091203195145.9093.88261.sendpatchset@localhost>
References: <20091203195145.9093.88261.sendpatchset@localhost>
Subject: [PATCH 1/6] alim15x3: remove obsolete and dangerous wdc_udma parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: remove obsolete and dangerous wdc_udma parameter

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -40,16 +40,6 @@
 #define DRV_NAME "alim15x3"
 
 /*
- * Allow UDMA on M1543C-E chipset for WDC disks that ignore CRC checking
- * (this is DANGEROUS and could result in data corruption).
- */
-static int wdc_udma;
-
-module_param(wdc_udma, bool, 0);
-MODULE_PARM_DESC(wdc_udma,
-		 "allow UDMA on M1543C-E chipset for WDC disks (DANGEROUS)");
-
-/*
  *	ALi devices are not plug in. Otherwise these static values would
  *	need to go. They ought to go away anyway
  */
@@ -132,7 +122,7 @@ static u8 ali_udma_filter(ide_drive_t *d
 	if (m5229_revision > 0x20 && m5229_revision < 0xC2) {
 		if (drive->media != ide_disk)
 			return 0;
-		if (wdc_udma == 0 && chip_is_1543c_e &&
+		if (chip_is_1543c_e &&
 		    strstr((char *)&drive->id[ATA_ID_PROD], "WDC "))
 			return 0;
 	}
