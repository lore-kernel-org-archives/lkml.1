Return-Path: <linux-kernel-owner+w=401wt.eu-S1946598AbXBIPpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946598AbXBIPpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946538AbXBIPot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:44:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946540AbXBIPeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BXrqeMgKVJKIjbUAz2saj90zi3UePvBpMlszF9yfpv2RkrvfrNQYHrz5fzTnzWB3wuuvphlbDJW5yQTY3/R5tuSuEKKSLFDGC3nzf7/UryqR0gGphnss1VuJ0iaPCHbPRzFkVryWW1m9F/YUYBzAegPtwfFJCYkLGndn7Asz54w=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, davej@codemonkey.org.uk, hpa@zytor.com,
       Riley@williams.name
Subject: [PATCH 06/34] __initdata cleanup - i386
Date: Fri, 9 Feb 2007 17:16:47 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091716.47567.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/kernel/acpi/boot.c linux-2.6.20-rc6-mm3/arch/i386/kernel/acpi/boot.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/kernel/acpi/boot.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/acpi/boot.c	2007-01-31 22:20:36.000000000 +0200
@@ -72,7 +72,7 @@ static inline int acpi_madt_oem_check(ch
 #define PREFIX			"ACPI: "
 
 int acpi_noirq;				/* skip ACPI IRQ initialization */
-int acpi_pci_disabled __initdata;	/* skip ACPI PCI scan and IRQ initialization */
+int acpi_pci_disabled __initdata = 0;	/* skip ACPI PCI scan and IRQ initialization */
 int acpi_ht __initdata = 1;	/* enable HT */
 
 int acpi_lapic;
@@ -80,10 +80,10 @@ int acpi_ioapic;
 int acpi_strict;
 EXPORT_SYMBOL(acpi_strict);
 
-u8 acpi_sci_flags __initdata;
-int acpi_sci_override_gsi __initdata;
-int acpi_skip_timer_override __initdata;
-int acpi_use_timer_override __initdata;
+u8 acpi_sci_flags __initdata = 0;
+int acpi_sci_override_gsi __initdata = 0;
+int acpi_skip_timer_override __initdata = 0;
+int acpi_use_timer_override __initdata = 0;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/kernel/acpi/earlyquirk.c linux-2.6.20-rc6-mm3/arch/i386/kernel/acpi/earlyquirk.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/kernel/acpi/earlyquirk.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/acpi/earlyquirk.c	2007-01-31 22:19:30.000000000 +0200
@@ -13,7 +13,7 @@
 
 #ifdef CONFIG_ACPI
 
-static int nvidia_hpet_detected __initdata;
+static int nvidia_hpet_detected __initdata = 0;
 
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/kernel/cpu/mtrr/generic.c linux-2.6.20-rc6-mm3/arch/i386/kernel/cpu/mtrr/generic.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/kernel/cpu/mtrr/generic.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/cpu/mtrr/generic.c	2007-01-31 22:19:30.000000000 +0200
@@ -26,7 +26,7 @@ static struct mtrr_state mtrr_state = {}
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "mtrr."
 
-static __initdata int mtrr_show;
+static __initdata int mtrr_show = 0;
 module_param_named(show, mtrr_show, bool, 0);
 
 /*  Get the MSR pair relating to a var range  */
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/kernel/e820.c linux-2.6.20-rc6-mm3/arch/i386/kernel/e820.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/kernel/e820.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/e820.c	2007-01-31 22:19:30.000000000 +0200
@@ -26,10 +26,10 @@ struct change_member {
 	struct e820entry *pbios; /* pointer to original bios entry */
 	unsigned long long addr; /* address for this change point */
 };
-static struct change_member change_point_list[2*E820MAX] __initdata;
-static struct change_member *change_point[2*E820MAX] __initdata;
-static struct e820entry *overlap_list[E820MAX] __initdata;
-static struct e820entry new_bios[E820MAX] __initdata;
+static struct change_member change_point_list[2*E820MAX] __initdata = {{0}};
+static struct change_member *change_point[2*E820MAX] __initdata = {0};
+static struct e820entry *overlap_list[E820MAX] __initdata = {0};
+static struct e820entry new_bios[E820MAX] __initdata = {{0}};
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0x10000000;
 #ifdef CONFIG_PCI
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/kernel/io_apic.c linux-2.6.20-rc6-mm3/arch/i386/kernel/io_apic.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/kernel/io_apic.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/io_apic.c	2007-01-31 22:19:30.000000000 +0200
@@ -72,7 +72,7 @@ int sis_apic_bug = -1;
  */
 int nr_ioapic_registers[MAX_IO_APICS];
 
-static int disable_timer_pin_1 __initdata;
+static int disable_timer_pin_1 __initdata = 0;
 
 /*
  * Rough estimation of how many shared IRQs there are, can
@@ -1920,7 +1920,7 @@ static void __init setup_ioapic_ids_from
 static void __init setup_ioapic_ids_from_mpc(void) { }
 #endif
 
-int no_timer_check __initdata;
+int no_timer_check __initdata = 0;
 
 static int __init notimercheck(char *s)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/kernel/setup.c linux-2.6.20-rc6-mm3/arch/i386/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -133,9 +133,9 @@ unsigned long saved_videomode;
 #define RAMDISK_PROMPT_FLAG		0x8000
 #define RAMDISK_LOAD_FLAG		0x4000	
 
-static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
-unsigned char __initdata boot_params[PARAM_SIZE];
+unsigned char __initdata boot_params[PARAM_SIZE] = {0};
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/kernel/srat.c linux-2.6.20-rc6-mm3/arch/i386/kernel/srat.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/kernel/srat.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/srat.c	2007-01-31 22:19:30.000000000 +0200
@@ -55,7 +55,7 @@ struct node_memory_chunk_s {
 static struct node_memory_chunk_s node_memory_chunk[MAXCHUNKS];
 
 static int num_memory_chunks;		/* total number of memory chunks */
-static u8 __initdata apicid_to_pxm[MAX_APICID];
+static u8 __initdata apicid_to_pxm[MAX_APICID] = {0};
 
 extern void * boot_ioremap(unsigned long, unsigned long);
 
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/kernel/summit.c linux-2.6.20-rc6-mm3/arch/i386/kernel/summit.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/kernel/summit.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/kernel/summit.c	2007-01-31 22:19:30.000000000 +0200
@@ -31,9 +31,9 @@
 #include <asm/io.h>
 #include <asm/mach-summit/mach_mpparse.h>
 
-static struct rio_table_hdr *rio_table_hdr __initdata;
-static struct scal_detail   *scal_devs[MAX_NUMNODES] __initdata;
-static struct rio_detail    *rio_devs[MAX_NUMNODES*4] __initdata;
+static struct rio_table_hdr *rio_table_hdr __initdata = NULL;
+static struct scal_detail   *scal_devs[MAX_NUMNODES] __initdata = {0};
+static struct rio_detail    *rio_devs[MAX_NUMNODES*4] __initdata = {0};
 
 static int __init setup_pci_node_map_for_wpeg(int wpeg_num, int last_bus)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/mach-generic/probe.c linux-2.6.20-rc6-mm3/arch/i386/mach-generic/probe.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/mach-generic/probe.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/mach-generic/probe.c	2007-01-31 22:19:30.000000000 +0200
@@ -30,7 +30,7 @@ struct genapic *apic_probe[] __initdata 
 	NULL,
 };
 
