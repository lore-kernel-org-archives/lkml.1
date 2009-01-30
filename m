Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZA3KUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZA3KUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZA3KR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54388 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbZA3KRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:52 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove setup_portio_remap
Date: Fri, 30 Jan 2009 11:17:14 +0100
Message-Id: <1233310639-27916-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-8-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
 <1233310639-27916-6-git-send-email-andi@firstfloor.org>
 <1233310639-27916-7-git-send-email-andi@firstfloor.org>
 <1233310639-27916-8-git-send-email-andi@firstfloor.org>
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
 arch/x86/kernel/numaq_32.c          |   14 --------------
 arch/x86/kernel/probe_32.c          |    1 -
 arch/x86/kernel/smpboot.c           |    3 ---
 arch/x86/kernel/summit_32.c         |    1 -
 11 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 6197803..988e1bc 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -44,7 +44,6 @@ struct genapic {
 	int (*cpu_to_logical_apicid)(int cpu);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
-	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int boot_cpu_physical_apicid);
 	void (*enable_apic_mode)(void);
 	int (*phys_pkg_id)(int cpuid_apic, int index_msb);
diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index 9c1e464..e3d31ae 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -232,7 +232,6 @@ struct genapic apic_bigsmp = {
 	.cpu_to_logical_apicid		= bigsmp_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= bigsmp_phys_pkg_id,
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 5e1c4aa..b50f0f5 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -768,7 +768,6 @@ struct genapic apic_es7000 = {
 	.cpu_to_logical_apicid		= es7000_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= es7000_check_phys_apicid_present,
 	.enable_apic_mode		= es7000_enable_apic_mode,
 	.phys_pkg_id			= es7000_phys_pkg_id,
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 6a00ea8..d85b7fc 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -202,7 +202,6 @@ struct genapic apic_flat =  {
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
@@ -344,7 +343,6 @@ struct genapic apic_physflat =  {
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 7e01834..9fc9582 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -207,7 +207,6 @@ struct genapic apic_x2apic_cluster = {
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_cluster_phys_pkg_id,
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index b92d60b..04fb617 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -193,7 +193,6 @@ struct genapic apic_x2apic_phys = {
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 6394b0e..ac0e23b 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -266,7 +266,6 @@ struct genapic apic_x2apic_uv_x = {
 	.cpu_to_logical_apicid		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= uv_phys_pkg_id,
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 73ce5ef..9c9b3c7 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -510,19 +510,6 @@ static void numaq_vector_allocation_domain(int cpu, cpumask_t *retmask)
 	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
 }
 
-static void numaq_setup_portio_remap(void)
-{
-	int num_quads = num_online_nodes();
-
-	if (num_quads <= 1)
-       		return;
-
-	printk("Remapping cross-quad port I/O for %d quads\n", num_quads);
-	xquad_portio = ioremap(XQUAD_PORTIO_BASE, num_quads*XQUAD_PORTIO_QUAD);
-	printk("xquad_portio vaddr 0x%08lx, len %08lx\n",
-		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
-}
-
 struct genapic apic_numaq = {
 
 	.name				= "NUMAQ",
@@ -549,7 +536,6 @@ struct genapic apic_numaq = {
 	.cpu_to_logical_apicid		= numaq_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
-	.setup_portio_remap		= numaq_setup_portio_remap,
 	.check_phys_apicid_present	= numaq_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= numaq_phys_pkg_id,
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index c296fb4..905295e 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -98,7 +98,6 @@ struct genapic apic_default = {
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= default_phys_pkg_id,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a04b219..f479bba 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1120,9 +1120,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	map_cpu_to_logical_apicid();
 
-	if (apic->setup_portio_remap)
-		apic->setup_portio_remap();
-
 	smpboot_setup_io_apic();
 	/*
 	 * Set up local APIC timer on boot CPU.
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index dbb7206..f0dde1c 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -568,7 +568,6 @@ struct genapic apic_summit = {
 	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= summit_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= summit_phys_pkg_id,
-- 
1.5.6.5

