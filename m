Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYDZPxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYDZPxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYDZPx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:53:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50174 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbYDZPx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:53:26 -0400
Date: Sat, 26 Apr 2008 17:53:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] x86 misc updates
Message-ID: <20080426155307.GA9836@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the x86 misc fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-misc.git for-linus

Thanks,

	Ingo

------------------>
Adrian Bunk (1):
      fix asm-x86/{posix_types,unistd}.h

Akinobu Mita (10):
      x86: use BUILD_BUG_ON() for the size of struct intel_mp_floating
      x86: use MP_intsrc_info()
      x86: use bitmap library for pin_programmed
      x86: remove unnecessary memset and NULL check after alloc_bootmem()
      x86: cleanup clocksource_hz2mult usage
      x86: cleanup div_sc() usage
      x86: use cpumask function for present, possible, and online cpus
      x86: get_bios_ebda() requires asm/io.h
      x86: remove duplicate get_bios_ebda() from rio.h
      x86: use get_bios_ebda()

Dmitri Vorobiev (3):
      x86: remove unused function amd_init_cpu()
      x86: array can become static
      x86: remove NexGen support

Jacek Luczak (6):
      x86: trampoline_32.S - switch to .cpuinit.data
      x86: uniq_ioapic_id - fix section mismatch warning
      x86: unlock_ExtINT_logic() - fix section mismatch warnings
      x86: pgtable_32.h - prototype and section mismatch fixes
      x86: section mismatch fixes, #2
      x86: section mismatch fixes, #3

Jan Beulich (4):
      i386: fix asm constraint in do_IRQ()
      x86: fix watchdog ops for CoreDuo
      i386: fix signal type for iret exception
      x86-64: extend MCE CPU quirk handling

Roland McGrath (4):
      x86 signals: lift flags diddling code
      x86 signals: lift set_fs
      x86_64 ia32 ptrace: use compat_ptrace_request for siginfo
      x86_64 ia32 ptrace: convert to compat_arch_ptrace

 arch/x86/Kconfig.cpu                         |    4 +-
 arch/x86/ia32/ia32_signal.c                  |   10 ---
 arch/x86/ia32/ia32entry.S                    |    2 +-
 arch/x86/kernel/acpi/boot.c                  |    4 -
 arch/x86/kernel/apic_32.c                    |    3 +-
 arch/x86/kernel/apic_64.c                    |    3 +-
 arch/x86/kernel/cpu/Makefile                 |    1 -
 arch/x86/kernel/cpu/amd.c                    |    6 --
 arch/x86/kernel/cpu/mcheck/mce_64.c          |   18 +++--
 arch/x86/kernel/cpu/nexgen.c                 |   59 ----------------
 arch/x86/kernel/cpu/perfctr-watchdog.c       |   14 +---
 arch/x86/kernel/genapic_64.c                 |    2 +-
 arch/x86/kernel/head64.c                     |    5 +-
 arch/x86/kernel/hpet.c                       |    2 +-
 arch/x86/kernel/i8253.c                      |    6 +-
 arch/x86/kernel/io_apic_32.c                 |    2 +-
 arch/x86/kernel/io_apic_64.c                 |    2 +-
 arch/x86/kernel/irq_32.c                     |    2 +-
 arch/x86/kernel/mfgpt_32.c                   |    3 +-
 arch/x86/kernel/mpparse.c                    |   39 +++--------
 arch/x86/kernel/pci-calgary_64.c             |    1 +
 arch/x86/kernel/ptrace.c                     |   95 ++-----------------------
 arch/x86/kernel/setup_32.c                   |    4 +-
 arch/x86/kernel/setup_64.c                   |    2 +-
 arch/x86/kernel/signal_32.c                  |   35 ++++------
 arch/x86/kernel/signal_64.c                  |   30 ++++++--
 arch/x86/kernel/smpboot.c                    |    4 +-
 arch/x86/kernel/summit_32.c                  |    5 +-
 arch/x86/kernel/tlb_64.c                     |    4 +-
 arch/x86/kernel/trampoline_32.S              |    2 +-
 arch/x86/kernel/traps_32.c                   |    2 +-
 arch/x86/mach-voyager/voyager_smp.c          |   10 ++--
 arch/x86/mm/init_32.c                        |    6 +-
 arch/x86/xen/smp.c                           |    2 +-
 include/asm-x86/bios_ebda.h                  |    2 +
 include/asm-x86/io_apic.h                    |    6 +-
 include/asm-x86/mach-default/smpboot_hooks.h |    2 +-
 include/asm-x86/pgtable_32.h                 |    8 +-
 include/asm-x86/posix_types.h                |    8 ++-
 include/asm-x86/processor.h                  |    1 -
 include/asm-x86/ptrace.h                     |    2 +
 include/asm-x86/rio.h                        |   11 ---
 include/asm-x86/unistd.h                     |    8 ++-
 43 files changed, 134 insertions(+), 303 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/nexgen.c

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 57072f2..4da3cdb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -21,8 +21,8 @@ config M386
 
 	  Here are the settings recommended for greatest speed:
 	  - "386" for the AMD/Cyrix/Intel 386DX/DXL/SL/SLC/SX, Cyrix/TI
