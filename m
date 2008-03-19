Return-Path: <linux-kernel-owner+w=401wt.eu-S933451AbYCSUaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451AbYCSUaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbYCSTjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbYCSTjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:14 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 79/79] [PATCH] remove smpboot_32.c and smpboot_64.c
Date: Wed, 19 Mar 2008 14:26:14 -0300
Message-Id: <12059479283239-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059479243480-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Remove the last leftovers from the files. Move the ones
that are still used to the files they belong, the others
that grep can't reach, simply throw away.

Merge comments ontop of file and that's it: smpboot integrated

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile     |    4 +-
 arch/x86/kernel/smpboot.c    |   42 ++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   68 ---------------------------------------
 arch/x86/kernel/smpboot_64.c |   73 ------------------------------------------
 arch/x86/pci/numa.c          |    7 +++-
 5 files changed, 50 insertions(+), 144 deletions(-)
 delete mode 100644 arch/x86/kernel/smpboot_32.c
 delete mode 100644 arch/x86/kernel/smpboot_64.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index dc333c8..c3adadd 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -47,10 +47,10 @@ obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
-obj-$(CONFIG_X86_SMP)		+= smpboot_$(BITS).o smp.o
+obj-$(CONFIG_X86_SMP)		+= smp.o
 obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb_$(BITS).o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
-obj-$(CONFIG_X86_64_SMP)	+= smpboot_64.o tsc_sync.o smpcommon.o
+obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse_$(BITS).o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_$(BITS).o nmi_$(BITS).o
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 75637fb..61b9a5b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1,3 +1,44 @@
+/*
+ *	x86 SMP booting functions
+ *
+ *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
+ *	(c) 1998, 1999, 2000 Ingo Molnar <mingo@redhat.com>
+ *	Copyright 2001 Andi Kleen, SuSE Labs.
+ *
+ *	Much of the core SMP work is based on previous work by Thomas Radke, to
+ *	whom a great many thanks are extended.
+ *
+ *	Thanks to Intel for making available several different Pentium,
+ *	Pentium Pro and Pentium-II/Xeon MP machines.
+ *	Original development of Linux SMP code supported by Caldera.
+ *
+ *	This code is released under the GNU General Public License version 2 or
+ *	later.
+ *
+ *	Fixes
+ *		Felix Koop	:	NR_CPUS used properly
+ *		Jose Renau	:	Handle single CPU case.
+ *		Alan Cox	:	By repeated request 8) - Total BogoMIPS report.
+ *		Greg Wright	:	Fix for kernel stacks panic.
+ *		Erich Boleyn	:	MP v1.4 and additional changes.
+ *	Matthias Sattler	:	Changes for 2.1 kernel map.
+ *	Michel Lespinasse	:	Changes for 2.1 kernel map.
+ *	Michael Chastain	:	Change trampoline.S to gnu as.
+ *		Alan Cox	:	Dumb bug: 'B' step PPro's are fine
+ *		Ingo Molnar	:	Added APIC timers, based on code
+ *					from Jose Renau
+ *		Ingo Molnar	:	various cleanups and rewrites
+ *		Tigran Aivazian	:	fixed "0.00 in /proc/uptime on SMP" bug.
+ *	Maciej W. Rozycki	:	Bits for genuine 82489DX APICs
+ *	Andi Kleen		:	Changed for SMP boot into long mode.
+ *		Martin J. Bligh	: 	Added support for multi-quad systems
+ *		Dave Jones	:	Report invalid combinations of Athlon CPUs.
+ *		Rusty Russell	:	Hacked into shape for new "hotplug" boot process.
+ *      Andi Kleen              :       Converted to new state machine.
+ *	Ashok Raj		: 	CPU hotplug support
+ *	Glauber Costa		:	i386 and x86_64 integration
+ */
+
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/module.h>
@@ -44,6 +85,7 @@ u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
 void *x86_bios_cpu_apicid_early_ptr;
 DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
