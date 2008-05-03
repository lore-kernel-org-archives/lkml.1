Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbYECPNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbYECPNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYECPMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:12:36 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:48821 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756497AbYECPMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:12:33 -0400
From: monstr@seznam.cz
To: paulus@samba.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 1/2] OF: clean coding style - prom_parse.c
Date: Sat,  3 May 2008 17:13:45 +0200
Message-Id: <c382f7ff87d1502c20423742ad738e50a118cf62.1209827449.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1209827626-8562-1-git-send-email-monstr@seznam.cz>
References: <monstr@seznam.cz>
 <1209827626-8562-1-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/powerpc/kernel/prom_parse.c |   98 ++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 52 deletions(-)

diff --git a/arch/powerpc/kernel/prom_parse.c b/arch/powerpc/kernel/prom_parse.c
index 90eb3a3..7c6b07c 100644
--- a/arch/powerpc/kernel/prom_parse.c
+++ b/arch/powerpc/kernel/prom_parse.c
@@ -9,12 +9,6 @@
 #include <asm/prom.h>
 #include <asm/pci-bridge.h>
 
-#ifdef DEBUG
-#define DBG(fmt...) do { printk(fmt); } while(0)
-#else
-#define DBG(fmt...) do { } while(0)
-#endif
-
 #ifdef CONFIG_PPC64
 #define PRu64	"%lx"
 #else
@@ -31,21 +25,19 @@ static int __of_address_to_resource(struct device_node *dev,
 		const u32 *addrp, u64 size, unsigned int flags,
 		struct resource *r);
 
-
 /* Debug utility */
 #ifdef DEBUG
 static void of_dump_addr(const char *s, const u32 *addr, int na)
 {
-	printk("%s", s);
-	while(na--)
-		printk(" %08x", *(addr++));
-	printk("\n");
+	printk(KERN_INFO "%s", s);
+	while (na--)
+		printk(KERN_INFO " %08x", *(addr++));
+	printk(KERN_INFO "\n");
 }
 #else
 static void of_dump_addr(const char *s, const u32 *addr, int na) { }
 #endif
 
-
 /* Callbacks for bus specific translators */
 struct of_bus {
 	const char	*name;
@@ -82,8 +74,8 @@ static u64 of_bus_default_map(u32 *addr, const u32 *range,
 	s  = of_read_number(range + na + pna, ns);
 	da = of_read_number(addr, na);
 
-	DBG("OF: default map, cp="PRu64", s="PRu64", da="PRu64"\n",
-	    cp, s, da);
+	pr_debug("OF: default map, cp="PRu64", s="PRu64", da="PRu64"\n",
+		cp, s, da);
 
 	if (da < cp || da >= (cp + s))
 		return OF_BAD_ADDR;
@@ -107,7 +99,6 @@ static unsigned int of_bus_default_get_flags(const u32 *addr)
 	return IORESOURCE_MEM;
 }
 
-
 #ifdef CONFIG_PCI
 /*
  * PCI bus specific translator
@@ -141,7 +132,7 @@ static u64 of_bus_pci_map(u32 *addr, const u32 *range, int na, int ns, int pna)
 	s  = of_read_number(range + na + pna, ns);
 	da = of_read_number(addr + 1, na - 1);
 
-	DBG("OF: PCI map, cp="PRu64", s="PRu64", da="PRu64"\n", cp, s, da);
+	pr_debug("OF: PCI map, cp="PRu64", s="PRu64", da="PRu64"\n", cp, s, da);
 
 	if (da < cp || da >= (cp + s))
 		return OF_BAD_ADDR;
@@ -158,7 +149,7 @@ static unsigned int of_bus_pci_get_flags(const u32 *addr)
 	unsigned int flags = 0;
 	u32 w = addr[0];
 
-	switch((w >> 24) & 0x03) {
+	switch ((w >> 24) & 0x03) {
 	case 0x01:
 		flags |= IORESOURCE_IO;
 		break;
@@ -342,7 +333,7 @@ static u64 of_bus_isa_map(u32 *addr, const u32 *range, int na, int ns, int pna)
 	s  = of_read_number(range + na + pna, ns);
 	da = of_read_number(addr + 1, na - 1);
 
-	DBG("OF: ISA map, cp="PRu64", s="PRu64", da="PRu64"\n", cp, s, da);
+	pr_debug("OF: ISA map, cp="PRu64", s="PRu64", da="PRu64"\n", cp, s, da);
 
 	if (da < cp || da >= (cp + s))
 		return OF_BAD_ADDR;
@@ -366,11 +357,9 @@ static unsigned int of_bus_isa_get_flags(const u32 *addr)
 	return flags;
 }
 
-
 /*
  * Array of bus specific translators
  */
-
 static struct of_bus of_busses[] = {
 #ifdef CONFIG_PCI
 	/* PCI */
@@ -442,11 +431,11 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
 	if (ranges == NULL || rlen == 0) {
 		offset = of_read_number(addr, na);
 		memset(addr, 0, pna * 4);
-		DBG("OF: no ranges, 1:1 translation\n");
+		pr_debug("OF: no ranges, 1:1 translation\n");
 		goto finish;
 	}
 
-	DBG("OF: walking ranges...\n");
+	pr_debug("OF: walking ranges...\n");
 
 	/* Now walk through the ranges */
 	rlen /= 4;
@@ -457,20 +446,19 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
 			break;
 	}
 	if (offset == OF_BAD_ADDR) {
-		DBG("OF: not found !\n");
+		pr_debug("OF: not found !\n");
 		return 1;
 	}
 	memcpy(addr, ranges + na, 4 * pna);
 
  finish:
 	of_dump_addr("OF: parent translation for:", addr, pna);
-	DBG("OF: with offset: "PRu64"\n", offset);
+	pr_debug("OF: with offset: "PRu64"\n", offset);
 
 	/* Translate it into parent bus space */
 	return pbus->translate(addr, offset, pna);
 }
 
