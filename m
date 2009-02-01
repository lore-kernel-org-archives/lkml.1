Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZBARv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZBARv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZBARtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:49:08 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:6833 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbZBARtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:49:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CAog7DA2KT+FCLomaV2e150XhpY7+jyrtphiIgLUif6+O++Fkct+tlPJ2qJvRp3oce
         gpzNsQ+rOVJdXy8Q5JeTw3PJmSKb4bbxV83j0s8LhNARLZTEiZ8MheWnbwn1kc6BB0ef
         NZ5VHjPoTsNxJlWCmtFMWhx9tw5L5HFeZbR+0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:49:58 +0100
Message-Id: <20090201174958.19144.18206.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/15] ide: add IDE_HFLAG_DTC2278 host flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add IDE_HFLAG_DTC2278 host flag

Add IDE_HFLAG_DTC2278 host flag and use it instead of ide_dtc2278
chipset type in ide_init_port().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/dtc2278.c   |    3 ++-
 drivers/ide/ide-probe.c |    2 +-
 include/linux/ide.h     |    2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

Index: b/drivers/ide/dtc2278.c
===================================================================
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -100,7 +100,8 @@ static const struct ide_port_info dtc227
 				  IDE_HFLAG_IO_32BIT |
 				  /* disallow ->io_32bit changes */
 				  IDE_HFLAG_NO_IO_32BIT |
-				  IDE_HFLAG_NO_DMA,
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_DTC2278,
 	.pio_mask		= ATA_PIO4,
 };
 
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1056,7 +1056,7 @@ static void ide_init_port(ide_hwif_t *hw
 		hwif->tp_ops = d->tp_ops;
 
 	/* ->set_pio_mode for DTC2278 is currently limited to port 0 */
-	if (hwif->chipset != ide_dtc2278 || hwif->channel == 0)
+	if ((hwif->host_flags & IDE_HFLAG_DTC2278) == 0 || hwif->channel == 0)
 		hwif->port_ops = d->port_ops;
 
 	hwif->swdma_mask = d->swdma_mask;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1322,6 +1322,8 @@ enum {
 	IDE_HFLAG_ERROR_STOPS_FIFO	= (1 << 19),
 	/* serialize ports */
 	IDE_HFLAG_SERIALIZE		= (1 << 20),
+	/* host is DTC2278 */
+	IDE_HFLAG_DTC2278		= (1 << 21),
 	/* host is TRM290 */
 	IDE_HFLAG_TRM290		= (1 << 23),
 	/* use 32-bit I/O ops */
