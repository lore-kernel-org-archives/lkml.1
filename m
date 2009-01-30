Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZA3KT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZA3KT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZA3KRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54383 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbZA3KRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:52 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove store_NMI_vector in genapic
Date: Fri, 30 Jan 2009 11:17:11 +0100
Message-Id: <1233310639-27916-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-5-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Only used by NUMAQ

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/genapic.h      |    1 -
 arch/x86/kernel/bigsmp_32.c         |    1 -
 arch/x86/kernel/es7000_32.c         |    1 -
 arch/x86/kernel/genapic_flat_64.c   |    2 --
 arch/x86/kernel/genx2apic_cluster.c |    1 -
 arch/x86/kernel/genx2apic_phys.c    |    1 -
 arch/x86/kernel/genx2apic_uv_x.c    |    1 -
 arch/x86/kernel/numaq_32.c          |   11 -----------
 arch/x86/kernel/probe_32.c          |    1 -
 arch/x86/kernel/smpboot.c           |    4 ----
 arch/x86/kernel/summit_32.c         |    1 -
 11 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 273b994..f57d4d4 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -81,7 +81,6 @@ struct genapic {
 
 	void (*wait_for_init_deassert)(atomic_t *deassert);
 	void (*smp_callin_clear_local_apic)(void);
-	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
 	void (*inquire_remote_apic)(int apicid);
 };
 
diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index b74f070..f728f9d 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -259,6 +259,5 @@ struct genapic apic_bigsmp = {
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 };
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 078364c..c0789b7 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -797,6 +797,5 @@ struct genapic apic_es7000 = {
 
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 };
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 19bffb3..c1bcf11 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -227,7 +227,6 @@ struct genapic apic_flat =  {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
 
@@ -372,6 +371,5 @@ struct genapic apic_physflat =  {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 7c87156..49ae07e 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -232,6 +232,5 @@ struct genapic apic_x2apic_cluster = {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 5cbae8a..2599aaf 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -218,6 +218,5 @@ struct genapic apic_x2apic_phys = {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 6adb5e6..1d4d503 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -291,7 +291,6 @@ struct genapic apic_x2apic_uv_x = {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= NULL,
 };
 
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 295c82e..be1fdd7 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -390,16 +390,6 @@ static inline void numaq_smp_callin_clear_local_apic(void)
 	clear_local_APIC();
 }
 
-static inline void
-numaq_store_NMI_vector(unsigned short *high, unsigned short *low)
-{
-	printk("Storing NMI vector\n");
-	*high =
-	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_HIGH));
-	*low =
-	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW));
-}
-
 static inline const cpumask_t *numaq_target_cpus(void)
 {
 	return &CPU_MASK_ALL;
@@ -605,6 +595,5 @@ struct genapic apic_numaq = {
 	.wait_for_init_deassert		= NULL,
 
 	.smp_callin_clear_local_apic	= numaq_smp_callin_clear_local_apic,
-	.store_NMI_vector		= numaq_store_NMI_vector,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index b5db26f..7445f66 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -125,7 +125,6 @@ struct genapic apic_default = {
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 };
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 709b65d..401b649 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -717,7 +717,6 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu)
 	unsigned long boot_error = 0;
 	int timeout;
 	unsigned long start_ip;
-	unsigned short nmi_high = 0, nmi_low = 0;
 	struct create_idle c_idle = {
 		.cpu = cpu,
 		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
@@ -786,9 +785,6 @@ do_rest:
 
 		pr_debug("Setting warm reset code and vector.\n");
 
-		if (apic->store_NMI_vector)
-			apic->store_NMI_vector(&nmi_high, &nmi_low);
-
 		smpboot_setup_warm_reset_vector(start_ip);
 		/*
 		 * Be paranoid about clearing APIC errors.
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index a04bc99..17197fc 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -595,6 +595,5 @@ struct genapic apic_summit = {
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
 	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 };
-- 
1.5.6.5

