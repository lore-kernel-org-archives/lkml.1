Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbXDKJyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbXDKJyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXDKJyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:54:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:15946 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbXDKJyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=UNSzmErqJ72sjl1lD3ozXXp3UAFslLiM8+RVk4hFioIwxGadT1JHEkdyBMoxaqfqZydJt+lBmK2mFgRFh6W8UWOV8aXNEhkhoY4Gl8ToH0sbMQjISwCuN0UXaMirEXcYfVrJmwUTiKUk9o0+rHkLNKikODVz2quUD1/Veuz53iA=
Message-ID: <5767b9100704110254s16566ce7n147aa578181d84e6@mail.gmail.com>
Date: Wed, 11 Apr 2007 17:54:50 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] ahci.c: remove non-existing SB600 raid id
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
same PCI ID 0x4380. There is such PCI ID 0x4381.

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
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438
