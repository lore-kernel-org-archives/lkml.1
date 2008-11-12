Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYKLVdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYKLVdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYKLVc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:32:57 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:8933 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbYKLVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=N7J1Y9qm/Qu8fzk+g0RgICfbdcqmFUscekMnjD/Mwo2Uwnq8fcnqqiAdoAN94MqSR4
         2+XXrlyzwB3iTZGfhf012ISIydOZghtwYW4gHUAfNvVqJqW9sZu3EkcJUSjA5vkHMvAO
         96YKPjgm7e+b/XuBWJlh5UX6mH25H6eEqfXrI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/6] ide: remove chipset type fixup from ide_host_register()
Date: Wed, 12 Nov 2008 22:15:15 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122215.15671.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Set chipset type explicitly in tx4938ide and tx4939ide host drivers
  (all other host drivers were updated already).

* Remove no longer used chipset type fixup from ide_host_register().

CC: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    3 ---
 drivers/ide/tx4938ide.c |    1 +
 drivers/ide/tx4939ide.c |    1 +
 3 files changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1654,9 +1654,6 @@ int ide_host_register(struct ide_host *h
 		if (hwif == NULL)
 			continue;
 
-		if (hwif->chipset == ide_unknown)
-			hwif->chipset = ide_generic;
-
 		if (hwif->present)
 			hwif_register_devices(hwif);
 	}
Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -226,6 +226,7 @@ static const struct ide_port_info tx4938
 #endif
 	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
 	.pio_mask		= ATA_PIO5,
+	.chipset		= ide_generic,
 };
 
 static int __init tx4938ide_probe(struct platform_device *pdev)
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -644,6 +644,7 @@ static const struct ide_port_info tx4939
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
 	.udma_mask		= ATA_UDMA5,
+	.chipset		= ide_generic,
 };
 
 static int __init tx4939ide_probe(struct platform_device *pdev)
