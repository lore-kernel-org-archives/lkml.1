Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbYEHUw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbYEHUw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761362AbYEHUua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:50:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:56622 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760533AbYEHUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:50:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=T2+qv98n1BZ6us4zi7juZf0gklOPc8dssG9lhE5zlqJRPZlLLo1f4fZwFr/gzw8NAkeY91De3utvSD3XlYFSiItOwiLTRJ/jGkHc8cv//FM6d4Tgq1H8BYsg31D9CMSK2Nkpfu+zbjZOsz/ckKP3tLdWSLStFj07/MPnjhLp3eQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/5] alim15x3: remove WDC_ALI15X3 config option
Date: Thu, 8 May 2008 23:05:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805082305.23005.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is "wdc_udma" module parameter now.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig        |   15 ---------------
 drivers/ide/pci/alim15x3.c |    4 ----
 2 files changed, 19 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -463,21 +463,6 @@ config BLK_DEV_ALI15X3
 
 	  If unsure, say N.
 
-config WDC_ALI15X3
-	bool "ALI M15x3 WDC support (DANGEROUS)"
-	depends on BLK_DEV_ALI15X3
-	---help---
-	  This allows for UltraDMA support for WDC drives that ignore CRC
-	  checking. You are a fool for enabling this option, but there have
-	  been requests. DO NOT COMPLAIN IF YOUR DRIVE HAS FS CORRUPTION, IF
-	  YOU ENABLE THIS! No one will listen, just laugh for ignoring this
-	  SERIOUS WARNING.
-
-	  Using this option can allow WDC drives to run at ATA-4/5 transfer
-	  rates with only an ATA-2 support structure.
-
-	  SAY N!
-
 config BLK_DEV_AMD74XX
 	tristate "AMD and nVidia IDE support"
 	depends on !ARM
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -127,8 +127,6 @@ static void ali_set_pio_mode(ide_drive_t
  *		No UDMA on revisions <= 0x20
  *		Disk only for revisions < 0xC2
  *		Not WDC drives on M1543C-E (?)
- *
- *	FIXME: WDC ifdef needs to die
  */
 
 static u8 ali_udma_filter(ide_drive_t *drive)
@@ -136,11 +134,9 @@ static u8 ali_udma_filter(ide_drive_t *d
 	if (m5229_revision > 0x20 && m5229_revision < 0xC2) {
 		if (drive->media != ide_disk)
 			return 0;
-#ifndef CONFIG_WDC_ALI15X3
 		if (chip_is_1543c_e && strstr(drive->id->model, "WDC ") &&
 		    wdc_udma == 0)
 			return 0;
-#endif
 	}
 
 	return drive->hwif->ultra_mask;
