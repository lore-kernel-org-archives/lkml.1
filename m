Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbXGPAzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbXGPAzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758505AbXGPAzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:55:12 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:54434 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919AbXGPAzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:55:09 -0400
Date: Mon, 16 Jul 2007 09:54:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] [RESEND] sh updates for 2.6.23-rc1
Message-ID: <20070716005453.GA22810@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Erik Johansson (1):
      sh: fix race in parallel out-of-tree build

Kaz Kojima (1):
      sh: Fix up futex implementation.

Kristoffer Ericson (3):
      sh: hd64461.h cleanup and added comments.
      sh: Kill off dead mach.c for hp6xx.
      sh: sh-rtc support for SH7709.

Magnus Damm (2):
      sh: rework intc2 code
      sh: rework ipr code

Nobuhiro Iwamatsu (2):
      sh: Add L-BOX RE2 to mach-types.
      sh: Fix timer-tmu build for SH-3.

Paul Mundt (56):
      sh: Split out CPU topology initialization.
      sh: __user annotations for __get/__put_user().
      sh: Fixup machvec support.
      sh: Shut up SH2-DSP compile warnings.
      sh: Rework CPU/board dependencies.
      sh: Fixup cmdline handling from machvec changes.
      sh: Get multiple boards in one image working again.
      sh: Kill off machvec aliases.
      sh: Rip out special unknown machvec.
      sh: Fix SH-4 CPU selects.
      sh: pfn_valid() depends on flatmem.
      sh: sparsemem support.
      sh: Allow for bootmem debug support.
      sh: Register multiple nodes in topology_init().
      sh: Mark sparsemem regions present earlier.
      sh: Enable IPR-IRQ for SH7206.
      sh: Wrap CPU tuning through cc-option.
      sh: Tidy compiler warnings for SH-2A build.
      sh: Wire up mempolicy syscalls.
      sh: Default to 4-byte alignment for SLUB objects.
      sh: Fix up max_zone_pfns[] with multiple nodes.
      sh: Use asm/sections.h for linker section symbols.
      sh: Support for multiple nodes.
      sh: URAM node support for SH7722.
      sh: Make NUMA depend on sparsemem.
      sh: Fix the SH7722 flatmem build.
      sh: Fix up cpu to node mapping in sysfs.
      sh: memory hot-add for sparsemem users support.
      sh: Kill off dead SH7604 support.
      sh: Compile fix for SH7604 removal.
      sh: Tidy up dependencies for SH-2 build.
      sh: Fixup misaligned data for sh2 lockdep.
      fs: hugetlbfs: Disable for shnommu.
      sh: Kill off broken dma page ops.
      sh: Fix up the math-emu build.
      sh: Only support PMB for SH-X cores.
      sh: Update SH-2/SH-2A defconfigs.
      sh: Check oops_may_print() in unhandled fault.
      sh: Fix up cf-enabler dependency for SE boards.
      sh: Update se7722 defconfig.
      sh: Hook up hard_smp_processor_id() for INTC2 block.
      sh: Preliminary support for the SH-X3 CPU.
      Merge branch 'x3'
      sh: Add cpu and mach links to CLEAN_FILES.
      sh: Correct __xdiv64_32/div64_32 return value size.
      sh: Select IPR-IRQ for SH7091.
      fb: pvr2fb: Fix up section mismatch warnings.
      fb: pvr2fb: A few more __devinit annotations for PCI.
      sh: Update dreamcast defconfig.
      sh: Drop -Wa,-dsp for DSP tuning.
      sh: Add parport stub for SuperIO ports.
      sh: Don't let SH-4A clobber SH-4 CFLAGS.
      sh: Add a .bss.page_aligned section for 4K stacks.
      sh: Export div symbols for GCC 4.2 and ST GCC.
      sh: Update r7785rp defconfig.
      sh: Revert __xdiv64_32 size change.

Robert P. J. Day (2):
      sh: Warn against direct inclusion of <asm/rwsem.h>.
      sh: Update the alignment when 4K stacks are used.

Takashi YOSHII (1):
      sh: Align .machvec.init section on a 4-byte boundary.