-static int cmdline_apic __initdata;
+static int cmdline_apic __initdata = 0;
 static int __init parse_apic(char *arg)
 {
 	int i;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/mach-voyager/voyager_cat.c linux-2.6.20-rc6-mm3/arch/i386/mach-voyager/voyager_cat.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/mach-voyager/voyager_cat.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/mach-voyager/voyager_cat.c	2007-01-31 22:19:30.000000000 +0200
@@ -561,7 +561,7 @@ cat_subread(voyager_module_t *modp, voya
 
 
 /* buffer for storing EPROM data read in during initialisation */
-static __initdata __u8 eprom_buf[0xFFFF];
+static __initdata __u8 eprom_buf[0xFFFF] = {0};
 static voyager_module_t *voyager_initial_module;
 
 /* Initialise the cat bus components.  We assume this is called by the
diff -urNp linux-2.6.20-rc6-mm3.org/arch/i386/mm/boot_ioremap.c linux-2.6.20-rc6-mm3/arch/i386/mm/boot_ioremap.c
--- linux-2.6.20-rc6-mm3.org/arch/i386/mm/boot_ioremap.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/i386/mm/boot_ioremap.c	2007-01-31 22:19:30.000000000 +0200
@@ -65,7 +65,7 @@ static void __boot_ioremap(unsigned long
 #define BOOT_IOREMAP_PAGES 4
 #define BOOT_IOREMAP_SIZE (BOOT_IOREMAP_PAGES*PAGE_SIZE)
 static __initdata char boot_ioremap_space[BOOT_IOREMAP_SIZE]
-		       __attribute__ ((aligned (PAGE_SIZE)));
+		       __attribute__ ((aligned (PAGE_SIZE))) = {0};
 
 /*
  * This only applies to things which need to ioremap before paging_init()
