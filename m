Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXJ2Su5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXJ2Su5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbXJ2Suu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:50:50 -0400
Received: from havoc.gtf.org ([69.61.125.42]:34831 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbXJ2Sut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:50:49 -0400
Date: Mon, 29 Oct 2007 14:50:48 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kkeil@suse.de
Subject: [RFC / git patch] Move pci_find_* under CONFIG_PCI_LEGACY
Message-ID: <20071029185047.GA4951@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am actively working on killing the remaining users of
pci_find_device().  The results can be found in the 'isdn-pci' and
'warnings' branches of jgarzik/misc-2.6.git.  Time consuming work
converting ancient drivers to PCI hotplug API, but it's almost done.

HOWEVER, given the limited number of drivers that are turned off when
that API is disabled, I felt it would be nice to provide the option
of eliminating the pci_find_* warnings that emit on every build (due
to presence in drivers/pci/search.c).

Please consider pulling from 'pci-legacy' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git pci-legacy

to receive the following updates:

 drivers/isdn/hisax/Kconfig     |   18 +++++++++---------
 drivers/isdn/hisax/avm_pci.c   |    4 ++--
 drivers/isdn/hisax/diva.c      |    6 +++---
 drivers/isdn/hisax/elsa.c      |    4 ++--
 drivers/isdn/hisax/gazel.c     |    4 +++-
 drivers/isdn/hisax/niccy.c     |    7 ++++---
 drivers/isdn/hisax/sedlbauer.c |    4 ++--
 drivers/pci/Kconfig            |   11 +++++++++++
 drivers/pci/hotplug/Kconfig    |    6 +++---
 drivers/pci/search.c           |    9 +++++++++
 drivers/scsi/Kconfig           |    2 +-
 include/linux/pci.h            |    3 +++
 12 files changed, 52 insertions(+), 26 deletions(-)

Jeff Garzik (1):
      [PCI] Add Kconfig option to disable deprecated pci_find_* API

diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
index a3b945a..7832d8b 100644
--- a/drivers/isdn/hisax/Kconfig
+++ b/drivers/isdn/hisax/Kconfig
@@ -109,7 +109,7 @@ config HISAX_16_3
 
 config HISAX_TELESPCI
 	bool "Teles PCI"
-	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Teles PCI.
 	  See <file:Documentation/isdn/README.HiSax> on how to configure it.
@@ -237,7 +237,7 @@ config HISAX_MIC
 
 config HISAX_NETJET
 	bool "NETjet card"
-	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the NetJet from Traverse
 	  Technologies.
@@ -248,7 +248,7 @@ config HISAX_NETJET
 
 config HISAX_NETJET_U
 	bool "NETspider U card"
-	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Netspider U interface ISDN card
 	  from Traverse Technologies.
@@ -287,7 +287,7 @@ config HISAX_HSTSAPHIR
 
 config HISAX_BKM_A4T
 	bool "Telekom A4T card"
-	depends on PCI
+	depends on PCI && PCI_LEGACY
 	help
 	  This enables HiSax support for the Telekom A4T card.
 
@@ -297,7 +297,7 @@ config HISAX_BKM_A4T
 
 config HISAX_SCT_QUADRO
 	bool "Scitel Quadro card"
-	depends on PCI
+	depends on PCI && PCI_LEGACY
 	help
 	  This enables HiSax support for the Scitel Quadro card.
 
@@ -316,7 +316,7 @@ config HISAX_GAZEL
 
 config HISAX_HFC_PCI
 	bool "HFC PCI-Bus cards"
-	depends on PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	depends on PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the HFC-S PCI 2BDS0 based cards.
 
@@ -325,7 +325,7 @@ config HISAX_HFC_PCI
 
 config HISAX_W6692
 	bool "Winbond W6692 based cards"
-	depends on PCI
+	depends on PCI && PCI_LEGACY
 	help
 	  This enables HiSax support for Winbond W6692 based PCI ISDN cards.
 
@@ -341,7 +341,7 @@ config HISAX_HFC_SX
 
 config HISAX_ENTERNOW_PCI
 	bool "Formula-n enter:now PCI card"
-	depends on HISAX_NETJET && PCI && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
+	depends on HISAX_NETJET && PCI && PCI_LEGACY && (BROKEN || !(SPARC || PPC || PARISC || M68K || (MIPS && !CPU_LITTLE_ENDIAN) || FRV))
 	help
 	  This enables HiSax support for the Formula-n enter:now PCI
 	  ISDN card.
@@ -411,7 +411,7 @@ config HISAX_HFC4S8S
 
 config HISAX_FRITZ_PCIPNP
 	tristate "AVM Fritz!Card PCI/PCIv2/PnP support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && PCI_LEGACY && EXPERIMENTAL
 	help
 	  This enables the driver for the AVM Fritz!Card PCI,
 	  Fritz!Card PCI v2 and Fritz!Card PnP.
diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index f8b7978..035d158 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -830,7 +830,7 @@ static int __devinit avm_pnp_setup(struct IsdnCardState *cs)
 
 #endif /* __ISAPNP__ */
 
-#ifndef CONFIG_PCI
+#ifndef CONFIG_PCI_LEGACY
 
 static int __devinit avm_pci_setup(struct IsdnCardState *cs)
 {
@@ -872,7 +872,7 @@ static int __devinit avm_pci_setup(struct IsdnCardState *cs)
 	return (1);
 }
 
-#endif /* CONFIG_PCI */
+#endif /* CONFIG_PCI_LEGACY */
 
 int __devinit
 setup_avm_pcipnp(struct IsdnCard *card)
diff --git a/drivers/isdn/hisax/diva.c b/drivers/isdn/hisax/diva.c
index 8267450..2d67085 100644
--- a/drivers/isdn/hisax/diva.c
+++ b/drivers/isdn/hisax/diva.c
@@ -1148,7 +1148,7 @@ static int __devinit setup_diva_isapnp(struct IsdnCard *card)
 
 #endif	/* ISAPNP */
 
-#ifdef CONFIG_PCI
+#ifdef CONFIG_PCI_LEGACY
 static struct pci_dev *dev_diva __devinitdata = NULL;
 static struct pci_dev *dev_diva_u __devinitdata = NULL;
 static struct pci_dev *dev_diva201 __devinitdata = NULL;
@@ -1229,14 +1229,14 @@ static int __devinit setup_diva_pci(struct IsdnCard *card)
 	return (1);		/* card found */
 }
 