-
 /*
  * Translate an address from the device-tree into a CPU physical address,
  * this walks up the tree and applies the various bus mappings on the
@@ -490,7 +478,7 @@ u64 __of_translate_address(struct device_node *dev, const u32 *in_addr,
 	int na, ns, pna, pns;
 	u64 result = OF_BAD_ADDR;
 
-	DBG("OF: ** translation for device %s **\n", dev->full_name);
+	pr_debug("OF: ** translation for device %s **\n", dev->full_name);
 
 	/* Increase refcount at current level */
 	of_node_get(dev);
@@ -510,8 +498,8 @@ u64 __of_translate_address(struct device_node *dev, const u32 *in_addr,
 	}
 	memcpy(addr, in_addr, na * 4);
 
-	DBG("OF: bus is %s (na=%d, ns=%d) on %s\n",
-	    bus->name, na, ns, parent->full_name);
+	pr_debug("OF: bus is %s (na=%d, ns=%d) on %s\n",
+		bus->name, na, ns, parent->full_name);
 	of_dump_addr("OF: translating address:", addr, na);
 
 	/* Translate */
@@ -523,7 +511,7 @@ u64 __of_translate_address(struct device_node *dev, const u32 *in_addr,
 
 		/* If root, we have finished */
 		if (parent == NULL) {
-			DBG("OF: reached root node\n");
+			pr_debug("OF: reached root node\n");
 			result = of_read_number(addr, na);
 			break;
 		}
@@ -537,7 +525,7 @@ u64 __of_translate_address(struct device_node *dev, const u32 *in_addr,
 			break;
 		}
 
-		DBG("OF: parent bus is %s (na=%d, ns=%d) on %s\n",
+		pr_debug("OF: parent bus is %s (na=%d, ns=%d) on %s\n",
 		    pbus->name, pna, pns, parent->full_name);
 
 		/* Apply bus translation */
@@ -571,7 +559,7 @@ u64 of_translate_dma_address(struct device_node *dev, const u32 *in_addr)
 EXPORT_SYMBOL(of_translate_dma_address);
 
 const u32 *of_get_address(struct device_node *dev, int index, u64 *size,
-		    unsigned int *flags)
+			unsigned int *flags)
 {
 	const u32 *prop;
 	unsigned int psize;
@@ -622,7 +610,11 @@ static int __of_address_to_resource(struct device_node *dev, const u32 *addrp,
 	memset(r, 0, sizeof(struct resource));
 	if (flags & IORESOURCE_IO) {
 		unsigned long port;
+#ifdef CONFIG_PCI
 		port = pci_address_to_pio(taddr);
+#else
+		port = -1;
+#endif
 		if (port == (unsigned long)-1)
 			return -EINVAL;
 		r->start = port;
@@ -727,7 +719,7 @@ void of_irq_map_init(unsigned int flags)
 	if (flags & OF_IMAP_NO_PHANDLE) {
 		struct device_node *np;
 
-		for(np = NULL; (np = of_find_all_nodes(np)) != NULL;) {
+		for (np = NULL; (np = of_find_all_nodes(np)) != NULL;) {
 			if (of_get_property(np, "interrupt-controller", NULL)
 			    == NULL)
 				continue;
@@ -757,8 +749,9 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
 	int imaplen, match, i;
 
-	DBG("of_irq_map_raw: par=%s,intspec=[0x%08x 0x%08x...],ointsize=%d\n",
-	    parent->full_name, intspec[0], intspec[1], ointsize);
+	pr_debug("of_irq_map_raw: par=%s,intspec=[0x%08x 0x%08x...],"
+		"ointsize=%d\n",
+		parent->full_name, intspec[0], intspec[1], ointsize);
 
 	ipar = of_node_get(parent);
 
@@ -777,11 +770,12 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		of_node_put(tnode);
 	} while (ipar);
 	if (ipar == NULL) {
-		DBG(" -> no parent found !\n");
+		pr_debug(" -> no parent found !\n");
 		goto fail;
 	}
 
-	DBG("of_irq_map_raw: ipar=%s, size=%d\n", ipar->full_name, intsize);
+	pr_debug("of_irq_map_raw: ipar=%s, size=%d\n",
+			ipar->full_name, intsize);
 
 	if (ointsize != intsize)
 		return -EINVAL;
@@ -795,12 +789,12 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		tnode = of_get_parent(old);
 		of_node_put(old);
 		old = tnode;
-	} while(old && tmp == NULL);
+	} while (old && tmp == NULL);
 	of_node_put(old);
 	old = NULL;
 	addrsize = (tmp == NULL) ? 2 : *tmp;
 
-	DBG(" -> addrsize=%d\n", addrsize);
+	pr_debug(" -> addrsize=%d\n", addrsize);
 
 	/* Now start the actual "proper" walk of the interrupt tree */
 	while (ipar != NULL) {
@@ -809,9 +803,9 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		 */
 		if (of_get_property(ipar, "interrupt-controller", NULL) !=
 				NULL) {
-			DBG(" -> got it !\n");
-			memcpy(out_irq->specifier, intspec,
-			       intsize * sizeof(u32));
+			pr_debug(" -> got it !\n");
+			memcpy(out_irq->specifier,
+			       intspec, intsize * sizeof(u32));
 			out_irq->size = intsize;
 			out_irq->controller = ipar;
 			of_node_put(old);
@@ -822,7 +816,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		imap = of_get_property(ipar, "interrupt-map", &imaplen);
 		/* No interrupt map, check for an interrupt parent */
 		if (imap == NULL) {
-			DBG(" -> no map, getting parent\n");
+			pr_debug(" -> no map, getting parent\n");
 			newpar = of_irq_find_parent(ipar);
 			goto skiplevel;
 		}
@@ -836,7 +830,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		 * Fail if it's not.
 		 */
 		if (addr == NULL && addrsize != 0) {
-			DBG(" -> no reg passed in when needed !\n");
+			pr_debug(" -> no reg passed in when needed !\n");
 			goto fail;
 		}
 
@@ -857,7 +851,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 			imap += addrsize + intsize;
 			imaplen -= addrsize + intsize;
 
-			DBG(" -> match=%d (imaplen=%d)\n", match, imaplen);
+			pr_debug(" -> match=%d (imaplen=%d)\n", match, imaplen);
 
 			/* Get the interrupt parent */
 			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
@@ -869,7 +863,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 
 			/* Check if not found */
 			if (newpar == NULL) {
-				DBG(" -> imap parent not found !\n");
+				pr_debug(" -> imap parent not found !\n");
 				goto fail;
 			}
 
@@ -878,14 +872,14 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 			 */
 			tmp = of_get_property(newpar, "#interrupt-cells", NULL);
 			if (tmp == NULL) {
-				DBG(" -> parent lacks #interrupt-cells !\n");
+				pr_debug(" -> parent lacks #interrupt-cells !\n");
 				goto fail;
 			}
 			newintsize = *tmp;
 			tmp = of_get_property(newpar, "#address-cells", NULL);
 			newaddrsize = (tmp == NULL) ? 0 : *tmp;
 
-			DBG(" -> newintsize=%d, newaddrsize=%d\n",
+			pr_debug(" -> newintsize=%d, newaddrsize=%d\n",
 			    newintsize, newaddrsize);
 
 			/* Check for malformed properties */
@@ -895,7 +889,7 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 			imap += newaddrsize + newintsize;
 			imaplen -= newaddrsize + newintsize;
 
-			DBG(" -> imaplen=%d\n", imaplen);
+			pr_debug(" -> imaplen=%d\n", imaplen);
 		}
 		if (!match)
 			goto fail;
@@ -909,12 +903,12 @@ int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 
 	skiplevel:
 		/* Iterate again with new parent */
-		DBG(" -> new parent: %s\n", newpar ? newpar->full_name : "<>");
+		pr_debug(" -> new parent: %s\n", newpar ? newpar->full_name : "<>");
 		of_node_put(ipar);
 		ipar = newpar;
 		newpar = NULL;
 	}
- fail:
+fail:
 	of_node_put(ipar);
 	of_node_put(old);
 	of_node_put(newpar);
@@ -974,7 +968,7 @@ int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq
 	u32 intsize, intlen;
 	int res;
 
-	DBG("of_irq_map_one: dev=%s, index=%d\n", device->full_name, index);
+	pr_debug("of_irq_map_one: dev=%s, index=%d\n", device->full_name, index);
 
 	/* OldWorld mac stuff is "special", handle out of line */
 	if (of_irq_workarounds & OF_IMAP_OLDWORLD_MAC)
@@ -1002,7 +996,7 @@ int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq
 	}
 	intsize = *tmp;
 
-	DBG(" intsize=%d intlen=%d\n", intsize, intlen);
+	pr_debug(" intsize=%d intlen=%d\n", intsize, intlen);
 
 	/* Check index */
 	if ((index + 1) * intsize > intlen)
-- 
1.5.4.GIT