-	  486DLC/DLC2, UMC 486SX-S and NexGen Nx586.  Only "386" kernels
-	  will run on a 386 class machine.
+	  486DLC/DLC2, and UMC 486SX-S.  Only "386" kernels will run on a 386
+	  class machine.
 	  - "486" for the AMD/Cyrix/IBM/Intel 486DX/DX2/DX4 or
 	  SL/SLC/SLC2/SLC3/SX/SX2 and UMC U5D or U5S.
 	  - "586" for generic Pentium CPUs lacking the TSC
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 05e155d..bbed3a2 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -499,11 +499,6 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	regs->cs = __USER32_CS;
 	regs->ss = __USER32_DS;
 
-	set_fs(USER_DS);
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 #if DEBUG_SIG
 	printk(KERN_DEBUG "SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
 	       current->comm, current->pid, frame, regs->ip, frame->pretcode);
@@ -599,11 +594,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->cs = __USER32_CS;
 	regs->ss = __USER32_DS;
 
-	set_fs(USER_DS);
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 #if DEBUG_SIG
 	printk(KERN_DEBUG "SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
 	       current->comm, current->pid, frame, regs->ip, frame->pretcode);
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index ae7158b..b5e329d 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -430,7 +430,7 @@ ia32_sys_call_table:
 	.quad sys_setuid16
 	.quad sys_getuid16
 	.quad compat_sys_stime	/* stime */		/* 25 */
-	.quad sys32_ptrace	/* ptrace */
+	.quad compat_sys_ptrace	/* ptrace */
 	.quad sys_alarm
 	.quad sys_fstat	/* (old)fstat */
 	.quad sys_pause
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 057ccf1..977ed5c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -697,10 +697,6 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 #define HPET_RESOURCE_NAME_SIZE 9
 	hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);
 
-	if (!hpet_res)
-		return 0;
-
-	memset(hpet_res, 0, sizeof(*hpet_res));
 	hpet_res->name = (void *)&hpet_res[1];
 	hpet_res->flags = IORESOURCE_MEM;
 	snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE, "HPET %u",
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 8317401..4b99b1b 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -451,7 +451,8 @@ void __init setup_boot_APIC_clock(void)
 	}
 
 	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS, 32);
+	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
+				       lapic_clockevent.shift);
 	lapic_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
 	lapic_clockevent.min_delta_ns =
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index bf83157..5910020 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -360,7 +360,8 @@ static void __init calibrate_APIC_clock(void)
 		result / 1000 / 1000, result / 1000 % 1000);
 
 	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC, 32);
+	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC,
+				       lapic_clockevent.shift);
 	lapic_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
 	lapic_clockevent.min_delta_ns =
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index ee7c452..a0c6f81 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_X86_32)	+= cyrix.o
 obj-$(CONFIG_X86_32)	+= centaur.o
 obj-$(CONFIG_X86_32)	+= transmeta.o
 obj-$(CONFIG_X86_32)	+= intel.o
-obj-$(CONFIG_X86_32)	+= nexgen.o
 obj-$(CONFIG_X86_32)	+= umc.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0173065..2458668 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -343,10 +343,4 @@ static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 	.c_size_cache	= amd_size_cache,
 };
 
-int __init amd_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_AMD] = &amd_cpu_dev;
-	return 0;
-}
-
 cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 9a699ed..e07e8c0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -49,7 +49,7 @@ static int banks;
 static unsigned long bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
 static unsigned long notify_user;
 static int rip_msr;
-static int mce_bootlog = 1;
+static int mce_bootlog = -1;
 static atomic_t mce_events;
 
 static char trigger[128];
@@ -471,13 +471,15 @@ static void mce_init(void *dummy)
 static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
 	/* This should be disabled by the BIOS, but isn't always */
-	if (c->x86_vendor == X86_VENDOR_AMD && c->x86 == 15) {
-		/* disable GART TBL walk error reporting, which trips off
-		   incorrectly with the IOMMU & 3ware & Cerberus. */
-		clear_bit(10, &bank[4]);
-		/* Lots of broken BIOS around that don't clear them
-		   by default and leave crap in there. Don't log. */
-		mce_bootlog = 0;
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		if(c->x86 == 15)
+			/* disable GART TBL walk error reporting, which trips off
+			   incorrectly with the IOMMU & 3ware & Cerberus. */
+			clear_bit(10, &bank[4]);
+		if(c->x86 <= 17 && mce_bootlog < 0)
+			/* Lots of broken BIOS around that don't clear them
+			   by default and leave crap in there. Don't log. */
+			mce_bootlog = 0;
 	}
 
 }
