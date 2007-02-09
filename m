Return-Path: <linux-kernel-owner+w=401wt.eu-S1946547AbXBIPmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946547AbXBIPmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946555AbXBIPeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946548AbXBIPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=p7ArB4hFF+uE/cPfSDBfEMWbfZq7aFQI8ICefK9QOcziooSi2haM9DdBdLl1IT7OTUe2J88NFxHgVA96ieOO3xYzA+Kjh6N9a7Ce1IhIoaDWApq0jm2BpJFRDgVAUaELOsEIYZzs7RqBZPKGVKgbM/PPxcFN/9eleerPYS9ZdnU=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, paulus@samba.org
Subject: [PATCH 12/34] __initdata cleanup - powerpc
Date: Fri, 9 Feb 2007 17:21:11 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091721.11735.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/powerpc/kernel/legacy_serial.c linux-2.6.20-rc6-mm3/arch/powerpc/kernel/legacy_serial.c
--- linux-2.6.20-rc6-mm3.org/arch/powerpc/kernel/legacy_serial.c	2007-01-31 22:15:31.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/powerpc/kernel/legacy_serial.c	2007-01-31 22:19:30.000000000 +0200
@@ -565,7 +565,7 @@ static int __init check_legacy_serial_co
 	DBG("Found serial console at ttyS%d\n", offset);
 
 	if (speed) {
-		static char __initdata opt[16];
+		static char __initdata opt[16] = {0};
 		sprintf(opt, "%d", speed);
 		return add_preferred_console("ttyS", offset, opt);
 	} else