-#else	/* if !CONFIG_PCI */
+#else	/* if !CONFIG_PCI_LEGACY */
 
 static int __devinit setup_diva_pci(struct IsdnCard *card)
 {
 	return (-1);	/* card not found; continue search */
 }
 
-#endif	/* CONFIG_PCI */
+#endif	/* CONFIG_PCI_LEGACY */
 
 int __devinit
 setup_diva(struct IsdnCard *card)
diff --git a/drivers/isdn/hisax/elsa.c b/drivers/isdn/hisax/elsa.c
index 948a9b2..2b2677b 100644
--- a/drivers/isdn/hisax/elsa.c
+++ b/drivers/isdn/hisax/elsa.c
@@ -1025,7 +1025,7 @@ setup_elsa_pcmcia(struct IsdnCard *card)
 	       cs->irq);
 }
 
-#ifdef CONFIG_PCI
+#ifdef CONFIG_PCI_LEGACY
 static 	struct pci_dev *dev_qs1000 __devinitdata = NULL;
 static 	struct pci_dev *dev_qs3000 __devinitdata = NULL;
 
@@ -1093,7 +1093,7 @@ setup_elsa_pci(struct IsdnCard *card)
 {
 	return (1);
 }
-#endif /* CONFIG_PCI */
+#endif /* CONFIG_PCI_LEGACY */
 
 static int __devinit
 setup_elsa_common(struct IsdnCard *card)
diff --git a/drivers/isdn/hisax/gazel.c b/drivers/isdn/hisax/gazel.c
index 3efa719..f66620a 100644
--- a/drivers/isdn/hisax/gazel.c
+++ b/drivers/isdn/hisax/gazel.c
@@ -532,6 +532,7 @@ setup_gazelisa(struct IsdnCard *card, struct IsdnCardState *cs)
 	return (0);
 }
 