diff --git a/arch/x86/kernel/cpu/nexgen.c b/arch/x86/kernel/cpu/nexgen.c
deleted file mode 100644
index 5d5e1c1..0000000
--- a/arch/x86/kernel/cpu/nexgen.c
+++ /dev/null
@@ -1,59 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <asm/processor.h>
-
-#include "cpu.h"
-
-/*
- *	Detect a NexGen CPU running without BIOS hypercode new enough
- *	to have CPUID. (Thanks to Herbert Oppmann)
- */
-
-static int __cpuinit deep_magic_nexgen_probe(void)
-{
-	int ret;
-
-	__asm__ __volatile__ (
-		"	movw	$0x5555, %%ax\n"
-		"	xorw	%%dx,%%dx\n"
-		"	movw	$2, %%cx\n"
-		"	divw	%%cx\n"
-		"	movl	$0, %%eax\n"
-		"	jnz	1f\n"
-		"	movl	$1, %%eax\n"
-		"1:\n"
-		: "=a" (ret) : : "cx", "dx");
-	return  ret;
-}
-
-static void __cpuinit init_nexgen(struct cpuinfo_x86 *c)
-{
-	c->x86_cache_size = 256; /* A few had 1 MB... */
-}
-
-static void __cpuinit nexgen_identify(struct cpuinfo_x86 *c)
-{
-	/* Detect NexGen with old hypercode */
-	if (deep_magic_nexgen_probe())
-		strcpy(c->x86_vendor_id, "NexGenDriven");
-}
-
-static struct cpu_dev nexgen_cpu_dev __cpuinitdata = {
-	.c_vendor	= "Nexgen",
-	.c_ident	= { "NexGenDriven" },
-	.c_models = {
-			{ .vendor = X86_VENDOR_NEXGEN,
-			  .family = 5,
-			  .model_names = { [1] = "Nx586" }
-			},
-	},
-	.c_init		= init_nexgen,
-	.c_identify	= nexgen_identify,
-};
-
-int __init nexgen_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_NEXGEN] = &nexgen_cpu_dev;
-	return 0;
-}
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index b943e10..f9ae93a 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -614,16 +614,6 @@ static struct wd_ops intel_arch_wd_ops __read_mostly = {
 	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
-static struct wd_ops coreduo_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
-	.setup = setup_intel_arch_watchdog,
-	.rearm = p6_rearm,
-	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
-	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
-};
-
 static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -637,8 +627,8 @@ static void probe_nmi_watchdog(void)
 		/* Work around Core Duo (Yonah) errata AE49 where perfctr1
 		   doesn't have a working enable bit. */
 		if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) {
-			wd_ops = &coreduo_wd_ops;
-			break;
+			intel_arch_wd_ops.perfctr = MSR_ARCH_PERFMON_PERFCTR0;
+			intel_arch_wd_ops.evntsel = MSR_ARCH_PERFMON_EVENTSEL0;
 		}
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 			wd_ops = &intel_arch_wd_ops;
diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/genapic_64.c
index 9546ef4..021624c 100644
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -51,7 +51,7 @@ void __init setup_apic_routing(void)
 	else
 #endif
 
-	if (cpus_weight(cpu_possible_map) <= 8)
+	if (num_possible_cpus() <= 8)
 		genapic = &apic_flat;
 	else
 		genapic = &apic_physflat;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 993c767..d31d6b7 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -22,6 +22,7 @@
 #include <asm/sections.h>
 #include <asm/kdebug.h>
 #include <asm/e820.h>
+#include <asm/bios_ebda.h>
 
 static void __init zap_identity_mappings(void)
 {
@@ -49,7 +50,6 @@ static void __init copy_bootdata(char *real_mode_data)
 	}
 }
 
-#define BIOS_EBDA_SEGMENT 0x40E
 #define BIOS_LOWMEM_KILOBYTES 0x413
 
 /*
@@ -80,8 +80,7 @@ static void __init reserve_ebda_region(void)
 	lowmem <<= 10;
 
 	/* start of EBDA area */
-	ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
-	ebda_addr <<= 4;
+	ebda_addr = get_bios_ebda();
 
 	/* Fixup: bios puts an EBDA in the top 64K segment */
 	/* of conventional memory, but does not adjust lowmem. */
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 36652ea..9007f9e 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -218,7 +218,7 @@ static void hpet_legacy_clockevent_register(void)
 	hpet_freq = 1000000000000000ULL;
 	do_div(hpet_freq, hpet_period);
 	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
-				      NSEC_PER_SEC, 32);
+				      NSEC_PER_SEC, hpet_clockevent.shift);
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 8540abe..c1b5e3e 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -115,7 +115,8 @@ void __init setup_pit_timer(void)
 	 * IO_APIC has been initialized.
 	 */
 	pit_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
