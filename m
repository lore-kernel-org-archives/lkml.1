Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYLVLBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYLVLBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYLVLBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:01:03 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:44135 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752862AbYLVLA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:00:59 -0500
Date: Mon, 22 Dec 2008 19:58:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: What's in sh-2.6.git for 2.6.29?
Message-ID: <20081222105857.GA14844@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better late than never, here is a brief summary of the changes that are
sitting in the sh queue for 2.6.29.

There is the usual batch of new boards, CPU subtypes, and so on. The main
issues of note are:

	- dynamic ftrace
	- move to generic kgdb stub
	- tracehook support for sh64
	- optimized bitops for SH-2A
	- optimized unaligned accesses on SH-4A
	- optimized mutex fastpath on SH-4A
	- clock framework support for the SH-Mobile CPUs and their
	  respective drivers
	- Killing off the libgcc linking, making it easier to build a
	  wider range of kernels with a wider range of toolchains

and lots of other things all over the place that I won't bother
enumerating.

The tree is at:

	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Aoi Shinkai (1):
      sh: Delete unnecessary mov in the interrupt exception entry point.

Dave Peverley (1):
      sh: oprofile: Backtrace support.

Magnus Damm (35):
      sh: enable and disable clocks recursively
      sh: sh_mobile clock divider index fix
      sh: use arch_flags for sh_mobile mstpcr clock bits
      sh: new sh_mobile mstpcr clocks base code
      sh: sh_mobile mstpcr clocks for sh7722
      sh: sh_mobile mstpcr clocks for sh7723
      sh: sh_mobile mstpcr clocks for sh7343
      sh: sh_mobile mstpcr clocks for sh7366
      sh: sh_mobile i2c clock framework support
      sh: sh_mobile keysc clock framework support
      sh: sh_mobile ceu clock framework support
      sh: sh_mobile usbf clock framework support
      sh: sh_mobile usb clock framework support
      sh: sh_mobile lcdc clock framework support
      sh: remove old sh_mobile mstpc clocks
      sh: P4 ioremap pass-through
      sh: propagate r_clk
      sh: sh7343 scif configuration update
      sh: fix number of interrupts on se7343
      sh: add st16c2550 devices to se7343
      sh: add isp1161 usb host device to se7343
      sh: remove ioport cruft and smc91x from se7343
      sh: update se7343 defconfig
      sh: move the hp6xx pm code
      sh: allow CONFIG_PM
      sh: allow CONFIG_CPU_IDLE
      sh: add ov772x reset delay on Migo-R
      sh: split coherent pages
      sh_mobile_lcdc: use FB_SYS helpers instead of FB_CFB
      sh: add LCDC interrupt configuration to AP325 and Migo-R
      video: fix deferred io fsync()
      video: deferred io cleanup
      video: deferred io with physically contiguous memory
      video: sh_mobile_lcdcfb deferred io support
      sh: enable deferred io LCDC on Migo-R

Matt Fleming (7):
      sh: dynamic ftrace support.
      sh: Switch HD64461 from hw_interrupt_type to irq_chip
      sh: Convert Microdev boards from hw_interrupt_type to irq_chip
      sh: Convert SystemH board support from hw_interrupt_type to irq_chip
      sh: Convert Dreamcast support from hw_interrupt_type to irq_chip
      sh: Convert Cayman boards from hw_interrupt_type to irq_chip
      sh: Enable GENERIC_HARDIRQS_NO__DO_IRQ for all SuperH machines

Michael Trimarchi (2):
      serial: sh-sci: Codestyle cleanup patch.
      sh: Add SH-4A optimized fastpath mutex implementation.

Nick Andrew (1):
      Fix incorrect use of loose in c-checksum.c

Nobuhiro Iwamatsu (2):
      sh: sh7760fb: Fix color pallette setting
      sh: sh7760fb: Add support SH7720/SH7721 of Renesas

