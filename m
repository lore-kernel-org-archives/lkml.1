Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbYDLSwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbYDLSwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYDLSvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:51:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:18079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbYDLSvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=duNkrzTGBNtjtdZfN9v/foIpemsE7AhFwEHgCaTzELRXaHqp1ApqAcM8jzSHTRbItL3Ao93NKtun8q1rr//e4X+WSorUhJx5Se2nOlu9eVArFJW5ldHiEPrq/nhcatobpsG8awjOQ8BGqp+wJgxLuHQVt4B2cFgnC8CNNEcBI/I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/5] ide: remove ->dma_vendor{1,3} fields from ide_hwif_t
Date: Sat, 12 Apr 2008 21:05:09 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804122105.09585.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use 'hwif->dma_base + {1,3}' instead of hwif->dma_vendor{1,3} in
  pdc202xx_new host driver.

* Remove no longer needed ->dma_vendor{1,3} fields from ide_hwif_t.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c          |    4 ----
 drivers/ide/pci/pdc202xx_new.c |    8 ++++----
 include/linux/ide.h            |    2 --
 3 files changed, 4 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -858,12 +858,8 @@ void ide_setup_dma(ide_hwif_t *hwif, uns
 
 	if (!hwif->dma_command)
 		hwif->dma_command	= hwif->dma_base + 0;
-	if (!hwif->dma_vendor1)
-		hwif->dma_vendor1	= hwif->dma_base + 1;
 	if (!hwif->dma_status)
 		hwif->dma_status	= hwif->dma_base + 2;
-	if (!hwif->dma_vendor3)
-		hwif->dma_vendor3	= hwif->dma_base + 3;
 	if (!hwif->dma_prdtable)
 		hwif->dma_prdtable	= hwif->dma_base + 4;
 
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -83,8 +83,8 @@ static u8 get_indexed_reg(ide_hwif_t *hw
 {
 	u8 value;
 
-	outb(index, hwif->dma_vendor1);
-	value = inb(hwif->dma_vendor3);
+	outb(index, hwif->dma_base + 1);
+	value = inb(hwif->dma_base + 3);
 
 	DBG("index[%02X] value[%02X]\n", index, value);
 	return value;
@@ -97,8 +97,8 @@ static u8 get_indexed_reg(ide_hwif_t *hw
  */
 static void set_indexed_reg(ide_hwif_t *hwif, u8 index, u8 value)
 {
-	outb(index, hwif->dma_vendor1);
-	outb(value, hwif->dma_vendor3);
+	outb(index, hwif->dma_base + 1);
+	outb(value, hwif->dma_base + 3);
 	DBG("index[%02X] value[%02X]\n", index, value);
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -510,9 +510,7 @@ typedef struct hwif_s {
 
 	unsigned long	dma_base;	/* base addr for dma ports */
 	unsigned long	dma_command;	/* dma command register */
-	unsigned long	dma_vendor1;	/* dma vendor 1 register */
 	unsigned long	dma_status;	/* dma status register */
-	unsigned long	dma_vendor3;	/* dma vendor 3 register */
 	unsigned long	dma_prdtable;	/* actual prd table address */
 
 	unsigned long	config_data;	/* for use by chipset-specific code */
