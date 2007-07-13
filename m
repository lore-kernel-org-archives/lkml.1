Return-Path: <linux-kernel-owner+w=401wt.eu-S937553AbXGMWrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937553AbXGMWrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937266AbXGMWo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:44:57 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59090 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937262AbXGMWoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:44:55 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Subject: [PATCH 6/12] drivers/isdn/hisax/enternow_pci.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:38 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.39762.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/enternow_pci.c: In function `setup_enternow_pci':
drivers/isdn/hisax/enternow_pci.c:326: warning: `pci_find_device' is 
deprecated (declared at include/linux/pci.h:478)

and also removes trailing whitespaces at the ends of lines and converts 
smarttabs/whitespaces into real tabs

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/enternow_pci.c |   40 
++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/enternow_pci.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/enternow_pci.c
+++ linux-2.6/drivers/isdn/hisax/enternow_pci.c
@@ -315,7 +315,7 @@ setup_enternow_pci(struct IsdnCard *card
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
 #endif
-        strcpy(tmp, enternow_pci_rev);
+	strcpy(tmp, enternow_pci_rev);
 	printk(KERN_INFO "HiSax: Formula-n Europe AG enter:now ISDN PCI driver 
Rev. %s\n", HiSax_getrev(tmp));
 	if (cs->typ != ISDN_CTYPE_ENTERNOW)
 		return(0);
@@ -323,29 +323,29 @@ setup_enternow_pci(struct IsdnCard *card
 
 	for ( ;; )
 	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
 			if (pci_enable_device(dev_netjet))
-				return(0);
+				goto dev_netjet_cleanup;
 			cs->irq = dev_netjet->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "enter:now PCI: No IRQ for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 			cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
 			if (!cs->hw.njet.base) {
 				printk(KERN_WARNING "enter:now PCI: No IO-Adr for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
-                        /* checks Sub-Vendor ID because system crashes with 
Traverse-Card */
+			/* checks Sub-Vendor ID because system crashes with Traverse-Card */
 			if ((dev_netjet->subsystem_vendor != 0x55) ||
 				(dev_netjet->subsystem_device != 0x02)) {
 				printk(KERN_WARNING "enter:now: You tried to load this driver with an 
incompatible TigerJet-card\n");
-                                printk(KERN_WARNING "Use type=20 for Traverse 
NetJet PCI Card.\n");
-                                return(0);
-                        }
+				printk(KERN_WARNING "Use type=20 for Traverse NetJet PCI Card.\n");
+				goto dev_netjet_cleanup;
+			}
 		} else {
-                        printk(KERN_WARNING "enter:now PCI: No PCI card 
found\n");
+			printk(KERN_WARNING "enter:now PCI: No PCI card found\n");
 			return(0);
 		}
 
@@ -390,22 +390,26 @@ setup_enternow_pci(struct IsdnCard *card
 			   CardType[card->typ],
 			   cs->hw.njet.base,
 			   cs->hw.njet.base + bytecnt);
-		return (0);
+		goto dev_netjet_cleanup;
 	}
 	setup_Amd7930(cs);
 	cs->hw.njet.last_is0 = 0;
-        /* macro rByteAMD */
-        cs->readisac = &ReadByteAmd7930;
-        /* macro wByteAMD */
-        cs->writeisac = &WriteByteAmd7930;
-        cs->dc.amd7930.setIrqMask = &enpci_setIrqMask;
+	/* macro rByteAMD */
+	cs->readisac = &ReadByteAmd7930;
+	/* macro wByteAMD */
+	cs->writeisac = &WriteByteAmd7930;
+	cs->dc.amd7930.setIrqMask = &enpci_setIrqMask;
 
-        cs->BC_Read_Reg  = &dummyrr;
+	cs->BC_Read_Reg  = &dummyrr;
 	cs->BC_Write_Reg = &dummywr;
 	cs->BC_Send_Data = &netjet_fill_dma;
 	cs->cardmsg = &enpci_card_msg;
 	cs->irq_func = &enpci_interrupt;
 	cs->irq_flags |= IRQF_SHARED;
+	pci_dev_put(dev_netjet);
+	return (1);
 
-        return (1);
+dev_netjet_cleanup:
+	pci_dev_put(dev_netjet);
+	return (0);
 }

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
