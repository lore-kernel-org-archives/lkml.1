Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZBXRib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZBXRib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbZBXRiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:38:16 -0500
Received: from mx1.suse.de ([195.135.220.2]:46822 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288AbZBXRiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:38:15 -0500
From: jirislaby@gmail.com
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] x86_32: summit_32, de-inline functions
Date: Tue, 24 Feb 2009 18:38:15 +0100
Message-Id: <1235497095-4896-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1235497095-4896-1-git-send-email-jirislaby@gmail.com>
References: <1235497095-4896-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

The ones which go only into struct genapic are de-inlined
by compiler anyway, so remove the inline specifier from them.

Afterwards, remove summit_setup_portio_remap completely as it
is unused.

Remove inline also from summit_cpu_mask_to_apicid, since it's
not worth it (it is used in struct genapic too).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/summit_32.c |   47 ++++++++++++++++++------------------------
 1 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index b10133a..1d3fe85 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -50,7 +50,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 
-static inline unsigned summit_get_apic_id(unsigned long x)
+static unsigned summit_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0xFF;
 }
@@ -60,7 +60,7 @@ static inline void summit_send_IPI_mask(const cpumask_t *mask, int vector)
 	default_send_IPI_mask_sequence_logical(mask, vector);
 }
 
-static inline void summit_send_IPI_allbutself(int vector)
+static void summit_send_IPI_allbutself(int vector)
 {
 	cpumask_t mask = cpu_online_map;
 	cpu_clear(smp_processor_id(), mask);
@@ -69,7 +69,7 @@ static inline void summit_send_IPI_allbutself(int vector)
 		summit_send_IPI_mask(&mask, vector);
 }
 
-static inline void summit_send_IPI_all(int vector)
+static void summit_send_IPI_all(int vector)
 {
 	summit_send_IPI_mask(&cpu_online_map, vector);
 }
@@ -84,8 +84,8 @@ extern void setup_summit(void);
 #define setup_summit()	{}
 #endif
 
-static inline int
-summit_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
+static int summit_mps_oem_check(struct mpc_table *mpc, char *oem,
+		char *productid)
 {
 	if (!strncmp(oem, "IBM ENSW", 8) &&
 			(!strncmp(productid, "VIGIL SMP", 9)
@@ -100,7 +100,7 @@ summit_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 }
 
 /* Hook from generic ACPI tables.c */
-static inline int summit_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int summit_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strncmp(oem_id, "IBM", 3) &&
 	    (!strncmp(oem_table_id, "SERVIGIL", 8)
@@ -188,7 +188,7 @@ static inline int is_WPEG(struct rio_detail *rio){
 
 #define SUMMIT_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
-static inline const cpumask_t *summit_target_cpus(void)
+static const cpumask_t *summit_target_cpus(void)
 {
 	/* CPU_MASK_ALL (0xff) has undefined behaviour with
 	 * dest_LowestPrio mode logical clustered apic interrupt routing
@@ -197,14 +197,13 @@ static inline const cpumask_t *summit_target_cpus(void)
 	return &cpumask_of_cpu(0);
 }
 
-static inline unsigned long
-summit_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long summit_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return 0;
 }
 
 /* we don't use the phys_cpu_present_map to indicate apicid presence */
-static inline unsigned long summit_check_apicid_present(int bit)
+static unsigned long summit_check_apicid_present(int bit)
 {
 	return 1;
 }
@@ -213,7 +212,7 @@ static inline unsigned long summit_check_apicid_present(int bit)
 
 extern u8 cpu_2_logical_apicid[];
 
-static inline void summit_init_apic_ldr(void)
+static void summit_init_apic_ldr(void)
 {
 	unsigned long val, id;
 	int count = 0;
@@ -240,18 +239,18 @@ static inline void summit_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static inline int summit_apic_id_registered(void)
+static int summit_apic_id_registered(void)
 {
 	return 1;
 }
 
-static inline void summit_setup_apic_routing(void)
+static void summit_setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
 						nr_ioapics);
 }
 
-static inline int summit_apicid_to_node(int logical_apicid)
+static int summit_apicid_to_node(int logical_apicid)
 {
 #ifdef CONFIG_SMP
 	return apicid_2_node[hard_smp_processor_id()];
@@ -272,7 +271,7 @@ static inline int summit_cpu_to_logical_apicid(int cpu)
 #endif
 }
 
-static inline int summit_cpu_present_to_apicid(int mps_cpu)
+static int summit_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
 		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
@@ -280,28 +279,23 @@ static inline int summit_cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
-static inline physid_mask_t
-summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
+static physid_mask_t summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
 	return physids_promote(0x0F);
 }
 
-static inline physid_mask_t summit_apicid_to_cpu_present(int apicid)
+static physid_mask_t summit_apicid_to_cpu_present(int apicid)
 {
 	return physid_mask_of_physid(0);
 }
 
-static inline void summit_setup_portio_remap(void)
-{
-}
-
-static inline int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
+static int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
 	return 1;
 }
 
-static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	int cpus_found = 0;
 	int num_bits_set;
@@ -335,8 +329,7 @@ static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
 	return apicid;
 }
 
-static inline unsigned int
-summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
+static unsigned int summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      const struct cpumask *andmask)
 {
 	int apicid = summit_cpu_to_logical_apicid(0);
@@ -361,7 +354,7 @@ summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
  *
  * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
  */
-static inline int summit_phys_pkg_id(int cpuid_apic, int index_msb)
+static int summit_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
 }
-- 
1.6.1.3

