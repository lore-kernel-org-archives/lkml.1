Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbZKYRHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbZKYRHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbZKYRHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:07:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbZKYRHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:07:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=GsRETVst6OS3pnBi8cFD8YoOXWtDcS4gijkvk5GsatDE/VyeE8/eFn/9aevpn7RAlw
         77F0ucsnt/leJ73xm64ELoKd43W0+EiijYUqUpPtE1uUscD0llQBEf4tjpIxOI0qQ8iM
         61TgSw0qSBCg4xqLMJVbS+DkT/6M5SWX2+8AY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:06:58 +0100
Message-Id: <20091125170658.5446.74178.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 39/86] pata_it8213: fix wrong MWDMA timings being programmed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: fix wrong MWDMA timings being programmed

Clear old MWDMA timings before programming new ones (IT8213
is a single port host so there is no need to check ap->port_no).

This change should be safe as this is how we have been doing
things in IDE it8213 host driver for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -211,7 +211,7 @@ static void it8213_set_dmamode (struct a
 			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
 			master_data |= control << 4;
 			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (0x0F + 0xE1 * ap->port_no);
+			slave_data &= 0xF0;
 			/* Load the matching timing */
 			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
 			pci_write_config_byte(dev, 0x44, slave_data);
