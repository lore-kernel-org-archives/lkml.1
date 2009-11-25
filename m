Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZKYRGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZKYRGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbZKYRGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:06:12 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41135 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973AbZKYRGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=X/PFNPADGxJrf9o9tBUk2qKCurYeLtqHHhRqkVJkPIy0dlPUO7Nubhnpqj6wPbwCBK
         GfE+4gddgYmoAGmux+hu9mmYLh6PiSpgODzzEZCsBOEtc5UsmiQMxz/EeVvJ2MzrdJxV
         p0gcu6MX9uboXQA4uMC5ZpM1OTmdg0vHZ82wI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:05:32 +0100
Message-Id: <20091125170532.5446.3009.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 27/86] pata_cs5535: no need to program PIO0 timings during device init
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5535: no need to program PIO0 timings during device init

Core libata code takes care of it nowadays.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5535.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: b/drivers/ata/pata_cs5535.c
===================================================================
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -67,8 +67,6 @@
 
 #define CS5535_CABLE_DETECT    0x48
 
-#define CS5535_BAD_PIO(timings) ( (timings&~0x80000000UL)==0x00009172 )
-
 /**
  *	cs5535_cable_detect	-	detect cable type
  *	@ap: Port to detect on
@@ -188,16 +186,6 @@ static int cs5535_init_one(struct pci_de
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
-	u32 timings, dummy;
-
-	/* Check the BIOS set the initial timing clock. If not set the
-	   timings for PIO0 */
-	rdmsr(ATAC_CH0D0_PIO, timings, dummy);
-	if (CS5535_BAD_PIO(timings))
-		wrmsr(ATAC_CH0D0_PIO, 0xF7F4F7F4UL, 0);
-	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
-	if (CS5535_BAD_PIO(timings))
-		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
 	return ata_pci_sff_init_one(dev, ppi, &cs5535_sht, NULL);
 }
 
