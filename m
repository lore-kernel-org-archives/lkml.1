Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYJMPDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYJMPDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbYJMPDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:03:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36143 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbYJMPDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:03:05 -0400
Date: Mon, 13 Oct 2008 17:02:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86-core-v4-for-linus
Message-ID: <20081013150216.GA3230@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest x86-core-v4-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-core-v4-for-linus

it merges:

   oprofile
   timers/hpet           # the timers/hpet-percpu bits come later
   x86/traps [v2] 
   x86/time [v2]
   x86/core misc items

out-of-topic modifications in x86-core-v4-for-linus:
----------------------------------------------------
arch/Kconfig                       # 852402c: x86/oprofile: add CONFIG_OPROFILE
drivers/char/hpet.c                # f26ed11: HPET: Remove spurious HPET busy w
                                   # f92a789: hpet: /dev/hpet - fixes and clean
                                   # 64a76f6: hpet: /dev/hpet - fixes and clean
                                   # 70ef6d5: x86: get irq for hpet timer
drivers/oprofile/buffer_sync.c     # 852402c: x86/oprofile: add CONFIG_OPROFILE
                                   # 345c257: x86/oprofile: add IBS support for
                                   # 5e11f98: OProfile: moving increment_tail()
                                   # 73185e0: drivers/oprofile: coding style fi
drivers/oprofile/cpu_buffer.c      # bd17b62: oprofile: fix printk in cpu_buffe
                                   # 852402c: x86/oprofile: add CONFIG_OPROFILE
                                   # 345c257: x86/oprofile: add IBS support for
drivers/oprofile/cpu_buffer.h      # 345c257: x86/oprofile: add IBS support for
include/linux/hpet.h               # 64a76f6: hpet: /dev/hpet - fixes and clean
                                   # 70ef6d5: x86: get irq for hpet timer
include/linux/oprofile.h           # ee648bc: OProfile: add IBS code macros

 Thanks,

	Ingo

------------------>
Alexander van Heukelum (54):
      i386: remove kprobes' restore_interrupts in favour of conditional_sti
      i386: prepare to convert exceptions to interrupts
      i386: convert hardware exception 0 to an interrupt gate
      i386: expand exception 3 DO_TRAP macro
      i386: convert hardware exception 4 to an interrupt gate
      i386: convert hardware exception 5 to an interrupt gate
      i386: convert hardware exception 6 to an interrupt gate
      i386: convert hardware exception 7 to an interrupt gate
      i386: convert hardware exception 9 to an interrupt gate
      i386: convert hardware exception 10 to an interrupt gate
      i386: convert hardware exception 11 to an interrupt gate
      i386: convert hardware exception 12 to an interrupt gate
      i386: convert hardware exception 13 to an interrupt gate
      i386: convert hardware exception 15 to an interrupt gate
      i386: convert hardware exception 16 to an interrupt gate
      i386: convert hardware exception 17 to an interrupt gate
      i386: convert hardware exception 18 to an interrupt gate
      i386: convert hardware exception 19 to an interrupt gate
      i386: remove temporary DO_TRAP macros, expanding the last one used
      i386: add TRACE_IRQS_OFF to entry_32.S in 'error_code'
      i386: add TRACE_IRQS_OFF for exception 1 (debug)
      i386: add TRACE_IRQS_OFF for the nmi
      i386: add TRACE_IRQS_OFF for the exception 3 (int3)
      i386: trace_hardirqs_fixup should now not be necessary: irqs are off.
      traps: x86_64: add TRACE_IRQS_OFF in error_entry
      traps: x86_64: add TRACE_IRQS_OFF in paranoidentry macro
      traps: x86_64: remove trace_hardirqs_fixup from DO_ERROR_INFO macro
      traps: x86_64: remove trace_hardirqs_fixup from int3 handler
      traps: x86_64: remove trace_hardirqs_fixup from debug handler
      traps: x86: remove trace_hardirqs_fixup from pagefault handler
      traps: i386: make do_trap more like x86_64
      i386: split out dumpstack code from traps_32.c
      x86_64: split out dumpstack code from traps_64.c
      x86, traps: split out math_error and simd_math_error
      x86, traps, i386: factor out lazy io-bitmap copy
      x86, traps: introduce dotraplinkage
      x86, traps: converge do_debug handlers
      traps: x86: converge trap_init functions
      traps: x86_64: make math_state_restore more like i386
      traps: i386: use preempt_conditional_sti/cli in do_int3
      traps: x86_64: make io_check_error equal to the one on i386
      traps: i386: expand clear_mem_error and remove from mach_traps.h
      traps: x86_64: use task_pid_nr(tsk) instead of tsk->pid in do_general_protection
      traps: x86: various noop-changes preparing for unification of traps_xx.c
      traps: x86: make traps_32.c and traps_64.c equal
      traps: x86: finalize unification of traps.c
      dumpstack: x86: move die_nmi to dumpstack_32.c
      dumpstack: x86: make printk_address equal
      dumpstack: x86: add "end" parameter to valid_stack_ptr and print_context_stack
      dumptrace: x86: consistently include loglevel, print stack switch
      dumpstack: x86: use log_lvl and unify trace formatting
      dumpstack: i386: make kstack= an early boot-param and add oops=panic
      dumpstack: x86: various small unification steps
      dumpstack: x86: various small unification steps, fix

Andreas Herrmann (1):
      x86: hpet: modify IXP400 quirk to enable interrupts

Barry Kasindorf (3):
      oprofile: Add support for AMD Family 11h
      x86/oprofile: add IBS support for AMD CPUs, IBS buffer handling routines
      x86/oprofile: add IBS support for AMD CPUs, model specific code

Chuck Ebbert (2):
      x86: move prefill_possible_map calling early, fix, V2
      x86: allow number of additional hotplug CPUs to be set at compile time, V2

Cyrill Gorcunov (1):
      x86: smpboot - check if we have ESR register in wakeup_secondary_cpu

David Brownell (2):
      hpet: /dev/hpet - fixes and cleanup
      hpet: /dev/hpet - fixes and cleanup, fix

David John (1):
      HPET: Remove spurious HPET busy warning message.

Glauber Costa (13):
      x86: use user_mode macro
      x86: coalesce tests
      x86: set bp field in pt_regs properly
      x86: use frame pointer information on x86_64 profile_pc
      x86: remove SEGMENT_IS_FLAT_CODE
      x86: use user_mode_vm instead of user_mode
      x86: bind irq0 irq data to cpu0
      x86: factor out irq initialization for x86_64
      x86: make init_ISA_irqs nonstatic
      x86: rename timer_event_interrupt to timer_interrupt
      x86: replace hardcoded number
      x86: wrap MCA_bus test around an ifdef
      x86: move vgetcpu mode probing to cpu detection

Ingo Molnar (2):
      x86: print out EBDA/lowmem address
      x86: remove additional_cpus configurability

Jack Steiner (3):
      x86, uv: add early detection of UV system types
      x86, uv: fix for size of hub mappings
      x86, UV: new UV genapic functions for x2apic

Jan Beulich (5):
      x86-64: reduce boot fixmap space
      x86-64: slightly stream-line 32-bit syscall entry code
      x86-64: fix combining of regions in init_memory_mapping()
      x86: make mm/gup.c more virtualization friendly
      x86: adjust dependencies for CONFIG_X86_CMOV

Jeremy Fitzhardinge (5):
      x86: add _PAGE_IOMAP pte flag for IO mappings
      x86: remove duplicate early_ioremap declarations
      x86: add early_memremap()
      x86: use early_memremap() in setup.c
      x86-64: don't check for map replacement

Joe Buehler (1):
      x86: add PCI ID for 6300ESB force hpet

Jordan Crouse (1):
      x86, hpet: SB600 - remove HPET resources from PCI device

Kevin Hao (1):
      x86: get irq for hpet timer

Krzysztof Helt (2):
      x86: merge winchip-2 and winchip-2a cpu choices
      x86: do not allow to optimize flag_is_changeable_p() (rev. 2)

Krzysztof Oledzki (1):
      x86: add another PCI ID for ICH6 force-hpet

Manfred Spraul (1):
      arch/x86/kernel/smpboot.c: Clarify when irq processing begins.

Pekka Enberg (1):
      x86: __show_registers() and __show_regs() API unification

Randy Dunlap (1):
      documentation: move hpet.txt to timers/ subdirectory

Robert Richter (22):
      x86: add PCI IDs for AMD Barcelona PCI devices
      x86: apic_*.c: add description to AMD's extended LVT functions
      x86/oprofile: introduce model specific init/exit functions
      x86/oprofile: Minor changes in op_model_athlon.c
      x86/oprofile: renaming athlon_*() into op_amd_*()
      drivers/oprofile: coding style fixes in buffer_sync.c
      OProfile: moving increment_tail() in buffer_sync.c
      OProfile: add IBS code macros
      x86/oprofile: separating the IBS handler
      OProfile: change IBS interrupt initialization
      OProfile: Fix build error in op_model_athlon.c
      OProfile: on_each_cpu(): kill unused retry parameter
      OProfile: fix setup_ibs_files() function interface
      OProfile: enable IBS for AMD CPUs
      OProfile: fix IBS build error for UP
      x86/oprofile: macro definition cleanup in op_model_athlon.c
      x86/oprofile: op_model_athlon.c: fix counter reset when reenabling IBS OP
      x86: apic: export symbols for extended interrupt LVT functions
      x86: apic: changing export symbols to *_GPL
      x86/oprofile: add CONFIG_OPROFILE_IBS option
      oprofile: fix printk in cpu_buffer.c
      x86/oprofile: reanaming op_model_athlon.c to op_model_amd.c

Thomas Gleixner (2):
      x86: improve UP kernel when CPU-hotplug and SMP is enabled
      x86: remove additional_cpus

Vegard Nossum (2):
      x86: add memory clobber in switch_to()
      x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y, v2

Yinghai Lu (5):
      x86: rename discontig_32.c to numa_32.c
      x86: check dsdt before find oem table for es7000, v2
      x86: cpu don't print duplicated vendor string
      x86: cleanup, remove extra ifdef
      x86: change early_ioremap to use slots instead of nesting


 Documentation/00-INDEX                    |    2 -
 Documentation/timers/00-INDEX             |   10 +
 Documentation/{ => timers}/hpet.txt       |   43 +-
 arch/Kconfig                              |   14 +
 arch/x86/Kconfig.cpu                      |   29 +-
 arch/x86/Makefile_32.cpu                  |    1 -
 arch/x86/configs/i386_defconfig           |    1 -
 arch/x86/configs/x86_64_defconfig         |    1 -
 arch/x86/ia32/ia32entry.S                 |   26 +-
 arch/x86/kernel/Makefile                  |    2 +-
 arch/x86/kernel/alternative.c             |    2 +-
 arch/x86/kernel/apic_32.c                 |    4 +
 arch/x86/kernel/apic_64.c                 |    4 +
 arch/x86/kernel/cpu/common.c              |   45 +-
 arch/x86/kernel/doublefault_32.c          |    2 +-
 arch/x86/kernel/dumpstack_32.c            |  447 +++++++++++
 arch/x86/kernel/dumpstack_64.c            |  573 ++++++++++++++
 arch/x86/kernel/entry_32.S                |   22 +-
 arch/x86/kernel/entry_64.S                |   15 +-
 arch/x86/kernel/es7000_32.c               |   28 +-
 arch/x86/kernel/genx2apic_uv_x.c          |   23 +-
 arch/x86/kernel/head.c                    |    1 +
 arch/x86/kernel/hpet.c                    |    6 +-
 arch/x86/kernel/irqinit_64.c              |   43 +-
 arch/x86/kernel/process_32.c              |    4 +-
 arch/x86/kernel/process_64.c              |    7 +-
 arch/x86/kernel/quirks.c                  |   41 +-
 arch/x86/kernel/setup.c                   |   10 +-
 arch/x86/kernel/smpboot.c                 |   87 +--
 arch/x86/kernel/time_32.c                 |    7 +-
 arch/x86/kernel/time_64.c                 |   23 +-
 arch/x86/kernel/{traps_32.c => traps.c}   |  893 ++++++++-------------
 arch/x86/kernel/traps_64.c                | 1214 -----------------------------
 arch/x86/mach-generic/es7000.c            |   20 +-
 arch/x86/mm/Makefile                      |    6 +-
 arch/x86/mm/fault.c                       |    5 -
 arch/x86/mm/gup.c                         |   10 +-
 arch/x86/mm/init_32.c                     |    2 +-
 arch/x86/mm/init_64.c                     |    9 +-
 arch/x86/mm/ioremap.c                     |  143 +++-
 arch/x86/mm/{discontig_32.c => numa_32.c} |    0
 arch/x86/mm/srat_64.c                     |    2 +-
 arch/x86/oprofile/Makefile                |    2 +-
 arch/x86/oprofile/nmi_int.c               |   27 +-
 arch/x86/oprofile/op_model_amd.c          |  543 +++++++++++++
 arch/x86/oprofile/op_model_athlon.c       |  190 -----
 arch/x86/oprofile/op_x86_model.h          |    4 +-
 arch/x86/pci/fixup.c                      |   28 +
 drivers/char/hpet.c                       |  159 +++--
 drivers/oprofile/buffer_sync.c            |  209 ++++--
 drivers/oprofile/cpu_buffer.c             |   74 ++-
 drivers/oprofile/cpu_buffer.h             |    2 +
 include/asm-x86/desc.h                    |   14 +-
 include/asm-x86/es7000/mpparse.h          |    1 +
 include/asm-x86/fixmap_32.h               |    4 +-
 include/asm-x86/fixmap_64.h               |   12 +-
 include/asm-x86/io.h                      |   15 +-
 include/asm-x86/io_64.h                   |    3 -
 include/asm-x86/irqflags.h                |   21 -
 include/asm-x86/kdebug.h                  |    3 +-
 include/asm-x86/kprobes.h                 |    9 -
 include/asm-x86/mach-default/mach_traps.h |    6 -
 include/asm-x86/module.h                  |    2 -
 include/asm-x86/nmi.h                     |    4 -
 include/asm-x86/page.h                    |    8 +-
 include/asm-x86/page_32.h                 |   10 +-
 include/asm-x86/pgtable.h                 |   16 +-
 include/asm-x86/ptrace.h                  |    4 -
 include/asm-x86/segment.h                 |    6 -
 include/asm-x86/smp.h                     |    8 +-
 include/asm-x86/system.h                  |    5 +-
 include/asm-x86/traps.h                   |   73 +-
 include/linux/hpet.h                      |   14 +-
 include/linux/oprofile.h                  |    2 +
 74 files changed, 2793 insertions(+), 2512 deletions(-)
 create mode 100644 Documentation/timers/00-INDEX
 rename Documentation/{ => timers}/hpet.txt (81%)
 create mode 100644 arch/x86/kernel/dumpstack_32.c
 create mode 100644 arch/x86/kernel/dumpstack_64.c
 rename arch/x86/kernel/{traps_32.c => traps.c} (57%)
 delete mode 100644 arch/x86/kernel/traps_64.c
 rename arch/x86/mm/{discontig_32.c => numa_32.c} (100%)
 create mode 100644 arch/x86/oprofile/op_model_amd.c
 delete mode 100644 arch/x86/oprofile/op_model_athlon.c

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 7306081..4382778 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -159,8 +159,6 @@ hayes-esp.txt
 	- info on using the Hayes ESP serial driver.
 highuid.txt
 	- notes on the change from 16 bit to 32 bit user/group IDs.
-hpet.txt
-	- High Precision Event Timer Driver for Linux.
 timers/
 	- info on the timer related topics
 hw_random.txt
diff --git a/Documentation/timers/00-INDEX b/Documentation/timers/00-INDEX
new file mode 100644
index 0000000..397dc35
--- /dev/null
+++ b/Documentation/timers/00-INDEX
@@ -0,0 +1,10 @@
+00-INDEX
+	- this file
+highres.txt
+	- High resolution timers and dynamic ticks design notes
+hpet.txt
+	- High Precision Event Timer Driver for Linux
+hrtimers.txt
+	- subsystem for high-resolution kernel timers
+timer_stats.txt
+	- timer usage statistics
diff --git a/Documentation/hpet.txt b/Documentation/timers/hpet.txt
similarity index 81%
rename from Documentation/hpet.txt
rename to Documentation/timers/hpet.txt
index 6ad52d9..e7c09ab 100644
--- a/Documentation/hpet.txt
+++ b/Documentation/timers/hpet.txt
@@ -1,21 +1,32 @@
 		High Precision Event Timer Driver for Linux
 
-The High Precision Event Timer (HPET) hardware is the future replacement
-for the 8254 and Real Time Clock (RTC) periodic timer functionality.
-Each HPET can have up to 32 timers.  It is possible to configure the
-first two timers as legacy replacements for 8254 and RTC periodic timers.
-A specification done by Intel and Microsoft can be found at
-<http://www.intel.com/technology/architecture/hpetspec.htm>.
+The High Precision Event Timer (HPET) hardware follows a specification
+by Intel and Microsoft which can be found at
+
+	http://www.intel.com/technology/architecture/hpetspec.htm
+
+Each HPET has one fixed-rate counter (at 10+ MHz, hence "High Precision")
+and up to 32 comparators.  Normally three or more comparators are provided,
+each of which can generate oneshot interupts and at least one of which has
+additional hardware to support periodic interrupts.  The comparators are
+also called "timers", which can be misleading since usually timers are
+independent of each other ... these share a counter, complicating resets.
+
+HPET devices can support two interrupt routing modes.  In one mode, the
+comparators are additional interrupt sources with no particular system
+role.  Many x86 BIOS writers don't route HPET interrupts at all, which
+prevents use of that mode.  They support the other "legacy replacement"
+mode where the first two comparators block interrupts from 8254 timers
+and from the RTC.
 
 The driver supports detection of HPET driver allocation and initialization
 of the HPET before the driver module_init routine is called.  This enables
 platform code which uses timer 0 or 1 as the main timer to intercept HPET
 initialization.  An example of this initialization can be found in
-arch/i386/kernel/time_hpet.c.
+arch/x86/kernel/hpet.c.
 
-The driver provides two APIs which are very similar to the API found in
-the rtc.c driver.  There is a user space API and a kernel space API.
-An example user space program is provided below.
+The driver provides a userspace API which resembles the API found in the
+RTC driver framework.  An example user space program is provided below.
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -286,15 +297,3 @@ out:
 
 	return;
 }
-
-The kernel API has three interfaces exported from the driver:
-
-	hpet_register(struct hpet_task *tp, int periodic)
-	hpet_unregister(struct hpet_task *tp)
-	hpet_control(struct hpet_task *tp, unsigned int cmd, unsigned long arg)
-
-The kernel module using this interface fills in the ht_func and ht_data
-members of the hpet_task structure before calling hpet_register.
-hpet_control simply vectors to the hpet_ioctl routine and has the same
-commands and respective arguments as the user API.  hpet_unregister
-is used to terminate usage of the HPET timer reserved by hpet_register.
diff --git a/arch/Kconfig b/arch/Kconfig
index 364c6da..0267bab 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -13,6 +13,20 @@ config OPROFILE
 
 	  If unsure, say N.
 
+config OPROFILE_IBS
+	bool "OProfile AMD IBS support (EXPERIMENTAL)"
+	default n
+	depends on OPROFILE && SMP && X86
+	help
+          Instruction-Based Sampling (IBS) is a new profiling
+          technique that provides rich, precise program performance
+          information. IBS is introduced by AMD Family10h processors
+          (AMD Opteron Quad-Core processor “Barcelona”) to overcome
+          the limitations of conventional performance counter
+          sampling.
+
+	  If unsure, say N.
+
 config HAVE_OPROFILE
 	def_bool n
 
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index c5f1013..0b7c4a3 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -38,8 +38,7 @@ config M386
 	  - "Crusoe" for the Transmeta Crusoe series.
 	  - "Efficeon" for the Transmeta Efficeon series.
 	  - "Winchip-C6" for original IDT Winchip.
-	  - "Winchip-2" for IDT Winchip 2.
-	  - "Winchip-2A" for IDT Winchips with 3dNow! capabilities.
+	  - "Winchip-2" for IDT Winchips with 3dNow! capabilities.
 	  - "GeodeGX1" for Geode GX1 (Cyrix MediaGX).
 	  - "Geode GX/LX" For AMD Geode GX and LX processors.
 	  - "CyrixIII/VIA C3" for VIA Cyrix III or VIA C3.
@@ -194,19 +193,11 @@ config MWINCHIPC6
 	  treat this chip as a 586TSC with some extended instructions
 	  and alignment requirements.
 
-config MWINCHIP2
-	bool "Winchip-2"
-	depends on X86_32
-	help
-	  Select this for an IDT Winchip-2.  Linux and GCC
-	  treat this chip as a 586TSC with some extended instructions
-	  and alignment requirements.
-
 config MWINCHIP3D
-	bool "Winchip-2A/Winchip-3"
+	bool "Winchip-2/Winchip-2A/Winchip-3"
 	depends on X86_32
 	help
-	  Select this for an IDT Winchip-2A or 3.  Linux and GCC
+	  Select this for an IDT Winchip-2, 2A or 3.  Linux and GCC
 	  treat this chip as a 586TSC with some extended instructions
 	  and alignment requirements.  Also enable out of order memory
 	  stores for this CPU, which can increase performance of some
@@ -318,7 +309,7 @@ config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || X86_GENERIC || GENERIC_CPU || MPSC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
-	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
+	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
 
 config X86_XADD
@@ -360,7 +351,7 @@ config X86_POPAD_OK
 
 config X86_ALIGNMENT_16
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
 
 config X86_INTEL_USERCOPY
 	def_bool y
@@ -368,7 +359,7 @@ config X86_INTEL_USERCOPY
 
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2
 
 config X86_USE_3DNOW
 	def_bool y
@@ -376,7 +367,7 @@ config X86_USE_3DNOW
 
 config X86_OOSTORE
 	def_bool y
-	depends on (MWINCHIP3D || MWINCHIP2 || MWINCHIPC6) && MTRR
+	depends on (MWINCHIP3D || MWINCHIPC6) && MTRR
 
 #
 # P6_NOPs are a relatively minor optimization that require a family >=
@@ -396,7 +387,7 @@ config X86_P6_NOP
 
 config X86_TSC
 	def_bool y
-	depends on ((MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
+	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
 
 config X86_CMPXCHG64
 	def_bool y
@@ -406,7 +397,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || X86_64)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
@@ -417,7 +408,7 @@ config X86_MINIMUM_CPU_FAMILY
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(MK6 || MWINCHIPC6 || MWINCHIP2 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
 
 menuconfig PROCESSOR_SELECT
 	bool "Supported processor vendors" if EMBEDDED
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index b72b4f7..80177ec 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -28,7 +28,6 @@ cflags-$(CONFIG_MK8)		+= $(call cc-option,-march=k8,-march=athlon)
 cflags-$(CONFIG_MCRUSOE)	+= -march=i686 $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MEFFICEON)	+= -march=i686 $(call tune,pentium3) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MWINCHIPC6)	+= $(call cc-option,-march=winchip-c6,-march=i586)
-cflags-$(CONFIG_MWINCHIP2)	+= $(call cc-option,-march=winchip2,-march=i586)
 cflags-$(CONFIG_MWINCHIP3D)	+= $(call cc-option,-march=winchip2,-march=i586)
 cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index ca226ca..52d0359 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -213,7 +213,6 @@ CONFIG_M686=y
 # CONFIG_MCRUSOE is not set
 # CONFIG_MEFFICEON is not set
 # CONFIG_MWINCHIPC6 is not set
-# CONFIG_MWINCHIP2 is not set
 # CONFIG_MWINCHIP3D is not set
 # CONFIG_MGEODEGX1 is not set
 # CONFIG_MGEODE_LX is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 2c4b1c7..f0a03d7 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -210,7 +210,6 @@ CONFIG_X86_PC=y
 # CONFIG_MCRUSOE is not set
 # CONFIG_MEFFICEON is not set
 # CONFIG_MWINCHIPC6 is not set
-# CONFIG_MWINCHIP2 is not set
 # CONFIG_MWINCHIP3D is not set
 # CONFIG_MGEODEGX1 is not set
 # CONFIG_MGEODE_LX is not set
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index ffc1bb4..eb43147 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -39,11 +39,11 @@
 	.endm 
 
 	/* clobbers %eax */	
-	.macro  CLEAR_RREGS
+	.macro  CLEAR_RREGS _r9=rax
 	xorl 	%eax,%eax
 	movq	%rax,R11(%rsp)
 	movq	%rax,R10(%rsp)
-	movq	%rax,R9(%rsp)
+	movq	%\_r9,R9(%rsp)
 	movq	%rax,R8(%rsp)
 	.endm
 
@@ -52,11 +52,10 @@
 	 * We don't reload %eax because syscall_trace_enter() returned
 	 * the value it wants us to use in the table lookup.
 	 */
-	.macro LOAD_ARGS32 offset
-	movl \offset(%rsp),%r11d
-	movl \offset+8(%rsp),%r10d
+	.macro LOAD_ARGS32 offset, _r9=0
+	.if \_r9
 	movl \offset+16(%rsp),%r9d
-	movl \offset+24(%rsp),%r8d
+	.endif
 	movl \offset+40(%rsp),%ecx
 	movl \offset+48(%rsp),%edx
 	movl \offset+56(%rsp),%esi
@@ -145,7 +144,7 @@ ENTRY(ia32_sysenter_target)
 	SAVE_ARGS 0,0,1
  	/* no need to do an access_ok check here because rbp has been
  	   32bit zero extended */ 
-1:	movl	(%rbp),%r9d
+1:	movl	(%rbp),%ebp
  	.section __ex_table,"a"
  	.quad 1b,ia32_badarg
  	.previous	
@@ -157,7 +156,7 @@ ENTRY(ia32_sysenter_target)
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	ia32_badsys
 sysenter_do_call:
-	IA32_ARG_FIXUP 1
+	IA32_ARG_FIXUP
 sysenter_dispatch:
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
@@ -234,20 +233,17 @@ sysexit_audit:
 #endif
 
 sysenter_tracesys:
-	xchgl	%r9d,%ebp
 #ifdef CONFIG_AUDITSYSCALL
 	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jz	sysenter_auditsys
 #endif
 	SAVE_REST
 	CLEAR_RREGS
-	movq	%r9,R9(%rsp)
 	movq	$-ENOSYS,RAX(%rsp)/* ptrace can change this for a bad syscall */
 	movq	%rsp,%rdi        /* &pt_regs -> arg1 */
 	call	syscall_trace_enter
 	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
-	xchgl	%ebp,%r9d
 	cmpl	$(IA32_NR_syscalls-1),%eax
 	ja	int_ret_from_sys_call /* sysenter_tracesys has set RAX(%rsp) */
 	jmp	sysenter_do_call
@@ -314,9 +310,9 @@ ENTRY(ia32_cstar_target)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
 	CFI_REMEMBER_STATE
 	jnz   cstar_tracesys
-cstar_do_call:	
 	cmpl $IA32_NR_syscalls-1,%eax
 	ja  ia32_badsys
+cstar_do_call:
 	IA32_ARG_FIXUP 1
 cstar_dispatch:
 	call *ia32_sys_call_table(,%rax,8)
@@ -357,15 +353,13 @@ cstar_tracesys:
 #endif
 	xchgl %r9d,%ebp
 	SAVE_REST
-	CLEAR_RREGS
-	movq %r9,R9(%rsp)
+	CLEAR_RREGS r9
 	movq $-ENOSYS,RAX(%rsp)	/* ptrace can change this for a bad syscall */
 	movq %rsp,%rdi        /* &pt_regs -> arg1 */
 	call syscall_trace_enter
-	LOAD_ARGS32 ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	LOAD_ARGS32 ARGOFFSET, 1  /* reload args from stack in case ptrace changed it */
 	RESTORE_REST
 	xchgl %ebp,%r9d
-	movl RSP-ARGOFFSET(%rsp), %r8d
 	cmpl $(IA32_NR_syscalls-1),%eax
 	ja int_ret_from_sys_call /* cstar_tracesys has set RAX(%rsp) */
 	jmp cstar_do_call
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5098585..0d41f03 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -23,7 +23,7 @@ CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
-obj-y			+= traps_$(BITS).o irq_$(BITS).o
+obj-y			+= traps.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index fb04e49..a84ac7b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -444,7 +444,7 @@ void __init alternative_instructions(void)
 					    _text, _etext);
 
 		/* Only switch to UP mode if we don't immediately boot others */
-		if (num_possible_cpus() == 1 || setup_max_cpus <= 1)
+		if (num_present_cpus() == 1 || setup_max_cpus <= 1)
 			alternatives_smp_switch(0);
 	}
 #endif
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index a91c57c..21c831d 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -295,6 +295,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
  *
  * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
  * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ *
+ * If mask=1, the LVT entry does not generate interrupts while mask=0
+ * enables the vector. See also the BKDGs.
  */
 
 #define APIC_EILVT_LVTOFF_MCE 0
@@ -319,6 +322,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
+EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
 
 /*
  * Program the next event, relative to now
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 53898b6..94ddb69 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -307,6 +307,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
  *
  * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
  * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ *
+ * If mask=1, the LVT entry does not generate interrupts while mask=0
+ * enables the vector. See also the BKDGs.
  */
 
 #define APIC_EILVT_LVTOFF_MCE 0
@@ -331,6 +334,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
+EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
 
 /*
  * Program the next event, relative to now
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index fb789dd..25581dc 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -124,18 +124,25 @@ static inline int flag_is_changeable_p(u32 flag)
 {
 	u32 f1, f2;
 
-	asm("pushfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "movl %0,%1\n\t"
-	    "xorl %2,%0\n\t"
-	    "pushl %0\n\t"
-	    "popfl\n\t"
-	    "pushfl\n\t"
-	    "popl %0\n\t"
-	    "popfl\n\t"
-	    : "=&r" (f1), "=&r" (f2)
-	    : "ir" (flag));
+	/*
+	 * Cyrix and IDT cpus allow disabling of CPUID
+	 * so the code below may return different results
+	 * when it is executed before and after enabling
+	 * the CPUID. Add "volatile" to not allow gcc to
+	 * optimize the subsequent calls to this function.
+	 */
+	asm volatile ("pushfl\n\t"
+		      "pushfl\n\t"
+		      "popl %0\n\t"
+		      "movl %0,%1\n\t"
+		      "xorl %2,%0\n\t"
+		      "pushl %0\n\t"
+		      "popfl\n\t"
+		      "pushfl\n\t"
+		      "popl %0\n\t"
+		      "popfl\n\t"
+		      : "=&r" (f1), "=&r" (f2)
+		      : "ir" (flag));
 
 	return ((f1^f2) & flag) != 0;
 }
@@ -719,12 +726,24 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #endif
 }
 
+#ifdef CONFIG_X86_64
+static void vgetcpu_set_mode(void)
+{
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
+		vgetcpu_mode = VGETCPU_RDTSCP;
+	else
+		vgetcpu_mode = VGETCPU_LSL;
+}
+#endif
+
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
+#else
+	vgetcpu_set_mode();
 #endif
 }
 
@@ -797,7 +816,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	else if (c->cpuid_level >= 0)
 		vendor = c->x86_vendor_id;
 
-	if (vendor && strncmp(c->x86_model_id, vendor, strlen(vendor)))
+	if (vendor && !strstr(c->x86_model_id, vendor))
 		printk(KERN_CONT "%s ", vendor);
 
 	if (c->x86_model_id[0])
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index 395acb1..b4f14c6 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -66,6 +66,6 @@ struct tss_struct doublefault_tss __cacheline_aligned = {
 		.ds		= __USER_DS,
 		.fs		= __KERNEL_PERCPU,
 
-		.__cr3		= __phys_addr_const((unsigned long)swapper_pg_dir)
+		.__cr3		= __pa_nodebug(swapper_pg_dir),
 	}
 };
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
new file mode 100644
index 0000000..201ee35
--- /dev/null
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -0,0 +1,447 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ */
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/uaccess.h>
+#include <linux/utsname.h>
+#include <linux/hardirq.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
+#include <linux/kexec.h>
+#include <linux/bug.h>
+#include <linux/nmi.h>
+
+#include <asm/stacktrace.h>
+
+#define STACKSLOTS_PER_LINE 8
+#define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
+
+int panic_on_unrecovered_nmi;
+int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
+static unsigned int code_bytes = 64;
+static int die_counter;
+
+void printk_address(unsigned long address, int reliable)
+{
+	printk(" [<%p>] %s%pS\n", (void *) address,
+			reliable ? "" : "? ", (void *) address);
+}
+
+static inline int valid_stack_ptr(struct thread_info *tinfo,
+			void *p, unsigned int size, void *end)
+{
+	void *t = tinfo;
+	if (end) {
+		if (p < end && p >= (end-THREAD_SIZE))
+			return 1;
+		else
+			return 0;
+	}
+	return p > t && p < t + THREAD_SIZE - size;
+}
+
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+static inline unsigned long
+print_context_stack(struct thread_info *tinfo,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data,
+		unsigned long *end)
+{
+	struct stack_frame *frame = (struct stack_frame *)bp;
+
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
+		unsigned long addr;
+
+		addr = *stack;
+		if (__kernel_text_address(addr)) {
+			if ((unsigned long) stack == bp + sizeof(long)) {
+				ops->address(data, addr, 1);
+				frame = frame->next_frame;
+				bp = (unsigned long) frame;
+			} else {
+				ops->address(data, addr, bp == 0);
+			}
+		}
+		stack++;
+	}
+	return bp;
+}
+
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data)
+{
+	if (!task)
+		task = current;
+
+	if (!stack) {
+		unsigned long dummy;
+		stack = &dummy;
+		if (task && task != current)
+			stack = (unsigned long *)task->thread.sp;
+	}
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp) {
+		if (task == current) {
+			/* Grab bp right from our regs */
+			get_bp(bp);
+		} else {
+			/* bp is the last reg pushed by switch_to */
+			bp = *(unsigned long *) task->thread.sp;
+		}
+	}
+#endif
+
+	for (;;) {
+		struct thread_info *context;
+
+		context = (struct thread_info *)
+			((unsigned long)stack & (~(THREAD_SIZE - 1)));
+		bp = print_context_stack(context, stack, bp, ops, data, NULL);
+
+		stack = (unsigned long *)context->previous_esp;
+		if (!stack)
+			break;
+		if (ops->stack(data, "IRQ") < 0)
+			break;
+		touch_nmi_watchdog();
+	}
+}
+EXPORT_SYMBOL(dump_trace);
+
+static void
+print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
+{
+	printk(data);
+	print_symbol(msg, symbol);
+	printk("\n");
+}
+
+static void print_trace_warning(void *data, char *msg)
+{
+	printk("%s%s\n", (char *)data, msg);
+}
+
+static int print_trace_stack(void *data, char *name)
+{
+	printk("%s <%s> ", (char *)data, name);
+	return 0;
+}
+
+/*
+ * Print one address/symbol entries per line.
+ */
+static void print_trace_address(void *data, unsigned long addr, int reliable)
+{
+	touch_nmi_watchdog();
+	printk(data);
+	printk_address(addr, reliable);
+}
+
+static const struct stacktrace_ops print_trace_ops = {
+	.warning = print_trace_warning,
+	.warning_symbol = print_trace_warning_symbol,
+	.stack = print_trace_stack,
+	.address = print_trace_address,
+};
+
+static void
+show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp, char *log_lvl)
+{
+	printk("%sCall Trace:\n", log_lvl);
+	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
+}
+
+void show_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp)
+{
+	show_trace_log_lvl(task, regs, stack, bp, "");
+}
+
+static void
+show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *sp, unsigned long bp, char *log_lvl)
+{
+	unsigned long *stack;
+	int i;
+
+	if (sp == NULL) {
+		if (task)
+			sp = (unsigned long *)task->thread.sp;
+		else
+			sp = (unsigned long *)&sp;
+	}
+
+	stack = sp;
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (kstack_end(stack))
+			break;
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
+			printk("\n%s", log_lvl);
+		printk(" %08lx", *stack++);
+		touch_nmi_watchdog();
+	}
+	printk("\n");
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_log_lvl(task, NULL, sp, 0, "");
+}
+
+/*
+ * The architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+	unsigned long bp = 0;
+	unsigned long stack;
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp)
+		get_bp(bp);
+#endif
+
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	show_trace(NULL, NULL, &stack, bp);
+}
+
+EXPORT_SYMBOL(dump_stack);
+
+void show_registers(struct pt_regs *regs)
+{
+	int i;
+
+	print_modules();
+	__show_regs(regs, 0);
+
+	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
+		TASK_COMM_LEN, current->comm, task_pid_nr(current),
+		current_thread_info(), current, task_thread_info(current));
+	/*
+	 * When in-kernel, we also print out the stack and code at the
+	 * time of the fault..
+	 */
+	if (!user_mode_vm(regs)) {
+		unsigned int code_prologue = code_bytes * 43 / 64;
+		unsigned int code_len = code_bytes;
+		unsigned char c;
+		u8 *ip;
+
+		printk(KERN_EMERG "Stack:\n");
+		show_stack_log_lvl(NULL, regs, &regs->sp,
+				0, KERN_EMERG);
+
+		printk(KERN_EMERG "Code: ");
+
+		ip = (u8 *)regs->ip - code_prologue;
+		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
+			/* try starting at IP */
+			ip = (u8 *)regs->ip;
+			code_len = code_len - code_prologue + 1;
+		}
+		for (i = 0; i < code_len; i++, ip++) {
+			if (ip < (u8 *)PAGE_OFFSET ||
+					probe_kernel_address(ip, c)) {
+				printk(" Bad EIP value.");
+				break;
+			}
+			if (ip == (u8 *)regs->ip)
+				printk("<%02x> ", c);
+			else
+				printk("%02x ", c);
+		}
+	}
+	printk("\n");
+}
+
+int is_valid_bugaddr(unsigned long ip)
+{
+	unsigned short ud2;
+
+	if (ip < PAGE_OFFSET)
+		return 0;
+	if (probe_kernel_address((unsigned short *)ip, ud2))
+		return 0;
+
+	return ud2 == 0x0b0f;
+}
+
+static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static int die_owner = -1;
+static unsigned int die_nest_count;
+
+unsigned __kprobes long oops_begin(void)
+{
+	unsigned long flags;
+
+	oops_enter();
+
+	if (die_owner != raw_smp_processor_id()) {
+		console_verbose();
+		raw_local_irq_save(flags);
+		__raw_spin_lock(&die_lock);
+		die_owner = smp_processor_id();
+		die_nest_count = 0;
+		bust_spinlocks(1);
+	} else {
+		raw_local_irq_save(flags);
+	}
+	die_nest_count++;
+	return flags;
+}
+
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+{
+	bust_spinlocks(0);
+	die_owner = -1;
+	add_taint(TAINT_DIE);
+	__raw_spin_unlock(&die_lock);
+	raw_local_irq_restore(flags);
+
+	if (!regs)
+		return;
+
+	if (kexec_should_crash(current))
+		crash_kexec(regs);
+	if (in_interrupt())
+		panic("Fatal exception in interrupt");
+	if (panic_on_oops)
+		panic("Fatal exception");
+	oops_exit();
+	do_exit(signr);
+}
+
+int __kprobes __die(const char *str, struct pt_regs *regs, long err)
+{
+	unsigned short ss;
+	unsigned long sp;
+
+	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
+#ifdef CONFIG_PREEMPT
+	printk("PREEMPT ");
+#endif
+#ifdef CONFIG_SMP
+	printk("SMP ");
+#endif
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk("DEBUG_PAGEALLOC");
+#endif
+	printk("\n");
+	if (notify_die(DIE_OOPS, str, regs, err,
+			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
+
+	show_registers(regs);
+	/* Executive summary in case the oops scrolled away */
+	sp = (unsigned long) (&regs->sp);
+	savesegment(ss, ss);
+	if (user_mode(regs)) {
+		sp = regs->sp;
+		ss = regs->ss & 0xffff;
+	}
+	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
+	print_symbol("%s", regs->ip);
+	printk(" SS:ESP %04x:%08lx\n", ss, sp);
+	return 0;
+}
+
+/*
+ * This is gone through when something in the kernel has done something bad
+ * and is about to be terminated:
+ */
+void die(const char *str, struct pt_regs *regs, long err)
+{
+	unsigned long flags = oops_begin();
+
+	if (die_nest_count < 3) {
+		report_bug(regs->ip, regs);
+
+		if (__die(str, regs, err))
+			regs = NULL;
+	} else {
+		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
+	}
+
+	oops_end(flags, regs, SIGSEGV);
+}
+
+static DEFINE_SPINLOCK(nmi_print_lock);
+
+void notrace __kprobes
+die_nmi(char *str, struct pt_regs *regs, int do_panic)
+{
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
+	spin_lock(&nmi_print_lock);
+	/*
+	* We are in trouble anyway, lets at least try
+	* to get a message out:
+	*/
+	bust_spinlocks(1);
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
+	show_registers(regs);
+	if (do_panic)
+		panic("Non maskable interrupt");
+	console_silent();
+	spin_unlock(&nmi_print_lock);
+	bust_spinlocks(0);
+
+	/*
+	 * If we are in kernel we are probably nested up pretty bad
+	 * and might aswell get out now while we still can:
+	 */
+	if (!user_mode_vm(regs)) {
+		current->thread.trap_no = 2;
+		crash_kexec(regs);
+	}
+
+	do_exit(SIGSEGV);
+}
+
+static int __init oops_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	if (!strcmp(s, "panic"))
+		panic_on_oops = 1;
+	return 0;
+}
+early_param("oops", oops_setup);
+
+static int __init kstack_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+	return 0;
+}
+early_param("kstack", kstack_setup);
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes > 8192)
+		code_bytes = 8192;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
new file mode 100644
index 0000000..086cc81
--- /dev/null
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -0,0 +1,573 @@
+/*
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
+ */
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/uaccess.h>
+#include <linux/utsname.h>
+#include <linux/hardirq.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/ptrace.h>
+#include <linux/kexec.h>
+#include <linux/bug.h>
+#include <linux/nmi.h>
+
+#include <asm/stacktrace.h>
+
+#define STACKSLOTS_PER_LINE 4
+#define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
+
+int panic_on_unrecovered_nmi;
+int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
+static unsigned int code_bytes = 64;
+static int die_counter;
+
+void printk_address(unsigned long address, int reliable)
+{
+	printk(" [<%p>] %s%pS\n", (void *) address,
+			reliable ? "" : "? ", (void *) address);
+}
+
+static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
+					unsigned *usedp, char **idp)
+{
+	static char ids[][8] = {
+		[DEBUG_STACK - 1] = "#DB",
+		[NMI_STACK - 1] = "NMI",
+		[DOUBLEFAULT_STACK - 1] = "#DF",
+		[STACKFAULT_STACK - 1] = "#SS",
+		[MCE_STACK - 1] = "#MC",
+#if DEBUG_STKSZ > EXCEPTION_STKSZ
+		[N_EXCEPTION_STACKS ...
+			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
+#endif
+	};
+	unsigned k;
+
+	/*
+	 * Iterate over all exception stacks, and figure out whether
+	 * 'stack' is in one of them:
+	 */
+	for (k = 0; k < N_EXCEPTION_STACKS; k++) {
+		unsigned long end = per_cpu(orig_ist, cpu).ist[k];
+		/*
+		 * Is 'stack' above this exception frame's end?
+		 * If yes then skip to the next frame.
+		 */
+		if (stack >= end)
+			continue;
+		/*
+		 * Is 'stack' above this exception frame's start address?
+		 * If yes then we found the right frame.
+		 */
+		if (stack >= end - EXCEPTION_STKSZ) {
+			/*
+			 * Make sure we only iterate through an exception
+			 * stack once. If it comes up for the second time
+			 * then there's something wrong going on - just
+			 * break out and return NULL:
+			 */
+			if (*usedp & (1U << k))
+				break;
+			*usedp |= 1U << k;
+			*idp = ids[k];
+			return (unsigned long *)end;
+		}
+		/*
+		 * If this is a debug stack, and if it has a larger size than
+		 * the usual exception stacks, then 'stack' might still
+		 * be within the lower portion of the debug stack:
+		 */
+#if DEBUG_STKSZ > EXCEPTION_STKSZ
+		if (k == DEBUG_STACK - 1 && stack >= end - DEBUG_STKSZ) {
+			unsigned j = N_EXCEPTION_STACKS - 1;
+
+			/*
+			 * Black magic. A large debug stack is composed of
+			 * multiple exception stack entries, which we
+			 * iterate through now. Dont look:
+			 */
+			do {
+				++j;
+				end -= EXCEPTION_STKSZ;
+				ids[j][4] = '1' + (j - N_EXCEPTION_STACKS);
+			} while (stack < end - EXCEPTION_STKSZ);
+			if (*usedp & (1U << j))
+				break;
+			*usedp |= 1U << j;
+			*idp = ids[j];
+			return (unsigned long *)end;
+		}
+#endif
+	}
+	return NULL;
+}
+
+/*
+ * x86-64 can have up to three kernel stacks:
+ * process stack
+ * interrupt stack
+ * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
+ */
+
+static inline int valid_stack_ptr(struct thread_info *tinfo,
+			void *p, unsigned int size, void *end)
+{
+	void *t = tinfo;
+	if (end) {
+		if (p < end && p >= (end-THREAD_SIZE))
+			return 1;
+		else
+			return 0;
+	}
+	return p > t && p < t + THREAD_SIZE - size;
+}
+
+/* The form of the top of the frame on the stack */
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+static inline unsigned long
+print_context_stack(struct thread_info *tinfo,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data,
+		unsigned long *end)
+{
+	struct stack_frame *frame = (struct stack_frame *)bp;
+
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
+		unsigned long addr;
+
+		addr = *stack;
+		if (__kernel_text_address(addr)) {
+			if ((unsigned long) stack == bp + sizeof(long)) {
+				ops->address(data, addr, 1);
+				frame = frame->next_frame;
+				bp = (unsigned long) frame;
+			} else {
+				ops->address(data, addr, bp == 0);
+			}
+		}
+		stack++;
+	}
+	return bp;
+}
+
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data)
+{
+	const unsigned cpu = get_cpu();
+	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
+	unsigned used = 0;
+	struct thread_info *tinfo;
+
+	if (!task)
+		task = current;
+
+	if (!stack) {
+		unsigned long dummy;
+		stack = &dummy;
+		if (task && task != current)
+			stack = (unsigned long *)task->thread.sp;
+	}
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp) {
+		if (task == current) {
+			/* Grab bp right from our regs */
+			get_bp(bp);
+		} else {
+			/* bp is the last reg pushed by switch_to */
+			bp = *(unsigned long *) task->thread.sp;
+		}
+	}
+#endif
+
+	/*
+	 * Print function call entries in all stacks, starting at the
+	 * current stack address. If the stacks consist of nested
+	 * exceptions
+	 */
+	tinfo = task_thread_info(task);
+	for (;;) {
+		char *id;
+		unsigned long *estack_end;
+		estack_end = in_exception_stack(cpu, (unsigned long)stack,
+						&used, &id);
+
+		if (estack_end) {
+			if (ops->stack(data, id) < 0)
+				break;
+
+			bp = print_context_stack(tinfo, stack, bp, ops,
+							data, estack_end);
+			ops->stack(data, "<EOE>");
+			/*
+			 * We link to the next stack via the
+			 * second-to-last pointer (index -2 to end) in the
+			 * exception stack:
+			 */
+			stack = (unsigned long *) estack_end[-2];
+			continue;
+		}
+		if (irqstack_end) {
+			unsigned long *irqstack;
+			irqstack = irqstack_end -
+				(IRQSTACKSIZE - 64) / sizeof(*irqstack);
+
+			if (stack >= irqstack && stack < irqstack_end) {
+				if (ops->stack(data, "IRQ") < 0)
+					break;
+				bp = print_context_stack(tinfo, stack, bp,
+						ops, data, irqstack_end);
+				/*
+				 * We link to the next stack (which would be
+				 * the process stack normally) the last
+				 * pointer (index -1 to end) in the IRQ stack:
+				 */
+				stack = (unsigned long *) (irqstack_end[-1]);
+				irqstack_end = NULL;
+				ops->stack(data, "EOI");
+				continue;
+			}
+		}
+		break;
+	}
+
+	/*
+	 * This handles the process stack:
+	 */
+	bp = print_context_stack(tinfo, stack, bp, ops, data, NULL);
+	put_cpu();
+}
+EXPORT_SYMBOL(dump_trace);
+
+static void
+print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
+{
+	printk(data);
+	print_symbol(msg, symbol);
+	printk("\n");
+}
+
+static void print_trace_warning(void *data, char *msg)
+{
+	printk("%s%s\n", (char *)data, msg);
+}
+
+static int print_trace_stack(void *data, char *name)
+{
+	printk("%s <%s> ", (char *)data, name);
+	return 0;
+}
+
+/*
+ * Print one address/symbol entries per line.
+ */
+static void print_trace_address(void *data, unsigned long addr, int reliable)
+{
+	touch_nmi_watchdog();
+	printk(data);
+	printk_address(addr, reliable);
+}
+
+static const struct stacktrace_ops print_trace_ops = {
+	.warning = print_trace_warning,
+	.warning_symbol = print_trace_warning_symbol,
+	.stack = print_trace_stack,
+	.address = print_trace_address,
+};
+
+static void
+show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp, char *log_lvl)
+{
+	printk("%sCall Trace:\n", log_lvl);
+	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
+}
+
+void show_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp)
+{
+	show_trace_log_lvl(task, regs, stack, bp, "");
+}
+
+static void
+show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *sp, unsigned long bp, char *log_lvl)
+{
+	unsigned long *stack;
+	int i;
+	const int cpu = smp_processor_id();
+	unsigned long *irqstack_end =
+		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
+	unsigned long *irqstack =
+		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
+
+	/*
+	 * debugging aid: "show_stack(NULL, NULL);" prints the
+	 * back trace for this cpu.
+	 */
+
+	if (sp == NULL) {
+		if (task)
+			sp = (unsigned long *)task->thread.sp;
+		else
+			sp = (unsigned long *)&sp;
+	}
+
+	stack = sp;
+	for (i = 0; i < kstack_depth_to_print; i++) {
+		if (stack >= irqstack && stack <= irqstack_end) {
+			if (stack == irqstack_end) {
+				stack = (unsigned long *) (irqstack_end[-1]);
+				printk(" <EOI> ");
+			}
+		} else {
+		if (((long) stack & (THREAD_SIZE-1)) == 0)
+			break;
+		}
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
+			printk("\n%s", log_lvl);
+		printk(" %016lx", *stack++);
+		touch_nmi_watchdog();
+	}
+	printk("\n");
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+}
+
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+	show_stack_log_lvl(task, NULL, sp, 0, "");
+}
+
+/*
+ * The architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+	unsigned long bp = 0;
+	unsigned long stack;
+
+#ifdef CONFIG_FRAME_POINTER
+	if (!bp)
+		get_bp(bp);
+#endif
+
+	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+		current->pid, current->comm, print_tainted(),
+		init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	show_trace(NULL, NULL, &stack, bp);
+}
+EXPORT_SYMBOL(dump_stack);
+
+void show_registers(struct pt_regs *regs)
+{
+	int i;
+	unsigned long sp;
+	const int cpu = smp_processor_id();
+	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
+
+	sp = regs->sp;
+	printk("CPU %d ", cpu);
+	__show_regs(regs, 1);
+	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
+		cur->comm, cur->pid, task_thread_info(cur), cur);
+
+	/*
+	 * When in-kernel, we also print out the stack and code at the
+	 * time of the fault..
+	 */
+	if (!user_mode(regs)) {
+		unsigned int code_prologue = code_bytes * 43 / 64;
+		unsigned int code_len = code_bytes;
+		unsigned char c;
+		u8 *ip;
+
+		printk(KERN_EMERG "Stack:\n");
+		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
+				regs->bp, KERN_EMERG);
+
+		printk(KERN_EMERG "Code: ");
+
+		ip = (u8 *)regs->ip - code_prologue;
+		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
+			/* try starting at IP */
+			ip = (u8 *)regs->ip;
+			code_len = code_len - code_prologue + 1;
+		}
+		for (i = 0; i < code_len; i++, ip++) {
+			if (ip < (u8 *)PAGE_OFFSET ||
+					probe_kernel_address(ip, c)) {
+				printk(" Bad RIP value.");
+				break;
+			}
+			if (ip == (u8 *)regs->ip)
+				printk("<%02x> ", c);
+			else
+				printk("%02x ", c);
+		}
+	}
+	printk("\n");
+}
+
+int is_valid_bugaddr(unsigned long ip)
+{
+	unsigned short ud2;
+
+	if (__copy_from_user(&ud2, (const void __user *) ip, sizeof(ud2)))
+		return 0;
+
+	return ud2 == 0x0b0f;
+}
+
+static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static int die_owner = -1;
+static unsigned int die_nest_count;
+
+unsigned __kprobes long oops_begin(void)
+{
+	int cpu;
+	unsigned long flags;
+
+	oops_enter();
+
+	/* racy, but better than risking deadlock. */
+	raw_local_irq_save(flags);
+	cpu = smp_processor_id();
+	if (!__raw_spin_trylock(&die_lock)) {
+		if (cpu == die_owner)
+			/* nested oops. should stop eventually */;
+		else
+			__raw_spin_lock(&die_lock);
+	}
+	die_nest_count++;
+	die_owner = cpu;
+	console_verbose();
+	bust_spinlocks(1);
+	return flags;
+}
+
+void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+{
+	die_owner = -1;
+	bust_spinlocks(0);
+	die_nest_count--;
+	if (!die_nest_count)
+		/* Nest count reaches zero, release the lock. */
+		__raw_spin_unlock(&die_lock);
+	raw_local_irq_restore(flags);
+	if (!regs) {
+		oops_exit();
+		return;
+	}
+	if (in_interrupt())
+		panic("Fatal exception in interrupt");
+	if (panic_on_oops)
+		panic("Fatal exception");
+	oops_exit();
+	do_exit(signr);
+}
+
+int __kprobes __die(const char *str, struct pt_regs *regs, long err)
+{
+	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
+#ifdef CONFIG_PREEMPT
+	printk("PREEMPT ");
+#endif
+#ifdef CONFIG_SMP
+	printk("SMP ");
+#endif
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk("DEBUG_PAGEALLOC");
+#endif
+	printk("\n");
+	if (notify_die(DIE_OOPS, str, regs, err,
+			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
+
+	show_registers(regs);
+	add_taint(TAINT_DIE);
+	/* Executive summary in case the oops scrolled away */
+	printk(KERN_ALERT "RIP ");
+	printk_address(regs->ip, 1);
+	printk(" RSP <%016lx>\n", regs->sp);
+	if (kexec_should_crash(current))
+		crash_kexec(regs);
+	return 0;
+}
+
+void die(const char *str, struct pt_regs *regs, long err)
+{
+	unsigned long flags = oops_begin();
+
+	if (!user_mode(regs))
+		report_bug(regs->ip, regs);
+
+	if (__die(str, regs, err))
+		regs = NULL;
+	oops_end(flags, regs, SIGSEGV);
+}
+
+notrace __kprobes void
+die_nmi(char *str, struct pt_regs *regs, int do_panic)
+{
+	unsigned long flags;
+
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
+	flags = oops_begin();
+	/*
+	 * We are in trouble anyway, lets at least try
+	 * to get a message out.
+	 */
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
+	show_registers(regs);
+	if (kexec_should_crash(current))
+		crash_kexec(regs);
+	if (do_panic || panic_on_oops)
+		panic("Non maskable interrupt");
+	oops_end(flags, NULL, SIGBUS);
+	nmi_exit();
+	local_irq_enable();
+	do_exit(SIGBUS);
+}
+
+static int __init oops_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	if (!strcmp(s, "panic"))
+		panic_on_oops = 1;
+	return 0;
+}
+early_param("oops", oops_setup);
+
+static int __init kstack_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+	return 0;
+}
+early_param("kstack", kstack_setup);
+
+static int __init code_bytes_setup(char *s)
+{
+	code_bytes = simple_strtoul(s, NULL, 0);
+	if (code_bytes > 8192)
+		code_bytes = 8192;
+
+	return 1;
+}
+__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 109792b..b21fbfa 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -730,6 +730,7 @@ error_code:
 	movl $(__USER_DS), %ecx
 	movl %ecx, %ds
 	movl %ecx, %es
+	TRACE_IRQS_OFF
 	movl %esp,%eax			# pt_regs pointer
 	call *%edi
 	jmp ret_from_exception
@@ -760,20 +761,9 @@ ENTRY(device_not_available)
 	RING0_INT_FRAME
 	pushl $-1			# mark this as an int
 	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	GET_CR0_INTO_EAX
-	testl $0x4, %eax		# EM (math emulation bit)
-	jne device_not_available_emulate
-	preempt_stop(CLBR_ANY)
-	call math_state_restore
-	jmp ret_from_exception
-device_not_available_emulate:
-	pushl $0			# temporary storage for ORIG_EIP
+	pushl $do_device_not_available
 	CFI_ADJUST_CFA_OFFSET 4
-	call math_emulate
-	addl $4, %esp
-	CFI_ADJUST_CFA_OFFSET -4
-	jmp ret_from_exception
+	jmp error_code
 	CFI_ENDPROC
 END(device_not_available)
 
@@ -814,6 +804,7 @@ debug_stack_correct:
 	pushl $-1			# mark this as an int
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	xorl %edx,%edx			# error code 0
 	movl %esp,%eax			# pt_regs pointer
 	call do_debug
@@ -858,6 +849,7 @@ nmi_stack_correct:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
 	call do_nmi
@@ -898,6 +890,7 @@ nmi_espfix_stack:
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	FIXUP_ESPFIX_STACK		# %eax == %esp
 	xorl %edx,%edx			# zero error code
 	call do_nmi
@@ -928,6 +921,7 @@ KPROBE_ENTRY(int3)
 	pushl $-1			# mark this as an int
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
+	TRACE_IRQS_OFF
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
 	call do_int3
@@ -1030,7 +1024,7 @@ ENTRY(machine_check)
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl machine_check_vector
+	pushl $do_machine_check
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index cf3a0b2..1db6ce4 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -667,6 +667,13 @@ END(stub_rt_sigreturn)
 	SAVE_ARGS
 	leaq -ARGOFFSET(%rsp),%rdi	# arg1 for handler
 	pushq %rbp
+	/*
+	 * Save rbp twice: One is for marking the stack frame, as usual, and the
+	 * other, to fill pt_regs properly. This is because bx comes right
+	 * before the last saved register in that structure, and not bp. If the
+	 * base pointer were in the place bx is today, this would not be needed.
+	 */
+	movq %rbp, -8(%rsp)
 	CFI_ADJUST_CFA_OFFSET	8
 	CFI_REL_OFFSET		rbp, 0
 	movq %rsp,%rbp
@@ -932,6 +939,9 @@ END(spurious_interrupt)
 	.if \ist
 	movq	%gs:pda_data_offset, %rbp
 	.endif
+	.if \irqtrace
+	TRACE_IRQS_OFF
+	.endif
 	movq %rsp,%rdi
 	movq ORIG_RAX(%rsp),%rsi
 	movq $-1,ORIG_RAX(%rsp)
@@ -1058,7 +1068,8 @@ KPROBE_ENTRY(error_entry)
 	je  error_kernelspace
 error_swapgs:	
 	SWAPGS
-error_sti:	
+error_sti:
+	TRACE_IRQS_OFF
 	movq %rdi,RDI(%rsp) 	
 	CFI_REL_OFFSET	rdi,RDI
 	movq %rsp,%rdi
@@ -1232,7 +1243,7 @@ ENTRY(simd_coprocessor_error)
 END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
-	zeroentry math_state_restore
+	zeroentry do_device_not_available
 END(device_not_available)
 
 	/* runs on exception stack */
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 849e5cd..f454c78 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -109,6 +109,7 @@ struct oem_table {
 };
 
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
 #endif
 
 struct mip_reg {
@@ -243,21 +244,38 @@ parse_unisys_oem (char *oemptr)
 }
 
 #ifdef CONFIG_ACPI
-int __init
-find_unisys_acpi_oem_table(unsigned long *oem_addr)
+static unsigned long oem_addrX;
+static unsigned long oem_size;
+int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	int i = 0;
-	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
+	acpi_size tbl_size;
+
+	while (ACPI_SUCCESS(acpi_get_table_with_size("OEM1", i++, &header, &tbl_size))) {
 		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
 			struct oem_table *t = (struct oem_table *)header;
-			*oem_addr = (unsigned long)__acpi_map_table(t->OEMTableAddr,
-								    t->OEMTableSize);
+
+			oem_addrX = t->OEMTableAddr;
+			oem_size = t->OEMTableSize;
+			early_acpi_os_unmap_memory(header, tbl_size);
+
+			*oem_addr = (unsigned long)__acpi_map_table(oem_addrX,
+								    oem_size);
 			return 0;
 		}
+		early_acpi_os_unmap_memory(header, tbl_size);
 	}
 	return -1;
 }
+
+void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
+{
+	if (!oem_addr)
+		return;
+
+	__acpi_unmap_table((char *)oem_addr, oem_size);
+}
 #endif
 
 static void
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index ae2ffc8..33581d9 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -114,7 +114,7 @@ static void uv_send_IPI_one(int cpu, int vector)
 	unsigned long val, apicid, lapicid;
 	int pnode;
 
-	apicid = per_cpu(x86_cpu_to_apicid, cpu); /* ZZZ - cache node-local ? */
+	apicid = per_cpu(x86_cpu_to_apicid, cpu);
 	lapicid = apicid & 0x3f;		/* ZZZ macro needed */
 	pnode = uv_apicid_to_pnode(apicid);
 	val =
@@ -202,12 +202,10 @@ static unsigned int phys_pkg_id(int index_msb)
 	return uv_read_apic_id() >> index_msb;
 }
 
-#ifdef ZZZ		/* Needs x2apic patch */
 static void uv_send_IPI_self(int vector)
 {
 	apic_write(APIC_SELF_IPI, vector);
 }
-#endif
 
 struct genapic apic_x2apic_uv_x = {
 	.name = "UV large system",
@@ -215,15 +213,15 @@ struct genapic apic_x2apic_uv_x = {
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = uv_target_cpus,
-	.vector_allocation_domain = uv_vector_allocation_domain,/* Fixme ZZZ */
+	.vector_allocation_domain = uv_vector_allocation_domain,
 	.apic_id_registered = uv_apic_id_registered,
 	.init_apic_ldr = uv_init_apic_ldr,
 	.send_IPI_all = uv_send_IPI_all,
 	.send_IPI_allbutself = uv_send_IPI_allbutself,
 	.send_IPI_mask = uv_send_IPI_mask,
-	/* ZZZ.send_IPI_self = uv_send_IPI_self, */
+	.send_IPI_self = uv_send_IPI_self,
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
-	.phys_pkg_id = phys_pkg_id,	/* Fixme ZZZ */
+	.phys_pkg_id = phys_pkg_id,
 	.get_apic_id = get_apic_id,
 	.set_apic_id = set_apic_id,
 	.apic_id_mask = (0xFFFFFFFFu),
@@ -286,12 +284,13 @@ static __init void map_low_mmrs(void)
 
 enum map_type {map_wb, map_uc};
 
-static __init void map_high(char *id, unsigned long base, int shift, enum map_type map_type)
+static __init void map_high(char *id, unsigned long base, int shift,
+			    int max_pnode, enum map_type map_type)
 {
 	unsigned long bytes, paddr;
 
 	paddr = base << shift;
-	bytes = (1UL << shift);
+	bytes = (1UL << shift) * (max_pnode + 1);
 	printk(KERN_INFO "UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr,
 	       					paddr + bytes);
 	if (map_type == map_uc)
@@ -307,7 +306,7 @@ static __init void map_gru_high(int max_pnode)
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
 	if (gru.s.enable)
-		map_high("GRU", gru.s.base, shift, map_wb);
+		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
 }
 
 static __init void map_config_high(int max_pnode)
@@ -317,7 +316,7 @@ static __init void map_config_high(int max_pnode)
 
 	cfg.v = uv_read_local_mmr(UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR);
 	if (cfg.s.enable)
-		map_high("CONFIG", cfg.s.base, shift, map_uc);
+		map_high("CONFIG", cfg.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmr_high(int max_pnode)
@@ -327,7 +326,7 @@ static __init void map_mmr_high(int max_pnode)
 
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
-		map_high("MMR", mmr.s.base, shift, map_uc);
+		map_high("MMR", mmr.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void map_mmioh_high(int max_pnode)
@@ -337,7 +336,7 @@ static __init void map_mmioh_high(int max_pnode)
 
 	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
 	if (mmioh.s.enable)
-		map_high("MMIOH", mmioh.s.base, shift, map_uc);
+		map_high("MMIOH", mmioh.s.base, shift, max_pnode, map_uc);
 }
 
 static __init void uv_rtc_init(void)
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index 3e66bd3..1dcb0f1 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -35,6 +35,7 @@ void __init reserve_ebda_region(void)
 
 	/* start of EBDA area */
 	ebda_addr = get_bios_ebda();
+	printk(KERN_INFO "BIOS EBDA/lowmem at: %08x/%08x\n", ebda_addr, lowmem);
 
 	/* Fixup: bios puts an EBDA in the top 64K segment */
 	/* of conventional memory, but does not adjust lowmem. */
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 73deaff..acf62fc 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -115,13 +115,17 @@ static void hpet_reserve_platform_timers(unsigned long id)
 	hd.hd_phys_address = hpet_address;
 	hd.hd_address = hpet;
 	hd.hd_nirqs = nrtimers;
-	hd.hd_flags = HPET_DATA_PLATFORM;
 	hpet_reserve_timer(&hd, 0);
 
 #ifdef CONFIG_HPET_EMULATE_RTC
 	hpet_reserve_timer(&hd, 1);
 #endif
 
+	/*
+	 * NOTE that hd_irq[] reflects IOAPIC input pins (LEGACY_8254
+	 * is wrong for i8259!) not the output IRQ.  Many BIOS writers
+	 * don't bother configuring *any* comparator interrupts.
+	 */
 	hd.hd_irq[0] = HPET_LEGACY_8254;
 	hd.hd_irq[1] = HPET_LEGACY_RTC;
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 1f26fd9..5b5be9d 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -135,7 +135,7 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
-static void __init init_ISA_irqs (void)
+void __init init_ISA_irqs(void)
 {
 	int i;
 
@@ -164,22 +164,8 @@ static void __init init_ISA_irqs (void)
 
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
-void __init native_init_IRQ(void)
+static void __init smp_intr_init(void)
 {
-	int i;
-
-	init_ISA_irqs();
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != IA32_SYSCALL_VECTOR)
-			set_intr_gate(vector, interrupt[i]);
-	}
-
 #ifdef CONFIG_SMP
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
@@ -207,6 +193,12 @@ void __init native_init_IRQ(void)
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
+}
+
+static void __init apic_intr_init(void)
+{
+	smp_intr_init();
+
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 
@@ -216,6 +208,25 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+}
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	init_ISA_irqs();
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		if (vector != IA32_SYSCALL_VECTOR)
+			set_intr_gate(vector, interrupt[i]);
+	}
+
+	apic_intr_init();
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 922c140..0a1302f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -123,7 +123,7 @@ void cpu_idle(void)
 	}
 }
 
-void __show_registers(struct pt_regs *regs, int all)
+void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -189,7 +189,7 @@ void __show_registers(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	__show_registers(regs, 1);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ca80394..cd8c0ed 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -136,7 +136,7 @@ void cpu_idle(void)
 }
 
 /* Prints also some state that isn't saved in the pt_regs */
-void __show_regs(struct pt_regs *regs)
+void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L, fs, gs, shadowgs;
 	unsigned long d0, d1, d2, d3, d6, d7;
@@ -175,6 +175,9 @@ void __show_regs(struct pt_regs *regs)
 	rdmsrl(MSR_GS_BASE, gs);
 	rdmsrl(MSR_KERNEL_GS_BASE, shadowgs);
 
+	if (!all)
+		return;
+
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
@@ -200,7 +203,7 @@ void __show_regs(struct pt_regs *regs)
 void show_regs(struct pt_regs *regs)
 {
 	printk(KERN_INFO "CPU %d:", smp_processor_id());
-	__show_regs(regs);
+	__show_regs(regs, 1);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index d138588..f6a11b9 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -354,9 +354,27 @@ static void ati_force_hpet_resume(void)
 	printk(KERN_DEBUG "Force enabled HPET at resume\n");
 }
 
+static u32 ati_ixp4x0_rev(struct pci_dev *dev)
+{
+	u32 d;
+	u8  b;
+
+	pci_read_config_byte(dev, 0xac, &b);
+	b &= ~(1<<5);
+	pci_write_config_byte(dev, 0xac, b);
+	pci_read_config_dword(dev, 0x70, &d);
+	d |= 1<<8;
+	pci_write_config_dword(dev, 0x70, d);
+	pci_read_config_dword(dev, 0x8, &d);
+	d &= 0xff;
+	dev_printk(KERN_DEBUG, &dev->dev, "SB4X0 revision 0x%x\n", d);
+	return d;
+}
+
 static void ati_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 uninitialized_var(val);
+	u32 d, val;
+	u8  b;
 
 	if (hpet_address || force_hpet_address)
 		return;
@@ -366,14 +384,33 @@ static void ati_force_enable_hpet(struct pci_dev *dev)
 		return;
 	}
 
+	d = ati_ixp4x0_rev(dev);
+	if (d  < 0x82)
+		return;
+
+	/* base address */
 	pci_write_config_dword(dev, 0x14, 0xfed00000);
 	pci_read_config_dword(dev, 0x14, &val);
+
+	/* enable interrupt */
+	outb(0x72, 0xcd6); b = inb(0xcd7);
+	b |= 0x1;
+	outb(0x72, 0xcd6); outb(b, 0xcd7);
+	outb(0x72, 0xcd6); b = inb(0xcd7);
+	if (!(b & 0x1))
+		return;
+	pci_read_config_dword(dev, 0x64, &d);
+	d |= (1<<10);
+	pci_write_config_dword(dev, 0x64, d);
+	pci_read_config_dword(dev, 0x64, &d);
+	if (!(d & (1<<10)))
+		return;
+
 	force_hpet_address = val;
 	force_hpet_resume_type = ATI_FORCE_HPET_RESUME;
 	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
 		   force_hpet_address);
 	cached_dev = dev;
-	return;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS,
 			 ati_force_enable_hpet);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21b8e0a..2255782 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -302,7 +302,7 @@ static void __init relocate_initrd(void)
 		if (clen > MAX_MAP_CHUNK-slop)
 			clen = MAX_MAP_CHUNK-slop;
 		mapaddr = ramdisk_image & PAGE_MASK;
-		p = early_ioremap(mapaddr, clen+slop);
+		p = early_memremap(mapaddr, clen+slop);
 		memcpy(q, p+slop, clen);
 		early_iounmap(p, clen+slop);
 		q += clen;
@@ -379,7 +379,7 @@ static void __init parse_setup_data(void)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, PAGE_SIZE);
+		data = early_memremap(pa_data, PAGE_SIZE);
 		switch (data->type) {
 		case SETUP_E820_EXT:
 			parse_e820_ext(data, pa_data);
@@ -402,7 +402,7 @@ static void __init e820_reserve_setup_data(void)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*data));
+		data = early_memremap(pa_data, sizeof(*data));
 		e820_update_range(pa_data, sizeof(*data)+data->len,
 			 E820_RAM, E820_RESERVED_KERN);
 		found = 1;
@@ -428,7 +428,7 @@ static void __init reserve_early_setup_data(void)
 		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = early_ioremap(pa_data, sizeof(*data));
+		data = early_memremap(pa_data, sizeof(*data));
 		sprintf(buf, "setup data %x", data->type);
 		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
 		pa_data = data->next;
@@ -998,6 +998,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_table_init();
 
+	early_acpi_boot_init();
+
 #ifdef CONFIG_ACPI_NUMA
 	/*
 	 * Parse SRAT to discover nodes.
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 76b6f50..8c3aca7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -334,14 +334,17 @@ static void __cpuinit start_secondary(void *unused)
 	 * does not change while we are assigning vectors to cpus.  Holding
 	 * this lock ensures we don't half assign or remove an irq from a cpu.
 	 */
-	ipi_call_lock_irq();
+	ipi_call_lock();
 	lock_vector_lock();
 	__setup_vector_irq(smp_processor_id());
 	cpu_set(smp_processor_id(), cpu_online_map);
 	unlock_vector_lock();
-	ipi_call_unlock_irq();
+	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 
+	/* enable local interrupts */
+	local_irq_enable();
+
 	setup_secondary_clock();
 
 	wmb();
@@ -596,10 +599,12 @@ wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
 	 * Give the other CPU some time to accept the IPI.
 	 */
 	udelay(200);
-	maxlvt = lapic_get_maxlvt();
-	if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
-		apic_write(APIC_ESR, 0);
-	accept_status = (apic_read(APIC_ESR) & 0xEF);
+	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+		maxlvt = lapic_get_maxlvt();
+		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
+			apic_write(APIC_ESR, 0);
+		accept_status = (apic_read(APIC_ESR) & 0xEF);
+	}
 	pr_debug("NMI sent.\n");
 
 	if (send_status)
@@ -1256,39 +1261,6 @@ void __init native_smp_cpus_done(unsigned int max_cpus)
 	check_nmi_watchdog();
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-static void remove_siblinginfo(int cpu)
-{
-	int sibling;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
-		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
-		/*/
-		 * last thread sibling in this cpu core going down
-		 */
-		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
-			cpu_data(sibling).booted_cores--;
-	}
-
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
-		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
-	cpus_clear(per_cpu(cpu_sibling_map, cpu));
-	cpus_clear(per_cpu(cpu_core_map, cpu));
-	c->phys_proc_id = 0;
-	c->cpu_core_id = 0;
-	cpu_clear(cpu, cpu_sibling_setup_map);
-}
-
-static int additional_cpus __initdata = -1;
-
-static __init int setup_additional_cpus(char *s)
-{
-	return s && get_option(&s, &additional_cpus) ? 0 : -EINVAL;
-}
-early_param("additional_cpus", setup_additional_cpus);
-
 /*
  * cpu_possible_map should be static, it cannot change as cpu's
  * are onlined, or offlined. The reason is per-cpu data-structures
@@ -1308,21 +1280,13 @@ early_param("additional_cpus", setup_additional_cpus);
  */
 __init void prefill_possible_map(void)
 {
-	int i;
-	int possible;
+	int i, possible;
 
 	/* no processor from mptable or madt */
 	if (!num_processors)
 		num_processors = 1;
 
-	if (additional_cpus == -1) {
-		if (disabled_cpus > 0)
-			additional_cpus = disabled_cpus;
-		else
-			additional_cpus = 0;
-	}
-
-	possible = num_processors + additional_cpus;
+	possible = num_processors + disabled_cpus;
 	if (possible > NR_CPUS)
 		possible = NR_CPUS;
 
@@ -1335,6 +1299,31 @@ __init void prefill_possible_map(void)
 	nr_cpu_ids = possible;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+static void remove_siblinginfo(int cpu)
+{
+	int sibling;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
+		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
+		/*/
+		 * last thread sibling in this cpu core going down
+		 */
+		if (cpus_weight(per_cpu(cpu_sibling_map, cpu)) == 1)
+			cpu_data(sibling).booted_cores--;
+	}
+
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
+		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
+	cpus_clear(per_cpu(cpu_sibling_map, cpu));
+	cpus_clear(per_cpu(cpu_core_map, cpu));
+	c->phys_proc_id = 0;
+	c->cpu_core_id = 0;
+	cpu_clear(cpu, cpu_sibling_setup_map);
+}
+
 static void __ref remove_cpu_from_maps(int cpu)
 {
 	cpu_clear(cpu, cpu_online_map);
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index bbecf8b..77b400f 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -47,10 +47,9 @@ unsigned long profile_pc(struct pt_regs *regs)
 	unsigned long pc = instruction_pointer(regs);
 
 #ifdef CONFIG_SMP
-	if (!v8086_mode(regs) && SEGMENT_IS_KERNEL_CODE(regs->cs) &&
-	    in_lock_functions(pc)) {
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + 4);
+		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
 		unsigned long *sp = (unsigned long *)&regs->sp;
 
@@ -95,6 +94,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 	do_timer_interrupt_hook();
 
+#ifdef CONFIG_MCA
 	if (MCA_bus) {
 		/* The PS/2 uses level-triggered interrupts.  You can't
 		turn them off, nor would you want to (any attempt to
@@ -108,6 +108,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		u8 irq_v = inb_p( 0x61 );	/* read the current state */
 		outb_p( irq_v|0x80, 0x61 );	/* reset the IRQ */
 	}
+#endif
 
 	return IRQ_HANDLED;
 }
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index e3d49c5..cb19d65 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/time.h>
+#include <linux/mca.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -33,23 +34,34 @@ unsigned long profile_pc(struct pt_regs *regs)
 	/* Assume the lock function has either no stack frame or a copy
 	   of flags from PUSHF
 	   Eflags always has bits 22 and up cleared unlike kernel addresses. */
-	if (!user_mode(regs) && in_lock_functions(pc)) {
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
+#ifdef CONFIG_FRAME_POINTER
+		return *(unsigned long *)(regs->bp + sizeof(long));
+#else
 		unsigned long *sp = (unsigned long *)regs->sp;
 		if (sp[0] >> 22)
 			return sp[0];
 		if (sp[1] >> 22)
 			return sp[1];
+#endif
 	}
 	return pc;
 }
 EXPORT_SYMBOL(profile_pc);
 
-static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
+irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	add_pda(irq0_irqs, 1);
 
 	global_clock_event->event_handler(global_clock_event);
 
+#ifdef CONFIG_MCA
+	if (MCA_bus) {
+		u8 irq_v = inb_p(0x61);       /* read the current state */
+		outb_p(irq_v|0x80, 0x61);     /* reset the IRQ */
+	}
+#endif
+
 	return IRQ_HANDLED;
 }
 
@@ -100,7 +112,7 @@ unsigned long __init calibrate_cpu(void)
 }
 
 static struct irqaction irq0 = {
-	.handler	= timer_event_interrupt,
+	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
@@ -111,16 +123,13 @@ void __init hpet_time_init(void)
 	if (!hpet_enable())
 		setup_pit_timer();
 
+	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 
 void __init time_init(void)
 {
 	tsc_init();
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
-		vgetcpu_mode = VGETCPU_RDTSCP;
-	else
-		vgetcpu_mode = VGETCPU_LSL;
 
 	late_time_init = choose_time_init();
 }
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps.c
similarity index 57%
rename from arch/x86/kernel/traps_32.c
rename to arch/x86/kernel/traps.c
index 0429c5d..e062974 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps.c
@@ -7,13 +7,11 @@
  */
 
 /*
- * 'Traps.c' handles hardware traps and faults after we have saved some
- * state in 'asm.s'.
+ * Handle hardware traps and faults.
  */
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 #include <linux/spinlock.h>
-#include <linux/highmem.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/utsname.h>
@@ -32,6 +30,8 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/io.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -46,21 +46,31 @@
 #include <linux/edac.h>
 #endif
 
-#include <asm/arch_hooks.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <asm/unwind.h>
+#include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
+
+#include <mach_traps.h>
+
+#ifdef CONFIG_X86_64
+#include <asm/pgalloc.h>
+#include <asm/proto.h>
+#include <asm/pda.h>
+#else
+#include <asm/processor-flags.h>
+#include <asm/arch_hooks.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
 #include <asm/io.h>
 #include <asm/traps.h>
 
-#include "mach_traps.h"
+#include "cpu/mcheck/mce.h"
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
@@ -77,418 +87,104 @@ char ignore_fpu_irq;
  */
 gate_desc idt_table[256]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
-
-int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 24;
-static unsigned int code_bytes = 64;
-static int ignore_nmis;
-static int die_counter;
-
-void printk_address(unsigned long address, int reliable)
-{
-#ifdef CONFIG_KALLSYMS
-	unsigned long offset = 0;
-	unsigned long symsize;
-	const char *symname;
-	char *modname;
-	char *delim = ":";
-	char namebuf[KSYM_NAME_LEN];
-	char reliab[4] = "";
-
-	symname = kallsyms_lookup(address, &symsize, &offset,
-					&modname, namebuf);
-	if (!symname) {
-		printk(" [<%08lx>]\n", address);
-		return;
-	}
-	if (!reliable)
-		strcpy(reliab, "? ");
-
-	if (!modname)
-		modname = delim = "";
-	printk(" [<%08lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
-		address, reliab, delim, modname, delim, symname, offset, symsize);
-#else
-	printk(" [<%08lx>]\n", address);
 #endif
-}
-
-static inline int valid_stack_ptr(struct thread_info *tinfo,
-			void *p, unsigned int size)
-{
-	void *t = tinfo;
-	return	p > t && p <= t + THREAD_SIZE - size;
-}
-
-/* The form of the top of the frame on the stack */
-struct stack_frame {
-	struct stack_frame *next_frame;
-	unsigned long return_address;
-};
-
-static inline unsigned long
-print_context_stack(struct thread_info *tinfo,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data)
-{
-	struct stack_frame *frame = (struct stack_frame *)bp;
-
-	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
-		unsigned long addr;
-
-		addr = *stack;
-		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + 4) {
-				ops->address(data, addr, 1);
-				frame = frame->next_frame;
-				bp = (unsigned long) frame;
-			} else {
-				ops->address(data, addr, bp == 0);
-			}
-		}
-		stack++;
-	}
-	return bp;
-}
-
-void dump_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data)
-{
-	if (!task)
-		task = current;
-
-	if (!stack) {
-		unsigned long dummy;
-		stack = &dummy;
-		if (task != current)
-			stack = (unsigned long *)task->thread.sp;
-	}
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
-		if (task == current) {
-			/* Grab bp right from our regs */
-			asm("movl %%ebp, %0" : "=r" (bp) :);
-		} else {
-			/* bp is the last reg pushed by switch_to */
-			bp = *(unsigned long *) task->thread.sp;
-		}
-	}
-#endif
-
-	for (;;) {
-		struct thread_info *context;
-
-		context = (struct thread_info *)
-			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops, data);
-		/*
-		 * Should be after the line below, but somewhere
-		 * in early boot context comes out corrupted and we
-		 * can't reference it:
-		 */
-		if (ops->stack(data, "IRQ") < 0)
-			break;
-		stack = (unsigned long *)context->previous_esp;
-		if (!stack)
-			break;
-		touch_nmi_watchdog();
-	}
-}
-EXPORT_SYMBOL(dump_trace);
-
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	printk(data);
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s%s\n", (char *)data, msg);
-}
 
-static int print_trace_stack(void *data, char *name)
-{
-	return 0;
-}
-
-/*
- * Print one address/symbol entries per line.
- */
-static void print_trace_address(void *data, unsigned long addr, int reliable)
-{
-	printk("%s [<%08lx>] ", (char *)data, addr);
-	if (!reliable)
-		printk("? ");
-	print_symbol("%s\n", addr);
-	touch_nmi_watchdog();
-}
-
-static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
-	.stack = print_trace_stack,
-	.address = print_trace_address,
-};
+static int ignore_nmis;
 
-static void
-show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl)
+static inline void conditional_sti(struct pt_regs *regs)
 {
-	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-	printk("%s =======================\n", log_lvl);
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_enable();
 }
 
-void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
+static inline void preempt_conditional_sti(struct pt_regs *regs)
 {
-	show_trace_log_lvl(task, regs, stack, bp, "");
+	inc_preempt_count();
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_enable();
 }
 
-static void
-show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, unsigned long bp, char *log_lvl)
+static inline void preempt_conditional_cli(struct pt_regs *regs)
 {
-	unsigned long *stack;
-	int i;
-
-	if (sp == NULL) {
-		if (task)
-			sp = (unsigned long *)task->thread.sp;
-		else
-			sp = (unsigned long *)&sp;
-	}
-
-	stack = sp;
-	for (i = 0; i < kstack_depth_to_print; i++) {
-		if (kstack_end(stack))
-			break;
-		if (i && ((i % 8) == 0))
-			printk("\n%s       ", log_lvl);
-		printk("%08lx ", *stack++);
-	}
-	printk("\n%sCall Trace:\n", log_lvl);
-
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+	if (regs->flags & X86_EFLAGS_IF)
+		local_irq_disable();
+	dec_preempt_count();
 }
 
-void show_stack(struct task_struct *task, unsigned long *sp)
+#ifdef CONFIG_X86_32
+static inline void
+die_if_kernel(const char *str, struct pt_regs *regs, long err)
 {
-	printk("       ");
-	show_stack_log_lvl(task, NULL, sp, 0, "");
+	if (!user_mode_vm(regs))
+		die(str, regs, err);
 }
 
 /*
- * The architecture-independent dump_stack generator
+ * Perform the lazy TSS's I/O bitmap copy. If the TSS has an
+ * invalid offset set (the LAZY one) and the faulting thread has
+ * a valid I/O bitmap pointer, we copy the I/O bitmap in the TSS,
+ * we set the offset field correctly and return 1.
  */
-void dump_stack(void)
+static int lazy_iobitmap_copy(void)
 {
-	unsigned long bp = 0;
-	unsigned long stack;
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		asm("movl %%ebp, %0" : "=r" (bp):);
-#endif
-
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-
-	show_trace(current, NULL, &stack, bp);
-}
-
-EXPORT_SYMBOL(dump_stack);
-
-void show_registers(struct pt_regs *regs)
-{
-	int i;
+	struct thread_struct *thread;
+	struct tss_struct *tss;
+	int cpu;
 
-	print_modules();
-	__show_registers(regs, 0);
+	cpu = get_cpu();
+	tss = &per_cpu(init_tss, cpu);
+	thread = &current->thread;
 
-	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
-		TASK_COMM_LEN, current->comm, task_pid_nr(current),
-		current_thread_info(), current, task_thread_info(current));
-	/*
-	 * When in-kernel, we also print out the stack and code at the
-	 * time of the fault..
-	 */
-	if (!user_mode_vm(regs)) {
-		unsigned int code_prologue = code_bytes * 43 / 64;
-		unsigned int code_len = code_bytes;
-		unsigned char c;
-		u8 *ip;
-
-		printk("\n" KERN_EMERG "Stack: ");
-		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);
-
-		printk(KERN_EMERG "Code: ");
-
-		ip = (u8 *)regs->ip - code_prologue;
-		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at EIP */
-			ip = (u8 *)regs->ip;
-			code_len = code_len - code_prologue + 1;
-		}
-		for (i = 0; i < code_len; i++, ip++) {
-			if (ip < (u8 *)PAGE_OFFSET ||
-					probe_kernel_address(ip, c)) {
-				printk(" Bad EIP value.");
-				break;
-			}
-			if (ip == (u8 *)regs->ip)
-				printk("<%02x> ", c);
-			else
-				printk("%02x ", c);
+	if (tss->x86_tss.io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
+	    thread->io_bitmap_ptr) {
+		memcpy(tss->io_bitmap, thread->io_bitmap_ptr,
+		       thread->io_bitmap_max);
+		/*
+		 * If the previously set map was extending to higher ports
+		 * than the current one, pad extra space with 0xff (no access).
+		 */
+		if (thread->io_bitmap_max < tss->io_bitmap_max) {
+			memset((char *) tss->io_bitmap +
+				thread->io_bitmap_max, 0xff,
+				tss->io_bitmap_max - thread->io_bitmap_max);
 		}
-	}
-	printk("\n");
-}
-
-int is_valid_bugaddr(unsigned long ip)
-{
-	unsigned short ud2;
-
-	if (ip < PAGE_OFFSET)
-		return 0;
-	if (probe_kernel_address((unsigned short *)ip, ud2))
-		return 0;
-
-	return ud2 == 0x0b0f;
-}
-
-static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
-static int die_owner = -1;
-static unsigned int die_nest_count;
-
-unsigned __kprobes long oops_begin(void)
-{
-	unsigned long flags;
-
-	oops_enter();
-
-	if (die_owner != raw_smp_processor_id()) {
-		console_verbose();
-		raw_local_irq_save(flags);
-		__raw_spin_lock(&die_lock);
-		die_owner = smp_processor_id();
-		die_nest_count = 0;
-		bust_spinlocks(1);
-	} else {
-		raw_local_irq_save(flags);
-	}
-	die_nest_count++;
-	return flags;
-}
-
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
-{
-	bust_spinlocks(0);
-	die_owner = -1;
-	add_taint(TAINT_DIE);
-	__raw_spin_unlock(&die_lock);
-	raw_local_irq_restore(flags);
-
-	if (!regs)
-		return;
-
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
-
-	if (in_interrupt())
-		panic("Fatal exception in interrupt");
-
-	if (panic_on_oops)
-		panic("Fatal exception");
-
-	oops_exit();
-	do_exit(signr);
-}
-
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned short ss;
-	unsigned long sp;
+		tss->io_bitmap_max = thread->io_bitmap_max;
+		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
+		tss->io_bitmap_owner = thread;
+		put_cpu();
 
-	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
-#ifdef CONFIG_PREEMPT
-	printk("PREEMPT ");
-#endif
-#ifdef CONFIG_SMP
-	printk("SMP ");
-#endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
-#endif
-	printk("\n");
-	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
 		return 1;
-
-	show_registers(regs);
-	/* Executive summary in case the oops scrolled away */
-	sp = (unsigned long) (&regs->sp);
-	savesegment(ss, ss);
-	if (user_mode(regs)) {
-		sp = regs->sp;
-		ss = regs->ss & 0xffff;
 	}
-	printk(KERN_EMERG "EIP: [<%08lx>] ", regs->ip);
-	print_symbol("%s", regs->ip);
-	printk(" SS:ESP %04x:%08lx\n", ss, sp);
-	return 0;
-}
-
-/*
- * This is gone through when something in the kernel has done something bad
- * and is about to be terminated:
- */
-void die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned long flags = oops_begin();
-
-	if (die_nest_count < 3) {
-		report_bug(regs->ip, regs);
-
-		if (__die(str, regs, err))
-			regs = NULL;
-	} else {
-		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
-	}
-
-	oops_end(flags, regs, SIGSEGV);
-}
+	put_cpu();
 
-static inline void
-die_if_kernel(const char *str, struct pt_regs *regs, long err)
-{
-	if (!user_mode_vm(regs))
-		die(str, regs, err);
+	return 0;
 }
+#endif
 
 static void __kprobes
-do_trap(int trapnr, int signr, char *str, int vm86, struct pt_regs *regs,
+do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
 {
 	struct task_struct *tsk = current;
 
+#ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK) {
-		if (vm86)
+		/*
+		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
+		 * On nmi (interrupt 2), do_trap should not be called.
+		 */
+		if (trapnr < 6)
 			goto vm86_trap;
 		goto trap_signal;
 	}
+#endif
 
 	if (!user_mode(regs))
 		goto kernel_trap;
 
+#ifdef CONFIG_X86_32
 trap_signal:
+#endif
 	/*
 	 * We want error_code and trap_no set for userspace faults and
 	 * kernelspace faults which result in die(), but not
@@ -501,6 +197,18 @@ trap_signal:
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_no = trapnr;
 
+#ifdef CONFIG_X86_64
+	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
+	    printk_ratelimit()) {
+		printk(KERN_INFO
+		       "%s[%d] trap %s ip:%lx sp:%lx error:%lx",
+		       tsk->comm, tsk->pid, str,
+		       regs->ip, regs->sp, error_code);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
+#endif
+
 	if (info)
 		force_sig_info(signr, info, tsk);
 	else
@@ -515,29 +223,29 @@ kernel_trap:
 	}
 	return;
 
+#ifdef CONFIG_X86_32
 vm86_trap:
 	if (handle_vm86_trap((struct kernel_vm86_regs *) regs,
 						error_code, trapnr))
 		goto trap_signal;
 	return;
+#endif
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
-void do_##name(struct pt_regs *regs, long error_code)			\
+dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	trace_hardirqs_fixup();						\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
-	do_trap(trapnr, signr, str, 0, regs, error_code, NULL);		\
+	conditional_sti(regs);						\
+	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
 }
 
-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq)	\
-void do_##name(struct pt_regs *regs, long error_code)			\
+#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
+dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
-	if (irq)							\
-		local_irq_enable();					\
 	info.si_signo = signr;						\
 	info.si_errno = 0;						\
 	info.si_code = sicode;						\
@@ -545,90 +253,68 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
 		return;							\
-	do_trap(trapnr, signr, str, 0, regs, error_code, &info);	\
+	conditional_sti(regs);						\
+	do_trap(trapnr, signr, str, regs, error_code, &info);		\
 }
 
-#define DO_VM86_ERROR(trapnr, signr, str, name)				\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	do_trap(trapnr, signr, str, 1, regs, error_code, NULL);		\
-}
-
-#define DO_VM86_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)	\
-void do_##name(struct pt_regs *regs, long error_code)			\
-{									\
-	siginfo_t info;							\
-	info.si_signo = signr;						\
-	info.si_errno = 0;						\
-	info.si_code = sicode;						\
-	info.si_addr = (void __user *)siaddr;				\
-	trace_hardirqs_fixup();						\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	do_trap(trapnr, signr, str, 1, regs, error_code, &info);	\
-}
-
-DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-#ifndef CONFIG_KPROBES
-DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
-#endif
-DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_VM86_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
+DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
+DO_ERROR(4, SIGSEGV, "overflow", overflow)
+DO_ERROR(5, SIGSEGV, "bounds", bounds)
+DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
 DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+#ifdef CONFIG_X86_32
 DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
-DO_ERROR_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
+#endif
+DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
+
+#ifdef CONFIG_X86_64
+/* Runs on IST stack */
+dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
+{
+	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
+			12, SIGBUS) == NOTIFY_STOP)
+		return;
+	preempt_conditional_sti(regs);
+	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
+	preempt_conditional_cli(regs);
+}
+
+dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
+{
+	static const char str[] = "double fault";
+	struct task_struct *tsk = current;
+
+	/* Return not checked because double check cannot be ignored */
+	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
 
-void __kprobes
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = 8;
+
+	/* This is always a kernel trap and never fixable (and thus must
+	   never return). */
+	for (;;)
+		die(str, regs, error_code);
+}
+#endif
+
+dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
-	struct thread_struct *thread;
-	struct tss_struct *tss;
-	int cpu;
 
-	cpu = get_cpu();
-	tss = &per_cpu(init_tss, cpu);
-	thread = &current->thread;
-
-	/*
-	 * Perform the lazy TSS's I/O bitmap copy. If the TSS has an
-	 * invalid offset set (the LAZY one) and the faulting thread has
-	 * a valid I/O bitmap pointer, we copy the I/O bitmap in the TSS
-	 * and we set the offset field correctly. Then we let the CPU to
-	 * restart the faulting instruction.
-	 */
-	if (tss->x86_tss.io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
-	    thread->io_bitmap_ptr) {
-		memcpy(tss->io_bitmap, thread->io_bitmap_ptr,
-		       thread->io_bitmap_max);
-		/*
-		 * If the previously set map was extending to higher ports
-		 * than the current one, pad extra space with 0xff (no access).
-		 */
-		if (thread->io_bitmap_max < tss->io_bitmap_max) {
-			memset((char *) tss->io_bitmap +
-				thread->io_bitmap_max, 0xff,
-				tss->io_bitmap_max - thread->io_bitmap_max);
-		}
-		tss->io_bitmap_max = thread->io_bitmap_max;
-		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
-		tss->io_bitmap_owner = thread;
-		put_cpu();
+	conditional_sti(regs);
 
+#ifdef CONFIG_X86_32
+	if (lazy_iobitmap_copy()) {
+		/* restart the faulting instruction */
 		return;
 	}
-	put_cpu();
 
 	if (regs->flags & X86_VM_MASK)
 		goto gp_in_vm86;
+#endif
 
 	tsk = current;
 	if (!user_mode(regs))
@@ -650,10 +336,12 @@ do_general_protection(struct pt_regs *regs, long error_code)
 	force_sig(SIGSEGV, tsk);
 	return;
 
+#ifdef CONFIG_X86_32
 gp_in_vm86:
 	local_irq_enable();
 	handle_vm86_fault((struct kernel_vm86_regs *) regs, error_code);
 	return;
+#endif
 
 gp_in_kernel:
 	if (fixup_exception(regs))
@@ -690,7 +378,8 @@ mem_parity_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 
 	/* Clear and disable the memory parity error line. */
-	clear_mem_error(reason);
+	reason = (reason & 0xf) | 4;
+	outb(reason, 0x61);
 }
 
 static notrace __kprobes void
@@ -716,7 +405,8 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 static notrace __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
+	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
+			NOTIFY_STOP)
 		return;
 #ifdef CONFIG_MCA
 	/*
@@ -739,41 +429,6 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
 
-static DEFINE_SPINLOCK(nmi_print_lock);
-
-void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
-{
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	spin_lock(&nmi_print_lock);
-	/*
-	* We are in trouble anyway, lets at least try
-	* to get a message out:
-	*/
-	bust_spinlocks(1);
-	printk(KERN_EMERG "%s", str);
-	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
-	show_registers(regs);
-	if (do_panic)
-		panic("Non maskable interrupt");
-	console_silent();
-	spin_unlock(&nmi_print_lock);
-	bust_spinlocks(0);
-
-	/*
-	 * If we are in kernel we are probably nested up pretty bad
-	 * and might aswell get out now while we still can:
-	 */
-	if (!user_mode_vm(regs)) {
-		current->thread.trap_no = 2;
-		crash_kexec(regs);
-	}
-
-	do_exit(SIGSEGV);
-}
-
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
@@ -812,22 +467,25 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		mem_parity_error(reason, regs);
 	if (reason & 0x40)
 		io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
 	/*
 	 * Reassert NMI in case it became active meanwhile
 	 * as it's edge-triggered:
 	 */
 	reassert_nmi();
+#endif
 }
 
-notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
+dotraplinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
 {
-	int cpu;
-
 	nmi_enter();
 
-	cpu = smp_processor_id();
-
-	++nmi_count(cpu);
+#ifdef CONFIG_X86_32
+	{ int cpu; cpu = smp_processor_id(); ++nmi_count(cpu); }
+#else
+	add_pda(__nmi_count, 1);
+#endif
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
@@ -847,21 +505,44 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
-#ifdef CONFIG_KPROBES
-void __kprobes do_int3(struct pt_regs *regs, long error_code)
+/* May run on IST stack. */
+dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
-	trace_hardirqs_fixup();
-
+#ifdef CONFIG_KPROBES
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-	/*
-	 * This is an interrupt gate, because kprobes wants interrupts
-	 * disabled. Normal trap handlers don't.
-	 */
-	restore_interrupts(regs);
+#else
+	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
+			== NOTIFY_STOP)
+		return;
+#endif
+
+	preempt_conditional_sti(regs);
+	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
+	preempt_conditional_cli(regs);
+}
 
-	do_trap(3, SIGTRAP, "int3", 1, regs, error_code, NULL);
+#ifdef CONFIG_X86_64
+/* Help handler running on IST stack to switch back to user stack
+   for scheduling or signal handling. The actual stack switch is done in
+   entry.S */
+asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+{
+	struct pt_regs *regs = eregs;
+	/* Did already sync */
+	if (eregs == (struct pt_regs *)eregs->sp)
+		;
+	/* Exception from user space */
+	else if (user_mode(eregs))
+		regs = task_pt_regs(current);
+	/* Exception from kernel and interrupts are enabled. Move to
+	   kernel process stack. */
+	else if (eregs->flags & X86_EFLAGS_IF)
+		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
+	if (eregs != regs)
+		*regs = *eregs;
+	return regs;
 }
 #endif
 
@@ -886,15 +567,15 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
  * about restoring all the debug state, and ptrace doesn't have to
  * find every occurrence of the TF bit that could be saved away even
  * by user code)
+ *
+ * May run on IST stack.
  */
-void __kprobes do_debug(struct pt_regs *regs, long error_code)
+dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
-	unsigned int condition;
+	unsigned long condition;
 	int si_code;
 
-	trace_hardirqs_fixup();
-
 	get_debugreg(condition, 6);
 
 	/*
@@ -906,9 +587,9 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 						SIGTRAP) == NOTIFY_STOP)
 		return;
+
 	/* It's safe to allow irq's after DR6 has been saved */
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
+	preempt_conditional_sti(regs);
 
 	/* Mask out spurious debug traps due to lazy DR7 setting */
 	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
@@ -916,8 +597,10 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 			goto clear_dr7;
 	}
 
+#ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK)
 		goto debug_vm86;
+#endif
 
 	/* Save debug status register where ptrace can see it */
 	tsk->thread.debugreg6 = condition;
@@ -927,16 +610,11 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	 * kernel space (but re-enable TF when returning to user mode).
 	 */
 	if (condition & DR_STEP) {
-		/*
-		 * We already checked v86 mode above, so we can
-		 * check for kernel mode by just checking the CPL
-		 * of CS.
-		 */
 		if (!user_mode(regs))
 			goto clear_TF_reenable;
 	}
 
-	si_code = get_si_code((unsigned long)condition);
+	si_code = get_si_code(condition);
 	/* Ok, finally something we can handle */
 	send_sigtrap(tsk, regs, error_code, si_code);
 
@@ -946,18 +624,37 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	 */
 clear_dr7:
 	set_debugreg(0, 7);
+	preempt_conditional_cli(regs);
 	return;
 
+#ifdef CONFIG_X86_32
 debug_vm86:
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
+	preempt_conditional_cli(regs);
 	return;
+#endif
 
 clear_TF_reenable:
 	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
 	regs->flags &= ~X86_EFLAGS_TF;
+	preempt_conditional_cli(regs);
 	return;
 }
 
+#ifdef CONFIG_X86_64
+static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
+{
+	if (fixup_exception(regs))
+		return 1;
+
+	notify_die(DIE_GPF, str, regs, 0, trapnr, SIGFPE);
+	/* Illegal floating point operation in the kernel */
+	current->thread.trap_no = trapnr;
+	die(str, regs, 0);
+	return 0;
+}
+#endif
+
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
  * the correct behaviour even in the presence of the asynchronous
@@ -994,7 +691,9 @@ void math_error(void __user *ip)
 	swd = get_fpu_swd(task);
 	switch (swd & ~cwd & 0x3f) {
 	case 0x000: /* No unmasked exception */
+#ifdef CONFIG_X86_32
 		return;
+#endif
 	default: /* Multiple exceptions */
 		break;
 	case 0x001: /* Invalid Op */
@@ -1022,9 +721,18 @@ void math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-void do_coprocessor_error(struct pt_regs *regs, long error_code)
+dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
+
+#ifdef CONFIG_X86_32
 	ignore_fpu_irq = 1;
+#else
+	if (!user_mode(regs) &&
+	    kernel_math_error(regs, "kernel x87 math error", 16))
+		return;
+#endif
+
 	math_error((void __user *)regs->ip);
 }
 
@@ -1076,8 +784,12 @@ static void simd_math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
+dotraplinkage void
+do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
+
+#ifdef CONFIG_X86_32
 	if (cpu_has_xmm) {
 		/* Handle SIMD FPU exceptions on PIII+ processors. */
 		ignore_fpu_irq = 1;
@@ -1096,16 +808,25 @@ void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 	current->thread.error_code = error_code;
 	die_if_kernel("cache flush denied", regs, error_code);
 	force_sig(SIGSEGV, current);
+#else
+	if (!user_mode(regs) &&
+			kernel_math_error(regs, "kernel simd math error", 19))
+		return;
+	simd_math_error((void __user *)regs->ip);
+#endif
 }
 
-void do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
+dotraplinkage void
+do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
 #if 0
 	/* No need to warn about this any longer. */
 	printk(KERN_INFO "Ignoring P6 Local APIC Spurious Interrupt Bug...\n");
 #endif
 }
 
+#ifdef CONFIG_X86_32
 unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
@@ -1124,6 +845,15 @@ unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 
 	return new_kesp;
 }
+#else
+asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
+{
+}
+
+asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
+{
+}
+#endif
 
 /*
  * 'math_state_restore()' saves the current math information in the
@@ -1156,14 +886,24 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
+#ifdef CONFIG_X86_32
 	restore_fpu(tsk);
+#else
+	/*
+	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
+	 */
+	if (unlikely(restore_fpu_checking(tsk))) {
+		stts();
+		force_sig(SIGSEGV, tsk);
+		return;
+	}
+#endif
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
-
 asmlinkage void math_emulate(long arg)
 {
 	printk(KERN_EMERG
@@ -1172,12 +912,54 @@ asmlinkage void math_emulate(long arg)
 	force_sig(SIGFPE, current);
 	schedule();
 }
-
 #endif /* CONFIG_MATH_EMULATION */
 
+dotraplinkage void __kprobes
+do_device_not_available(struct pt_regs *regs, long error)
+{
+#ifdef CONFIG_X86_32
+	if (read_cr0() & X86_CR0_EM) {
+		conditional_sti(regs);
+		math_emulate(0);
+	} else {
+		math_state_restore(); /* interrupts still off */
+		conditional_sti(regs);
+	}
+#else
+	math_state_restore();
+#endif
+}
+
+#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_MCE
+dotraplinkage void __kprobes do_machine_check(struct pt_regs *regs, long error)
+{
+	conditional_sti(regs);
+	machine_check_vector(regs, error);
+}
+#endif
+
+dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
+{
+	siginfo_t info;
+	local_irq_enable();
+
+	info.si_signo = SIGILL;
+	info.si_errno = 0;
+	info.si_code = ILL_BADSTK;
+	info.si_addr = 0;
+	if (notify_die(DIE_TRAP, "iret exception",
+			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
+		return;
+	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
+}
+#endif
+
 void __init trap_init(void)
 {
+#ifdef CONFIG_X86_32
 	int i;
+#endif
 
 #ifdef CONFIG_EISA
 	void __iomem *p = early_ioremap(0x0FFFD9, 4);
@@ -1187,29 +969,40 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_trap_gate(0, &divide_error);
-	set_intr_gate(1, &debug);
-	set_intr_gate(2, &nmi);
-	set_system_intr_gate(3, &int3); /* int3 can be called from all */
-	set_system_gate(4, &overflow); /* int4 can be called from all */
-	set_trap_gate(5, &bounds);
-	set_trap_gate(6, &invalid_op);
-	set_trap_gate(7, &device_not_available);
+	set_intr_gate(0, &divide_error);
+	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	set_intr_gate_ist(2, &nmi, NMI_STACK);
+	/* int3 can be called from all */
+	set_system_intr_gate_ist(3, &int3, DEBUG_STACK);
+	/* int4 can be called from all */
+	set_system_intr_gate(4, &overflow);
+	set_intr_gate(5, &bounds);
+	set_intr_gate(6, &invalid_op);
+	set_intr_gate(7, &device_not_available);
+#ifdef CONFIG_X86_32
 	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
-	set_trap_gate(9, &coprocessor_segment_overrun);
-	set_trap_gate(10, &invalid_TSS);
-	set_trap_gate(11, &segment_not_present);
-	set_trap_gate(12, &stack_segment);
-	set_trap_gate(13, &general_protection);
+#else
+	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+#endif
+	set_intr_gate(9, &coprocessor_segment_overrun);
+	set_intr_gate(10, &invalid_TSS);
+	set_intr_gate(11, &segment_not_present);
+	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(13, &general_protection);
 	set_intr_gate(14, &page_fault);
-	set_trap_gate(15, &spurious_interrupt_bug);
-	set_trap_gate(16, &coprocessor_error);
-	set_trap_gate(17, &alignment_check);
+	set_intr_gate(15, &spurious_interrupt_bug);
+	set_intr_gate(16, &coprocessor_error);
+	set_intr_gate(17, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_trap_gate(18, &machine_check);
+	set_intr_gate_ist(18, &machine_check, MCE_STACK);
 #endif
-	set_trap_gate(19, &simd_coprocessor_error);
+	set_intr_gate(19, &simd_coprocessor_error);
 
+#ifdef CONFIG_IA32_EMULATION
+	set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
+#endif
+
+#ifdef CONFIG_X86_32
 	if (cpu_has_fxsr) {
 		printk(KERN_INFO "Enabling fast FPU save and restore... ");
 		set_in_cr4(X86_CR4_OSFXSR);
@@ -1222,36 +1015,20 @@ void __init trap_init(void)
 		printk("done.\n");
 	}
 
-	set_system_gate(SYSCALL_VECTOR, &system_call);
+	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
 		set_bit(i, used_vectors);
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
-
+#endif
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
 
+#ifdef CONFIG_X86_32
 	trap_init_hook();
+#endif
 }
-
-static int __init kstack_setup(char *s)
-{
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
-
-	return 1;
-}
-__setup("kstack=", kstack_setup);
-
-static int __init code_bytes_setup(char *s)
-{
-	code_bytes = simple_strtoul(s, NULL, 0);
-	if (code_bytes > 8192)
-		code_bytes = 8192;
-
-	return 1;
-}
-__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
deleted file mode 100644
index 9c0ac0c..0000000
--- a/arch/x86/kernel/traps_64.c
+++ /dev/null
@@ -1,1214 +0,0 @@
-/*
- *  Copyright (C) 1991, 1992  Linus Torvalds
- *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
- *
- *  Pentium III FXSR, SSE support
- *	Gareth Hughes <gareth@valinux.com>, May 2000
- */
-
-/*
- * 'Traps.c' handles hardware traps and faults after we have saved some
- * state in 'entry.S'.
- */
-#include <linux/moduleparam.h>
-#include <linux/interrupt.h>
-#include <linux/kallsyms.h>
-#include <linux/spinlock.h>
-#include <linux/kprobes.h>
-#include <linux/uaccess.h>
-#include <linux/utsname.h>
-#include <linux/kdebug.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/unwind.h>
-#include <linux/delay.h>
-#include <linux/errno.h>
-#include <linux/kexec.h>
-#include <linux/sched.h>
-#include <linux/timer.h>
-#include <linux/init.h>
-#include <linux/bug.h>
-#include <linux/nmi.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/io.h>
-
-#if defined(CONFIG_EDAC)
-#include <linux/edac.h>
-#endif
-
-#include <asm/stacktrace.h>
-#include <asm/processor.h>
-#include <asm/debugreg.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-#include <asm/unwind.h>
-#include <asm/desc.h>
-#include <asm/i387.h>
-#include <asm/pgalloc.h>
-#include <asm/proto.h>
-#include <asm/pda.h>
-#include <asm/traps.h>
-
-#include <mach_traps.h>
-
-int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 12;
-static unsigned int code_bytes = 64;
-static int ignore_nmis;
-static int die_counter;
-
-static inline void conditional_sti(struct pt_regs *regs)
-{
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
-}
-
-static inline void preempt_conditional_sti(struct pt_regs *regs)
-{
-	inc_preempt_count();
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
-}
-
-static inline void preempt_conditional_cli(struct pt_regs *regs)
-{
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_disable();
-	/* Make sure to not schedule here because we could be running
-	   on an exception stack. */
-	dec_preempt_count();
-}
-
-void printk_address(unsigned long address, int reliable)
-{
-	printk(" [<%016lx>] %s%pS\n",
-			address, reliable ?	"" : "? ", (void *) address);
-}
-
-static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
-					unsigned *usedp, char **idp)
-{
-	static char ids[][8] = {
-		[DEBUG_STACK - 1] = "#DB",
-		[NMI_STACK - 1] = "NMI",
-		[DOUBLEFAULT_STACK - 1] = "#DF",
-		[STACKFAULT_STACK - 1] = "#SS",
-		[MCE_STACK - 1] = "#MC",
-#if DEBUG_STKSZ > EXCEPTION_STKSZ
-		[N_EXCEPTION_STACKS ...
-			N_EXCEPTION_STACKS + DEBUG_STKSZ / EXCEPTION_STKSZ - 2] = "#DB[?]"
-#endif
-	};
-	unsigned k;
-
-	/*
-	 * Iterate over all exception stacks, and figure out whether
-	 * 'stack' is in one of them:
-	 */
-	for (k = 0; k < N_EXCEPTION_STACKS; k++) {
-		unsigned long end = per_cpu(orig_ist, cpu).ist[k];
-		/*
-		 * Is 'stack' above this exception frame's end?
-		 * If yes then skip to the next frame.
-		 */
-		if (stack >= end)
-			continue;
-		/*
-		 * Is 'stack' above this exception frame's start address?
-		 * If yes then we found the right frame.
-		 */
-		if (stack >= end - EXCEPTION_STKSZ) {
-			/*
-			 * Make sure we only iterate through an exception
-			 * stack once. If it comes up for the second time
-			 * then there's something wrong going on - just
-			 * break out and return NULL:
-			 */
-			if (*usedp & (1U << k))
-				break;
-			*usedp |= 1U << k;
-			*idp = ids[k];
-			return (unsigned long *)end;
-		}
-		/*
-		 * If this is a debug stack, and if it has a larger size than
-		 * the usual exception stacks, then 'stack' might still
-		 * be within the lower portion of the debug stack:
-		 */
-#if DEBUG_STKSZ > EXCEPTION_STKSZ
-		if (k == DEBUG_STACK - 1 && stack >= end - DEBUG_STKSZ) {
-			unsigned j = N_EXCEPTION_STACKS - 1;
-
-			/*
-			 * Black magic. A large debug stack is composed of
-			 * multiple exception stack entries, which we
-			 * iterate through now. Dont look:
-			 */
-			do {
-				++j;
-				end -= EXCEPTION_STKSZ;
-				ids[j][4] = '1' + (j - N_EXCEPTION_STACKS);
-			} while (stack < end - EXCEPTION_STKSZ);
-			if (*usedp & (1U << j))
-				break;
-			*usedp |= 1U << j;
-			*idp = ids[j];
-			return (unsigned long *)end;
-		}
-#endif
-	}
-	return NULL;
-}
-
-/*
- * x86-64 can have up to three kernel stacks:
- * process stack
- * interrupt stack
- * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
- */
-
-static inline int valid_stack_ptr(struct thread_info *tinfo,
-			void *p, unsigned int size, void *end)
-{
-	void *t = tinfo;
-	if (end) {
-		if (p < end && p >= (end-THREAD_SIZE))
-			return 1;
-		else
-			return 0;
-	}
-	return p > t && p < t + THREAD_SIZE - size;
-}
-
-/* The form of the top of the frame on the stack */
-struct stack_frame {
-	struct stack_frame *next_frame;
-	unsigned long return_address;
-};
-
-static inline unsigned long
-print_context_stack(struct thread_info *tinfo,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data,
-		unsigned long *end)
-{
-	struct stack_frame *frame = (struct stack_frame *)bp;
-
-	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
-		unsigned long addr;
-
-		addr = *stack;
-		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + 8) {
-				ops->address(data, addr, 1);
-				frame = frame->next_frame;
-				bp = (unsigned long) frame;
-			} else {
-				ops->address(data, addr, bp == 0);
-			}
-		}
-		stack++;
-	}
-	return bp;
-}
-
-void dump_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data)
-{
-	const unsigned cpu = get_cpu();
-	unsigned long *irqstack_end = (unsigned long *)cpu_pda(cpu)->irqstackptr;
-	unsigned used = 0;
-	struct thread_info *tinfo;
-
-	if (!task)
-		task = current;
-
-	if (!stack) {
-		unsigned long dummy;
-		stack = &dummy;
-		if (task && task != current)
-			stack = (unsigned long *)task->thread.sp;
-	}
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
-		if (task == current) {
-			/* Grab bp right from our regs */
-			asm("movq %%rbp, %0" : "=r" (bp) : );
-		} else {
-			/* bp is the last reg pushed by switch_to */
-			bp = *(unsigned long *) task->thread.sp;
-		}
-	}
-#endif
-
-	/*
-	 * Print function call entries in all stacks, starting at the
-	 * current stack address. If the stacks consist of nested
-	 * exceptions
-	 */
-	tinfo = task_thread_info(task);
-	for (;;) {
-		char *id;
-		unsigned long *estack_end;
-		estack_end = in_exception_stack(cpu, (unsigned long)stack,
-						&used, &id);
-
-		if (estack_end) {
-			if (ops->stack(data, id) < 0)
-				break;
-
-			bp = print_context_stack(tinfo, stack, bp, ops,
-							data, estack_end);
-			ops->stack(data, "<EOE>");
-			/*
-			 * We link to the next stack via the
-			 * second-to-last pointer (index -2 to end) in the
-			 * exception stack:
-			 */
-			stack = (unsigned long *) estack_end[-2];
-			continue;
-		}
-		if (irqstack_end) {
-			unsigned long *irqstack;
-			irqstack = irqstack_end -
-				(IRQSTACKSIZE - 64) / sizeof(*irqstack);
-
-			if (stack >= irqstack && stack < irqstack_end) {
-				if (ops->stack(data, "IRQ") < 0)
-					break;
-				bp = print_context_stack(tinfo, stack, bp,
-						ops, data, irqstack_end);
-				/*
-				 * We link to the next stack (which would be
-				 * the process stack normally) the last
-				 * pointer (index -1 to end) in the IRQ stack:
-				 */
-				stack = (unsigned long *) (irqstack_end[-1]);
-				irqstack_end = NULL;
-				ops->stack(data, "EOI");
-				continue;
-			}
-		}
-		break;
-	}
-
-	/*
-	 * This handles the process stack:
-	 */
-	bp = print_context_stack(tinfo, stack, bp, ops, data, NULL);
-	put_cpu();
-}
-EXPORT_SYMBOL(dump_trace);
-
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s\n", msg);
-}
-
-static int print_trace_stack(void *data, char *name)
-{
-	printk(" <%s> ", name);
-	return 0;
-}
-
-static void print_trace_address(void *data, unsigned long addr, int reliable)
-{
-	touch_nmi_watchdog();
-	printk_address(addr, reliable);
-}
-
-static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
-	.stack = print_trace_stack,
-	.address = print_trace_address,
-};
-
-static void
-show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl)
-{
-	printk("Call Trace:\n");
-	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-}
-
-void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
-{
-	show_trace_log_lvl(task, regs, stack, bp, "");
-}
-
-static void
-show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl)
-{
-	unsigned long *stack;
-	int i;
-	const int cpu = smp_processor_id();
-	unsigned long *irqstack_end =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr);
-	unsigned long *irqstack =
-		(unsigned long *) (cpu_pda(cpu)->irqstackptr - IRQSTACKSIZE);
-
-	/*
-	 * debugging aid: "show_stack(NULL, NULL);" prints the
-	 * back trace for this cpu.
-	 */
-
-	if (sp == NULL) {
-		if (task)
-			sp = (unsigned long *)task->thread.sp;
-		else
-			sp = (unsigned long *)&sp;
-	}
-
-	stack = sp;
-	for (i = 0; i < kstack_depth_to_print; i++) {
-		if (stack >= irqstack && stack <= irqstack_end) {
-			if (stack == irqstack_end) {
-				stack = (unsigned long *) (irqstack_end[-1]);
-				printk(" <EOI> ");
-			}
-		} else {
-		if (((long) stack & (THREAD_SIZE-1)) == 0)
-			break;
-		}
-		if (i && ((i % 4) == 0))
-			printk("\n");
-		printk(" %016lx", *stack++);
-		touch_nmi_watchdog();
-	}
-	printk("\n");
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
-}
-
-void show_stack(struct task_struct *task, unsigned long *sp)
-{
-	show_stack_log_lvl(task, NULL, sp, 0, "");
-}
-
-/*
- * The architecture-independent dump_stack generator
- */
-void dump_stack(void)
-{
-	unsigned long bp = 0;
-	unsigned long stack;
-
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		asm("movq %%rbp, %0" : "=r" (bp) : );
-#endif
-
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
-		current->pid, current->comm, print_tainted(),
-		init_utsname()->release,
-		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
-}
-EXPORT_SYMBOL(dump_stack);
-
-void show_registers(struct pt_regs *regs)
-{
-	int i;
-	unsigned long sp;
-	const int cpu = smp_processor_id();
-	struct task_struct *cur = cpu_pda(cpu)->pcurrent;
-
-	sp = regs->sp;
-	printk("CPU %d ", cpu);
-	__show_regs(regs);
-	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
-		cur->comm, cur->pid, task_thread_info(cur), cur);
-
-	/*
-	 * When in-kernel, we also print out the stack and code at the
-	 * time of the fault..
-	 */
-	if (!user_mode(regs)) {
-		unsigned int code_prologue = code_bytes * 43 / 64;
-		unsigned int code_len = code_bytes;
-		unsigned char c;
-		u8 *ip;
-
-		printk("Stack: ");
-		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				regs->bp, "");
-
-		printk(KERN_EMERG "Code: ");
-
-		ip = (u8 *)regs->ip - code_prologue;
-		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at RIP */
-			ip = (u8 *)regs->ip;
-			code_len = code_len - code_prologue + 1;
-		}
-		for (i = 0; i < code_len; i++, ip++) {
-			if (ip < (u8 *)PAGE_OFFSET ||
-					probe_kernel_address(ip, c)) {
-				printk(" Bad RIP value.");
-				break;
-			}
-			if (ip == (u8 *)regs->ip)
-				printk("<%02x> ", c);
-			else
-				printk("%02x ", c);
-		}
-	}
-	printk("\n");
-}
-
-int is_valid_bugaddr(unsigned long ip)
-{
-	unsigned short ud2;
-
-	if (__copy_from_user(&ud2, (const void __user *) ip, sizeof(ud2)))
-		return 0;
-
-	return ud2 == 0x0b0f;
-}
-
-static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
-static int die_owner = -1;
-static unsigned int die_nest_count;
-
-unsigned __kprobes long oops_begin(void)
-{
-	int cpu;
-	unsigned long flags;
-
-	oops_enter();
-
-	/* racy, but better than risking deadlock. */
-	raw_local_irq_save(flags);
-	cpu = smp_processor_id();
-	if (!__raw_spin_trylock(&die_lock)) {
-		if (cpu == die_owner)
-			/* nested oops. should stop eventually */;
-		else
-			__raw_spin_lock(&die_lock);
-	}
-	die_nest_count++;
-	die_owner = cpu;
-	console_verbose();
-	bust_spinlocks(1);
-	return flags;
-}
-
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
-{
-	die_owner = -1;
-	bust_spinlocks(0);
-	die_nest_count--;
-	if (!die_nest_count)
-		/* Nest count reaches zero, release the lock. */
-		__raw_spin_unlock(&die_lock);
-	raw_local_irq_restore(flags);
-	if (!regs) {
-		oops_exit();
-		return;
-	}
-	if (panic_on_oops)
-		panic("Fatal exception");
-	oops_exit();
-	do_exit(signr);
-}
-
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
-{
-	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff, ++die_counter);
-#ifdef CONFIG_PREEMPT
-	printk("PREEMPT ");
-#endif
-#ifdef CONFIG_SMP
-	printk("SMP ");
-#endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC");
-#endif
-	printk("\n");
-	if (notify_die(DIE_OOPS, str, regs, err,
-			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
-		return 1;
-
-	show_registers(regs);
-	add_taint(TAINT_DIE);
-	/* Executive summary in case the oops scrolled away */
-	printk(KERN_ALERT "RIP ");
-	printk_address(regs->ip, 1);
-	printk(" RSP <%016lx>\n", regs->sp);
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
-	return 0;
-}
-
-void die(const char *str, struct pt_regs *regs, long err)
-{
-	unsigned long flags = oops_begin();
-
-	if (!user_mode(regs))
-		report_bug(regs->ip, regs);
-
-	if (__die(str, regs, err))
-		regs = NULL;
-	oops_end(flags, regs, SIGSEGV);
-}
-
-notrace __kprobes void
-die_nmi(char *str, struct pt_regs *regs, int do_panic)
-{
-	unsigned long flags;
-
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	flags = oops_begin();
-	/*
-	 * We are in trouble anyway, lets at least try
-	 * to get a message out.
-	 */
-	printk(KERN_EMERG "%s", str);
-	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
-	show_registers(regs);
-	if (kexec_should_crash(current))
-		crash_kexec(regs);
-	if (do_panic || panic_on_oops)
-		panic("Non maskable interrupt");
-	oops_end(flags, NULL, SIGBUS);
-	nmi_exit();
-	local_irq_enable();
-	do_exit(SIGBUS);
-}
-
-static void __kprobes
-do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
-	long error_code, siginfo_t *info)
-{
-	struct task_struct *tsk = current;
-
-	if (!user_mode(regs))
-		goto kernel_trap;
-
-	/*
-	 * We want error_code and trap_no set for userspace faults and
-	 * kernelspace faults which result in die(), but not
-	 * kernelspace faults which are fixed up.  die() gives the
-	 * process no chance to handle the signal and notice the
-	 * kernel fault information, so that won't result in polluting
-	 * the information about previously queued, but not yet
-	 * delivered, faults.  See also do_general_protection below.
-	 */
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
-
-	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
-	    printk_ratelimit()) {
-		printk(KERN_INFO
-		       "%s[%d] trap %s ip:%lx sp:%lx error:%lx",
-		       tsk->comm, tsk->pid, str,
-		       regs->ip, regs->sp, error_code);
-		print_vma_addr(" in ", regs->ip);
-		printk("\n");
-	}
-
-	if (info)
-		force_sig_info(signr, info, tsk);
-	else
-		force_sig(signr, tsk);
-	return;
-
-kernel_trap:
-	if (!fixup_exception(regs)) {
-		tsk->thread.error_code = error_code;
-		tsk->thread.trap_no = trapnr;
-		die(str, regs, error_code);
-	}
-	return;
-}
-
-#define DO_ERROR(trapnr, signr, str, name) \
-asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
-{									\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
-}
-
-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
-asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
-{									\
-	siginfo_t info;							\
-	info.si_signo = signr;						\
-	info.si_errno = 0;						\
-	info.si_code = sicode;						\
-	info.si_addr = (void __user *)siaddr;				\
-	trace_hardirqs_fixup();						\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
-		return;							\
-	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, &info);		\
-}
-
-DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
-DO_ERROR(4, SIGSEGV, "overflow", overflow)
-DO_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
-DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
-DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
-DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
-
-/* Runs on IST stack */
-asmlinkage void do_stack_segment(struct pt_regs *regs, long error_code)
-{
-	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-			12, SIGBUS) == NOTIFY_STOP)
-		return;
-	preempt_conditional_sti(regs);
-	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
-}
-
-asmlinkage void do_double_fault(struct pt_regs *regs, long error_code)
-{
-	static const char str[] = "double fault";
-	struct task_struct *tsk = current;
-
-	/* Return not checked because double check cannot be ignored */
-	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
-
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 8;
-
-	/* This is always a kernel trap and never fixable (and thus must
-	   never return). */
-	for (;;)
-		die(str, regs, error_code);
-}
-
-asmlinkage void __kprobes
-do_general_protection(struct pt_regs *regs, long error_code)
-{
-	struct task_struct *tsk;
-
-	conditional_sti(regs);
-
-	tsk = current;
-	if (!user_mode(regs))
-		goto gp_in_kernel;
-
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-
-	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
-			printk_ratelimit()) {
-		printk(KERN_INFO
-			"%s[%d] general protection ip:%lx sp:%lx error:%lx",
-			tsk->comm, tsk->pid,
-			regs->ip, regs->sp, error_code);
-		print_vma_addr(" in ", regs->ip);
-		printk("\n");
-	}
-
-	force_sig(SIGSEGV, tsk);
-	return;
-
-gp_in_kernel:
-	if (fixup_exception(regs))
-		return;
-
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-	if (notify_die(DIE_GPF, "general protection fault", regs,
-				error_code, 13, SIGSEGV) == NOTIFY_STOP)
-		return;
-	die("general protection fault", regs, error_code);
-}
-
-static notrace __kprobes void
-mem_parity_error(unsigned char reason, struct pt_regs *regs)
-{
-	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
-		reason);
-	printk(KERN_EMERG "You have some hardware problem, likely on the PCI bus.\n");
-
-#if defined(CONFIG_EDAC)
-	if (edac_handler_set()) {
-		edac_atomic_assert_error();
-		return;
-	}
-#endif
-
-	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
-
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
-
-	/* Clear and disable the memory parity error line. */
-	reason = (reason & 0xf) | 4;
-	outb(reason, 0x61);
-}
-
-static notrace __kprobes void
-io_check_error(unsigned char reason, struct pt_regs *regs)
-{
-	printk("NMI: IOCK error (debug interrupt?)\n");
-	show_registers(regs);
-
-	/* Re-enable the IOCK line, wait for a few seconds */
-	reason = (reason & 0xf) | 8;
-	outb(reason, 0x61);
-	mdelay(2000);
-	reason &= ~8;
-	outb(reason, 0x61);
-}
-
-static notrace __kprobes void
-unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
-{
-	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
-			NOTIFY_STOP)
-		return;
-	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
-		reason);
-	printk(KERN_EMERG "Do you have a strange power saving mode enabled?\n");
-
-	if (panic_on_unrecovered_nmi)
-		panic("NMI: Not continuing");
-
-	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
-}
-
-/* Runs on IST stack. This code must keep interrupts off all the time.
-   Nested NMIs are prevented by the CPU. */
-asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
-{
-	unsigned char reason = 0;
-	int cpu;
-
-	cpu = smp_processor_id();
-
-	/* Only the BSP gets external NMIs from the system. */
-	if (!cpu)
-		reason = get_nmi_reason();
-
-	if (!(reason & 0xc0)) {
-		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
-								== NOTIFY_STOP)
-			return;
-		/*
-		 * Ok, so this is none of the documented NMI sources,
-		 * so it must be the NMI watchdog.
-		 */
-		if (nmi_watchdog_tick(regs, reason))
-			return;
-		if (!do_nmi_callback(regs, cpu))
-			unknown_nmi_error(reason, regs);
-
-		return;
-	}
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & 0x80)
-		mem_parity_error(reason, regs);
-	if (reason & 0x40)
-		io_check_error(reason, regs);
-}
-
-asmlinkage notrace __kprobes void
-do_nmi(struct pt_regs *regs, long error_code)
-{
-	nmi_enter();
-
-	add_pda(__nmi_count, 1);
-
-	if (!ignore_nmis)
-		default_do_nmi(regs);
-
-	nmi_exit();
-}
-
-void stop_nmi(void)
-{
-	acpi_nmi_disable();
-	ignore_nmis++;
-}
-
-void restart_nmi(void)
-{
-	ignore_nmis--;
-	acpi_nmi_enable();
-}
-
-/* runs on IST stack. */
-asmlinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
-{
-	trace_hardirqs_fixup();
-
-	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
-		return;
-
-	preempt_conditional_sti(regs);
-	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
-}
-
-/* Help handler running on IST stack to switch back to user stack
-   for scheduling or signal handling. The actual stack switch is done in
-   entry.S */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
-{
-	struct pt_regs *regs = eregs;
-	/* Did already sync */
-	if (eregs == (struct pt_regs *)eregs->sp)
-		;
-	/* Exception from user space */
-	else if (user_mode(eregs))
-		regs = task_pt_regs(current);
-	/* Exception from kernel and interrupts are enabled. Move to
-	   kernel process stack. */
-	else if (eregs->flags & X86_EFLAGS_IF)
-		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
-	if (eregs != regs)
-		*regs = *eregs;
-	return regs;
-}
-
-/* runs on IST stack. */
-asmlinkage void __kprobes do_debug(struct pt_regs *regs,
-				   unsigned long error_code)
-{
-	struct task_struct *tsk = current;
-	unsigned long condition;
-	siginfo_t info;
-
-	trace_hardirqs_fixup();
-
-	get_debugreg(condition, 6);
-
-	/*
-	 * The processor cleared BTF, so don't mark that we need it set.
-	 */
-	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
-	tsk->thread.debugctlmsr = 0;
-
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
-						SIGTRAP) == NOTIFY_STOP)
-		return;
-
-	preempt_conditional_sti(regs);
-
-	/* Mask out spurious debug traps due to lazy DR7 setting */
-	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
-		if (!tsk->thread.debugreg7)
-			goto clear_dr7;
-	}
-
-	tsk->thread.debugreg6 = condition;
-
-	/*
-	 * Single-stepping through TF: make sure we ignore any events in
-	 * kernel space (but re-enable TF when returning to user mode).
-	 */
-	if (condition & DR_STEP) {
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
-	}
-
-	/* Ok, finally something we can handle */
-	tsk->thread.trap_no = 1;
-	tsk->thread.error_code = error_code;
-	info.si_signo = SIGTRAP;
-	info.si_errno = 0;
-	info.si_code = get_si_code(condition);
-	info.si_addr = user_mode(regs) ? (void __user *)regs->ip : NULL;
-	force_sig_info(SIGTRAP, &info, tsk);
-
-clear_dr7:
-	set_debugreg(0, 7);
-	preempt_conditional_cli(regs);
-	return;
-
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->flags &= ~X86_EFLAGS_TF;
-	preempt_conditional_cli(regs);
-	return;
-}
-
-static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
-{
-	if (fixup_exception(regs))
-		return 1;
-
-	notify_die(DIE_GPF, str, regs, 0, trapnr, SIGFPE);
-	/* Illegal floating point operation in the kernel */
-	current->thread.trap_no = trapnr;
-	die(str, regs, 0);
-	return 0;
-}
-
-/*
- * Note that we play around with the 'TS' bit in an attempt to get
- * the correct behaviour even in the presence of the asynchronous
- * IRQ13 behaviour
- */
-asmlinkage void do_coprocessor_error(struct pt_regs *regs)
-{
-	void __user *ip = (void __user *)(regs->ip);
-	struct task_struct *task;
-	siginfo_t info;
-	unsigned short cwd, swd;
-
-	conditional_sti(regs);
-	if (!user_mode(regs) &&
-	    kernel_math_error(regs, "kernel x87 math error", 16))
-		return;
-
-	/*
-	 * Save the info for the exception handler and clear the error.
-	 */
-	task = current;
-	save_init_fpu(task);
-	task->thread.trap_no = 16;
-	task->thread.error_code = 0;
-	info.si_signo = SIGFPE;
-	info.si_errno = 0;
-	info.si_code = __SI_FAULT;
-	info.si_addr = ip;
-	/*
-	 * (~cwd & swd) will mask out exceptions that are not set to unmasked
-	 * status.  0x3f is the exception bits in these regs, 0x200 is the
-	 * C1 reg you need in case of a stack fault, 0x040 is the stack
-	 * fault bit.  We should only be taking one exception at a time,
-	 * so if this combination doesn't produce any single exception,
-	 * then we have a bad program that isn't synchronizing its FPU usage
-	 * and it will suffer the consequences since we won't be able to
-	 * fully reproduce the context of the exception
-	 */
-	cwd = get_fpu_cwd(task);
-	swd = get_fpu_swd(task);
-	switch (swd & ~cwd & 0x3f) {
-	case 0x000: /* No unmasked exception */
-	default: /* Multiple exceptions */
-		break;
-	case 0x001: /* Invalid Op */
-		/*
-		 * swd & 0x240 == 0x040: Stack Underflow
-		 * swd & 0x240 == 0x240: Stack Overflow
-		 * User must clear the SF bit (0x40) if set
-		 */
-		info.si_code = FPE_FLTINV;
-		break;
-	case 0x002: /* Denormalize */
-	case 0x010: /* Underflow */
-		info.si_code = FPE_FLTUND;
-		break;
-	case 0x004: /* Zero Divide */
-		info.si_code = FPE_FLTDIV;
-		break;
-	case 0x008: /* Overflow */
-		info.si_code = FPE_FLTOVF;
-		break;
-	case 0x020: /* Precision */
-		info.si_code = FPE_FLTRES;
-		break;
-	}
-	force_sig_info(SIGFPE, &info, task);
-}
-
-asmlinkage void bad_intr(void)
-{
-	printk("bad interrupt");
-}
-
-asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
-{
-	void __user *ip = (void __user *)(regs->ip);
-	struct task_struct *task;
-	siginfo_t info;
-	unsigned short mxcsr;
-
-	conditional_sti(regs);
-	if (!user_mode(regs) &&
-			kernel_math_error(regs, "kernel simd math error", 19))
-		return;
-
-	/*
-	 * Save the info for the exception handler and clear the error.
-	 */
-	task = current;
-	save_init_fpu(task);
-	task->thread.trap_no = 19;
-	task->thread.error_code = 0;
-	info.si_signo = SIGFPE;
-	info.si_errno = 0;
-	info.si_code = __SI_FAULT;
-	info.si_addr = ip;
-	/*
-	 * The SIMD FPU exceptions are handled a little differently, as there
-	 * is only a single status/control register.  Thus, to determine which
-	 * unmasked exception was caught we must mask the exception mask bits
-	 * at 0x1f80, and then use these to mask the exception bits at 0x3f.
-	 */
-	mxcsr = get_fpu_mxcsr(task);
-	switch (~((mxcsr & 0x1f80) >> 7) & (mxcsr & 0x3f)) {
-	case 0x000:
-	default:
-		break;
-	case 0x001: /* Invalid Op */
-		info.si_code = FPE_FLTINV;
-		break;
-	case 0x002: /* Denormalize */
-	case 0x010: /* Underflow */
-		info.si_code = FPE_FLTUND;
-		break;
-	case 0x004: /* Zero Divide */
-		info.si_code = FPE_FLTDIV;
-		break;
-	case 0x008: /* Overflow */
-		info.si_code = FPE_FLTOVF;
-		break;
-	case 0x020: /* Precision */
-		info.si_code = FPE_FLTRES;
-		break;
-	}
-	force_sig_info(SIGFPE, &info, task);
-}
-
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs *regs)
-{
-}
-
-asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
-{
-}
-
-asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
-{
-}
-
-/*
- * 'math_state_restore()' saves the current math information in the
- * old math state array, and gets the new ones from the current task
- *
- * Careful.. There are problems with IBM-designed IRQ13 behaviour.
- * Don't touch unless you *really* know how it works.
- */
-asmlinkage void math_state_restore(void)
-{
-	struct task_struct *me = current;
-
-	if (!used_math()) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(me)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
-
-	clts();				/* Allow maths ops (or we recurse) */
-	/*
-	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
-	 */
-	if (unlikely(restore_fpu_checking(me))) {
-		stts();
-		force_sig(SIGSEGV, me);
-		return;
-	}
-	task_thread_info(me)->status |= TS_USEDFPU;
-	me->fpu_counter++;
-}
-EXPORT_SYMBOL_GPL(math_state_restore);
-
-void __init trap_init(void)
-{
-	set_intr_gate(0, &divide_error);
-	set_intr_gate_ist(1, &debug, DEBUG_STACK);
-	set_intr_gate_ist(2, &nmi, NMI_STACK);
-	/* int3 can be called from all */
-	set_system_gate_ist(3, &int3, DEBUG_STACK);
-	/* int4 can be called from all */
-	set_system_gate(4, &overflow);
-	set_intr_gate(5, &bounds);
-	set_intr_gate(6, &invalid_op);
-	set_intr_gate(7, &device_not_available);
-	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
-	set_intr_gate(9, &coprocessor_segment_overrun);
-	set_intr_gate(10, &invalid_TSS);
-	set_intr_gate(11, &segment_not_present);
-	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
-	set_intr_gate(13, &general_protection);
-	set_intr_gate(14, &page_fault);
-	set_intr_gate(15, &spurious_interrupt_bug);
-	set_intr_gate(16, &coprocessor_error);
-	set_intr_gate(17, &alignment_check);
-#ifdef CONFIG_X86_MCE
-	set_intr_gate_ist(18, &machine_check, MCE_STACK);
-#endif
-	set_intr_gate(19, &simd_coprocessor_error);
-
-#ifdef CONFIG_IA32_EMULATION
-	set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
-#endif
-	/*
-	 * Should be a barrier for any external CPU state:
-	 */
-	cpu_init();
-}
-
-static int __init oops_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	if (!strcmp(s, "panic"))
-		panic_on_oops = 1;
-	return 0;
-}
-early_param("oops", oops_setup);
-
-static int __init kstack_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
-	return 0;
-}
-early_param("kstack", kstack_setup);
-
-static int __init code_bytes_setup(char *s)
-{
-	code_bytes = simple_strtoul(s, NULL, 0);
-	if (code_bytes > 8192)
-		code_bytes = 8192;
-
-	return 1;
-}
-__setup("code_bytes=", code_bytes_setup);
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 520cca0..6513d41 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -47,16 +47,26 @@ static __init int mps_oem_check(struct mp_config_table *mpc, char *oem,
 /* Hook from generic ACPI tables.c */
 static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	unsigned long oem_addr;
+	unsigned long oem_addr = 0;
+	int check_dsdt;
+	int ret = 0;
+
+	/* check dsdt at first to avoid clear fix_map for oem_addr */
+	check_dsdt = es7000_check_dsdt();
+
 	if (!find_unisys_acpi_oem_table(&oem_addr)) {
-		if (es7000_check_dsdt())
-			return parse_unisys_oem((char *)oem_addr);
+		if (check_dsdt)
+			ret = parse_unisys_oem((char *)oem_addr);
 		else {
 			setup_unisys();
-			return 1;
+			ret = 1;
 		}
+		/*
+		 * we need to unmap it
+		 */
+		unmap_unisys_acpi_oem_table(oem_addr);
 	}
-	return 0;
+	return ret;
 }
 #else
 static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index dfb932d..59f89b4 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -13,12 +13,8 @@ obj-$(CONFIG_MMIOTRACE)		+= mmiotrace.o
 mmiotrace-y			:= pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
-ifeq ($(CONFIG_X86_32),y)
-obj-$(CONFIG_NUMA)		+= discontig_32.o
-else
-obj-$(CONFIG_NUMA)		+= numa_64.o
+obj-$(CONFIG_NUMA)		+= numa_$(BITS).o
 obj-$(CONFIG_K8_NUMA)		+= k8topology_64.o
-endif
 obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
 
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a742d75..3f2b896 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -592,11 +592,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	unsigned long flags;
 #endif
 
-	/*
-	 * We can fault from pretty much anywhere, with unknown IRQ state.
-	 */
-	trace_hardirqs_fixup();
-
 	tsk = current;
 	mm = tsk->mm;
 	prefetchw(&mm->mmap_sem);
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 007bb06..4ba373c 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -82,7 +82,7 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 		pte_t pte = gup_get_pte(ptep);
 		struct page *page;
 
-		if ((pte_val(pte) & (mask | _PAGE_SPECIAL)) != mask) {
+		if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
 			pte_unmap(ptep);
 			return 0;
 		}
@@ -116,10 +116,10 @@ static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 	mask = _PAGE_PRESENT|_PAGE_USER;
 	if (write)
 		mask |= _PAGE_RW;
-	if ((pte_val(pte) & mask) != mask)
+	if ((pte_flags(pte) & mask) != mask)
 		return 0;
 	/* hugepages are never "special" */
-	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
+	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
 	refs = 0;
@@ -173,10 +173,10 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
 	mask = _PAGE_PRESENT|_PAGE_USER;
 	if (write)
 		mask |= _PAGE_RW;
-	if ((pte_val(pte) & mask) != mask)
+	if ((pte_flags(pte) & mask) != mask)
 		return 0;
 	/* hugepages are never "special" */
-	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
+	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
 	refs = 0;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index bbe044d..8396868 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -558,7 +558,7 @@ void zap_low_mappings(void)
 
 int nx_enabled;
 
-pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL);
+pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 #ifdef CONFIG_X86_PAE
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 3e10054..b8e461d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -89,7 +89,7 @@ early_param("gbpages", parse_direct_gbpages_on);
 
 int after_bootmem;
 
-unsigned long __supported_pte_mask __read_mostly = ~0UL;
+pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
 static int do_not_nx __cpuinitdata;
@@ -196,9 +196,6 @@ set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte)
 	}
 
 	pte = pte_offset_kernel(pmd, vaddr);
-	if (!pte_none(*pte) && pte_val(new_pte) &&
-	    pte_val(*pte) != (pte_val(new_pte) & __supported_pte_mask))
-		pte_ERROR(*pte);
 	set_pte(pte, new_pte);
 
 	/*
@@ -313,7 +310,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 	if (pfn >= table_top)
 		panic("alloc_low_page: ran out of memory");
 
-	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
+	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
 	memset(adr, 0, PAGE_SIZE);
 	*phys  = pfn * PAGE_SIZE;
 	return adr;
@@ -749,7 +746,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		old_start = mr[i].start;
 		memmove(&mr[i], &mr[i+1],
 			 (nr_range - 1 - i) * sizeof (struct map_range));
-		mr[i].start = old_start;
+		mr[i--].start = old_start;
 		nr_range--;
 	}
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 8cbeda1..e4c43ec 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -45,6 +45,27 @@ unsigned long __phys_addr(unsigned long x)
 }
 EXPORT_SYMBOL(__phys_addr);
 
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x >= __START_KERNEL_map) {
+		x -= __START_KERNEL_map;
+		if (x >= KERNEL_IMAGE_SIZE)
+			return false;
+		x += phys_base;
+	} else {
+		if (x < PAGE_OFFSET)
+			return false;
+		x -= PAGE_OFFSET;
+		if (system_state == SYSTEM_BOOTING ?
+				x > MAXMEM : !phys_addr_valid(x)) {
+			return false;
+		}
+	}
+
+	return pfn_valid(x >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
 #else
 
 static inline int phys_addr_valid(unsigned long addr)
@@ -56,13 +77,24 @@ static inline int phys_addr_valid(unsigned long addr)
 unsigned long __phys_addr(unsigned long x)
 {
 	/* VMALLOC_* aren't constants; not available at the boot time */
-	VIRTUAL_BUG_ON(x < PAGE_OFFSET || (system_state != SYSTEM_BOOTING &&
-					is_vmalloc_addr((void *)x)));
+	VIRTUAL_BUG_ON(x < PAGE_OFFSET);
+	VIRTUAL_BUG_ON(system_state != SYSTEM_BOOTING &&
+		is_vmalloc_addr((void *) x));
 	return x - PAGE_OFFSET;
 }
 EXPORT_SYMBOL(__phys_addr);
 #endif
 
+bool __virt_addr_valid(unsigned long x)
+{
+	if (x < PAGE_OFFSET)
+		return false;
+	if (system_state != SYSTEM_BOOTING && is_vmalloc_addr((void *) x))
+		return false;
+	return pfn_valid((x - PAGE_OFFSET) >> PAGE_SHIFT);
+}
+EXPORT_SYMBOL(__virt_addr_valid);
+
 #endif
 
 int page_is_ram(unsigned long pagenr)
@@ -242,16 +274,16 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 	switch (prot_val) {
 	case _PAGE_CACHE_UC:
 	default:
-		prot = PAGE_KERNEL_NOCACHE;
+		prot = PAGE_KERNEL_IO_NOCACHE;
 		break;
 	case _PAGE_CACHE_UC_MINUS:
-		prot = PAGE_KERNEL_UC_MINUS;
+		prot = PAGE_KERNEL_IO_UC_MINUS;
 		break;
 	case _PAGE_CACHE_WC:
-		prot = PAGE_KERNEL_WC;
+		prot = PAGE_KERNEL_IO_WC;
 		break;
 	case _PAGE_CACHE_WB:
-		prot = PAGE_KERNEL;
+		prot = PAGE_KERNEL_IO;
 		break;
 	}
 
@@ -568,12 +600,12 @@ static void __init __early_set_fixmap(enum fixed_addresses idx,
 }
 
 static inline void __init early_set_fixmap(enum fixed_addresses idx,
-					unsigned long phys)
+					   unsigned long phys, pgprot_t prot)
 {
 	if (after_paging_init)
-		set_fixmap(idx, phys);
+		__set_fixmap(idx, phys, prot);
 	else
-		__early_set_fixmap(idx, phys, PAGE_KERNEL);
+		__early_set_fixmap(idx, phys, prot);
 }
 
 static inline void __init early_clear_fixmap(enum fixed_addresses idx)
@@ -584,16 +616,22 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 		__early_set_fixmap(idx, 0, __pgprot(0));
 }
 
-
-static int __initdata early_ioremap_nested;
-
+static void *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 static int __init check_early_ioremap_leak(void)
 {
-	if (!early_ioremap_nested)
+	int count = 0;
+	int i;
+
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
+		if (prev_map[i])
+			count++;
+
+	if (!count)
 		return 0;
 	WARN(1, KERN_WARNING
 	       "Debug warning: early ioremap leak of %d areas detected.\n",
-		early_ioremap_nested);
+		count);
 	printk(KERN_WARNING
 		"please boot with early_ioremap_debug and report the dmesg.\n");
 
@@ -601,18 +639,33 @@ static int __init check_early_ioremap_leak(void)
 }
 late_initcall(check_early_ioremap_leak);
 
-void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
+static void __init *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 {
 	unsigned long offset, last_addr;
-	unsigned int nrpages, nesting;
+	unsigned int nrpages;
 	enum fixed_addresses idx0, idx;
+	int i, slot;
 
 	WARN_ON(system_state != SYSTEM_BOOTING);
 
-	nesting = early_ioremap_nested;
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (!prev_map[i]) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		printk(KERN_INFO "early_iomap(%08lx, %08lx) not found slot\n",
+			 phys_addr, size);
+		WARN_ON(1);
+		return NULL;
+	}
+
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_ioremap(%08lx, %08lx) [%d] => ",
-		       phys_addr, size, nesting);
+		       phys_addr, size, slot);
 		dump_stack();
 	}
 
@@ -623,11 +676,7 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 		return NULL;
 	}
 
-	if (nesting >= FIX_BTMAPS_NESTING) {
-		WARN_ON(1);
-		return NULL;
-	}
-	early_ioremap_nested++;
+	prev_size[slot] = size;
 	/*
 	 * Mappings have to be page-aligned
 	 */
@@ -647,10 +696,10 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 	/*
 	 * Ok, go for it..
 	 */
-	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*nesting;
+	idx0 = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	idx = idx0;
 	while (nrpages > 0) {
-		early_set_fixmap(idx, phys_addr);
+		early_set_fixmap(idx, phys_addr, prot);
 		phys_addr += PAGE_SIZE;
 		--idx;
 		--nrpages;
@@ -658,7 +707,20 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 	if (early_ioremap_debug)
 		printk(KERN_CONT "%08lx + %08lx\n", offset, fix_to_virt(idx0));
 
-	return (void *) (offset + fix_to_virt(idx0));
+	prev_map[slot] = (void *) (offset + fix_to_virt(idx0));
+	return prev_map[slot];
+}
+
+/* Remap an IO device */
+void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
+}
+
+/* Remap memory */
+void __init *early_memremap(unsigned long phys_addr, unsigned long size)
+{
+	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
 void __init early_iounmap(void *addr, unsigned long size)
@@ -667,15 +729,33 @@ void __init early_iounmap(void *addr, unsigned long size)
 	unsigned long offset;
 	unsigned int nrpages;
 	enum fixed_addresses idx;
-	int nesting;
+	int i, slot;
+
+	slot = -1;
+	for (i = 0; i < FIX_BTMAPS_SLOTS; i++) {
+		if (prev_map[i] == addr) {
+			slot = i;
+			break;
+		}
+	}
 
-	nesting = --early_ioremap_nested;
-	if (WARN_ON(nesting < 0))
+	if (slot < 0) {
+		printk(KERN_INFO "early_iounmap(%p, %08lx) not found slot\n",
+			 addr, size);
+		WARN_ON(1);
+		return;
+	}
+
+	if (prev_size[slot] != size) {
+		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
+			 addr, size, slot, prev_size[slot]);
+		WARN_ON(1);
 		return;
+	}
 
 	if (early_ioremap_debug) {
 		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
-		       size, nesting);
+		       size, slot);
 		dump_stack();
 	}
 
@@ -687,12 +767,13 @@ void __init early_iounmap(void *addr, unsigned long size)
 	offset = virt_addr & ~PAGE_MASK;
 	nrpages = PAGE_ALIGN(offset + size - 1) >> PAGE_SHIFT;
 
-	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*nesting;
+	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
 		early_clear_fixmap(idx);
 		--idx;
 		--nrpages;
 	}
+	prev_map[slot] = 0;
 }
 
 void __this_fixmap_does_not_exist(void)
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/numa_32.c
similarity index 100%
rename from arch/x86/mm/discontig_32.c
rename to arch/x86/mm/numa_32.c
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 1b4763e..51c0a2f 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -138,7 +138,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		return;
 	}
 
-	if (is_uv_system())
+	if (get_uv_system_type() >= UV_X2APIC)
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
diff --git a/arch/x86/oprofile/Makefile b/arch/x86/oprofile/Makefile
index 30f3eb3..446902b 100644
--- a/arch/x86/oprofile/Makefile
+++ b/arch/x86/oprofile/Makefile
@@ -7,6 +7,6 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
 		timer_int.o )
 
 oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o
-oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_athlon.o \
+oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_amd.o \
 					   op_model_ppro.o op_model_p4.o
 oprofile-$(CONFIG_X86_IO_APIC)		+= nmi_timer_int.o
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 8a5f161..57f6c90 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -1,10 +1,11 @@
 /**
  * @file nmi_int.c
  *
- * @remark Copyright 2002 OProfile authors
+ * @remark Copyright 2002-2008 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Robert Richter <robert.richter@amd.com>
  */
 
 #include <linux/init.h>
@@ -439,6 +440,7 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	__u8 vendor = boot_cpu_data.x86_vendor;
 	__u8 family = boot_cpu_data.x86;
 	char *cpu_type;
+	int ret = 0;
 
 	if (!cpu_has_apic)
 		return -ENODEV;
@@ -451,19 +453,23 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		default:
 			return -ENODEV;
 		case 6:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			cpu_type = "i386/athlon";
 			break;
 		case 0xf:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			/* Actually it could be i386/hammer too, but give
 			 user space an consistent name. */
 			cpu_type = "x86-64/hammer";
 			break;
 		case 0x10:
-			model = &op_athlon_spec;
+			model = &op_amd_spec;
 			cpu_type = "x86-64/family10";
 			break;
+		case 0x11:
+			model = &op_amd_spec;
+			cpu_type = "x86-64/family11h";
+			break;
 		}
 		break;
 
@@ -490,17 +496,24 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		return -ENODEV;
 	}
 
-	init_sysfs();
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&oprofile_cpu_nb);
 #endif
-	using_nmi = 1;
+	/* default values, can be overwritten by model */
 	ops->create_files = nmi_create_files;
 	ops->setup = nmi_setup;
 	ops->shutdown = nmi_shutdown;
 	ops->start = nmi_start;
 	ops->stop = nmi_stop;
 	ops->cpu_type = cpu_type;
+
+	if (model->init)
+		ret = model->init(ops);
+	if (ret)
+		return ret;
+
+	init_sysfs();
+	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
 }
@@ -513,4 +526,6 @@ void op_nmi_exit(void)
 		unregister_cpu_notifier(&oprofile_cpu_nb);
 #endif
 	}