+u8 apicid_2_node[MAX_APICID];
 #endif
 
 /* State of each CPU */
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
deleted file mode 100644
index 3590afe..0000000
--- a/arch/x86/kernel/smpboot_32.c
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- *	x86 SMP booting functions
- *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
- *	(c) 1998, 1999, 2000 Ingo Molnar <mingo@redhat.com>
- *
- *	Much of the core SMP work is based on previous work by Thomas Radke, to
- *	whom a great many thanks are extended.
- *
- *	Thanks to Intel for making available several different Pentium,
- *	Pentium Pro and Pentium-II/Xeon MP machines.
- *	Original development of Linux SMP code supported by Caldera.
- *
- *	This code is released under the GNU General Public License version 2 or
- *	later.
- *
- *	Fixes
- *		Felix Koop	:	NR_CPUS used properly
- *		Jose Renau	:	Handle single CPU case.
- *		Alan Cox	:	By repeated request 8) - Total BogoMIPS report.
- *		Greg Wright	:	Fix for kernel stacks panic.
- *		Erich Boleyn	:	MP v1.4 and additional changes.
- *	Matthias Sattler	:	Changes for 2.1 kernel map.
- *	Michel Lespinasse	:	Changes for 2.1 kernel map.
- *	Michael Chastain	:	Change trampoline.S to gnu as.
- *		Alan Cox	:	Dumb bug: 'B' step PPro's are fine
- *		Ingo Molnar	:	Added APIC timers, based on code
- *					from Jose Renau
- *		Ingo Molnar	:	various cleanups and rewrites
- *		Tigran Aivazian	:	fixed "0.00 in /proc/uptime on SMP" bug.
- *	Maciej W. Rozycki	:	Bits for genuine 82489DX APICs
- *		Martin J. Bligh	: 	Added support for multi-quad systems
- *		Dave Jones	:	Report invalid combinations of Athlon CPUs.
-*		Rusty Russell	:	Hacked into shape for new "hotplug" boot process. */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-
-#include <linux/mm.h>
-#include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/bootmem.h>
-#include <linux/notifier.h>
-#include <linux/cpu.h>
-#include <linux/percpu.h>
-#include <linux/nmi.h>
-
-#include <linux/delay.h>
-#include <linux/mc146818rtc.h>
-#include <asm/tlbflush.h>
-#include <asm/desc.h>
-#include <asm/arch_hooks.h>
-#include <asm/nmi.h>
-
-#include <mach_apic.h>
-#include <mach_wakecpu.h>
-#include <smpboot_hooks.h>
-#include <asm/vmi.h>
-#include <asm/mtrr.h>
-
-u8 apicid_2_node[MAX_APICID];
-
-/* Where the IO area was mapped on multiquad, always 0 otherwise */
-void *xquad_portio;
-#ifdef CONFIG_X86_NUMAQ
-EXPORT_SYMBOL(xquad_portio);
-#endif
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
deleted file mode 100644
index 66b5562..0000000
--- a/arch/x86/kernel/smpboot_64.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- *	x86 SMP booting functions
- *
- *	(c) 1995 Alan Cox, Building #3 <alan@redhat.com>
- *	(c) 1998, 1999, 2000 Ingo Molnar <mingo@redhat.com>
- *	Copyright 2001 Andi Kleen, SuSE Labs.
- *
- *	Much of the core SMP work is based on previous work by Thomas Radke, to
- *	whom a great many thanks are extended.
- *
- *	Thanks to Intel for making available several different Pentium,
- *	Pentium Pro and Pentium-II/Xeon MP machines.
- *	Original development of Linux SMP code supported by Caldera.
- *
- *	This code is released under the GNU General Public License version 2
- *
- *	Fixes
- *		Felix Koop	:	NR_CPUS used properly
- *		Jose Renau	:	Handle single CPU case.
- *		Alan Cox	:	By repeated request 8) - Total BogoMIP report.
- *		Greg Wright	:	Fix for kernel stacks panic.
- *		Erich Boleyn	:	MP v1.4 and additional changes.
- *	Matthias Sattler	:	Changes for 2.1 kernel map.
- *	Michel Lespinasse	:	Changes for 2.1 kernel map.
- *	Michael Chastain	:	Change trampoline.S to gnu as.
- *		Alan Cox	:	Dumb bug: 'B' step PPro's are fine
- *		Ingo Molnar	:	Added APIC timers, based on code
- *					from Jose Renau
- *		Ingo Molnar	:	various cleanups and rewrites
- *		Tigran Aivazian	:	fixed "0.00 in /proc/uptime on SMP" bug.
- *	Maciej W. Rozycki	:	Bits for genuine 82489DX APICs
- *	Andi Kleen		:	Changed for SMP boot into long mode.
- *		Rusty Russell	:	Hacked into shape for new "hotplug" boot process.
- *      Andi Kleen              :       Converted to new state machine.
- *					Various cleanups.
- *					Probably mostly hotplug CPU ready now.
- *	Ashok Raj			: CPU hotplug support
- */
-
-
-#include <linux/init.h>
-
-#include <linux/mm.h>
-#include <linux/kernel_stat.h>
-#include <linux/bootmem.h>
-#include <linux/thread_info.h>
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/mc146818rtc.h>
-#include <linux/smp.h>
-#include <linux/kdebug.h>
-
-#include <asm/acpi.h>
-#include <asm/mtrr.h>
-#include <asm/pgalloc.h>
-#include <asm/desc.h>
-#include <asm/tlbflush.h>
-#include <asm/proto.h>
-#include <asm/nmi.h>
-#include <asm/irq.h>
-#include <asm/hw_irq.h>
-#include <asm/numa.h>
-
-#include <mach_wakecpu.h>
-#include <mach_apic.h>
-#include <smpboot_hooks.h>
-#include <mach_apic.h>
-
-/* Set when the idlers are all forked */
-int smp_threads_ready;
-
-cycles_t cacheflush_time;
-unsigned long cache_decay_ticks;
diff --git a/arch/x86/pci/numa.c b/arch/x86/pci/numa.c
index 9e30378..79d0a98 100644
--- a/arch/x86/pci/numa.c
+++ b/arch/x86/pci/numa.c
@@ -20,7 +20,12 @@ int mp_bus_id_to_local[MAX_MP_BUSSES];
 int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 #define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
 
-extern void *xquad_portio;    /* Where the IO area was mapped */
+/* Where the IO area was mapped on multiquad, always 0 otherwise */
+void *xquad_portio;
+#ifdef CONFIG_X86_NUMAQ
+EXPORT_SYMBOL(xquad_portio);
+#endif
+
 #define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
 
 #define PCI_CONF1_MQ_ADDRESS(bus, devfn, reg) \
-- 
1.5.0.6

