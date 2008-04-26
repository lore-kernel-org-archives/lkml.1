Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYDZSz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYDZSz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbYDZSzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:55:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758998AbYDZSzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:55:44 -0400
Date: Sat, 26 Apr 2008 20:55:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: [RFC git pull] "big box" x86 changes
Message-ID: <20080426185516.GA32364@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

the following tree contains the "big box" topic commits of x86.git:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox.git for-linus

Most of the work has been done by Yinghai Lu who has gone through a 
heroic effort to fix all the big-box bugs that he encountered on the 
vanilla Linux kernel on his various up to 256 GB RAM test-systems. Also 
work is included from Ying Huang for those insane SGI UV boxes.

Most of these patches have been carried in x86.git since around v2.6.23 
so they have a good track record in terms of "practical" stability. They 
have not been problem-free - the tree reflects most of those iterations 
and fixes that happened in that ~6 months timeframe of testing. They do 
solve a boatload of problems and inefficiencies on those systems.

Due to the nature of this topic the commits are all across bootmem, 
driver core and other subsystems - but most of them (obviously) affect 
arch/x86 - which is why they have been carried there.

The sub-topic that looks most scary in this lot are the mmconf changes 
that start with this one:

  Robert Hancock (1):
        x86: validate against acpi motherboard resources

Note that these are not the same changes that you rejected in the past, 
Yinghai has done a number of delta patches to that to make it more 
practical and palatable ... i hope. It's still ... somewhat problematic 
and might still be rejectable.

Another one is the mmconfig enablement in the CPU on Family 10 Opterons 
is turned into an optional, DMI-driven thing in one of the later patches 
so that is a lot less scary than it looks - it's still a generic PC and 
thus tons better than all those crazy subarch hacks that people ended up 
doing.

So we need a bit of help wrt. how mergable this is, and what else is 
needed to make it mergable. These changes have been booted all across 
the x86 spectrum, small and large boxes alike, so i'd be seriously 
surprised if they caused any widespread breakage.

	Ingo

------------------>
Huang, Ying (4):
      x86, boot: add free_early to early reservation machanism
      x86, boot: add linked list of struct setup_data
      x86, boot: export linked list of struct setup_data via debugfs
      x86, boot: Document for linked list of struct setup_data

Ingo Molnar (2):
      x86: fix k8-bus_64.c build
      x86: sanity check gart for buggy device, fix

Robert Hancock (1):
      x86: validate against acpi motherboard resources

Yinghai Lu (39):
      mm: make mem_map allocation continuous
      mm: fix alloc_bootmem_core to use fast searching for all nodes
      x86: clear pci_mmcfg_virt when mmcfg get rejected
      x86: mmconf enable mcfg early
      x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
      x86_64: check and enable MMCONFIG for AMD Family 10h
      x86_64: check MSR to get MMCONFIG for AMD Family 10h
      x86: if acpi=off, force setting the mmconf for fam10h
      x86: seperate mmconf for fam10h out from setup_64.c
      driver core: try parent numa_node at first before using default
      x86: skip it if Fam 10h only handle bus 0
      ide: use dev_to_node instead of pcibus_to_node
      x86: remove unneeded check in mmconf reject
      mm: offset align in alloc_bootmem()
      mm: allow reserve_bootmem() cross nodes
      x86_64: make reserve_bootmem_generic() use new reserve_bootmem()
      x86_64: fix setup_node_bootmem to support big mem excluding with memmap
      x86 pci: remove checking type for mmconfig probe
      x86: change pci_direct_conf1 back not static
      x86: get mp_bus_to_node early
      x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit
      x86: multi pci root bus with different io resource range, on 64-bit
      x86/acpi: make dev_to_node return online node
      x86: double check the multi root bus with fam10h mmconf
      x86/pci: add pci=skip_isa_align command lines.
      net: use numa_node in net_devcice->dev instead of parent
      x86_64: don't need set default res if only have one root bus
      x86_64/mm: check and print vmemmap allocation continuous
      x86_64/mm: check and print vmemmap allocation continuous -fix
      acpi: get boot_cpu_id as early for k8_scan_nodes
      x86: work around io allocation overlap of HT links
      x86: agp_gart size checking for buggy device
      x86: checking aperture size order
      x86: add pci=check_enable_amd_mmconf and dmi check
      x86 PCI: call dmi_check_pciprobe()
      x86_64: allocate gart aperture from 512M
      x86: don't call pxm_to_node again
      x86: clean up aperture_64.c
      x86: reserve dma32 early for gart -fix

 Documentation/i386/boot.txt         |   26 ++
 Documentation/kernel-parameters.txt |    2 +
 arch/x86/boot/header.S              |    6 +-
 arch/x86/kernel/Makefile            |    2 +
 arch/x86/kernel/acpi/boot.c         |   70 +++++
 arch/x86/kernel/aperture_64.c       |  283 ++++++++++++------
 arch/x86/kernel/e820_64.c           |   35 ++-
 arch/x86/kernel/head64.c            |   20 ++
 arch/x86/kernel/kdebugfs.c          |  163 ++++++++++-
 arch/x86/kernel/mmconf-fam10h_64.c  |  243 +++++++++++++++
 arch/x86/kernel/pci-dma.c           |   11 +-
 arch/x86/kernel/setup_64.c          |   47 +++-
 arch/x86/mm/init_64.c               |   38 ++-
 arch/x86/mm/k8topology_64.c         |   38 +++-
 arch/x86/mm/numa_64.c               |   43 +++-
 arch/x86/pci/Makefile_32            |    1 +
 arch/x86/pci/Makefile_64            |    2 +-
 arch/x86/pci/acpi.c                 |   81 ++----
 arch/x86/pci/common.c               |   76 +++++-
 arch/x86/pci/direct.c               |    8 +-
 arch/x86/pci/fixup.c                |   17 +
 arch/x86/pci/init.c                 |   17 +-
 arch/x86/pci/irq.c                  |    4 +-
 arch/x86/pci/k8-bus_64.c            |  580 +++++++++++++++++++++++++++++++----
 arch/x86/pci/legacy.c               |    4 +-
 arch/x86/pci/mmconfig-shared.c      |  252 +++++++++++++--
 arch/x86/pci/mmconfig_32.c          |    4 +
 arch/x86/pci/mmconfig_64.c          |   22 ++-
 arch/x86/pci/mp_bus_to_node.c       |   23 ++
 arch/x86/pci/pci.h                  |    6 +-
 drivers/acpi/bus.c                  |    2 +
 drivers/base/core.c                 |   14 +-
 drivers/char/agp/amd64-agp.c        |   21 +-
 drivers/pci/probe.c                 |   21 ++-
 include/asm-x86/bootparam.h         |   14 +
 include/asm-x86/e820_64.h           |    3 +-
 include/asm-x86/pci.h               |    2 +
 include/asm-x86/topology.h          |   16 +
 include/linux/acpi.h                |    5 +
 include/linux/ide.h                 |    3 +-
 include/linux/mm.h                  |    1 +
 include/linux/pci.h                 |   11 +-
 mm/bootmem.c                        |  157 +++++++---
 mm/sparse.c                         |   37 ++-
 net/core/skbuff.c                   |    2 +-
 45 files changed, 2071 insertions(+), 362 deletions(-)
 create mode 100644 arch/x86/kernel/mmconf-fam10h_64.c
 create mode 100644 arch/x86/pci/mp_bus_to_node.c

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index 2eb1610..0fac346 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -42,6 +42,8 @@ Protocol 2.05:	(Kernel 2.6.20) Make protected mode kernel relocatable.
 Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
 		the boot command line
 
+Protocol 2.09:	(kernel 2.6.26) Added a field of 64-bit physical
+		pointer to single linked list of struct	setup_data.
 
 **** MEMORY LAYOUT
 
@@ -172,6 +174,8 @@ Offset	Proto	Name		Meaning
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
 0248/4	2.08+	payload_offset	Offset of kernel payload
 024C/4	2.08+	payload_length	Length of kernel payload
+0250/8	2.09+	setup_data	64-bit physical pointer to linked list
+				of struct setup_data
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -572,6 +576,28 @@ command line is entered using the following protocol:
 	covered by setup_move_size, so you may need to adjust this
 	field.
 
+Field name:	setup_data
+Type:		write (obligatory)
+Offset/size:	0x250/8
+Protocol:	2.09+
+
+  The 64-bit physical pointer to NULL terminated single linked list of
+  struct setup_data. This is used to define a more extensible boot
+  parameters passing mechanism. The definition of struct setup_data is
+  as follow:
+
+  struct setup_data {
+	  u64 next;
+	  u32 type;
+	  u32 len;
+	  u8  data[0];
+  };
+
+  Where, the next is a 64-bit physical pointer to the next node of
+  linked list, the next field of the last node is 0; the type is used
+  to identify the contents of data; the len is the length of data
+  field; the data holds the real payload.
+
 
 **** MEMORY LAYOUT OF THE REAL-MODE CODE
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index bf6303e..e0101d9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1516,6 +1516,8 @@ and is between 256 and 4096 characters. It is defined in the file
 				This is normally done in pci_enable_device(),
 				so this option is a temporary workaround
 				for broken drivers that don't call it.
+		skip_isa_align	[X86] do not align io start addr, so can
+				handle more pci cards
 		firmware	[ARM] Do not re-enumerate the bus but instead
 				just use the configuration from the
 				bootloader. This is currently used on
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 6d2df8d..af86e43 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -120,7 +120,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0208		# header version number (>= 0x0105)
+		.word	0x0209		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -227,6 +227,10 @@ hardware_subarch_data:	.quad 0
 payload_offset:		.long input_data
 payload_length:		.long input_data_end-input_data
 
+setup_data:		.quad 0			# 64-bit physical pointer to
+						# single linked list of
+						# struct setup_data
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 90e092d..815b650 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -99,4 +99,6 @@ ifeq ($(CONFIG_X86_64),y)
         obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
         obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
         obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
+
+        obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 endif
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 977ed5c..c49ebcc 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -771,6 +771,32 @@ static void __init acpi_register_lapic_address(unsigned long address)
 		boot_cpu_physical_apicid  = GET_APIC_ID(read_apic_id());
 }
 
+static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
+{
+	int count;
+
+	if (!cpu_has_apic)
+		return -ENODEV;
+
+	/*
+	 * Note that the LAPIC address is obtained from the MADT (32-bit value)
+	 * and (optionally) overriden by a LAPIC_ADDR_OVR entry (64-bit value).
+	 */
+
+	count =
+	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
+				  acpi_parse_lapic_addr_ovr, 0);
+	if (count < 0) {
+		printk(KERN_ERR PREFIX
+		       "Error parsing LAPIC address override entry\n");
+		return count;
+	}
+
+	acpi_register_lapic_address(acpi_lapic_addr);
+
+	return count;
+}
+
 static int __init acpi_parse_madt_lapic_entries(void)
 {
 	int count;
@@ -901,6 +927,33 @@ static inline int acpi_parse_madt_ioapic_entries(void)
 }
 #endif	/* !CONFIG_X86_IO_APIC */
 
+static void __init early_acpi_process_madt(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	int error;
+
+	if (!acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt)) {
+
+		/*
+		 * Parse MADT LAPIC entries
+		 */
+		error = early_acpi_parse_madt_lapic_addr_ovr();
+		if (!error) {
+			acpi_lapic = 1;
+			smp_found_config = 1;
+		}
+		if (error == -EINVAL) {
+			/*
+			 * Dell Precision Workstation 410, 610 come here.
+			 */
+			printk(KERN_ERR PREFIX
+			       "Invalid BIOS MADT, disabling ACPI\n");
+			disable_acpi();
+		}
+	}
+#endif
+}
+
 static void __init acpi_process_madt(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -1233,6 +1286,23 @@ int __init acpi_boot_table_init(void)
 	return 0;
 }
 
