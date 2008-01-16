Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYAPXS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYAPXS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYAPXOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:14:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbYAPXOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:14:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=H6nNpj3sQ+OqMLcl//2L7FRJV0stQn1zxMV2J7OOdIY4xIjtOLuwS8uqNdGPADxyVQ514YoSy4A4zggc5e+dkbxcEZbX+ietiTChHuGXFy4Hsyh2PXR0nWx61M3xTeszU4M2UdFeiaJHXmYK1KPtwv3d9xhat9kjMAhoofNBbBk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:27:30 +0100
Message-Id: <20080116232730.9166.16191.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/22] ide: call init_gendisk() after ide_acpi_init()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1258,10 +1258,10 @@ static int hwif_init(ide_hwif_t *hwif)
 		hwif->name, hwif->irq);
 
 done:
-	init_gendisk(hwif);
 	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
 			    THIS_MODULE, ata_probe, ata_lock, hwif);
 	ide_acpi_init(hwif);
+	init_gendisk(hwif);
 	return 1;
 
 out:
