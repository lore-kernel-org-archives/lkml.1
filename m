Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYDZV4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYDZV4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYDZV4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:56:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYDZV4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:56:08 -0400
Date: Sat, 26 Apr 2008 23:55:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: [git pull] "big box" x86 changes, PCI
Message-ID: <20080426215540.GA3545@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
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


ok, this is the final chunk of the "big box" topic - the PCI changes. 

These are the largest, and while i tried to reduce their number it's 
still 19 commits - but it's all around the same topic. The bulk of the 
new code is in a single file. The tree can be pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-pci.git for-linus

this depends on the bootmem changes which are now upstream. These 
changes too have been in linux-next for some time and the cross-arch 
(build) success rate is high, as in:

   http://www.tglx.de/autoqa-cgi/index?run=89&tree=1

all but the last few patches have been in x86.git for a longer time and 
more than 95% of the changes are for arch/x86. (see the dates of the 
patches. The "15 Feb 2008" ones are older than their timestamp - that's 
when we imported those changes into a date-aware repository.)

i booted up this tree 5 times on x86, mixed 64-bit/32-bit.

	Ingo

------------------>
Robert Hancock (1):
      x86: validate against acpi motherboard resources

Yinghai Lu (18):
      x86: clear pci_mmcfg_virt when mmcfg get rejected
      x86: mmconf enable mcfg early
      x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
      x86_64: check and enable MMCONFIG for AMD Family 10h
      x86_64: check MSR to get MMCONFIG for AMD Family 10h
      x86: if acpi=off, force setting the mmconf for fam10h
      x86: seperate mmconf for fam10h out from setup_64.c
      driver core: try parent numa_node at first before using default
      x86: remove unneeded check in mmconf reject
      x86 pci: remove checking type for mmconfig probe
      x86: get mp_bus_to_node early
      x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit
      x86: multi pci root bus with different io resource range, on 64-bit
      x86: double check the multi root bus with fam10h mmconf
      x86_64: don't need set default res if only have one root bus
      acpi: get boot_cpu_id as early for k8_scan_nodes
      x86: work around io allocation overlap of HT links
      x86: add pci=check_enable_amd_mmconf and dmi check

 arch/x86/kernel/Makefile           |    2 +
 arch/x86/kernel/acpi/boot.c        |   70 +++++
 arch/x86/kernel/mmconf-fam10h_64.c |  243 +++++++++++++++
 arch/x86/kernel/setup_64.c         |   20 ++
 arch/x86/mm/k8topology_64.c        |   38 +++-
 arch/x86/pci/Makefile_32           |    1 +
 arch/x86/pci/Makefile_64           |    2 +-
 arch/x86/pci/acpi.c                |   27 +-
 arch/x86/pci/common.c              |   22 ++-
 arch/x86/pci/direct.c              |    8 +-
 arch/x86/pci/fixup.c               |   17 +
 arch/x86/pci/init.c                |   13 +-
 arch/x86/pci/irq.c                 |    4 +-
 arch/x86/pci/k8-bus_64.c           |  575 ++++++++++++++++++++++++++++++++----
 arch/x86/pci/legacy.c              |    4 +-
 arch/x86/pci/mmconfig-shared.c     |  247 +++++++++++++---
 arch/x86/pci/mmconfig_32.c         |    4 +
 arch/x86/pci/mmconfig_64.c         |   22 ++-
 arch/x86/pci/mp_bus_to_node.c      |   23 ++
 arch/x86/pci/pci.h                 |    3 +-
 drivers/acpi/bus.c                 |    2 +
 drivers/base/core.c                |   14 +-
 drivers/pci/probe.c                |   21 ++-
 include/asm-x86/pci.h              |    2 +
 include/asm-x86/topology.h         |   16 +
 include/linux/acpi.h               |    5 +
 include/linux/pci.h                |   11 +-
 27 files changed, 1284 insertions(+), 132 deletions(-)
 create mode 100644 arch/x86/kernel/mmconf-fam10h_64.c
 create mode 100644 arch/x86/pci/mp_bus_to_node.c

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
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 60e64c8..2f5c488 100644
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
 