+int __init early_acpi_boot_init(void)
+{
+	/*
+	 * If acpi_disabled, bail out
+	 * One exception: acpi=ht continues far enough to enumerate LAPICs
+	 */
+	if (acpi_disabled && !acpi_ht)
+		return 1;
+
+	/*
+	 * Process the Multiple APIC Description Table (MADT), if present
+	 */
+	early_acpi_process_madt();
+
+	return 0;
+}
+
 int __init acpi_boot_init(void)
 {
 	/*
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 479926d..02f4dba 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -35,6 +35,18 @@ int fallback_aper_force __initdata;
 
 int fix_aperture __initdata = 1;
 
+struct bus_dev_range {
+	int bus;
+	int dev_base;
+	int dev_limit;
+};
+
+static struct bus_dev_range bus_dev_ranges[] __initdata = {
+	{ 0x00, 0x18, 0x20},
+	{ 0xff, 0x00, 0x20},
+	{ 0xfe, 0x00, 0x20}
+};
+
 static struct resource gart_resource = {
 	.name	= "GART",
 	.flags	= IORESOURCE_MEM,
@@ -55,8 +67,9 @@ static u32 __init allocate_aperture(void)
 	u32 aper_size;
 	void *p;
 
-	if (fallback_aper_order > 7)
-		fallback_aper_order = 7;
+	/* aper_size should <= 1G */
+	if (fallback_aper_order > 5)
+		fallback_aper_order = 5;
 	aper_size = (32 * 1024 * 1024) << fallback_aper_order;
 
 	/*
@@ -65,7 +78,20 @@ static u32 __init allocate_aperture(void)
 	 * memory. Unfortunately we cannot move it up because that would
 	 * make the IOMMU useless.
 	 */
-	p = __alloc_bootmem_nopanic(aper_size, aper_size, 0);
+	/*
+	 * using 512M as goal, in case kexec will load kernel_big
+	 * that will do the on position decompress, and  could overlap with
+	 * that positon with gart that is used.
+	 * sequende:
+	 * kernel_small
+	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
+	 * ==> kernel_small(gart area become e820_reserved)
+	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
+	 * ==> kerne_big (uncompressed size will be big than 64M or 128M)
+	 * so don't use 512M below as gart iommu, leave the space for kernel
+	 * code for safe
+	 */
+	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk(KERN_ERR
 			"Cannot allocate aperture memory hole (%p,%uK)\n",
@@ -83,7 +109,7 @@ static u32 __init allocate_aperture(void)
 	return (u32)__pa(p);
 }
 
-static int __init aperture_valid(u64 aper_base, u32 aper_size)
+static int __init aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
 {
 	if (!aper_base)
 		return 0;
@@ -96,8 +122,9 @@ static int __init aperture_valid(u64 aper_base, u32 aper_size)
 		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
 		return 0;
 	}
-	if (aper_size < 64*1024*1024) {
-		printk(KERN_ERR "Aperture too small (%d MB)\n", aper_size>>20);
+	if (aper_size < min_size) {
+		printk(KERN_ERR "Aperture too small (%d MB) than (%d MB)\n",
+				 aper_size>>20, min_size>>20);
 		return 0;
 	}
 
@@ -105,47 +132,51 @@ static int __init aperture_valid(u64 aper_base, u32 aper_size)
 }
 
 /* Find a PCI capability */
-static __u32 __init find_cap(int num, int slot, int func, int cap)
+static __u32 __init find_cap(int bus, int slot, int func, int cap)
 {
 	int bytes;
 	u8 pos;
 
-	if (!(read_pci_config_16(num, slot, func, PCI_STATUS) &
+	if (!(read_pci_config_16(bus, slot, func, PCI_STATUS) &
 						PCI_STATUS_CAP_LIST))
 		return 0;
 
-	pos = read_pci_config_byte(num, slot, func, PCI_CAPABILITY_LIST);
+	pos = read_pci_config_byte(bus, slot, func, PCI_CAPABILITY_LIST);
 	for (bytes = 0; bytes < 48 && pos >= 0x40; bytes++) {
 		u8 id;
 
 		pos &= ~3;
-		id = read_pci_config_byte(num, slot, func, pos+PCI_CAP_LIST_ID);
+		id = read_pci_config_byte(bus, slot, func, pos+PCI_CAP_LIST_ID);
 		if (id == 0xff)
 			break;
 		if (id == cap)
 			return pos;
-		pos = read_pci_config_byte(num, slot, func,
+		pos = read_pci_config_byte(bus, slot, func,
 						pos+PCI_CAP_LIST_NEXT);
 	}
 	return 0;
 }
 
 /* Read a standard AGPv3 bridge header */
-static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
+static __u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
 {
 	u32 apsize;
 	u32 apsizereg;
 	int nbits;
 	u32 aper_low, aper_hi;
 	u64 aper;
+	u32 old_order;
 
-	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", num, slot, func);
-	apsizereg = read_pci_config_16(num, slot, func, cap + 0x14);
+	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", bus, slot, func);
+	apsizereg = read_pci_config_16(bus, slot, func, cap + 0x14);
 	if (apsizereg == 0xffffffff) {
 		printk(KERN_ERR "APSIZE in AGP bridge unreadable\n");
 		return 0;
 	}
 
+	/* old_order could be the value from NB gart setting */
+	old_order = *order;
+
 	apsize = apsizereg & 0xfff;
 	/* Some BIOS use weird encodings not in the AGPv3 table. */
 	if (apsize & 0xff)
@@ -155,14 +186,26 @@ static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
 	if ((int)*order < 0) /* < 32MB */
 		*order = 0;
 
-	aper_low = read_pci_config(num, slot, func, 0x10);
-	aper_hi = read_pci_config(num, slot, func, 0x14);
+	aper_low = read_pci_config(bus, slot, func, 0x10);
+	aper_hi = read_pci_config(bus, slot, func, 0x14);
 	aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
 
+	/*
+	 * On some sick chips, APSIZE is 0. It means it wants 4G
+	 * so let double check that order, and lets trust AMD NB settings:
+	 */
+	printk(KERN_INFO "Aperture from AGP @ %Lx old size %u MB\n",
+			aper, 32 << old_order);
+	if (aper + (32ULL<<(20 + *order)) > 0x100000000ULL) {
+		printk(KERN_INFO "Aperture size %u MB (APSIZE %x) is not right, using settings from NB\n",
+				32 << *order, apsizereg);
+		*order = old_order;
+	}
+
 	printk(KERN_INFO "Aperture from AGP @ %Lx size %u MB (APSIZE %x)\n",
 			aper, 32 << *order, apsizereg);
 
-	if (!aperture_valid(aper, (32*1024*1024) << *order))
+	if (!aperture_valid(aper, (32*1024*1024) << *order, 32<<20))
 		return 0;
 	return (u32)aper;
 }
@@ -182,15 +225,15 @@ static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
  */
 static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 {
-	int num, slot, func;
+	int bus, slot, func;
 
 	/* Poor man's PCI discovery */
-	for (num = 0; num < 256; num++) {
+	for (bus = 0; bus < 256; bus++) {
 		for (slot = 0; slot < 32; slot++) {
 			for (func = 0; func < 8; func++) {
 				u32 class, cap;
 				u8 type;
-				class = read_pci_config(num, slot, func,
+				class = read_pci_config(bus, slot, func,
 							PCI_CLASS_REVISION);
 				if (class == 0xffffffff)
 					break;
@@ -199,17 +242,17 @@ static __u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 				case PCI_CLASS_BRIDGE_HOST:
 				case PCI_CLASS_BRIDGE_OTHER: /* needed? */
 					/* AGP bridge? */
-					cap = find_cap(num, slot, func,
+					cap = find_cap(bus, slot, func,
 							PCI_CAP_ID_AGP);
 					if (!cap)
 						break;
 					*valid_agp = 1;
-					return read_agp(num, slot, func, cap,
+					return read_agp(bus, slot, func, cap,
 							order);
 				}
 
 				/* No multi-function device? */
-				type = read_pci_config_byte(num, slot, func,
+				type = read_pci_config_byte(bus, slot, func,
 							       PCI_HEADER_TYPE);
 				if (!(type & 0x80))
 					break;
@@ -249,38 +292,49 @@ void __init early_gart_iommu_check(void)
 	 * or BIOS forget to put that in reserved.
 	 * try to update e820 to make that region as reserved.
 	 */
-	int fix, num;
+	int fix, slot;
 	u32 ctl;
 	u32 aper_size = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base = 0, last_aper_base = 0;
 	int aper_enabled = 0, last_aper_enabled = 0;
+	int i;
 
 	if (!early_pci_allowed())
 		return;
 
 	fix = 0;
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		ctl = read_pci_config(0, num, 3, 0x90);
-		aper_enabled = ctl & 1;
-		aper_order = (ctl >> 1) & 7;
-		aper_size = (32 * 1024 * 1024) << aper_order;
-		aper_base = read_pci_config(0, num, 3, 0x94) & 0x7fff;
-		aper_base <<= 25;
-
-		if ((last_aper_order && aper_order != last_aper_order) ||
-		    (last_aper_base && aper_base != last_aper_base) ||
-		    (last_aper_enabled && aper_enabled != last_aper_enabled)) {
-			fix = 1;
-			break;
+	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+		int bus;
+		int dev_base, dev_limit;
+
+		bus = bus_dev_ranges[i].bus;
+		dev_base = bus_dev_ranges[i].dev_base;
+		dev_limit = bus_dev_ranges[i].dev_limit;
+
+		for (slot = dev_base; slot < dev_limit; slot++) {
+			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+				continue;
+
+			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
+			aper_enabled = ctl & AMD64_GARTEN;
+			aper_order = (ctl >> 1) & 7;
+			aper_size = (32 * 1024 * 1024) << aper_order;
+			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
+			aper_base <<= 25;
+
+			if ((last_aper_order && aper_order != last_aper_order) ||
+			    (last_aper_base && aper_base != last_aper_base) ||
+			    (last_aper_enabled && aper_enabled != last_aper_enabled)) {
+				fix = 1;
+				goto out;
+			}
+			last_aper_order = aper_order;
+			last_aper_base = aper_base;
+			last_aper_enabled = aper_enabled;
 		}
-		last_aper_order = aper_order;
-		last_aper_base = aper_base;
-		last_aper_enabled = aper_enabled;
 	}
 
+out:
 	if (!fix && !aper_enabled)
 		return;
 
@@ -288,8 +342,8 @@ void __init early_gart_iommu_check(void)
 		fix = 1;
 
 	if (gart_fix_e820 && !fix && aper_enabled) {
-		if (e820_any_mapped(aper_base, aper_base + aper_size,
-				    E820_RAM)) {
+		if (!e820_all_mapped(aper_base, aper_base + aper_size,
+				    E820_RESERVED)) {
 			/* reserved it, so we can resuse it in second kernel */
 			printk(KERN_INFO "update e820 for GART\n");
 			add_memory_region(aper_base, aper_size, E820_RESERVED);
@@ -299,23 +353,35 @@ void __init early_gart_iommu_check(void)
 	}
 
 	/* different nodes have different setting, disable them all at first*/
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
+	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+		int bus;
+		int dev_base, dev_limit;
+
+		bus = bus_dev_ranges[i].bus;
+		dev_base = bus_dev_ranges[i].dev_base;
+		dev_limit = bus_dev_ranges[i].dev_limit;
 
-		ctl = read_pci_config(0, num, 3, 0x90);
-		ctl &= ~1;
-		write_pci_config(0, num, 3, 0x90, ctl);
+		for (slot = dev_base; slot < dev_limit; slot++) {
+			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+				continue;
+
+			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
+			ctl &= ~AMD64_GARTEN;
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
+		}
 	}
 
 }
 
+static int __initdata printed_gart_size_msg;
+
 void __init gart_iommu_hole_init(void)
 {
+	u32 agp_aper_base = 0, agp_aper_order = 0;
 	u32 aper_size, aper_alloc = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base, last_aper_base = 0;
-	int fix, num, valid_agp = 0;
-	int node;
+	int fix, slot, valid_agp = 0;
+	int i, node;
 
 	if (gart_iommu_aperture_disabled || !fix_aperture ||
 	    !early_pci_allowed())
@@ -323,38 +389,63 @@ void __init gart_iommu_hole_init(void)
 
 	printk(KERN_INFO  "Checking aperture...\n");
 
+	if (!fallback_aper_force)
+		agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
+
 	fix = 0;
 	node = 0;
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		iommu_detected = 1;
-		gart_iommu_aperture = 1;
-
-		aper_order = (read_pci_config(0, num, 3, 0x90) >> 1) & 7;
-		aper_size = (32 * 1024 * 1024) << aper_order;
-		aper_base = read_pci_config(0, num, 3, 0x94) & 0x7fff;
-		aper_base <<= 25;
-
-		printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
-				node, aper_base, aper_size >> 20);
-		node++;
-
-		if (!aperture_valid(aper_base, aper_size)) {
-			fix = 1;
-			break;
-		}
+	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+		int bus;
+		int dev_base, dev_limit;
+
+		bus = bus_dev_ranges[i].bus;
+		dev_base = bus_dev_ranges[i].dev_base;
+		dev_limit = bus_dev_ranges[i].dev_limit;
+
+		for (slot = dev_base; slot < dev_limit; slot++) {
+			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+				continue;
+
+			iommu_detected = 1;
+			gart_iommu_aperture = 1;
+
+			aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
+			aper_size = (32 * 1024 * 1024) << aper_order;
+			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
+			aper_base <<= 25;
+
+			printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
+					node, aper_base, aper_size >> 20);
+			node++;
+
+			if (!aperture_valid(aper_base, aper_size, 64<<20)) {
+				if (valid_agp && agp_aper_base &&
+				    agp_aper_base == aper_base &&
+				    agp_aper_order == aper_order) {
+					/* the same between two setting from NB and agp */
+					if (!no_iommu && end_pfn > MAX_DMA32_PFN && !printed_gart_size_msg) {
+						printk(KERN_ERR "you are using iommu with agp, but GART size is less than 64M\n");
+						printk(KERN_ERR "please increase GART size in your BIOS setup\n");
+						printk(KERN_ERR "if BIOS doesn't have that option, contact your HW vendor!\n");
+						printed_gart_size_msg = 1;
+					}
+				} else {
+					fix = 1;
+					goto out;
+				}
+			}
 
-		if ((last_aper_order && aper_order != last_aper_order) ||
-		    (last_aper_base && aper_base != last_aper_base)) {
-			fix = 1;
-			break;
+			if ((last_aper_order && aper_order != last_aper_order) ||
+			    (last_aper_base && aper_base != last_aper_base)) {
+				fix = 1;
+				goto out;
+			}
+			last_aper_order = aper_order;
+			last_aper_base = aper_base;
 		}
-		last_aper_order = aper_order;
-		last_aper_base = aper_base;
 	}
 
+out:
 	if (!fix && !fallback_aper_force) {
 		if (last_aper_base) {
 			unsigned long n = (32 * 1024 * 1024) << last_aper_order;
@@ -364,8 +455,10 @@ void __init gart_iommu_hole_init(void)
 		return;
 	}
 
-	if (!fallback_aper_force)
-		aper_alloc = search_agp_bridge(&aper_order, &valid_agp);
+	if (!fallback_aper_force) {
+		aper_alloc = agp_aper_base;
+		aper_order = agp_aper_order;
+	}
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
@@ -401,16 +494,22 @@ void __init gart_iommu_hole_init(void)
 	}
 
 	/* Fix up the north bridges */
-	for (num = 24; num < 32; num++) {
-		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
-			continue;
-
-		/*
-		 * Don't enable translation yet. That is done later.
-		 * Assume this BIOS didn't initialise the GART so
-		 * just overwrite all previous bits
-		 */
-		write_pci_config(0, num, 3, 0x90, aper_order<<1);
-		write_pci_config(0, num, 3, 0x94, aper_alloc>>25);
+	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
+		int bus;
+		int dev_base, dev_limit;
+
+		bus = bus_dev_ranges[i].bus;
+		dev_base = bus_dev_ranges[i].dev_base;
+		dev_limit = bus_dev_ranges[i].dev_limit;
+		for (slot = dev_base; slot < dev_limit; slot++) {
+			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+				continue;
+
+			/* Don't enable translation yet. That is done later.
+			   Assume this BIOS didn't initialise the GART so
+			   just overwrite all previous bits */
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE, aper_alloc >> 25);
+		}
 	}
 }
diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index cbd42e5..645ee5e 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -84,14 +84,41 @@ void __init reserve_early(unsigned long start, unsigned long end, char *name)
 		strncpy(r->name, name, sizeof(r->name) - 1);
 }
 
-void __init early_res_to_bootmem(void)
+void __init free_early(unsigned long start, unsigned long end)
+{
+	struct early_res *r;
+	int i, j;
+
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		r = &early_res[i];
+		if (start == r->start && end == r->end)
+			break;
+	}
+	if (i >= MAX_EARLY_RES || !early_res[i].end)
+		panic("free_early on not reserved area: %lx-%lx!", start, end);
+
+	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
+		;
+
+	memcpy(&early_res[i], &early_res[i + 1],
+	       (j - 1 - i) * sizeof(struct early_res));
+
+	early_res[j - 1].end = 0;
+}
+
+void __init early_res_to_bootmem(unsigned long start, unsigned long end)
 {
 	int i;
+	unsigned long final_start, final_end;
 	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
 		struct early_res *r = &early_res[i];
-		printk(KERN_INFO "early res: %d [%lx-%lx] %s\n", i,
-			r->start, r->end - 1, r->name);
-		reserve_bootmem_generic(r->start, r->end - r->start);
+		final_start = max(start, r->start);
+		final_end = min(end, r->end);
+		if (final_start >= final_end)
+			continue;
+		printk(KERN_INFO "  early res: %d [%lx-%lx] %s\n", i,
+			final_start, final_end - 1, r->name);
+		reserve_bootmem_generic(final_start, final_end - final_start);
 	}
 }
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index d31d6b7..e25c57b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <linux/percpu.h>
 #include <linux/start_kernel.h>
+#include <linux/io.h>
 
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -100,6 +101,24 @@ static void __init reserve_ebda_region(void)
 	reserve_early(lowmem, 0x100000, "BIOS reserved");
 }
 
+static void __init reserve_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data;
+	char buf[32];
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, sizeof(*data));
+		sprintf(buf, "setup data %x", data->type);
+		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		pa_data = data->next;
+		early_iounmap(data, sizeof(*data));
+	}
+}
+
 void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
@@ -156,6 +175,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 #endif
 
 	reserve_ebda_region();
+	reserve_setup_data();
 
 	/*
 	 * At this point everything still needed from the boot loader
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 7335430..c032059 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -6,23 +6,171 @@
  *
  * This file is released under the GPLv2.
  */
-
 #include <linux/debugfs.h>
+#include <linux/uaccess.h>
 #include <linux/stat.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/mm.h>
 
 #include <asm/setup.h>
 
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
+struct setup_data_node {
+	u64 paddr;
+	u32 type;
+	u32 len;
+};
+
+static ssize_t
+setup_data_read(struct file *file, char __user *user_buf, size_t count,
+		loff_t *ppos)
+{
+	struct setup_data_node *node = file->private_data;
+	unsigned long remain;
+	loff_t pos = *ppos;
+	struct page *pg;
+	void *p;
+	u64 pa;
+
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= node->len)
+		return 0;
+
+	if (count > node->len - pos)
+		count = node->len - pos;
+	pa = node->paddr + sizeof(struct setup_data) + pos;
+	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
+	if (PageHighMem(pg)) {
+		p = ioremap_cache(pa, count);
+		if (!p)
+			return -ENXIO;
+	} else {
+		p = __va(pa);
+	}
+
+	remain = copy_to_user(user_buf, p, count);
+
+	if (PageHighMem(pg))
+		iounmap(p);
+
+	if (remain)
+		return -EFAULT;
+
+	*ppos = pos + count;
+
+	return count;
+}
+
+static int setup_data_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static const struct file_operations fops_setup_data = {
+	.read =		setup_data_read,
+	.open =		setup_data_open,
+};
+
+static int __init
+create_setup_data_node(struct dentry *parent, int no,
+		       struct setup_data_node *node)
+{
+	struct dentry *d, *type, *data;
+	char buf[16];
+	int error;
+
+	sprintf(buf, "%d", no);
+	d = debugfs_create_dir(buf, parent);
+	if (!d) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+	type = debugfs_create_x32("type", S_IRUGO, d, &node->type);
+	if (!type) {
+		error = -ENOMEM;
+		goto err_dir;
+	}
+	data = debugfs_create_file("data", S_IRUGO, d, node, &fops_setup_data);
+	if (!data) {
+		error = -ENOMEM;
+		goto err_type;
+	}
+	return 0;
+
+err_type:
+	debugfs_remove(type);
+err_dir:
+	debugfs_remove(d);
+err_return:
+	return error;
+}
+
+static int __init create_setup_data_nodes(struct dentry *parent)
+{
+	struct setup_data_node *node;
+	struct setup_data *data;
+	int error, no = 0;
+	struct dentry *d;
+	struct page *pg;
+	u64 pa_data;
+
+	d = debugfs_create_dir("setup_data", parent);
+	if (!d) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+
+	pa_data = boot_params.hdr.setup_data;
+
+	while (pa_data) {
+		node = kmalloc(sizeof(*node), GFP_KERNEL);
+		if (!node) {
+			error = -ENOMEM;
+			goto err_dir;
+		}
+		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
+		if (PageHighMem(pg)) {
+			data = ioremap_cache(pa_data, sizeof(*data));
+			if (!data) {
+				error = -ENXIO;
+				goto err_dir;
+			}
+		} else {
+			data = __va(pa_data);
+		}
+
+		node->paddr = pa_data;
+		node->type = data->type;
+		node->len = data->len;
+		error = create_setup_data_node(d, no, node);
+		pa_data = data->next;
+
+		if (PageHighMem(pg))
+			iounmap(data);
+		if (error)
+			goto err_dir;
+		no++;
+	}
+	return 0;
+
+err_dir:
+	debugfs_remove(d);
+err_return:
+	return error;
+}
+
 static struct debugfs_blob_wrapper boot_params_blob = {
-	.data = &boot_params,
-	.size = sizeof(boot_params),
+	.data		= &boot_params,
+	.size		= sizeof(boot_params),
 };
 
 static int __init boot_params_kdebugfs_init(void)
 {
-	int error;
 	struct dentry *dbp, *version, *data;
+	int error;
 
 	dbp = debugfs_create_dir("boot_params", NULL);
 	if (!dbp) {
@@ -41,7 +189,13 @@ static int __init boot_params_kdebugfs_init(void)
 		error = -ENOMEM;
 		goto err_version;
 	}
+	error = create_setup_data_nodes(dbp);
+	if (error)
+		goto err_data;
 	return 0;
+
+err_data:
+	debugfs_remove(data);
 err_version:
 	debugfs_remove(version);
 err_dir:
@@ -61,5 +215,4 @@ static int __init arch_kdebugfs_init(void)
 
 	return error;
 }
-
 arch_initcall(arch_kdebugfs_init);
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
new file mode 100644
index 0000000..edc5fbf
--- /dev/null
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -0,0 +1,243 @@
+/*
+ * AMD Family 10h mmconfig enablement
+ */
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <linux/dmi.h>
+#include <asm/pci-direct.h>
+#include <linux/sort.h>
+#include <asm/io.h>
+#include <asm/msr.h>
+#include <asm/acpi.h>
+
+#include "../pci/pci.h"
+
+struct pci_hostbridge_probe {
+	u32 bus;
+	u32 slot;
+	u32 vendor;
+	u32 device;
+};
+
+static u64 __cpuinitdata fam10h_pci_mmconf_base;
+static int __cpuinitdata fam10h_pci_mmconf_base_status;
+
+static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
+	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
+};
+
+struct range {
+	u64 start;
+	u64 end;
+};
+
+static int __cpuinit cmp_range(const void *x1, const void *x2)
+{
+	const struct range *r1 = x1;
+	const struct range *r2 = x2;
+	int start1, start2;
+
+	start1 = r1->start >> 32;
+	start2 = r2->start >> 32;
+
+	return start1 - start2;
+}
+
+/*[47:0] */
+/* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
+#define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
+#define BASE_VALID(b) ((b != (0xfdULL << 32)) && (b != (0xfeULL << 32)))
+static void __cpuinit get_fam10h_pci_mmconf_base(void)
+{
+	int i;
+	unsigned bus;
+	unsigned slot;
+	int found;
+
+	u64 val;
+	u32 address;
+	u64 tom2;
+	u64 base = FAM10H_PCI_MMCONF_BASE;
+
+	int hi_mmio_num;
+	struct range range[8];
+
+	/* only try to get setting from BSP */
+	/* -1 or 1 */
+	if (fam10h_pci_mmconf_base_status)
+		return;
+
+	if (!early_pci_allowed())
+		goto fail;
+
+	found = 0;
+	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
+		u32 id;
+		u16 device;
+		u16 vendor;
+
+		bus = pci_probes[i].bus;
+		slot = pci_probes[i].slot;
+		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
+
+		vendor = id & 0xffff;
+		device = (id>>16) & 0xffff;
+		if (pci_probes[i].vendor == vendor &&
+		    pci_probes[i].device == device) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found)
+		goto fail;
+
+	/* SYS_CFG */
+	address = MSR_K8_SYSCFG;
+	rdmsrl(address, val);
+
+	/* TOP_MEM2 is not enabled? */
+	if (!(val & (1<<21))) {
+		tom2 = 0;
+	} else {
+		/* TOP_MEM2 */
+		address = MSR_K8_TOP_MEM2;
+		rdmsrl(address, val);
+		tom2 = val & (0xffffULL<<32);
+	}
+
+	if (base <= tom2)
+		base = tom2 + (1ULL<<32);
+
+	/*
+	 * need to check if the range is in the high mmio range that is
+	 * above 4G
+	 */
+	hi_mmio_num = 0;
+	for (i = 0; i < 8; i++) {
+		u32 reg;
+		u64 start;
+		u64 end;
+		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
+		if (!(reg & 3))
+			continue;
+
+		start = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
+		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
+		end = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
+
+		if (!end)
+			continue;
+
+		range[hi_mmio_num].start = start;
+		range[hi_mmio_num].end = end;
+		hi_mmio_num++;
+	}
+
+	if (!hi_mmio_num)
+		goto out;
+
+	/* sort the range */
+	sort(range, hi_mmio_num, sizeof(struct range), cmp_range, NULL);
+
+	if (range[hi_mmio_num - 1].end < base)
+		goto out;
+	if (range[0].start > base)
+		goto out;
+
+	/* need to find one window */
+	base = range[0].start - (1ULL << 32);
+	if ((base > tom2) && BASE_VALID(base))
+		goto out;
+	base = range[hi_mmio_num - 1].end + (1ULL << 32);
+	if ((base > tom2) && BASE_VALID(base))
+		goto out;
+	/* need to find window between ranges */
+	if (hi_mmio_num > 1)
+	for (i = 0; i < hi_mmio_num - 1; i++) {
+		if (range[i + 1].start > (range[i].end + (1ULL << 32))) {
+			base = range[i].end + (1ULL << 32);
+			if ((base > tom2) && BASE_VALID(base))
+				goto out;
+		}
+	}
+
+fail:
+	fam10h_pci_mmconf_base_status = -1;
+	return;
+out:
+	fam10h_pci_mmconf_base = base;
+	fam10h_pci_mmconf_base_status = 1;
+}
+
+void __cpuinit fam10h_check_enable_mmcfg(void)
+{
+	u64 val;
+	u32 address;
+
+	if (!(pci_probe & PCI_CHECK_ENABLE_AMD_MMCONF))
+		return;
+
+	address = MSR_FAM10H_MMIO_CONF_BASE;
+	rdmsrl(address, val);
+
+	/* try to make sure that AP's setting is identical to BSP setting */
+	if (val & FAM10H_MMIO_CONF_ENABLE) {
+		unsigned busnbits;
+		busnbits = (val >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
+			FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+		/* only trust the one handle 256 buses, if acpi=off */
+		if (!acpi_pci_disabled || busnbits >= 8) {
+			u64 base;
+			base = val & (0xffffULL << 32);
+			if (fam10h_pci_mmconf_base_status <= 0) {
+				fam10h_pci_mmconf_base = base;
+				fam10h_pci_mmconf_base_status = 1;
+				return;
+			} else if (fam10h_pci_mmconf_base ==  base)
+				return;
+		}
+	}
+
+	/*
+	 * if it is not enabled, try to enable it and assume only one segment
+	 * with 256 buses
+	 */
+	get_fam10h_pci_mmconf_base();
+	if (fam10h_pci_mmconf_base_status <= 0)
+		return;
+
+	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
+	val &= ~((FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT) |
+	     (FAM10H_MMIO_CONF_BUSRANGE_MASK<<FAM10H_MMIO_CONF_BUSRANGE_SHIFT));
+	val |= fam10h_pci_mmconf_base | (8 << FAM10H_MMIO_CONF_BUSRANGE_SHIFT) |
+	       FAM10H_MMIO_CONF_ENABLE;
+	wrmsrl(address, val);
+}
+
+static int __devinit set_check_enable_amd_mmconf(const struct dmi_system_id *d)
+{
+        pci_probe |= PCI_CHECK_ENABLE_AMD_MMCONF;
+        return 0;
+}
+
+static struct dmi_system_id __devinitdata mmconf_dmi_table[] = {
+        {
+                .callback = set_check_enable_amd_mmconf,
+                .ident = "Sun Microsystems Machine",
+                .matches = {
+                        DMI_MATCH(DMI_SYS_VENDOR, "Sun Microsystems"),
+                },
+        },
+	{}
+};
+
+void __init check_enable_amd_mmconf_dmi(void)
+{
+	dmi_check_system(mmconf_dmi_table);
+}
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 388b113..50a18e4 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -77,10 +77,14 @@ void __init dma32_reserve_bootmem(void)
 	if (end_pfn <= MAX_DMA32_PFN)
 		return;
 
+	/*
+	 * check aperture_64.c allocate_aperture() for reason about
+	 * using 512M as goal
+	 */
 	align = 64ULL<<20;
 	size = round_up(dma32_bootmem_size, align);
 	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
-				 __pa(MAX_DMA_ADDRESS));
+				 512ULL<<20);
 	if (dma32_bootmem_ptr)
 		dma32_bootmem_size = size;
 	else
