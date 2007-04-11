Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXDKKXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXDKKXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXDKKXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:23:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:26252 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXDKKXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=m84kZ06L5K1KRlpROkBWudIiZLKUD58j62L/K9xZALLx72ewkTlextLTk7ME469XJw5NG3CqFSniZBcmW6q4EEwQd+iRzyF+sROy/hHTfx5PiD97W3G7thXIVTaorYDeoC5ksvQcvUmQWa2Km38NAz1tEzyQhDC6hSZNYo4EqVM=
Message-ID: <5767b9100704110323n600e0a27kcf0a3800e0953296@mail.gmail.com>
Date: Wed, 11 Apr 2007 18:23:14 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] ahci.c: remove non-existing SB600 raid id (re-send)
Cc: "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    SB600 RAID and SB600 SATA is the same controller and share the
same PCI ID 0x4380. There is no such PCI ID 0x4381.

    Signed-off-by: Conke Hu <conke.hu@gmail.com>
 ---------
diff -Nur linux-2.6.21-rc6-git3.orig/drivers/ata/ahci.c
linux-2.6.21-rc6-git3/drivers/ata/ahci.c
--- linux-2.6.21-rc6-git3.orig/drivers/ata/ahci.c	2007-04-22
18:38:39.000000000 +0800
+++ linux-2.6.21-rc6-git3/drivers/ata/ahci.c	2007-04-22 18:39:12.000000000 +0800
@@ -413,8 +413,7 @@
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },

 	/* ATI */
-	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 non-raid */
-	{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */
+	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */

 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
diff -Nur linux-2.6.21-rc6-git3.orig/include/linux/pci_ids.h
linux-2.6.21-rc6-git3/include/linux/pci_ids.h
--- linux-2.6.21-rc6-git3.orig/include/linux/pci_ids.h	2007-04-22
18:38:39.000000000 +0800
+++ linux-2.6.21-rc6-git3/include/linux/pci_ids.h	2007-04-22
18:39:35.000000000 +0800
@@ -368,7 +368,6 @@
 #define PCI_DEVICE_ID_ATI_IXP400_SATA   0x4379
 #define PCI_DEVICE_ID_ATI_IXP400_SATA2	0x437a
 #define PCI_DEVICE_ID_ATI_IXP600_SATA	0x4380
-#define PCI_DEVICE_ID_ATI_IXP600_SRAID	0x4381
 #define PCI_DEVICE_ID_ATI_IXP600_SMBUS	0x4385
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438c
