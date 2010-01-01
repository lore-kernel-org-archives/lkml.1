Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209Ab0AAQl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab0AAQl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 11:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142Ab0AAQlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 11:41:20 -0500
Received: from isilmar.linta.de ([213.133.102.198]:54574 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752070Ab0AAQlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 11:41:18 -0500
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-arch@vger.kernel.org>, <torvalds@linux-foundation.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/2] resource: mark struct resource as const
Date: Fri,  1 Jan 2010 17:40:50 +0100
Message-Id: <1262364050-8540-2-git-send-email-linux@dominikbrodowski.net>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100101163811.GA8124@comet.dominikbrodowski.net>
References: <20100101163811.GA8124@comet.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we return the new resource start position, there is no
need to update "struct resource" inside the align function.
Therefore, mark the struct resource as const.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 arch/alpha/kernel/pci.c                 |    2 +-
 arch/arm/kernel/bios32.c                |    2 +-
 arch/cris/arch-v32/drivers/pci/bios.c   |    2 +-
 arch/frv/mb93090-mb00/pci-frv.c         |    2 +-
 arch/ia64/pci/pci.c                     |    2 +-
 arch/mips/pci/pci.c                     |    2 +-
 arch/mips/pmc-sierra/yosemite/ht.c      |    2 +-
 arch/mn10300/unit-asb2305/pci-asb2305.c |    2 +-
 arch/parisc/kernel/pci.c                |    2 +-
 arch/powerpc/kernel/pci-common.c        |    2 +-
 arch/sh/drivers/pci/pci.c               |    2 +-
 arch/sparc/kernel/pci.c                 |    2 +-
 arch/sparc/kernel/pcic.c                |    2 +-
 arch/x86/pci/i386.c                     |    2 +-
 arch/xtensa/kernel/pci.c                |    4 ++--
 drivers/pci/bus.c                       |    2 +-
 drivers/pcmcia/rsrc_mgr.c               |    3 ++-
 drivers/pcmcia/rsrc_nonstatic.c         |    6 +++---
 include/linux/ioport.h                  |    2 +-
 include/linux/pci.h                     |    5 +++--
 kernel/resource.c                       |    4 ++--
 21 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index 5cf111e..c9ab94e 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -127,7 +127,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pcibios_fixup_final);
 #define GB			(1024*MB)
 
 resource_size_t