@@ -88,7 +92,6 @@ void __init dma32_reserve_bootmem(void)
 }
 static void __init dma32_free_bootmem(void)
 {
-	int node;
 
 	if (end_pfn <= MAX_DMA32_PFN)
 		return;
@@ -96,9 +99,7 @@ static void __init dma32_free_bootmem(void)
 	if (!dma32_bootmem_ptr)
 		return;
 
-	for_each_online_node(node)
-		free_bootmem_node(NODE_DATA(node), __pa(dma32_bootmem_ptr),
-				  dma32_bootmem_size);
+	free_bootmem(__pa(dma32_bootmem_ptr), dma32_bootmem_size);
 
 	dma32_bootmem_ptr = NULL;
 	dma32_bootmem_size = 0;
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 17bdf23..2f5c488 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -29,6 +29,7 @@
 #include <linux/crash_dump.h>
 #include <linux/root_dev.h>
 #include <linux/pci.h>
+#include <asm/pci-direct.h>
 #include <linux/efi.h>
 #include <linux/acpi.h>
 #include <linux/kallsyms.h>
@@ -40,6 +41,7 @@
 #include <linux/dmi.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
+#include <linux/sort.h>
 #include <linux/uaccess.h>
 #include <linux/init_ohci1394_dma.h>
 
@@ -190,6 +192,7 @@ contig_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	bootmap_size = init_bootmem(bootmap >> PAGE_SHIFT, end_pfn);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
+	early_res_to_bootmem(0, end_pfn<<PAGE_SHIFT);
 	reserve_bootmem(bootmap, bootmap_size, BOOTMEM_DEFAULT);
 }
 #endif