+	if (model->exit)
+		model->exit();
 }
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
new file mode 100644
index 0000000..d9faf60
--- /dev/null
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -0,0 +1,543 @@
+/*
+ * @file op_model_amd.c
+ * athlon / K7 / K8 / Family 10h model-specific MSR operations
+ *
+ * @remark Copyright 2002-2008 OProfile authors
+ * @remark Read the file COPYING
+ *
+ * @author John Levon
+ * @author Philippe Elie
+ * @author Graydon Hoare
+ * @author Robert Richter <robert.richter@amd.com>
+ * @author Barry Kasindorf
+*/
+
+#include <linux/oprofile.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+
+#include <asm/ptrace.h>
+#include <asm/msr.h>
+#include <asm/nmi.h>
+
+#include "op_x86_model.h"
+#include "op_counter.h"
+
+#define NUM_COUNTERS 4
+#define NUM_CONTROLS 4
+
+#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
+#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
+#define CTR_WRITE(l, msrs, c) do {wrmsr(msrs->counters[(c)].addr, -(unsigned int)(l), -1); } while (0)
+#define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
+
+#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
+#define CTRL_READ(l, h, msrs, c) do {rdmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
+#define CTRL_WRITE(l, h, msrs, c) do {wrmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
+#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
+#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
+#define CTRL_CLEAR_LO(x) (x &= (1<<21))
+#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
+#define CTRL_SET_ENABLE(val) (val |= 1<<20)
+#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
+#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
+#define CTRL_SET_UM(val, m) (val |= (m << 8))
+#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
+#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
+#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
+#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
+
+static unsigned long reset_value[NUM_COUNTERS];
+
+#ifdef CONFIG_OPROFILE_IBS
+
+/* IbsFetchCtl bits/masks */
+#define IBS_FETCH_HIGH_VALID_BIT	(1UL << 17)	/* bit 49 */
+#define IBS_FETCH_HIGH_ENABLE		(1UL << 16)	/* bit 48 */
+#define IBS_FETCH_LOW_MAX_CNT_MASK	0x0000FFFFUL	/* MaxCnt mask */
+
+/*IbsOpCtl bits */
+#define IBS_OP_LOW_VALID_BIT		(1ULL<<18)	/* bit 18 */
+#define IBS_OP_LOW_ENABLE		(1ULL<<17)	/* bit 17 */
+
+/* Codes used in cpu_buffer.c */
+/* This produces duplicate code, need to be fixed */
+#define IBS_FETCH_BEGIN 3
+#define IBS_OP_BEGIN    4
+
+/* The function interface needs to be fixed, something like add
+   data. Should then be added to linux/oprofile.h. */
+extern void oprofile_add_ibs_sample(struct pt_regs *const regs,
+				    unsigned int * const ibs_sample, u8 code);
+
+struct ibs_fetch_sample {
+	/* MSRC001_1031 IBS Fetch Linear Address Register */
+	unsigned int ibs_fetch_lin_addr_low;
+	unsigned int ibs_fetch_lin_addr_high;
+	/* MSRC001_1030 IBS Fetch Control Register */
+	unsigned int ibs_fetch_ctl_low;
+	unsigned int ibs_fetch_ctl_high;
+	/* MSRC001_1032 IBS Fetch Physical Address Register */
+	unsigned int ibs_fetch_phys_addr_low;
+	unsigned int ibs_fetch_phys_addr_high;
+};
+
+struct ibs_op_sample {
+	/* MSRC001_1034 IBS Op Logical Address Register (IbsRIP) */
+	unsigned int ibs_op_rip_low;
+	unsigned int ibs_op_rip_high;
+	/* MSRC001_1035 IBS Op Data Register */
+	unsigned int ibs_op_data1_low;
+	unsigned int ibs_op_data1_high;
+	/* MSRC001_1036 IBS Op Data 2 Register */
+	unsigned int ibs_op_data2_low;
+	unsigned int ibs_op_data2_high;
+	/* MSRC001_1037 IBS Op Data 3 Register */
+	unsigned int ibs_op_data3_low;
+	unsigned int ibs_op_data3_high;
+	/* MSRC001_1038 IBS DC Linear Address Register (IbsDcLinAd) */
+	unsigned int ibs_dc_linear_low;
+	unsigned int ibs_dc_linear_high;
+	/* MSRC001_1039 IBS DC Physical Address Register (IbsDcPhysAd) */
+	unsigned int ibs_dc_phys_low;
+	unsigned int ibs_dc_phys_high;
+};
+
+/*
+ * unitialize the APIC for the IBS interrupts if needed on AMD Family10h+
+*/
+static void clear_ibs_nmi(void);
+
+static int ibs_allowed;	/* AMD Family10h and later */
+
+struct op_ibs_config {
+	unsigned long op_enabled;
+	unsigned long fetch_enabled;
+	unsigned long max_cnt_fetch;
+	unsigned long max_cnt_op;
+	unsigned long rand_en;
+	unsigned long dispatched_ops;
+};
+
+static struct op_ibs_config ibs_config;
+
+#endif
+
+/* functions for op_amd_spec */
+
+static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_COUNTERS; i++) {
+		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
+		else
+			msrs->counters[i].addr = 0;
+	}
+
+	for (i = 0; i < NUM_CONTROLS; i++) {
+		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
+			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		else
+			msrs->controls[i].addr = 0;
+	}
+}
+
+
+static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+
+	/* clear all counters */
+	for (i = 0 ; i < NUM_CONTROLS; ++i) {
+		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+			continue;
+		CTRL_READ(low, high, msrs, i);
+		CTRL_CLEAR_LO(low);
+		CTRL_CLEAR_HI(high);
+		CTRL_WRITE(low, high, msrs, i);
+	}
+
+	/* avoid a false detection of ctr overflows in NMI handler */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
+			continue;
+		CTR_WRITE(1, msrs, i);
+	}
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
+			reset_value[i] = counter_config[i].count;
+
+			CTR_WRITE(counter_config[i].count, msrs, i);
+
+			CTRL_READ(low, high, msrs, i);
+			CTRL_CLEAR_LO(low);
+			CTRL_CLEAR_HI(high);
+			CTRL_SET_ENABLE(low);
+			CTRL_SET_USR(low, counter_config[i].user);
+			CTRL_SET_KERN(low, counter_config[i].kernel);
+			CTRL_SET_UM(low, counter_config[i].unit_mask);
+			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
+			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
+			CTRL_SET_HOST_ONLY(high, 0);
+			CTRL_SET_GUEST_ONLY(high, 0);
+
+			CTRL_WRITE(low, high, msrs, i);
+		} else {
+			reset_value[i] = 0;
+		}
+	}
+}
+
+#ifdef CONFIG_OPROFILE_IBS
+
+static inline int
+op_amd_handle_ibs(struct pt_regs * const regs,
+		  struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	struct ibs_fetch_sample ibs_fetch;
+	struct ibs_op_sample ibs_op;
+
+	if (!ibs_allowed)
+		return 1;
+
+	if (ibs_config.fetch_enabled) {
+		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+		if (high & IBS_FETCH_HIGH_VALID_BIT) {
+			ibs_fetch.ibs_fetch_ctl_high = high;
+			ibs_fetch.ibs_fetch_ctl_low = low;
+			rdmsr(MSR_AMD64_IBSFETCHLINAD, low, high);
+			ibs_fetch.ibs_fetch_lin_addr_high = high;
+			ibs_fetch.ibs_fetch_lin_addr_low = low;
+			rdmsr(MSR_AMD64_IBSFETCHPHYSAD, low, high);
+			ibs_fetch.ibs_fetch_phys_addr_high = high;
+			ibs_fetch.ibs_fetch_phys_addr_low = low;
+
+			oprofile_add_ibs_sample(regs,
+						(unsigned int *)&ibs_fetch,
+						IBS_FETCH_BEGIN);
+
+			/*reenable the IRQ */
+			rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+			high &= ~IBS_FETCH_HIGH_VALID_BIT;
+			high |= IBS_FETCH_HIGH_ENABLE;
+			low &= IBS_FETCH_LOW_MAX_CNT_MASK;
+			wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+		}
+	}
+
+	if (ibs_config.op_enabled) {
+		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
+		if (low & IBS_OP_LOW_VALID_BIT) {
+			rdmsr(MSR_AMD64_IBSOPRIP, low, high);
+			ibs_op.ibs_op_rip_low = low;
+			ibs_op.ibs_op_rip_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA, low, high);
+			ibs_op.ibs_op_data1_low = low;
+			ibs_op.ibs_op_data1_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA2, low, high);
+			ibs_op.ibs_op_data2_low = low;
+			ibs_op.ibs_op_data2_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA3, low, high);
+			ibs_op.ibs_op_data3_low = low;
+			ibs_op.ibs_op_data3_high = high;
+			rdmsr(MSR_AMD64_IBSDCLINAD, low, high);
+			ibs_op.ibs_dc_linear_low = low;
+			ibs_op.ibs_dc_linear_high = high;
+			rdmsr(MSR_AMD64_IBSDCPHYSAD, low, high);
+			ibs_op.ibs_dc_phys_low = low;
+			ibs_op.ibs_dc_phys_high = high;
+
+			/* reenable the IRQ */
+			oprofile_add_ibs_sample(regs,
+						(unsigned int *)&ibs_op,
+						IBS_OP_BEGIN);
+			rdmsr(MSR_AMD64_IBSOPCTL, low, high);
+			high = 0;
+			low &= ~IBS_OP_LOW_VALID_BIT;
+			low |= IBS_OP_LOW_ENABLE;
+			wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+		}
+	}
+
+	return 1;
+}
+
+#endif
+
+static int op_amd_check_ctrs(struct pt_regs * const regs,
+			     struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+
+	for (i = 0 ; i < NUM_COUNTERS; ++i) {
+		if (!reset_value[i])
+			continue;
+		CTR_READ(low, high, msrs, i);
+		if (CTR_OVERFLOWED(low)) {
+			oprofile_add_sample(regs, i);
+			CTR_WRITE(reset_value[i], msrs, i);
+		}
+	}
+
+#ifdef CONFIG_OPROFILE_IBS
+	op_amd_handle_ibs(regs, msrs);
+#endif
+
+	/* See op_model_ppro.c */
+	return 1;
+}
+
+static void op_amd_start(struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+		if (reset_value[i]) {
+			CTRL_READ(low, high, msrs, i);
+			CTRL_SET_ACTIVE(low);
+			CTRL_WRITE(low, high, msrs, i);
+		}
+	}
+
+#ifdef CONFIG_OPROFILE_IBS
+	if (ibs_allowed && ibs_config.fetch_enabled) {
+		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		high = IBS_FETCH_HIGH_ENABLE;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (ibs_allowed && ibs_config.op_enabled) {
+		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF) + IBS_OP_LOW_ENABLE;
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
+#endif
+}
+
+
+static void op_amd_stop(struct op_msrs const * const msrs)
+{
+	unsigned int low, high;
+	int i;
+
+	/* Subtle: stop on all counters to avoid race with
+	 * setting our pm callback */
+	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+		if (!reset_value[i])
+			continue;
+		CTRL_READ(low, high, msrs, i);
+		CTRL_SET_INACTIVE(low);
+		CTRL_WRITE(low, high, msrs, i);
+	}
+
+#ifdef CONFIG_OPROFILE_IBS
+	if (ibs_allowed && ibs_config.fetch_enabled) {
+		low = 0;		/* clear max count and enable */
+		high = 0;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (ibs_allowed && ibs_config.op_enabled) {
+		low = 0;		/* clear max count and enable */
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
+#endif
+}
+
+static void op_amd_shutdown(struct op_msrs const * const msrs)
+{
+	int i;
+
+	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
+		if (CTR_IS_RESERVED(msrs, i))
+			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+	}
+	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
+		if (CTRL_IS_RESERVED(msrs, i))
+			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+}
+
+#ifndef CONFIG_OPROFILE_IBS
+
+/* no IBS support */
+
+static int op_amd_init(struct oprofile_operations *ops)
+{
+	return 0;
+}
+
+static void op_amd_exit(void) {}
+
+#else
+
+static u8 ibs_eilvt_off;
+
+static inline void apic_init_ibs_nmi_per_cpu(void *arg)
+{
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+}
+
+static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
+{
+	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int pfm_amd64_setup_eilvt(void)
+{
+#define IBSCTL_LVTOFFSETVAL		(1 << 8)
+#define IBSCTL				0x1cc
+	struct pci_dev *cpu_cfg;
+	int nodes;
+	u32 value = 0;
+
+	/* per CPU setup */
+	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1);
+
+	nodes = 0;
+	cpu_cfg = NULL;
+	do {
+		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
+					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
+					 cpu_cfg);
+		if (!cpu_cfg)
+			break;
+		++nodes;
+		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
+				       | IBSCTL_LVTOFFSETVAL);
+		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
+		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
+			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
+				"IBSCTL = 0x%08x", value);
+			return 1;
+		}
+	} while (1);
+
+	if (!nodes) {
+		printk(KERN_DEBUG "No CPU node configured for IBS");
+		return 1;
+	}
+
+#ifdef CONFIG_NUMA
+	/* Sanity check */
+	/* Works only for 64bit with proper numa implementation. */
+	if (nodes != num_possible_nodes()) {
+		printk(KERN_DEBUG "Failed to setup CPU node(s) for IBS, "
+			"found: %d, expected %d",
+			nodes, num_possible_nodes());
+		return 1;
+	}
+#endif
+	return 0;
+}
+
+/*
+ * initialize the APIC for the IBS interrupts
+ * if available (AMD Family10h rev B0 and later)
+ */
+static void setup_ibs(void)
+{
+	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
+
+	if (!ibs_allowed)
+		return;
+
+	if (pfm_amd64_setup_eilvt()) {
+		ibs_allowed = 0;
+		return;
+	}
+
+	printk(KERN_INFO "oprofile: AMD IBS detected\n");
+}
+
+
+/*
+ * unitialize the APIC for the IBS interrupts if needed on AMD Family10h
+ * rev B0 and later */
+static void clear_ibs_nmi(void)
+{
+	if (ibs_allowed)
+		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
+}
+
+static int (*create_arch_files)(struct super_block * sb, struct dentry * root);
+
+static int setup_ibs_files(struct super_block * sb, struct dentry * root)
+{
+	char buf[12];
+	struct dentry *dir;
+	int ret = 0;
+
+	/* architecture specific files */
+	if (create_arch_files)
+		ret = create_arch_files(sb, root);
+
+	if (ret)
+		return ret;
+
+	if (!ibs_allowed)
+		return ret;
+
+	/* model specific files */
+
+	/* setup some reasonable defaults */
+	ibs_config.max_cnt_fetch = 250000;
+	ibs_config.fetch_enabled = 0;
+	ibs_config.max_cnt_op = 250000;
+	ibs_config.op_enabled = 0;
+	ibs_config.dispatched_ops = 1;
+	snprintf(buf,  sizeof(buf), "ibs_fetch");
+	dir = oprofilefs_mkdir(sb, root, buf);
+	oprofilefs_create_ulong(sb, dir, "rand_enable",
+				&ibs_config.rand_en);
+	oprofilefs_create_ulong(sb, dir, "enable",
+		&ibs_config.fetch_enabled);
+	oprofilefs_create_ulong(sb, dir, "max_count",
+		&ibs_config.max_cnt_fetch);
+	snprintf(buf,  sizeof(buf), "ibs_uops");
+	dir = oprofilefs_mkdir(sb, root, buf);
+	oprofilefs_create_ulong(sb, dir, "enable",
+		&ibs_config.op_enabled);
+	oprofilefs_create_ulong(sb, dir, "max_count",
+		&ibs_config.max_cnt_op);
+	oprofilefs_create_ulong(sb, dir, "dispatched_ops",
+		&ibs_config.dispatched_ops);
+
+	return 0;
+}
+
+static int op_amd_init(struct oprofile_operations *ops)
+{
+	setup_ibs();
+	create_arch_files = ops->create_files;
+	ops->create_files = setup_ibs_files;
+	return 0;
+}
+
+static void op_amd_exit(void)
+{
+	clear_ibs_nmi();
+}
+
+#endif
+
+struct op_x86_model_spec const op_amd_spec = {
+	.init = op_amd_init,
+	.exit = op_amd_exit,
+	.num_counters = NUM_COUNTERS,
+	.num_controls = NUM_CONTROLS,
+	.fill_in_addresses = &op_amd_fill_in_addresses,
+	.setup_ctrs = &op_amd_setup_ctrs,
+	.check_ctrs = &op_amd_check_ctrs,
+	.start = &op_amd_start,
+	.stop = &op_amd_stop,
+	.shutdown = &op_amd_shutdown
+};
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
deleted file mode 100644
index 3d53487..0000000
--- a/arch/x86/oprofile/op_model_athlon.c
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * @file op_model_athlon.h
- * athlon / K7 / K8 / Family 10h model-specific MSR operations
- *
- * @remark Copyright 2002 OProfile authors
- * @remark Read the file COPYING
- *
- * @author John Levon
- * @author Philippe Elie
- * @author Graydon Hoare
- */
-
-#include <linux/oprofile.h>
-#include <asm/ptrace.h>
-#include <asm/msr.h>
-#include <asm/nmi.h>
-
-#include "op_x86_model.h"
-#include "op_counter.h"
-
-#define NUM_COUNTERS 4
-#define NUM_CONTROLS 4
-
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
-#define CTR_WRITE(l, msrs, c) do {wrmsr(msrs->counters[(c)].addr, -(unsigned int)(l), -1); } while (0)
-#define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
-
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
-#define CTRL_READ(l, h, msrs, c) do {rdmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
-#define CTRL_WRITE(l, h, msrs, c) do {wrmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
-#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
-#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR_LO(x) (x &= (1<<21))
-#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
-#define CTRL_SET_ENABLE(val) (val |= 1<<20)
-#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
-#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
-#define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
-#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
-#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
-#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
-
-static unsigned long reset_value[NUM_COUNTERS];
-
-static void athlon_fill_in_addresses(struct op_msrs * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-		else
-			msrs->counters[i].addr = 0;
-	}
-
-	for (i = 0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
-			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
-		else
-			msrs->controls[i].addr = 0;
-	}
-}
-
-
-static void athlon_setup_ctrs(struct op_msrs const * const msrs)
-{
-	unsigned int low, high;
-	int i;
-
-	/* clear all counters */
-	for (i = 0 ; i < NUM_CONTROLS; ++i) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
-			continue;
-		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR_LO(low);
-		CTRL_CLEAR_HI(high);
-		CTRL_WRITE(low, high, msrs, i);
-	}
-
-	/* avoid a false detection of ctr overflows in NMI handler */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
-			continue;
-		CTR_WRITE(1, msrs, i);
-	}
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
-			reset_value[i] = counter_config[i].count;
-
-			CTR_WRITE(counter_config[i].count, msrs, i);
-
-			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR_LO(low);
-			CTRL_CLEAR_HI(high);
-			CTRL_SET_ENABLE(low);
-			CTRL_SET_USR(low, counter_config[i].user);
-			CTRL_SET_KERN(low, counter_config[i].kernel);
-			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
-			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
-			CTRL_SET_HOST_ONLY(high, 0);
-			CTRL_SET_GUEST_ONLY(high, 0);
-
-			CTRL_WRITE(low, high, msrs, i);
-		} else {
-			reset_value[i] = 0;
-		}
-	}
-}
-
-
-static int athlon_check_ctrs(struct pt_regs * const regs,
-			     struct op_msrs const * const msrs)
-{
-	unsigned int low, high;
-	int i;
-
-	for (i = 0 ; i < NUM_COUNTERS; ++i) {
-		if (!reset_value[i])
-			continue;
-		CTR_READ(low, high, msrs, i);
-		if (CTR_OVERFLOWED(low)) {
-			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], msrs, i);
-		}
-	}
-
-	/* See op_model_ppro.c */
-	return 1;
-}
-
-
-static void athlon_start(struct op_msrs const * const msrs)
-{
-	unsigned int low, high;
-	int i;
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (reset_value[i]) {
-			CTRL_READ(low, high, msrs, i);
-			CTRL_SET_ACTIVE(low);
-			CTRL_WRITE(low, high, msrs, i);
-		}
-	}
-}
-
-
-static void athlon_stop(struct op_msrs const * const msrs)
-{
-	unsigned int low, high;
-	int i;
-
-	/* Subtle: stop on all counters to avoid race with
-	 * setting our pm callback */
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (!reset_value[i])
-			continue;
-		CTRL_READ(low, high, msrs, i);
-		CTRL_SET_INACTIVE(low);
-		CTRL_WRITE(low, high, msrs, i);
-	}
-}
-
-static void athlon_shutdown(struct op_msrs const * const msrs)
-{
-	int i;
-
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (CTR_IS_RESERVED(msrs, i))
-			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-	}
-	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
-		if (CTRL_IS_RESERVED(msrs, i))
-			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
-}
-
-struct op_x86_model_spec const op_athlon_spec = {
-	.num_counters = NUM_COUNTERS,
-	.num_controls = NUM_CONTROLS,
-	.fill_in_addresses = &athlon_fill_in_addresses,
-	.setup_ctrs = &athlon_setup_ctrs,
-	.check_ctrs = &athlon_check_ctrs,
-	.start = &athlon_start,
-	.stop = &athlon_stop,
-	.shutdown = &athlon_shutdown
-};
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 45b605f..05a0261 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -32,6 +32,8 @@ struct pt_regs;
  * various x86 CPU models' perfctr support.
  */
 struct op_x86_model_spec {
+	int (*init)(struct oprofile_operations *ops);
+	void (*exit)(void);
 	unsigned int const num_counters;
 	unsigned int const num_controls;
 	void (*fill_in_addresses)(struct op_msrs * const msrs);
@@ -46,6 +48,6 @@ struct op_x86_model_spec {
 extern struct op_x86_model_spec const op_ppro_spec;
 extern struct op_x86_model_spec const op_p4_spec;
 extern struct op_x86_model_spec const op_p4_ht2_spec;
-extern struct op_x86_model_spec const op_athlon_spec;
+extern struct op_x86_model_spec const op_amd_spec;
 
 #endif /* OP_X86_MODEL_H */
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 4bdaa59..3c27a80 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -511,3 +511,31 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, fam10h_pci_cfg_space_size);
+
+/*
+ * SB600: Disable BAR1 on device 14.0 to avoid HPET resources from
+ * confusing the PCI engine:
+ */
+static void sb600_disable_hpet_bar(struct pci_dev *dev)
+{
+	u8 val;
+
+	/*
+	 * The SB600 and SB700 both share the same device
+	 * ID, but the PM register 0x55 does something different
+	 * for the SB700, so make sure we are dealing with the
+	 * SB600 before touching the bit:
+	 */
+
+	pci_read_config_byte(dev, 0x08, &val);
+
+	if (val < 0x2F) {
+		outb(0x55, 0xCD6);
+		val = inb(0xCD7);
+
+		/* Set bit 7 in PM register 0x55 */
+		outb(0x55, 0xCD6);
+		outb(val | 0x80, 0xCD7);
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index b3f5dbc..f3cfb4c 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -53,6 +53,11 @@
 
 #define HPET_RANGE_SIZE		1024	/* from HPET spec */
 
+
+/* WARNING -- don't get confused.  These macros are never used
+ * to write the (single) counter, and rarely to read it.
+ * They're badly named; to fix, someday.
+ */
 #if BITS_PER_LONG == 64
 #define	write_counter(V, MC)	writeq(V, MC)
 #define	read_counter(MC)	readq(MC)
@@ -77,7 +82,7 @@ static struct clocksource clocksource_hpet = {
         .rating         = 250,
         .read           = read_hpet,
         .mask           = CLOCKSOURCE_MASK(64),
-        .mult           = 0, /*to be caluclated*/
+	.mult		= 0, /* to be calculated */
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -86,8 +91,6 @@ static struct clocksource *hpet_clocksource;
 
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);
-/* A lock for concurrent intermodule access to hpet and isr hpet activity. */
-static DEFINE_SPINLOCK(hpet_task_lock);
 
 #define	HPET_DEV_NAME	(7)
 
@@ -99,7 +102,6 @@ struct hpet_dev {
 	unsigned long hd_irqdata;
 	wait_queue_head_t hd_waitqueue;
 	struct fasync_struct *hd_async_queue;
-	struct hpet_task *hd_task;
 	unsigned int hd_flags;
 	unsigned int hd_irq;
 	unsigned int hd_hdwirq;
@@ -173,11 +175,6 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
 		writel(isr, &devp->hd_hpet->hpet_isr);
 	spin_unlock(&hpet_lock);
 
-	spin_lock(&hpet_task_lock);
-	if (devp->hd_task)
-		devp->hd_task->ht_func(devp->hd_task->ht_data);
-	spin_unlock(&hpet_task_lock);
-
 	wake_up_interruptible(&devp->hd_waitqueue);
 
 	kill_fasync(&devp->hd_async_queue, SIGIO, POLL_IN);
@@ -185,6 +182,67 @@ static irqreturn_t hpet_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void hpet_timer_set_irq(struct hpet_dev *devp)
+{
+	unsigned long v;
+	int irq, gsi;
+	struct hpet_timer __iomem *timer;
+
+	spin_lock_irq(&hpet_lock);
+	if (devp->hd_hdwirq) {
+		spin_unlock_irq(&hpet_lock);
+		return;
+	}
+
+	timer = devp->hd_timer;
+
+	/* we prefer level triggered mode */
+	v = readl(&timer->hpet_config);
+	if (!(v & Tn_INT_TYPE_CNF_MASK)) {
+		v |= Tn_INT_TYPE_CNF_MASK;
+		writel(v, &timer->hpet_config);
+	}
+	spin_unlock_irq(&hpet_lock);
+
+	v = (readq(&timer->hpet_config) & Tn_INT_ROUTE_CAP_MASK) >>
+				 Tn_INT_ROUTE_CAP_SHIFT;
+
+	/*
+	 * In PIC mode, skip IRQ0-4, IRQ6-9, IRQ12-15 which is always used by
+	 * legacy device. In IO APIC mode, we skip all the legacy IRQS.
+	 */
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC)
+		v &= ~0xf3df;
+	else
+		v &= ~0xffff;
+
+	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
+		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
+
+		if (irq >= NR_IRQS) {
+			irq = HPET_MAX_IRQ;
+			break;
+		}
+
+		gsi = acpi_register_gsi(irq, ACPI_LEVEL_SENSITIVE,
+					ACPI_ACTIVE_LOW);
+		if (gsi > 0)
+			break;
+
+		/* FIXME: Setup interrupt source table */
+	}
+
+	if (irq < HPET_MAX_IRQ) {
+		spin_lock_irq(&hpet_lock);
+		v = readl(&timer->hpet_config);
+		v |= irq << Tn_INT_ROUTE_CNF_SHIFT;
+		writel(v, &timer->hpet_config);
+		devp->hd_hdwirq = gsi;
+		spin_unlock_irq(&hpet_lock);
+	}
+	return;
+}
+
 static int hpet_open(struct inode *inode, struct file *file)
 {
 	struct hpet_dev *devp;
@@ -199,8 +257,7 @@ static int hpet_open(struct inode *inode, struct file *file)
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
 		for (i = 0; i < hpetp->hp_ntimer; i++)
-			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN
-			    || hpetp->hp_dev[i].hd_task)
+			if (hpetp->hp_dev[i].hd_flags & HPET_OPEN)
 				continue;
 			else {
 				devp = &hpetp->hp_dev[i];
@@ -219,6 +276,8 @@ static int hpet_open(struct inode *inode, struct file *file)
 	spin_unlock_irq(&hpet_lock);
 	unlock_kernel();
 
+	hpet_timer_set_irq(devp);
+
 	return 0;
 }
 
@@ -441,7 +500,11 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 	devp->hd_irq = irq;
 	t = devp->hd_ireqfreq;
 	v = readq(&timer->hpet_config);
-	g = v | Tn_INT_ENB_CNF_MASK;
+
+	/* 64-bit comparators are not yet supported through the ioctls,
+	 * so force this into 32-bit mode if it supports both modes
+	 */
+	g = v | Tn_32MODE_CNF_MASK | Tn_INT_ENB_CNF_MASK;
 
 	if (devp->hd_flags & HPET_PERIODIC) {
 		write_counter(t, &timer->hpet_compare);
@@ -451,6 +514,12 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
 		v |= Tn_VAL_SET_CNF_MASK;
 		writeq(v, &timer->hpet_config);
 		local_irq_save(flags);
+
+		/* NOTE:  what we modify here is a hidden accumulator
+		 * register supported by periodic-capable comparators.
+		 * We never want to modify the (single) counter; that
+		 * would affect all the comparators.
+		 */
 		m = read_counter(&hpet->hpet_mc);
 		write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
 	} else {
@@ -604,57 +673,6 @@ static int hpet_is_known(struct hpet_data *hdp)
 	return 0;
 }
 
-static inline int hpet_tpcheck(struct hpet_task *tp)
-{
-	struct hpet_dev *devp;
-	struct hpets *hpetp;
-
-	devp = tp->ht_opaque;
-
-	if (!devp)
-		return -ENXIO;
-
-	for (hpetp = hpets; hpetp; hpetp = hpetp->hp_next)
-		if (devp >= hpetp->hp_dev
-		    && devp < (hpetp->hp_dev + hpetp->hp_ntimer)
-		    && devp->hd_hpet == hpetp->hp_hpet)
-			return 0;
-
-	return -ENXIO;
-}
-
-#if 0
-int hpet_unregister(struct hpet_task *tp)
-{
-	struct hpet_dev *devp;
-	struct hpet_timer __iomem *timer;
-	int err;
-
-	if ((err = hpet_tpcheck(tp)))
-		return err;
-
-	spin_lock_irq(&hpet_task_lock);
-	spin_lock(&hpet_lock);
-
-	devp = tp->ht_opaque;
-	if (devp->hd_task != tp) {
-		spin_unlock(&hpet_lock);
-		spin_unlock_irq(&hpet_task_lock);
-		return -ENXIO;
-	}
-
-	timer = devp->hd_timer;
-	writeq((readq(&timer->hpet_config) & ~Tn_INT_ENB_CNF_MASK),
-	       &timer->hpet_config);
-	devp->hd_flags &= ~(HPET_IE | HPET_PERIODIC);
-	devp->hd_task = NULL;
-	spin_unlock(&hpet_lock);
-	spin_unlock_irq(&hpet_task_lock);
-
-	return 0;
-}
-#endif  /*  0  */
-
 static ctl_table hpet_table[] = {
 	{
 	 .ctl_name = CTL_UNNUMBERED,
@@ -746,6 +764,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	static struct hpets *last = NULL;
 	unsigned long period;
 	unsigned long long temp;
+	u32 remainder;
 
 	/*
 	 * hpet_alloc can be called by platform dependent code.
@@ -809,9 +828,13 @@ int hpet_alloc(struct hpet_data *hdp)
 		printk("%s %d", i > 0 ? "," : "", hdp->hd_irq[i]);
 	printk("\n");
 
-	printk(KERN_INFO "hpet%u: %u %d-bit timers, %Lu Hz\n",
-	       hpetp->hp_which, hpetp->hp_ntimer,
-	       cap & HPET_COUNTER_SIZE_MASK ? 64 : 32, hpetp->hp_tick_freq);
+	temp = hpetp->hp_tick_freq;
+	remainder = do_div(temp, 1000000);
+	printk(KERN_INFO
+		"hpet%u: %u comparators, %d-bit %u.%06u MHz counter\n",
+		hpetp->hp_which, hpetp->hp_ntimer,
+		cap & HPET_COUNTER_SIZE_MASK ? 64 : 32,
+		(unsigned) temp, remainder);
 
 	mcfg = readq(&hpet->hpet_config);
 	if ((mcfg & HPET_ENABLE_CNF_MASK) == 0) {
@@ -874,8 +897,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 		hdp->hd_address = ioremap(addr.minimum, addr.address_length);
 
 		if (hpet_is_known(hdp)) {
-			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
-				__func__, hdp->hd_phys_address);
 			iounmap(hdp->hd_address);
 			return AE_ALREADY_EXISTS;
 		}
@@ -891,8 +912,6 @@ static acpi_status hpet_resources(struct acpi_resource *res, void *data)
 						HPET_RANGE_SIZE);
 
 		if (hpet_is_known(hdp)) {
-			printk(KERN_DEBUG "%s: 0x%lx is busy\n",
-				__func__, hdp->hd_phys_address);
 			iounmap(hdp->hd_address);
 			return AE_ALREADY_EXISTS;
 		}
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 9304c45..ed98227 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -5,6 +5,7 @@
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Barry Kasindorf
  *
  * This is the core of the buffer management. Each
  * CPU buffer is processed and entered into the
@@ -33,7 +34,7 @@
 #include "event_buffer.h"
 #include "cpu_buffer.h"
 #include "buffer_sync.h"
- 
+
 static LIST_HEAD(dying_tasks);
 static LIST_HEAD(dead_tasks);
 static cpumask_t marked_cpus = CPU_MASK_NONE;
@@ -48,10 +49,11 @@ static void process_task_mortuary(void);
  * Can be invoked from softirq via RCU callback due to
  * call_rcu() of the task struct, hence the _irqsave.
  */
-static int task_free_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+task_free_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	unsigned long flags;
-	struct task_struct * task = data;
+	struct task_struct *task = data;
 	spin_lock_irqsave(&task_mortuary, flags);
 	list_add(&task->tasks, &dying_tasks);
 	spin_unlock_irqrestore(&task_mortuary, flags);
@@ -62,13 +64,14 @@ static int task_free_notify(struct notifier_block * self, unsigned long val, voi
 /* The task is on its way out. A sync of the buffer means we can catch
  * any remaining samples for this task.
  */
-static int task_exit_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+task_exit_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	/* To avoid latency problems, we only process the current CPU,
 	 * hoping that most samples for the task are on this CPU
 	 */
 	sync_buffer(raw_smp_processor_id());
-  	return 0;
+	return 0;
 }
 
 
@@ -77,11 +80,12 @@ static int task_exit_notify(struct notifier_block * self, unsigned long val, voi
  * we don't lose any. This does not have to be exact, it's a QoI issue
  * only.
  */
-static int munmap_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+munmap_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	unsigned long addr = (unsigned long)data;
-	struct mm_struct * mm = current->mm;
-	struct vm_area_struct * mpnt;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *mpnt;
 
 	down_read(&mm->mmap_sem);
 
@@ -99,11 +103,12 @@ static int munmap_notify(struct notifier_block * self, unsigned long val, void *
 	return 0;
 }
 
- 
+
 /* We need to be told about new modules so we don't attribute to a previously
  * loaded module, or drop the samples on the floor.
  */
-static int module_load_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+module_load_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 #ifdef CONFIG_MODULES
 	if (val != MODULE_STATE_COMING)
@@ -118,7 +123,7 @@ static int module_load_notify(struct notifier_block * self, unsigned long val, v
 	return 0;
 }
 
- 
+
 static struct notifier_block task_free_nb = {
 	.notifier_call	= task_free_notify,
 };
@@ -135,7 +140,7 @@ static struct notifier_block module_load_nb = {
 	.notifier_call = module_load_notify,
 };
 
- 
+
 static void end_sync(void)
 {
 	end_cpu_work();
@@ -208,14 +213,14 @@ static inline unsigned long fast_get_dcookie(struct path *path)
  * not strictly necessary but allows oprofile to associate
  * shared-library samples with particular applications
  */
-static unsigned long get_exec_dcookie(struct mm_struct * mm)
+static unsigned long get_exec_dcookie(struct mm_struct *mm)
 {
 	unsigned long cookie = NO_COOKIE;
-	struct vm_area_struct * vma;
- 
+	struct vm_area_struct *vma;
+
 	if (!mm)
 		goto out;
- 
+
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (!vma->vm_file)
 			continue;
@@ -235,13 +240,14 @@ out:
  * sure to do this lookup before a mm->mmap modification happens so
  * we don't lose track.
  */
-static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, off_t * offset)
+static unsigned long
+lookup_dcookie(struct mm_struct *mm, unsigned long addr, off_t *offset)
 {
 	unsigned long cookie = NO_COOKIE;
-	struct vm_area_struct * vma;
+	struct vm_area_struct *vma;
 
 	for (vma = find_vma(mm, addr); vma; vma = vma->vm_next) {
- 
+
 		if (addr < vma->vm_start || addr >= vma->vm_end)
 			continue;
 
@@ -263,9 +269,20 @@ static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, o
 	return cookie;
 }
 
+static void increment_tail(struct oprofile_cpu_buffer *b)
+{
+	unsigned long new_tail = b->tail_pos + 1;
+
+	rmb();	/* be sure fifo pointers are synchromized */
+
+	if (new_tail < b->buffer_size)
+		b->tail_pos = new_tail;
+	else
+		b->tail_pos = 0;
+}
 
 static unsigned long last_cookie = INVALID_COOKIE;
- 
+
 static void add_cpu_switch(int i)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -278,16 +295,16 @@ static void add_kernel_ctx_switch(unsigned int in_kernel)
 {
 	add_event_entry(ESCAPE_CODE);
 	if (in_kernel)
-		add_event_entry(KERNEL_ENTER_SWITCH_CODE); 
+		add_event_entry(KERNEL_ENTER_SWITCH_CODE);
 	else
-		add_event_entry(KERNEL_EXIT_SWITCH_CODE); 
+		add_event_entry(KERNEL_EXIT_SWITCH_CODE);
 }
- 
+
 static void
-add_user_ctx_switch(struct task_struct const * task, unsigned long cookie)
+add_user_ctx_switch(struct task_struct const *task, unsigned long cookie)
 {
 	add_event_entry(ESCAPE_CODE);
-	add_event_entry(CTX_SWITCH_CODE); 
+	add_event_entry(CTX_SWITCH_CODE);
 	add_event_entry(task->pid);
 	add_event_entry(cookie);
 	/* Another code for daemon back-compat */
@@ -296,7 +313,7 @@ add_user_ctx_switch(struct task_struct const * task, unsigned long cookie)
 	add_event_entry(task->tgid);
 }
 
- 
+
 static void add_cookie_switch(unsigned long cookie)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -304,13 +321,78 @@ static void add_cookie_switch(unsigned long cookie)
 	add_event_entry(cookie);
 }
 
- 
+
 static void add_trace_begin(void)
 {
 	add_event_entry(ESCAPE_CODE);
 	add_event_entry(TRACE_BEGIN_CODE);
 }
 
+#ifdef CONFIG_OPROFILE_IBS
+
+#define IBS_FETCH_CODE_SIZE	2
+#define IBS_OP_CODE_SIZE	5
+#define IBS_EIP(offset)				\
+	(((struct op_sample *)&cpu_buf->buffer[(offset)])->eip)
+#define IBS_EVENT(offset)				\
+	(((struct op_sample *)&cpu_buf->buffer[(offset)])->event)
+
+/*
+ * Add IBS fetch and op entries to event buffer
+ */
+static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
+	int in_kernel, struct mm_struct *mm)
+{
+	unsigned long rip;
+	int i, count;
+	unsigned long ibs_cookie = 0;
+	off_t offset;
+
+	increment_tail(cpu_buf);	/* move to RIP entry */
+
+	rip = IBS_EIP(cpu_buf->tail_pos);
+
+#ifdef __LP64__
+	rip += IBS_EVENT(cpu_buf->tail_pos) << 32;
+#endif
+
+	if (mm) {
+		ibs_cookie = lookup_dcookie(mm, rip, &offset);
+
+		if (ibs_cookie == NO_COOKIE)
+			offset = rip;
+		if (ibs_cookie == INVALID_COOKIE) {
+			atomic_inc(&oprofile_stats.sample_lost_no_mapping);
+			offset = rip;
+		}
+		if (ibs_cookie != last_cookie) {
+			add_cookie_switch(ibs_cookie);
+			last_cookie = ibs_cookie;
+		}
+	} else
+		offset = rip;
+
+	add_event_entry(ESCAPE_CODE);
+	add_event_entry(code);
+	add_event_entry(offset);	/* Offset from Dcookie */
+
+	/* we send the Dcookie offset, but send the raw Linear Add also*/
+	add_event_entry(IBS_EIP(cpu_buf->tail_pos));
+	add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+
+	if (code == IBS_FETCH_CODE)
+		count = IBS_FETCH_CODE_SIZE;	/*IBS FETCH is 2 int64s*/
+	else
+		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
+
+	for (i = 0; i < count; i++) {
+		increment_tail(cpu_buf);
+		add_event_entry(IBS_EIP(cpu_buf->tail_pos));
+		add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+	}
+}
+
+#endif
 
 static void add_sample_entry(unsigned long offset, unsigned long event)
 {
@@ -319,13 +401,13 @@ static void add_sample_entry(unsigned long offset, unsigned long event)
 }
 
 
-static int add_us_sample(struct mm_struct * mm, struct op_sample * s)
+static int add_us_sample(struct mm_struct *mm, struct op_sample *s)
 {
 	unsigned long cookie;
 	off_t offset;
- 
- 	cookie = lookup_dcookie(mm, s->eip, &offset);
- 
+
+	cookie = lookup_dcookie(mm, s->eip, &offset);
+
 	if (cookie == INVALID_COOKIE) {
 		atomic_inc(&oprofile_stats.sample_lost_no_mapping);
 		return 0;
@@ -341,13 +423,13 @@ static int add_us_sample(struct mm_struct * mm, struct op_sample * s)
 	return 1;
 }
 
- 
+
 /* Add a sample to the global event buffer. If possible the
  * sample is converted into a persistent dentry/offset pair
  * for later lookup from userspace.
  */
 static int
-add_sample(struct mm_struct * mm, struct op_sample * s, int in_kernel)
+add_sample(struct mm_struct *mm, struct op_sample *s, int in_kernel)
 {
 	if (in_kernel) {
 		add_sample_entry(s->eip, s->event);
@@ -359,9 +441,9 @@ add_sample(struct mm_struct * mm, struct op_sample * s, int in_kernel)
 	}
 	return 0;
 }
- 
 
-static void release_mm(struct mm_struct * mm)
+
+static void release_mm(struct mm_struct *mm)
 {
 	if (!mm)
 		return;
@@ -370,9 +452,9 @@ static void release_mm(struct mm_struct * mm)
 }
 
 
-static struct mm_struct * take_tasks_mm(struct task_struct * task)
+static struct mm_struct *take_tasks_mm(struct task_struct *task)
 {
-	struct mm_struct * mm = get_task_mm(task);
+	struct mm_struct *mm = get_task_mm(task);
 	if (mm)
 		down_read(&mm->mmap_sem);
 	return mm;
@@ -383,10 +465,10 @@ static inline int is_code(unsigned long val)
 {
 	return val == ESCAPE_CODE;
 }
- 
+
 
 /* "acquire" as many cpu buffer slots as we can */
-static unsigned long get_slots(struct oprofile_cpu_buffer * b)
+static unsigned long get_slots(struct oprofile_cpu_buffer *b)
 {
 	unsigned long head = b->head_pos;
 	unsigned long tail = b->tail_pos;
@@ -412,19 +494,6 @@ static unsigned long get_slots(struct oprofile_cpu_buffer * b)
 }
 
 
-static void increment_tail(struct oprofile_cpu_buffer * b)
-{
-	unsigned long new_tail = b->tail_pos + 1;
-
-	rmb();
-
-	if (new_tail < b->buffer_size)
-		b->tail_pos = new_tail;
-	else
-		b->tail_pos = 0;
-}
-
-
 /* Move tasks along towards death. Any tasks on dead_tasks
  * will definitely have no remaining references in any
  * CPU buffers at this point, because we use two lists,
@@ -435,8 +504,8 @@ static void process_task_mortuary(void)
 {
 	unsigned long flags;
 	LIST_HEAD(local_dead_tasks);
-	struct task_struct * task;
-	struct task_struct * ttask;
+	struct task_struct *task;
+	struct task_struct *ttask;
 
 	spin_lock_irqsave(&task_mortuary, flags);
 
@@ -493,7 +562,7 @@ void sync_buffer(int cpu)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
-	struct task_struct * new;
+	struct task_struct *new;
 	unsigned long cookie = 0;
 	int in_kernel = 1;
 	unsigned int i;
@@ -501,7 +570,7 @@ void sync_buffer(int cpu)
 	unsigned long available;
 
 	mutex_lock(&buffer_mutex);
- 
+
 	add_cpu_switch(cpu);
 
 	/* Remember, only we can modify tail_pos */
@@ -509,8 +578,8 @@ void sync_buffer(int cpu)
 	available = get_slots(cpu_buf);
 
 	for (i = 0; i < available; ++i) {
-		struct op_sample * s = &cpu_buf->buffer[cpu_buf->tail_pos];
- 
+		struct op_sample *s = &cpu_buf->buffer[cpu_buf->tail_pos];
+
 		if (is_code(s->eip)) {
 			if (s->event <= CPU_IS_KERNEL) {
 				/* kernel/userspace switch */
@@ -521,8 +590,18 @@ void sync_buffer(int cpu)
 			} else if (s->event == CPU_TRACE_BEGIN) {
 				state = sb_bt_start;
 				add_trace_begin();
+#ifdef CONFIG_OPROFILE_IBS
+			} else if (s->event == IBS_FETCH_BEGIN) {
+				state = sb_bt_start;
+				add_ibs_begin(cpu_buf,
+					IBS_FETCH_CODE, in_kernel, mm);
+			} else if (s->event == IBS_OP_BEGIN) {
+				state = sb_bt_start;
+				add_ibs_begin(cpu_buf,
+					IBS_OP_CODE, in_kernel, mm);
+#endif
 			} else {
-				struct mm_struct * oldmm = mm;
+				struct mm_struct *oldmm = mm;
 
 				/* userspace context switch */
 				new = (struct task_struct *)s->event;
@@ -533,13 +612,11 @@ void sync_buffer(int cpu)
 					cookie = get_exec_dcookie(mm);
 				add_user_ctx_switch(new, cookie);
 			}
-		} else {
-			if (state >= sb_bt_start &&
-			    !add_sample(mm, s, in_kernel)) {
-				if (state == sb_bt_start) {
-					state = sb_bt_ignore;
-					atomic_inc(&oprofile_stats.bt_lost_no_mapping);
-				}
+		} else if (state >= sb_bt_start &&
+			   !add_sample(mm, s, in_kernel)) {
+			if (state == sb_bt_start) {
+				state = sb_bt_ignore;
+				atomic_inc(&oprofile_stats.bt_lost_no_mapping);
 			}
 		}
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 7ba78e6..e1bd5a9 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -5,6 +5,7 @@
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
+ * @author Barry Kasindorf <barry.kasindorf@amd.com>
  *
  * Each CPU has a local buffer that stores PC value/event
  * pairs. We also log context switches when we notice them.
@@ -209,7 +210,7 @@ static int log_sample(struct oprofile_cpu_buffer * cpu_buf, unsigned long pc,
 	return 1;
 }
 
-static int oprofile_begin_trace(struct oprofile_cpu_buffer * cpu_buf)
+static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
 	if (nr_available_slots(cpu_buf) < 4) {
 		cpu_buf->sample_lost_overflow++;
@@ -254,6 +255,75 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 	oprofile_add_ext_sample(pc, regs, event, is_kernel);
 }
 
+#ifdef CONFIG_OPROFILE_IBS
+
+#define MAX_IBS_SAMPLE_SIZE	14
+static int log_ibs_sample(struct oprofile_cpu_buffer *cpu_buf,
+	unsigned long pc, int is_kernel, unsigned  int *ibs, int ibs_code)
+{
+	struct task_struct *task;
+
+	cpu_buf->sample_received++;
+
+	if (nr_available_slots(cpu_buf) < MAX_IBS_SAMPLE_SIZE) {
+		cpu_buf->sample_lost_overflow++;
+		return 0;
+	}
+
+	is_kernel = !!is_kernel;
+
+	/* notice a switch from user->kernel or vice versa */
+	if (cpu_buf->last_is_kernel != is_kernel) {
+		cpu_buf->last_is_kernel = is_kernel;
+		add_code(cpu_buf, is_kernel);
+	}
+
+	/* notice a task switch */
+	if (!is_kernel) {
+		task = current;
+
+		if (cpu_buf->last_task != task) {
+			cpu_buf->last_task = task;
+			add_code(cpu_buf, (unsigned long)task);
+		}
+	}
+
+	add_code(cpu_buf, ibs_code);
+	add_sample(cpu_buf, ibs[0], ibs[1]);
+	add_sample(cpu_buf, ibs[2], ibs[3]);
+	add_sample(cpu_buf, ibs[4], ibs[5]);
+
+	if (ibs_code == IBS_OP_BEGIN) {
+	add_sample(cpu_buf, ibs[6], ibs[7]);
+	add_sample(cpu_buf, ibs[8], ibs[9]);
+	add_sample(cpu_buf, ibs[10], ibs[11]);
+	}
+
+	return 1;
+}
+
+void oprofile_add_ibs_sample(struct pt_regs *const regs,
+				unsigned int * const ibs_sample, u8 code)
+{
+	int is_kernel = !user_mode(regs);
+	unsigned long pc = profile_pc(regs);
+
+	struct oprofile_cpu_buffer *cpu_buf =
+			 &per_cpu(cpu_buffer, smp_processor_id());
+
+	if (!backtrace_depth) {
+		log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code);
+		return;
+	}
+
+	/* if log_sample() fails we can't backtrace since we lost the source
+	* of this event */
+	if (log_ibs_sample(cpu_buf, pc, is_kernel, ibs_sample, code))
+		oprofile_ops.backtrace(regs, backtrace_depth);
+}
+
+#endif
+
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
@@ -296,7 +366,7 @@ static void wq_sync_buffer(struct work_struct *work)
 	struct oprofile_cpu_buffer * b =
 		container_of(work, struct oprofile_cpu_buffer, work.work);
 	if (b->cpu != smp_processor_id()) {
-		printk("WQ on CPU%d, prefer CPU%d\n",
+		printk(KERN_DEBUG "WQ on CPU%d, prefer CPU%d\n",
 		       smp_processor_id(), b->cpu);
 	}
 	sync_buffer(b->cpu);
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index c3e366b..9c44d00 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -55,5 +55,7 @@ void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
 #define CPU_TRACE_BEGIN 2
+#define IBS_FETCH_BEGIN 3
+#define IBS_OP_BEGIN    4
 
 #endif /* OPROFILE_CPU_BUFFER_H */
diff --git a/include/asm-x86/desc.h b/include/asm-x86/desc.h
index ebc3078..f06adac 100644
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -351,20 +351,16 @@ static inline void set_system_intr_gate(unsigned int n, void *addr)
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
 }
 
-static inline void set_trap_gate(unsigned int n, void *addr)
+static inline void set_system_trap_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_TRAP, addr, 0, 0, __KERNEL_CS);
+	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
 }
 
-static inline void set_system_gate(unsigned int n, void *addr)
+static inline void set_trap_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
-#ifdef CONFIG_X86_32
-	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
-#else
-	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
-#endif
+	_set_gate(n, GATE_TRAP, addr, 0, 0, __KERNEL_CS);
 }
 
 static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
@@ -379,7 +375,7 @@ static inline void set_intr_gate_ist(int n, void *addr, unsigned ist)
 	_set_gate(n, GATE_INTERRUPT, addr, 0, ist, __KERNEL_CS);
 }
 
-static inline void set_system_gate_ist(int n, void *addr, unsigned ist)
+static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 {
 	BUG_ON((unsigned)n > 0xFF);
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
diff --git a/include/asm-x86/es7000/mpparse.h b/include/asm-x86/es7000/mpparse.h
index 7b5c889..ed5a3ca 100644
--- a/include/asm-x86/es7000/mpparse.h
+++ b/include/asm-x86/es7000/mpparse.h
@@ -5,6 +5,7 @@
 
 extern int parse_unisys_oem (char *oemptr);
 extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
 extern void setup_unisys(void);
 
 #ifndef CONFIG_X86_GENERICARCH
diff --git a/include/asm-x86/fixmap_32.h b/include/asm-x86/fixmap_32.h
index 784e3e7..8844002 100644
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -94,10 +94,10 @@ enum fixed_addresses {
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_NESTING	4
+#define FIX_BTMAPS_SLOTS	4
 	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
 			(__end_of_permanent_fixed_addresses & 255),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
 	FIX_WP_TEST,
 #ifdef CONFIG_ACPI
 	FIX_ACPI_BEGIN,
diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
index dafb24b..dab4751 100644
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -49,6 +49,7 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
+	__end_of_permanent_fixed_addresses,
 #ifdef CONFIG_ACPI
 	FIX_ACPI_BEGIN,
 	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
@@ -56,19 +57,18 @@ enum fixed_addresses {
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
-	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 *
-	 * We round it up to the next 512 pages boundary so that we
+	 * We round it up to the next 256 pages boundary so that we
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_NESTING	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 512 -
-			(__end_of_permanent_fixed_addresses & 511),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
+#define FIX_BTMAPS_SLOTS	4
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
+			(__end_of_permanent_fixed_addresses & 255),
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
 	__end_of_fixed_addresses
 };
 
diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
index 72b7719..a233f83 100644
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -5,20 +5,6 @@
 
 #include <linux/compiler.h>
 
-/*
- * early_ioremap() and early_iounmap() are for temporary early boot-time
- * mappings, before the real ioremap() is functional.
- * A boot-time mapping is currently limited to at most 16 pages.
- */
-#ifndef __ASSEMBLY__
-extern void early_ioremap_init(void);
-extern void early_ioremap_clear(void);
-extern void early_ioremap_reset(void);
-extern void *early_ioremap(unsigned long offset, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
-extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
-#endif
-
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
 { type ret; asm volatile("mov" size " %1,%0":reg (ret) \
@@ -97,6 +83,7 @@ extern void early_ioremap_init(void);
 extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
 extern void *early_ioremap(unsigned long offset, unsigned long size);
+extern void *early_memremap(unsigned long offset, unsigned long size);
 extern void early_iounmap(void *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index 64429e9..ee6e086 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -165,9 +165,6 @@ static inline void *phys_to_virt(unsigned long address)
 
 #include <asm-generic/iomap.h>
 
-extern void *early_ioremap(unsigned long addr, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
-
 /*
  * This one maps high address device memory and turns off caching for that area.
  * it's useful if some control registers are in such an area and write combining
diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
index 424acb4..2bdab21 100644
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -166,27 +166,6 @@ static inline int raw_irqs_disabled(void)
 	return raw_irqs_disabled_flags(flags);
 }
 
-/*
- * makes the traced hardirq state match with the machine state
- *
- * should be a rarely used function, only in places where its
- * otherwise impossible to know the irq state, like in traps.
- */
-static inline void trace_hardirqs_fixup_flags(unsigned long flags)
-{
-	if (raw_irqs_disabled_flags(flags))
-		trace_hardirqs_off();
-	else
-		trace_hardirqs_on();
-}
-
-static inline void trace_hardirqs_fixup(void)
-{
-	unsigned long flags = __raw_local_save_flags();
-
-	trace_hardirqs_fixup_flags(flags);
-}
-
 #else
 
 #ifdef CONFIG_X86_64
diff --git a/include/asm-x86/kdebug.h b/include/asm-x86/kdebug.h
index 5ec3ad3..fbbab66 100644
--- a/include/asm-x86/kdebug.h
+++ b/include/asm-x86/kdebug.h
@@ -27,10 +27,9 @@ extern void printk_address(unsigned long address, int reliable);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
-extern void __show_registers(struct pt_regs *, int all);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
-extern void __show_regs(struct pt_regs *regs);
+extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index bd84078..8a0748d 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -82,15 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe;
 };
 
-/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
- * if necessary, before executing the original int3/1 (trap) handler.
- */
-static inline void restore_interrupts(struct pt_regs *regs)
-{
-	if (regs->flags & X86_EFLAGS_IF)
-		local_irq_enable();
-}
-
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
diff --git a/include/asm-x86/mach-default/mach_traps.h b/include/asm-x86/mach-default/mach_traps.h
index de9ac3f..ff8778f 100644
--- a/include/asm-x86/mach-default/mach_traps.h
+++ b/include/asm-x86/mach-default/mach_traps.h
@@ -7,12 +7,6 @@
 
 #include <asm/mc146818rtc.h>
 
-static inline void clear_mem_error(unsigned char reason)
-{
-	reason = (reason & 0xf) | 4;
-	outb(reason, 0x61);
-}
-
 static inline unsigned char get_nmi_reason(void)
 {
 	return inb(0x61);
diff --git a/include/asm-x86/module.h b/include/asm-x86/module.h
index 48dc3e0..864f200 100644
--- a/include/asm-x86/module.h
+++ b/include/asm-x86/module.h
@@ -52,8 +52,6 @@ struct mod_arch_specific {};
 #define MODULE_PROC_FAMILY "EFFICEON "
 #elif defined CONFIG_MWINCHIPC6
 #define MODULE_PROC_FAMILY "WINCHIPC6 "
-#elif defined CONFIG_MWINCHIP2
-#define MODULE_PROC_FAMILY "WINCHIP2 "
 #elif defined CONFIG_MWINCHIP3D
 #define MODULE_PROC_FAMILY "WINCHIP3D "
 #elif defined CONFIG_MCYRIXIII
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index d5e715f..a53f829 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -15,10 +15,6 @@
  */
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
-#ifdef CONFIG_X86_64
-extern void default_do_nmi(struct pt_regs *);
-#endif
-
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index c915747..d4f1d57 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -179,6 +179,7 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #endif	/* CONFIG_PARAVIRT */
 
 #define __pa(x)		__phys_addr((unsigned long)(x))
+#define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
 #define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
@@ -188,9 +189,14 @@ static inline pteval_t native_pte_flags(pte_t pte)
 #define __boot_va(x)		__va(x)
 #define __boot_pa(x)		__pa(x)
 
+/*
+ * virt_to_page(kaddr) returns a valid pointer if and only if
+ * virt_addr_valid(kaddr) returns true.
+ */
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+extern bool __virt_addr_valid(unsigned long kaddr);
+#define virt_addr_valid(kaddr)	__virt_addr_valid((unsigned long) (kaddr))
 
 #endif	/* __ASSEMBLY__ */
 
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 9c5a737..e8d80d1 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -20,6 +20,12 @@
 #endif
 #define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
 
+#define STACKFAULT_STACK 0
+#define DOUBLEFAULT_STACK 1
+#define NMI_STACK 0
+#define DEBUG_STACK 0
+#define MCE_STACK 0
+#define N_EXCEPTION_STACKS 1
 
 #ifdef CONFIG_X86_PAE
 /* 44=32+12, the limit we can fit into an unsigned long pfn */
@@ -73,11 +79,11 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifndef __ASSEMBLY__
-#define __phys_addr_const(x)	((x) - PAGE_OFFSET)
+#define __phys_addr_nodebug(x)	((x) - PAGE_OFFSET)
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
 #else
-#define __phys_addr(x)		((x) - PAGE_OFFSET)
+#define __phys_addr(x)		__phys_addr_nodebug(x)
 #endif
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index ed93245..182f9d4 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -15,7 +15,7 @@
 #define _PAGE_BIT_PAT		7	/* on 4KB pages */
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
-#define _PAGE_BIT_UNUSED2	10
+#define _PAGE_BIT_IOMAP		10	/* flag used to indicate IO mapping */
 #define _PAGE_BIT_UNUSED3	11
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
@@ -32,7 +32,7 @@
 #define _PAGE_PSE	(_AT(pteval_t, 1) << _PAGE_BIT_PSE)
 #define _PAGE_GLOBAL	(_AT(pteval_t, 1) << _PAGE_BIT_GLOBAL)
 #define _PAGE_UNUSED1	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED1)
-#define _PAGE_UNUSED2	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED2)
+#define _PAGE_IOMAP	(_AT(pteval_t, 1) << _PAGE_BIT_IOMAP)
 #define _PAGE_UNUSED3	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED3)
 #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
@@ -99,6 +99,11 @@
 #define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
 
+#define __PAGE_KERNEL_IO		(__PAGE_KERNEL | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_UC_MINUS	(__PAGE_KERNEL_UC_MINUS | _PAGE_IOMAP)
+#define __PAGE_KERNEL_IO_WC		(__PAGE_KERNEL_WC | _PAGE_IOMAP)
+
 #define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
 #define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
@@ -113,6 +118,11 @@
 #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
 #define PAGE_KERNEL_VSYSCALL_NOCACHE	__pgprot(__PAGE_KERNEL_VSYSCALL_NOCACHE)
 
+#define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
+#define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
+#define PAGE_KERNEL_IO_UC_MINUS		__pgprot(__PAGE_KERNEL_IO_UC_MINUS)
+#define PAGE_KERNEL_IO_WC		__pgprot(__PAGE_KERNEL_IO_WC)
+
 /*         xwr */
 #define __P000	PAGE_NONE
 #define __P001	PAGE_READONLY
@@ -196,7 +206,7 @@ static inline int pte_exec(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_SPECIAL;
+	return pte_flags(pte) & _PAGE_SPECIAL;
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index ac578f1..a202552 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -174,12 +174,8 @@ extern unsigned long profile_pc(struct pt_regs *regs);
 
 extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
-
-#ifdef CONFIG_X86_32
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code, int si_code);
-#endif
-
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 extern long syscall_trace_enter(struct pt_regs *);
diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index ea5f0a8..5d6e694 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -131,12 +131,6 @@
  * Matching rules for certain types of segments.
  */
 
-/* Matches only __KERNEL_CS, ignoring PnP / USER / APM segments */
-#define SEGMENT_IS_KERNEL_CODE(x) (((x) & 0xfc) == GDT_ENTRY_KERNEL_CS * 8)
-
-/* Matches __KERNEL_CS and __USER_CS (they must be 2 entries apart) */
-#define SEGMENT_IS_FLAT_CODE(x)  (((x) & 0xec) == GDT_ENTRY_KERNEL_CS * 8)
-
 /* Matches PNP_CS32 and PNP_CS16 (they must be consecutive) */
 #define SEGMENT_IS_PNP_CODE(x)   (((x) & 0xf4) == GDT_ENTRY_PNPBIOS_BASE * 8)
 
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 6df2615..a6afc29 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -141,6 +141,8 @@ void play_dead_common(void);
 void native_send_call_func_ipi(cpumask_t mask);
 void native_send_call_func_single_ipi(int cpu);
 
+extern void prefill_possible_map(void);
+
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
@@ -149,15 +151,11 @@ static inline int num_booting_cpus(void)
 {
 	return cpus_weight(cpu_callout_map);
 }
-#endif /* CONFIG_SMP */
-
-#if defined(CONFIG_SMP) && defined(CONFIG_HOTPLUG_CPU)
-extern void prefill_possible_map(void);
 #else
 static inline void prefill_possible_map(void)
 {
 }
-#endif
+#endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
 
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 34505dd..b20c894 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -64,7 +64,10 @@ do {									\
 		       							\
 		       /* regparm parameters for __switch_to(): */	\
 		       [prev]     "a" (prev),				\
-		       [next]     "d" (next));				\
+		       [next]     "d" (next)				\
+									\
+		     : /* reloaded segment registers */			\
+			"memory");					\
 } while (0)
 
 /*
diff --git a/include/asm-x86/traps.h b/include/asm-x86/traps.h
index 7a692ba..6c3dc2c 100644
--- a/include/asm-x86/traps.h
+++ b/include/asm-x86/traps.h
@@ -3,7 +3,12 @@
 
 #include <asm/debugreg.h>
 
-/* Common in X86_32 and X86_64 */
+#ifdef CONFIG_X86_32
+#define dotraplinkage
+#else
+#define dotraplinkage asmlinkage
+#endif
+
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
 asmlinkage void nmi(void);
@@ -12,31 +17,47 @@ asmlinkage void overflow(void);
 asmlinkage void bounds(void);
 asmlinkage void invalid_op(void);
 asmlinkage void device_not_available(void);
+#ifdef CONFIG_X86_64
+asmlinkage void double_fault(void);
+#endif
 asmlinkage void coprocessor_segment_overrun(void);
 asmlinkage void invalid_TSS(void);
 asmlinkage void segment_not_present(void);
 asmlinkage void stack_segment(void);
 asmlinkage void general_protection(void);
 asmlinkage void page_fault(void);
+asmlinkage void spurious_interrupt_bug(void);
 asmlinkage void coprocessor_error(void);
-asmlinkage void simd_coprocessor_error(void);
 asmlinkage void alignment_check(void);
-asmlinkage void spurious_interrupt_bug(void);
 #ifdef CONFIG_X86_MCE
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
+asmlinkage void simd_coprocessor_error(void);
 
-void do_divide_error(struct pt_regs *, long);
-void do_overflow(struct pt_regs *, long);
-void do_bounds(struct pt_regs *, long);
-void do_coprocessor_segment_overrun(struct pt_regs *, long);
-void do_invalid_TSS(struct pt_regs *, long);
-void do_segment_not_present(struct pt_regs *, long);
-void do_stack_segment(struct pt_regs *, long);
-void do_alignment_check(struct pt_regs *, long);
-void do_invalid_op(struct pt_regs *, long);
-void do_general_protection(struct pt_regs *, long);
-void do_nmi(struct pt_regs *, long);
+dotraplinkage void do_divide_error(struct pt_regs *, long);
+dotraplinkage void do_debug(struct pt_regs *, long);
+dotraplinkage void do_nmi(struct pt_regs *, long);
+dotraplinkage void do_int3(struct pt_regs *, long);
+dotraplinkage void do_overflow(struct pt_regs *, long);
+dotraplinkage void do_bounds(struct pt_regs *, long);
+dotraplinkage void do_invalid_op(struct pt_regs *, long);
+dotraplinkage void do_device_not_available(struct pt_regs *, long);
+dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
+dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
+dotraplinkage void do_segment_not_present(struct pt_regs *, long);
+dotraplinkage void do_stack_segment(struct pt_regs *, long);
+dotraplinkage void do_general_protection(struct pt_regs *, long);
+dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
+dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
+dotraplinkage void do_coprocessor_error(struct pt_regs *, long);
+dotraplinkage void do_alignment_check(struct pt_regs *, long);
+#ifdef CONFIG_X86_MCE
+dotraplinkage void do_machine_check(struct pt_regs *, long);
+#endif
+dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
+#ifdef CONFIG_X86_32
+dotraplinkage void do_iret_error(struct pt_regs *, long);
+#endif
 
 static inline int get_si_code(unsigned long condition)
 {
@@ -52,31 +73,9 @@ extern int panic_on_unrecovered_nmi;
 extern int kstack_depth_to_print;
 
 #ifdef CONFIG_X86_32
-
-void do_iret_error(struct pt_regs *, long);
-void do_int3(struct pt_regs *, long);
-void do_debug(struct pt_regs *, long);
 void math_error(void __user *);
-void do_coprocessor_error(struct pt_regs *, long);
-void do_simd_coprocessor_error(struct pt_regs *, long);
-void do_spurious_interrupt_bug(struct pt_regs *, long);
 unsigned long patch_espfix_desc(unsigned long, unsigned long);
 asmlinkage void math_emulate(long);
+#endif
 
-void do_page_fault(struct pt_regs *regs, unsigned long error_code);
-
-#else /* CONFIG_X86_32 */
-
-asmlinkage void double_fault(void);
-
-asmlinkage void do_int3(struct pt_regs *, long);
-asmlinkage void do_stack_segment(struct pt_regs *, long);
-asmlinkage void do_debug(struct pt_regs *, unsigned long);
-asmlinkage void do_coprocessor_error(struct pt_regs *);
-asmlinkage void do_simd_coprocessor_error(struct pt_regs *);
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs *);
-
-asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long error_code);
-
-#endif /* CONFIG_X86_32 */
 #endif /* ASM_X86__TRAPS_H */
diff --git a/include/linux/hpet.h b/include/linux/hpet.h
index 2dc29ce..79f63a2 100644
--- a/include/linux/hpet.h
+++ b/include/linux/hpet.h
@@ -37,6 +37,7 @@ struct hpet {
 #define	hpet_compare	_u1._hpet_compare
 
 #define	HPET_MAX_TIMERS	(32)
+#define	HPET_MAX_IRQ	(32)
 
 /*
  * HPET general capabilities register
@@ -64,7 +65,7 @@ struct hpet {
  */
 
 #define	Tn_INT_ROUTE_CAP_MASK		(0xffffffff00000000ULL)
-#define	Tn_INI_ROUTE_CAP_SHIFT		(32UL)
+#define	Tn_INT_ROUTE_CAP_SHIFT		(32UL)
 #define	Tn_FSB_INT_DELCAP_MASK		(0x8000UL)
 #define	Tn_FSB_INT_DELCAP_SHIFT		(15)
 #define	Tn_FSB_EN_CNF_MASK		(0x4000UL)
@@ -91,23 +92,14 @@ struct hpet {
  * exported interfaces
  */
 
-struct hpet_task {
-	void (*ht_func) (void *);
-	void *ht_data;
-	void *ht_opaque;
-};
-
 struct hpet_data {
 	unsigned long hd_phys_address;
 	void __iomem *hd_address;
 	unsigned short hd_nirqs;
-	unsigned short hd_flags;
 	unsigned int hd_state;	/* timer allocated */
 	unsigned int hd_irq[HPET_MAX_TIMERS];
 };
 
-#define	HPET_DATA_PLATFORM	0x0001	/* platform call to hpet_alloc */
-
 static inline void hpet_reserve_timer(struct hpet_data *hd, int timer)
 {
 	hd->hd_state |= (1 << timer);
@@ -125,7 +117,7 @@ struct hpet_info {
 	unsigned short hi_timer;
 };
 
-#define	HPET_INFO_PERIODIC	0x0001	/* timer is periodic */
+#define HPET_INFO_PERIODIC	0x0010	/* periodic-capable comparator */
 
 #define	HPET_IE_ON	_IO('h', 0x01)	/* interrupt on */
 #define	HPET_IE_OFF	_IO('h', 0x02)	/* interrupt off */
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 041bb31..bcb8f72 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -36,6 +36,8 @@
 #define XEN_ENTER_SWITCH_CODE		10
 #define SPU_PROFILING_CODE		11
 #define SPU_CTX_SWITCH_CODE		12
+#define IBS_FETCH_CODE			13
+#define IBS_OP_CODE			14
 
 struct super_block;
 struct dentry;
