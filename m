Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909Ab0A2QEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0A2QEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421Ab0A2QEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:04:13 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0A2QEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kWaMlaNIOiBi/CrhPUJKxJL1VDXa6V+5ego7YZuba5DPanVgUBgYUmkMh2HTz+2hRK
         sl//ibooYmbbjtXyWFJZbMt1k4mOU7Hz5bfZpPpwW7/yH12PaKLnZ5yOm1KS8QJQZ8EG
         AyGX52hlpjJU7rkAeq//nY0HOoC/Q/wicdTo0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:01 +0100
Message-Id: <20100129160401.21495.95428.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 08/68] ide-cs: use pata_pcmcia.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cs: use pata_pcmcia.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cs.c |   68 +--------------------------------------------------
 1 file changed, 2 insertions(+), 66 deletions(-)

Index: b/drivers/ide/ide-cs.c
===================================================================
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -385,71 +385,7 @@ static void ide_release(struct pcmcia_de
 
 ======================================================================*/
 
-static struct pcmcia_device_id ide_ids[] = {
-	PCMCIA_DEVICE_FUNC_ID(4),
-	PCMCIA_DEVICE_MANF_CARD(0x0000, 0x0000),	/* Corsair */
-	PCMCIA_DEVICE_MANF_CARD(0x0007, 0x0000),	/* Hitachi */
-	PCMCIA_DEVICE_MANF_CARD(0x000a, 0x0000),	/* I-O Data CFA */
-	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
-	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
-	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x2904),
-	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
-	PCMCIA_DEVICE_MANF_CARD(0x004f, 0x0000),	/* Kingston */
-	PCMCIA_DEVICE_MANF_CARD(0x0097, 0x1620), 	/* TI emulated */
-	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
-	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
-	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
-	PCMCIA_DEVICE_MANF_CARD(0x0319, 0x0000),	/* Hitachi */
-	PCMCIA_DEVICE_MANF_CARD(0x2080, 0x0001),
-	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0100),	/* Viking CFA */
-	PCMCIA_DEVICE_MANF_CARD(0x4e01, 0x0200),	/* Lexar, Viking CFA */
-	PCMCIA_DEVICE_PROD_ID123("Caravelle", "PSC-IDE ", "PSC000", 0x8c36137c, 0xd0693ab8, 0x2768a9f0),
-	PCMCIA_DEVICE_PROD_ID123("CDROM", "IDE", "MCD-601p", 0x1b9179ca, 0xede88951, 0x0d902f74),
-	PCMCIA_DEVICE_PROD_ID123("PCMCIA", "IDE CARD", "F1", 0x281f1c5d, 0x1907960c, 0xf7fde8b9),
-	PCMCIA_DEVICE_PROD_ID12("ARGOSY", "CD-ROM", 0x78f308dc, 0x66536591),
-	PCMCIA_DEVICE_PROD_ID12("ARGOSY", "PnPIDE", 0x78f308dc, 0x0c694728),
-	PCMCIA_DEVICE_PROD_ID12("CNF   ", "CD-ROM", 0x46d7db81, 0x66536591),
-	PCMCIA_DEVICE_PROD_ID12("CNF CD-M", "CD-ROM", 0x7d93b852, 0x66536591),
-	PCMCIA_DEVICE_PROD_ID12("Creative Technology Ltd.", "PCMCIA CD-ROM Interface Card", 0xff8c8a45, 0xfe8020c4),
-	PCMCIA_DEVICE_PROD_ID12("Digital Equipment Corporation.", "Digital Mobile Media CD-ROM", 0x17692a66, 0xef1dcbde),
-	PCMCIA_DEVICE_PROD_ID12("EXP", "CD+GAME", 0x6f58c983, 0x63c13aaf),
-	PCMCIA_DEVICE_PROD_ID12("EXP   ", "CD-ROM", 0x0a5c52fd, 0x66536591),
-	PCMCIA_DEVICE_PROD_ID12("EXP   ", "PnPIDE", 0x0a5c52fd, 0x0c694728),
-	PCMCIA_DEVICE_PROD_ID12("FREECOM", "PCCARD-IDE", 0x5714cbf7, 0x48e0ab8e),
-	PCMCIA_DEVICE_PROD_ID12("HITACHI", "FLASH", 0xf4f43949, 0x9eb86aae),
-	PCMCIA_DEVICE_PROD_ID12("HITACHI", "microdrive", 0xf4f43949, 0xa6d76178),
-	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
-	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
-	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
-	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
-	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
-	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
-	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDEII", 0x547e66dc, 0xb3662674),
-	PCMCIA_DEVICE_PROD_ID12("LOOKMEET", "CBIDE2      ", 0xe37be2b5, 0x8671043b),
-	PCMCIA_DEVICE_PROD_ID12("M-Systems", "CF300", 0x7ed2ad87, 0x7e9e78ee),
-	PCMCIA_DEVICE_PROD_ID12("M-Systems", "CF500", 0x7ed2ad87, 0x7a13045c),
-	PCMCIA_DEVICE_PROD_ID2("NinjaATA-", 0xebe0bd79),
-	PCMCIA_DEVICE_PROD_ID12("PCMCIA", "CD-ROM", 0x281f1c5d, 0x66536591),
-	PCMCIA_DEVICE_PROD_ID12("PCMCIA", "PnPIDE", 0x281f1c5d, 0x0c694728),
-	PCMCIA_DEVICE_PROD_ID12("SHUTTLE TECHNOLOGY LTD.", "PCCARD-IDE/ATAPI Adapter", 0x4a3f0ba0, 0x322560e1),
-	PCMCIA_DEVICE_PROD_ID12("SEAGATE", "ST1", 0x87c1b330, 0xe1f30883),
-	PCMCIA_DEVICE_PROD_ID12("SAMSUNG", "04/05/06", 0x43d74cb4, 0x6a22777d),
-	PCMCIA_DEVICE_PROD_ID12("SMI VENDOR", "SMI PRODUCT", 0x30896c92, 0x703cc5f6),
-	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
-	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
-	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF45", 0x709b1bf1, 0xf68b6f32),
-	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
-	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
-	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
-	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
-	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
-	PCMCIA_DEVICE_PROD_ID1("STI Flash", 0xe4a13209),
-	PCMCIA_DEVICE_PROD_ID12("STI", "Flash 5.0", 0xbf2df18d, 0x8cb57a0e),
-	PCMCIA_MFC_DEVICE_PROD_ID12(1, "SanDisk", "ConnectPlus", 0x7a954bd9, 0x74be00c6),
-	PCMCIA_DEVICE_PROD_ID2("Flash Card", 0x5a362506),
-	PCMCIA_DEVICE_NULL,
-};
-MODULE_DEVICE_TABLE(pcmcia, ide_ids);
+#include "../ata/pata_pcmcia.h"
 
 static struct pcmcia_driver ide_cs_driver = {
 	.owner		= THIS_MODULE,
@@ -458,7 +394,7 @@ static struct pcmcia_driver ide_cs_drive
 	},
 	.probe		= ide_probe,
 	.remove		= ide_detach,
-	.id_table       = ide_ids,
+	.id_table       = pcmcia_devices,
 };
 
 static int __init init_ide_cs(void)
