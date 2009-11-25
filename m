Return-Path: <linux-kernel-owner+w=401wt.eu-S1759142AbZKYREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142AbZKYREt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759135AbZKYREs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:48 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53682 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129AbZKYREq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gNYPtzNbCpGDZzB8FUoTe1qxAZE97OckxKdZT3Wd7+9SOo90jS2fTuZgh08AkZdFuY
         hYPiIrQQA2SxMEegzDTBReWgUkn5VaWLRawdE2WCdh+iGtomeTKk/fSrs7pZW+RSGMCG
         7f3BGqKHaafY18hX/y3Zi2NIOFSWQac4CPkAU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:04:08 +0100
Message-Id: <20091125170408.5446.92212.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 15/86] pata_efar: fix wrong MWDMA timings being programmed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_efar: fix wrong MWDMA timings being programmed

Do not clear MWDMA timings for device on the other port when
programming slave device.

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
@@ -201,7 +201,7 @@ static void efar_set_dmamode (struct ata
 			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
 			master_data |= control << 4;
 			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (0x0F + 0xE1 * ap->port_no);
+			slave_data &= ap->port_no ? 0x0F : 0xF0;
 			/* Load the matching timing */
 			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
 			pci_write_config_byte(dev, 0x44, slave_data);
