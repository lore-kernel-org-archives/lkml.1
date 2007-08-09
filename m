Return-Path: <linux-kernel-owner+w=401wt.eu-S939791AbXHINRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939791AbXHINRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933756AbXHINQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:16:54 -0400
Received: from ns2.bglans.net ([217.79.67.244]:35955 "EHLO mail.bglans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856AbXHINQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:16:54 -0400
X-Greylist: delayed 1337 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2007 09:16:53 EDT
Date: Thu, 9 Aug 2007 15:54:30 +0300 (EEST)
From: ivaylo@bglans.net
To: linux-kernel@vger.kernel.org
Subject: 2.4.XX and JMicron
Message-ID: <Pine.LNX.4.62.0708091550270.25126@mail.bglans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have ASUS P5B-VM DO mobo with JMicron SATA/PATA controler. I write mail 
to Alan Cox and he told me that PATA part of JMicron controler can be 
pressant as generic ide. So I make some changes to generic ide driver in 
kernel 2.4.35 to be support JMicron PATA controler, but I'm not advanced 
in C programing and not sure what I did is right. It works for me.

If there are any interes I send you (see bellow) changes.


Best Regards.
Ivaylo Josifov

--- /home/ivaylo/boza/linux-2.4.35/include/linux/pci_ids.h      2007-07-26 23:53:41.000000000 +0300
+++ include/linux/pci_ids.h     2007-08-02 19:51:18.000000000 +0300 @@ -2100,3 +2100,7 @@

  #define PCI_VENDOR_ID_WORKBIT          0x1145
  #define PCI_DEVICE_ID_WORKBIT_CB       0xf021
+
+#define PCI_VENDOR_ID_JMICRON          0x197b
+#define PCI_DEVICE_ID_JMICRON_20363    0x2363
+


--- /home/ivaylo/boza/linux-2.4.35/drivers/ide/pci/generic.h    2007-07-26 23:53:41.000000000 +0300
+++ drivers/ide/pci/generic.h   2007-08-02 19:58:53.000000000 +0300 @@ -157,6 +157,16 @@
                 .channels       = 2,
                 .autodma        = NOAUTODMA,
                 .bootable       = ON_BOARD,
+       },{     /* 12 */
+               .vendor         = PCI_VENDOR_ID_JMICRON,
+               .device         = PCI_DEVICE_ID_JMICRON_20363,
+               .name           = "JMICRON_20363",
+               .init_chipset   = init_chipset_generic,
+               .init_hwif      = init_hwif_generic,
+               .init_dma       = init_dma_generic,
+               .channels       = 1,
+               .autodma        = NOAUTODMA,
+               .bootable       = ON_BOARD,
         },{
                 .vendor         = 0,
                 .device         = 0,


--- /home/ivaylo/boza/linux-2.4.35/drivers/ide/pci/generic.c    2007-07-26 23:53:41.000000000 +0300
+++ drivers/ide/pci/generic.c   2007-08-02 19:51:15.000000000 +0300 @@ -143,6 +143,7 @@
         { PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 9},
         { PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO_1,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 10},
         { PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO_2,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 11},
+       { PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_20363,PCI_ANY_ID, PCI_ANY_ID, 0, 0, 12},
         { 0, },
  };