-	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, 32);
+	pit_clockevent.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC,
+				     pit_clockevent.shift);
 	pit_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFF, &pit_clockevent);
 	pit_clockevent.min_delta_ns =
@@ -224,7 +225,8 @@ static int __init init_pit_clocksource(void)
 	    pit_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE, 20);
+	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE,
+						   clocksource_pit.shift);
 	return clocksource_register(&clocksource_pit);
 }
 arch_initcall(init_pit_clocksource);
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 2e2f420..696b8e4 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -2068,7 +2068,7 @@ static void __init setup_nmi(void)
  * cycles as some i82489DX-based boards have glue logic that keeps the
  * 8259A interrupt line asserted until INTA.  --macro
  */
-static inline void unlock_ExtINT_logic(void)
+static inline void __init unlock_ExtINT_logic(void)
 {
 	int apic, pin, i;
 	struct IO_APIC_route_entry entry0, entry1;
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 9ba11d0..ef1a8df 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1599,7 +1599,7 @@ static void __init setup_nmi(void)
  * cycles as some i82489DX-based boards have glue logic that keeps the
  * 8259A interrupt line asserted until INTA.  --macro
  */
-static inline void unlock_ExtINT_logic(void)
+static inline void __init unlock_ExtINT_logic(void)
 {
 	int apic, pin, i;
 	struct IO_APIC_route_entry entry0, entry1;
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 6ea67b7..00bda7b 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -134,7 +134,7 @@ unsigned int do_IRQ(struct pt_regs *regs)
 			: "=a" (arg1), "=d" (arg2), "=b" (bx)
 			:  "0" (irq),   "1" (desc),  "2" (isp),
 			   "D" (desc->handle_irq)
-			: "memory", "cc"
+			: "memory", "cc", "ecx"
 		);
 	} else
 #endif
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index b402c0f..cfc2648 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -364,7 +364,8 @@ int __init mfgpt_timer_setup(void)
 	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP, val);
 
 	/* Set up the clock event */
-	mfgpt_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC, 32);
+	mfgpt_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC,
+				       mfgpt_clockevent.shift);
 	mfgpt_clockevent.min_delta_ns = clockevent_delta2ns(0xF,
 			&mfgpt_clockevent);
 	mfgpt_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 70744e3..3e2c54d 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -686,13 +686,11 @@ void __init get_smp_config(void)
 static int __init smp_scan_config(unsigned long base, unsigned long length,
 				  unsigned reserve)
 {
-	extern void __bad_mpf_size(void);
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
 	Dprintk("Scan SMP from %p for %ld bytes.\n", bp, length);
-	if (sizeof(*mpf) != 16)
-		__bad_mpf_size();
+	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
 		mpf = (struct intel_mp_floating *)bp;
@@ -801,7 +799,6 @@ void __init find_smp_config(void)
 #ifdef	CONFIG_X86_IO_APIC
 
 #define MP_ISA_BUS		0
-#define MP_MAX_IOAPIC_PIN	127
 
 extern struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
 
@@ -820,7 +817,7 @@ static int mp_find_ioapic(int gsi)
 	return -1;
 }
 
-static u8 uniq_ioapic_id(u8 id)
+static u8 __init uniq_ioapic_id(u8 id)
 {
 #ifdef CONFIG_X86_32
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
@@ -909,14 +906,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	intsrc.mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;	/* APIC ID */
 	intsrc.mpc_dstirq = pin;	/* INTIN# */
 
-	Dprintk("Int: type %d, pol %d, trig %d, bus %d, irq %d, %d-%d\n",
-		intsrc.mpc_irqtype, intsrc.mpc_irqflag & 3,
-		(intsrc.mpc_irqflag >> 2) & 3, intsrc.mpc_srcbus,
-		intsrc.mpc_srcbusirq, intsrc.mpc_dstapic, intsrc.mpc_dstirq);
-
-	mp_irqs[mp_irq_entries] = intsrc;
-	if (++mp_irq_entries == MAX_IRQ_SOURCES)
-		panic("Max # of irq sources exceeded!\n");
+	MP_intsrc_info(&intsrc);
 }
 
 int es7000_plat;
@@ -985,23 +975,14 @@ void __init mp_config_acpi_legacy_irqs(void)
 		intsrc.mpc_srcbusirq = i;	/* Identity mapped */
 		intsrc.mpc_dstirq = i;
 
