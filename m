Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbYFGMO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbYFGMO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 08:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYFGMOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 08:14:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:42050 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYFGMOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 08:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=k9D20NNZqYFOspD+8ktzop1ocb1awJX8y/5VCrWn6M2ttvPHvnp3QJBdurv/jSWkUh
         WR7tV3oE+jg+Hc0n2KRORpBHicUHtqb9jk+9+ztNuCDp+yeO+FTdGu3bKsSd+ZcMYXb5
         eIcX6SWQqtCKHntw9v8+ONpr4g4JqpRsffz8A=
Date: Sat, 7 Jun 2008 14:14:35 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] [patch] x86: coding style fixes to arch/x86/pci/irq.
Message-ID: <20080607141435.0ab5fa48@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 60 errors, 85 warnings, 1237 lines checked

After:
total: 1 errors, 82 warnings, 1226 lines checked

WARNING: line over 80 characters

Compile tested.

paolo@paolo-desktop:/tmp$ size irq.o.*
   text    data     bss     dec     hex filename
   6128     440      76    6644    19f4 irq.o.after
   6128     440      76    6644    19f4 irq.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/pci/irq.c |  261 +++++++++++++++++++++++++---------------------------
 1 files changed, 125 insertions(+), 136 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index ca8df9c..f0859de 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -11,8 +11,8 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/dmi.h>
-#include <asm/io.h>
-#include <asm/smp.h>
+#include <linux/io.h>
+#include <linux/smp.h>
 #include <asm/io_apic.h>
 #include <linux/irq.h>
 #include <linux/acpi.h>
@@ -61,7 +61,7 @@ void (*pcibios_disable_irq)(struct pci_dev *dev) = NULL;
  *  and perform checksum verification.
  */
 
-static inline struct irq_routing_table * pirq_check_routing_table(u8 *addr)
+static inline struct irq_routing_table *pirq_check_routing_table(u8 *addr)
 {
 	struct irq_routing_table *rt;
 	int i;
@@ -74,7 +74,7 @@ static inline struct irq_routing_table * pirq_check_routing_table(u8 *addr)
 	    rt->size < sizeof(struct irq_routing_table))
 		return NULL;
 	sum = 0;
-	for (i=0; i < rt->size; i++)
+	for (i = 0; i < rt->size; i++)
 		sum += addr[i];
 	if (!sum) {
 		DBG(KERN_DEBUG "PCI: Interrupt Routing Table found at 0x%p\n", rt);
@@ -100,7 +100,7 @@ static struct irq_routing_table * __init pirq_find_routing_table(void)
 			return rt;
 		printk(KERN_WARNING "PCI: PIRQ table NOT found at pirqaddr\n");
 	}