@@ -264,6 +267,40 @@ void __attribute__((weak)) __init memory_setup(void)
        machine_specific_memory_setup();
 }
 
+static void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data;
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		switch (data->type) {
+		default:
+			break;
+		}
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+		free_early(pa_data, pa_data+sizeof(*data)+data->len);
+#endif
+		pa_data = data->next;
+		early_iounmap(data, PAGE_SIZE);
+	}
+}
+
+#ifdef CONFIG_PCI_MMCONFIG
+extern void __cpuinit fam10h_check_enable_mmcfg(void);
+extern void __init check_enable_amd_mmconf_dmi(void);
+#else
+void __cpuinit fam10h_check_enable_mmcfg(void)
+{
+}
+void __init check_enable_amd_mmconf_dmi(void)
+{
+}
+#endif
+
 /*
  * setup_arch - architecture-specific boot-time initializations
  *
@@ -316,6 +353,8 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	parse_setup_data();
+
 	parse_early_param();
 
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
@@ -397,8 +436,6 @@ void __init setup_arch(char **cmdline_p)
 	contig_initmem_init(0, end_pfn);
 #endif
 
-	early_res_to_bootmem();
-
 	dma32_reserve_bootmem();
 
 #ifdef CONFIG_ACPI_SLEEP
@@ -485,6 +522,9 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
+
+	/* do this before identify_cpu for boot cpu */
+	check_enable_amd_mmconf_dmi();
 }
 
 static int __cpuinit get_model_name(struct cpuinfo_x86 *c)
@@ -737,6 +777,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	/* MFENCE stops RDTSC speculation */
 	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 
+	if (c->x86 == 0x10)
+		fam10h_check_enable_mmcfg();
+
 	if (amd_apic_timer_broken())
 		disable_apic_timer = 1;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0cca626..e900757 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -810,7 +810,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 {
 #ifdef CONFIG_NUMA
-	int nid = phys_to_nid(phys);
+	int nid, next_nid;
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
 
@@ -829,10 +829,14 @@ void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 
 	/* Should check here against the e820 map to avoid double free */
 #ifdef CONFIG_NUMA
+	nid = phys_to_nid(phys);
+	next_nid = phys_to_nid(phys + len - 1);
+	if (nid == next_nid)
 	reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
-#else
-	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+	else
 #endif
+	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+
 	if (phys+len <= MAX_DMA_PFN*PAGE_SIZE) {
 		dma_reserve += len / PAGE_SIZE;
 		set_dma_reserve(dma_reserve);
@@ -926,6 +930,10 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
  */
+static long __meminitdata addr_start, addr_end;
+static void __meminitdata *p_start, *p_end;
+static int __meminitdata node_start;
+
 int __meminit
 vmemmap_populate(struct page *start_page, unsigned long size, int node)
 {
@@ -960,12 +968,32 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 							PAGE_KERNEL_LARGE);
 			set_pmd(pmd, __pmd(pte_val(entry)));
 
-			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
-				addr, addr + PMD_SIZE - 1, p, node);
+			/* check to see if we have contiguous blocks */
+			if (p_end != p || node_start != node) {
+				if (p_start)
+					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+						addr_start, addr_end-1, p_start, p_end-1, node_start);
+				addr_start = addr;
+				node_start = node;
+				p_start = p;
+			}
+			addr_end = addr + PMD_SIZE;
+			p_end = p + PMD_SIZE;
 		} else {
 			vmemmap_verify((pte_t *)pmd, node, addr, next);
 		}
 	}
 	return 0;
 }
+
+void __meminit vmemmap_populate_print_last(void)
+{
+	if (p_start) {
+		printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+			addr_start, addr_end-1, p_start, p_end-1, node_start);
+		p_start = NULL;
+		p_end = NULL;
+		node_start = 0;
+	}
+}
 #endif
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 86808e6..1f476e4 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -13,12 +13,15 @@
 #include <linux/nodemask.h>
 #include <asm/io.h>
 #include <linux/pci_ids.h>
+#include <linux/acpi.h>
 #include <asm/types.h>
 #include <asm/mmzone.h>
 #include <asm/proto.h>
 #include <asm/e820.h>
 #include <asm/pci-direct.h>
 #include <asm/numa.h>
+#include <asm/mpspec.h>
+#include <asm/apic.h>
 
 static __init int find_northbridge(void)
 {
@@ -44,6 +47,30 @@ static __init int find_northbridge(void)
 	return -1;
 }
 
+static __init void early_get_boot_cpu_id(void)
+{
+	/*
+	 * need to get boot_cpu_id so can use that to create apicid_to_node
+	 * in k8_scan_nodes()
+	 */
+	/*
+	 * Find possible boot-time SMP configuration:
+	 */
+	early_find_smp_config();
+#ifdef CONFIG_ACPI
+	/*
+	 * Read APIC information from ACPI tables.
+	 */
+	early_acpi_boot_init();
+#endif
+	/*
+	 * get boot-time SMP configuration:
+	 */
+	if (smp_found_config)
+		early_get_smp_config();
+	early_init_lapic_mapping();
+}
+
 int __init k8_scan_nodes(unsigned long start, unsigned long end)
 {
 	unsigned long prevbase;
@@ -56,6 +83,7 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	unsigned cores;
 	unsigned bits;
 	int j;
+	unsigned apicid_base;
 
 	if (!early_pci_allowed())
 		return -1;
@@ -174,11 +202,19 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	/* use the coreid bits from early_identify_cpu */
 	bits = boot_cpu_data.x86_coreid_bits;
 	cores = (1<<bits);
+	apicid_base = 0;
+	/* need to get boot_cpu_id early for system with apicid lifting */
+	early_get_boot_cpu_id();
+	if (boot_cpu_physical_apicid > 0) {
+		printk(KERN_INFO "BSP APIC ID: %02x\n",
+				 boot_cpu_physical_apicid);
+		apicid_base = boot_cpu_physical_apicid;
+	}
 
 	for (i = 0; i < 8; i++) {
 		if (nodes[i].start != nodes[i].end) {
 			nodeid = nodeids[i];
-			for (j = 0; j < cores; j++)
+			for (j = apicid_base; j < cores + apicid_base; j++)
 				apicid_to_node[(nodeid << bits) + j] = i;
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 		}
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 9a68922..efb7483 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -196,6 +196,7 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	unsigned long bootmap_start, nodedata_phys;
 	void *bootmap;
 	const int pgdat_size = round_up(sizeof(pg_data_t), PAGE_SIZE);
+	int nid;
 
 	start = round_up(start, ZONE_ALIGN);
 
@@ -218,9 +219,20 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
 	NODE_DATA(nodeid)->node_spanned_pages = end_pfn - start_pfn;
 
-	/* Find a place for the bootmem map */
+	/*
+	 * Find a place for the bootmem map
+	 * nodedata_phys could be on other nodes by alloc_bootmem,
+	 * so need to sure bootmap_start not to be small, otherwise
+	 * early_node_mem will get that with find_e820_area instead
+	 * of alloc_bootmem, that could clash with reserved range
+	 */
 	bootmap_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
-	bootmap_start = round_up(nodedata_phys + pgdat_size, PAGE_SIZE);
+	nid = phys_to_nid(nodedata_phys);
+	if (nid == nodeid)
+		bootmap_start = round_up(nodedata_phys + pgdat_size,
+					 PAGE_SIZE);
+	else
+		bootmap_start = round_up(start, PAGE_SIZE);
 	/*
 	 * SMP_CAHCE_BYTES could be enough, but init_bootmem_node like
 	 * to use that to align to PAGE_SIZE
@@ -245,10 +257,29 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 
 	free_bootmem_with_active_regions(nodeid, end);
 
-	reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys, pgdat_size,
-			BOOTMEM_DEFAULT);
-	reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
-			bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
+	/*
+	 * convert early reserve to bootmem reserve earlier
+	 * otherwise early_node_mem could use early reserved mem
+	 * on previous node
+	 */
+	early_res_to_bootmem(start, end);
+
+	/*
+	 * in some case early_node_mem could use alloc_bootmem
+	 * to get range on other node, don't reserve that again
+	 */
+	if (nid != nodeid)
+		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nodeid, nid);
+	else
+		reserve_bootmem_node(NODE_DATA(nodeid), nodedata_phys,
+					pgdat_size, BOOTMEM_DEFAULT);
+	nid = phys_to_nid(bootmap_start);
+	if (nid != nodeid)
+		printk(KERN_INFO "    bootmap(%d) on node %d\n", nodeid, nid);
+	else
+		reserve_bootmem_node(NODE_DATA(nodeid), bootmap_start,
+				 bootmap_pages<<PAGE_SHIFT, BOOTMEM_DEFAULT);
+
 #ifdef CONFIG_ACPI_NUMA
 	srat_reserve_add_area(nodeid);
 #endif
diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
index cdd6828..e9c5caf 100644
--- a/arch/x86/pci/Makefile_32
+++ b/arch/x86/pci/Makefile_32
@@ -10,5 +10,6 @@ pci-y				+= legacy.o irq.o
 
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
 pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
diff --git a/arch/x86/pci/Makefile_64 b/arch/x86/pci/Makefile_64
index 7d8c467..8fbd198 100644
--- a/arch/x86/pci/Makefile_64
+++ b/arch/x86/pci/Makefile_64
@@ -13,5 +13,5 @@ obj-y			+= legacy.o irq.o common.o early.o
 # mmconfig has a 64bit special
 obj-$(CONFIG_PCI_MMCONFIG) += mmconfig_64.o direct.o mmconfig-shared.o
 
-obj-$(CONFIG_NUMA)	+= k8-bus_64.o
+obj-y		+= k8-bus_64.o
 
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 2664cb3..28d17a5 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -6,45 +6,6 @@
 #include <asm/numa.h>
 #include "pci.h"
 
-static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
-{
-	pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
-	printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
-	return 0;
-}
-
-static struct dmi_system_id acpi_pciprobe_dmi_table[] __devinitdata = {
-/*
- * Systems where PCI IO resource ISA alignment can be skipped
- * when the ISA enable bit in the bridge control is not set
- */
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3800",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3800"),
-		},
-	},
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3850",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3850"),
-		},
-	},
-	{
-		.callback = can_skip_ioresource_align,
-		.ident = "IBM System x3950",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "x3950"),
-		},
-	},
-	{}
-};
-
 struct pci_root_info {
 	char *name;
 	unsigned int res_num;
@@ -191,9 +152,10 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 {
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
+	int node;
+#ifdef CONFIG_ACPI_NUMA
 	int pxm;
-
-	dmi_check_system(acpi_pciprobe_dmi_table);
+#endif
 
 	if (domain && !pci_domains_supported) {
 		printk(KERN_WARNING "PCI: Multiple domains not supported "
@@ -201,6 +163,20 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 		return NULL;
 	}
 
+	node = -1;
+#ifdef CONFIG_ACPI_NUMA
+	pxm = acpi_get_pxm(device->handle);
+	if (pxm >= 0)
+		node = pxm_to_node(pxm);
+	if (node != -1)
+		set_mp_bus_to_node(busnum, node);
+	else
+#endif
+		node = get_mp_bus_to_node(busnum);
+
+	if (node != -1 && !node_online(node))
+		node = -1;
+
 	/* Allocate per-root-bus (not per bus) arch-specific data.
 	 * TODO: leak; this memory is never freed.
 	 * It's arguable whether it's worth the trouble to care.
@@ -212,13 +188,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 	}
 
 	sd->domain = domain;
-	sd->node = -1;
-
-	pxm = acpi_get_pxm(device->handle);
-#ifdef CONFIG_ACPI_NUMA
-	if (pxm >= 0)
-		sd->node = pxm_to_node(pxm);
-#endif
+	sd->node = node;
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -237,18 +207,19 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 	if (!bus)
 		kfree(sd);
 
+	if (bus && node != -1) {
 #ifdef CONFIG_ACPI_NUMA
-	if (bus != NULL) {
-		if (pxm >= 0) {
-			printk("bus %d -> pxm %d -> node %d\n",
-				busnum, pxm, pxm_to_node(pxm));
-		}
-	}
+		if (pxm >= 0)
+			printk(KERN_DEBUG "bus %02x -> pxm %d -> node %d\n",
+				busnum, pxm, node);
+#else
+		printk(KERN_DEBUG "bus %02x -> node %d\n",
+			busnum, node);
 #endif
+	}
 
 	if (bus && (pci_probe & PCI_USE__CRS))
 		get_current_resources(device, busnum, domain, bus);
-	
 	return bus;
 }
 
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 75fcc29..9f6b117 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -90,6 +90,50 @@ static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
 		rom_r->start = rom_r->end = rom_r->flags = 0;
 }
 
+static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
+{
+	pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
+	printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
+	return 0;
+}
+
+static struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitdata = {
+/*
+ * Systems where PCI IO resource ISA alignment can be skipped
+ * when the ISA enable bit in the bridge control is not set
+ */
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3800",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3800"),
+		},
+	},
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3850",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3850"),
+		},
+	},
+	{
+		.callback = can_skip_ioresource_align,
+		.ident = "IBM System x3950",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "x3950"),
+		},
+	},
+	{}
+};
+
+void __init dmi_check_skip_isa_align(void)
+{
+	dmi_check_system(can_skip_pciprobe_dmi_table);
+}
+
 /*
  *  Called after each bus is probed, but before its children
  *  are examined.
@@ -318,13 +362,16 @@ static struct dmi_system_id __devinitdata pciprobe_dmi_table[] = {
 	{}
 };
 
+void __init dmi_check_pciprobe(void)
+{
+	dmi_check_system(pciprobe_dmi_table);
+}
+
 struct pci_bus * __devinit pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
 
-	dmi_check_system(pciprobe_dmi_table);
-
 	while ((bus = pci_find_next_bus(bus)) != NULL) {
 		if (bus->number == busnum) {
 			/* Already scanned */
@@ -342,9 +389,14 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 		return NULL;
 	}
 
+	sd->node = get_mp_bus_to_node(busnum);
+
 	printk(KERN_DEBUG "PCI: Probing PCI hardware (bus %02x)\n", busnum);
