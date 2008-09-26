Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYIZLBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYIZLBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 07:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYIZLBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 07:01:34 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:12472 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751783AbYIZLBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 07:01:31 -0400
Date: Fri, 26 Sep 2008 20:01:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: What's in sh-2.6.git for 2.6.28?
Message-ID: <20080926110124.GA18957@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a brief summary of the changes that are sitting in the sh queue
for 2.6.28.

There are quite a few changes all over the place. The main items are:

	- tracehook support
	- ftrace support
	- kprobes/kretprobes support
	- latencytop support

Tracehook support presently includes all of the general registers, DSP
registers, and hard FPU registers. There is still some outstanding work
for tying in the math emulation code in to the same interface, but as
we've never supported that through ptrace before, it will be an
incremental change. It passes the utrace tests, and ELF core dumps have
been switched over to using the shiny new regset interface.

As far as ftrace goes, only static ftrace is presently implemented. I'm
presently hacking on some trampoline code to get dynamic ftrace working,
but that's 2.6.29 material at this point.

The kprobes implementation is somewhat of a combined effort of all of the
various implementations that were floating around over the years, and
is based on the version ST has been shipping for some time.

Other misc stuff include new board support (EDOSK7760), support for
kernel stacks < PAGE_SIZE, optimized delay loop calibration, memory
hot-unplug, tickless fixes, SH4-A optimized bitops/cmpxchg, lots of
sparse fixes, and some SMP work for platforms lacking local timers.

As usual, the tree is at:

        git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Carl Shaw (1):
      sh: Subnormal double to float conversion

Chris Smith (2):
      sh: Fix uImage load address in 32-bit mode.
      sh: Add kprobes support.

Francesco Virlinzi (1):
      sh: fix the TMU code to allow a fully running NO_HZ system

Luca Santini (5):
      sh: Enable IRLM mode for SH7760 IRQ_MODE_IRQ.
      sh: Add Renesas EDOSK7760 board support.
      sh: edosk7760 physmap-flash support.
      sh: update edosk7760 defconfig for physmap-flash.
      sh: edosk7760: Correct size of bootloader flash partition.

Marek Skuczynski (1):
      sh: remove unnecessary memset after alloc_bootmem_low_pages

Nobuhiro Iwamatsu (1):
      sh: ap325rxa: create CPLD data area in mtd

Paul Mundt (59):
      sh: Provide movli.l/movco.l-based bitops.
      sh: Provide movli.l/movco.l-based cmpxchg.
      sh: Kill off unused defines from asm/smp.h.
      sh: smp: Provide a generic IPI handler.
      sh: smp: Hook in to the generic IPI handler for SH-X3 SMP.
      sh: smp: Hook up a timer IPI stub.
      sh: generic clockevent broadcast support.
      sh: smp: shove a cpu_relax() in the plat_start_cpu() busy loop.
      sh: Early dummy clockevent registration on boot CPU.
      sh: Display CPU information in show_regs().
      sh: fixup many sparse errors.
      sh: Don't enable clockevents broadcasting on UP SH-X3 builds.
      sh: Add support for memory hot-remove.
      sh: Add the rest of the boot targets to arch/sh/boot/.gitignore.
      sh: uninline flush_icache_all().
      sh: Add EDOSK7760 mach type.
      sh: Mark kretprobe_trampoline_holder static and __used.
      sh: Disable seccomp support by default.
      sh: kprobes: Hook up kprobe_fault_handler() in the page fault path.
      sh: kprobes: Use trapa #0x3a for breakpoint trap.
      sh: kprobes: Default to NOTIFY_DONE for unhandled debug traps.
      sh: kprobes: Fix up a preemption imbalance on jprobe return.
      sh: kprobes: Fix up race against probe point removal.
      sh: kprobes: __kprobes annotations and formatting cleanups.
      sh: Derive calibrate_delay lpj from clk fwk.
      sh: Add R2D+ defconfig for qemu system emulator.
      sh: kprobes: kretprobe_trampoline needs to be global.
      sh: Provide a fixed UTS_MACHINE definition for sh64.
      sh: ptrace: Introduce user_regset interface for gp regs.
      sh: ioremap_prot support.
      sh: Flag T-bit for syscall restart.
      sh: provide user_stack_pointer(), needed for tracehook support.
      sh: Provide the asm/syscall.h interface, needed by tracehook.
      sh: Enable HAVE_ARCH_TRACEHOOK.
      sh: Fix up NUMA build error with se7722_defconfig.
      sh: Add DSP registers to regset interface.
      sh: Add missing task_user_regset_view() definition.
      sh: Check SR.DSP bit for DSP regset validity.
      sh: Tidy up ELF core dumps.
      sh: latencytop support.
      sh: Fix up fpu emu build.
      sh: Make memory hot-add and hot-remove depend on MMU.
      sh: Fix up signal_64 conflicting handle_signal() definition.
      sh: Consolidate struct sh_cpuinfo definitions across _32/_64 split.
      sh: Fix up headers_check regression.
      sh: HAVE_IOREMAP_PROT depends on MMU.
      sh: Disable 4kB stacks when using PAGE_SIZE_64KB.
      sh: Support kernel stacks smaller than a page.
      sh: Copy in asm/sizes.h helper from ARM.
      sh: Add a few more definitions to asm/sizes.h.
      sh: Move lookup_exception_vector() out to asm/system_32.h.
      sh: Look up the trap vector for the page fault notifier.
      sh: Kill off duplicate page fault notifiers in slow path.
      sh: Trivial trace_mark() instrumentation for core events.
      sh: ftrace support.
      doc: Add remaining SH parameters to kernel-parameters.txt.
      sh: Add missing asm/ftrace.h.
      sh: Add FPU registers to regset interface.
      sh: Force pending restarted system calls to return -EINTR.

