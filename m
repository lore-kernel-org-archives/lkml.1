Return-Path: <linux-kernel-owner+w=401wt.eu-S1763679AbYBBAhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763679AbYBBAhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbYBBAgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:36:51 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:7670 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978AbYBBAgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Y13MMkxyFy5yiOeSRD+DIVQE+akC1JI10ZgIbxOpStV1CaxbZazYk1HRZyBFk/VyUcUHnaAgM+3J8Ue8qJUNkKKzdA5jay1M1RNlPiPEVyPIqoXJVliD+yIpgUq02yhWWmPvjhl6a+yAHJSsSQ1fX7Y4WEwtsGg81dq0QHEdiOc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/5] ide: remove write-only ->sata_misc[] from ide_hwif_t
Date: Sat, 2 Feb 2008 01:45:40 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020145.40429.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Remove write-only ->sata_misc[] from ide_hwif_t.

* Remove no longer used SATA_{MISC,PHY,IEN}_OFFSET defines.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/siimage.c |    3 ---
 include/linux/ide.h       |    5 -----
 2 files changed, 8 deletions(-)

Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -704,9 +704,6 @@ static void __devinit init_mmio_iops_sii
 		hwif->sata_scr[SATA_STATUS_OFFSET]	= base + 0x104;
 		hwif->sata_scr[SATA_ERROR_OFFSET]	= base + 0x108;
 		hwif->sata_scr[SATA_CONTROL_OFFSET]	= base + 0x100;
-		hwif->sata_misc[SATA_MISC_OFFSET]	= base + 0x140;
-		hwif->sata_misc[SATA_PHY_OFFSET]	= base + 0x144;
-		hwif->sata_misc[SATA_IEN_OFFSET]	= base + 0x148;
 	}
 
 	memcpy(hwif->io_ports, hw.io_ports, sizeof(hwif->io_ports));
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -115,10 +115,6 @@ typedef unsigned char	byte;	/* used ever
 #define SATA_ERROR_OFFSET	(1)
 #define SATA_CONTROL_OFFSET	(2)
 
-#define SATA_MISC_OFFSET	(0)
-#define SATA_PHY_OFFSET		(1)
-#define SATA_IEN_OFFSET		(2)
-
 /*
  * Our Physical Region Descriptor (PRD) table should be large enough
  * to handle the biggest I/O request we are likely to see.  Since requests
@@ -473,7 +469,6 @@ typedef struct hwif_s {
 		/* task file registers for pata and sata */
 	unsigned long	io_ports[IDE_NR_PORTS];
 	unsigned long	sata_scr[SATA_NR_PORTS];
-	unsigned long	sata_misc[SATA_NR_PORTS];
 
 	ide_drive_t	drives[MAX_DRIVES];	/* drive info */
 
