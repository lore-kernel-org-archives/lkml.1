Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbZFVOIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbZFVOIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZFVOIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:08:13 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:36812 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZFVOIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:08:12 -0400
Subject: [PATCH] PCI: remove pcibios_scan_all_fns()
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>
Date: Mon, 22 Jun 2009 08:08:07 -0600
Message-ID: <20090622140807.25509.54448.stgit@bob.kio>
User-Agent: StGit/0.14.3.385.gd87a.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was #define'd as 0 on all platforms, so let's get rid of it.

This change makes pci_scan_slot() slightly easier to read.

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 arch/alpha/include/asm/pci.h    |    1 -
 arch/arm/include/asm/pci.h      |    2 --
 arch/h8300/include/asm/pci.h    |    1 -
 arch/ia64/include/asm/pci.h     |    3 ---
 arch/mips/include/asm/pci.h     |    2 --
 arch/mn10300/include/asm/pci.h  |    2 --
 arch/parisc/include/asm/pci.h   |    1 -
 arch/powerpc/include/asm/pci.h  |    1 -
 arch/sh/include/asm/pci.h       |    1 -
 arch/sparc/include/asm/pci_32.h |    1 -
 arch/sparc/include/asm/pci_64.h |    1 -
 arch/um/include/asm/pci.h       |    1 -
 arch/x86/include/asm/pci.h      |    1 -
 drivers/pci/probe.c             |    3 +--
 include/asm-generic/pci.h       |    2 --
 15 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/arch/alpha/include/asm/pci.h b/arch/alpha/include/asm/pci.h
