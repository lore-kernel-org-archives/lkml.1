Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbZA1X7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbZA1X7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbZA1Xot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:52905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104AbZA1Xop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:45 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 035/114] x86, apic: clean up check_apicid*() callbacks
Date: Wed, 28 Jan 2009 23:41:41 +0000
Message-Id: <1233186180-29883-36-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up these methods - to make it clearer which function is
used in which case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/bigsmp/apic.h            |    9 +++++----
 arch/x86/include/asm/es7000/apic.h            |    5 +++--
 arch/x86/include/asm/mach-default/mach_apic.h |    4 ++--
 arch/x86/include/asm/mach-generic/mach_apic.h |    2 --
 arch/x86/include/asm/numaq/apic.h             |    5 +++--
 arch/x86/include/asm/summit/apic.h            |    5 +++--
 arch/x86/kernel/io_apic.c                     |    6 +++---
 arch/x86/mach-generic/bigsmp.c                |    4 ++--
 arch/x86/mach-generic/default.c               |    4 ++--
 arch/x86/mach-generic/es7000.c                |    4 ++--
 arch/x86/mach-generic/numaq.c                 |    4 ++--
 arch/x86/mach-generic/summit.c                |    4 ++--
 12 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index 7e6e33a..bd52d4d 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -20,14 +20,15 @@ static inline const cpumask_t *bigsmp_target_cpus(void)
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define NO_BALANCE_IRQ		(0)
 
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+static inline unsigned long
+bigsmp_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
-	return (0);
+	return 0;
 }
 
-static inline unsigned long check_apicid_present(int bit)
+static inline unsigned long bigsmp_check_apicid_present(int bit)
 {
-	return (1);
+	return 1;
 }
 
 static inline unsigned long calculate_ldr(int cpu)
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index 0d770fc..cd888da 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -28,11 +28,12 @@ static inline const cpumask_t *es7000_target_cpus(void)
 #define APIC_DFR_VALUE		(APIC_DFR_FLAT)
 #define NO_BALANCE_IRQ		(0)
 
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+static inline unsigned long
+es7000_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return 0;
 }
-static inline unsigned long check_apicid_present(int bit)
+static inline unsigned long es7000_check_apicid_present(int bit)
 {
 	return physid_isset(bit, phys_cpu_present_map);
 }
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index 5f8d17f..064bc11 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -105,12 +105,12 @@ static inline void vector_allocation_domain(int cpu, struct cpumask *retmask)
 }
 #endif
 
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+static inline unsigned long default_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return physid_isset(apicid, bitmap);
 }
 
-static inline unsigned long check_apicid_present(int bit)
+static inline unsigned long default_check_apicid_present(int bit)
 {
 	return physid_isset(bit, phys_cpu_present_map);
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
index 00d5fe6..e035f88 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -13,9 +13,7 @@
 #define cpu_present_to_apicid (apic->cpu_present_to_apicid)
 #define apicid_to_cpu_present (apic->apicid_to_cpu_present)
 #define setup_portio_remap (apic->setup_portio_remap)
-#define check_apicid_present (apic->check_apicid_present)
 #define check_phys_apicid_present (apic->check_phys_apicid_present)
-#define check_apicid_used (apic->check_apicid_used)
 #define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
 #define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
 #define vector_allocation_domain (apic->vector_allocation_domain)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index 8ecb3b4..571fdae 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -14,11 +14,12 @@ static inline const cpumask_t *numaq_target_cpus(void)
 
 #define NO_BALANCE_IRQ (1)
 
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+static inline unsigned long
+numaq_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return physid_isset(apicid, bitmap);
 }
-static inline unsigned long check_apicid_present(int bit)
+static inline unsigned long numaq_check_apicid_present(int bit)
 {
 	return physid_isset(bit, phys_cpu_present_map);
 }
diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
index 84679e6..482038b 100644
--- a/arch/x86/include/asm/summit/apic.h
+++ b/arch/x86/include/asm/summit/apic.h
@@ -23,13 +23,14 @@ static inline const cpumask_t *summit_target_cpus(void)
 	return &cpumask_of_cpu(0);
 }
 
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+static inline unsigned long
+summit_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return 0;
 }
 
 /* we don't use the phys_cpu_present_map to indicate apicid presence */
-static inline unsigned long check_apicid_present(int bit)
+static inline unsigned long summit_check_apicid_present(int bit)
 {
 	return 1;
 }
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 7f8b32b..733ecf1 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2135,7 +2135,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * system must have a unique ID or we get lots of nice
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
-		if (check_apicid_used(phys_id_present_map,
+		if (apic->check_apicid_used(phys_id_present_map,
 					mp_ioapics[apic_id].apicid)) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
 				apic_id, mp_ioapics[apic_id].apicid);
@@ -3878,10 +3878,10 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 	 * Every APIC in a system must have a unique ID or we get lots of nice
 	 * 'stuck on smp_invalidate_needed IPI wait' messages.
 	 */
-	if (check_apicid_used(apic_id_map, apic_id)) {
+	if (apic->check_apicid_used(apic_id_map, apic_id)) {
 
 		for (i = 0; i < get_physical_broadcast(); i++) {
-			if (!check_apicid_used(apic_id_map, i))
+			if (!apic->check_apicid_used(apic_id_map, i))
 				break;
 		}
 
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 7c52840..aa8443f 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -71,8 +71,8 @@ struct genapic apic_bigsmp = {
 	.target_cpus			= bigsmp_target_cpus,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
-	.check_apicid_used		= check_apicid_used,
-	.check_apicid_present		= check_apicid_present,
+	.check_apicid_used		= bigsmp_check_apicid_used,
+	.check_apicid_present		= bigsmp_check_apicid_present,
 
 	.no_balance_irq			= NO_BALANCE_IRQ,
 	.no_ioapic_check		= 0,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 53fa1ad..47f6b5b 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -38,8 +38,8 @@ struct genapic apic_default = {
 	.target_cpus			= default_target_cpus,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= check_apicid_used,
-	.check_apicid_present		= check_apicid_present,
+	.check_apicid_used		= default_check_apicid_used,
+	.check_apicid_present		= default_check_apicid_present,
 
 	.no_balance_irq			= NO_BALANCE_IRQ,
 	.no_ioapic_check		= 0,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 50fed02..5633f32 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -114,8 +114,8 @@ struct genapic apic_es7000 = {
 	.target_cpus			= es7000_target_cpus,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
-	.check_apicid_used		= check_apicid_used,
-	.check_apicid_present		= check_apicid_present,
+	.check_apicid_used		= es7000_check_apicid_used,
+	.check_apicid_present		= es7000_check_apicid_present,
 
 	.no_balance_irq			= NO_BALANCE_IRQ,
 	.no_ioapic_check		= 0,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 1fb1b1a..d85206d 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -58,8 +58,8 @@ struct genapic apic_numaq = {
 	.target_cpus			= numaq_target_cpus,
 	.disable_esr			= 1,
 	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= check_apicid_used,
-	.check_apicid_present		= check_apicid_present,
+	.check_apicid_used		= numaq_check_apicid_used,
+	.check_apicid_present		= numaq_check_apicid_present,
 
 	.no_balance_irq			= NO_BALANCE_IRQ,
 	.no_ioapic_check		= 0,
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 5c27d4d..f54cf73 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -51,8 +51,8 @@ struct genapic apic_summit = {
 	.target_cpus			= summit_target_cpus,
 	.disable_esr			= 1,
 	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= check_apicid_used,
-	.check_apicid_present		= check_apicid_present,
+	.check_apicid_used		= summit_check_apicid_used,
+	.check_apicid_present		= summit_check_apicid_present,
 
 	.no_balance_irq			= NO_BALANCE_IRQ,
 	.no_ioapic_check		= 0,
-- 
1.6.0.2

