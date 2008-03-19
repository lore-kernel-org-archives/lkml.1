Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbYCSUcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbYCSUcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbYCSTjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbYCSTjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:06 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 58/79] [PATCH] include mach_apic.h in smpboot_64.c and smpboot.c
Date: Wed, 19 Mar 2008 14:25:53 -0300
Message-Id: <12059478362371-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478321396-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

After the inclusion, a lot of files needs fixing for conflicts,
some of them in the headers themselves, to accomodate for both
i386 and x86_64 versions.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/acpi/boot.c                 |    2 ++
 arch/x86/kernel/mpparse_64.c                |    2 ++
 arch/x86/kernel/smpboot.c                   |    2 ++
 arch/x86/kernel/smpboot_64.c                |    1 +
 arch/x86/vdso/Makefile                      |    2 +-
 include/asm-x86/apic.h                      |    1 -
 include/asm-x86/apicdef.h                   |    6 ------
 include/asm-x86/mach-default/mach_apic.h    |   11 +++++++++++
 include/asm-x86/mach-default/mach_apicdef.h |    5 +++++
 include/asm-x86/smp_64.h                    |    9 +--------
 10 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index e8c2c47..f1f7d18 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -40,6 +40,8 @@
 #include <asm/io.h>
 #include <asm/mpspec.h>
 
+#include <mach_apic.h>
+
 static int __initdata acpi_force = 0;
 
 #ifdef	CONFIG_ACPI
diff --git a/arch/x86/kernel/mpparse_64.c b/arch/x86/kernel/mpparse_64.c
index 529b1c2..03ef1a8 100644
--- a/arch/x86/kernel/mpparse_64.c
+++ b/arch/x86/kernel/mpparse_64.c
@@ -30,6 +30,8 @@
 #include <asm/proto.h>
 #include <asm/acpi.h>
 
+#include <mach_apic.h>
+
 /* Have we found an MP table */
 int smp_found_config;
 unsigned int __cpuinitdata maxcpus = NR_CPUS;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6978f1b..253be86 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -11,6 +11,8 @@
 #include <asm/cpu.h>
 #include <asm/numa.h>
 
+#include <mach_apic.h>
+
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 7d1b4cb..8a59fa8 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -61,6 +61,7 @@
 #include <asm/numa.h>
 
 #include <mach_wakecpu.h>
+#include <mach_apic.h>
 #include <smpboot_hooks.h>
 
 /* Set when the idlers are all forked */
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 0a8f474..17a6b05 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -39,7 +39,7 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 
 CFL := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
 
-$(vobjs): KBUILD_CFLAGS = $(CFL)
+$(vobjs): KBUILD_CFLAGS += $(CFL)
 
 targets += vdso-syms.lds
 obj-$(VDSO64-y)			+= vdso-syms.lds
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 0d6ea74..534af84 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -128,7 +128,6 @@ extern void enable_NMI_through_LVT0(void);
  * On 32bit this is mach-xxx local
  */
 #ifdef CONFIG_X86_64
-extern void setup_apic_routing(void);
 extern void early_init_lapic_mapping(void);
 #endif
 
diff --git a/include/asm-x86/apicdef.h b/include/asm-x86/apicdef.h
index b0c6b28..674a228 100644
--- a/include/asm-x86/apicdef.h
+++ b/include/asm-x86/apicdef.h
@@ -12,12 +12,6 @@
 
 #define	APIC_ID		0x20
 
-#ifdef CONFIG_X86_64
-# define	APIC_ID_MASK		(0xFFu<<24)
-# define	GET_APIC_ID(x)		(((x)>>24)&0xFFu)
-# define	SET_APIC_ID(x)		(((x)<<24))
-#endif
-
 #define	APIC_LVR	0x30
 #define		APIC_LVR_MASK		0xFF00FF
 #define		GET_APIC_VERSION(x)	((x)&0xFFu)
diff --git a/include/asm-x86/mach-default/mach_apic.h b/include/asm-x86/mach-default/mach_apic.h
index e3c2c10..e081bdc 100644
--- a/include/asm-x86/mach-default/mach_apic.h
+++ b/include/asm-x86/mach-default/mach_apic.h
@@ -54,21 +54,27 @@ static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
 	return phys_map;
 }
 
+#ifdef CONFIG_X86_64
+extern void setup_apic_routing(void);
+#else
 static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 					"Flat", nr_ioapics);
 }
+#endif
 
 static inline int multi_timer_check(int apic, int irq)
 {
 	return 0;
 }
 
+#ifdef CONFIG_X86_32
 static inline int apicid_to_node(int logical_apicid)
 {
 	return 0;
 }
+#endif
 
 /* Mapping from cpu number to logical apicid */
 static inline int cpu_to_logical_apicid(int cpu)
@@ -78,8 +84,13 @@ static inline int cpu_to_logical_apicid(int cpu)
 
 static inline int cpu_present_to_apicid(int mps_cpu)
 {
+#ifdef CONFIG_X86_64
+	if (cpu_present(mps_cpu))
+		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
+#else
 	if (mps_cpu < get_physical_broadcast())
 		return  mps_cpu;
+#endif
 	else
 		return BAD_APICID;
 }
diff --git a/include/asm-x86/mach-default/mach_apicdef.h b/include/asm-x86/mach-default/mach_apicdef.h
index ae98413..7b78275 100644
--- a/include/asm-x86/mach-default/mach_apicdef.h
+++ b/include/asm-x86/mach-default/mach_apicdef.h
@@ -3,7 +3,12 @@
 
 #include <asm/apic.h>
 
+#ifdef CONFIG_X86_64
+#define	APIC_ID_MASK		(0xFFu<<24)
+#define	SET_APIC_ID(x)		(((x)<<24))
+#else
 #define		APIC_ID_MASK		(0xF<<24)
+#endif
 
 static inline unsigned get_apic_id(unsigned long x) 
 { 
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 1b3c0f1..be870a4 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -19,14 +19,6 @@ extern cpumask_t cpu_callin_map;
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
 
-static inline int cpu_present_to_apicid(int mps_cpu)
-{
-	if (cpu_present(mps_cpu))
-		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
-	else
-		return BAD_APICID;
-}
-
 #ifdef CONFIG_SMP
 
 #define raw_smp_processor_id()	read_pda(cpunumber)
@@ -64,6 +56,7 @@ static __inline int logical_smp_processor_id(void)
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
 }
 
+#include <mach_apicdef.h>
 static inline int hard_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
-- 
1.5.0.6