index d22ace9..dd8dcab 100644
--- a/arch/alpha/include/asm/pci.h
+++ b/arch/alpha/include/asm/pci.h
@@ -52,7 +52,6 @@ struct pci_controller {
    bus numbers.  */
 
 #define pcibios_assign_all_busses()	1
-#define pcibios_scan_all_fns(a, b)	0
 
 #define PCIBIOS_MIN_IO		alpha_mv.min_io_address
 #define PCIBIOS_MIN_MEM		alpha_mv.min_mem_address
diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
index 0abf386..226cddd 100644
--- a/arch/arm/include/asm/pci.h
+++ b/arch/arm/include/asm/pci.h
@@ -6,8 +6,6 @@
 
 #include <mach/hardware.h> /* for PCIBIOS_MIN_* */
 
-#define pcibios_scan_all_fns(a, b)	0
-
 #ifdef CONFIG_PCI_HOST_ITE8152
 /* ITE bridge requires setting latency timer to avoid early bus access
    termination by PIC bus mater devices
diff --git a/arch/h8300/include/asm/pci.h b/arch/h8300/include/asm/pci.h
index 97389b3..cc97620 100644
--- a/arch/h8300/include/asm/pci.h
+++ b/arch/h8300/include/asm/pci.h
@@ -8,7 +8,6 @@
  */
 
 #define pcibios_assign_all_busses()	0
-#define pcibios_scan_all_fns(a, b)	0
 
 static inline void pcibios_set_master(struct pci_dev *dev)
 {
diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index fcfca56..ceb1db1 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -17,7 +17,6 @@
  * loader.
  */
 #define pcibios_assign_all_busses()     0
-#define pcibios_scan_all_fns(a, b)	0
 
 #define PCIBIOS_MIN_IO		0x1000
 #define PCIBIOS_MIN_MEM		0x10000000
@@ -135,8 +134,6 @@ extern void pcibios_resource_to_bus(struct pci_dev *dev,
 extern void pcibios_bus_to_resource(struct pci_dev *dev,
 		struct resource *res, struct pci_bus_region *region);
 
-#define pcibios_scan_all_fns(a, b)	0
-
 #define HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 {
diff --git a/arch/mips/include/asm/pci.h b/arch/mips/include/asm/pci.h
index a68d111..5ebf825 100644
--- a/arch/mips/include/asm/pci.h
+++ b/arch/mips/include/asm/pci.h
@@ -65,8 +65,6 @@ extern int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin);
 
 extern unsigned int pcibios_assign_all_busses(void);
 
-#define pcibios_scan_all_fns(a, b)	0
-
 extern unsigned long PCIBIOS_MIN_IO;
 extern unsigned long PCIBIOS_MIN_MEM;
 
diff --git a/arch/mn10300/include/asm/pci.h b/arch/mn10300/include/asm/pci.h
index e58b9a4..c001149 100644
--- a/arch/mn10300/include/asm/pci.h
+++ b/arch/mn10300/include/asm/pci.h
@@ -106,8 +106,6 @@ extern void pcibios_bus_to_resource(struct pci_dev *dev,
 				    struct resource *res,
 				    struct pci_bus_region *region);
 
-#define pcibios_scan_all_fns(a, b)	0
-
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 {
 	return channel ? 15 : 14;
diff --git a/arch/parisc/include/asm/pci.h b/arch/parisc/include/asm/pci.h
index 7d842d6..64c7aa5 100644
--- a/arch/parisc/include/asm/pci.h
+++ b/arch/parisc/include/asm/pci.h
@@ -233,7 +233,6 @@ static inline void pcibios_register_hba(struct pci_hba_data *x)
  *   rp7420/8420 boxes and then revisit this issue.
  */
 #define pcibios_assign_all_busses()     (1)
-#define pcibios_scan_all_fns(a, b)	(0)
 
 #define PCIBIOS_MIN_IO          0x10
 #define PCIBIOS_MIN_MEM         0x1000 /* NBPG - but pci/setup-res.c dies */
diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index d9483c5..36057c8 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -40,7 +40,6 @@ struct pci_dev;
  */
 #define pcibios_assign_all_busses() \
 	(ppc_pci_has_flag(PPC_PCI_REASSIGN_ALL_BUS))
-#define pcibios_scan_all_fns(a, b)	0
 
 static inline void pcibios_set_master(struct pci_dev *dev)
 {
diff --git a/arch/sh/include/asm/pci.h b/arch/sh/include/asm/pci.h
index d3633f5..4163950 100644
--- a/arch/sh/include/asm/pci.h
+++ b/arch/sh/include/asm/pci.h
@@ -10,7 +10,6 @@
    or architectures with incomplete PCI setup by the loader */
 
 #define pcibios_assign_all_busses()	1
-#define pcibios_scan_all_fns(a, b)	0
 
 /*
  * A board can define one or more PCI channels that represent built-in (or
diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
index b41c4c1..810d924 100644
--- a/arch/sparc/include/asm/pci_32.h
+++ b/arch/sparc/include/asm/pci_32.h
@@ -10,7 +10,6 @@
  * or architectures with incomplete PCI setup by the loader.
  */
 #define pcibios_assign_all_busses()	0
-#define pcibios_scan_all_fns(a, b)	0
 
 #define PCIBIOS_MIN_IO		0UL
 #define PCIBIOS_MIN_MEM		0UL
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
index 7a1e356..a329708 100644
--- a/arch/sparc/include/asm/pci_64.h
+++ b/arch/sparc/include/asm/pci_64.h
@@ -10,7 +10,6 @@
  * or architectures with incomplete PCI setup by the loader.
  */
 #define pcibios_assign_all_busses()	0
-#define pcibios_scan_all_fns(a, b)	0
 
 #define PCIBIOS_MIN_IO		0UL
 #define PCIBIOS_MIN_MEM		0UL
diff --git a/arch/um/include/asm/pci.h b/arch/um/include/asm/pci.h
index 5992319..b44cf59 100644
--- a/arch/um/include/asm/pci.h
+++ b/arch/um/include/asm/pci.h
@@ -2,6 +2,5 @@
 #define __UM_PCI_H
 
 #define PCI_DMA_BUS_IS_PHYS     (1)
-#define pcibios_scan_all_fns(a, b)	0
 
 #endif
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index b51a1e8..73cd31c 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -48,7 +48,6 @@ extern unsigned int pcibios_assign_all_busses(void);
 #else
 #define pcibios_assign_all_busses()	0
 #endif
-#define pcibios_scan_all_fns(a, b)	0
 
 extern unsigned long pci_mem_start;
 #define PCIBIOS_MIN_IO		0x1000
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f1ae247..b613cad 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1056,8 +1056,7 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 	if (dev && !dev->is_added)	/* new device? */
 		nr++;
 
-	if ((dev && dev->multifunction) ||
-	    (!dev && pcibios_scan_all_fns(bus, devfn))) {
+	if (dev && dev->multifunction) {
 		for (fn = 1; fn < 8; fn++) {
 			dev = pci_scan_single_device(bus, devfn + fn);
 			if (dev) {
diff --git a/include/asm-generic/pci.h b/include/asm-generic/pci.h
index b4326b5..1a1496f 100644
--- a/include/asm-generic/pci.h
+++ b/include/asm-generic/pci.h
@@ -30,8 +30,6 @@ pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 	res->end = region->end;
 }
 
-#define pcibios_scan_all_fns(a, b)	0
-
 #ifndef HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 {

