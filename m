Return-Path: <linux-kernel-owner+w=401wt.eu-S937154AbXGMWtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937154AbXGMWtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760627AbXGMWpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:45:23 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59106 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758624AbXGMWpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:07 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
Subject: [PATCH 10/12] drivers/isdn/hisax/sedlbauer.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 01:44:51 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200707140144.53441.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/sedlbauer.c: In function `setup_sedlbauer':
drivers/isdn/hisax/sedlbauer.c:621: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

and also removes trailing whitespaces at the ends of lines and converts 
smarttabs/whitespaces into real tabs

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/sedlbauer.c |   43 
++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/sedlbauer.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/sedlbauer.c
+++ linux-2.6/drivers/isdn/hisax/sedlbauer.c
@@ -540,19 +540,19 @@ setup_sedlbauer(struct IsdnCard *card)
 	strcpy(tmp, Sedlbauer_revision);
 	printk(KERN_INFO "HiSax: Sedlbauer driver Rev. %s\n", HiSax_getrev(tmp));
 	
- 	if (cs->typ == ISDN_CTYPE_SEDLBAUER) {
- 		cs->subtyp = SEDL_SPEED_CARD_WIN;
+	if (cs->typ == ISDN_CTYPE_SEDLBAUER) {
+		cs->subtyp = SEDL_SPEED_CARD_WIN;
 		cs->hw.sedl.bus = SEDL_BUS_ISA;
 		cs->hw.sedl.chip = SEDL_CHIP_TEST;
- 	} else if (cs->typ == ISDN_CTYPE_SEDLBAUER_PCMCIA) {	
- 		cs->subtyp = SEDL_SPEED_STAR;
+	} else if (cs->typ == ISDN_CTYPE_SEDLBAUER_PCMCIA) {
+		cs->subtyp = SEDL_SPEED_STAR;
 		cs->hw.sedl.bus = SEDL_BUS_PCMCIA;
 		cs->hw.sedl.chip = SEDL_CHIP_TEST;
- 	} else if (cs->typ == ISDN_CTYPE_SEDLBAUER_FAX) {	
- 		cs->subtyp = SEDL_SPEED_FAX;
+	} else if (cs->typ == ISDN_CTYPE_SEDLBAUER_FAX) {
+		cs->subtyp = SEDL_SPEED_FAX;
 		cs->hw.sedl.bus = SEDL_BUS_ISA;
 		cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
- 	} else
+	} else
 		return (0);
 
 	bytecnt = 8;
@@ -618,14 +618,14 @@ setup_sedlbauer(struct IsdnCard *card)
 #endif
 /* Probe for Sedlbauer speed pci */
 #ifdef CONFIG_PCI
-		if ((dev_sedl = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_sedl = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 				PCI_DEVICE_ID_TIGERJET_100, dev_sedl))) {
 			if (pci_enable_device(dev_sedl))
-				return(0);
+				goto dev_sedl_cleanup;
 			cs->irq = dev_sedl->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "Sedlbauer: No IRQ for PCI card found\n");
-				return(0);
+				goto dev_sedl_cleanup;
 			}
 			cs->hw.sedl.cfg_reg = pci_resource_start(dev_sedl, 0);
 		} else {
@@ -642,7 +642,7 @@ setup_sedlbauer(struct IsdnCard *card)
 			cs->hw.sedl.cfg_reg);
 		if (sub_id != PCI_SUB_ID_SEDLBAUER) {
 			printk(KERN_ERR "Sedlbauer: unknown sub id %#x\n", sub_id);
-			return(0);
+			goto dev_sedl_cleanup;
 		}
 		if (sub_vendor_id == PCI_SUBVENDOR_SPEEDFAX_PYRAMID) {
 			cs->hw.sedl.chip = SEDL_CHIP_ISAC_ISAR;
@@ -659,7 +659,7 @@ setup_sedlbauer(struct IsdnCard *card)
 		} else {
 			printk(KERN_ERR "Sedlbauer: unknown sub vendor id %#x\n",
 				sub_vendor_id);
-			return(0);
+			goto dev_sedl_cleanup;
 		}
 		bytecnt = 256;
 		cs->hw.sedl.reset_on = SEDL_ISAR_PCI_ISAR_RESET_ON;
@@ -676,10 +676,10 @@ setup_sedlbauer(struct IsdnCard *card)
 		printk(KERN_WARNING "Sedlbauer: NO_PCI_BIOS\n");
 		return (0);
 #endif /* CONFIG_PCI */
-	}	
+	}
 
 #ifdef __ISAPNP__
-ready:	
+ready:
 #endif
 
 	/* In case of the sedlbauer pcmcia card, this region is in use,
@@ -693,7 +693,7 @@ ready:	
 			CardType[card->typ],
 			cs->hw.sedl.cfg_reg,
 			cs->hw.sedl.cfg_reg + bytecnt);
-			return (0);
+			goto dev_sedl_cleanup;
 	}
 
 	printk(KERN_INFO
@@ -711,7 +711,7 @@ ready:	
  * testing ISA and PCMCIA Cards for IPAC, default is ISAC
  * do not test for PCI card, because ports are different
  * and PCI card uses only IPAC (for the moment)
- */	
+ */
 	if (cs->hw.sedl.bus != SEDL_BUS_PCI) {
 		val = readreg(cs->hw.sedl.cfg_reg + SEDL_IPAC_ANY_ADR,
 			cs->hw.sedl.cfg_reg + SEDL_IPAC_ANY_IPAC, IPAC_ID);
@@ -804,7 +804,7 @@ ready:	
 			}
 			if (!bytecnt) {
 				release_io_sedlbauer(cs);
-				return (0);
+				goto dev_sedl_cleanup;
 			}
 		} else {
 			if (cs->hw.sedl.bus == SEDL_BUS_PCMCIA) {
@@ -823,14 +823,19 @@ ready:	
 			}
 			cs->irq_func = &sedlbauer_interrupt;
 			ISACVersion(cs, "Sedlbauer:");
-		
+
 			if (HscxVersion(cs, "Sedlbauer:")) {
 				printk(KERN_WARNING
 					"Sedlbauer: wrong HSCX versions check IO address\n");
 				release_io_sedlbauer(cs);
-				return (0);
+				goto dev_sedl_cleanup;
 			}
 		}
 	}
+	pci_dev_put(dev_sedl);
 	return (1);
+
+dev_sedl_cleanup:
+	pci_dev_put(dev_sedl);
+	return 0;
 }

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
