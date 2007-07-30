Return-Path: <linux-kernel-owner+w=401wt.eu-S936170AbXG3N2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936170AbXG3N2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761151AbXG3N2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:28:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:13539 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760246AbXG3N2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=KgShEEj2nI/WaiqOeIsDdn317V10qzH4VhqAWUQCvuZ35MqIaqk78J0Ago9Aqkantd/MoPfeSGaVLHz6MNVZ/ZK27F7QN4T+Jn0u3jHDUFl9BRLeMaxDd4QALHfQ26RCnIY8TTXx0d7xHr/R1pslRRCBEJFca70wQRU/Mh0Hfpo=
Message-ID: <46ADE66F.8080007@googlemail.com>
Date: Mon, 30 Jul 2007 15:23:59 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] drivers/isdn/hisax/* - Fix some warnings when CONFIG_PCI=n
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed some warning when CONFIG_PCI=n

...

drivers/isdn/hisax/elsa.c:835: warning: 'dev_qs1000' defined but not used
drivers/isdn/hisax/elsa.c:836: warning: 'dev_qs3000' defined but not used

drivers/isdn/hisax/gazel.c:539: warning: 'setup_gazelpci' defined but not used
drivers/isdn/hisax/sedlbauer.c: In function 'setup_sedlbauer':
drivers/isdn/hisax/sedlbauer.c:544: warning: unused variable 'sub_id'
drivers/isdn/hisax/sedlbauer.c:544: warning: unused variable 'sub_vendor_id'
drivers/isdn/hisax/sedlbauer.c: At top level:
drivers/isdn/hisax/sedlbauer.c:521: warning: 'dev_sedl' defined but not used

drivers/isdn/hisax/diva.c:909: warning: 'dev_diva' defined but not used
drivers/isdn/hisax/diva.c:910: warning: 'dev_diva_u' defined but not used
drivers/isdn/hisax/diva.c:911: warning: 'dev_diva201' defined but not used
drivers/isdn/hisax/diva.c:912: warning: 'dev_diva202' defined but not used

drivers/isdn/hisax/niccy.c:226: warning: 'niccy_dev' defined but not used

...

This patch just add some #ifdef's and some cleanups to drivers/isdn/hisax/sedlbauer.c
while checkpatch.pl bugged me about :)


Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 drivers/isdn/hisax/diva.c      |    2 ++
 drivers/isdn/hisax/elsa.c      |    2 ++
 drivers/isdn/hisax/gazel.c     |    2 ++
 drivers/isdn/hisax/niccy.c     |    3 +++
 drivers/isdn/hisax/sedlbauer.c |   39 +++++++++++++++++++++------------------
 5 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 6eebeb4..321205f 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -906,10 +906,12 @@ Diva_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return(0);
 }
 
+#ifdef CONFIG_PCI
 static struct pci_dev *dev_diva __devinitdata = NULL;
 static struct pci_dev *dev_diva_u __devinitdata = NULL;
 static struct pci_dev *dev_diva201 __devinitdata = NULL;
 static struct pci_dev *dev_diva202 __devinitdata = NULL;
+#endif
 
 #ifdef __ISAPNP__
 static struct isapnp_device_id diva_ids[] __devinitdata = {
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index fab3e4e..870c87f 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -832,8 +832,10 @@ probe_elsa(struct IsdnCardState *cs)
 	return (CARD_portlist[i]);
 }
 
+#ifdef CONFIG_PCI
 static 	struct pci_dev *dev_qs1000 __devinitdata = NULL;
 static 	struct pci_dev *dev_qs3000 __devinitdata = NULL;
+#endif
 
 #ifdef __ISAPNP__
 static struct isapnp_device_id elsa_ids[] __devinitdata = {
diff --git a/drivers/isdn/hisax/gazel.c b/drivers/isdn/hisax/gazel.c
index 3efa719..51fa4a5 100644
--- a/drivers/isdn/hisax/gazel.c
+++ b/drivers/isdn/hisax/gazel.c
@@ -532,6 +532,7 @@ setup_gazelisa(struct IsdnCard *card, struct IsdnCardState *cs)
 	return (0);
 }
 
+#ifdef CONFIG_PCI
 static struct pci_dev *dev_tel __devinitdata = NULL;
 
 static int __devinit
@@ -620,6 +621,7 @@ setup_gazelpci(struct IsdnCardState *cs)
 
 	return (0);
 }
+#endif
 
 int __devinit
 setup_gazel(struct IsdnCard *card)
diff --git a/drivers/isdn/hisax/niccy.c b/drivers/isdn/hisax/niccy.c
index e5918c6..5201cab 100644
--- a/drivers/isdn/hisax/niccy.c
+++ b/drivers/isdn/hisax/niccy.c
@@ -223,7 +223,10 @@ static int niccy_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return 0;
 }
 
+#ifdef CONFIG_PCI
 static struct pci_dev *niccy_dev __devinitdata = NULL;
+#endif
+
 #ifdef __ISAPNP__
 static struct pnp_card *pnp_c __devinitdata = NULL;
 #endif
diff --git a/drivers/isdn/hisax/sedlbauer.c b/drivers/isdn/hisax/sedlbauer.c
index ad06f3c..bc3bd0e 100644
--- a/drivers/isdn/hisax/sedlbauer.c
+++ b/drivers/isdn/hisax/sedlbauer.c
@@ -9,7 +9,7 @@
  *
  * Author       Marcus Niemann
  * Copyright    by Marcus Niemann    <niemann@www-bib.fh-bielefeld.de>
- * 
+ *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  *
@@ -222,7 +222,7 @@ WriteHSCX(struct IsdnCardState *cs, int hscx, u_char offset, u_char value)
 
 static u_char
 ReadISAR(struct IsdnCardState *cs, int mode, u_char offset)
-{	
+{
 	if (mode == 0)
 		return (readreg(cs->hw.sedl.adr, cs->hw.sedl.hscx, offset));
 	else if (mode == 1)
@@ -430,7 +430,7 @@ reset_sedlbauer(struct IsdnCardState *cs)
 			mdelay(2);
 			byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_off);
 			mdelay(10);
-		} else {		
+		} else {
 			byteout(cs->hw.sedl.reset_on, SEDL_RESET);	/* Reset On */
 			mdelay(2);
 			byteout(cs->hw.sedl.reset_off, 0);	/* Reset Off */
