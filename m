Return-Path: <linux-kernel-owner+w=401wt.eu-S1750974Ab0A2QFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974Ab0A2QFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302Ab0A2QFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:05:46 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0A2QFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HhvFr0ZT7ZAapyTCxsfoPtmMdzCoEIUoB8XQLXP+W6SE1Rf4vd0mPCl/QbWzeV3wmt
         ltdIwUxuEWBP7cMXmdhBly8AZ291dGm+zeOZuo5LgumolGoEDRB0BJGRZFDOf3vGTgUW
         hqFuL7r1ZdvMQ1/m7srpnS7BEJslcwwdRX9Kg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:05:31 +0100
Message-Id: <20100129160531.21495.79268.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 22/68] ide: add drive->devno field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add drive->devno field

Add devno field to ide_drive_t matching devno field used in
struct ata_device.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    1 +
 include/linux/ide.h     |    1 +
 2 files changed, 2 insertions(+)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1033,6 +1033,7 @@ static void ide_port_init_devices(ide_hw
 
 	ide_port_for_each_dev(i, drive, hwif) {
 		drive->dn = i + hwif->channel * 2;
+		drive->devno = i;
 
 		if (hwif->host_flags & IDE_HFLAG_IO_32BIT)
 			drive->io_32bit = 1;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -518,6 +518,7 @@ struct ide_drive_s {
 	u8	pio_mode;	/* for ->set_pio_mode _only_ */
 	u8	dma_mode;	/* for ->dma_pio_mode _only_ */
         u8	dn;		/* now wide spread use */
+	u8	devno;		/* 0 or 1 */
 	u8	acoustic;	/* acoustic management */
 	u8	media;		/* disk, cdrom, tape, floppy, ... */
 	u8	ready_stat;	/* min status value for drive ready */