Paul Mundt (75):
      sh: Move arch_get_unmapped_area() in to arch/sh/mm/mmap.c.
      media: sh_mobile_ceu_camera: Add HAVE_CLK dependency.
      usb: Fix up sh_mobile usbf clock framework warnings.
      sh: Fix clock framework compiler warnings.
      sh: __udivdi3 -> do_div() in softfloat lib.
      sh: Migrate necessary libgcc bits in to arch/sh/lib for SUPERH32.
      sh: Specify sane default image targets for the SH-2 platforms.
      sh: Convert to generic bitops for IRQ-toggling implementation.
      sh: Add exports for __udivsi3/__sdivsi3 and the _i4 versions.
      sh: Add -m4al tuning for SH4AL-DSP.
      sh: Provide optimized non-atomic bitops for SH-2A.
      sh: Provide optimized unaligned loads on SH-4A.
      sh: More movmem alias symbol exports for older compilers.
      sh: Re-add support for best fit ISA tuning if none is available.
      sh: Add a few more branch types to the branch emulator.
      sh: Add a simple code dumper for SUPERH32 show_regs().
      sh: Tidy up backtrace formatting with kallsyms disabled.
      sh: do not latency trace idle.
      sh: Consolidate cpu_relax()/cpu_sleep() definitions across _32/_64.
      sh: Split out the idle loop for reuse between _32/_64 variants.
      sh: Provide a dyn_arch_ftrace struct definition.
      sh: Fix up the SH-4A mutex fastpath semantics.
      sh: Disable -Werror for arch/sh/oprofile/.
      sh: Provide ftrace_make_call()/ftrace_make_nop().
      sh: Consolidate rsk7203/7201 in to a new mach-rsk.
      sh: Enable leds-gpio in rsk7203 defconfig.
      sh: Update rsk701_defconfig to reflect mach-rsk changes.
      sh: Fix an off-by-1 check in __mutex_fastpath_unlock().
      sh: Drop the special qemu defconfig.
      sh: mach-migor: Kill off unused Migo-R machvec.
      sh: Kill off sh64's unused alloc/free_task_struct() definitions.
      sh: Convert sh64 /proc/asids to debugfs and generic sh.
      sh: Fix up the cpu_asid() return value on nommu.
      sh: Fix up syscall_get_nr() comment in syscall_32.h.
      sh: Handle cases where setup{_rt,}_frame() fail on SH-5 signal delivery.
      sh: Provide asm/syscall.h for SH-5.
      sh: Provide linux/regset.h interface for SH-5.
      sh: Enable HAVE_ARCH_TRACEHOOK for all SH, now that SH-5 supports it too.
      sh: Generic kgdb stub support.
      serial: sh-sci: Implement CONSOLE_POLL support and kill off old kgdb console.
      sh: Kill off remaining CONFIG_SH_KGDB bits.
      sh: Add SH-5 optimized memcpy()/memset()/strcpy()/strlen().
      fb: SH-5 uses __raw I/O accessors now also, drop the special casing.
      sh: Provide sdivsi3/udivsi3/udivdi3 for sh64, kill off libgcc linking.
      sh: oprofile: Refactor common setup code for multiple driver support.
      sh: oprofile: Convert op_model_sh7750 to new common interface.
      serial: sh-sci: Fix up the cpufreq notifier to use the proper port clock.
      serial: sh-sci: pr_debug() -> dev_dbg() conversion.
      serial: sh-sci: Tidy up fifo overrun error handling.
      serial: sh-sci: Generalize port pin initialization.
      sh: Run sh_bios through a long overdue Lindent.
      sh: export sh_bios_get_node_addr() symbol for stnic module.
      sh: Kill off sh_bios_in_gdb_mode().
      sh: Kill off the cayman and microdev special heartbeat code.
      sh: Kill off mv_heartbeat() from the machvec.
      sh: Simplify kernel_thread_helper() for sh32.
      sh: Kill off dead mv_init_pci() from machvec.
      sh: board-shmin: Convert shmin to use __set_io_port_base().
      sh: mach-sh03: Move off of cf_enabler to pata_platform, as per landisk.
      sh: mach-sh03: Use __set_io_port_base(), kill off special ioport_map().
      sh: mach-microdev: Split out the fdc37c93xapm initialization code.
      sh: mach-edosk7705: Fix up edosk7705 so it all builds again.
      sh: Add a simple edosk7705_defconfig for build testing.
      sh: Kill off cf-enabler with extreme prejudice.
      serial: sh-sci: sci_poll_get_char() is only used by CONFIG_CONSOLE_POLL.
      sh: mrshpc_setup_windows() needs to be inline.
      doc: Update sh cpufreq documentation.
      sh: Enable skipping of bss on debug platforms for sh32 also.
      sh: Kill off the unused SH_ALPHANUMERIC debug option.
      sh: Conditionalize the code dumper on CONFIG_DUMP_CODE.
      sh: dma: Kill off ISA DMA wrapper.
      sh: mach-sh03: Fix up pata_platform build breakage.
      sh: mach-rsk: Use uImage generation by default for rsk7201/7203.
      serial: sh-sci: Fix up port pinmux for SH7366.
      sh: oprofile: Fix up the module build.

