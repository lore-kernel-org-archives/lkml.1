Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZA3KUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZA3KUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZA3KR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54384 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbZA3KRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:52 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove smp_callin_clear_local_apic hook
Date: Fri, 30 Jan 2009 11:17:12 +0100
Message-Id: <1233310639-27916-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-6-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
 <1233310639-27916-6-git-send-email-andi@firstfloor.org>
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
 arch/x86/kernel/numaq_32.c          |   10 ----------
 arch/x86/kernel/probe_32.c          |    1 -
 arch/x86/kernel/smpboot.c           |    2 --
 arch/x86/kernel/summit_32.c         |    1 -
 11 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index f57d4d4..07bab93 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -80,7 +80,6 @@ struct genapic {
 	int trampoline_phys_high;
 
 	void (*wait_for_init_deassert)(atomic_t *deassert);
-	void (*smp_callin_clear_local_apic)(void);
 	void (*inquire_remote_apic)(int apicid);
 };
 
diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index f728f9d..85d72ee 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -258,6 +258,5 @@ struct genapic apic_bigsmp = {
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 };
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index c0789b7..770205b 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -796,6 +796,5 @@ struct genapic apic_es7000 = {
 	.wait_for_init_deassert		= es7000_wait_for_init_deassert,
 
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 };
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index c1bcf11..b42e724 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -226,7 +226,6 @@ struct genapic apic_flat =  {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 };
 
@@ -370,6 +369,5 @@ struct genapic apic_physflat =  {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 49ae07e..6cccd3a 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -231,6 +231,5 @@ struct genapic apic_x2apic_cluster = {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 2599aaf..17ff29a 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -217,6 +217,5 @@ struct genapic apic_x2apic_phys = {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 1d4d503..d46531d 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -290,7 +290,6 @@ struct genapic apic_x2apic_uv_x = {
 	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 };
 
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index be1fdd7..07954d1 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -381,15 +381,6 @@ extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
 #define NUMAQ_TRAMPOLINE_PHYS_LOW (0x8)
 #define NUMAQ_TRAMPOLINE_PHYS_HIGH (0xa)
 
-/*
- * Because we use NMIs rather than the INIT-STARTUP sequence to
- * bootstrap the CPUs, the APIC may be in a weird state. Kick it:
- */
-static inline void numaq_smp_callin_clear_local_apic(void)
-{
-	clear_local_APIC();
-}
-
 static inline const cpumask_t *numaq_target_cpus(void)
 {
 	return &CPU_MASK_ALL;
@@ -594,6 +585,5 @@ struct genapic apic_numaq = {
 	/* We don't do anything here because we use NMI's to boot instead */
 	.wait_for_init_deassert		= NULL,
 
-	.smp_callin_clear_local_apic	= numaq_smp_callin_clear_local_apic,
 	.inquire_remote_apic		= NULL,
 };
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index 7445f66..e96b6b2 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -124,7 +124,6 @@ struct genapic apic_default = {
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 };
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 401b649..a04b219 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -243,8 +243,6 @@ static void __cpuinit smp_callin(void)
 	 */
 
 	pr_debug("CALLIN, before setup_local_APIC().\n");
-	if (apic->smp_callin_clear_local_apic)
-		apic->smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index 17197fc..7b7eeb6 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -594,6 +594,5 @@ struct genapic apic_summit = {
 
 	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 };
-- 
1.5.6.5