-		Dprintk("Int: type %d, pol %d, trig %d, bus %d, irq %d, "
-			"%d-%d\n", intsrc.mpc_irqtype, intsrc.mpc_irqflag & 3,
-			(intsrc.mpc_irqflag >> 2) & 3, intsrc.mpc_srcbus,
-			intsrc.mpc_srcbusirq, intsrc.mpc_dstapic,
-			intsrc.mpc_dstirq);
-
-		mp_irqs[mp_irq_entries] = intsrc;
-		if (++mp_irq_entries == MAX_IRQ_SOURCES)
-			panic("Max # of irq sources exceeded!\n");
+		MP_intsrc_info(&intsrc);
 	}
 }
 
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
 {
-	int ioapic = -1;
-	int ioapic_pin = 0;
-	int idx, bit = 0;
+	int ioapic;
+	int ioapic_pin;
 #ifdef CONFIG_X86_32
 #define MAX_GSI_NUM	4096
 #define IRQ_COMPRESSION_START	64
@@ -1041,15 +1022,13 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 	 * with redundant pin->gsi mappings (but unique PCI devices);
 	 * we only program the IOAPIC on the first.
 	 */
-	bit = ioapic_pin % 32;
-	idx = (ioapic_pin < 32) ? 0 : (ioapic_pin / 32);
-	if (idx > 3) {
+	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 		       "%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
 		       ioapic_pin);
 		return gsi;
 	}
-	if ((1 << bit) & mp_ioapic_routing[ioapic].pin_programmed[idx]) {
+	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
 		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
 			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
 #ifdef CONFIG_X86_32
@@ -1059,7 +1038,7 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 #endif
 	}
 
-	mp_ioapic_routing[ioapic].pin_programmed[idx] |= (1 << bit);
+	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
 #ifdef CONFIG_X86_32
 	/*
 	 * For GSI >= 64, use IRQ compression
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 2edee22..e28ec49 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -43,6 +43,7 @@
 #include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/rio.h>
+#include <asm/bios_ebda.h>
 
 #ifdef CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT
 int use_calgary __read_mostly = 1;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 559c1b0..fb03ef3 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1207,97 +1207,16 @@ static int genregs32_set(struct task_struct *target,
 	return ret;
 }
 
-static long ptrace32_siginfo(unsigned request, u32 pid, u32 addr, u32 data)
+long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
+			compat_ulong_t caddr, compat_ulong_t cdata)
 {
-	siginfo_t __user *si = compat_alloc_user_space(sizeof(siginfo_t));
-	compat_siginfo_t __user *si32 = compat_ptr(data);
-	siginfo_t ssi;
-	int ret;
-
-	if (request == PTRACE_SETSIGINFO) {
-		memset(&ssi, 0, sizeof(siginfo_t));
-		ret = copy_siginfo_from_user32(&ssi, si32);
-		if (ret)
-			return ret;
-		if (copy_to_user(si, &ssi, sizeof(siginfo_t)))
-			return -EFAULT;
-	}
-	ret = sys_ptrace(request, pid, addr, (unsigned long)si);
-	if (ret)
-		return ret;
-	if (request == PTRACE_GETSIGINFO) {
-		if (copy_from_user(&ssi, si, sizeof(siginfo_t)))
-			return -EFAULT;
-		ret = copy_siginfo_to_user32(si32, &ssi);
-	}
-	return ret;
-}
-
-asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
-{
-	struct task_struct *child;
-	struct pt_regs *childregs;
+	unsigned long addr = caddr;
+	unsigned long data = cdata;
 	void __user *datap = compat_ptr(data);
 	int ret;
 	__u32 val;
 
 	switch (request) {
-	case PTRACE_TRACEME:
-	case PTRACE_ATTACH:
-	case PTRACE_KILL:
-	case PTRACE_CONT:
-	case PTRACE_SINGLESTEP:
-	case PTRACE_SINGLEBLOCK:
-	case PTRACE_DETACH:
-	case PTRACE_SYSCALL:
-	case PTRACE_OLDSETOPTIONS:
-	case PTRACE_SETOPTIONS:
-	case PTRACE_SET_THREAD_AREA:
-	case PTRACE_GET_THREAD_AREA:
-#ifdef X86_BTS
-	case PTRACE_BTS_CONFIG:
-	case PTRACE_BTS_STATUS:
-	case PTRACE_BTS_SIZE:
-	case PTRACE_BTS_GET:
-	case PTRACE_BTS_CLEAR:
-	case PTRACE_BTS_DRAIN:
-#endif
-		return sys_ptrace(request, pid, addr, data);
-
-	default:
-		return -EINVAL;
-
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-	case PTRACE_POKEDATA:
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEUSR:
-	case PTRACE_PEEKUSR:
-	case PTRACE_GETREGS:
-	case PTRACE_SETREGS:
-	case PTRACE_SETFPREGS:
-	case PTRACE_GETFPREGS:
-	case PTRACE_SETFPXREGS:
-	case PTRACE_GETFPXREGS:
-	case PTRACE_GETEVENTMSG:
-		break;
-
-	case PTRACE_SETSIGINFO:
-	case PTRACE_GETSIGINFO:
-		return ptrace32_siginfo(request, pid, addr, data);
-	}
-
-	child = ptrace_get_task_struct(pid);
-	if (IS_ERR(child))
-		return PTR_ERR(child);
-
-	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (ret < 0)
-		goto out;
-
-	childregs = task_pt_regs(child);
-
-	switch (request) {
 	case PTRACE_PEEKUSR:
 		ret = getreg32(child, addr, &val);
 		if (ret == 0)
@@ -1343,12 +1262,14 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 					     sizeof(struct user32_fxsr_struct),
 					     datap);
 
+	case PTRACE_GET_THREAD_AREA:
+	case PTRACE_SET_THREAD_AREA:
+		return arch_ptrace(child, request, addr, data);
+
 	default:
 		return compat_ptrace_request(child, request, addr, data);
 	}
 
- out:
-	put_task_struct(child);
 	return ret;
 }
 
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 455d3c8..44cc9b9 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -389,7 +389,6 @@ unsigned long __init find_max_low_pfn(void)
 	return max_low_pfn;
 }
 
-#define BIOS_EBDA_SEGMENT 0x40E
 #define BIOS_LOWMEM_KILOBYTES 0x413
 
 /*
@@ -420,8 +419,7 @@ static void __init reserve_ebda_region(void)
 	lowmem <<= 10;
 
 	/* start of EBDA area */
