Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbZACK0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbZACK0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759880AbZACK0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:26:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbZACK0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:26:21 -0500
Subject: [PATCH -tip 1/7] x86: rename mp_config_table to mpc_table
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       jbarnes@sgi.com, pazke@orbita1.ru, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:46:57 +0530
Message-Id: <1230977817.6138.20.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, smaller names, solves 80 columns wrap problem

mp_config_table should be renamed to mpc_table.
The reason: the 'c' in MPC already means 'config' -
no need to repeat that in the type name.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/es7000/mpparse.h            |    3 +--
 arch/x86/include/asm/genapic_32.h                |    4 ++--
 arch/x86/include/asm/mach-default/mach_mpparse.h |    4 ++--
 arch/x86/include/asm/mach-generic/mach_mpparse.h |    5 ++---
 arch/x86/include/asm/mach-generic/mach_mpspec.h  |    4 ++--
 arch/x86/include/asm/mpspec_def.h                |    2 +-
 arch/x86/include/asm/numaq/mpparse.h             |    3 +--
 arch/x86/include/asm/summit/mpparse.h            |    2 +-
 arch/x86/kernel/mpparse.c                        |   10 ++++------
 arch/x86/kernel/numaq_32.c                       |    3 +--
 arch/x86/mach-generic/es7000.c                   |    4 ++--
 arch/x86/mach-generic/numaq.c                    |    3 +--
 arch/x86/mach-generic/probe.c                    |    3 +--
 13 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/es7000/mpparse.h b/arch/x86/include/asm/es7000/mpparse.h
index ed5a3ca..c1629b0 100644
--- a/arch/x86/include/asm/es7000/mpparse.h
+++ b/arch/x86/include/asm/es7000/mpparse.h
@@ -10,8 +10,7 @@ extern void setup_unisys(void);
 
 #ifndef CONFIG_X86_GENERICARCH
 extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
-extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
+extern int mps_oem_check(struct mpc_table *mpc, char *oem, char *productid);
 #endif
 
 #ifdef CONFIG_ACPI
diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index 746f37a..db02be0 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -16,7 +16,7 @@
  */
 
 struct mpc_config_bus;