Peter Griffin (2):
      sh: Add support for SH7201 CPU subtype.
      sh: RSK+ 7201 board support.

Steve Glendinning (3):
      sh: Add platform-specific constants for SH7709
      sh: fix DMAOR register access on SH7709
      sh: add SH DMAC burst mode constant

Takanari Hayama (1):
      sh: add UIO support for JPU on SH7722.

Takashi YOSHII (1):
      sh: Add plain udivsi3 (not _i4*) for gcc-4.1 and lower.

Yoshihiro Shimoda (1):
      sh: pci-sh7780: fix pci memory address mask

 Documentation/cpu-freq/user-guide.txt         |    6 +-
 Documentation/sh/kgdb.txt                     |  179 -----
 arch/sh/Kconfig                               |   83 +--
 arch/sh/Kconfig.debug                         |  104 +--
 arch/sh/Makefile                              |   33 +-
 arch/sh/boards/Kconfig                        |   11 +-
 arch/sh/boards/Makefile                       |    1 -
 arch/sh/boards/board-ap325rxa.c               |    7 +-
 arch/sh/boards/board-rsk7203.c                |  179 -----
 arch/sh/boards/board-shmin.c                  |   14 +-
 arch/sh/boards/mach-cayman/Makefile           |    1 -
 arch/sh/boards/mach-cayman/irq.c              |   35 +-
 arch/sh/boards/mach-cayman/led.c              |   51 --
 arch/sh/boards/mach-dreamcast/irq.c           |  192 ++---
 arch/sh/boards/mach-dreamcast/setup.c         |    5 +-
 arch/sh/boards/mach-edosk7705/Makefile        |    1 -
 arch/sh/boards/mach-edosk7705/io.c            |   61 +-
 arch/sh/boards/mach-edosk7705/setup.c         |    9 +-
 arch/sh/boards/mach-hp6xx/pm.c                |   78 ++-
 arch/sh/boards/mach-microdev/Makefile         |    5 +-
 arch/sh/boards/mach-microdev/fdc37c93xapm.c   |  160 ++++
 arch/sh/boards/mach-microdev/irq.c            |   36 +-
 arch/sh/boards/mach-microdev/led.c            |  101 ---
 arch/sh/boards/mach-microdev/setup.c          |  196 +-----
 arch/sh/boards/mach-migor/setup.c             |   21 +-
 arch/sh/boards/mach-rsk/Kconfig               |   18 +
 arch/sh/boards/mach-rsk/Makefile              |    2 +
 arch/sh/boards/mach-rsk/devices-rsk7203.c     |  103 +++
 arch/sh/boards/mach-rsk/setup.c               |  106 +++
 arch/sh/boards/mach-se/7343/Makefile          |    2 +-
 arch/sh/boards/mach-se/7343/io.c              |  273 -------
 arch/sh/boards/mach-se/7343/setup.c           |  126 ++--
 arch/sh/boards/mach-se/770x/setup.c           |    4 +-
 arch/sh/boards/mach-se/7721/setup.c           |    7 +-
 arch/sh/boards/mach-se/7722/setup.c           |   10 +-
 arch/sh/boards/mach-sh03/setup.c              |   59 ++-
 arch/sh/boards/mach-systemh/irq.c             |   37 +-
 arch/sh/cchips/hd6446x/hd64461.c              |  115 +---
 arch/sh/configs/edosk7705_defconfig           |  438 ++++++++++
 arch/sh/configs/rsk7201_defconfig             |  703 +++++++++++++++++
 arch/sh/configs/rsk7203_defconfig             |   65 ++-
 arch/sh/configs/rts7751r2dplus_qemu_defconfig |  949 ----------------------
 arch/sh/configs/se7343_defconfig              |  303 +++++++-
 arch/sh/drivers/dma/Makefile                  |    1 -
 arch/sh/drivers/dma/dma-isa.c                 |  106 ---
 arch/sh/drivers/dma/dma-sh.c                  |    3 +-
 arch/sh/drivers/dma/dma-sh.h                  |    1 +
 arch/sh/drivers/pci/ops-sh03.c                |    3 +-
 arch/sh/drivers/pci/pci-sh7780.c              |   12 +-
 arch/sh/include/asm/addrspace.h               |   11 +
 arch/sh/include/asm/bitops-grb.h              |    3 +
 arch/sh/include/asm/bitops-irq.h              |   91 ---
 arch/sh/include/asm/bitops-llsc.h             |    2 +
 arch/sh/include/asm/bitops-op32.h             |  142 ++++
 arch/sh/include/asm/bitops.h                  |    9 +-
 arch/sh/include/asm/bugs.h                    |    2 +-
 arch/sh/include/asm/elf.h                     |    2 -
 arch/sh/include/asm/ftrace.h                  |   28 +-
 arch/sh/include/asm/io.h                      |    4 +
 arch/sh/include/asm/kgdb.h                    |   66 +--
 arch/sh/include/asm/machvec.h                 |    5 -
 arch/sh/include/asm/mmu_context.h             |    4 +-
 arch/sh/include/asm/mutex-llsc.h              |  112 +++
 arch/sh/include/asm/mutex.h                   |    5 +-
 arch/sh/include/asm/pm.h                      |   17 -
 arch/sh/include/asm/processor.h               |    5 +-
 arch/sh/include/asm/processor_32.h            |   12 +-
 arch/sh/include/asm/processor_64.h            |    4 +-
 arch/sh/include/asm/ptrace.h                  |    2 +-
 arch/sh/include/asm/sh_bios.h                 |    1 -
 arch/sh/include/asm/string_64.h               |   21 +-
 arch/sh/include/asm/syscall_32.h              |    2 +-
 arch/sh/include/asm/syscall_64.h              |   76 ++-
 arch/sh/include/asm/system.h                  |    2 +
 arch/sh/include/asm/unaligned-sh4a.h          |  258 ++++++
 arch/sh/include/asm/unaligned.h               |    7 +-
 arch/sh/include/cpu-sh3/cpu/gpio.h            |   14 +
 arch/sh/include/mach-common/mach/edosk7705.h  |   31 +-
 arch/sh/include/mach-se/mach/mrshpc.h         |   52 ++
 arch/sh/include/mach-se/mach/se.h             |   18 +
 arch/sh/include/mach-se/mach/se7343.h         |    9 +-
 arch/sh/kernel/Makefile_32                    |   18 +-
 arch/sh/kernel/Makefile_64                    |    5 +-
 arch/sh/kernel/cf-enabler.c                   |  168 ----
 arch/sh/kernel/cpu/clock.c                    |   10 +
 arch/sh/kernel/cpu/init.c                     |    2 +
 arch/sh/kernel/cpu/sh2a/Makefile              |    3 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7201.c        |   85 ++
 arch/sh/kernel/cpu/sh2a/probe.c               |    7 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c        |  331 ++++++++
 arch/sh/kernel/cpu/sh3/entry.S                |   14 +-
 arch/sh/kernel/cpu/sh3/ex.S                   |    2 +-
 arch/sh/kernel/cpu/sh4/softfloat.c            |   73 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c        |  310 +++++---
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c        |   37 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c        |   19 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c        |   50 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c        |   19 +-
 arch/sh/kernel/debugtraps.S                   |   13 +-
 arch/sh/kernel/disassemble.c                  |  573 ++++++++++++++
 arch/sh/kernel/entry-common.S                 |   54 +--
 arch/sh/kernel/ftrace.c                       |  133 ++++
 arch/sh/kernel/head_32.S                      |   12 +-
 arch/sh/kernel/idle.c                         |   81 ++
 arch/sh/kernel/kgdb.c                         |  285 +++++++
 arch/sh/kernel/kgdb_jmp.S                     |   33 -
 arch/sh/kernel/kgdb_stub.c                    | 1052 -------------------------
 arch/sh/kernel/pm.c                           |   88 --
 arch/sh/kernel/process_32.c                   |   81 +--
 arch/sh/kernel/process_64.c                   |  111 ---
 arch/sh/kernel/ptrace_64.c                    |  186 +++++-
 arch/sh/kernel/setup.c                        |    1 +
 arch/sh/kernel/sh_bios.c                      |   65 +-
 arch/sh/kernel/sh_ksyms_32.c                  |   37 +-
 arch/sh/kernel/sh_ksyms_64.c                  |    5 +-
 arch/sh/kernel/signal_32.c                    |    1 -
 arch/sh/kernel/signal_64.c                    |  154 ++--
 arch/sh/kernel/sys_sh.c                       |   92 ---
 arch/sh/kernel/time_32.c                      |   12 -
 arch/sh/kernel/time_64.c                      |    5 -
 arch/sh/kernel/timers/timer-mtu2.c            |    5 +
 arch/sh/kernel/traps_32.c                     |   36 +-
 arch/sh/lib/Makefile                          |   16 +-
 arch/sh/lib/ashiftrt.S                        |  149 ++++
 arch/sh/lib/ashldi3.c                         |   29 +
 arch/sh/lib/ashlsi3.S                         |  193 +++++
 arch/sh/lib/ashrdi3.c                         |   31 +
 arch/sh/lib/ashrsi3.S                         |  185 +++++
 arch/sh/lib/libgcc.h                          |   26 +
 arch/sh/lib/lshrdi3.c                         |   29 +
 arch/sh/lib/lshrsi3.S                         |  193 +++++
 arch/sh/lib/mcount.S                          |   90 +++
 arch/sh/lib/movmem.S                          |  238 ++++++
 arch/sh/lib/udiv_qrnnd.S                      |   81 ++
 arch/sh/lib/udivsi3.S                         |   87 ++
 arch/sh/lib/udivsi3_i4i-Os.S                  |  149 ++++
 arch/sh/lib/udivsi3_i4i.S                     |  666 ++++++++++++++++
 arch/sh/lib64/Makefile                        |    8 +-
 arch/sh/lib64/c-checksum.c                    |    4 +-
 arch/sh/lib64/memcpy.S                        |  201 +++++
 arch/sh/lib64/memcpy.c                        |   81 --
 arch/sh/lib64/memset.S                        |   91 +++
 arch/sh/lib64/sdivsi3.S                       |  131 +++
 arch/sh/lib64/strcpy.S                        |   97 +++
 arch/sh/lib64/strlen.S                        |   33 +
 arch/sh/lib64/udivdi3.S                       |  120 +++
 arch/sh/lib64/udivsi3.S                       |   59 ++
 arch/sh/mm/Makefile_32                        |    1 +
 arch/sh/mm/Makefile_64                        |    1 +
 arch/sh/mm/asids-debugfs.c                    |   79 ++
 arch/sh/mm/consistent.c                       |    7 +-
 arch/sh/mm/fault_32.c                         |   17 -
 arch/sh/mm/ioremap_32.c                       |    3 +-
 arch/sh/mm/mmap.c                             |   94 +++
 arch/sh/oprofile/Makefile                     |   13 +-
 arch/sh/oprofile/backtrace.c                  |  114 +++
 arch/sh/oprofile/common.c                     |  150 ++++
 arch/sh/oprofile/op_impl.h                    |   33 +
 arch/sh/oprofile/op_model_null.c              |   23 -
 arch/sh/oprofile/op_model_sh7750.c            |  172 ++---
 arch/sh/tools/mach-types                      |    2 +
 drivers/i2c/busses/i2c-sh_mobile.c            |   73 +-
 drivers/input/keyboard/sh_keysc.c             |   28 +-
 drivers/media/video/Kconfig                   |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c    |   20 +-
 drivers/serial/sh-sci.c                       |  563 ++++---------
 drivers/serial/sh-sci.h                       |   45 +-
 drivers/usb/gadget/m66592-udc.c               |   34 +-
 drivers/usb/gadget/m66592-udc.h               |   27 +-
 drivers/usb/host/r8a66597-hcd.c               |   34 +-
 drivers/usb/host/r8a66597.h                   |    8 +-
 drivers/video/Kconfig                         |   33 +-
 drivers/video/fb_defio.c                      |   27 +-
 drivers/video/sh7760fb.c                      |   94 +--
 drivers/video/sh_mobile_lcdcfb.c              |  198 ++++-
 include/linux/fb.h                            |    2 +-
 include/video/sh_mobile_lcdc.h                |    1 +
 scripts/recordmcount.pl                       |   11 +
 178 files changed, 9397 insertions(+), 5799 deletions(-)
 delete mode 100644 Documentation/sh/kgdb.txt
 delete mode 100644 arch/sh/boards/board-rsk7203.c
 delete mode 100644 arch/sh/boards/mach-cayman/led.c
 create mode 100644 arch/sh/boards/mach-microdev/fdc37c93xapm.c
 delete mode 100644 arch/sh/boards/mach-microdev/led.c
 create mode 100644 arch/sh/boards/mach-rsk/Kconfig
 create mode 100644 arch/sh/boards/mach-rsk/Makefile
 create mode 100644 arch/sh/boards/mach-rsk/devices-rsk7203.c
 create mode 100644 arch/sh/boards/mach-rsk/setup.c
 delete mode 100644 arch/sh/boards/mach-se/7343/io.c
 create mode 100644 arch/sh/configs/edosk7705_defconfig
 create mode 100644 arch/sh/configs/rsk7201_defconfig
 delete mode 100644 arch/sh/configs/rts7751r2dplus_qemu_defconfig
 delete mode 100644 arch/sh/drivers/dma/dma-isa.c
 delete mode 100644 arch/sh/include/asm/bitops-irq.h
 create mode 100644 arch/sh/include/asm/bitops-op32.h
 create mode 100644 arch/sh/include/asm/mutex-llsc.h
 delete mode 100644 arch/sh/include/asm/pm.h
 create mode 100644 arch/sh/include/asm/unaligned-sh4a.h
 create mode 100644 arch/sh/include/mach-se/mach/mrshpc.h
 delete mode 100644 arch/sh/kernel/cf-enabler.c
 create mode 100644 arch/sh/kernel/cpu/sh2a/clock-sh7201.c
 create mode 100644 arch/sh/kernel/cpu/sh2a/setup-sh7201.c
 create mode 100644 arch/sh/kernel/disassemble.c
 create mode 100644 arch/sh/kernel/ftrace.c
 create mode 100644 arch/sh/kernel/idle.c
 create mode 100644 arch/sh/kernel/kgdb.c
 delete mode 100644 arch/sh/kernel/kgdb_jmp.S
 delete mode 100644 arch/sh/kernel/kgdb_stub.c
 delete mode 100644 arch/sh/kernel/pm.c
 create mode 100644 arch/sh/lib/ashiftrt.S
 create mode 100644 arch/sh/lib/ashldi3.c
 create mode 100644 arch/sh/lib/ashlsi3.S
 create mode 100644 arch/sh/lib/ashrdi3.c
 create mode 100644 arch/sh/lib/ashrsi3.S
 create mode 100644 arch/sh/lib/libgcc.h
 create mode 100644 arch/sh/lib/lshrdi3.c
 create mode 100644 arch/sh/lib/lshrsi3.S
 create mode 100644 arch/sh/lib/mcount.S
 create mode 100644 arch/sh/lib/movmem.S
 create mode 100644 arch/sh/lib/udiv_qrnnd.S
 create mode 100644 arch/sh/lib/udivsi3.S
 create mode 100644 arch/sh/lib/udivsi3_i4i-Os.S
 create mode 100644 arch/sh/lib/udivsi3_i4i.S
 create mode 100644 arch/sh/lib64/memcpy.S
 delete mode 100644 arch/sh/lib64/memcpy.c
 create mode 100644 arch/sh/lib64/memset.S
 create mode 100644 arch/sh/lib64/sdivsi3.S
 create mode 100644 arch/sh/lib64/strcpy.S
 create mode 100644 arch/sh/lib64/strlen.S
 create mode 100644 arch/sh/lib64/udivdi3.S
 create mode 100644 arch/sh/lib64/udivsi3.S
 create mode 100644 arch/sh/mm/asids-debugfs.c
 create mode 100644 arch/sh/oprofile/backtrace.c
 create mode 100644 arch/sh/oprofile/common.c
 create mode 100644 arch/sh/oprofile/op_impl.h
 delete mode 100644 arch/sh/oprofile/op_model_null.c
