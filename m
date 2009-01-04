Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZADQgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZADQgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbZADQfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:35:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:35907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458AbZADQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:35:44 -0500
Subject: [PATCH -tip 4/7] x86: rename all fields of mpc_cpu mpc_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 21:58:25 +0530
Message-Id: <1231086505.5517.25.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, solve 80 columns wrap problems

It would be cleaner to rename all the mpc->mpc_X fields to
mpc->X - that alone would give 4 characters per usage site.
(we already know that it's an 'mpc' entity -
no need to duplicate that in the field too)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |   14 +++++++-------
 arch/x86/kernel/mpparse.c         |   28 ++++++++++++++--------------
 arch/x86/kernel/numaq_32.c        |    9 ++++-----
 arch/x86/kernel/visws_quirks.c    |   28 +++++++++++++---------------
 4 files changed, 38 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index e24e1bc..78057aa 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -71,13 +71,13 @@ struct mpc_table {
 #define CPU_FAMILY_MASK		0x0F00
 
 struct mpc_cpu {
-	unsigned char mpc_type;
-	unsigned char mpc_apicid;	/* Local APIC number */
-	unsigned char mpc_apicver;	/* Its versions */
-	unsigned char mpc_cpuflag;
-	unsigned int mpc_cpufeature;
-	unsigned int mpc_featureflag;	/* CPUID feature value */
-	unsigned int mpc_reserved[2];
+	unsigned char type;
+	unsigned char apicid;		/* Local APIC number */
+	unsigned char apicver;		/* Its versions */
+	unsigned char cpuflag;
+	unsigned int cpufeature;
+	unsigned int featureflag;	/* CPUID feature value */
+	unsigned int reserved[2];
 };
 
 struct mpc_bus {
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a804f10..a8b9ba9 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -54,7 +54,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	int apicid;
 	char *bootup_cpu = "";
 
-	if (!(m->mpc_cpuflag & CPU_ENABLED)) {
+	if (!(m->cpuflag & CPU_ENABLED)) {
 		disabled_cpus++;
 		return;
 	}
@@ -62,15 +62,15 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	if (x86_quirks->mpc_apic_id)
 		apicid = x86_quirks->mpc_apic_id(m);
 	else
-		apicid = m->mpc_apicid;
+		apicid = m->apicid;
 
-	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR) {
+	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_physical_apicid = m->mpc_apicid;
+		boot_cpu_physical_apicid = m->apicid;
 	}
 
-	printk(KERN_INFO "Processor #%d%s\n", m->mpc_apicid, bootup_cpu);
-	generic_processor_info(apicid, m->mpc_apicver);
+	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
+	generic_processor_info(apicid, m->apicver);
 }
 
 #ifdef CONFIG_X86_IO_APIC
@@ -542,17 +542,17 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 	/*
 	 * 2 CPUs, numbered 0 & 1.
 	 */
-	processor.mpc_type = MP_PROCESSOR;
+	processor.type = MP_PROCESSOR;
 	/* Either an integrated APIC or a discrete 82489DX. */
-	processor.mpc_apicver = mpc_default_type > 4 ? 0x10 : 0x01;
-	processor.mpc_cpuflag = CPU_ENABLED;
-	processor.mpc_cpufeature = (boot_cpu_data.x86 << 8) |
+	processor.apicver = mpc_default_type > 4 ? 0x10 : 0x01;
+	processor.cpuflag = CPU_ENABLED;
+	processor.cpufeature = (boot_cpu_data.x86 << 8) |
 	    (boot_cpu_data.x86_model << 4) | boot_cpu_data.x86_mask;
-	processor.mpc_featureflag = boot_cpu_data.x86_capability[0];
-	processor.mpc_reserved[0] = 0;
-	processor.mpc_reserved[1] = 0;
+	processor.featureflag = boot_cpu_data.x86_capability[0];
+	processor.reserved[0] = 0;
+	processor.reserved[1] = 0;
 	for (i = 0; i < 2; i++) {
-		processor.mpc_apicid = i;
+		processor.apicid = i;
 		MP_processor_info(&processor);
 	}
 
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index aa1e5a0..a53831c 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -120,13 +120,12 @@ static inline int generate_logical_apicid(int quad, int phys_apicid)
 static int mpc_apic_id(struct mpc_cpu *m)
 {
 	int quad = translation_table[mpc_record]->trans_quad;
-	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
+	int logical_apicid = generate_logical_apicid(quad, m->apicid);
 
 	printk(KERN_DEBUG "Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
-	       m->mpc_apicid,
-	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
-	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
-	       m->mpc_apicver, quad, logical_apicid);
+	       m->apicid, (m->cpufeature & CPU_FAMILY_MASK) >> 8,
+	       (m->cpufeature & CPU_MODEL_MASK) >> 4,
+	       m->apicver, quad, logical_apicid);
 	return logical_apicid;
 }
 
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index ca12afa..d801d06 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -181,28 +181,26 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	int ver, logical_apicid;
 	physid_mask_t apic_cpus;
 
-	if (!(m->mpc_cpuflag & CPU_ENABLED))
+	if (!(m->cpuflag & CPU_ENABLED))
 		return;
 
-	logical_apicid = m->mpc_apicid;
+	logical_apicid = m->apicid;
 	printk(KERN_INFO "%sCPU #%d %u:%u APIC version %d\n",
-	       m->mpc_cpuflag & CPU_BOOTPROCESSOR ? "Bootup " : "",
-	       m->mpc_apicid,
-	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
-	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
-	       m->mpc_apicver);
+	       m->cpuflag & CPU_BOOTPROCESSOR ? "Bootup " : "",
+	       m->apicid, (m->cpufeature & CPU_FAMILY_MASK) >> 8,
+	       (m->cpufeature & CPU_MODEL_MASK) >> 4, m->apicver);
 
-	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR)
-		boot_cpu_physical_apicid = m->mpc_apicid;
+	if (m->cpuflag & CPU_BOOTPROCESSOR)
+		boot_cpu_physical_apicid = m->apicid;
 
-	ver = m->mpc_apicver;
-	if ((ver >= 0x14 && m->mpc_apicid >= 0xff) || m->mpc_apicid >= 0xf) {
+	ver = m->apicver;
+	if ((ver >= 0x14 && m->apicid >= 0xff) || m->apicid >= 0xf) {
 		printk(KERN_ERR "Processor #%d INVALID. (Max ID: %d).\n",
-			m->mpc_apicid, MAX_APICS);
+			m->apicid, MAX_APICS);
 		return;
 	}
 
-	apic_cpus = apicid_to_cpu_present(m->mpc_apicid);
+	apic_cpus = apicid_to_cpu_present(m->apicid);
 	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
 	/*
 	 * Validate version
@@ -210,10 +208,10 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	if (ver == 0x0) {
 		printk(KERN_ERR "BIOS bug, APIC version is 0 for CPU#%d! "
 			"fixing up to 0x10. (tell your hw vendor)\n",
-			m->mpc_apicid);
+			m->apicid);
 		ver = 0x10;
 	}
-	apic_version[m->mpc_apicid] = ver;
+	apic_version[m->apicid] = ver;
 }
 
 static int __init visws_find_smp_config(unsigned int reserve)
-- 
1.5.5.1