@@ -518,15 +518,19 @@ Sedl_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return(0);
 }
 
+#ifdef CONFIG_PCI
 static struct pci_dev *dev_sedl __devinitdata = NULL;
+u16 sub_vendor_id __devinitdata = 0;
+u16 sub_id __devinitdata = 0;
+#endif
 
 #ifdef __ISAPNP__
 static struct isapnp_device_id sedl_ids[] __devinitdata = {
 	{ ISAPNP_VENDOR('S', 'A', 'G'), ISAPNP_FUNCTION(0x01),
-	  ISAPNP_VENDOR('S', 'A', 'G'), ISAPNP_FUNCTION(0x01), 
+	  ISAPNP_VENDOR('S', 'A', 'G'), ISAPNP_FUNCTION(0x01),
 	  (unsigned long) "Speed win" },
 	{ ISAPNP_VENDOR('S', 'A', 'G'), ISAPNP_FUNCTION(0x02),
-	  ISAPNP_VENDOR('S', 'A', 'G'), ISAPNP_FUNCTION(0x02), 
+	  ISAPNP_VENDOR('S', 'A', 'G'), ISAPNP_FUNCTION(0x02),
 	  (unsigned long) "Speed Fax+" },
 	{ 0, }
 };
@@ -541,21 +545,20 @@ setup_sedlbauer(struct IsdnCard *card)
 	int bytecnt, ver, val;
 	struct IsdnCardState *cs = card->cs;
 	char tmp[64];
-	u16 sub_vendor_id, sub_id;
 
 	strcpy(tmp, Sedlbauer_revision);
 	printk(KERN_INFO "HiSax: Sedlbauer driver Rev. %s\n", HiSax_getrev(tmp));
-	
- 	if (cs->typ == ISDN_CTYPE_SEDLBAUER) {
- 		cs->subtyp = SEDL_SPEED_CARD_WIN;
+
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
  	} else
@@ -616,7 +619,7 @@ setup_sedlbauer(struct IsdnCard *card)
 				}
 				ipid++;
 				pnp_c = NULL;
-			} 
+			}
 			if (!ipid->card_vendor) {
 				printk(KERN_INFO "Sedlbauer PnP: no ISAPnP card found\n");
 			}
@@ -682,10 +685,10 @@ setup_sedlbauer(struct IsdnCard *card)
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
@@ -717,7 +720,7 @@ ready:
  * testing ISA and PCMCIA Cards for IPAC, default is ISAC
  * do not test for PCI card, because ports are different
  * and PCI card uses only IPAC (for the moment)
- */	
+ */
 	if (cs->hw.sedl.bus != SEDL_BUS_PCI) {
 		val = readreg(cs->hw.sedl.cfg_reg + SEDL_IPAC_ANY_ADR,
 			cs->hw.sedl.cfg_reg + SEDL_IPAC_ANY_IPAC, IPAC_ID);
@@ -829,7 +832,7 @@ ready:
 			}
 			cs->irq_func = &sedlbauer_interrupt;
 			ISACVersion(cs, "Sedlbauer:");
-		
+
 			if (HscxVersion(cs, "Sedlbauer:")) {
 				printk(KERN_WARNING
 					"Sedlbauer: wrong HSCX versions check IO address\n");