+	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	if (!bus)
+		kfree(sd);
 
-	return pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
+	return bus;
 }
 
 extern u8 pci_cache_line_size;
@@ -420,6 +472,10 @@ char * __devinit  pcibios_setup(char *str)
 		pci_probe &= ~PCI_PROBE_MMCONF;
 		return NULL;
 	}
+	else if (!strcmp(str, "check_enable_amd_mmconf")) {
+		pci_probe |= PCI_CHECK_ENABLE_AMD_MMCONF;
+		return NULL;
+	}
 #endif
 	else if (!strcmp(str, "noacpi")) {
 		acpi_noirq_set();
@@ -453,6 +509,9 @@ char * __devinit  pcibios_setup(char *str)
 	} else if (!strcmp(str, "routeirq")) {
 		pci_routeirq = 1;
 		return NULL;
+	} else if (!strcmp(str, "skip_isa_align")) {
+		pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
+		return NULL;
 	}
 	return str;
 }
@@ -480,7 +539,7 @@ void pcibios_disable_device (struct pci_dev *dev)
 		pcibios_disable_irq(dev);
 }
 
-struct pci_bus *__devinit pci_scan_bus_with_sysdata(int busno)
+struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
@@ -495,10 +554,15 @@ struct pci_bus *__devinit pci_scan_bus_with_sysdata(int busno)
 		printk(KERN_ERR "PCI: OOM, skipping PCI bus %02x\n", busno);
 		return NULL;
 	}
-	sd->node = -1;
-	bus = pci_scan_bus(busno, &pci_root_ops, sd);
+	sd->node = node;
+	bus = pci_scan_bus(busno, ops, sd);
 	if (!bus)
 		kfree(sd);
 
 	return bus;
 }