diff -urNp linux-2.6.20-rc6-mm3.org/arch/powerpc/kernel/pci_32.c linux-2.6.20-rc6-mm3/arch/powerpc/kernel/pci_32.c
--- linux-2.6.20-rc6-mm3.org/arch/powerpc/kernel/pci_32.c	2007-01-31 22:15:31.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/powerpc/kernel/pci_32.c	2007-01-31 22:19:30.000000000 +0200
@@ -889,7 +889,7 @@ void __init
 pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			   struct device_node *dev, int primary)
 {
-	static unsigned int static_lc_ranges[256] __initdata;
+	static unsigned int static_lc_ranges[256] __initdata = {0};
 	const unsigned int *dt_ranges;
 	unsigned int *lc_ranges, *ranges, *prev, size;
 	int rlen = 0, orig_rlen;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/powerpc/kernel/prom.c linux-2.6.20-rc6-mm3/arch/powerpc/kernel/prom.c
--- linux-2.6.20-rc6-mm3.org/arch/powerpc/kernel/prom.c	2007-01-31 22:15:31.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/powerpc/kernel/prom.c	2007-01-31 22:19:30.000000000 +0200
@@ -60,8 +60,8 @@
 #endif
 
 
-static int __initdata dt_root_addr_cells;
-static int __initdata dt_root_size_cells;
+static int __initdata dt_root_addr_cells = 0;
+static int __initdata dt_root_size_cells = 0;
 
 #ifdef CONFIG_PPC64
 int __initdata iommu_is_off;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/powerpc/kernel/prom_init.c linux-2.6.20-rc6-mm3/arch/powerpc/kernel/prom_init.c
--- linux-2.6.20-rc6-mm3.org/arch/powerpc/kernel/prom_init.c	2007-01-31 22:15:31.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/powerpc/kernel/prom_init.c	2007-01-31 22:19:30.000000000 +0200
@@ -157,26 +157,26 @@ extern void copy_and_flush(unsigned long
 			   unsigned long size, unsigned long offset);
 
 /* prom structure */
-static struct prom_t __initdata prom;
+static struct prom_t __initdata prom = {0};
 
-static unsigned long prom_entry __initdata;
+static unsigned long prom_entry __initdata = 0l;
 
 #define PROM_SCRATCH_SIZE 256
 
-static char __initdata of_stdout_device[256];
-static char __initdata prom_scratch[PROM_SCRATCH_SIZE];
+static char __initdata of_stdout_device[256] = {0};
+static char __initdata prom_scratch[PROM_SCRATCH_SIZE] = {0};
 
-static unsigned long __initdata dt_header_start;
-static unsigned long __initdata dt_struct_start, dt_struct_end;
-static unsigned long __initdata dt_string_start, dt_string_end;
+static unsigned long __initdata dt_header_start = 0l;
+static unsigned long __initdata dt_struct_start = 0l, dt_struct_end = 0l;
+static unsigned long __initdata dt_string_start = 0l, dt_string_end = 0l;
 
-static unsigned long __initdata prom_initrd_start, prom_initrd_end;
+static unsigned long __initdata prom_initrd_start = 0l, prom_initrd_end = 0l;
 
 #ifdef CONFIG_PPC64
-static int __initdata prom_iommu_force_on;
-static int __initdata prom_iommu_off;
-static unsigned long __initdata prom_tce_alloc_start;
-static unsigned long __initdata prom_tce_alloc_end;
+static int __initdata prom_iommu_force_on = 0;
+static int __initdata prom_iommu_off = 0;
+static unsigned long __initdata prom_tce_alloc_start = 0l;
+static unsigned long __initdata prom_tce_alloc_end = 0l;
 #endif
 
 /* Platforms codes are now obsolete in the kernel. Now only used within this
@@ -189,20 +189,20 @@ static unsigned long __initdata prom_tce
 #define PLATFORM_POWERMAC	0x0400
 #define PLATFORM_GENERIC	0x0500
 
-static int __initdata of_platform;
+static int __initdata of_platform = 0;
 
-static char __initdata prom_cmd_line[COMMAND_LINE_SIZE];
+static char __initdata prom_cmd_line[COMMAND_LINE_SIZE] = "";
 
-static unsigned long __initdata alloc_top;
-static unsigned long __initdata alloc_top_high;
-static unsigned long __initdata alloc_bottom;
-static unsigned long __initdata rmo_top;
-static unsigned long __initdata ram_top;
+static unsigned long __initdata alloc_top = 0l;
+static unsigned long __initdata alloc_top_high = 0l;
+static unsigned long __initdata alloc_bottom = 0l;
+static unsigned long __initdata rmo_top = 0l;
+static unsigned long __initdata ram_top = 0l;
 
-static struct mem_map_entry __initdata mem_reserve_map[MEM_RESERVE_MAP_SIZE];
-static int __initdata mem_reserve_cnt;
+static struct mem_map_entry __initdata mem_reserve_map[MEM_RESERVE_MAP_SIZE] = {{0}};
+static int __initdata mem_reserve_cnt = 0;
 
-static cell_t __initdata regbuf[1024];
+static cell_t __initdata regbuf[1024] = {0};
 
 
 #define MAX_CPU_THREADS 2
diff -urNp linux-2.6.20-rc6-mm3.org/arch/powerpc/mm/numa.c linux-2.6.20-rc6-mm3/arch/powerpc/mm/numa.c
--- linux-2.6.20-rc6-mm3.org/arch/powerpc/mm/numa.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/powerpc/mm/numa.c	2007-01-31 22:19:30.000000000 +0200
@@ -35,7 +35,7 @@ EXPORT_SYMBOL(numa_cpu_lookup_table);
 EXPORT_SYMBOL(numa_cpumask_lookup_table);
 EXPORT_SYMBOL(node_data);
 
-static bootmem_data_t __initdata plat_node_bdata[MAX_NUMNODES];
+static bootmem_data_t __initdata plat_node_bdata[MAX_NUMNODES] = {{0}};
 static int min_common_depth;
 static int n_mem_addr_cells, n_mem_size_cells;
 
diff -urNp linux-2.6.20-rc6-mm3.org/arch/powerpc/platforms/iseries/dt.c linux-2.6.20-rc6-mm3/arch/powerpc/platforms/iseries/dt.c
--- linux-2.6.20-rc6-mm3.org/arch/powerpc/platforms/iseries/dt.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/powerpc/platforms/iseries/dt.c	2007-01-31 22:19:30.000000000 +0200
@@ -61,7 +61,7 @@ struct iseries_flat_dt {
 	u64 reserve_map[2];
 };
 
-static void * __initdata dt_data;
+static void * __initdata dt_data = NULL;
 
 /*
  * Putting these strings here keeps them out of the section
diff -urNp linux-2.6.20-rc6-mm3.org/arch/powerpc/platforms/powermac/bootx_init.c linux-2.6.20-rc6-mm3/arch/powerpc/platforms/powermac/bootx_init.c
--- linux-2.6.20-rc6-mm3.org/arch/powerpc/platforms/powermac/bootx_init.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/powerpc/platforms/powermac/bootx_init.c	2007-01-31 22:19:30.000000000 +0200
@@ -32,11 +32,11 @@
 
 extern void __start(unsigned long r3, unsigned long r4, unsigned long r5);
 
-static unsigned long __initdata bootx_dt_strbase;
-static unsigned long __initdata bootx_dt_strend;
-static unsigned long __initdata bootx_node_chosen;
-static boot_infos_t * __initdata bootx_info;
-static char __initdata bootx_disp_path[256];
+static unsigned long __initdata bootx_dt_strbase = 0l;
+static unsigned long __initdata bootx_dt_strend = 0l;
+static unsigned long __initdata bootx_node_chosen = 0l;
+static boot_infos_t * __initdata bootx_info = NULL;
+static char __initdata bootx_disp_path[256] = {0};
 
 /* Is boot-info compatible ? */
 #define BOOT_INFO_IS_COMPATIBLE(bi) \
diff -urNp linux-2.6.20-rc6-mm3.org/arch/powerpc/xmon/xmon.c linux-2.6.20-rc6-mm3/arch/powerpc/xmon/xmon.c
--- linux-2.6.20-rc6-mm3.org/arch/powerpc/xmon/xmon.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/powerpc/xmon/xmon.c	2007-01-31 22:19:30.000000000 +0200
@@ -2632,7 +2632,7 @@ static int __init setup_xmon_sysrq(void)
 __initcall(setup_xmon_sysrq);
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-int __initdata xmon_early, xmon_off;
+int __initdata xmon_early = 0, xmon_off = 0;
 
 static int __init early_parse_xmon(char *p)
 {
