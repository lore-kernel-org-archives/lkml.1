Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbYAPXUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbYAPXUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYAPXP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:15:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYAPXPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:15:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=eiC3lt1E0F8isBG/fzPVMJnrOwsRAqC+ens5+GElAqPs5Cp35cIuiyWvbMVyEK7GNS/NvIOJ90Y3HTFdwMBG9JEjYdfWJBojtj/jtcL3Qkw8o7Tgbtmo+frQMZIl1Gk680jS4D037+apZSdGugZpPjvdaV36MgNG2CdZz6LVb7E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:28:04 +0100
Message-Id: <20080116232804.9166.57061.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/22] ide: move ide_acpi_init() call to ide_device_add_all()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1260,7 +1260,6 @@ static int hwif_init(ide_hwif_t *hwif)
 done:
 	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
 			    THIS_MODULE, ata_probe, ata_lock, hwif);
-	ide_acpi_init(hwif);
 	return 1;
 
 out:
@@ -1429,6 +1428,8 @@ int ide_device_add_all(u8 idx[MAX_HWIFS]
 			rc = -1;
 			continue;
 		}
+
+		ide_acpi_init(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
