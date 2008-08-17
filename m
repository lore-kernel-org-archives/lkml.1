Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYHQT5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYHQT5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYHQT4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:56:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:50284 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbYHQT4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cdms/sDjJGmThp8dRyIo3GqdkwvyV3gUXwUpJLR33Cf79sRPGhH05hVoNjyJXLh2up
         UQ+QwxCjEaTjVnz/XLajC68n0iqb36wdfD9zZjlbb6w0wM2gkGEMvE5/x28S90Bf56Xd
         HQ4EkO6i1MGXZya6ZFpe+iIy/x5+9vk7YdqGg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 21:53:57 +0200
Message-Id: <20080817195357.13393.92210.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
References: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] cy82c693: remove no longer needed CY82C693_DEBUG_LOGS code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having CY82C693_DEBUG_INFO is enough nowadays.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cy82c693.c |   51 ---------------------------------------------
 1 file changed, 51 deletions(-)

Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -53,7 +53,6 @@
 /*
  *	The following are used to debug the driver.
  */
-#define CY82C693_DEBUG_LOGS	0
 #define CY82C693_DEBUG_INFO	0
 
 /*
@@ -172,17 +171,6 @@ static void cy82c693_set_dma_mode(ide_dr
 
 	index = hwif->channel ? CY82_INDEX_CHANNEL1 : CY82_INDEX_CHANNEL0;
 
-#if CY82C693_DEBUG_LOGS
-	/* for debug let's show the previous values */
-
-	outb(index, CY82_INDEX_PORT);
-	data = inb(CY82_DATA_PORT);
-
-	printk(KERN_INFO "%s (ch=%d, dev=%d): DMA mode is %d (single=%d)\n",
-		drive->name, HWIF(drive)->channel, drive->select.b.unit,
-		(data&0x3), ((data>>2)&1));
-#endif /* CY82C693_DEBUG_LOGS */
-
 	data = (mode & 3) | (single << 2);
 
 	outb(index, CY82_INDEX_PORT);
@@ -232,45 +220,6 @@ static void cy82c693_set_pio_mode(ide_dr
 		}
 	}
 
-#if CY82C693_DEBUG_LOGS
-	/* for debug let's show the register values */
-
-	if (drive->select.b.unit == 0) {
-		/*
-		 * get master drive registers
-		 * address setup control register
-		 * is 32 bit !!!
-		 */
-		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
-		addrCtrl &= 0x0F;
-
-		/* now let's get the remaining registers */
-		pci_read_config_byte(dev, CY82_IDE_MASTER_IOR, &pclk.time_16r);
-		pci_read_config_byte(dev, CY82_IDE_MASTER_IOW, &pclk.time_16w);
-		pci_read_config_byte(dev, CY82_IDE_MASTER_8BIT, &pclk.time_8);
-	} else {
-		/*
-		 * set slave drive registers
-		 * address setup control register
-		 * is 32 bit !!!
-		 */
-		pci_read_config_dword(dev, CY82_IDE_ADDRSETUP, &addrCtrl);
-
-		addrCtrl &= 0xF0;
-		addrCtrl >>= 4;
-
-		/* now let's get the remaining registers */
-		pci_read_config_byte(dev, CY82_IDE_SLAVE_IOR, &pclk.time_16r);
-		pci_read_config_byte(dev, CY82_IDE_SLAVE_IOW, &pclk.time_16w);
-		pci_read_config_byte(dev, CY82_IDE_SLAVE_8BIT, &pclk.time_8);
-	}
-
-	printk(KERN_INFO "%s (ch=%d, dev=%d): PIO timing is "
-		"(addr=0x%X, ior=0x%X, iow=0x%X, 8bit=0x%X)\n",
-		drive->name, hwif->channel, drive->select.b.unit,
-		addrCtrl, pclk.time_16r, pclk.time_16w, pclk.time_8);
-#endif /* CY82C693_DEBUG_LOGS */
-
 	/* let's calc the values for this PIO mode */
 	compute_clocks(pio, &pclk);
 
