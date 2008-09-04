Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYIDS1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYIDS1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYIDS1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:27:00 -0400
Received: from mail.bglans.net ([217.79.67.244]:35326 "EHLO mail.bglans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYIDS07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:26:59 -0400
X-Greylist: delayed 1105 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 14:26:59 EDT
Date: Thu, 4 Sep 2008 21:26:12 +0300 (EEST)
From: ivaylo@bglans.net
To: linux-kernel@vger.kernel.org
cc: w@1wt.eu
Subject: Marvel IDE 88SE6101 2.4.XX support
In-Reply-To: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net>
Message-ID: <Pine.LNX.4.64.0809042115350.11281@mail.bglans.net>
References: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1339683907-1035896435-1220552772=:11281"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1339683907-1035896435-1220552772=:11281
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed


Another one small patch to support Marvel IDE 88SE6101 controler. I have 
one on Intel DG33BU motherboard. It is detect as
02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 single-port 
PATA133 interface (rev b2)

I add it in kernel as generic IDE. This patch and the other which is to 
support ICH9 AHCI works for me from few month.

The patch is in attached file and I post it bellow:


diff -ru a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
--- a/drivers/ide/pci/generic.c 2008-01-01 14:06:40.000000000 +0200
+++ b/drivers/ide/pci/generic.c 2008-05-02 02:57:28.000000000 +0300
@@ -144,6 +144,7 @@
         { PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO_1,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 10},
         { PCI_VENDOR_ID_TOSHIBA, PCI_DEVICE_ID_TOSHIBA_PICCOLO_2,  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 11},
         { PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_20363,      PCI_ANY_ID, PCI_ANY_ID, 0, 0, 12},
+       { PCI_VENDOR_ID_MARVEL,  PCI_DEVICE_ID_MARVEL_6101,        PCI_ANY_ID, PCI_ANY_ID, 0, 0, 13},
         { 0, },
  };


diff -ru a/drivers/ide/pci/generic.h b/drivers/ide/pci/generic.h
--- a/drivers/ide/pci/generic.h 2008-01-01 14:06:40.000000000 +0200
+++ b/drivers/ide/pci/generic.h 2008-05-02 02:58:18.000000000 +0300
@@ -167,6 +167,16 @@
                 .channels       = 1,
                 .autodma        = NOAUTODMA,
                 .bootable       = ON_BOARD,
+       },{     /* 13 */
+               .vendor         = PCI_VENDOR_ID_MARVEL,
+               .device         = PCI_DEVICE_ID_MARVEL_6101,
+               .name           = "MARVEL_6101",
+               .init_chipset   = init_chipset_generic,
+               .init_hwif      = init_hwif_generic,
+               .init_dma       = init_dma_generic,
+               .channels       = 1,
+               .autodma        = NOAUTODMA,
+               .bootable       = ON_BOARD,
         },{
                 .vendor         = 0,
                 .device         = 0,


diff -ru a/include/linux/pci_ids.h b/include/linux/pci_ids.h
--- a/include/linux/pci_ids.h   2008-01-01 14:06:40.000000000 +0200
+++ b/include/linux/pci_ids.h   2008-05-02 02:52:41.000000000 +0300
@@ -2105,3 +2105,6 @@
  #define PCI_VENDOR_ID_JMICRON          0x197b
  #define PCI_DEVICE_ID_JMICRON_20363    0x2363

+#define PCI_VENDOR_ID_MARVEL           0x11ab
+#define PCI_DEVICE_ID_MARVEL_6101      0x6101
+




Best Regards,
Ivaylo Josifov
--1339683907-1035896435-1220552772=:11281
Content-Type: APPLICATION/octet-stream; name=Marvel-IDE.patch.gz
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0809042126120.11281@mail.bglans.net>
Content-Description: 
Content-Disposition: attachment; filename=Marvel-IDE.patch.gz

H4sICEYVwEgAA01hcnZlbC1JREUucGF0Y2gArVRdb5tAEHyGX3FK33Jg7jDG
LlUlE7BUqthEbmqpT4iPcznJwRH+SKTI/73LgWtIwahVEdIuO+MxzA4kfL1G
an5AoZbk/MjyncYTpj3HXPvJMpbzeBCjqBuTVVW99ltJJ2SiEgonooZFTMsg
A3I+ECaAyxjja/9RaYxUoiOiW6OxpU8aGkPQmE6RSg1DMREuyhhNpzKS3tCD
4wWr2cL1l4HnBo/+ty/ena2IsTtbec6sNg4ePMfx7/2AKkgw7MUPgJVGT8RJ
yUn5d329X5+26n+de87SX7zXr8aBTobmELSLo0dfB338h/7cXq5m99XdXfTL
cWBSQiv1Xv1hdf/QF93pk4zkpD9s6ZUgpD1hS/9D2NL3YZtYtCNs5liEDQo1
y7RJgzgNs4xtdtJnRBUxCQ/7bfIUwmDh298ffXdul0C03e7DaMMAgc3d+fbS
LTZyUt6EvdoteIhuNRhJgyPLkm0uAbV1XYKTsCOP2ZnTvjtBzMInQbupITcl
xDO+D+KUP+/YHhj1y6ByqEZMX/j6zCr6Fkr55Oe2SWh6hbu8wl1eocIrYeXF
HlJ6e/ECBvXY8SzeHGDlG54dXovFBzzZidB1IFXkOtC/CNx1hd9x0y2DtsZN
p2SkDBEWtczbh4StecbaPxGSRF7px3HUpHV8MoCrQ4FXFLeLllERmjSMmqzW
qAGzKDKW5V+9AVRaYwYAAA==

--1339683907-1035896435-1220552772=:11281--
