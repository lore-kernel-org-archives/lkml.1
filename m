Return-Path: <linux-kernel-owner+w=401wt.eu-S964946AbXGMWu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946AbXGMWu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937034AbXGMWp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:45:29 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59114 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937262AbXGMWpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:12 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Subject: [PATCH 12/12] drivers/isdn/hisax/w6692.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:57 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.58514.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/w6692.c: In function `setup_w6692':
drivers/isdn/hisax/w6692.c:1014: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

and also removes trailing whitespaces at the ends of lines and converts 
smarttabs/whitespaces into real tabs

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/w6692.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/w6692.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/w6692.c
+++ linux-2.6/drivers/isdn/hisax/w6692.c
@@ -1011,7 +1011,7 @@ setup_w6692(struct IsdnCard *card)
 		return (0);
 #ifdef CONFIG_PCI
 	while (id_list[id_idx].vendor_id) {
-		dev_w6692 = pci_find_device(id_list[id_idx].vendor_id,
+		dev_w6692 = pci_get_device(id_list[id_idx].vendor_id,
 					    id_list[id_idx].device_id,
 					    dev_w6692);
 		if (dev_w6692) {
@@ -1031,7 +1031,7 @@ setup_w6692(struct IsdnCard *card)
 		/* USR ISDN PCI card TA need some special handling */
 		if (cs->subtyp == W6692_WINBOND) {
 			if ((W6692_SV_USR == dev_w6692->subsystem_vendor) &&
-			    (W6692_SD_USR == dev_w6692->subsystem_device)) {
+				(W6692_SD_USR == dev_w6692->subsystem_device)) {
 				cs->subtyp = W6692_USR;
 			}
 		}
@@ -1043,11 +1043,11 @@ setup_w6692(struct IsdnCard *card)
 	cs->irq = pci_irq;
 	if (!cs->irq) {
 		printk(KERN_WARNING "W6692: No IRQ for PCI card found\n");
-		return (0);
+		goto dev_w6692_cleanup;
 	}
 	if (!pci_ioaddr) {
 		printk(KERN_WARNING "W6692: NO I/O Base Address found\n");
-		return (0);
+		goto dev_w6692_cleanup;
 	}
 	cs->hw.w6692.iobase = pci_ioaddr;
 	printk(KERN_INFO "Found: %s %s, I/O base: 0x%x, irq: %d\n",
@@ -1059,7 +1059,7 @@ setup_w6692(struct IsdnCard *card)
 		       id_list[cs->subtyp].card_name,
 		       cs->hw.w6692.iobase,
 		       cs->hw.w6692.iobase + 255);
-		return (0);
+		goto dev_w6692_cleanup;
 	}
 #else
 	printk(KERN_WARNING "HiSax: W6692 and NO_PCI_BIOS\n");
@@ -1089,5 +1089,10 @@ setup_w6692(struct IsdnCard *card)
 	printk(KERN_INFO "W6692 D_EXIR=0x%X\n", ReadW6692(cs, W_D_EXIR));
 	printk(KERN_INFO "W6692 D_EXIM=0x%X\n", ReadW6692(cs, W_D_EXIM));
 	printk(KERN_INFO "W6692 D_RSTA=0x%X\n", ReadW6692(cs, W_D_RSTA));
+	pci_dev_put(dev_w6692);
 	return (1);
+
+dev_w6692_cleanup:
+	pci_dev_put(dev_w6692);
+	return (0);
 }

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