@@ -287,6 +289,18 @@ static void __init parse_setup_data(void)
 	}
 }
 
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
@@ -508,6 +522,9 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
+
+	/* do this before identify_cpu for boot cpu */
+	check_enable_amd_mmconf_dmi();
 }
 
 static int __cpuinit get_model_name(struct cpuinfo_x86 *c)
@@ -760,6 +777,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	/* MFENCE stops RDTSC speculation */
 	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 
+	if (c->x86 == 0x10)
+		fam10h_check_enable_mmcfg();
+
 	if (amd_apic_timer_broken())
 		disable_apic_timer = 1;
 
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
index 2664cb3..1a9c0c6 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -191,7 +191,10 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 {
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
+	int node;
+#ifdef CONFIG_ACPI_NUMA
 	int pxm;
+#endif
 
 	dmi_check_system(acpi_pciprobe_dmi_table);
 
@@ -201,6 +204,17 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
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
+		node = get_mp_bus_to_node(busnum);
+#endif
+
 	/* Allocate per-root-bus (not per bus) arch-specific data.
 	 * TODO: leak; this memory is never freed.
 	 * It's arguable whether it's worth the trouble to care.
@@ -212,13 +226,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
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
@@ -238,9 +246,9 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 		kfree(sd);
 
 #ifdef CONFIG_ACPI_NUMA
-	if (bus != NULL) {
+	if (bus) {
 		if (pxm >= 0) {
-			printk("bus %d -> pxm %d -> node %d\n",
+			printk(KERN_DEBUG "bus %02x -> pxm %d -> node %d\n",
 				busnum, pxm, pxm_to_node(pxm));
 		}
 	}
@@ -248,7 +256,6 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 
 	if (bus && (pci_probe & PCI_USE__CRS))
 		get_current_resources(device, busnum, domain, bus);
-	
 	return bus;
 }
 
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 75fcc29..2a4d751 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -342,9 +342,14 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
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
@@ -420,6 +425,10 @@ char * __devinit  pcibios_setup(char *str)
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
@@ -480,7 +489,7 @@ void pcibios_disable_device (struct pci_dev *dev)
 		pcibios_disable_irq(dev);
 }
 
-struct pci_bus *__devinit pci_scan_bus_with_sysdata(int busno)
+struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
@@ -495,10 +504,15 @@ struct pci_bus *__devinit pci_scan_bus_with_sysdata(int busno)
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
index 3de9f9b..343c363 100644
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
@@ -28,7 +25,7 @@ static __init int pci_access_init(void)
 #ifdef CONFIG_PCI_DIRECT
 	pci_direct_init(type);
 #endif
-	if (!raw_pci_ops)
+	if (!raw_pci_ops && !raw_pci_ext_ops)
 		printk(KERN_ERR
 		"PCI: Fatal: No config space access function found\n");
 
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
index 9cc813e..ab6d4b1 100644
--- a/arch/x86/pci/k8-bus_64.c
+++ b/arch/x86/pci/k8-bus_64.c
@@ -1,83 +1,536 @@
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
index 8d54df4..0cfebec 100644
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
@@ -184,51 +322,80 @@ static void __init pci_mmcfg_reject_broken(int type)
 
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
+	}
 
 	if (!known_bridge) {
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-		pci_mmcfg_reject_broken(type);
+		pci_mmcfg_reject_broken(early);
 	}
 
 	if ((pci_mmcfg_config_num == 0) ||
@@ -249,6 +416,16 @@ void __init pci_mmcfg_init(int type)
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
index c4bddae..8ef86b5 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -26,6 +26,7 @@
 #define PCI_ASSIGN_ALL_BUSSES	0x4000
 #define PCI_CAN_SKIP_ISA_ALIGN	0x8000
 #define PCI_USE__CRS		0x10000
+#define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
 
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
@@ -97,11 +98,11 @@ extern struct pci_raw_ops pci_direct_conf1;
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