-	ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
-	ebda_addr <<= 4;
+	ebda_addr = get_bios_ebda();
 
 	/* Fixup: bios puts an EBDA in the top 64K segment */
 	/* of conventional memory, but does not adjust lowmem. */
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c2ec3dc..17bdf23 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -116,7 +116,7 @@ extern int root_mountflags;
 
 char __initdata command_line[COMMAND_LINE_SIZE];
 
-struct resource standard_io_resources[] = {
+static struct resource standard_io_resources[] = {
 	{ .name = "dma1", .start = 0x00, .end = 0x1f,
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
 	{ .name = "pic1", .start = 0x20, .end = 0x21,
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index f1b1179..8e05e7f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -413,16 +413,6 @@ setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	regs->ss = __USER_DS;
 	regs->cs = __USER_CS;
 
-	/*
-	 * Clear TF when entering the signal handler, but
-	 * notify any tracer that was single-stepping it.
-	 * The tracer may want to single-step inside the
-	 * handler too.
-	 */
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 	return 0;
 
 give_sigsegv:
@@ -501,16 +491,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->ss = __USER_DS;
 	regs->cs = __USER_CS;
 
-	/*
-	 * Clear TF when entering the signal handler, but
-	 * notify any tracer that was single-stepping it.
-	 * The tracer may want to single-step inside the
-	 * handler too.
-	 */
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 	return 0;
 
 give_sigsegv:
@@ -566,6 +546,21 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	if (ret)
 		return ret;
 
+	/*
+	 * Clear the direction flag as per the ABI for function entry.
+	 */
+	regs->flags &= ~X86_EFLAGS_DF;
+
+	/*
+	 * Clear TF when entering the signal handler, but
+	 * notify any tracer that was single-stepping it.
+	 * The tracer may want to single-step inside the
+	 * handler too.
+	 */
+	regs->flags &= ~X86_EFLAGS_TF;
+	if (test_thread_flag(TIF_SINGLESTEP))
+		ptrace_notify(SIGTRAP);
+
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 827179c..ccb2a45 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -285,14 +285,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	   even if the handler happens to be interrupting 32-bit code. */
 	regs->cs = __USER_CS;
 
-	/* This, by contrast, has nothing to do with segment registers -
-	   see include/asm-x86_64/uaccess.h for details. */
-	set_fs(USER_DS);
-
-	regs->flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_DF);
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
-
 	return 0;
 
 give_sigsegv:
@@ -380,6 +372,28 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	ret = setup_rt_frame(sig, ka, info, oldset, regs);
 
 	if (ret == 0) {
+		/*
+		 * This has nothing to do with segment registers,
+		 * despite the name.  This magic affects uaccess.h
+		 * macros' behavior.  Reset it to the normal setting.
+		 */
+		set_fs(USER_DS);
+
+		/*
+		 * Clear the direction flag as per the ABI for function entry.
+		 */
+		regs->flags &= ~X86_EFLAGS_DF;
+
+		/*
+		 * Clear TF when entering the signal handler, but
+		 * notify any tracer that was single-stepping it.
+		 * The tracer may want to single-step inside the
+		 * handler too.
+		 */
+		regs->flags &= ~X86_EFLAGS_TF;
+		if (test_thread_flag(TIF_SINGLESTEP))
+			ptrace_notify(SIGTRAP);
+
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index eef79e8..04c662b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1058,7 +1058,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	check_tsc_sync_source(cpu);
 	local_irq_restore(flags);
 
-	while (!cpu_isset(cpu, cpu_online_map)) {
+	while (!cpu_online(cpu)) {
 		cpu_relax();
 		touch_nmi_watchdog();
 	}
@@ -1168,7 +1168,7 @@ static void __init smp_cpu_index_default(void)
 	int i;
 	struct cpuinfo_x86 *c;
 
-	for_each_cpu_mask(i, cpu_possible_map) {
+	for_each_possible_cpu(i) {
 		c = &cpu_data(i);
 		/* mark all to hotplug */
 		c->cpu_index = NR_CPUS;
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index 6878a9c..ae75109 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <asm/io.h>
+#include <asm/bios_ebda.h>
 #include <asm/mach-summit/mach_mpparse.h>
 
 static struct rio_table_hdr *rio_table_hdr __initdata;
@@ -140,8 +141,8 @@ void __init setup_summit(void)
 	int			i, next_wpeg, next_bus = 0;
 
 	/* The pointer to the EBDA is stored in the word @ phys 0x40E(40:0E) */
-	ptr = *(unsigned short *)phys_to_virt(0x40Eul);
-	ptr = (unsigned long)phys_to_virt(ptr << 4);
+	ptr = get_bios_ebda();
+	ptr = (unsigned long)phys_to_virt(ptr);
 
 	rio_table_hdr = NULL;
 	offset = 0x180;
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index df224a8..a1f07d7 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -195,9 +195,9 @@ static int __cpuinit init_smp_flush(void)
 {
 	int i;
 
-	for_each_cpu_mask(i, cpu_possible_map) {
+	for_each_possible_cpu(i)
 		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
-	}
+
 	return 0;
 }
 core_initcall(init_smp_flush);
diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 6458067..d8ccc3c 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -33,7 +33,7 @@
 
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 #ifndef CONFIG_HOTPLUG_CPU
-.section ".init.data","aw",@progbits
+.section ".cpuinit.data","aw",@progbits
 #else
 .section .rodata,"a",@progbits
 #endif
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 471e694..bde6f63 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -602,7 +602,7 @@ DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
-DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0, 1)
+DO_ERROR_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
 void __kprobes do_general_protection(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 6e2c4ef..8acbf0c 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -113,7 +113,7 @@ static inline void send_QIC_CPI(__u32 cpuset, __u8 cpi)
 	for_each_online_cpu(cpu) {
 		if (cpuset & (1 << cpu)) {
 #ifdef VOYAGER_DEBUG
-			if (!cpu_isset(cpu, cpu_online_map))
+			if (!cpu_online(cpu))
 				VDEBUG(("CPU%d sending cpi %d to CPU%d not in "
 					"cpu_online_map\n",
 					hard_smp_processor_id(), cpi, cpu));
@@ -683,9 +683,9 @@ void __init smp_boot_cpus(void)
 	 * Code added from smpboot.c */
 	{
 		unsigned long bogosum = 0;
-		for (i = 0; i < NR_CPUS; i++)
-			if (cpu_isset(i, cpu_online_map))
-				bogosum += cpu_data(i).loops_per_jiffy;
+
+		for_each_online_cpu(i)
+			bogosum += cpu_data(i).loops_per_jiffy;
 		printk(KERN_INFO "Total of %d processors activated "
 		       "(%lu.%02lu BogoMIPS).\n",
 		       cpucount + 1, bogosum / (500000 / HZ),
@@ -1838,7 +1838,7 @@ static int __cpuinit voyager_cpu_up(unsigned int cpu)
 		return -EIO;
 	/* Unleash the CPU! */
 	cpu_set(cpu, smp_commenced_mask);
-	while (!cpu_isset(cpu, cpu_online_map))
+	while (!cpu_online(cpu))
 		mb();
 	return 0;
 }
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index baf7c4f..4a47618 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -566,9 +566,9 @@ void __init paging_init(void)
 
 /*
  * Test if the WP bit works in supervisor mode. It isn't supported on 386's
- * and also on some strange 486's (NexGen etc.). All 586+'s are OK. This
- * used to involve black magic jumps to work around some nasty CPU bugs,
- * but fortunately the switch to using exceptions got rid of all that.
+ * and also on some strange 486's. All 586+'s are OK. This used to involve
+ * black magic jumps to work around some nasty CPU bugs, but fortunately the
+ * switch to using exceptions got rid of all that.
  */
 static void __init test_wp_bit(void)
 {
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 92dd3db..94e6900 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -193,7 +193,7 @@ void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 
 	/* Restrict the possible_map according to max_cpus. */
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
-		for (cpu = NR_CPUS-1; !cpu_isset(cpu, cpu_possible_map); cpu--)
+		for (cpu = NR_CPUS - 1; !cpu_possible(cpu); cpu--)
 			continue;
 		cpu_clear(cpu, cpu_possible_map);
 	}
diff --git a/include/asm-x86/bios_ebda.h b/include/asm-x86/bios_ebda.h
index 9cbd9a6..b4a46b7 100644
--- a/include/asm-x86/bios_ebda.h
+++ b/include/asm-x86/bios_ebda.h
@@ -1,6 +1,8 @@
 #ifndef _MACH_BIOS_EBDA_H
 #define _MACH_BIOS_EBDA_H
 
+#include <asm/io.h>
+
 /*
  * there is a real-mode segmented pointer pointing to the
  * 4K EBDA area at 0x40E.
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 0c9e17c..d593e14 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_IO_APIC_H
 #define __ASM_IO_APIC_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
@@ -110,11 +110,13 @@ extern int nr_ioapic_registers[MAX_IO_APICS];
  * MP-BIOS irq configuration table structures:
  */
 
+#define MP_MAX_IOAPIC_PIN 127
+
 struct mp_ioapic_routing {
 	int apic_id;
 	int gsi_base;
 	int gsi_end;
-	u32 pin_programmed[4];
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 };
 
 /* I/O APIC entries */
diff --git a/include/asm-x86/mach-default/smpboot_hooks.h b/include/asm-x86/mach-default/smpboot_hooks.h
index 3ff2c5b..56d0e1f 100644
--- a/include/asm-x86/mach-default/smpboot_hooks.h
+++ b/include/asm-x86/mach-default/smpboot_hooks.h
@@ -33,7 +33,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 	*((volatile long *) phys_to_virt(0x467)) = 0;
 }
 
-static inline void smpboot_setup_io_apic(void)
+static inline void __init smpboot_setup_io_apic(void)
 {
 	/*
 	 * Here we can be sure that there is an IO-APIC in the system. Let's
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index 168b644..577ab79 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -198,16 +198,16 @@ do {						\
  */
 #define update_mmu_cache(vma, address, pte) do { } while (0)
 
-void native_pagetable_setup_start(pgd_t *base);
-void native_pagetable_setup_done(pgd_t *base);
+extern void native_pagetable_setup_start(pgd_t *base);
+extern void native_pagetable_setup_done(pgd_t *base);
 
 #ifndef CONFIG_PARAVIRT
-static inline void paravirt_pagetable_setup_start(pgd_t *base)
+static inline void __init paravirt_pagetable_setup_start(pgd_t *base)
 {
 	native_pagetable_setup_start(base);
 }
 
-static inline void paravirt_pagetable_setup_done(pgd_t *base)
+static inline void __init paravirt_pagetable_setup_done(pgd_t *base)
 {
 	native_pagetable_setup_done(base);
 }
diff --git a/include/asm-x86/posix_types.h b/include/asm-x86/posix_types.h
index fe312a5..bb7133d 100644
--- a/include/asm-x86/posix_types.h
+++ b/include/asm-x86/posix_types.h
@@ -1,5 +1,11 @@
 #ifdef __KERNEL__
-# if defined(CONFIG_X86_32) || defined(__i386__)
+# ifdef CONFIG_X86_32
+#  include "posix_types_32.h"
+# else
+#  include "posix_types_64.h"
+# endif
+#else
+# ifdef __i386__
 #  include "posix_types_32.h"
 # else
 #  include "posix_types_64.h"
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index e6bf92d..117343b 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -118,7 +118,6 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_CYRIX	1
 #define X86_VENDOR_AMD		2
 #define X86_VENDOR_UMC		3
-#define X86_VENDOR_NEXGEN	4
 #define X86_VENDOR_CENTAUR	5
 #define X86_VENDOR_TRANSMETA	7
 #define X86_VENDOR_NSC		8
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 24ec061..9f922b0 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -231,6 +231,8 @@ extern int do_get_thread_area(struct task_struct *p, int idx,
 extern int do_set_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info, int can_allocate);
 
+#define __ARCH_WANT_COMPAT_SYS_PTRACE
+
 #endif /* __KERNEL__ */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/include/asm-x86/rio.h b/include/asm-x86/rio.h
index 3451c57..c9448bd 100644
--- a/include/asm-x86/rio.h
+++ b/include/asm-x86/rio.h
@@ -60,15 +60,4 @@ enum {
 	ALT_CALGARY	= 5,	/* Second Planar Calgary      */
 };
 
-/*
- * there is a real-mode segmented pointer pointing to the
- * 4K EBDA area at 0x40E.
- */
-static inline unsigned long get_bios_ebda(void)
-{
-	unsigned long address = *(unsigned short *)phys_to_virt(0x40EUL);
-	address <<= 4;
-	return address;
-}
-
 #endif /* __ASM_RIO_H */
diff --git a/include/asm-x86/unistd.h b/include/asm-x86/unistd.h
index effc7ad..2a58ed3 100644
--- a/include/asm-x86/unistd.h
+++ b/include/asm-x86/unistd.h
@@ -1,5 +1,11 @@
 #ifdef __KERNEL__
-# if defined(CONFIG_X86_32) || defined(__i386__)
+# ifdef CONFIG_X86_32
+#  include "unistd_32.h"
+# else
+#  include "unistd_64.h"
+# endif
+#else
+# ifdef __i386__
 #  include "unistd_32.h"
 # else
 #  include "unistd_64.h"
