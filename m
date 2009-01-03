Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbZACK04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbZACK04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932405AbZACK0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:26:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbZACK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:26:34 -0500
Subject: [PATCH -tip 2/7] x86: rename mpc_config_bus to mpc_bus
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       jbarnes@sgi.com, pazke@orbita1.ru, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:47:32 +0530
Message-Id: <1230977852.6138.22.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, smaller names, solves 80 columns wrap problem

mpc_config_bus should be renamed to mpc_bus.
The reason: the 'c' in MPC already means 'config' -
no need to repeat that in the type name.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/genapic_32.h |    2 +-
 arch/x86/include/asm/mpspec_def.h |    2 +-
 arch/x86/include/asm/setup.h      |    6 +++---
 arch/x86/kernel/mpparse.c         |   12 +++++-------
 arch/x86/kernel/numaq_32.c        |    4 ++--
 5 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index db02be0..057e2c2 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -15,7 +15,7 @@
  * Copyright 2003 Andi Kleen, SuSE Labs.
  */
 
-struct mpc_config_bus;
+struct mpc_bus;
 struct mpc_table;
 struct mpc_config_processor;
 
diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index e260e65..daa3f4a 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -80,7 +80,7 @@ struct mpc_config_processor {
 	unsigned int mpc_reserved[2];
 };
 
-struct mpc_config_bus {
+struct mpc_bus {
 	unsigned char mpc_type;
 	unsigned char mpc_busid;
 	unsigned char mpc_bustype[6];
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 4fcd53f..26754ca 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -26,7 +26,7 @@ extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
  * Any setup quirks to be performed?
  */
 struct mpc_config_processor;
-struct mpc_config_bus;
+struct mpc_bus;
 struct mp_config_oemtable;
 struct x86_quirks {
 	int (*arch_pre_time_init)(void);
@@ -40,8 +40,8 @@ struct x86_quirks {
 
 	int *mpc_record;
 	int (*mpc_apic_id)(struct mpc_config_processor *m);
-	void (*mpc_oem_bus_info)(struct mpc_config_bus *m, char *name);
-	void (*mpc_oem_pci_bus)(struct mpc_config_bus *m);
+	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
+	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
                                     unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 154de68..edbd2b1 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -74,7 +74,7 @@ static void __init MP_processor_info(struct mpc_config_processor *m)
 }
 
 #ifdef CONFIG_X86_IO_APIC
-static void __init MP_bus_info(struct mpc_config_bus *m)
+static void __init MP_bus_info(struct mpc_bus *m)
 {
 	char str[7];
 	memcpy(str, m->mpc_bustype, 6);
@@ -338,8 +338,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			}
 		case MP_BUS:
 			{
-				struct mpc_config_bus *m =
-				    (struct mpc_config_bus *)mpt;
+				struct mpc_bus *m = (struct mpc_bus *)mpt;
 #ifdef CONFIG_X86_IO_APIC
 				MP_bus_info(m);
 #endif
@@ -488,7 +487,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 static void __init construct_ioapic_table(int mpc_default_type)
 {
 	struct mpc_config_ioapic ioapic;
-	struct mpc_config_bus bus;
+	struct mpc_bus bus;
 
 	bus.mpc_type = MP_BUS;
 	bus.mpc_busid = 0;
@@ -656,7 +655,7 @@ static void __init __get_smp_config(unsigned int early)
 		 * ISA defaults and hope it will work.
 		 */
 		if (!mp_irq_entries) {
-			struct mpc_config_bus bus;
+			struct mpc_bus bus;
 
 			printk(KERN_ERR "BIOS bug, no explicit IRQ entries, "
 			       "using default mptable. "
@@ -867,8 +866,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			}
 		case MP_BUS:
 			{
-				struct mpc_config_bus *m =
-				    (struct mpc_config_bus *)mpt;
+				struct mpc_bus *m = (struct mpc_bus *)mpt;
 				mpt += sizeof(*m);
 				count += sizeof(*m);
 				break;
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 454c55b..8135426 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -135,7 +135,7 @@ int mp_bus_id_to_node[MAX_MP_BUSSES];
 int mp_bus_id_to_local[MAX_MP_BUSSES];
 
 /* x86_quirks member */
-static void mpc_oem_bus_info(struct mpc_config_bus *m, char *name)
+static void mpc_oem_bus_info(struct mpc_bus *m, char *name)
 {
 	int quad = translation_table[mpc_record]->trans_quad;
 	int local = translation_table[mpc_record]->trans_local;
@@ -149,7 +149,7 @@ static void mpc_oem_bus_info(struct mpc_config_bus *m, char *name)
 int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 
 /* x86_quirks member */
-static void mpc_oem_pci_bus(struct mpc_config_bus *m)
+static void mpc_oem_pci_bus(struct mpc_bus *m)
 {
 	int quad = translation_table[mpc_record]->trans_quad;
 	int local = translation_table[mpc_record]->trans_local;
-- 
1.5.5.1