-struct mp_config_table;
+struct mpc_table;
 struct mpc_config_processor;
 
 struct genapic {
@@ -51,7 +51,7 @@ struct genapic {
 	/* When one of the next two hooks returns 1 the genapic
 	   is switched to this. Essentially they are additional probe
 	   functions. */
-	int (*mps_oem_check)(struct mp_config_table *mpc, char *oem,
+	int (*mps_oem_check)(struct mpc_table *mpc, char *oem,
 			     char *productid);
 	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
diff --git a/arch/x86/include/asm/mach-default/mach_mpparse.h b/arch/x86/include/asm/mach-default/mach_mpparse.h
index 8c1ea21..c70a263 100644
--- a/arch/x86/include/asm/mach-default/mach_mpparse.h
+++ b/arch/x86/include/asm/mach-default/mach_mpparse.h
@@ -1,8 +1,8 @@
 #ifndef _ASM_X86_MACH_DEFAULT_MACH_MPPARSE_H
 #define _ASM_X86_MACH_DEFAULT_MACH_MPPARSE_H
 
-static inline int mps_oem_check(struct mp_config_table *mpc, char *oem, 
-		char *productid)
+static inline int
+mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	return 0;
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_mpparse.h b/arch/x86/include/asm/mach-generic/mach_mpparse.h
index 048f1d4..9444ab8 100644
--- a/arch/x86/include/asm/mach-generic/mach_mpparse.h
+++ b/arch/x86/include/asm/mach-generic/mach_mpparse.h
@@ -2,9 +2,8 @@
 #define _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H
 

-extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
-			 char *productid);
+extern int mps_oem_check(struct mpc_table *, char *, char *);
 
-extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
+extern int acpi_madt_oem_check(char *, char *);
 
 #endif /* _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_mpspec.h b/arch/x86/include/asm/mach-generic/mach_mpspec.h
index bbab5cc..3bc4072 100644
--- a/arch/x86/include/asm/mach-generic/mach_mpspec.h
+++ b/arch/x86/include/asm/mach-generic/mach_mpspec.h
@@ -7,6 +7,6 @@
 /* Maximum 256 PCI busses, plus 1 ISA bus in each of 4 cabinets. */
 #define MAX_MP_BUSSES 260
 
-extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
+extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
+
 #endif /* _ASM_X86_MACH_GENERIC_MACH_MPSPEC_H */
diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index e3ace7d..e260e65 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -39,7 +39,7 @@ struct intel_mp_floating {
 
 #define MPC_SIGNATURE "PCMP"
 
-struct mp_config_table {
+struct mpc_table {
 	char mpc_signature[4];
 	unsigned short mpc_length;	/* Size of table */
 	char mpc_spec;			/* 0x01 */
diff --git a/arch/x86/include/asm/numaq/mpparse.h b/arch/x86/include/asm/numaq/mpparse.h
index 252292e..a2eeefc 100644
--- a/arch/x86/include/asm/numaq/mpparse.h
+++ b/arch/x86/include/asm/numaq/mpparse.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_NUMAQ_MPPARSE_H
 #define __ASM_NUMAQ_MPPARSE_H
 
-extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
+extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
 
 #endif /* __ASM_NUMAQ_MPPARSE_H */
diff --git a/arch/x86/include/asm/summit/mpparse.h b/arch/x86/include/asm/summit/mpparse.h
index 013ce6f..380e86c 100644
--- a/arch/x86/include/asm/summit/mpparse.h
+++ b/arch/x86/include/asm/summit/mpparse.h
@@ -11,7 +11,7 @@ extern void setup_summit(void);
 #define setup_summit()	{}
 #endif
 
-static inline int mps_oem_check(struct mp_config_table *mpc, char *oem,
+static inline int mps_oem_check(struct mpc_table *mpc, char *oem,
 		char *productid)
 {
 	if (!strncmp(oem, "IBM ENSW", 8) &&
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c5c5b8d..154de68 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -246,8 +246,7 @@ static void __init MP_lintsrc_info(struct mpc_config_lintsrc *m)
  * Read/parse the MPC
  */
 
-static int __init smp_check_mpc(struct mp_config_table *mpc, char *oem,
-				char *str)
+static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 {
 
 	if (memcmp(mpc->mpc_signature, MPC_SIGNATURE, 4)) {
@@ -283,7 +282,7 @@ static int __init smp_check_mpc(struct mp_config_table *mpc, char *oem,
 	return 1;
 }
 
-static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
+static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
 	char oem[10];
@@ -843,7 +842,7 @@ static int  __init get_MP_intsrc_index(struct mpc_config_intsrc *m)
 static struct mpc_config_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
 #endif
 
-static int  __init replace_intsrc_all(struct mp_config_table *mpc,
+static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
 					unsigned long mpc_new_length)
 {
@@ -1014,8 +1013,7 @@ static int __init update_mp_table(void)
 	char str[16];
 	char oem[10];
 	struct intel_mp_floating *mpf;
-	struct mp_config_table *mpc;
-	struct mp_config_table *mpc_new;
+	struct mpc_table *mpc, *mpc_new;
 
 	if (!enable_update_mptable)
 		return 0;
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 0deea37..454c55b 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -260,8 +260,7 @@ static struct x86_quirks numaq_x86_quirks __initdata = {
 	.update_genapic		= numaq_update_genapic,
 };
 
-void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				 char *productid)
+void numaq_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	if (strncmp(oem, "IBM NUMA", 8))
 		printk("Warning!  Not a NUMA-Q system!\n");
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 4ba5cca..3b580ed 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -43,8 +43,8 @@ static void __init enable_apic_mode(void)
 	return;
 }
 
-static __init int mps_oem_check(struct mp_config_table *mpc, char *oem,
-		char *productid)
+static __init int
+mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	if (mpc->mpc_oemptr) {
 		struct mp_config_oemtable *oem_table =
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index 511d794..3679e22 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -19,8 +19,7 @@
 #include <asm/numaq/wakecpu.h>
 #include <asm/numaq.h>
 
-static int mps_oem_check(struct mp_config_table *mpc, char *oem,
-		char *productid)
+static int mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	numaq_mps_oem_check(mpc, oem, productid);
 	return found_numaq;
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index c346d9d..15a38da 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -110,8 +110,7 @@ void __init generic_apic_probe(void)
 
 /* These functions can switch the APIC even after the initial ->probe() */
 
-int __init mps_oem_check(struct mp_config_table *mpc, char *oem,
-				 char *productid)
+int __init mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	int i;
 	for (i = 0; apic_probe[i]; ++i) {
-- 
1.5.5.1



