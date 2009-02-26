Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbZBZVqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbZBZVqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZBZVqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:46:08 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:42448 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZBZVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:46:06 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/4] x86_32: apic/bigsmp_32, de-inline functions
Date: Thu, 26 Feb 2009 22:45:29 +0100
Message-Id: <1235684732-5991-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20090225111002.GA15453@elte.hu>
References: <20090225111002.GA15453@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ones which go only into struct apic are de-inlined
by compiler anyway, so remove the inline specifier from them.

Afterwards, remove bigsmp_setup_portio_remap completely as it
is unused.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/bigsmp_32.c |   40 ++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 0b10933..d14e635 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -16,17 +16,17 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 
-static inline unsigned bigsmp_get_apic_id(unsigned long x)
+static unsigned bigsmp_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0xFF;
 }
 
-static inline int bigsmp_apic_id_registered(void)
+static int bigsmp_apic_id_registered(void)
 {
 	return 1;
 }
 
-static inline const cpumask_t *bigsmp_target_cpus(void)
+static const cpumask_t *bigsmp_target_cpus(void)
 {
 #ifdef CONFIG_SMP
 	return &cpu_online_map;
@@ -35,13 +35,12 @@ static inline const cpumask_t *bigsmp_target_cpus(void)
 #endif
 }
 
-static inline unsigned long
-bigsmp_check_apicid_used(physid_mask_t bitmap, int apicid)
+static unsigned long bigsmp_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return 0;
 }
 
-static inline unsigned long bigsmp_check_apicid_present(int bit)
+static unsigned long bigsmp_check_apicid_present(int bit)
 {
 	return 1;
 }
@@ -64,7 +63,7 @@ static inline unsigned long calculate_ldr(int cpu)
  * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
  * document number 292116).  So here it goes...
  */
-static inline void bigsmp_init_apic_ldr(void)
+static void bigsmp_init_apic_ldr(void)
 {
 	unsigned long val;
 	int cpu = smp_processor_id();
@@ -74,19 +73,19 @@ static inline void bigsmp_init_apic_ldr(void)
 	apic_write(APIC_LDR, val);
 }
 
-static inline void bigsmp_setup_apic_routing(void)
+static void bigsmp_setup_apic_routing(void)
 {
 	printk(KERN_INFO
 		"Enabling APIC mode:  Physflat.  Using %d I/O APICs\n",
 		nr_ioapics);
 }
 
-static inline int bigsmp_apicid_to_node(int logical_apicid)
+static int bigsmp_apicid_to_node(int logical_apicid)
 {
 	return apicid_2_node[hard_smp_processor_id()];
 }
 
-static inline int bigsmp_cpu_present_to_apicid(int mps_cpu)
+static int bigsmp_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
 		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
@@ -94,7 +93,7 @@ static inline int bigsmp_cpu_present_to_apicid(int mps_cpu)
 	return BAD_APICID;
 }
 
-static inline physid_mask_t bigsmp_apicid_to_cpu_present(int phys_apicid)
+static physid_mask_t bigsmp_apicid_to_cpu_present(int phys_apicid)
 {
 	return physid_mask_of_physid(phys_apicid);
 }
@@ -107,29 +106,24 @@ static inline int bigsmp_cpu_to_logical_apicid(int cpu)
 	return cpu_physical_id(cpu);
 }
 
-static inline physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
+static physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
 {
 	/* For clustered we don't have a good way to do this yet - hack */
 	return physids_promote(0xFFL);
 }
 
-static inline void bigsmp_setup_portio_remap(void)
-{
-}
-
-static inline int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
+static int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
 	return 1;
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int bigsmp_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int bigsmp_cpu_mask_to_apicid(const cpumask_t *cpumask)
 {
 	return bigsmp_cpu_to_logical_apicid(first_cpu(*cpumask));
 }
 
-static inline unsigned int
-bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			      const struct cpumask *andmask)
 {
 	int cpu;
@@ -148,7 +142,7 @@ bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return BAD_APICID;
 }
 
-static inline int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
+static int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
 {
 	return cpuid_apic >> index_msb;
 }
@@ -158,12 +152,12 @@ static inline void bigsmp_send_IPI_mask(const struct cpumask *mask, int vector)
 	default_send_IPI_mask_sequence_phys(mask, vector);
 }
 
-static inline void bigsmp_send_IPI_allbutself(int vector)
+static void bigsmp_send_IPI_allbutself(int vector)
 {
 	default_send_IPI_mask_allbutself_phys(cpu_online_mask, vector);
 }
 
-static inline void bigsmp_send_IPI_all(int vector)
+static void bigsmp_send_IPI_all(int vector)
 {
 	bigsmp_send_IPI_mask(cpu_online_mask, vector);
 }
-- 
1.6.1.3

