Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZKYRDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZKYRDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbZKYRDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:03:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZKYRDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=uLX6eo25SbDzB4nwt8au1nBo1WoSB9/5ySKSYNFiIxOT0SLuyY7GTlnu6wKR1aBlxX
         h352MU0e02mIMf+hKHQP2Hqo6XR9fu35j24Xa84w2qMAuIMbvQJutnkHBB5ErOISMSrb
         n+saeezOM9Oemb5hy9S2rM8DnbgDL4UCZXLzE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:02:25 +0100
Message-Id: <20091125170225.5446.50868.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 01/86] ata_piix: fix MWDMA handling on PIIX3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata_piix: fix MWDMA handling on PIIX3

Fix erroneous check for ap->udma_mask in do_pata_set_dmamode()
resulting in controller not being programmed properly for MWDMA.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -869,10 +869,10 @@ static void do_pata_set_dmamode(struct a
 				(timings[pio][1] << 8);
 		}
 
-		if (ap->udma_mask) {
+		if (ap->udma_mask)
 			udma_enable &= ~(1 << devid);
-			pci_write_config_word(dev, master_port, master_data);
-		}
+
+		pci_write_config_word(dev, master_port, master_data);
 	}
 	/* Don't scribble on 0x48 if the controller does not support UDMA */
 	if (ap->udma_mask)