+
+struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+{
+	return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
+}
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 42f3e4c..21d1e0e 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -258,7 +258,8 @@ void __init pci_direct_init(int type)
 {
 	if (type == 0)
 		return;
-	printk(KERN_INFO "PCI: Using configuration type %d\n", type);
+	printk(KERN_INFO "PCI: Using configuration type %d for base access\n",
+		 type);
 	if (type == 1)
 		raw_pci_ops = &pci_direct_conf1;
 	else
@@ -275,8 +276,10 @@ int __init pci_direct_probe(void)
 	if (!region)
 		goto type2;
 
-	if (pci_check_type1())
+	if (pci_check_type1()) {
+		raw_pci_ops = &pci_direct_conf1;
 		return 1;
+	}
 	release_resource(region);
 
  type2:
@@ -290,7 +293,6 @@ int __init pci_direct_probe(void)
 		goto fail2;
 
 	if (pci_check_type2()) {
-		printk(KERN_INFO "PCI: Using configuration type 2\n");
 		raw_pci_ops = &pci_direct_conf2;
 		return 2;
 	}
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index a5ef5f5..b60b2ab 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -493,3 +493,20 @@ static void __devinit pci_siemens_interrupt_controller(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
+
+/*
+ * Regular PCI devices have 256 bytes, but AMD Family 10h Opteron ext config
+ * have 4096 bytes.  Even if the device is capable, that doesn't mean we can
+ * access it.  Maybe we don't have a way to generate extended config space
+ * accesses.   So check it
+ */
+static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+{
+	dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1200, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, fam10h_pci_cfg_space_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, fam10h_pci_cfg_space_size);
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index 3de9f9b..f098a6e 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -6,16 +6,13 @@
    in the right sequence from here. */
 static __init int pci_access_init(void)
 {
-	int type __maybe_unused = 0;
-
 #ifdef CONFIG_PCI_DIRECT
+	int type = 0;
+
 	type = pci_direct_probe();
 #endif
-#ifdef CONFIG_PCI_MMCONFIG
-	pci_mmcfg_init(type);
-#endif
-	if (raw_pci_ops)
-		return 0;
+	pci_mmcfg_early_init();
+
 #ifdef CONFIG_PCI_BIOS
 	pci_pcbios_init();
 #endif
@@ -28,10 +25,14 @@ static __init int pci_access_init(void)
 #ifdef CONFIG_PCI_DIRECT
 	pci_direct_init(type);
 #endif
-	if (!raw_pci_ops)
+	if (!raw_pci_ops && !raw_pci_ext_ops)
 		printk(KERN_ERR
 		"PCI: Fatal: No config space access function found\n");
 
+	dmi_check_pciprobe();
+
+	dmi_check_skip_isa_align();
+
 	return 0;
 }
 arch_initcall(pci_access_init);
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 579745c..0908fca 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -136,9 +136,11 @@ static void __init pirq_peer_trick(void)
 		busmap[e->bus] = 1;
 	}
 	for(i = 1; i < 256; i++) {
+		int node;
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		if (pci_scan_bus_with_sysdata(i))
+		node = get_mp_bus_to_node(i);
+		if (pci_scan_bus_on_node(i, &pci_root_ops, node))
 			printk(KERN_INFO "PCI: Discovered primary peer "
 			       "bus %02x [IRQ]\n", i);
 	}
diff --git a/arch/x86/pci/k8-bus_64.c b/arch/x86/pci/k8-bus_64.c
index 9cc813e..cfdde16 100644
--- a/arch/x86/pci/k8-bus_64.c
+++ b/arch/x86/pci/k8-bus_64.c
@@ -1,83 +1,541 @@
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <asm/pci-direct.h>
 #include <asm/mpspec.h>
 #include <linux/cpumask.h>
+#include <linux/topology.h>
 
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
- *
- * RED-PEN need to call this again on PCI hotplug
- * RED-PEN empty cpus get reported wrong
+ * also get peer root bus resource for io,mmio
  */
 
-#define NODE_ID_REGISTER 0x60
-#define NODE_ID(dword) (dword & 0x07)
-#define LDT_BUS_NUMBER_REGISTER_0 0x94
-#define LDT_BUS_NUMBER_REGISTER_1 0xB4
-#define LDT_BUS_NUMBER_REGISTER_2 0xD4
-#define NR_LDT_BUS_NUMBER_REGISTERS 3
-#define SECONDARY_LDT_BUS_NUMBER(dword) ((dword >> 8) & 0xFF)
-#define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
-#define PCI_DEVICE_ID_K8HTCONFIG 0x1100
+
+/*
+ * sub bus (transparent) will use entres from 3 to store extra from root,
+ * so need to make sure have enought slot there, increase PCI_BUS_NUM_RESOURCES?
+ */
+#define RES_NUM 16
+struct pci_root_info {
+	char name[12];
+	unsigned int res_num;
+	struct resource res[RES_NUM];
+	int bus_min;
+	int bus_max;
+	int node;
+	int link;
+};
+
+/* 4 at this time, it may become to 32 */
+#define PCI_ROOT_NR 4
+static int pci_root_num;
+static struct pci_root_info pci_root_info[PCI_ROOT_NR];
+
+#ifdef CONFIG_NUMA
+
+#define BUS_NR 256
+
+static int mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+		mp_bus_to_node[busnum] = node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node = -1;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1))
+		return node;
+
+	node = mp_bus_to_node[busnum];
+
+	/*
+	 * let numa_node_id to decide it later in dma_alloc_pages
+	 * if there is no ram on that node
+	 */
+	if (node != -1 && !node_online(node))
+		node = -1;
+
+	return node;
+}
+#endif
+
+void set_pci_bus_resources_arch_default(struct pci_bus *b)
+{
+	int i;
+	int j;
+	struct pci_root_info *info;
+
+	/* if only one root bus, don't need to anything */
+	if (pci_root_num < 2)
+		return;
+
+	for (i = 0; i < pci_root_num; i++) {
+		if (pci_root_info[i].bus_min == b->number)
+			break;
+	}
+
+	if (i == pci_root_num)
+		return;
+
+	info = &pci_root_info[i];
+	for (j = 0; j < info->res_num; j++) {
+		struct resource *res;
+		struct resource *root;
+
+		res = &info->res[j];
+		b->resource[j] = res;
+		if (res->flags & IORESOURCE_IO)
+			root = &ioport_resource;
+		else
+			root = &iomem_resource;
+		insert_resource(root, res);
+	}
+}
+
+#define RANGE_NUM 16
+
+struct res_range {
+	size_t start;
+	size_t end;
+};
+
+static void __init update_range(struct res_range *range, size_t start,
+				size_t end)
+{
+	int i;
+	int j;
+
+	for (j = 0; j < RANGE_NUM; j++) {
+		if (!range[j].end)
+			continue;
+
+		if (start <= range[j].start && end >= range[j].end) {
+			range[j].start = 0;
+			range[j].end = 0;
+			continue;
+		}
+
+		if (start <= range[j].start && end < range[j].end && range[j].start < end + 1) {
+			range[j].start = end + 1;
+			continue;
+		}
+
+
+		if (start > range[j].start && end >= range[j].end && range[j].end > start - 1) {
+			range[j].end = start - 1;
+			continue;
+		}
+
+		if (start > range[j].start && end < range[j].end) {
+			/* find the new spare */
+			for (i = 0; i < RANGE_NUM; i++) {
+				if (range[i].end == 0)
+					break;
+			}
+			if (i < RANGE_NUM) {
+				range[i].end = range[j].end;
+				range[i].start = end + 1;
+			} else {
+				printk(KERN_ERR "run of slot in ranges\n");
+			}
+			range[j].end = start - 1;
+			continue;
+		}
+	}
+}
+
+static void __init update_res(struct pci_root_info *info, size_t start,
+			      size_t end, unsigned long flags, int merge)
+{
+	int i;
+	struct resource *res;
+
+	if (!merge)
+		goto addit;
+
+	/* try to merge it with old one */
+	for (i = 0; i < info->res_num; i++) {
+		size_t final_start, final_end;
+		size_t common_start, common_end;
+
+		res = &info->res[i];
+		if (res->flags != flags)
+			continue;
+
+		common_start = max((size_t)res->start, start);
+		common_end = min((size_t)res->end, end);
+		if (common_start > common_end + 1)
+			continue;
+
+		final_start = min((size_t)res->start, start);
+		final_end = max((size_t)res->end, end);
+
+		res->start = final_start;
+		res->end = final_end;
+		return;
+	}
+
+addit:
+
+	/* need to add that */
+	if (info->res_num >= RES_NUM)
+		return;
+
+	res = &info->res[info->res_num];
+	res->name = info->name;
+	res->flags = flags;
+	res->start = start;
+	res->end = end;
+	res->child = NULL;
+	info->res_num++;
+}
+
+struct pci_hostbridge_probe {
+	u32 bus;
+	u32 slot;
+	u32 vendor;
+	u32 device;
+};
+
+static struct pci_hostbridge_probe pci_probes[] __initdata = {
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
+	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
+};
+
+static u64 __initdata fam10h_mmconf_start;
+static u64 __initdata fam10h_mmconf_end;
+static void __init get_pci_mmcfg_amd_fam10h_range(void)
+{
+	u32 address;
+	u64 base, msr;
+	unsigned segn_busn_bits;
+
+	/* assume all cpus from fam10h have mmconf */
+        if (boot_cpu_data.x86 < 0x10)
+		return;
+
+	address = MSR_FAM10H_MMIO_CONF_BASE;
+	rdmsrl(address, msr);
+
+	/* mmconfig is not enable */
+	if (!(msr & FAM10H_MMIO_CONF_ENABLE))
+		return;
+
+	base = msr & (FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT);
+
+	segn_busn_bits = (msr >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
+			 FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+	fam10h_mmconf_start = base;
+	fam10h_mmconf_end = base + (1ULL<<(segn_busn_bits + 20)) - 1;
+}
 
 /**
- * fill_mp_bus_to_cpumask()
+ * early_fill_mp_bus_to_node()
+ * called before pcibios_scan_root and pci_scan_bus
  * fills the mp_bus_to_cpumask array based according to the LDT Bus Number
  * Registers found in the K8 northbridge
  */
-__init static int
-fill_mp_bus_to_cpumask(void)
+static int __init early_fill_mp_bus_info(void)
 {
-	struct pci_dev *nb_dev = NULL;
-	int i, j;
-	u32 ldtbus, nid;
-	static int lbnr[3] = {
-		LDT_BUS_NUMBER_REGISTER_0,
-		LDT_BUS_NUMBER_REGISTER_1,
-		LDT_BUS_NUMBER_REGISTER_2
-	};
-
-	while ((nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-			PCI_DEVICE_ID_K8HTCONFIG, nb_dev))) {
-		pci_read_config_dword(nb_dev, NODE_ID_REGISTER, &nid);
-
-		for (i = 0; i < NR_LDT_BUS_NUMBER_REGISTERS; i++) {
-			pci_read_config_dword(nb_dev, lbnr[i], &ldtbus);
-			/*
-			 * if there are no busses hanging off of the current
-			 * ldt link then both the secondary and subordinate
-			 * bus number fields are set to 0.
-			 * 
-			 * RED-PEN
-			 * This is slightly broken because it assumes
- 			 * HT node IDs == Linux node ids, which is not always
-			 * true. However it is probably mostly true.
-			 */
-			if (!(SECONDARY_LDT_BUS_NUMBER(ldtbus) == 0
-				&& SUBORDINATE_LDT_BUS_NUMBER(ldtbus) == 0)) {
-				for (j = SECONDARY_LDT_BUS_NUMBER(ldtbus);
-				     j <= SUBORDINATE_LDT_BUS_NUMBER(ldtbus);
-				     j++) { 
-					struct pci_bus *bus;
-					struct pci_sysdata *sd;
-
-					long node = NODE_ID(nid);
-					/* Algorithm a bit dumb, but
- 					   it shouldn't matter here */
-					bus = pci_find_bus(0, j);
-					if (!bus)
-						continue;
-					if (!node_online(node))
-						node = 0;
-
-					sd = bus->sysdata;
-					sd->node = node;
-				}		
+	int i;
+	int j;
+	unsigned bus;
+	unsigned slot;
+	int found;
+	int node;
+	int link;
+	int def_node;
+	int def_link;
+	struct pci_root_info *info;
+	u32 reg;
+	struct resource *res;
+	size_t start;
+	size_t end;
+	struct res_range range[RANGE_NUM];
+	u64 val;
+	u32 address;
+
+#ifdef CONFIG_NUMA
+	for (i = 0; i < BUS_NR; i++)
+		mp_bus_to_node[i] = -1;
+#endif
+
+	if (!early_pci_allowed())
+		return -1;
+
+	found = 0;
+	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
+		u32 id;
+		u16 device;
+		u16 vendor;
+
+		bus = pci_probes[i].bus;
+		slot = pci_probes[i].slot;
+		id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
+
+		vendor = id & 0xffff;
+		device = (id>>16) & 0xffff;
+		if (pci_probes[i].vendor == vendor &&
+		    pci_probes[i].device == device) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found)
+		return 0;
+
+	pci_root_num = 0;
+	for (i = 0; i < 4; i++) {
+		int min_bus;
+		int max_bus;
+		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
+
+		/* Check if that register is enabled for bus range */
+		if ((reg & 7) != 3)
+			continue;
+
+		min_bus = (reg >> 16) & 0xff;
+		max_bus = (reg >> 24) & 0xff;
+		node = (reg >> 4) & 0x07;
+#ifdef CONFIG_NUMA
+		for (j = min_bus; j <= max_bus; j++)
+			mp_bus_to_node[j] = (unsigned char) node;
+#endif
+		link = (reg >> 8) & 0x03;
+
+		info = &pci_root_info[pci_root_num];
+		info->bus_min = min_bus;
+		info->bus_max = max_bus;
+		info->node = node;
+		info->link = link;
+		sprintf(info->name, "PCI Bus #%02x", min_bus);
+		pci_root_num++;
+	}
+
+	/* get the default node and link for left over res */
+	reg = read_pci_config(bus, slot, 0, 0x60);
+	def_node = (reg >> 8) & 0x07;
+	reg = read_pci_config(bus, slot, 0, 0x64);
+	def_link = (reg >> 8) & 0x03;
+
+	memset(range, 0, sizeof(range));
+	range[0].end = 0xffff;
+	/* io port resource */
+	for (i = 0; i < 4; i++) {
+		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
+		if (!(reg & 3))
+			continue;
+
+		start = reg & 0xfff000;
+		reg = read_pci_config(bus, slot, 1, 0xc4 + (i << 3));
+		node = reg & 0x07;
+		link = (reg >> 4) & 0x03;
+		end = (reg & 0xfff000) | 0xfff;
+
+		/* find the position */
+		for (j = 0; j < pci_root_num; j++) {
+			info = &pci_root_info[j];
+			if (info->node == node && info->link == link)
+				break;
+		}
+		if (j == pci_root_num)
+			continue; /* not found */
+
+		info = &pci_root_info[j];
+		printk(KERN_DEBUG "node %d link %d: io port [%llx, %llx]\n",
+		       node, link, (u64)start, (u64)end);
+
+		/* kernel only handle 16 bit only */
+		if (end > 0xffff)
+			end = 0xffff;
+		update_res(info, start, end, IORESOURCE_IO, 1);
+		update_range(range, start, end);
+	}
+	/* add left over io port range to def node/link, [0, 0xffff] */
+	/* find the position */
+	for (j = 0; j < pci_root_num; j++) {
+		info = &pci_root_info[j];
+		if (info->node == def_node && info->link == def_link)
+			break;
+	}
+	if (j < pci_root_num) {
+		info = &pci_root_info[j];
+		for (i = 0; i < RANGE_NUM; i++) {
+			if (!range[i].end)
+				continue;
+
+			update_res(info, range[i].start, range[i].end,
+				   IORESOURCE_IO, 1);
+		}
+	}
+
+	memset(range, 0, sizeof(range));
+	/* 0xfd00000000-0xffffffffff for HT */
+	range[0].end = (0xfdULL<<32) - 1;
+
+	/* need to take out [0, TOM) for RAM*/
+	address = MSR_K8_TOP_MEM1;
+	rdmsrl(address, val);
+	end = (val & 0xffffff8000000ULL);
+	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
+	if (end < (1ULL<<32))
+		update_range(range, 0, end - 1);
+
+	/* get mmconfig */
+	get_pci_mmcfg_amd_fam10h_range();
+	/* need to take out mmconf range */
+	if (fam10h_mmconf_end) {
+		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n", fam10h_mmconf_start, fam10h_mmconf_end);
+		update_range(range, fam10h_mmconf_start, fam10h_mmconf_end);
+	}
+
+	/* mmio resource */
+	for (i = 0; i < 8; i++) {
+		reg = read_pci_config(bus, slot, 1, 0x80 + (i << 3));
+		if (!(reg & 3))
+			continue;
+
+		start = reg & 0xffffff00; /* 39:16 on 31:8*/
+		start <<= 8;
+		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
+		node = reg & 0x07;
+		link = (reg >> 4) & 0x03;
+		end = (reg & 0xffffff00);
+		end <<= 8;
+		end |= 0xffff;
+
+		/* find the position */
+		for (j = 0; j < pci_root_num; j++) {
+			info = &pci_root_info[j];
+			if (info->node == node && info->link == link)
+				break;
+		}
+		if (j == pci_root_num)
+			continue; /* not found */
+
+		info = &pci_root_info[j];
+
+		printk(KERN_DEBUG "node %d link %d: mmio [%llx, %llx]",
+		       node, link, (u64)start, (u64)end);
+		/*
+		 * some sick allocation would have range overlap with fam10h
+		 * mmconf range, so need to update start and end.
+		 */
+		if (fam10h_mmconf_end) {
+			int changed = 0;
+			u64 endx = 0;
+			if (start >= fam10h_mmconf_start &&
+			    start <= fam10h_mmconf_end) {
+				start = fam10h_mmconf_end + 1;
+				changed = 1;
+			}
+
+			if (end >= fam10h_mmconf_start &&
+			    end <= fam10h_mmconf_end) {
+				end = fam10h_mmconf_start - 1;
+				changed = 1;
+			}
+
+			if (start < fam10h_mmconf_start &&
+			    end > fam10h_mmconf_end) {
+				/* we got a hole */
+				endx = fam10h_mmconf_start - 1;
+				update_res(info, start, endx, IORESOURCE_MEM, 0);
+				update_range(range, start, endx);
+				printk(KERN_CONT " ==> [%llx, %llx]", (u64)start, endx);
+				start = fam10h_mmconf_end + 1;
+				changed = 1;
+			}
+			if (changed) {
+				if (start <= end) {
+					printk(KERN_CONT " %s [%llx, %llx]", endx?"and":"==>", (u64)start, (u64)end);
+				} else {
+					printk(KERN_CONT "%s\n", endx?"":" ==> none");
+					continue;
+				}
 			}
 		}
+
+		update_res(info, start, end, IORESOURCE_MEM, 1);
+		update_range(range, start, end);
+		printk(KERN_CONT "\n");
+	}
+
+	/* need to take out [4G, TOM2) for RAM*/
+	/* SYS_CFG */
+	address = MSR_K8_SYSCFG;
+	rdmsrl(address, val);
+	/* TOP_MEM2 is enabled? */
+	if (val & (1<<21)) {
+		/* TOP_MEM2 */
+		address = MSR_K8_TOP_MEM2;
+		rdmsrl(address, val);
+		end = (val & 0xffffff8000000ULL);
+		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
+		update_range(range, 1ULL<<32, end - 1);
+	}
+
+	/*
+	 * add left over mmio range to def node/link ?
+	 * that is tricky, just record range in from start_min to 4G
+	 */
+	for (j = 0; j < pci_root_num; j++) {
+		info = &pci_root_info[j];
+		if (info->node == def_node && info->link == def_link)
+			break;
+	}
+	if (j < pci_root_num) {
+		info = &pci_root_info[j];
+
+		for (i = 0; i < RANGE_NUM; i++) {
+			if (!range[i].end)
+				continue;
+#if 0
+			/* don't use last one near 4G */
+			if (range[i].end == 0xffffffffULL)
+				continue;
+#endif
+
+			update_res(info, range[i].start, range[i].end,
+				   IORESOURCE_MEM, 1);
+		}
+	}
+
+#ifdef CONFIG_NUMA
+	for (i = 0; i < BUS_NR; i++) {
+		node = mp_bus_to_node[i];
+		if (node >= 0)
+			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
+	}
+#endif
+
+	for (i = 0; i < pci_root_num; i++) {
+		int res_num;
+		int busnum;
+
+		info = &pci_root_info[i];
+		res_num = info->res_num;
+		busnum = info->bus_min;
+		printk(KERN_DEBUG "bus: [%02x,%02x] on node %x link %x\n",
+		       info->bus_min, info->bus_max, info->node, info->link);
+		for (j = 0; j < res_num; j++) {
+			res = &info->res[j];
+			printk(KERN_DEBUG "bus: %02x index %x %s: [%llx, %llx]\n",
+			       busnum, j,
+			       (res->flags & IORESOURCE_IO)?"io port":"mmio",
+			       res->start, res->end);
+		}
 	}
 
 	return 0;
 }
 
-fs_initcall(fill_mp_bus_to_cpumask);
+postcore_initcall(early_fill_mp_bus_info);
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index e041ced..a67921c 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -12,6 +12,7 @@
 static void __devinit pcibios_fixup_peer_bridges(void)
 {
 	int n, devfn;
+	long node;
 
 	if (pcibios_last_bus <= 0 || pcibios_last_bus >= 0xff)
 		return;
@@ -21,12 +22,13 @@ static void __devinit pcibios_fixup_peer_bridges(void)
 		u32 l;
 		if (pci_find_bus(0, n))
 			continue;
+		node = get_mp_bus_to_node(n);
 		for (devfn = 0; devfn < 256; devfn += 8) {
 			if (!raw_pci_read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus_with_sysdata(n);
+				pci_scan_bus_on_node(n, &pci_root_ops, node);
 				break;
 			}
 		}
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 8d54df4..3fdee2d 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -28,7 +28,7 @@ static int __initdata pci_mmcfg_resources_inserted;
 static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
-	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
+	raw_pci_ops->read(0, 0, PCI_DEVFN(0, 0), 0xce, 2, &win);
 
 	win = win & 0xf000;
 	if(win == 0x0000 || win == 0xf000)
@@ -53,7 +53,7 @@ static const char __init *pci_mmcfg_intel_945(void)
 
 	pci_mmcfg_config_num = 1;
 
-	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+	raw_pci_ops->read(0, 0, PCI_DEVFN(0, 0), 0x48, 4, &pciexbar);
 
 	/* Enable bit */
 	if (!(pciexbar & 1))
@@ -100,33 +100,102 @@ static const char __init *pci_mmcfg_intel_945(void)
 	return "Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub";
 }
 
+static const char __init *pci_mmcfg_amd_fam10h(void)
+{
+	u32 low, high, address;
+	u64 base, msr;
+	int i;
+	unsigned segnbits = 0, busnbits;
+
+	if (!(pci_probe & PCI_CHECK_ENABLE_AMD_MMCONF))
+		return NULL;
+
+	address = MSR_FAM10H_MMIO_CONF_BASE;
+	if (rdmsr_safe(address, &low, &high))
+		return NULL;
+
+	msr = high;
+	msr <<= 32;
+	msr |= low;
+
+	/* mmconfig is not enable */
+	if (!(msr & FAM10H_MMIO_CONF_ENABLE))
+		return NULL;
+
+	base = msr & (FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT);
+
+	busnbits = (msr >> FAM10H_MMIO_CONF_BUSRANGE_SHIFT) &
+			 FAM10H_MMIO_CONF_BUSRANGE_MASK;
+
+	/*
+	 * only handle bus 0 ?
+	 * need to skip it
+	 */
+	if (!busnbits)
+		return NULL;
+
+	if (busnbits > 8) {
+		segnbits = busnbits - 8;
+		busnbits = 8;
+	}
+
+	pci_mmcfg_config_num = (1 << segnbits);
+	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]) *
+				   pci_mmcfg_config_num, GFP_KERNEL);
+	if (!pci_mmcfg_config)
+		return NULL;
+
+	for (i = 0; i < (1 << segnbits); i++) {
+		pci_mmcfg_config[i].address = base + (1<<28) * i;
+		pci_mmcfg_config[i].pci_segment = i;
+		pci_mmcfg_config[i].start_bus_number = 0;
+		pci_mmcfg_config[i].end_bus_number = (1 << busnbits) - 1;
+	}
+
+	return "AMD Family 10h NB";
+}
+
 struct pci_mmcfg_hostbridge_probe {
+	u32 bus;
+	u32 devfn;
 	u32 vendor;
 	u32 device;
 	const char *(*probe)(void);
 };
 
 static struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] __initdata = {
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_INTEL,
+	  PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ 0, PCI_DEVFN(0, 0), PCI_VENDOR_ID_INTEL,
+	  PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+	{ 0, PCI_DEVFN(0x18, 0), PCI_VENDOR_ID_AMD,
+	  0x1200, pci_mmcfg_amd_fam10h },
+	{ 0xff, PCI_DEVFN(0, 0), PCI_VENDOR_ID_AMD,
+	  0x1200, pci_mmcfg_amd_fam10h },
 };
 
 static int __init pci_mmcfg_check_hostbridge(void)
 {
 	u32 l;
+	u32 bus, devfn;
 	u16 vendor, device;
 	int i;
 	const char *name;
 
-	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
-	vendor = l & 0xffff;
-	device = (l >> 16) & 0xffff;
+	if (!raw_pci_ops)
+		return 0;
 
 	pci_mmcfg_config_num = 0;
 	pci_mmcfg_config = NULL;
 	name = NULL;
 
 	for (i = 0; !name && i < ARRAY_SIZE(pci_mmcfg_probes); i++) {
+		bus =  pci_mmcfg_probes[i].bus;
+		devfn = pci_mmcfg_probes[i].devfn;
+		raw_pci_ops->read(0, bus, devfn, 0, 4, &l);
+		vendor = l & 0xffff;
+		device = (l >> 16) & 0xffff;
+
 		if (pci_mmcfg_probes[i].vendor == vendor &&
 		    pci_mmcfg_probes[i].device == device)
 			name = pci_mmcfg_probes[i].probe();
@@ -173,9 +242,78 @@ static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
 	pci_mmcfg_resources_inserted = 1;
 }
 
-static void __init pci_mmcfg_reject_broken(int type)
+static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
+					      void *data)
+{
+	struct resource *mcfg_res = data;
+	struct acpi_resource_address64 address;
+	acpi_status status;
+
+	if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
+		struct acpi_resource_fixed_memory32 *fixmem32 =
+			&res->data.fixed_memory32;
+		if (!fixmem32)
+			return AE_OK;
+		if ((mcfg_res->start >= fixmem32->address) &&
+		    (mcfg_res->end < (fixmem32->address +
+				      fixmem32->address_length))) {
+			mcfg_res->flags = 1;
+			return AE_CTRL_TERMINATE;
+		}
+	}
+	if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
+	    (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
+		return AE_OK;
+
+	status = acpi_resource_to_address64(res, &address);
+	if (ACPI_FAILURE(status) ||
+	   (address.address_length <= 0) ||
+	   (address.resource_type != ACPI_MEMORY_RANGE))
+		return AE_OK;
+
+	if ((mcfg_res->start >= address.minimum) &&
+	    (mcfg_res->end < (address.minimum + address.address_length))) {
+		mcfg_res->flags = 1;
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
+		void *context, void **rv)
+{
+	struct resource *mcfg_res = context;
+
+	acpi_walk_resources(handle, METHOD_NAME__CRS,
+			    check_mcfg_resource, context);
+
+	if (mcfg_res->flags)
+		return AE_CTRL_TERMINATE;
+
+	return AE_OK;
+}
+
+static int __init is_acpi_reserved(unsigned long start, unsigned long end)
+{
+	struct resource mcfg_res;
+
+	mcfg_res.start = start;
+	mcfg_res.end = end;
+	mcfg_res.flags = 0;
+
+	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
+
+	if (!mcfg_res.flags)
+		acpi_get_devices("PNP0C02", find_mboard_resource, &mcfg_res,
+				 NULL);
+
+	return mcfg_res.flags;
+}
+
+static void __init pci_mmcfg_reject_broken(int early)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
+	int i;
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -184,51 +322,85 @@ static void __init pci_mmcfg_reject_broken(int type)
 
 	cfg = &pci_mmcfg_config[0];
 
-	/*
-	 * Handle more broken MCFG tables on Asus etc.
-	 * They only contain a single entry for bus 0-0.
-	 */
-	if (pci_mmcfg_config_num == 1 &&
-	    cfg->pci_segment == 0 &&
-	    (cfg->start_bus_number | cfg->end_bus_number) == 0) {
-		printk(KERN_ERR "PCI: start and end of bus number is 0. "
-		       "Rejected as broken MCFG.\n");
-		goto reject;
+	for (i = 0; i < pci_mmcfg_config_num; i++) {
+		int valid = 0;
+		u32 size = (cfg->end_bus_number + 1) << 20;
+		cfg = &pci_mmcfg_config[i];
+		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lx "
+		       "segment %hu buses %u - %u\n",
+		       i, (unsigned long)cfg->address, cfg->pci_segment,
+		       (unsigned int)cfg->start_bus_number,
+		       (unsigned int)cfg->end_bus_number);
+
+		if (!early &&
+		    is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
+			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
+			       "in ACPI motherboard resources\n",
+			       cfg->address);
+			valid = 1;
+		}
+
+		if (valid)
+			continue;
+
+		if (!early)
+			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
+			       " reserved in ACPI motherboard resources\n",
+			       cfg->address);
+		/* Don't try to do this check unless configuration
+		   type 1 is available. how about type 2 ?*/
+		if (raw_pci_ops && e820_all_mapped(cfg->address,
+						  cfg->address + size - 1,
+						  E820_RESERVED)) {
+			printk(KERN_NOTICE
+			       "PCI: MCFG area at %Lx reserved in E820\n",
+			       cfg->address);
+			valid = 1;
+		}
+
+		if (!valid)
+			goto reject;
 	}
 