Stuart Menefy (4):
      sh: early cached_to_uncached initialization.
      sh: Fix up broken 32-bit initrd support.
      sh: vmalloc pgtable sync fix.
      sh: Fix an unusual memory initialisation error.

roel kluin (3):
      sh: intc_prio_data() test before subtraction on unsigned
      sh_eth: unsigned ndev->irq cannot be negative
      rtc-sh: Unsigned rtc->{periodic,carry,alarm}_irq cannot be negative

 Documentation/kernel-parameters.txt           |   12 +-
 arch/sh/Kconfig                               |   17 +-
 arch/sh/Kconfig.debug                         |    2 +-
 arch/sh/Makefile                              |    2 +
 arch/sh/boards/Kconfig                        |    7 +
 arch/sh/boards/Makefile                       |    1 +
 arch/sh/boards/board-ap325rxa.c               |   33 +-
 arch/sh/boards/board-edosk7760.c              |  193 +++++
 arch/sh/boot/.gitignore                       |    3 +
 arch/sh/boot/Makefile                         |    6 +
 arch/sh/boot/compressed/Makefile_32           |    5 +
 arch/sh/boot/compressed/misc_32.c             |    2 +-
 arch/sh/configs/edosk7760_defconfig           | 1050 +++++++++++++++++++++++++
 arch/sh/configs/rts7751r2dplus_qemu_defconfig |  909 +++++++++++++++++++++
 arch/sh/include/asm/bitops-llsc.h             |  144 ++++
 arch/sh/include/asm/bitops.h                  |    2 +
 arch/sh/include/asm/clock.h                   |    1 +
 arch/sh/include/asm/cmpxchg-llsc.h            |   71 ++
 arch/sh/include/asm/elf.h                     |   14 +-
 arch/sh/include/asm/fpu.h                     |   19 +
 arch/sh/include/asm/ftrace.h                  |    8 +
 arch/sh/include/asm/io.h                      |    6 +-
 arch/sh/include/asm/irq.h                     |    3 +
 arch/sh/include/asm/kprobes.h                 |   58 ++
 arch/sh/include/asm/mmzone.h                  |    2 +
 arch/sh/include/asm/page.h                    |    2 +
 arch/sh/include/asm/pgtable.h                 |    1 +
 arch/sh/include/asm/processor.h               |   44 +-
 arch/sh/include/asm/processor_32.h            |   22 +-
 arch/sh/include/asm/processor_64.h            |   45 +-
 arch/sh/include/asm/ptrace.h                  |   11 +-
 arch/sh/include/asm/rtc.h                     |    1 +
 arch/sh/include/asm/setup.h                   |    1 -
 arch/sh/include/asm/sizes.h                   |   61 ++
 arch/sh/include/asm/smp.h                     |   26 +-
 arch/sh/include/asm/syscall.h                 |   10 +
 arch/sh/include/asm/syscall_32.h              |  110 +++
 arch/sh/include/asm/syscall_64.h              |    6 +
 arch/sh/include/asm/syscalls.h                |   25 +
 arch/sh/include/asm/syscalls_32.h             |   56 ++
 arch/sh/include/asm/syscalls_64.h             |   34 +
 arch/sh/include/asm/system.h                  |    8 +-
 arch/sh/include/asm/system_32.h               |   44 +-
 arch/sh/include/asm/thread_info.h             |   32 +-
 arch/sh/kernel/Makefile_32                    |    2 +-
 arch/sh/kernel/Makefile_64                    |    1 -
 arch/sh/kernel/cpu/clock.c                    |    5 +-
 arch/sh/kernel/cpu/irq/intc.c                 |   10 +-
 arch/sh/kernel/cpu/sh4/fpu.c                  |   25 +-
 arch/sh/kernel/cpu/sh4/setup-sh7760.c         |    5 +
 arch/sh/kernel/cpu/sh4/softfloat.c            |   29 +
 arch/sh/kernel/cpu/sh4a/smp-shx3.c            |   67 +-
 arch/sh/kernel/dump_task.c                    |   32 -
 arch/sh/kernel/entry-common.S                 |   44 +
 arch/sh/kernel/io_generic.c                   |    6 +-
 arch/sh/kernel/kprobes.c                      |  584 ++++++++++++++
 arch/sh/kernel/machvec.c                      |    1 +
 arch/sh/kernel/process_32.c                   |   36 +-
 arch/sh/kernel/process_64.c                   |   11 +-
 arch/sh/kernel/ptrace_32.c                    |  298 ++++++--
 arch/sh/kernel/ptrace_64.c                    |    1 +
 arch/sh/kernel/setup.c                        |   48 +-
 arch/sh/kernel/sh_ksyms_32.c                  |    4 +
 arch/sh/kernel/signal_32.c                    |   69 +-
 arch/sh/kernel/signal_64.c                    |   22 +-
 arch/sh/kernel/smp.c                          |   43 +-
 arch/sh/kernel/stacktrace.c                   |   23 +-
 arch/sh/kernel/sys_sh.c                       |    9 +-
 arch/sh/kernel/sys_sh32.c                     |    5 +-
 arch/sh/kernel/time_32.c                      |   11 +-
 arch/sh/kernel/timers/Makefile                |    1 +
 arch/sh/kernel/timers/timer-broadcast.c       |   57 ++
 arch/sh/kernel/timers/timer-cmt.c             |    2 +-
 arch/sh/kernel/timers/timer-tmu.c             |  177 +++--
 arch/sh/kernel/traps_32.c                     |   95 ++--
 arch/sh/lib/div64-generic.c                   |    1 +
 arch/sh/mm/Kconfig                            |    6 +-
 arch/sh/mm/cache-sh4.c                        |    2 +-
 arch/sh/mm/consistent.c                       |    2 +-
 arch/sh/mm/fault_32.c                         |   63 ++-
 arch/sh/mm/init.c                             |   74 ++-
 arch/sh/mm/pg-nommu.c                         |    1 +
 arch/sh/mm/tlb-nommu.c                        |    1 +
 arch/sh/tools/mach-types                      |    1 +
 drivers/net/sh_eth.c                          |    5 +-
 drivers/rtc/rtc-sh.c                          |   21 +-
 drivers/serial/sh-sci.c                       |    2 +-
 87 files changed, 4541 insertions(+), 470 deletions(-)
 create mode 100644 arch/sh/boards/board-edosk7760.c
 create mode 100644 arch/sh/configs/edosk7760_defconfig
 create mode 100644 arch/sh/configs/rts7751r2dplus_qemu_defconfig
 create mode 100644 arch/sh/include/asm/bitops-llsc.h
 create mode 100644 arch/sh/include/asm/cmpxchg-llsc.h
 create mode 100644 arch/sh/include/asm/ftrace.h
 create mode 100644 arch/sh/include/asm/kprobes.h
 create mode 100644 arch/sh/include/asm/sizes.h
 create mode 100644 arch/sh/include/asm/syscall.h
 create mode 100644 arch/sh/include/asm/syscall_32.h
 create mode 100644 arch/sh/include/asm/syscall_64.h
 create mode 100644 arch/sh/include/asm/syscalls.h
 create mode 100644 arch/sh/include/asm/syscalls_32.h
 create mode 100644 arch/sh/include/asm/syscalls_64.h
 delete mode 100644 arch/sh/kernel/dump_task.c
 create mode 100644 arch/sh/kernel/kprobes.c
 create mode 100644 arch/sh/kernel/timers/timer-broadcast.c