+#ifdef CONFIG_PCI_LEGACY
 static struct pci_dev *dev_tel __devinitdata = NULL;
 
 static int __devinit
@@ -620,6 +621,7 @@ setup_gazelpci(struct IsdnCardState *cs)
 
 	return (0);
 }
+#endif /* CONFIG_PCI_LEGACY */
 
 int __devinit
 setup_gazel(struct IsdnCard *card)
@@ -639,7 +641,7 @@ setup_gazel(struct IsdnCard *card)
 			return (0);
 	} else {
 
-#ifdef CONFIG_PCI
+#ifdef CONFIG_PCI_LEGACY
 		if (setup_gazelpci(cs))
 			return (0);
 #else
diff --git a/drivers/isdn/hisax/niccy.c b/drivers/isdn/hisax/niccy.c
index e5918c6..bd99211 100644
--- a/drivers/isdn/hisax/niccy.c
+++ b/drivers/isdn/hisax/niccy.c
@@ -223,7 +223,6 @@ static int niccy_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 	return 0;
 }
 
-static struct pci_dev *niccy_dev __devinitdata = NULL;
 #ifdef __ISAPNP__
 static struct pnp_card *pnp_c __devinitdata = NULL;
 #endif
@@ -299,7 +298,9 @@ int __devinit setup_niccy(struct IsdnCard *card)
 			return 0;
 		}
 	} else {
-#ifdef CONFIG_PCI
+#ifdef CONFIG_PCI_LEGACY
+		static struct pci_dev *niccy_dev __devinitdata;
+
 		u_int pci_ioaddr;
 		cs->subtyp = 0;
 		if ((niccy_dev = pci_find_device(PCI_VENDOR_ID_SATSAGEM,
@@ -356,7 +357,7 @@ int __devinit setup_niccy(struct IsdnCard *card)
 		printk(KERN_WARNING "Niccy: io0 0 and NO_PCI_BIOS\n");
 		printk(KERN_WARNING "Niccy: unable to config NICCY PCI\n");
 		return 0;
-#endif				/* CONFIG_PCI */
+#endif				/* CONFIG_PCI_LEGACY */
 	}
 	printk(KERN_INFO "HiSax: %s %s config irq:%d data:0x%X ale:0x%X\n",
 		CardType[cs->typ], (cs->subtyp == 1) ? "PnP" : "PCI",
diff --git a/drivers/isdn/hisax/sedlbauer.c b/drivers/isdn/hisax/sedlbauer.c
index 03dfc32..95425f3 100644
--- a/drivers/isdn/hisax/sedlbauer.c
+++ b/drivers/isdn/hisax/sedlbauer.c
@@ -600,7 +600,7 @@ setup_sedlbauer_isapnp(struct IsdnCard *card, int *bytecnt)
 }
 #endif /* __ISAPNP__ */
 
-#ifdef CONFIG_PCI
+#ifdef CONFIG_PCI_LEGACY
 static struct pci_dev *dev_sedl __devinitdata = NULL;
 
 static int __devinit
@@ -675,7 +675,7 @@ setup_sedlbauer_pci(struct IsdnCard *card)
 	return (1);
 }
 
-#endif /* CONFIG_PCI */
+#endif /* CONFIG_PCI_LEGACY */
 
 int __devinit
 setup_sedlbauer(struct IsdnCard *card)
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 7a1d6d5..e1ca425 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -21,6 +21,17 @@ config PCI_MSI
 
 	   If you don't know what to do here, say N.
 
+config PCI_LEGACY
+	bool "Enable deprecated pci_find_* API"
+	depends on PCI
+	default y
+	help
+	  Say Y here if you want to include support for the deprecated
+	  pci_find_slot() and pci_find_device() APIs.  Most drivers have
+	  been converted over to using the proper hotplug APIs, so this
+	  option serves to include/exclude only a few drivers that are
+	  still using this API.
+
 config PCI_DEBUG
 	bool "PCI Debugging"
 	depends on PCI && DEBUG_KERNEL
diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index 63d6275..a64449d 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -41,7 +41,7 @@ config HOTPLUG_PCI_FAKE
 
 config HOTPLUG_PCI_COMPAQ
 	tristate "Compaq PCI Hotplug driver"
-	depends on X86 && PCI_BIOS
+	depends on X86 && PCI_BIOS && PCI_LEGACY
 	help
 	  Say Y here if you have a motherboard with a Compaq PCI Hotplug
 	  controller.
@@ -63,7 +63,7 @@ config HOTPLUG_PCI_COMPAQ_NVRAM
 
 config HOTPLUG_PCI_IBM
 	tristate "IBM PCI Hotplug driver"
-	depends on X86_IO_APIC && X86 && PCI_BIOS
+	depends on X86_IO_APIC && X86 && PCI_BIOS && PCI_LEGACY
 	help
 	  Say Y here if you have a motherboard with a IBM PCI Hotplug
 	  controller.
@@ -119,7 +119,7 @@ config HOTPLUG_PCI_CPCI_ZT5550
 
 config HOTPLUG_PCI_CPCI_GENERIC
 	tristate "Generic port I/O CompactPCI Hotplug driver"
-	depends on HOTPLUG_PCI_CPCI && X86
+	depends on HOTPLUG_PCI_CPCI && X86 && PCI_LEGACY
 	help
 	  Say Y here if you have a CompactPCI system card that exposes the #ENUM
 	  hotswap signal as a bit in a system register that can be read through
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index b001b59..8541034 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -113,6 +113,8 @@ pci_find_next_bus(const struct pci_bus *from)
 	return b;
 }
 
+#ifdef CONFIG_PCI_LEGACY
+
 /**
  * pci_find_slot - locate PCI device from a given PCI slot
  * @bus: number of PCI bus on which desired PCI device resides
@@ -137,6 +139,8 @@ pci_find_slot(unsigned int bus, unsigned int devfn)
 	return NULL;
 }
 
+#endif /* CONFIG_PCI_LEGACY */
+
 /**
  * pci_get_slot - locate PCI device for a given PCI slot
  * @bus: PCI bus on which desired PCI device resides
@@ -200,6 +204,7 @@ struct pci_dev * pci_get_bus_and_slot(unsigned int bus, unsigned int devfn)
 	return NULL;
 }
 
+#ifdef CONFIG_PCI_LEGACY
 /**
  * pci_find_subsys - begin or continue searching for a PCI device by vendor/subvendor/device/subdevice id
  * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
@@ -278,6 +283,7 @@ pci_find_device(unsigned int vendor, unsigned int device, const struct pci_dev *
 {
 	return pci_find_subsys(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
 }
+#endif /* CONFIG_PCI_LEGACY */
 
 /**
  * pci_get_subsys - begin or continue searching for a PCI device by vendor/subvendor/device/subdevice id
@@ -468,8 +474,11 @@ int pci_dev_present(const struct pci_device_id *ids)
 EXPORT_SYMBOL(pci_dev_present);
 EXPORT_SYMBOL(pci_find_present);
 
+#ifdef CONFIG_PCI_LEGACY
 EXPORT_SYMBOL(pci_find_device);
 EXPORT_SYMBOL(pci_find_slot);
+#endif /* CONFIG_PCI_LEGACY */
+
 /* For boot time work */
 EXPORT_SYMBOL(pci_find_bus);
 EXPORT_SYMBOL(pci_find_next_bus);
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a5763c6..d6d3fdc 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -725,7 +725,7 @@ config SCSI_FD_MCS
 
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
-	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
+	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API && PCI_LEGACY
 	---help---
 	  Formerly called GDT SCSI Disk Array Controller Support.
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5d2281f..d97e8bb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -479,8 +479,11 @@ extern void pci_sort_breadthfirst(void);
 
 /* Generic PCI functions exported to card drivers */
 
+#ifdef CONFIG_PCI_LEGACY
 struct pci_dev __deprecated *pci_find_device (unsigned int vendor, unsigned int device, const struct pci_dev *from);
 struct pci_dev __deprecated *pci_find_slot (unsigned int bus, unsigned int devfn);
+#endif /* CONFIG_PCI_LEGACY */
+
 int pci_find_capability (struct pci_dev *dev, int cap);
 int pci_find_next_capability (struct pci_dev *dev, u8 pos, int cap);
 int pci_find_ext_capability (struct pci_dev *dev, int cap);
