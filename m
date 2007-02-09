Return-Path: <linux-kernel-owner+w=401wt.eu-S1946559AbXBIPmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946559AbXBIPmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946575AbXBIPmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:42:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946564AbXBIPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=OtXgt2ei5mbVS4c/eG6QR5xCOFmK1WAHMXc0f3QUuEarEtIZ3A//h1ObnIBGc98LAvxHw+8zZb81QJ9joL7pIdO2itx7pJ6Ek9BJMJdmE+09OSkSxREIOvhSDUp10TGYBvWmT4ue1k2V0hDybjh1bHja63hxaL98g2zqGGk6Weg=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, ak@muc.de, vojtech@suse.cz
Subject: [PATCH 18/34] __initdata cleanup - x86_64
Date: Fri, 9 Feb 2007 17:24:28 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091724.28770.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/crypto/aes.c linux-2.6.20-rc6-mm3/arch/x86_64/crypto/aes.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/crypto/aes.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/crypto/aes.c
@@ -83,10 +83,10 @@ struct aes_ctx
 #define E_KEY (&ctx->buf[0])
 #define D_KEY (&ctx->buf[60])
 
-static u8 pow_tab[256] __initdata;
-static u8 log_tab[256] __initdata;
-static u8 sbx_tab[256] __initdata;
-static u8 isb_tab[256] __initdata;
+static u8 pow_tab[256] __initdata = {0};
+static u8 log_tab[256] __initdata = {0};
+static u8 sbx_tab[256] __initdata = {0};
+static u8 isb_tab[256] __initdata = {0};
 static u32 rco_tab[10];
 u32 aes_ft_tab[4][256];
 u32 aes_it_tab[4][256];
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/apic.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/apic.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/apic.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/apic.c
@@ -43,9 +43,9 @@
 int apic_mapped;
 int apic_verbosity;
 int apic_runs_main_timer;
-int apic_calibrate_pmtmr __initdata;
+int apic_calibrate_pmtmr __initdata = 0;
 
-int disable_apic_timer __initdata;
+int disable_apic_timer __initdata = 0;
 
 static struct resource *ioapic_resources;
 static struct resource lapic_resource = {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/e820.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/e820.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/e820.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/e820.c
@@ -25,7 +25,7 @@
 #include <asm/bootsetup.h>
 #include <asm/sections.h>
 
-struct e820map e820 __initdata;
+struct e820map e820 __initdata = {0};
 
 /* 
  * PFN of last memory page.
@@ -402,10 +402,10 @@ static int __init sanitize_e820_map(stru
 		struct e820entry *pbios; /* pointer to original bios entry */
 		unsigned long long addr; /* address for this change point */
 	};
-	static struct change_member change_point_list[2*E820MAX] __initdata;
-	static struct change_member *change_point[2*E820MAX] __initdata;
-	static struct e820entry *overlap_list[E820MAX] __initdata;
-	static struct e820entry new_bios[E820MAX] __initdata;
+	static struct change_member change_point_list[2*E820MAX] __initdata = {{0}};
+	static struct change_member *change_point[2*E820MAX] __initdata = {0};
+	static struct e820entry *overlap_list[E820MAX] __initdata = {0};
+	static struct e820entry new_bios[E820MAX] __initdata = {{0}};
 	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
 	unsigned long long last_addr;
@@ -618,7 +618,7 @@ static int __init parse_memopt(char *p)
 } 
 early_param("mem", parse_memopt);
 
-static int userdef __initdata;
+static int userdef __initdata = 0;
 
 static int __init parse_memmap_opt(char *p)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/early_printk.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/early_printk.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/early_printk.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/early_printk.c
@@ -213,7 +213,7 @@ void early_printk(const char *fmt, ...)
 	va_end(ap);
 }
 
-static int __initdata keep_early;
+static int __initdata keep_early = 0;
 
 static int __init setup_early_printk(char *buf)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/early-quirks.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/early-quirks.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/early-quirks.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/early-quirks.c
@@ -30,7 +30,7 @@ static void via_bugs(void)
 
 #ifdef CONFIG_ACPI
 
-static int nvidia_hpet_detected __initdata;
+static int nvidia_hpet_detected __initdata = 0;
 
 static int __init nvidia_hpet_check(struct acpi_table_header *header)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/io_apic.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/io_apic.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/io_apic.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/io_apic.c
@@ -55,7 +55,7 @@ int sis_apic_bug; /* not actually suppor
 
 static int no_timer_check;
 
-static int disable_timer_pin_1 __initdata;
+static int disable_timer_pin_1 __initdata = 0;
 
 int timer_over_8254 __initdata = 1;
 
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/mpparse.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/mpparse.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/mpparse.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/mpparse.c
@@ -62,7 +62,7 @@ unsigned int boot_cpu_id = -1U;
 /* Internal processor count */
 unsigned int num_processors __initdata = 0;
 
