Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZLCTw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZLCTw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZLCTwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:52:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:25744 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbZLCTwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:52:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tJsUVzouJQfuaU4t0qnhFk604ZfEuSoQKBPoalXVxf/sO2/EUYC5WcjbmHsRhA5rDd
         eeubhSYmHltQKEMnGHNJ113S4x5j/Fq7Hewkk7rPl03rKaslIZuEsFSif6pO5wP1kAwp
         0cOmPHi8xT94/DoGN8m61unkcOgJ8RfrZMp1A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 03 Dec 2009 20:52:11 +0100
Message-Id: <20091203195211.9093.87171.sendpatchset@localhost>
In-Reply-To: <20091203195145.9093.88261.sendpatchset@localhost>
References: <20091203195145.9093.88261.sendpatchset@localhost>
Subject: [PATCH 3/6] cy82c693: remove no longer needed debugging code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cy82c693: remove no longer needed debugging code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cy82c693.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

Index: b/drivers/ide/cy82c693.c
===================================================================
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -51,11 +51,6 @@
 #define DRV_NAME "cy82c693"
 
 /*
- *	The following are used to debug the driver.
- */
-#define CY82C693_DEBUG_INFO	0
-
-/*
  *	NOTE: the value for busmaster timeout is tricky and I got it by
  *	trial and error!  By using a to low value will cause DMA timeouts
  *	and drop IDE performance, and by using a to high value will cause
@@ -176,11 +171,6 @@ static void cy82c693_set_dma_mode(ide_dr
 	outb(index, CY82_INDEX_PORT);
 	outb(data, CY82_DATA_PORT);
 
-#if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s (ch=%d, dev=%d): set DMA mode to %d (single=%d)\n",
-		drive->name, hwif->channel, drive->dn & 1, mode & 3, single);
-#endif /* CY82C693_DEBUG_INFO */
-
 	/*
 	 * note: below we set the value for Bus Master IDE TimeOut Register
 	 * I'm not absolutly sure what this does, but it solved my problem
@@ -194,11 +184,6 @@ static void cy82c693_set_dma_mode(ide_dr
 	data = BUSMASTER_TIMEOUT;
 	outb(CY82_INDEX_TIMEOUT, CY82_INDEX_PORT);
 	outb(data, CY82_DATA_PORT);
-
-#if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s: Set IDE Bus Master TimeOut Register to 0x%X\n",
-		drive->name, data);
-#endif /* CY82C693_DEBUG_INFO */
 }
 
 static void cy82c693_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -239,8 +224,6 @@ static void cy82c693_set_pio_mode(ide_dr
 		pci_write_config_byte(dev, CY82_IDE_MASTER_IOR, pclk.time_16r);
 		pci_write_config_byte(dev, CY82_IDE_MASTER_IOW, pclk.time_16w);
 		pci_write_config_byte(dev, CY82_IDE_MASTER_8BIT, pclk.time_8);
-
-		addrCtrl &= 0xF;
 	} else {
 		/*
 		 * set slave drive
@@ -257,17 +240,7 @@ static void cy82c693_set_pio_mode(ide_dr
 		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOR, pclk.time_16r);
 		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOW, pclk.time_16w);
 		pci_write_config_byte(dev, CY82_IDE_SLAVE_8BIT, pclk.time_8);
-
-		addrCtrl >>= 4;
-		addrCtrl &= 0xF;
 	}
-
-#if CY82C693_DEBUG_INFO
-	printk(KERN_INFO "%s (ch=%d, dev=%d): set PIO timing to "
-		"(addr=0x%X, ior=0x%X, iow=0x%X, 8bit=0x%X)\n",
-		drive->name, hwif->channel, drive->dn & 1,
-		addrCtrl, pclk.time_16r, pclk.time_16w, pclk.time_8);
-#endif /* CY82C693_DEBUG_INFO */
 }
 
 static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)