-pcibios_align_resource(void *data, struct resource *res,
+pcibios_align_resource(void *data, const struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index a7c85f8..bd397e0 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -616,7 +616,7 @@ char * __init pcibios_setup(char *str)
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might be mirrored at 0x0100-0x03ff..
  */
-resource_size_t pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
 	resource_size_t start = res->start;
diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index 5811e2f..d4b9c36 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -42,7 +42,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 }
 
 resource_size_t
-pcibios_align_resource(void *data, struct resource *res,
+pcibios_align_resource(void *data, const struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
 	resource_size_t start = res->start;
diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
index c947aa4..1ed15d7 100644
--- a/arch/frv/mb93090-mb00/pci-frv.c
+++ b/arch/frv/mb93090-mb00/pci-frv.c
@@ -33,7 +33,7 @@
  * which might have be mirrored at 0x0100-0x03ff..
  */
 resource_size_t
-pcibios_align_resource(void *data, struct resource *res,
+pcibios_align_resource(void *data, const struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
 	resource_size_t start = res->start;
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index ef574cd..783c83b 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -548,7 +548,7 @@ pcibios_disable_device (struct pci_dev *dev)
 }
 
 resource_size_t
-pcibios_align_resource (void *data, struct resource *res,
+pcibios_align_resource (void *data, const struct resource *res,
 		        resource_size_t size, resource_size_t align)
 {
 	return res->start;
diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 9085988..f87f5e1 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -50,7 +50,7 @@ static int pci_initialized;
  * which might have be mirrored at 0x0100-0x03ff..
  */
 resource_size_t
-pcibios_align_resource(void *data, struct resource *res,
+pcibios_align_resource(void *data, const struct resource *res,
 		       resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
diff --git a/arch/mips/pmc-sierra/yosemite/ht.c b/arch/mips/pmc-sierra/yosemite/ht.c
index 5e41008..fd22597 100644
--- a/arch/mips/pmc-sierra/yosemite/ht.c
+++ b/arch/mips/pmc-sierra/yosemite/ht.c
@@ -345,7 +345,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
         return pcibios_enable_resources(dev);
 }
 
-resource_size_t pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
         struct pci_dev *dev = data;
diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.c b/arch/mn10300/unit-asb2305/pci-asb2305.c
index 60f24a7..8182fff 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -31,7 +31,7 @@
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might have be mirrored at 0x0100-0x03ff..
  */
-resource_size_t pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
 	resource_size_t start = res->start;
diff --git a/arch/parisc/kernel/pci.c b/arch/parisc/kernel/pci.c
index 4463a31..5179e5e 100644
--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -254,7 +254,7 @@ EXPORT_SYMBOL(pcibios_bus_to_resource);
  * Since we are just checking candidates, don't use any fields other
  * than res->start.
  */
-resource_size_t pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t alignment)
 {
 	resource_size_t mask, align, start = res->start;
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 3e343b8..55045e7 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1168,7 +1168,7 @@ static int skip_isa_ioresource_align(struct pci_dev *dev)
  * but we want to try to avoid allocating at 0x2900-0x2bff
  * which might have be mirrored at 0x0100-0x03ff..
  */
-resource_size_t pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index b36ca82..96213fd 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -148,7 +148,7 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
  * addresses to be allocated in the 0x000-0x0ff region
  * modulo 0x400.
  */
-resource_size_t pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 6381ceb..e71e9ce 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -715,7 +715,7 @@ void pcibios_update_irq(struct pci_dev *pdev, int irq)
 {
 }
 
-resource_size_t pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
 	return res->start;
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 96fe494..49fcf5f 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -839,7 +839,7 @@ char * __devinit pcibios_setup(char *str)
 	return str;
 }
 
-resource_size_t pcibios_align_resource(void *data, struct resource *res,
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
 	return res->start;
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 924e40c..5a8fbf8 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -61,7 +61,7 @@ skip_isa_ioresource_align(struct pci_dev *dev) {
  * which might have be mirrored at 0x0100-0x03ff..
  */
 resource_size_t
-pcibios_align_resource(void *data, struct resource *res,
+pcibios_align_resource(void *data, const struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index d7efab0..cd10269 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -70,8 +70,8 @@ static int pci_bus_count;
  * which might have be mirrored at 0x0100-0x03ff..
  */
 resource_size_t
-pcibios_align_resource(void *data, struct resource *res, resource_size_t size,
-    		       resource_size_t align)
+pcibios_align_resource(void *data, const struct resource *res,
+		       resource_size_t size, resource_size_t align)
 {
 	struct pci_dev *dev = data;
 	resource_size_t start = res->start;
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index d29d69a..a26135b 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -37,7 +37,7 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		resource_size_t size, resource_size_t align,
 		resource_size_t min, unsigned int type_mask,
 		resource_size_t (*alignf)(void *,
-					  struct resource *,
+					  const struct resource *,
 					  resource_size_t,
 					  resource_size_t),
 		void *alignf_data)
diff --git a/drivers/pcmcia/rsrc_mgr.c b/drivers/pcmcia/rsrc_mgr.c
index f92a2da..f8401a0 100644
--- a/drivers/pcmcia/rsrc_mgr.c
+++ b/drivers/pcmcia/rsrc_mgr.c
@@ -114,7 +114,8 @@ struct pcmcia_align_data {
 	unsigned long	offset;
 };
 
-static resource_size_t pcmcia_align(void *align_data, struct resource *res,
+static resource_size_t pcmcia_align(void *align_data,
+				const struct resource *res,
 				resource_size_t size, resource_size_t align)
 {
 	struct pcmcia_align_data *data = align_data;
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index b659028..45d75dc 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -534,7 +534,7 @@ struct pcmcia_align_data {
 };
 
 static resource_size_t
-pcmcia_common_align(void *align_data, struct resource *res,
+pcmcia_common_align(void *align_data, const struct resource *res,
 			resource_size_t size, resource_size_t align)
 {
 	struct pcmcia_align_data *data = align_data;
@@ -549,8 +549,8 @@ pcmcia_common_align(void *align_data, struct resource *res,
 }
 
 static resource_size_t
-pcmcia_align(void *align_data, struct resource *res, resource_size_t size,
-		resource_size_t align)
+pcmcia_align(void *align_data, const struct resource *res,
+	resource_size_t size, resource_size_t align)
 {
 	struct pcmcia_align_data *data = align_data;
 	struct resource_map *m;
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index f4195de..4a81189 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -121,7 +121,7 @@ extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
 			     resource_size_t max, resource_size_t align,
 			     resource_size_t (*alignf)(void *,
-						       struct resource *,
+						       const struct resource *,
 						       resource_size_t,
 						       resource_size_t),
 			     void *alignf_data);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 30a6e9b..f5cd77e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -562,7 +562,7 @@ int __must_check pcibios_enable_device(struct pci_dev *, int mask);
 char *pcibios_setup(char *str);
 
 /* Used only when drivers/pci/setup.c is used */
-resource_size_t pcibios_align_resource(void *, struct resource *,
+resource_size_t pcibios_align_resource(void *, const struct resource *,
 				resource_size_t,
 				resource_size_t);
 void pcibios_update_irq(struct pci_dev *, int irq);
@@ -790,7 +790,8 @@ int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 			struct resource *res, resource_size_t size,
 			resource_size_t align, resource_size_t min,
 			unsigned int type_mask,
-			resource_size_t (*alignf)(void *, struct resource *,
+			resource_size_t (*alignf)(void *,
+						  const struct resource *,
 						  resource_size_t,
 						  resource_size_t),
 			void *alignf_data);
diff --git a/kernel/resource.c b/kernel/resource.c
index e697f20..7fd123a 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -304,7 +304,7 @@ static int find_resource(struct resource *root, struct resource *new,
 			 resource_size_t size, resource_size_t min,
 			 resource_size_t max, resource_size_t align,
 			 resource_size_t (*alignf)(void *,
-						   struct resource *,
+						   const struct resource *,
 						   resource_size_t,
 						   resource_size_t),
 			 void *alignf_data)
@@ -361,7 +361,7 @@ int allocate_resource(struct resource *root, struct resource *new,
 		      resource_size_t size, resource_size_t min,
 		      resource_size_t max, resource_size_t align,
 		      resource_size_t (*alignf)(void *,
-						struct resource *,
+						const struct resource *,
 						resource_size_t,
 						resource_size_t),
 		      void *alignf_data)
-- 
1.6.3.3