-	/*
-	 * Only do this check when type 1 works. If it doesn't work
-	 * assume we run on a Mac and always use MCFG
-	 */
-	if (type == 1 && !e820_all_mapped(cfg->address,
-					  cfg->address + MMCONFIG_APER_MIN,
-					  E820_RESERVED)) {
-		printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
-		       " E820-reserved\n", cfg->address);
-		goto reject;
-	}
 	return;
 
 reject:
 	printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
+	pci_mmcfg_arch_free();
 	kfree(pci_mmcfg_config);
 	pci_mmcfg_config = NULL;
 	pci_mmcfg_config_num = 0;
 }
 
-void __init pci_mmcfg_init(int type)
-{
-	int known_bridge = 0;
+static int __initdata known_bridge;
 
+void __init __pci_mmcfg_init(int early)
+{
+	/* MMCONFIG disabled */
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
-	if (type == 1 && pci_mmcfg_check_hostbridge())
-		known_bridge = 1;
+	/* MMCONFIG already enabled */
+	if (!early && !(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
+		return;
+
+	/* for late to exit */
+	if (known_bridge)
+		return;
+
+	if (early) {
+		if (pci_mmcfg_check_hostbridge())
+			known_bridge = 1;
+#if 0
+	/* check e820 in late? */
+		else
+			return;
+#endif
+	}
 
 	if (!known_bridge) {
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-		pci_mmcfg_reject_broken(type);
+		pci_mmcfg_reject_broken(early);
 	}
 
 	if ((pci_mmcfg_config_num == 0) ||
@@ -249,6 +421,16 @@ void __init pci_mmcfg_init(int type)
 	}
 }
 
+void __init pci_mmcfg_early_init(void)
+{
+	__pci_mmcfg_init(1);
+}
+
+void __init pci_mmcfg_late_init(void)
+{
+	__pci_mmcfg_init(0);
+}
+
 static int __init pci_mmcfg_late_insert_resources(void)
 {
 	/*
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 081816a..f3c761d 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -136,3 +136,7 @@ int __init pci_mmcfg_arch_init(void)
 	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
+
+void __init pci_mmcfg_arch_free(void)
+{
+}
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index 9207fd4..a199416 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -127,7 +127,7 @@ static void __iomem * __init mcfg_ioremap(struct acpi_mcfg_allocation *cfg)
 int __init pci_mmcfg_arch_init(void)
 {
 	int i;
-	pci_mmcfg_virt = kmalloc(sizeof(*pci_mmcfg_virt) *
+	pci_mmcfg_virt = kzalloc(sizeof(*pci_mmcfg_virt) *
 				 pci_mmcfg_config_num, GFP_KERNEL);
 	if (pci_mmcfg_virt == NULL) {
 		printk(KERN_ERR "PCI: Can not allocate memory for mmconfig structures\n");
@@ -141,9 +141,29 @@ int __init pci_mmcfg_arch_init(void)
 			printk(KERN_ERR "PCI: Cannot map mmconfig aperture for "
 					"segment %d\n",
 				pci_mmcfg_config[i].pci_segment);
+			pci_mmcfg_arch_free();
 			return 0;
 		}
 	}
 	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
+
+void __init pci_mmcfg_arch_free(void)
+{
+	int i;
+
+	if (pci_mmcfg_virt == NULL)
+		return;
+
+	for (i = 0; i < pci_mmcfg_config_num; ++i) {
+		if (pci_mmcfg_virt[i].virt) {
+			iounmap(pci_mmcfg_virt[i].virt);
+			pci_mmcfg_virt[i].virt = NULL;
+			pci_mmcfg_virt[i].cfg = NULL;
+		}
+	}
+
+	kfree(pci_mmcfg_virt);
+	pci_mmcfg_virt = NULL;
+}
diff --git a/arch/x86/pci/mp_bus_to_node.c b/arch/x86/pci/mp_bus_to_node.c
new file mode 100644
index 0000000..0229439
--- /dev/null
+++ b/arch/x86/pci/mp_bus_to_node.c
@@ -0,0 +1,23 @@
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/topology.h>
+
+#define BUS_NR 256
+
+static unsigned char mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+	mp_bus_to_node[busnum] = (unsigned char) node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1))
+		return 0;
+	node = mp_bus_to_node[busnum];
+	return node;
+}
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index c4bddae..3b0db9b 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -26,6 +26,7 @@
 #define PCI_ASSIGN_ALL_BUSSES	0x4000
 #define PCI_CAN_SKIP_ISA_ALIGN	0x8000
 #define PCI_USE__CRS		0x10000
+#define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
 
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
@@ -37,6 +38,9 @@ enum pci_bf_sort_state {
 	pci_dmi_bf,
 };
 
+extern void __init dmi_check_pciprobe(void);
+extern void __init dmi_check_skip_isa_align(void);
+
 /* pci-i386.c */
 
 extern unsigned int pcibios_max_latency;
@@ -97,11 +101,11 @@ extern struct pci_raw_ops pci_direct_conf1;
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
-extern void pci_mmcfg_init(int type);
 
 /* pci-mmconfig.c */
 
 extern int __init pci_mmcfg_arch_init(void);
+extern void __init pci_mmcfg_arch_free(void);
 
 /*
  * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 2d1955c..a6dbcf4 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -35,6 +35,7 @@
 #ifdef CONFIG_X86
 #include <asm/mpspec.h>
 #endif
+#include <linux/pci.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -784,6 +785,7 @@ static int __init acpi_init(void)
 	result = acpi_bus_init();
 
 	if (!result) {
+		pci_mmcfg_late_init();
 		if (!(pm_flags & PM_APM))
 			pm_flags |= PM_ACPI;
 		else {
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 9248e09..be288b5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -787,6 +787,10 @@ int device_add(struct device *dev)
 	parent = get_device(dev->parent);
 	setup_parent(dev, parent);
 
+	/* use parent numa_node */
+	if (parent)
+		set_dev_node(dev, dev_to_node(parent));
+
 	/* first, register with generic layer. */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
 	if (error)
@@ -1306,8 +1310,11 @@ int device_move(struct device *dev, struct device *new_parent)
 	dev->parent = new_parent;
 	if (old_parent)
 		klist_remove(&dev->knode_parent);
-	if (new_parent)
+	if (new_parent) {
 		klist_add_tail(&dev->knode_parent, &new_parent->klist_children);
+		set_dev_node(dev, dev_to_node(new_parent));
+	}
+
 	if (!dev->class)
 		goto out_put;
 	error = device_move_class_links(dev, old_parent, new_parent);
@@ -1317,9 +1324,12 @@ int device_move(struct device *dev, struct device *new_parent)
 		if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
 			if (new_parent)
 				klist_remove(&dev->knode_parent);
-			if (old_parent)
+			dev->parent = old_parent;
+			if (old_parent) {
 				klist_add_tail(&dev->knode_parent,
 					       &old_parent->klist_children);
+				set_dev_node(dev, dev_to_node(old_parent));
+			}
 		}
 		cleanup_glue_dir(dev, new_parent_kobj);
 		put_device(new_parent);
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d8200ac..e77b321 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -264,11 +264,7 @@ static int __devinit aperture_valid(u64 aper, u32 size)
 		printk(KERN_ERR PFX "No aperture\n");
 		return 0;
 	}
-	if (size < 32*1024*1024) {
-		printk(KERN_ERR PFX "Aperture too small (%d MB)\n", size>>20);
-		return 0;
-	}
-       if ((u64)aper + size > 0x100000000ULL) {
+	if ((u64)aper + size > 0x100000000ULL) {
 		printk(KERN_ERR PFX "Aperture out of bounds\n");
 		return 0;
 	}
@@ -276,6 +272,10 @@ static int __devinit aperture_valid(u64 aper, u32 size)
 		printk(KERN_ERR PFX "Aperture pointing to RAM\n");
 		return 0;
 	}
+	if (size < 32*1024*1024) {
+		printk(KERN_ERR PFX "Aperture too small (%d MB)\n", size>>20);
+		return 0;
+	}
 
 	/* Request the Aperture. This catches cases when someone else
 	   already put a mapping in there - happens with some very broken BIOS
@@ -331,6 +331,17 @@ static __devinit int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp,
 	pci_read_config_dword(agp, 0x10, &aper_low);
 	pci_read_config_dword(agp, 0x14, &aper_hi);
 	aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
+
+	/*
+	 * On some sick chips APSIZE is 0. This means it wants 4G
+	 * so let double check that order, and lets trust the AMD NB settings
+	 */
+	if (order >=0 && aper + (32ULL<<(20 + order)) > 0x100000000ULL) {
+		printk(KERN_INFO "Aperture size %u MB is not right, using settings from NB\n",
+				  32 << order);
+		order = nb_order;
+	}
+
 	printk(KERN_INFO PFX "Aperture from AGP @ %Lx size %u MB\n", aper, 32 << order);
 	if (order < 0 || !aperture_valid(aper, (32*1024*1024)<<order))
 		return -1;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f991359..4a55bf3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -842,11 +842,14 @@ static void set_pcie_port_type(struct pci_dev *pdev)
  * reading the dword at 0x100 which must either be 0 or a valid extended
  * capability header.
  */
-int pci_cfg_space_size(struct pci_dev *dev)
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix)
 {
 	int pos;
 	u32 status;
 
+	if (!check_exp_pcix)
+		goto skip;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
@@ -858,6 +861,7 @@ int pci_cfg_space_size(struct pci_dev *dev)
 			goto fail;
 	}
 
+ skip:
 	if (pci_read_config_dword(dev, 256, &status) != PCIBIOS_SUCCESSFUL)
 		goto fail;
 	if (status == 0xffffffff)
@@ -869,6 +873,11 @@ int pci_cfg_space_size(struct pci_dev *dev)
 	return PCI_CFG_SPACE_SIZE;
 }
 
+int pci_cfg_space_size(struct pci_dev *dev)
+{
+	return pci_cfg_space_size_ext(dev, 1);
+}
+
 static void pci_release_bus_bridge_dev(struct device *dev)
 {
 	kfree(dev);
@@ -964,7 +973,6 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	dev->dev.release = pci_release_dev;
 	pci_dev_get(dev);
 
-	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.dma_parms = &dev->dma_parms;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
@@ -1080,6 +1088,10 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	return max;
 }
 
