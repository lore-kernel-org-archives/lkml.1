Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYBIRk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYBIRk3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbYBIRkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:40:18 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:12540 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbYBIRkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c52pUzniVrOW1aeW5Vwf0f1BgmpjfbItsNFjQ3TXT+hh0U+K2RYa5BseYC3c2OM6f5pnaoRHkAY/2gsuySEJKDaH03RhNLHMwA8iNQ7Hz9PorIdwS2g9f9AO4fjk38+b+bnWDB+Uqpz6m2kh+ruvSmzdEADqFJYb0gsExQwtk2M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove ->hold field from ide_hwif_t (take 2)
Date: Sat, 9 Feb 2008 18:54:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802091854.07310.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


->hold is write-only now, remove it.

v2:
* v1 missed bast-ide, palm_bk3710, ide-cs and delkin_cb host drivers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c    |    2 +-
 drivers/ide/arm/palm_bk3710.c |    2 +-
 drivers/ide/legacy/ide-cs.c   |    2 +-
 drivers/ide/mips/au1xxx-ide.c |    3 ---
 drivers/ide/pci/delkin_cb.c   |    2 +-
 drivers/ide/ppc/pmac.c        |    1 -
 include/linux/ide.h           |    1 -
 7 files changed, 4 insertions(+), 9 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -54,7 +54,7 @@ bastide_register(unsigned int base, unsi
 
 	if (hwif->present)
 		ide_unregister(i);
-	else if (!hwif->hold)
+	else
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -386,7 +386,7 @@ static int __devinit palm_bk3710_probe(s
 
 	if (hwif->present)
 		ide_unregister(i, 0, 0);
-	else if (!hwif->hold)
+	else
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -164,7 +164,7 @@ static int idecs_register(unsigned long 
 
     if (hwif->present)
 	ide_unregister(i);
-    else if (!hwif->hold)
+    else
 	ide_init_port_data(hwif, i);
 
     ide_init_port_hw(hwif, &hw);
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -617,9 +617,6 @@ static int au_ide_probe(struct device *d
 
 	hwif->dev = dev;
 
-	/* hold should be on in all cases */
-	hwif->hold                      = 1;
-
 	hwif->mmio  = 1;
 
 	/* If the user has selected DDMA assisted copies,
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -86,7 +86,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 
 	if (hwif->present)
 		ide_unregister(i);
-	else if (!hwif->hold)
+	else
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1120,7 +1120,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	hwif->hwif_data = pmif;
 	ide_init_port_hw(hwif, hw);
 	hwif->noprobe = pmif->mediabay;
-	hwif->hold = pmif->mediabay;
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 	hwif->set_pio_mode = pmac_ide_set_pio_mode;
 	if (pmif->kind == controller_un_ata6
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -573,7 +573,6 @@ typedef struct hwif_s {
 
 	unsigned	noprobe    : 1;	/* don't probe for this interface */
 	unsigned	present    : 1;	/* this interface exists */
-	unsigned	hold       : 1; /* this interface is always present */
 	unsigned	serialized : 1;	/* serialized all channel operation */
 	unsigned	sharing_irq: 1;	/* 1 = sharing irq with another hwif */
 	unsigned	reset      : 1;	/* reset after probe */
