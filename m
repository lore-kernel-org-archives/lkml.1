Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbZKYRE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbZKYRE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759154AbZKYREz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149AbZKYREx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=sSEnfEdZ4tTnGYu5wOAxxUCZX6coh1T9zqPvG62Z2PV2SZZR6q7W420PLVzU674C/K
         M37mT6ZXooGtUUfoO1GB7mpZqMMKMM5/KaNHDm6iMxKMuNmMGCzmbrE0Bvaa2DTZFO1p
         UiWcfcDyIiVk8RlWHtk7EIQPDG2a+cqfDWpIU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:04:15 +0100
Message-Id: <20091125170415.5446.15073.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 16/86] pata_efar: MWDMA0 is unsupported
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_efar: MWDMA0 is unsupported

MWDMA0 timings cannot be met with the PIIX based controller
programming interface.

This change should be safe as this is how we have been doing
things in IDE slc90e66 host driver for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -252,7 +252,7 @@ static int efar_init_one (struct pci_dev
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &efar_ops,
 	};
