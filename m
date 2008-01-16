Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYAPXSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYAPXSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYAPXOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:14:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:10937 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbYAPXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:14:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RT6+PEkJ/mG2NgSbK1p8rqm97VJLfGsHbbo6abvjsxjcTc7l8MdUVl3JW9JqEzilLaeWa4yf7lacqTwcaoglPeBkyZWv1Pfehc1jo5+hQti0dH5laou6NT/A/6kiSARb+A59Jgo30t+9IB79nq4NcBwy4zYh0FwkPafNfOzkuIM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:27:23 +0100
Message-Id: <20080116232723.9166.48965.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/22] ide: move blk_register_region() call out from init_gendisk()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move blk_register_region() call out from init_gendisk() to hwif_init().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1200,8 +1200,6 @@ static void init_gendisk (ide_hwif_t *hw
 		drive->gendev.driver_data = drive;
 		drive->gendev.release = drive_release_dev;
 	}
-	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
-			THIS_MODULE, ata_probe, ata_lock, hwif);
 }
 
 static int hwif_init(ide_hwif_t *hwif)
@@ -1261,6 +1259,8 @@ static int hwif_init(ide_hwif_t *hwif)
 
 done:
 	init_gendisk(hwif);
+	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
+			    THIS_MODULE, ata_probe, ata_lock, hwif);
 	ide_acpi_init(hwif);
 	return 1;
 
