Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104Ab0ARRTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0ARRTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077Ab0ARRTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:19:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:36177 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab0ARRTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:19:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IIxxMwqA8qyHbzTFMuxohs184qeMU6RR53LsKogiiWPxE+Dhi8SKP9WsyHpdSA8FTb
         /yD+3BV0BdtAEAMtydQeYjreKGKPHAqSsfXSyzc++fx5WPM/AypMV91iHHPKI4heV89h
         IA5WOLcK8JkJG1OrXGFMlKd0ctmTi5dGP+RIM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:18:17 +0100
Message-Id: <20100118171817.14623.7796.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 30/64] amd74xx: don't change UDMA settings when programming PIO timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] amd74xx: don't change UDMA settings when programming PIO timings

Based on libata pata_amd host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/amd74xx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/ide/amd74xx.c
===================================================================
--- a/drivers/ide/amd74xx.c
+++ b/drivers/ide/amd74xx.c
@@ -3,7 +3,7 @@
  * IDE driver for Linux.
  *
  * Copyright (c) 2000-2002 Vojtech Pavlik
- * Copyright (c) 2007-2008 Bartlomiej Zolnierkiewicz
+ * Copyright (c) 2007-2010 Bartlomiej Zolnierkiewicz
  *
  * Based on the work of:
  *      Andre Hedrick
@@ -70,7 +70,8 @@ static void amd_set_speed(struct pci_dev
 	default: return;
 	}
 
-	pci_write_config_byte(dev, AMD_UDMA_TIMING + offset + (3 - dn), t);
+	if (timing->udma)
+		pci_write_config_byte(dev, AMD_UDMA_TIMING + offset + 3 - dn, t);
 }
 
 /*
@@ -340,6 +341,6 @@ static void __exit amd74xx_ide_exit(void
 module_init(amd74xx_ide_init);
 module_exit(amd74xx_ide_exit);
 
-MODULE_AUTHOR("Vojtech Pavlik");
+MODULE_AUTHOR("Vojtech Pavlik, Bartlomiej Zolnierkiewicz");
 MODULE_DESCRIPTION("AMD PCI IDE driver");
 MODULE_LICENSE("GPL");
