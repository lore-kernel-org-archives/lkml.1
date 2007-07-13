Return-Path: <linux-kernel-owner+w=401wt.eu-S938011AbXGMXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938011AbXGMXES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbXGMXEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:04:04 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:33843 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757574AbXGMXEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:04:01 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/12] drivers/isdn/hisax/nj_u.c: replace pci_find_device with pci_get_device
Date: Sat, 14 Jul 2007 02:03:45 +0300
User-Agent: KMail/1.9.7
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de
References: <200707140144.49983.caglar@pardus.org.tr>
In-Reply-To: <200707140144.49983.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707140203.47008.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[resend] i forget to quilt refresh :(, sorry for noise

14 Tem 2007 Cts tarihinde, S.Çağlar Onur şunları yazmıştı: 
> ---
>  drivers/isdn/hisax/nj_u.c |   21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

Following patch replaces pci_find_device with pci_get_device to avoid 
following compiliation warning;

drivers/isdn/hisax/nj_u.c: In function `setup_netjet_u':
drivers/isdn/hisax/nj_u.c:154: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:478)

and also removes trailing whitespaces at the ends of lines and converts 
smarttabs/whitespaces into real tabs

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

---
 drivers/isdn/hisax/nj_u.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/isdn/hisax/nj_u.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hisax/nj_u.c
+++ linux-2.6/drivers/isdn/hisax/nj_u.c
@@ -151,20 +151,20 @@ setup_netjet_u(struct IsdnCard *card)
 
 	for ( ;; )
 	{
-		if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
+		if ((dev_netjet = pci_get_device(PCI_VENDOR_ID_TIGERJET,
 			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
 			if (pci_enable_device(dev_netjet))
-				return(0);
+				goto dev_netjet_cleanup;
 			pci_set_master(dev_netjet);
 			cs->irq = dev_netjet->irq;
 			if (!cs->irq) {
 				printk(KERN_WARNING "NETspider-U: No IRQ for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 			cs->hw.njet.base = pci_resource_start(dev_netjet, 0);
 			if (!cs->hw.njet.base) {
 				printk(KERN_WARNING "NETspider-U: No IO-Adr for PCI card found\n");
-				return(0);
+				goto dev_netjet_cleanup;
 			}
 		} else {
 			printk(KERN_WARNING "NETspider-U: No PCI card found\n");
@@ -202,9 +202,9 @@ setup_netjet_u(struct IsdnCard *card)
 
 			default :
 				printk( KERN_WARNING "NETspider-U: No PCI card found\n" );
-				return 0;
-                }
-                break;
+				goto dev_netjet_cleanup;
+		}
+		break;
 	}
 #else
 
@@ -225,7 +225,7 @@ setup_netjet_u(struct IsdnCard *card)
 		       CardType[card->typ],
 		       cs->hw.njet.base,
 		       cs->hw.njet.base + bytecnt);
-		return (0);
+		goto dev_netjet_cleanup;
 	}
 	setup_icc(cs);
 	cs->readisac  = &NETjet_ReadIC;
@@ -239,5 +239,10 @@ setup_netjet_u(struct IsdnCard *card)
 	cs->irq_func = &netjet_u_interrupt;
 	cs->irq_flags |= IRQF_SHARED;
 	ICCVersion(cs, "NETspider-U:");
+	pci_dev_put(dev_netjet);
 	return (1);
+
+dev_netjet_cleanup:
+	pci_dev_put(dev_netjet);
+	return (0);
 }

-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