Yoshihiro Shimoda (1):
      sh: Provide a defconfig for R7780MP.

 arch/sh/Kconfig                             |  441 +++++-----
 arch/sh/Kconfig.debug                       |    5 
 arch/sh/Makefile                            |  104 +-
 arch/sh/boards/dreamcast/setup.c            |    3 
 arch/sh/boards/hp6xx/mach.c                 |   46 -
 arch/sh/boards/hp6xx/setup.c                |    3 
 arch/sh/boards/landisk/setup.c              |    3 
 arch/sh/boards/lboxre2/setup.c              |    3 
 arch/sh/boards/mpc1211/setup.c              |    3 
 arch/sh/boards/renesas/edosk7705/setup.c    |    3 
 arch/sh/boards/renesas/hs7751rvoip/setup.c  |    3 
 arch/sh/boards/renesas/r7780rp/Kconfig      |    6 
 arch/sh/boards/renesas/r7780rp/setup.c      |    3 
 arch/sh/boards/renesas/rts7751r2d/setup.c   |    3 
 arch/sh/boards/renesas/sh7710voipgw/setup.c |    3 
 arch/sh/boards/renesas/systemh/setup.c      |    3 
 arch/sh/boards/saturn/Makefile              |    8 
 arch/sh/boards/saturn/io.c                  |   26 
 arch/sh/boards/saturn/irq.c                 |  118 --
 arch/sh/boards/saturn/setup.c               |   31 
 arch/sh/boards/saturn/smp.c                 |   68 -
 arch/sh/boards/se/7206/setup.c              |    3 
 arch/sh/boards/se/7300/setup.c              |    3 
 arch/sh/boards/se/73180/setup.c             |    3 
 arch/sh/boards/se/7343/setup.c              |    3 
 arch/sh/boards/se/7619/setup.c              |    3 
 arch/sh/boards/se/770x/irq.c                |  124 +-
 arch/sh/boards/se/770x/setup.c              |    3 
 arch/sh/boards/se/7722/irq.c                |   15 
 arch/sh/boards/se/7722/setup.c              |    3 
 arch/sh/boards/se/7751/irq.c                |   59 -
 arch/sh/boards/se/7751/setup.c              |    3 
 arch/sh/boards/se/7780/irq.c                |   45 -
 arch/sh/boards/se/7780/setup.c              |    3 
 arch/sh/boards/sh03/setup.c                 |   31 
 arch/sh/boards/shmin/setup.c                |   33 
 arch/sh/boards/snapgear/setup.c             |   31 
 arch/sh/boards/superh/microdev/setup.c      |    3 
 arch/sh/boards/titan/setup.c                |   25 
 arch/sh/boards/unknown/Makefile             |    6 
 arch/sh/boards/unknown/setup.c              |   21 
 arch/sh/cchips/Kconfig                      |    6 
 arch/sh/configs/dreamcast_defconfig         |  338 +++----
 arch/sh/configs/r7780mp_defconfig           | 1223 ++++++++++++++++++++++++++++
 arch/sh/configs/r7785rp_defconfig           |  296 ++----
 arch/sh/configs/se7206_defconfig            |  272 ++----
 arch/sh/configs/se7619_defconfig            |  215 +---
 arch/sh/configs/se7722_defconfig            |  287 ++----
 arch/sh/configs/shx3_defconfig              |  756 +++++++++++++++++
 arch/sh/drivers/dma/Kconfig                 |   17 
 arch/sh/drivers/pci/Kconfig                 |    1 
 arch/sh/kernel/Makefile                     |    9 
 arch/sh/kernel/cf-enabler.c                 |    6 
 arch/sh/kernel/cpu/init.c                   |   15 
 arch/sh/kernel/cpu/irq/intc2.c              |   63 -
 arch/sh/kernel/cpu/irq/ipr.c                |   59 -
 arch/sh/kernel/cpu/sh2/entry.S              |    1 
 arch/sh/kernel/cpu/sh2/probe.c              |   13 
 arch/sh/kernel/cpu/sh2/setup-sh7619.c       |   24 
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c      |   24 
 arch/sh/kernel/cpu/sh3/entry.S              |   19 
 arch/sh/kernel/cpu/sh3/setup-sh7705.c       |   40 
 arch/sh/kernel/cpu/sh3/setup-sh7709.c       |  112 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c       |   42 
 arch/sh/kernel/cpu/sh4/Makefile             |    4 
 arch/sh/kernel/cpu/sh4/probe.c              |    8 
 arch/sh/kernel/cpu/sh4/setup-sh7750.c       |   58 -
 arch/sh/kernel/cpu/sh4/setup-sh7760.c       |   45 -
 arch/sh/kernel/cpu/sh4a/Makefile            |    2 
 arch/sh/kernel/cpu/sh4a/clock-shx3.c        |  135 +++
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c      |   29 
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c      |   15 
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c      |   16 
 arch/sh/kernel/cpu/sh4a/setup-shx3.c        |   85 +
 arch/sh/kernel/irq.c                        |    8 
 arch/sh/kernel/machvec.c                    |  130 ++
 arch/sh/kernel/process.c                    |   18 
 arch/sh/kernel/ptrace.c                     |    8 
 arch/sh/kernel/setup.c                      |  210 ----
 arch/sh/kernel/sh_ksyms.c                   |   10 
 arch/sh/kernel/signal.c                     |    5 
 arch/sh/kernel/syscalls.S                   |    6 
 arch/sh/kernel/timers/timer-tmu.c           |    7 
 arch/sh/kernel/topology.c                   |   49 +
 arch/sh/kernel/traps.c                      |    5 
 arch/sh/kernel/vmlinux.lds.S                |   20 
 arch/sh/lib/div64-generic.c                 |    9 
 arch/sh/lib/div64.S                         |    6 
 arch/sh/math-emu/math.c                     |   18 
 arch/sh/mm/Kconfig                          |   87 +
 arch/sh/mm/Makefile                         |    5 
 arch/sh/mm/fault.c                          |   45 -
 arch/sh/mm/init.c                           |  107 +-
 arch/sh/mm/numa.c                           |   92 ++
 arch/sh/mm/pg-dma.c                         |   95 --
 arch/sh/tools/Makefile                      |    1 
 arch/sh/tools/mach-types                    |    2 
 drivers/serial/sh-sci.c                     |    4 
 drivers/serial/sh-sci.h                     |   50 -
 drivers/video/pvr2fb.c                      |  101 +-
 fs/Kconfig                                  |    2 
 include/asm-sh/bugs.h                       |    4 
 include/asm-sh/cache.h                      |    4 
 include/asm-sh/cpu-sh2/cache.h              |   20 
 include/asm-sh/cpu-sh3/timer.h              |    4 
 include/asm-sh/cpu-sh4/freq.h               |    2 
 include/asm-sh/cpu-sh4/timer.h              |   57 -
 include/asm-sh/futex-irq.h                  |  111 ++
 include/asm-sh/futex.h                      |   79 +
 include/asm-sh/hd64461.h                    |  397 +++++----
 include/asm-sh/hw_irq.h                     |   42 
 include/asm-sh/irq.h                        |   40 
 include/asm-sh/machvec.h                    |    4 
 include/asm-sh/machvec_init.h               |   53 -
 include/asm-sh/mmzone.h                     |   46 +
 include/asm-sh/page.h                       |   10 
 include/asm-sh/parport.h                    |   16 
 include/asm-sh/processor.h                  |    8 
 include/asm-sh/rwsem.h                      |    6 
 include/asm-sh/saturn/io.h                  |   19 
 include/asm-sh/saturn/smpc.h                |   34 
 include/asm-sh/sections.h                   |    2 
 include/asm-sh/setup.h                      |    1 
 include/asm-sh/sh03/io.h                    |    4 
 include/asm-sh/smp.h                        |    2 
 include/asm-sh/snapgear.h                   |    4 
 include/asm-sh/sparsemem.h                  |   16 
 include/asm-sh/system.h                     |   16 
 include/asm-sh/topology.h                   |   30 
 include/asm-sh/uaccess.h                    |   40 
 include/asm-sh/ubc.h                        |    9 
 mm/Kconfig                                  |    2 
 132 files changed, 4888 insertions(+), 2835 deletions(-)
