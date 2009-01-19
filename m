Return-Path: <linux-kernel-owner+w=401wt.eu-S1750880AbZASORu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbZASORu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZASOOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:14:33 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49200 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZASOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:14:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Mgpffk/dfdROvTMorHENYrZEtr4twSJ38Z4wTAQTgoRLJPigcDWY21a4TwJAc96yYF
         pNGk5WDmJwvXQKaNhmWa5iUlFyTAxoJttbbK8vsY8ER7aw9sxXGdgcjRUo+IPJmDIpy0
         M90N/dyB73nq/S1eyfExNLry7MR9Ja2pUusD4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2009 15:14:50 +0100
Message-Id: <20090119141450.27613.72820.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
References: <20090119141330.27613.34546.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/12] amd74xx: remove no longer needed ->init_hwif method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] amd74xx: remove no longer needed ->init_hwif method

This is now handled by core IDE PCI code.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/amd74xx.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -183,14 +183,6 @@ static u8 amd_cable_detect(ide_hwif_t *h
 		return ATA_CBL_PATA40;
 }
 
-static void __devinit init_hwif_amd74xx(ide_hwif_t *hwif)
-{
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-
-	if (ide_pci_is_in_compatibility_mode(dev))
-		hwif->irq = pci_get_legacy_ide_irq(dev, hwif->channel);
-}
-
 static const struct ide_port_ops amd_port_ops = {
 	.set_pio_mode		= amd_set_pio_mode,
 	.set_dma_mode		= amd_set_drive,
@@ -207,7 +199,6 @@ static const struct ide_port_ops amd_por
 	{								\
 		.name		= DRV_NAME,				\
 		.init_chipset	= init_chipset_amd74xx,			\
-		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x40,0x02,0x02}, {0x40,0x01,0x01}},	\
 		.port_ops	= &amd_port_ops,			\
 		.host_flags	= IDE_HFLAGS_AMD,			\
@@ -221,7 +212,6 @@ static const struct ide_port_ops amd_por
 	{								\
 		.name		= DRV_NAME,				\
 		.init_chipset	= init_chipset_amd74xx,			\
-		.init_hwif	= init_hwif_amd74xx,			\
 		.enablebits	= {{0x50,0x02,0x02}, {0x50,0x01,0x01}},	\
 		.port_ops	= &amd_port_ops,			\
 		.host_flags	= IDE_HFLAGS_AMD,			\
