Return-Path: <linux-kernel-owner+w=401wt.eu-S1946537AbXBIPpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946537AbXBIPpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946544AbXBIPoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:44:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946537AbXBIPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=l3elIM+Qc3H3JunUupv0tRz1InAzOKsd7jOj1RXrmTanKbKlKK+PrAA85A7CdKy8aswY11l0N4CcvWUJDP9UoeojPfo3VU1XWthVFCNbE2KEaDGgHEE7bHP459o/EKJZVSbP72eq500/K5yR8XurEQPjHEWS/dgCJLge7+/AhrI=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, tony.luck@intel.com
Subject: [PATCH 07/34] __initdata cleanup - ia64
Date: Fri, 9 Feb 2007 17:17:32 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091717.32267.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/acpi.c linux-2.6.20-rc6-mm3/arch/ia64/kernel/acpi.c
--- linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/acpi.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ia64/kernel/acpi.c	2007-01-31 22:19:30.000000000 +0200
@@ -158,9 +158,9 @@ char *__acpi_map_table(unsigned long phy
                             Boot-time Table Parsing
    -------------------------------------------------------------------------- */
 
-static int total_cpus __initdata;
-static int available_cpus __initdata;
-struct acpi_table_madt *acpi_madt __initdata;
+static int total_cpus __initdata = 0;
+static int available_cpus __initdata = 0;
+struct acpi_table_madt *acpi_madt __initdata = NULL;
 static u8 has_8259;
 
 static int __init
@@ -229,7 +229,7 @@ acpi_parse_iosapic(struct acpi_subtable_
 	return iosapic_init(iosapic->address, iosapic->global_irq_base);
 }
 
-static unsigned int __initdata acpi_madt_rev;
+static unsigned int __initdata acpi_madt_rev = 0;
 
 static int __init
 acpi_parse_plat_int_src(struct acpi_subtable_header * header,
@@ -401,11 +401,11 @@ static int __init acpi_parse_madt(struct
 
 #define PXM_FLAG_LEN ((MAX_PXM_DOMAINS + 1)/32)
 
-static int __initdata srat_num_cpus;	/* number of cpus */
-static u32 __devinitdata pxm_flag[PXM_FLAG_LEN];
+static int __initdata srat_num_cpus = 0;	/* number of cpus */
+static u32 __devinitdata pxm_flag[PXM_FLAG_LEN] = {0};
 #define pxm_bit_set(bit)	(set_bit(bit,(void *)pxm_flag))
 #define pxm_bit_test(bit)	(test_bit(bit,(void *)pxm_flag))
-static struct acpi_table_slit __initdata *slit_table;
+static struct acpi_table_slit __initdata *slit_table = NULL;
 
 static int get_processor_proximity_domain(struct acpi_srat_cpu_affinity *pa)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/machvec.c linux-2.6.20-rc6-mm3/arch/ia64/kernel/machvec.c
--- linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/machvec.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ia64/kernel/machvec.c	2007-01-31 22:19:30.000000000 +0200
@@ -13,7 +13,7 @@
 struct ia64_machine_vector ia64_mv;
 EXPORT_SYMBOL(ia64_mv);
 
-static __initdata const char *mvec_name;
+static __initdata const char *mvec_name = NULL;
 static __init int setup_mvec(char *s)
 {
 	mvec_name = s;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/mca.c linux-2.6.20-rc6-mm3/arch/ia64/kernel/mca.c
--- linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/mca.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ia64/kernel/mca.c	2007-01-31 22:19:30.000000000 +0200
@@ -138,7 +138,7 @@ static int cpe_poll_enabled = 1;
 
 extern void salinfo_log_wakeup(int type, u8 *buffer, u64 size, int irqsafe);
 
-static int mca_init __initdata;
+static int mca_init __initdata = 0;
 
 /*
  * limited & delayed printing support for MCA/INIT handler
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/setup.c linux-2.6.20-rc6-mm3/arch/ia64/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ia64/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -131,8 +131,8 @@ EXPORT_SYMBOL(ia64_max_iommu_merge_mask)
 /*
  * We use a special marker for the end of memory and it uses the extra (+1) slot
  */
-struct rsvd_region rsvd_region[IA64_MAX_RSVD_REGIONS + 1] __initdata;
-int num_rsvd_regions __initdata;
+struct rsvd_region rsvd_region[IA64_MAX_RSVD_REGIONS + 1] __initdata = {{0}};
+int num_rsvd_regions __initdata = 0;
 
 
 /*
@@ -432,7 +432,7 @@ check_for_logical_procs (void)
 }
 #endif
 
-static __initdata int nomca;
+static __initdata int nomca = 0;
 static __init int setup_nomca(char *s)
 {
 	nomca = 1;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/smpboot.c linux-2.6.20-rc6-mm3/arch/ia64/kernel/smpboot.c
--- linux-2.6.20-rc6-mm3.org/arch/ia64/kernel/smpboot.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ia64/kernel/smpboot.c	2007-01-31 22:19:30.000000000 +0200
@@ -148,11 +148,11 @@ EXPORT_SYMBOL(ia64_cpu_to_sapicid);
 
 static volatile cpumask_t cpu_callin_map;
 
-struct smp_boot_data smp_boot_data __initdata;
+struct smp_boot_data smp_boot_data __initdata = {0};
 
 unsigned long ap_wakeup_vector = -1; /* External Int use to wakeup APs */
 
-char __initdata no_int_routing;
+char __initdata no_int_routing = 0;
 
 unsigned char smp_int_redirect; /* are INT and IPI redirectable by the chipset? */
 
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ia64/mm/discontig.c linux-2.6.20-rc6-mm3/arch/ia64/mm/discontig.c
--- linux-2.6.20-rc6-mm3.org/arch/ia64/mm/discontig.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ia64/mm/discontig.c	2007-01-31 22:19:30.000000000 +0200
@@ -44,8 +44,8 @@ struct early_node_data {
 	unsigned long max_pfn;
 };
 
-static struct early_node_data mem_data[MAX_NUMNODES] __initdata;
-static nodemask_t memory_less_mask __initdata;
+static struct early_node_data mem_data[MAX_NUMNODES] __initdata = {{0}};
+static nodemask_t memory_less_mask __initdata = {{0}};
 
 static pg_data_t *pgdat_list[MAX_NUMNODES];
 
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ia64/mm/init.c linux-2.6.20-rc6-mm3/arch/ia64/mm/init.c
--- linux-2.6.20-rc6-mm3.org/arch/ia64/mm/init.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ia64/mm/init.c	2007-01-31 22:19:30.000000000 +0200
@@ -656,7 +656,7 @@ count_reserved_pages (u64 start, u64 end
  * purposes.
  */
 
-static int nolwsys __initdata;
+static int nolwsys __initdata = 0;
 
 static int __init
 nolwsys_setup (char *s)
diff -urNp linux-2.6.20-rc6-mm3.org/arch/ia64/sn/kernel/setup.c linux-2.6.20-rc6-mm3/arch/ia64/sn/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/ia64/sn/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/ia64/sn/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -194,7 +194,7 @@ void __init early_sn_setup(void)
 }
 
 extern int platform_intr_list[];
-static int __initdata shub_1_1_found;
+static int __initdata shub_1_1_found = 0;
 
 /*
  * sn_check_for_wars