-	for(addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000); addr += 16) {
+	for (addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000); addr += 16) {
 		rt = pirq_check_routing_table(addr);
 		if (rt)
 			return rt;
@@ -122,20 +122,20 @@ static void __init pirq_peer_trick(void)
 	struct irq_info *e;
 
 	memset(busmap, 0, sizeof(busmap));
-	for(i=0; i < (rt->size - sizeof(struct irq_routing_table)) / sizeof(struct irq_info); i++) {
+	for (i = 0; i < (rt->size - sizeof(struct irq_routing_table)) / sizeof(struct irq_info); i++) {
 		e = &rt->slots[i];
 #ifdef DEBUG
 		{
 			int j;
 			DBG(KERN_DEBUG "%02x:%02x slot=%02x", e->bus, e->devfn/8, e->slot);
-			for(j=0; j<4; j++)
+			for (j = 0; j < 4; j++)
 				DBG(" %d:%02x/%04x", j, e->irq[j].link, e->irq[j].bitmap);
 			DBG("\n");
 		}
 #endif
 		busmap[e->bus] = 1;
 	}
-	for(i = 1; i < 256; i++) {
+	for (i = 1; i < 256; i++) {
 		int node;
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
@@ -285,7 +285,7 @@ static int pirq_ite_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 	static const unsigned char pirqmap[4] = { 1, 0, 2, 3 };
 
 	WARN_ON_ONCE(pirq > 4);
-	return read_config_nybble(router,0x43, pirqmap[pirq-1]);
+	return read_config_nybble(router, 0x43, pirqmap[pirq-1]);
 }
 
 static int pirq_ite_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
@@ -314,7 +314,7 @@ static int pirq_opti_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
 
 /*
  * Cyrix: nibble offset 0x5C
- * 0x5C bits 7:4 is INTB bits 3:0 is INTA 
+ * 0x5C bits 7:4 is INTB bits 3:0 is INTA
  * 0x5D bits 7:4 is INTD bits 3:0 is INTC
  */
 static int pirq_cyrix_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
@@ -350,7 +350,7 @@ static int pirq_cyrix_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
  *	Apparently there are systems implementing PCI routing table using
  *	link values 0x01-0x04 and others using 0x41-0x44 for PCI INTA..D.
  *	We try our best to handle both link mappings.
- *	
+ *
  *	Currently (2003-05-21) it appears most SiS chipsets follow the
  *	definition of routing registers from the SiS-5595 southbridge.
  *	According to the SiS 5595 datasheets the revision id's of the
@@ -370,7 +370,7 @@ static int pirq_cyrix_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
  *
  *	0x62:	USBIRQ:
  *		bit 6 OHCI function disabled (0), enabled (1)
- *	
+ *
  *	0x6a:	ACPI/SCI IRQ: bits 4-6 reserved
  *
  *	0x7e:	Data Acq. Module IRQ - bits 4-6 reserved
@@ -487,9 +487,7 @@ static int pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev, int pirq
 	u8 irq;
 	irq = 0;
 	if (pirq <= 4)
-	{
 		irq = read_config_nybble(router, 0x56, pirq - 1);
-	}
 	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d get irq : %2d\n",
 		dev->vendor, dev->device, pirq, irq);
 	return irq;
@@ -497,12 +495,10 @@ static int pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev, int pirq
 
 static int pirq_amd756_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
 {
-	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d SET irq : %2d\n", 
+	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d SET irq : %2d\n",
 		dev->vendor, dev->device, pirq, irq);
 	if (pirq <= 4)
-	{
 		write_config_nybble(router, 0x56, pirq - 1, irq);
-	}
 	return 1;
 }
 
@@ -549,50 +545,49 @@ static __init int intel_router_probe(struct irq_router *r, struct pci_dev *route
 	if (pci_dev_present(pirq_440gx))
 		return 0;
 
-	switch(device)
-	{
-		case PCI_DEVICE_ID_INTEL_82371FB_0:
-		case PCI_DEVICE_ID_INTEL_82371SB_0:
-		case PCI_DEVICE_ID_INTEL_82371AB_0:
-		case PCI_DEVICE_ID_INTEL_82371MX:
-		case PCI_DEVICE_ID_INTEL_82443MX_0:
-		case PCI_DEVICE_ID_INTEL_82801AA_0:
-		case PCI_DEVICE_ID_INTEL_82801AB_0:
-		case PCI_DEVICE_ID_INTEL_82801BA_0:
-		case PCI_DEVICE_ID_INTEL_82801BA_10:
-		case PCI_DEVICE_ID_INTEL_82801CA_0:
-		case PCI_DEVICE_ID_INTEL_82801CA_12:
-		case PCI_DEVICE_ID_INTEL_82801DB_0:
-		case PCI_DEVICE_ID_INTEL_82801E_0:
-		case PCI_DEVICE_ID_INTEL_82801EB_0:
-		case PCI_DEVICE_ID_INTEL_ESB_1:
-		case PCI_DEVICE_ID_INTEL_ICH6_0:
-		case PCI_DEVICE_ID_INTEL_ICH6_1:
-		case PCI_DEVICE_ID_INTEL_ICH7_0:
-		case PCI_DEVICE_ID_INTEL_ICH7_1:
-		case PCI_DEVICE_ID_INTEL_ICH7_30:
-		case PCI_DEVICE_ID_INTEL_ICH7_31:
-		case PCI_DEVICE_ID_INTEL_ESB2_0:
-		case PCI_DEVICE_ID_INTEL_ICH8_0:
-		case PCI_DEVICE_ID_INTEL_ICH8_1:
-		case PCI_DEVICE_ID_INTEL_ICH8_2:
-		case PCI_DEVICE_ID_INTEL_ICH8_3:
-		case PCI_DEVICE_ID_INTEL_ICH8_4:
-		case PCI_DEVICE_ID_INTEL_ICH9_0:
-		case PCI_DEVICE_ID_INTEL_ICH9_1:
-		case PCI_DEVICE_ID_INTEL_ICH9_2:
-		case PCI_DEVICE_ID_INTEL_ICH9_3:
-		case PCI_DEVICE_ID_INTEL_ICH9_4:
-		case PCI_DEVICE_ID_INTEL_ICH9_5:
-		case PCI_DEVICE_ID_INTEL_TOLAPAI_0:
-		case PCI_DEVICE_ID_INTEL_ICH10_0:
-		case PCI_DEVICE_ID_INTEL_ICH10_1:
-		case PCI_DEVICE_ID_INTEL_ICH10_2:
-		case PCI_DEVICE_ID_INTEL_ICH10_3:
-			r->name = "PIIX/ICH";
-			r->get = pirq_piix_get;
-			r->set = pirq_piix_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_INTEL_82371FB_0:
+	case PCI_DEVICE_ID_INTEL_82371SB_0:
+	case PCI_DEVICE_ID_INTEL_82371AB_0:
+	case PCI_DEVICE_ID_INTEL_82371MX:
+	case PCI_DEVICE_ID_INTEL_82443MX_0:
+	case PCI_DEVICE_ID_INTEL_82801AA_0:
+	case PCI_DEVICE_ID_INTEL_82801AB_0:
+	case PCI_DEVICE_ID_INTEL_82801BA_0:
+	case PCI_DEVICE_ID_INTEL_82801BA_10:
+	case PCI_DEVICE_ID_INTEL_82801CA_0:
+	case PCI_DEVICE_ID_INTEL_82801CA_12:
+	case PCI_DEVICE_ID_INTEL_82801DB_0:
+	case PCI_DEVICE_ID_INTEL_82801E_0:
+	case PCI_DEVICE_ID_INTEL_82801EB_0:
+	case PCI_DEVICE_ID_INTEL_ESB_1:
+	case PCI_DEVICE_ID_INTEL_ICH6_0:
+	case PCI_DEVICE_ID_INTEL_ICH6_1:
+	case PCI_DEVICE_ID_INTEL_ICH7_0:
+	case PCI_DEVICE_ID_INTEL_ICH7_1:
+	case PCI_DEVICE_ID_INTEL_ICH7_30:
+	case PCI_DEVICE_ID_INTEL_ICH7_31:
+	case PCI_DEVICE_ID_INTEL_ESB2_0:
+	case PCI_DEVICE_ID_INTEL_ICH8_0:
+	case PCI_DEVICE_ID_INTEL_ICH8_1:
+	case PCI_DEVICE_ID_INTEL_ICH8_2:
+	case PCI_DEVICE_ID_INTEL_ICH8_3:
+	case PCI_DEVICE_ID_INTEL_ICH8_4:
+	case PCI_DEVICE_ID_INTEL_ICH9_0:
+	case PCI_DEVICE_ID_INTEL_ICH9_1:
+	case PCI_DEVICE_ID_INTEL_ICH9_2:
+	case PCI_DEVICE_ID_INTEL_ICH9_3:
+	case PCI_DEVICE_ID_INTEL_ICH9_4:
+	case PCI_DEVICE_ID_INTEL_ICH9_5:
+	case PCI_DEVICE_ID_INTEL_TOLAPAI_0:
+	case PCI_DEVICE_ID_INTEL_ICH10_0:
+	case PCI_DEVICE_ID_INTEL_ICH10_1:
+	case PCI_DEVICE_ID_INTEL_ICH10_2:
+	case PCI_DEVICE_ID_INTEL_ICH10_3:
+		r->name = "PIIX/ICH";
+		r->get = pirq_piix_get;
+		r->set = pirq_piix_set;
+		return 1;
 	}
 	return 0;
 }
@@ -606,7 +601,7 @@ static __init int via_router_probe(struct irq_router *r,
 	 * workarounds for some buggy BIOSes
 	 */
 	if (device == PCI_DEVICE_ID_VIA_82C586_0) {
-		switch(router->device) {
+		switch (router->device) {
 		case PCI_DEVICE_ID_VIA_82C686:
 			/*
 			 * Asus k7m bios wrongly reports 82C686A
@@ -631,7 +626,7 @@ static __init int via_router_probe(struct irq_router *r,
 		}
 	}
 
-	switch(device) {
+	switch (device) {
 	case PCI_DEVICE_ID_VIA_82C586_0:
 		r->name = "VIA";
 		r->get = pirq_via586_get;
@@ -654,13 +649,12 @@ static __init int via_router_probe(struct irq_router *r,
 
 static __init int vlsi_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_VLSI_82C534:
-			r->name = "VLSI 82C534";
-			r->get = pirq_vlsi_get;
-			r->set = pirq_vlsi_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_VLSI_82C534:
+		r->name = "VLSI 82C534";
+		r->get = pirq_vlsi_get;
+		r->set = pirq_vlsi_set;
+		return 1;
 	}
 	return 0;
 }
@@ -668,14 +662,13 @@ static __init int vlsi_router_probe(struct irq_router *r, struct pci_dev *router
 
 static __init int serverworks_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_SERVERWORKS_OSB4:
-		case PCI_DEVICE_ID_SERVERWORKS_CSB5:
-			r->name = "ServerWorks";
-			r->get = pirq_serverworks_get;
-			r->set = pirq_serverworks_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_SERVERWORKS_OSB4:
+	case PCI_DEVICE_ID_SERVERWORKS_CSB5:
+		r->name = "ServerWorks";
+		r->get = pirq_serverworks_get;
+		r->set = pirq_serverworks_set;
+		return 1;
 	}
 	return 0;
 }
@@ -684,7 +677,7 @@ static __init int sis_router_probe(struct irq_router *r, struct pci_dev *router,
 {
 	if (device != PCI_DEVICE_ID_SI_503)
 		return 0;
-		
+
 	r->name = "SIS";
 	r->get = pirq_sis_get;
 	r->set = pirq_sis_set;
@@ -693,47 +686,43 @@ static __init int sis_router_probe(struct irq_router *r, struct pci_dev *router,
 
 static __init int cyrix_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_CYRIX_5520:
-			r->name = "NatSemi";
-			r->get = pirq_cyrix_get;
-			r->set = pirq_cyrix_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_CYRIX_5520:
+		r->name = "NatSemi";
+		r->get = pirq_cyrix_get;
+		r->set = pirq_cyrix_set;
+		return 1;
 	}
 	return 0;
 }
 
 static __init int opti_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_OPTI_82C700:
-			r->name = "OPTI";
-			r->get = pirq_opti_get;
-			r->set = pirq_opti_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_OPTI_82C700:
+		r->name = "OPTI";
+		r->get = pirq_opti_get;
+		r->set = pirq_opti_set;
+		return 1;
 	}
 	return 0;
 }
 
 static __init int ite_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_ITE_IT8330G_0:
-			r->name = "ITE";
-			r->get = pirq_ite_get;
-			r->set = pirq_ite_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_ITE_IT8330G_0:
+		r->name = "ITE";
+		r->get = pirq_ite_get;
+		r->set = pirq_ite_set;
+		return 1;
 	}
 	return 0;
 }
 
 static __init int ali_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
+	switch (device) {
 	case PCI_DEVICE_ID_AL_M1533:
 	case PCI_DEVICE_ID_AL_M1563:
 		printk(KERN_DEBUG "PCI: Using ALI IRQ Router\n");
@@ -747,25 +736,24 @@ static __init int ali_router_probe(struct irq_router *r, struct pci_dev *router,
 
 static __init int amd_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_AMD_VIPER_740B:
-			r->name = "AMD756";
-			break;
-		case PCI_DEVICE_ID_AMD_VIPER_7413:
-			r->name = "AMD766";
-			break;
-		case PCI_DEVICE_ID_AMD_VIPER_7443:
-			r->name = "AMD768";
-			break;
-		default:
-			return 0;
+	switch (device) {
+	case PCI_DEVICE_ID_AMD_VIPER_740B:
+		r->name = "AMD756";
+		break;
+	case PCI_DEVICE_ID_AMD_VIPER_7413:
+		r->name = "AMD766";
+		break;
+	case PCI_DEVICE_ID_AMD_VIPER_7443:
+		r->name = "AMD768";
+		break;
+	default:
+		return 0;
 	}
 	r->get = pirq_amd756_get;
 	r->set = pirq_amd756_set;
 	return 1;
 }
-		
+
 static __init int pico_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
 {
 	switch (device) {
@@ -807,7 +795,7 @@ static struct pci_dev *pirq_router_dev;
  *	FIXME: should we have an option to say "generic for
  *	chipset" ?
  */
- 
+
 static void __init pirq_find_router(struct irq_router *r)
 {
 	struct irq_routing_table *rt = pirq_table;
@@ -826,7 +814,7 @@ static void __init pirq_find_router(struct irq_router *r)
 	r->name = "default";
 	r->get = NULL;
 	r->set = NULL;
-	
+
 	DBG(KERN_DEBUG "PCI: Attempting to find IRQ router for %04x:%04x\n",
 	    rt->rtr_vendor, rt->rtr_device);
 
@@ -837,7 +825,7 @@ static void __init pirq_find_router(struct irq_router *r)
 		return;
 	}
 
-	for( h = pirq_routers; h->vendor; h++) {
+	for (h = pirq_routers; h->vendor; h++) {
 		/* First look for a router match */
 		if (rt->rtr_vendor == h->vendor && h->probe(r, pirq_router_dev, rt->rtr_device))
 			break;
@@ -889,7 +877,7 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 
 	if (!pirq_table)
 		return 0;
-	
+
 	DBG(KERN_DEBUG "IRQ for %s[%c]", pci_name(dev), 'A' + pin);
 	info = pirq_get_info(dev);
 	if (!info) {
@@ -928,8 +916,10 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 	 */
 	newirq = dev->irq;
 	if (newirq && !((1 << newirq) & mask)) {
-		if ( pci_probe & PCI_USE_PIRQ_MASK) newirq = 0;
-		else printk("\n" KERN_WARNING
+		if (pci_probe & PCI_USE_PIRQ_MASK)
+			newirq = 0;
+		else
+			printk("\n" KERN_WARNING
 			"PCI: IRQ %i for device %s doesn't match PIRQ mask "
 			"- try pci=usepirqmask\n" KERN_DEBUG, newirq,
 			pci_name(dev));
@@ -949,8 +939,8 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 		irq = pirq & 0xf;
 		DBG(" -> hardcoded IRQ %d\n", irq);
 		msg = "Hardcoded";
-	} else if ( r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
-	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask)) ) {
+	} else if (r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
+	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask))) {
 		DBG(" -> got IRQ %d\n", irq);
 		msg = "Found";
 		eisa_set_level_irq(irq);
@@ -985,15 +975,15 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 			continue;
 		if (info->irq[pin].link == pirq) {
 			/* We refuse to override the dev->irq information. Give a warning! */
-		    	if ( dev2->irq && dev2->irq != irq && \
+			if (dev2->irq && dev2->irq != irq && \
 			(!(pci_probe & PCI_USE_PIRQ_MASK) || \
-			((1 << dev2->irq) & mask)) ) {
+			((1 << dev2->irq) & mask))) {
 #ifndef CONFIG_PCI_MSI
-		    		printk(KERN_INFO "IRQ routing conflict for %s, have irq %d, want irq %d\n",
+				printk(KERN_INFO "IRQ routing conflict for %s, have irq %d, want irq %d\n",
 				       pci_name(dev2), dev2->irq, irq);
 #endif
-		    		continue;
-		    	}
+				continue;
+			}
 			dev2->irq = irq;
 			pirq_penalty[irq]++;
 			if (dev != dev2)
@@ -1031,8 +1021,7 @@ static void __init pcibios_fixup_irqs(void)
 		/*
 		 * Recalculate IRQ numbers if we use the I/O APIC.
 		 */
-		if (io_apic_assign_pci_irqs)
-		{
+		if (io_apic_assign_pci_irqs) {
 			int irq;
 
 			if (pin) {
@@ -1045,10 +1034,10 @@ static void __init pcibios_fixup_irqs(void)
 	 * busses itself so we should get into this branch reliably.
 	 */
 				if (irq < 0 && dev->bus->parent) { /* go back to the bridge */
-					struct pci_dev * bridge = dev->bus->self;
+					struct pci_dev *bridge = dev->bus->self;
 
 					pin = (pin + PCI_SLOT(dev->devfn)) % 4;
-					irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number, 
+					irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 							PCI_SLOT(bridge->devfn), pin);
 					if (irq >= 0)
 						printk(KERN_WARNING "PCI: using PPB %s[%c] to get irq %d\n",
@@ -1138,7 +1127,7 @@ static int __init pcibios_irq_init(void)
 		pirq_find_router(&pirq_router);
 		if (pirq_table->exclusive_irqs) {
 			int i;
-			for (i=0; i<16; i++)
+			for (i = 0; i < 16; i++)
 				if (!(pirq_table->exclusive_irqs & (1 << i)))
 					pirq_penalty[i] += 100;
 		}
@@ -1203,10 +1192,10 @@ static int pirq_enable_irq(struct pci_dev *dev)
 			 */
 			temp_dev = dev;
 			while (irq < 0 && dev->bus->parent) { /* go back to the bridge */
-				struct pci_dev * bridge = dev->bus->self;
+				struct pci_dev *bridge = dev->bus->self;
 
 				pin = (pin + PCI_SLOT(dev->devfn)) % 4;
-				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number, 
+				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 						PCI_SLOT(bridge->devfn), pin);
 				if (irq >= 0)
 					printk(KERN_WARNING "PCI: using PPB %s[%c] to get irq %d\n",
-- 
1.5.6.rc1.21.g03300

