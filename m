Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987Ab0A2QE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0A2QE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331Ab0A2QE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:04:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:44306 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab0A2QEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:04:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FnREKdpBjPv9IHp+iWAi9yhjGqJIo7kVZusOUOkjlbcUlZFgvdn2X8e2pnOAkrsmB0
         D/oCz0Zoh1tfL1v+TiHyAjZOYRt56Mi+wlloP+TjuP3IMcg8bAJhw0U8M/HloNFi6+A0
         ripXl5XsL0wnRruslofYR6QPKHdyQt+rCJ3+0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:46 +0100
Message-Id: <20100129160446.21495.53881.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 15/68] sis5513: use pata_sis.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] sis5513: use pata_sis.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/sis5513.c |   25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

Index: b/drivers/ide/sis5513.c
===================================================================
--- a/drivers/ide/sis5513.c
+++ b/drivers/ide/sis5513.c
@@ -506,34 +506,15 @@ static int init_chipset_sis5513(struct p
 	return 0;
 }
 
-struct sis_laptop {
-	u16 device;
-	u16 subvendor;
-	u16 subdevice;
-};
-
-static const struct sis_laptop sis_laptop[] = {
-	/* devid, subvendor, subdev */
-	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
-	{ 0x5513, 0x1734, 0x105f },	/* FSC Amilo A1630 */
-	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
-	/* end marker */
-	{ 0, }
-};
+#include "../ata/pata_sis.h"
 
 static u8 sis_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	const struct sis_laptop *lap = &sis_laptop[0];
 	u8 ata66 = 0;
 
-	while (lap->device) {
-		if (lap->device == pdev->device &&
-		    lap->subvendor == pdev->subsystem_vendor &&
-		    lap->subdevice == pdev->subsystem_device)
-			return ATA_CBL_PATA40_SHORT;
-		lap++;
-	}
+	if (sis_short_ata40(pdev))
+		return ATA_CBL_PATA40_SHORT;
 
 	if (chipset_family >= ATA_133) {
 		u16 regw = 0;