+void __attribute__((weak)) set_pci_bus_resources_arch_default(struct pci_bus *b)
+{
+}
+
 struct pci_bus * pci_create_bus(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
@@ -1119,6 +1131,9 @@ struct pci_bus * pci_create_bus(struct device *parent,
 		goto dev_reg_err;
 	b->bridge = get_device(dev);
 
+	if (!parent)
+		set_dev_node(b->bridge, pcibus_to_node(b));
+
 	b->dev.class = &pcibus_class;
 	b->dev.parent = b->bridge;
 	sprintf(b->dev.bus_id, "%04x:%02x", pci_domain_nr(b), bus);
@@ -1136,6 +1151,8 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	b->resource[0] = &ioport_resource;
 	b->resource[1] = &iomem_resource;
 
+	set_pci_bus_resources_arch_default(b);
+
 	return b;
 
 dev_create_file_err:
diff --git a/include/asm-x86/bootparam.h b/include/asm-x86/bootparam.h
index 5115135..e865990 100644
--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -9,6 +9,17 @@
 #include <asm/ist.h>
 #include <video/edid.h>
 
+/* setup data types */
+#define SETUP_NONE			0
+
+/* extensible setup data list node */
+struct setup_data {
+	u64 next;
+	u32 type;
+	u32 len;
+	u8 data[0];
+};
+
 struct setup_header {
 	__u8	setup_sects;
 	__u16	root_flags;
@@ -46,6 +57,9 @@ struct setup_header {
 	__u32	cmdline_size;
 	__u32	hardware_subarch;
 	__u64	hardware_subarch_data;
+	__u32	payload_offset;
+	__u32	payload_length;
+	__u64	setup_data;
 } __attribute__((packed));
 
 struct sys_desc_table {
diff --git a/include/asm-x86/e820_64.h b/include/asm-x86/e820_64.h
index f478c57..71c4d68 100644
--- a/include/asm-x86/e820_64.h
+++ b/include/asm-x86/e820_64.h
@@ -48,7 +48,8 @@ extern struct e820map e820;
 extern void update_e820(void);
 
 extern void reserve_early(unsigned long start, unsigned long end, char *name);
-extern void early_res_to_bootmem(void);
+extern void free_early(unsigned long start, unsigned long end);
+extern void early_res_to_bootmem(unsigned long start, unsigned long end);
 
 #endif/*!__ASSEMBLY__*/
 
diff --git a/include/asm-x86/pci.h b/include/asm-x86/pci.h
index ddd8e24..30bbde0 100644
--- a/include/asm-x86/pci.h
+++ b/include/asm-x86/pci.h
@@ -19,6 +19,8 @@ struct pci_sysdata {
 };
 
 /* scan a bus after allocating a pci_sysdata for it */
+extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops,
+					    int node);
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
 static inline int pci_domain_nr(struct pci_bus *bus)
diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 2207326..0e6d6b0 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -193,9 +193,25 @@ extern cpumask_t cpu_coregroup_map(int cpu);
 #define topology_thread_siblings(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #endif
 
+struct pci_bus;
+void set_pci_bus_resources_arch_default(struct pci_bus *b);
+
 #ifdef CONFIG_SMP
 #define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
+#ifdef CONFIG_NUMA
+extern int get_mp_bus_to_node(int busnum);
+extern void set_mp_bus_to_node(int busnum, int node);
+#else
+static inline int get_mp_bus_to_node(int busnum)
+{
+	return 0;
+}
+static inline void set_mp_bus_to_node(int busnum, int node)
+{
+}
+#endif
+
 #endif
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 2c7e003..41f7ce7 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -79,6 +79,7 @@ typedef int (*acpi_table_handler) (struct acpi_table_header *table);
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
 int acpi_numa_init (void);
@@ -235,6 +236,10 @@ int acpi_check_mem_region(resource_size_t start, resource_size_t n,
 
 #else	/* CONFIG_ACPI */
 
+static inline int early_acpi_boot_init(void)
+{
+	return 0;
+}
 static inline int acpi_boot_init(void)
 {
 	return 0;
diff --git a/include/linux/ide.h b/include/linux/ide.h
index f20410d..13779aa 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1303,8 +1303,7 @@ static inline void ide_dump_identify(u8 *id)
 
 static inline int hwif_to_node(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
+	return hwif->dev ? dev_to_node(hwif->dev) : -1;
 }
 
 static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b695875..286d315 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1229,6 +1229,7 @@ void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
 int vmemmap_populate_basepages(struct page *start_page,
 						unsigned long pages, int node);
 int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
+void vmemmap_populate_print_last(void);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2924913..abc998f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -254,7 +254,7 @@ static inline void pci_add_saved_cap(struct pci_dev *pci_dev,
 #define PCI_NUM_RESOURCES	11
 
 #ifndef PCI_BUS_NUM_RESOURCES
-#define PCI_BUS_NUM_RESOURCES	8
+#define PCI_BUS_NUM_RESOURCES	16
 #endif
 
 #define PCI_REGION_FLAG_MASK	0x0fU	/* These bits of resource flags tell us the PCI region flags */
@@ -666,6 +666,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
 		  void *userdata);
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus *bus);
 
@@ -1053,5 +1054,13 @@ extern unsigned long pci_cardbus_mem_size;
 
 extern int pcibios_add_platform_entries(struct pci_dev *dev);
 
+#ifdef CONFIG_PCI_MMCONFIG
+extern void __init pci_mmcfg_early_init(void);
+extern void __init pci_mmcfg_late_init(void);
+#else
+static inline void pci_mmcfg_early_init(void) { }
+static inline void pci_mmcfg_late_init(void) { }
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 2ccea70..590873d 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -111,44 +111,71 @@ static unsigned long __init init_bootmem_core(pg_data_t *pgdat,
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static int __init reserve_bootmem_core(bootmem_data_t *bdata,
+static int __init can_reserve_bootmem_core(bootmem_data_t *bdata,
 			unsigned long addr, unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
-	int ret;
+
+	BUG_ON(!size);
+
+	/* out of range, don't hold other */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return 0;
 
 	/*
-	 * round up, partially reserved pages are considered
-	 * fully reserved.
+	 * Round up to index to the range.
 	 */
+	if (addr > bdata->node_boot_start)
+		sidx= PFN_DOWN(addr - bdata->node_boot_start);
+	else
+		sidx = 0;
+
+	eidx = PFN_UP(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+
+	for (i = sidx; i < eidx; i++)
+		if (test_bit(i, bdata->node_bootmem_map)) {
+			if (flags & BOOTMEM_EXCLUSIVE)
+				return -EBUSY;
+		}
+
+	return 0;
+
+}
+static void __init reserve_bootmem_core(bootmem_data_t *bdata,
+			unsigned long addr, unsigned long size, int flags)
+{
+	unsigned long sidx, eidx;
+	unsigned long i;
+
 	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
-	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
-	BUG_ON(addr < bdata->node_boot_start);
 
-	sidx = PFN_DOWN(addr - bdata->node_boot_start);
+	/* out of range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
+
+	/*
+	 * Round up to index to the range.
+	 */
+	if (addr > bdata->node_boot_start)
+		sidx= PFN_DOWN(addr - bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++)
 		if (test_and_set_bit(i, bdata->node_bootmem_map)) {
 #ifdef CONFIG_DEBUG_BOOTMEM
 			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
 #endif
-			if (flags & BOOTMEM_EXCLUSIVE) {
-				ret = -EBUSY;
-				goto err;
-			}
 		}
-
-	return 0;
-
-err:
-	/* unreserve memory we accidentally reserved */
-	for (i--; i >= sidx; i--)
-		clear_bit(i, bdata->node_bootmem_map);
-
-	return ret;
 }
 
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
@@ -206,9 +233,11 @@ void * __init
 __alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
 	      unsigned long align, unsigned long goal, unsigned long limit)
 {
-	unsigned long offset, remaining_size, areasize, preferred;
+	unsigned long areasize, preferred;
 	unsigned long i, start = 0, incr, eidx, end_pfn;
 	void *ret;
+	unsigned long node_boot_start;
+	void *node_bootmem_map;
 
 	if (!size) {
 		printk("__alloc_bootmem_core(): zero-sized request\n");
@@ -216,70 +245,83 @@ __alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
 	}
 	BUG_ON(align & (align-1));
 
-	if (limit && bdata->node_boot_start >= limit)
-		return NULL;
-
 	/* on nodes without memory - bootmem_map is NULL */
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
+	/* bdata->node_boot_start is supposed to be (12+6)bits alignment on x86_64 ? */
+	node_boot_start = bdata->node_boot_start;
+	node_bootmem_map = bdata->node_bootmem_map;
+	if (align) {
+		node_boot_start = ALIGN(bdata->node_boot_start, align);
+		if (node_boot_start > bdata->node_boot_start)
+			node_bootmem_map = (unsigned long *)bdata->node_bootmem_map +
+			    PFN_DOWN(node_boot_start - bdata->node_boot_start)/BITS_PER_LONG;
+	}
+
+	if (limit && node_boot_start >= limit)
+		return NULL;
+
 	end_pfn = bdata->node_low_pfn;
 	limit = PFN_DOWN(limit);
 	if (limit && end_pfn > limit)
 		end_pfn = limit;
 
-	eidx = end_pfn - PFN_DOWN(bdata->node_boot_start);
-	offset = 0;
-	if (align && (bdata->node_boot_start & (align - 1UL)) != 0)
-		offset = align - (bdata->node_boot_start & (align - 1UL));
-	offset = PFN_DOWN(offset);
+	eidx = end_pfn - PFN_DOWN(node_boot_start);
 
 	/*
 	 * We try to allocate bootmem pages above 'goal'
 	 * first, then we try to allocate lower pages.
 	 */
-	if (goal && goal >= bdata->node_boot_start && PFN_DOWN(goal) < end_pfn) {
-		preferred = goal - bdata->node_boot_start;
+	preferred = 0;
+	if (goal && PFN_DOWN(goal) < end_pfn) {
+		if (goal > node_boot_start)
+			preferred = goal - node_boot_start;
 
-		if (bdata->last_success >= preferred)
+		if (bdata->last_success > node_boot_start &&
+			bdata->last_success - node_boot_start >= preferred)
 			if (!limit || (limit && limit > bdata->last_success))
-				preferred = bdata->last_success;
-	} else
-		preferred = 0;
+				preferred = bdata->last_success - node_boot_start;
+	}
 
-	preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
+	preferred = PFN_DOWN(ALIGN(preferred, align));
 	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
 	incr = align >> PAGE_SHIFT ? : 1;
 
 restart_scan:
-	for (i = preferred; i < eidx; i += incr) {
+	for (i = preferred; i < eidx;) {
 		unsigned long j;
-		i = find_next_zero_bit(bdata->node_bootmem_map, eidx, i);
+
+		i = find_next_zero_bit(node_bootmem_map, eidx, i);
 		i = ALIGN(i, incr);
 		if (i >= eidx)
 			break;
-		if (test_bit(i, bdata->node_bootmem_map))
+		if (test_bit(i, node_bootmem_map)) {
+			i += incr;
 			continue;
+		}
 		for (j = i + 1; j < i + areasize; ++j) {
 			if (j >= eidx)
 				goto fail_block;
-			if (test_bit(j, bdata->node_bootmem_map))
+			if (test_bit(j, node_bootmem_map))
 				goto fail_block;
 		}
 		start = i;
 		goto found;
 	fail_block:
 		i = ALIGN(j, incr);
+		if (i == j)
+			i += incr;
 	}
 
-	if (preferred > offset) {
-		preferred = offset;
+	if (preferred > 0) {
+		preferred = 0;
 		goto restart_scan;
 	}
 	return NULL;
 
 found:
-	bdata->last_success = PFN_PHYS(start);
+	bdata->last_success = PFN_PHYS(start) + node_boot_start;
 	BUG_ON(start >= eidx);
 
 	/*
@@ -289,6 +331,7 @@ found:
 	 */
 	if (align < PAGE_SIZE &&
 	    bdata->last_offset && bdata->last_pos+1 == start) {
+		unsigned long offset, remaining_size;
 		offset = ALIGN(bdata->last_offset, align);
 		BUG_ON(offset > PAGE_SIZE);
 		remaining_size = PAGE_SIZE - offset;
@@ -297,14 +340,12 @@ found:
 			/* last_pos unchanged */
 			bdata->last_offset = offset + size;
 			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset +
-					   bdata->node_boot_start);
+					   offset + node_boot_start);
 		} else {
 			remaining_size = size - remaining_size;
 			areasize = (remaining_size + PAGE_SIZE-1) / PAGE_SIZE;
 			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset +
-					   bdata->node_boot_start);
+					   offset + node_boot_start);
 			bdata->last_pos = start + areasize - 1;
 			bdata->last_offset = remaining_size;
 		}
@@ -312,14 +353,14 @@ found:
 	} else {
 		bdata->last_pos = start + areasize - 1;
 		bdata->last_offset = size & ~PAGE_MASK;
-		ret = phys_to_virt(start * PAGE_SIZE + bdata->node_boot_start);
+		ret = phys_to_virt(start * PAGE_SIZE + node_boot_start);
 	}
 
 	/*
 	 * Reserve the area now:
 	 */
 	for (i = start; i < start + areasize; i++)
-		if (unlikely(test_and_set_bit(i, bdata->node_bootmem_map)))
+		if (unlikely(test_and_set_bit(i, node_bootmem_map)))
 			BUG();
 	memset(ret, 0, size);
 	return ret;
@@ -401,6 +442,11 @@ unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
+	int ret;
+
+	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	if (ret < 0)
+		return;
 	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
 }
 
@@ -426,7 +472,16 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
-	return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
+	int ret;
+	bootmem_data_t *bdata;
+	list_for_each_entry(bdata, &bdata_list, list) {
+		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
+		if (ret < 0)
+			return ret;
+	}
+	list_for_each_entry(bdata, &bdata_list, list)
+		reserve_bootmem_core(bdata, addr, size, flags);
+	return 0;
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 98d6b39..7e91913 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -295,6 +295,9 @@ struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 	return NULL;
 }
 
+void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
+{
+}
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -304,22 +307,50 @@ void __init sparse_init(void)
 	unsigned long pnum;
 	struct page *map;
 	unsigned long *usemap;
+	unsigned long **usemap_map;
+	int size;
+
+	/*
+	 * map is using big page (aka 2M in x86 64 bit)
+	 * usemap is less one page (aka 24 bytes)
+	 * so alloc 2M (with 2M align) and 24 bytes in turn will
+	 * make next 2M slip to one more 2M later.
+	 * then in big system, the memory will have a lot of holes...
+	 * here try to allocate 2M pages continously.
+	 *
+	 * powerpc need to call sparse_init_one_section right after each
+	 * sparse_early_mem_map_alloc, so allocate usemap_map at first.
+	 */
+	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
+	usemap_map = alloc_bootmem(size);
+	if (!usemap_map)
+		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
+		usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
+	}
 
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!present_section_nr(pnum))
 			continue;
 
-		usemap = sparse_early_usemap_alloc(pnum);
+		usemap = usemap_map[pnum];
 		if (!usemap)
 			continue;
 
+		map = sparse_early_mem_map_alloc(pnum);
+		if (!map)
+			continue;
+
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
 								usemap);
 	}
+
+	vmemmap_populate_print_last();
+
+	free_bootmem(__pa(usemap_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4fe605f..94448e6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -252,7 +252,7 @@ nodata:
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
 		unsigned int length, gfp_t gfp_mask)
 {
-	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
+	int node = dev_to_node(&dev->dev);
 	struct sk_buff *skb;
 
 	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, node);
