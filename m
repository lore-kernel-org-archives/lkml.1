Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbYBHAgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbYBHAgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932645AbYBHAbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:31:37 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:56846 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334AbYBHAbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KzwkBMVUdmHF0g4dKLfp8RsFGHX36nv7vRKlRmG3jn+XeigycqxvghslLNURjjCZ8mESTHAe5zwuJOZ5PIRSfVCDThEPVvtgbjw2WG1FrXRxZfRCTCDZXwIkxJrB3bdEOL78qnsg0xGFvURu7myMzzkw/qX/zbPBUjCU0YYmSVo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:45:45 +0100
Message-Id: <20080208004545.17746.25806.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/18] ide: remove needless CONFIG_BLK_DEV_HD hack from init_hwif()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_irq() will fail if there is already another IRQ handler
registered and IRQ flags are mismatched.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    7 -------
 1 file changed, 7 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1237,13 +1237,6 @@ static int hwif_init(ide_hwif_t *hwif)
 			return 0;
 		}
 	}
-#ifdef CONFIG_BLK_DEV_HD
-	if (hwif->irq == HD_IRQ && hwif->io_ports[IDE_DATA_OFFSET] != HD_DATA) {
-		printk("%s: CANNOT SHARE IRQ WITH OLD "
-			"HARDDISK DRIVER (hd.c)\n", hwif->name);
-		return 0;
-	}
-#endif /* CONFIG_BLK_DEV_HD */
 
 	if (register_blkdev(hwif->major, hwif->name))
 		return 0;