-unsigned disabled_cpus __initdata;
+unsigned disabled_cpus __initdata = 0;
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map = PHYSID_MASK_NONE;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/pci-calgary.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/pci-calgary.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/pci-calgary.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/pci-calgary.c
@@ -142,9 +142,9 @@ unsigned int specified_table_size = TCE_
 static int translate_empty_slots __read_mostly = 0;
 static int calgary_detected __read_mostly = 0;
 
-static struct rio_table_hdr	*rio_table_hdr __initdata;
-static struct scal_detail	*scal_devs[MAX_NUMNODES] __initdata;
-static struct rio_detail	*rio_devs[MAX_NUMNODES * 4] __initdata;
+static struct rio_table_hdr	*rio_table_hdr __initdata = NULL;
+static struct scal_detail	*scal_devs[MAX_NUMNODES] __initdata = {0};
+static struct rio_detail	*rio_devs[MAX_NUMNODES * 4] __initdata = {0};
 
 struct calgary_bus_info {
 	void *tce_space;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/setup64.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/setup64.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/setup64.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/setup64.c
@@ -24,7 +24,7 @@
 #include <asm/proto.h>
 #include <asm/sections.h>
 
-char x86_boot_params[BOOT_PARAM_SIZE] __initdata;
+char x86_boot_params[BOOT_PARAM_SIZE] __initdata = "";
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/setup.c linux-2.6.20-rc6-mm3/arch/x86_64/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/kernel/setup.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/kernel/setup.c
@@ -100,7 +100,7 @@ EXPORT_SYMBOL_GPL(edid_info);
 
 extern int root_mountflags;
 
-char __initdata command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 struct resource standard_io_resources[] = {
 	{ .name = "dma1", .start = 0x00, .end = 0x1f,
@@ -333,8 +333,8 @@ static inline void copy_edd(void)
 
 #define EBDA_ADDR_POINTER 0x40E
 
-unsigned __initdata ebda_addr;
-unsigned __initdata ebda_size;
+unsigned __initdata ebda_addr = 0;
+unsigned __initdata ebda_size = 0;
 
 static void discover_ebda(void)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/mm/init.c linux-2.6.20-rc6-mm3/arch/x86_64/mm/init.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/mm/init.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/mm/init.c
@@ -49,7 +49,7 @@
 struct dma_mapping_ops* dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
-static unsigned long dma_reserve __initdata;
+static unsigned long dma_reserve __initdata = 0l;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
@@ -165,7 +165,7 @@ __set_fixmap (enum fixed_addresses idx, 
 	set_pte_phys(address, phys, prot);
 }
 
-unsigned long __initdata table_start, table_end; 
+unsigned long __initdata table_start = 0l, table_end = 0l;
 
 extern pmd_t temp_boot_pmds[]; 
 
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/mm/numa.c linux-2.6.20-rc6-mm3/arch/x86_64/mm/numa.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/mm/numa.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/mm/numa.c
@@ -35,9 +35,9 @@ unsigned char apicid_to_node[MAX_LOCAL_A
 };
 cpumask_t node_to_cpumask[MAX_NUMNODES] __read_mostly;
 
-int numa_off __initdata;
-unsigned long __initdata nodemap_addr;
-unsigned long __initdata nodemap_size;
+int numa_off __initdata = 0;
+unsigned long __initdata nodemap_addr = 0l;
+unsigned long __initdata nodemap_size = 0l;
 
 
 /*
diff -urNp linux-2.6.20-rc6-mm3.org/arch/x86_64/mm/srat.c linux-2.6.20-rc6-mm3/arch/x86_64/mm/srat.c
--- linux-2.6.20-rc6-mm3.org/arch/x86_64/mm/srat.c
+++ linux-2.6.20-rc6-mm3/arch/x86_64/mm/srat.c
@@ -21,14 +21,14 @@
 #include <asm/numa.h>
 #include <asm/e820.h>
 
-int acpi_numa __initdata;
+int acpi_numa __initdata = 0;
 
 static struct acpi_table_slit *acpi_slit;
 
-static nodemask_t nodes_parsed __initdata;
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
+static nodemask_t nodes_parsed __initdata = {{0}};
+static struct bootnode nodes[MAX_NUMNODES] __initdata = {{0}};
 static struct bootnode nodes_add[MAX_NUMNODES];
-static int found_add_area __initdata;
+static int found_add_area __initdata = 0;
 int hotadd_percent __initdata = 0;
 
 /* Too small nodes confuse the VM badly. Usually they result
