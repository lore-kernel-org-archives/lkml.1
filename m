Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbYGUGlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbYGUGlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbYGUGlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:41:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32961
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755259AbYGUGlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:41:14 -0400
Date: Sun, 20 Jul 2008 23:41:14 -0700 (PDT)
Message-Id: <20080720.234114.216341238.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Main items:

1) Header merging and cleanups from Sam Ravnborg and Adrian
   Bunk.

2) Niagara 2 hardware RNG driver.

3) Convert sparc to use %pS

4) Convert sparc64 to use new generic IPI function cal
   infrastructure

Please pull, thanks a lot!

The following changes since commit 5b664cb235e97afbf34db9c4d77f08ebd725335e:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../mfasheh/ocfs2

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Adrian Bunk (5):
      sparc/kernel/: possible cleanups
      sparc/mm/: possible cleanups
      sparc64/kernel/: make code static
      drivers/sbus/: cleanups
      sparc: remove PROM_AP1000

David Howells (1):
      sparc: Remove Sparc's asm-offsets for sclow.S

David S. Miller (7):
      sparc64 Kbuild: apb.h and bbc.h should not be exported to userspace
      sparc: Use new '%pS' infrastructure to print symbols.
      sparc64: Convert to generic helpers for IPI function calls.
      sparc64: Remove 4MB and 512K base page size options.
      sparc64: Add missing hypervisor service group numbers.
      sparc64: Add Niagara2 RNG driver.
      sparc64: Update defconfig.

Randy Dunlap (1):
      sparc64: Config category "Processor type and features" absent

Robert Reif (1):
      sparc32: fix init.c allnoconfig build error

Sam Ravnborg (28):
      sparc: Merge include/asm-sparc{,64}/openpromio.h
      sparc: Merge include/asm-sparc{,64}/perfctr.h
      sparc: add -m64 when building vmlinux.lds
      sparc: copy exported sparc64 specific header files to asm-sparc
      sparc: Merge asm-sparc{,64}/ioctl.h
      sparc: Merge asm-sparc{,64}/ioctls.h
      sparc: Merge asm-sparc{,64}/param.h
      sparc: Merge asm-sparc{,64}/poll.h
      sparc: Merge asm-sparc{,64}/socket.h
      sparc: Merge asm-sparc{,64}/sockios.h
      sparc: Merge asm-sparc{,64}/fcntl.h
      sparc: Merge asm-sparc{,64}/msgbuf.h
      sparc: Merge asm-sparc{,64}/sembuf.h
      sparc: Merge asm-sparc{,64}/shmbuf.h
      sparc: Merge asm-sparc{,64}/mman.h
      sparc: copy asm-sparc64/fbio.h to asm-sparc
      sparc: Merge asm-sparc{,64}/fbio.h
      sparc: Merge asm-sparc{,64}/resource.h
      sparc: Merge asm-sparc{,64}/setup.h
      sparc: Merge asm-sparc{,64}/termbits.h
      sparc: Merge asm-sparc{,64}/termios.h
      sparc: Merge asm-sparc{,64}/types.h
      sparc: export openprom.h to userspace
      sparc: Merge asm-sparc{,64}/asi.h
      sparc: copy sparc64 specific files to asm-sparc
      sparc: when header files are equal use asm-sparc version
      sparc: merge header files with trivial differences
      sparc: join the remaining header files

Stoyan Gaydarov (1):
      sparc: arch/sparc/kernel/apc.c to unlocked_ioctl

 arch/sparc/kernel/apc.c              |   42 +-
 arch/sparc/kernel/asm-offsets.c      |   12 -
 arch/sparc/kernel/ebus.c             |    9 +-
 arch/sparc/kernel/entry.S            |    5 +-
 arch/sparc/kernel/etrap.S            |    1 -
 arch/sparc/kernel/head.S             |    2 -
 arch/sparc/kernel/idprom.c           |    2 +-
 arch/sparc/kernel/ioport.c           |   13 +-
 arch/sparc/kernel/irq.c              |    2 +-
 arch/sparc/kernel/process.c          |   14 +-
 arch/sparc/kernel/rtrap.S            |    2 -
 arch/sparc/kernel/setup.c            |    4 +-
 arch/sparc/kernel/smp.c              |    7 -
 arch/sparc/kernel/sun4c_irq.c        |    3 +-
 arch/sparc/kernel/sun4d_irq.c        |    7 +-
 arch/sparc/kernel/sun4m_irq.c        |    7 +-
 arch/sparc/kernel/sun4m_smp.c        |    9 +-
 arch/sparc/kernel/time.c             |    4 +-
 arch/sparc/kernel/traps.c            |   16 +-
 arch/sparc/kernel/wof.S              |    1 -
 arch/sparc/kernel/wuf.S              |    1 -
 arch/sparc/mm/fault.c                |    2 +-
 arch/sparc/mm/init.c                 |    9 +-
 arch/sparc/mm/srmmu.c                |   38 +-
 arch/sparc/mm/tsunami.S              |    1 -
 arch/sparc64/Kconfig                 |   20 +-
 arch/sparc64/Makefile                |    4 +-
 arch/sparc64/defconfig               |  145 +-
 arch/sparc64/kernel/central.c        |   14 +-
 arch/sparc64/kernel/ds.c             |    2 +-
 arch/sparc64/kernel/hvapi.c          |    4 +
 arch/sparc64/kernel/pci_msi.c        |   10 +-
 arch/sparc64/kernel/pci_sun4v.c      |    2 +-
 arch/sparc64/kernel/process.c        |   26 +-
 arch/sparc64/kernel/smp.c            |   87 +-
 arch/sparc64/kernel/sparc64_ksyms.c  |    2 -
 arch/sparc64/kernel/sys_sparc.c      |    6 +-
 arch/sparc64/kernel/sys_sparc32.c    |    7 +-
 arch/sparc64/kernel/traps.c          |   37 +-
 arch/sparc64/kernel/ttable.S         |    7 +-
 arch/sparc64/kernel/unaligned.c      |    7 +-
 arch/sparc64/lib/copy_page.S         |    6 +-
 arch/sparc64/mm/fault.c              |    5 +-
 arch/sparc64/mm/tsb.c                |    6 -
 arch/sparc64/mm/ultra.S              |    5 +
 drivers/char/hw_random/Kconfig       |   13 +
 drivers/char/hw_random/Makefile      |    2 +
 drivers/char/hw_random/n2-asm.S      |   79 +
 drivers/char/hw_random/n2-drv.c      |  771 +++++++++
 drivers/char/hw_random/n2rng.h       |  118 ++
 drivers/sbus/char/uctrl.c            |   16 +-
 drivers/sbus/char/vfc.h              |    4 -
 drivers/sbus/char/vfc_dev.c          |   39 +-
 drivers/sbus/char/vfc_i2c.c          |   12 +-
 drivers/sbus/dvma.c                  |    2 +-
 include/asm-sparc/Kbuild             |   15 +-
 include/asm-sparc/agp.h              |   20 +
 include/asm-sparc/apb.h              |   36 +
 include/asm-sparc/asi.h              |  153 ++-
 include/asm-sparc/atomic.h           |  169 +--
 include/asm-sparc/atomic_32.h        |  165 ++
 include/asm-sparc/atomic_64.h        |  128 ++
 include/asm-sparc/auxio.h            |   97 +-
 include/asm-sparc/auxio_32.h         |   89 +
 include/asm-sparc/auxio_64.h         |  100 ++
 include/asm-sparc/backoff.h          |   31 +
 include/asm-sparc/bbc.h              |  225 +++
 include/asm-sparc/bitops.h           |  117 +--
 include/asm-sparc/bitops_32.h        |  111 ++
 include/asm-sparc/bitops_64.h        |  107 ++
 include/asm-sparc/cacheflush.h       |   93 +-
 include/asm-sparc/cacheflush_32.h    |   85 +
 include/asm-sparc/cacheflush_64.h    |   76 +
 include/asm-sparc/chafsr.h           |  241 +++
 include/asm-sparc/checksum.h         |  249 +---
 include/asm-sparc/checksum_32.h      |  241 +++
 include/asm-sparc/checksum_64.h      |  167 ++
 include/asm-sparc/chmctrl.h          |  183 +++
 include/asm-sparc/cmt.h              |   59 +
 include/asm-sparc/compat.h           |  243 +++
 include/asm-sparc/compat_signal.h    |   29 +
 include/asm-sparc/cpudata.h          |   35 +-
 include/asm-sparc/cpudata_32.h       |   27 +
 include/asm-sparc/cpudata_64.h       |  240 +++
 include/asm-sparc/dcr.h              |   14 +
 include/asm-sparc/dcu.h              |   27 +
 include/asm-sparc/delay.h            |   42 +-
 include/asm-sparc/delay_32.h         |   34 +
 include/asm-sparc/delay_64.h         |   17 +
 include/asm-sparc/display7seg.h      |   79 +
 include/asm-sparc/dma-mapping.h      |   17 +-
 include/asm-sparc/dma-mapping_32.h   |   11 +
 include/asm-sparc/dma-mapping_64.h   |  154 ++
 include/asm-sparc/dma.h              |  290 +----
 include/asm-sparc/dma_32.h           |  288 ++++
 include/asm-sparc/dma_64.h           |  205 +++
 include/asm-sparc/ebus.h             |  105 +--
 include/asm-sparc/ebus_32.h          |   99 ++
 include/asm-sparc/ebus_64.h          |   94 ++
 include/asm-sparc/elf.h              |  149 +--
 include/asm-sparc/elf_32.h           |  145 ++
 include/asm-sparc/elf_64.h           |  217 +++
 include/asm-sparc/envctrl.h          |  103 ++
 include/asm-sparc/estate.h           |   49 +
 include/asm-sparc/fbio.h             |   37 +-
 include/asm-sparc/fcntl.h            |    4 +
 include/asm-sparc/fhc.h              |  121 ++
 include/asm-sparc/floppy.h           |  394 +-----
 include/asm-sparc/floppy_32.h        |  388 +++++
 include/asm-sparc/floppy_64.h        |  782 +++++++++
 include/asm-sparc/fpumacro.h         |   33 +
 include/asm-sparc/futex.h            |   12 +-
 include/asm-sparc/futex_32.h         |    6 +
 include/asm-sparc/futex_64.h         |  110 ++
 include/asm-sparc/hardirq.h          |   31 +-
 include/asm-sparc/hardirq_32.h       |   23 +
 include/asm-sparc/hardirq_64.h       |   19 +
 include/asm-sparc/head.h             |  106 +--
 include/asm-sparc/head_32.h          |  102 ++
 include/asm-sparc/head_64.h          |   76 +
 include/asm-sparc/hugetlb.h          |   84 +
 include/asm-sparc/hvtramp.h          |   37 +
 include/asm-sparc/hypervisor.h       | 2949 ++++++++++++++++++++++++++++++++++
 include/asm-sparc/ide.h              |  103 +--
 include/asm-sparc/ide_32.h           |   95 ++
 include/asm-sparc/ide_64.h           |  118 ++
 include/asm-sparc/idprom.h           |    2 +-
 include/asm-sparc/intr_queue.h       |   15 +
 include/asm-sparc/io.h               |  331 +----
 include/asm-sparc/io_32.h            |  325 ++++
 include/asm-sparc/io_64.h            |  511 ++++++
 include/asm-sparc/ioctls.h           |    4 +-
 include/asm-sparc/iommu.h            |  129 +--
 include/asm-sparc/iommu_32.h         |  121 ++
 include/asm-sparc/iommu_64.h         |   62 +
 include/asm-sparc/ipcbuf.h           |   39 +-
 include/asm-sparc/ipcbuf_32.h        |   31 +
 include/asm-sparc/ipcbuf_64.h        |   28 +
 include/asm-sparc/irq.h              |   21 +-
 include/asm-sparc/irq_32.h           |   15 +
 include/asm-sparc/irq_64.h           |   93 ++
 include/asm-sparc/irqflags.h         |   47 +-
 include/asm-sparc/irqflags_32.h      |   39 +
 include/asm-sparc/irqflags_64.h      |   89 +
 include/asm-sparc/kdebug.h           |   81 +-
 include/asm-sparc/kdebug_32.h        |   73 +
 include/asm-sparc/kdebug_64.h        |   19 +
 include/asm-sparc/kmap_types.h       |    4 +
 include/asm-sparc/kprobes.h          |   49 +
 include/asm-sparc/ldc.h              |  138 ++
 include/asm-sparc/lmb.h              |   10 +
 include/asm-sparc/lsu.h              |   19 +
 include/asm-sparc/machines.h         |    2 -
 include/asm-sparc/mbus.h             |    2 -
 include/asm-sparc/mc146818rtc.h      |   35 +-
 include/asm-sparc/mc146818rtc_32.h   |   29 +
 include/asm-sparc/mc146818rtc_64.h   |   34 +
 include/asm-sparc/mdesc.h            |   78 +
 include/asm-sparc/mmu.h              |   13 +-
 include/asm-sparc/mmu_32.h           |    7 +
 include/asm-sparc/mmu_64.h           |  123 ++
 include/asm-sparc/mmu_context.h      |   50 +-
 include/asm-sparc/mmu_context_32.h   |   42 +
 include/asm-sparc/mmu_context_64.h   |  155 ++
 include/asm-sparc/mmzone.h           |   17 +
 include/asm-sparc/module.h           |   15 +-
 include/asm-sparc/module_32.h        |    7 +
 include/asm-sparc/module_64.h        |    7 +
 include/asm-sparc/mostek.h           |  175 +--
 include/asm-sparc/mostek_32.h        |  171 ++
 include/asm-sparc/mostek_64.h        |  143 ++
 include/asm-sparc/msgbuf.h           |   23 +-
 include/asm-sparc/namei.h            |   21 +-
 include/asm-sparc/namei_32.h         |   13 +
 include/asm-sparc/namei_64.h         |   13 +
 include/asm-sparc/ns87303.h          |  118 ++
 include/asm-sparc/of_platform.h      |   32 +-
 include/asm-sparc/of_platform_32.h   |   24 +
 include/asm-sparc/of_platform_64.h   |   25 +
 include/asm-sparc/openprom.h         |  265 +---
 include/asm-sparc/openprom_32.h      |  255 +++
 include/asm-sparc/openprom_64.h      |  280 ++++
 include/asm-sparc/oplib.h            |  279 +----
 include/asm-sparc/oplib_32.h         |  272 ++++
 include/asm-sparc/oplib_64.h         |  322 ++++
 include/asm-sparc/page.h             |  167 +--
 include/asm-sparc/page_32.h          |  163 ++
 include/asm-sparc/page_64.h          |  138 ++
 include/asm-sparc/parport.h          |  246 +++
 include/asm-sparc/pci.h              |  176 +--
 include/asm-sparc/pci_32.h           |  170 ++
 include/asm-sparc/pci_64.h           |  209 +++
 include/asm-sparc/percpu.h           |   14 +-
 include/asm-sparc/percpu_32.h        |    6 +
 include/asm-sparc/percpu_64.h        |   28 +
 include/asm-sparc/pgalloc.h          |   76 +-
 include/asm-sparc/pgalloc_32.h       |   68 +
 include/asm-sparc/pgalloc_64.h       |   81 +
 include/asm-sparc/pgtable.h          |  477 +------
 include/asm-sparc/pgtable_32.h       |  480 ++++++
 include/asm-sparc/pgtable_64.h       |  775 +++++++++
 include/asm-sparc/pil.h              |   22 +
 include/asm-sparc/posix_types.h      |  124 +--
 include/asm-sparc/posix_types_32.h   |  118 ++
 include/asm-sparc/posix_types_64.h   |  122 ++
 include/asm-sparc/processor.h        |  132 +--
 include/asm-sparc/processor_32.h     |  128 ++
 include/asm-sparc/processor_64.h     |  237 +++
 include/asm-sparc/psrcompat.h        |   45 +
 include/asm-sparc/pstate.h           |   91 ++
 include/asm-sparc/ptrace.h           |  179 +--
 include/asm-sparc/ptrace_32.h        |  175 ++
 include/asm-sparc/ptrace_64.h        |  346 ++++
 include/asm-sparc/reboot.h           |    6 +
 include/asm-sparc/reg.h              |   87 +-
 include/asm-sparc/reg_32.h           |   79 +
 include/asm-sparc/reg_64.h           |   56 +
 include/asm-sparc/resource.h         |    6 +-
 include/asm-sparc/rwsem-const.h      |   12 +
 include/asm-sparc/rwsem.h            |   84 +
 include/asm-sparc/sbus.h             |  161 +--
 include/asm-sparc/sbus_32.h          |  153 ++
 include/asm-sparc/sbus_64.h          |  190 +++
 include/asm-sparc/scatterlist.h      |   32 +-
 include/asm-sparc/scatterlist_32.h   |   26 +
 include/asm-sparc/scatterlist_64.h   |   27 +
 include/asm-sparc/scratchpad.h       |   14 +
 include/asm-sparc/seccomp.h          |   21 +
 include/asm-sparc/sections.h         |   12 +-
 include/asm-sparc/sections_32.h      |    6 +
 include/asm-sparc/sections_64.h      |    9 +
 include/asm-sparc/sembuf.h           |   12 +-
 include/asm-sparc/setup.h            |    6 +-
 include/asm-sparc/sfafsr.h           |   82 +
 include/asm-sparc/sfp-machine.h      |  214 +---
 include/asm-sparc/sfp-machine_32.h   |  212 +++
 include/asm-sparc/sfp-machine_64.h   |   93 ++
 include/asm-sparc/shmbuf.h           |   14 +-
 include/asm-sparc/shmparam.h         |   19 +-
 include/asm-sparc/shmparam_32.h      |   11 +
 include/asm-sparc/shmparam_64.h      |   10 +
 include/asm-sparc/sigcontext.h       |   70 +-
 include/asm-sparc/sigcontext_32.h    |   62 +
 include/asm-sparc/sigcontext_64.h    |   87 +
 include/asm-sparc/siginfo.h          |   25 +-
 include/asm-sparc/siginfo_32.h       |   17 +
 include/asm-sparc/siginfo_64.h       |   32 +
 include/asm-sparc/signal.h           |  209 +---
 include/asm-sparc/signal_32.h        |  207 +++
 include/asm-sparc/signal_64.h        |  194 +++
 include/asm-sparc/smp.h              |  177 +--
 include/asm-sparc/smp_32.h           |  173 ++
 include/asm-sparc/smp_64.h           |   67 +
 include/asm-sparc/sparsemem.h        |   12 +
 include/asm-sparc/spinlock.h         |  200 +---
 include/asm-sparc/spinlock_32.h      |  192 +++
 include/asm-sparc/spinlock_64.h      |  250 +++
 include/asm-sparc/spinlock_types.h   |    2 +-
 include/asm-sparc/spitfire.h         |  342 ++++
 include/asm-sparc/sstate.h           |   13 +
 include/asm-sparc/stacktrace.h       |    6 +
 include/asm-sparc/starfire.h         |   21 +
 include/asm-sparc/stat.h             |   82 +-
 include/asm-sparc/stat_32.h          |   76 +
 include/asm-sparc/stat_64.h          |   47 +
 include/asm-sparc/statfs.h           |   12 +-
 include/asm-sparc/statfs_32.h        |    6 +
 include/asm-sparc/statfs_64.h        |   54 +
 include/asm-sparc/string.h           |  213 +---
 include/asm-sparc/string_32.h        |  205 +++
 include/asm-sparc/string_64.h        |   83 +
 include/asm-sparc/syscalls.h         |   13 +
 include/asm-sparc/system.h           |  290 +----
 include/asm-sparc/system_32.h        |  288 ++++
 include/asm-sparc/system_64.h        |  355 ++++
 include/asm-sparc/termbits.h         |    5 +
 include/asm-sparc/termios.h          |   79 +-
 include/asm-sparc/thread_info.h      |  157 +--
 include/asm-sparc/thread_info_32.h   |  151 ++
 include/asm-sparc/thread_info_64.h   |  277 ++++
 include/asm-sparc/timer.h            |  113 +--
 include/asm-sparc/timer_32.h         |  107 ++
 include/asm-sparc/timer_64.h         |   30 +
 include/asm-sparc/timex.h            |   21 +-
 include/asm-sparc/timex_32.h         |   15 +
 include/asm-sparc/timex_64.h         |   19 +
 include/asm-sparc/tlb.h              |   32 +-
 include/asm-sparc/tlb_32.h           |   24 +
 include/asm-sparc/tlb_64.h           |  111 ++
 include/asm-sparc/tlbflush.h         |   68 +-
 include/asm-sparc/tlbflush_32.h      |   60 +
 include/asm-sparc/tlbflush_64.h      |   44 +
 include/asm-sparc/topology.h         |   14 +-
 include/asm-sparc/topology_32.h      |    6 +
 include/asm-sparc/topology_64.h      |   86 +
 include/asm-sparc/tsb.h              |  283 ++++
 include/asm-sparc/ttable.h           |  658 ++++++++
 include/asm-sparc/types.h            |   32 +-
 include/asm-sparc/uaccess.h          |  342 +----
 include/asm-sparc/uaccess_32.h       |  336 ++++
 include/asm-sparc/uaccess_64.h       |  273 ++++
 include/asm-sparc/uctx.h             |   71 +
 include/asm-sparc/unistd.h           |  386 +-----
 include/asm-sparc/unistd_32.h        |  378 +++++
 include/asm-sparc/unistd_64.h        |  373 +++++
 include/asm-sparc/upa.h              |  109 ++
 include/asm-sparc/utrap.h            |   51 +
 include/asm-sparc/vaddrs.h           |    5 -
 include/asm-sparc/vio.h              |  406 +++++
 include/asm-sparc/visasm.h           |   62 +
 include/asm-sparc/watchdog.h         |   31 +
 include/asm-sparc/xor.h              |  277 +----
 include/asm-sparc/xor_32.h           |  269 ++++
 include/asm-sparc/xor_64.h           |   70 +
 include/asm-sparc64/Kbuild           |   24 +-
 include/asm-sparc64/agp.h            |   21 +-
 include/asm-sparc64/apb.h            |   37 +-
 include/asm-sparc64/asi.h            |  161 +--
 include/asm-sparc64/atomic.h         |  129 +--
 include/asm-sparc64/auxio.h          |  101 +--
 include/asm-sparc64/backoff.h        |   32 +-
 include/asm-sparc64/bbc.h            |  226 +---
 include/asm-sparc64/bitops.h         |  108 +--
 include/asm-sparc64/cacheflush.h     |   77 +-
 include/asm-sparc64/chafsr.h         |  242 +---
 include/asm-sparc64/checksum.h       |  168 +--
 include/asm-sparc64/chmctrl.h        |  184 +---
 include/asm-sparc64/cmt.h            |   60 +-
 include/asm-sparc64/compat.h         |  244 +---
 include/asm-sparc64/compat_signal.h  |   30 +-
 include/asm-sparc64/cpudata.h        |  241 +---
 include/asm-sparc64/dcr.h            |   15 +-
 include/asm-sparc64/dcu.h            |   28 +-
 include/asm-sparc64/delay.h          |   18 +-
 include/asm-sparc64/display7seg.h    |   80 +-
 include/asm-sparc64/dma-mapping.h    |  155 +--
 include/asm-sparc64/dma.h            |  206 +---
 include/asm-sparc64/ebus.h           |   95 +--
 include/asm-sparc64/elf.h            |  218 +---
 include/asm-sparc64/envctrl.h        |  104 +--
 include/asm-sparc64/estate.h         |   50 +-
 include/asm-sparc64/fbio.h           |  331 +----
 include/asm-sparc64/fcntl.h          |   36 +-
 include/asm-sparc64/fhc.h            |  132 +--
 include/asm-sparc64/floppy.h         |  783 +---------
 include/asm-sparc64/fpumacro.h       |   34 +-
 include/asm-sparc64/futex.h          |  111 +--
 include/asm-sparc64/hardirq.h        |   20 +-
 include/asm-sparc64/head.h           |   77 +-
 include/asm-sparc64/hugetlb.h        |   85 +-
 include/asm-sparc64/hvtramp.h        |   38 +-
 include/asm-sparc64/hw_irq.h         |    5 +-
 include/asm-sparc64/hypervisor.h     | 2946 +---------------------------------
 include/asm-sparc64/ide.h            |  119 +--
 include/asm-sparc64/idprom.h         |   26 +-
 include/asm-sparc64/intr_queue.h     |   16 +-
 include/asm-sparc64/io.h             |  512 +------
 include/asm-sparc64/ioctl.h          |   68 +-
 include/asm-sparc64/ioctls.h         |  137 +--
 include/asm-sparc64/iommu.h          |   63 +-
 include/asm-sparc64/ipcbuf.h         |   29 +-
 include/asm-sparc64/irq.h            |   94 +--
 include/asm-sparc64/irq_regs.h       |    2 +-
 include/asm-sparc64/irqflags.h       |   90 +-
 include/asm-sparc64/kdebug.h         |   20 +-
 include/asm-sparc64/kmap_types.h     |   26 +-
 include/asm-sparc64/kprobes.h        |   50 +-
 include/asm-sparc64/kvm.h            |    7 +-
 include/asm-sparc64/ldc.h            |  139 +--
 include/asm-sparc64/linkage.h        |    7 +-
 include/asm-sparc64/lmb.h            |   11 +-
 include/asm-sparc64/lsu.h            |   20 +-
 include/asm-sparc64/mc146818rtc.h    |   35 +-
 include/asm-sparc64/mdesc.h          |   79 +-
 include/asm-sparc64/mman.h           |   32 +-
 include/asm-sparc64/mmu.h            |  128 +--
 include/asm-sparc64/mmu_context.h    |  156 +--
 include/asm-sparc64/mmzone.h         |   18 +-
 include/asm-sparc64/module.h         |    8 +-
 include/asm-sparc64/mostek.h         |  144 +--
 include/asm-sparc64/msgbuf.h         |   28 +-
 include/asm-sparc64/mutex.h          |   10 +-
 include/asm-sparc64/namei.h          |   14 +-
 include/asm-sparc64/ns87303.h        |  119 +--
 include/asm-sparc64/of_platform.h    |   26 +-
 include/asm-sparc64/openprom.h       |  281 +----
 include/asm-sparc64/openpromio.h     |   70 +-
 include/asm-sparc64/oplib.h          |  323 +----
 include/asm-sparc64/page.h           |  143 +--
 include/asm-sparc64/param.h          |   24 +-
 include/asm-sparc64/parport.h        |  247 +---
 include/asm-sparc64/pci.h            |  210 +---
 include/asm-sparc64/percpu.h         |   29 +-
 include/asm-sparc64/perfctr.h        |  174 +--
 include/asm-sparc64/pgalloc.h        |   82 +-
 include/asm-sparc64/pgtable.h        |  782 +---------
 include/asm-sparc64/pil.h            |   22 +-
 include/asm-sparc64/poll.h           |   13 +-
 include/asm-sparc64/posix_types.h    |  123 +--
 include/asm-sparc64/processor.h      |  238 +---
 include/asm-sparc64/psrcompat.h      |   46 +-
 include/asm-sparc64/pstate.h         |   92 +--
 include/asm-sparc64/ptrace.h         |  347 +----
 include/asm-sparc64/reboot.h         |    7 +-
 include/asm-sparc64/reg.h            |   57 +-
 include/asm-sparc64/resource.h       |   20 +-
 include/asm-sparc64/rtc.h            |   27 +-
 include/asm-sparc64/rwsem-const.h    |   13 +-
 include/asm-sparc64/rwsem.h          |   85 +-
 include/asm-sparc64/sbus.h           |  191 +---
 include/asm-sparc64/scatterlist.h    |   28 +-
 include/asm-sparc64/scratchpad.h     |   15 +-
 include/asm-sparc64/seccomp.h        |   22 +-
 include/asm-sparc64/sections.h       |   10 +-
 include/asm-sparc64/semaphore.h      |    2 +-
 include/asm-sparc64/sembuf.h         |   23 +-
 include/asm-sparc64/setup.h          |   11 +-
 include/asm-sparc64/sfafsr.h         |   83 +-
 include/asm-sparc64/sfp-machine.h    |   94 +--
 include/asm-sparc64/shmbuf.h         |   39 +-
 include/asm-sparc64/shmparam.h       |   11 +-
 include/asm-sparc64/sigcontext.h     |   88 +-
 include/asm-sparc64/siginfo.h        |   33 +-
 include/asm-sparc64/signal.h         |  195 +---
 include/asm-sparc64/smp.h            |   65 +-
 include/asm-sparc64/socket.h         |   58 +-
 include/asm-sparc64/sockios.h        |   15 +-
 include/asm-sparc64/sparsemem.h      |   13 +-
 include/asm-sparc64/spinlock.h       |  251 +---
 include/asm-sparc64/spinlock_types.h |   21 +-
 include/asm-sparc64/spitfire.h       |  343 +----
 include/asm-sparc64/sstate.h         |   14 +-
 include/asm-sparc64/stacktrace.h     |    7 +-
 include/asm-sparc64/starfire.h       |   22 +-
 include/asm-sparc64/stat.h           |   48 +-
 include/asm-sparc64/statfs.h         |   55 +-
 include/asm-sparc64/string.h         |   84 +-
 include/asm-sparc64/sunbpp.h         |   81 +-
 include/asm-sparc64/syscalls.h       |   14 +-
 include/asm-sparc64/system.h         |  356 +----
 include/asm-sparc64/termbits.h       |  261 +---
 include/asm-sparc64/termios.h        |  187 +---
 include/asm-sparc64/thread_info.h    |  278 +----
 include/asm-sparc64/timer.h          |   31 +-
 include/asm-sparc64/timex.h          |   20 +-
 include/asm-sparc64/tlb.h            |  112 +--
 include/asm-sparc64/tlbflush.h       |   45 +-
 include/asm-sparc64/topology.h       |   87 +-
 include/asm-sparc64/tsb.h            |  284 +----
 include/asm-sparc64/ttable.h         |  659 +--------
 include/asm-sparc64/types.h          |   35 +-
 include/asm-sparc64/uaccess.h        |  274 +----
 include/asm-sparc64/uctx.h           |   72 +-
 include/asm-sparc64/unaligned.h      |   11 +-
 include/asm-sparc64/unistd.h         |  374 +-----
 include/asm-sparc64/upa.h            |  110 +--
 include/asm-sparc64/utrap.h          |   52 +-
 include/asm-sparc64/vga.h            |   34 +-
 include/asm-sparc64/vio.h            |  407 +-----
 include/asm-sparc64/visasm.h         |   63 +-
 include/asm-sparc64/watchdog.h       |   32 +-
 include/asm-sparc64/xor.h            |   71 +-
 462 files changed, 26902 insertions(+), 27102 deletions(-)
 create mode 100644 drivers/char/hw_random/n2-asm.S
 create mode 100644 drivers/char/hw_random/n2-drv.c
 create mode 100644 drivers/char/hw_random/n2rng.h
 create mode 100644 include/asm-sparc/agp.h
 create mode 100644 include/asm-sparc/apb.h
 create mode 100644 include/asm-sparc/atomic_32.h
 create mode 100644 include/asm-sparc/atomic_64.h
 create mode 100644 include/asm-sparc/auxio_32.h
 create mode 100644 include/asm-sparc/auxio_64.h
 create mode 100644 include/asm-sparc/backoff.h
 create mode 100644 include/asm-sparc/bbc.h
 create mode 100644 include/asm-sparc/bitops_32.h
 create mode 100644 include/asm-sparc/bitops_64.h
 create mode 100644 include/asm-sparc/cacheflush_32.h
 create mode 100644 include/asm-sparc/cacheflush_64.h
 create mode 100644 include/asm-sparc/chafsr.h
 create mode 100644 include/asm-sparc/checksum_32.h
 create mode 100644 include/asm-sparc/checksum_64.h
 create mode 100644 include/asm-sparc/chmctrl.h
 create mode 100644 include/asm-sparc/cmt.h
 create mode 100644 include/asm-sparc/compat.h
 create mode 100644 include/asm-sparc/compat_signal.h
 create mode 100644 include/asm-sparc/cpudata_32.h
 create mode 100644 include/asm-sparc/cpudata_64.h
 create mode 100644 include/asm-sparc/dcr.h
 create mode 100644 include/asm-sparc/dcu.h
 create mode 100644 include/asm-sparc/delay_32.h
 create mode 100644 include/asm-sparc/delay_64.h
 create mode 100644 include/asm-sparc/display7seg.h
 create mode 100644 include/asm-sparc/dma-mapping_32.h
 create mode 100644 include/asm-sparc/dma-mapping_64.h
 create mode 100644 include/asm-sparc/dma_32.h
 create mode 100644 include/asm-sparc/dma_64.h
 create mode 100644 include/asm-sparc/ebus_32.h
 create mode 100644 include/asm-sparc/ebus_64.h
 create mode 100644 include/asm-sparc/elf_32.h
 create mode 100644 include/asm-sparc/elf_64.h
 create mode 100644 include/asm-sparc/envctrl.h
 create mode 100644 include/asm-sparc/estate.h
 create mode 100644 include/asm-sparc/fhc.h
 create mode 100644 include/asm-sparc/floppy_32.h
 create mode 100644 include/asm-sparc/floppy_64.h
 create mode 100644 include/asm-sparc/fpumacro.h
 create mode 100644 include/asm-sparc/futex_32.h
 create mode 100644 include/asm-sparc/futex_64.h
 create mode 100644 include/asm-sparc/hardirq_32.h
 create mode 100644 include/asm-sparc/hardirq_64.h
 create mode 100644 include/asm-sparc/head_32.h
 create mode 100644 include/asm-sparc/head_64.h
 create mode 100644 include/asm-sparc/hugetlb.h
 create mode 100644 include/asm-sparc/hvtramp.h
 create mode 100644 include/asm-sparc/hypervisor.h
 create mode 100644 include/asm-sparc/ide_32.h
 create mode 100644 include/asm-sparc/ide_64.h
 create mode 100644 include/asm-sparc/intr_queue.h
 create mode 100644 include/asm-sparc/io_32.h
 create mode 100644 include/asm-sparc/io_64.h
 create mode 100644 include/asm-sparc/iommu_32.h
 create mode 100644 include/asm-sparc/iommu_64.h
 create mode 100644 include/asm-sparc/ipcbuf_32.h
 create mode 100644 include/asm-sparc/ipcbuf_64.h
 create mode 100644 include/asm-sparc/irq_32.h
 create mode 100644 include/asm-sparc/irq_64.h
 create mode 100644 include/asm-sparc/irqflags_32.h
 create mode 100644 include/asm-sparc/irqflags_64.h
 create mode 100644 include/asm-sparc/kdebug_32.h
 create mode 100644 include/asm-sparc/kdebug_64.h
 create mode 100644 include/asm-sparc/kprobes.h
 create mode 100644 include/asm-sparc/ldc.h
 create mode 100644 include/asm-sparc/lmb.h
 create mode 100644 include/asm-sparc/lsu.h
 create mode 100644 include/asm-sparc/mc146818rtc_32.h
 create mode 100644 include/asm-sparc/mc146818rtc_64.h
 create mode 100644 include/asm-sparc/mdesc.h
 create mode 100644 include/asm-sparc/mmu_32.h
 create mode 100644 include/asm-sparc/mmu_64.h
 create mode 100644 include/asm-sparc/mmu_context_32.h
 create mode 100644 include/asm-sparc/mmu_context_64.h
 create mode 100644 include/asm-sparc/mmzone.h
 create mode 100644 include/asm-sparc/module_32.h
 create mode 100644 include/asm-sparc/module_64.h
 create mode 100644 include/asm-sparc/mostek_32.h
 create mode 100644 include/asm-sparc/mostek_64.h
 create mode 100644 include/asm-sparc/namei_32.h
 create mode 100644 include/asm-sparc/namei_64.h
 create mode 100644 include/asm-sparc/ns87303.h
 create mode 100644 include/asm-sparc/of_platform_32.h
 create mode 100644 include/asm-sparc/of_platform_64.h
 create mode 100644 include/asm-sparc/openprom_32.h
 create mode 100644 include/asm-sparc/openprom_64.h
 create mode 100644 include/asm-sparc/oplib_32.h
 create mode 100644 include/asm-sparc/oplib_64.h
 create mode 100644 include/asm-sparc/page_32.h
 create mode 100644 include/asm-sparc/page_64.h
 create mode 100644 include/asm-sparc/parport.h
 create mode 100644 include/asm-sparc/pci_32.h
 create mode 100644 include/asm-sparc/pci_64.h
 create mode 100644 include/asm-sparc/percpu_32.h
 create mode 100644 include/asm-sparc/percpu_64.h
 create mode 100644 include/asm-sparc/pgalloc_32.h
 create mode 100644 include/asm-sparc/pgalloc_64.h
 create mode 100644 include/asm-sparc/pgtable_32.h
 create mode 100644 include/asm-sparc/pgtable_64.h
 create mode 100644 include/asm-sparc/pil.h
 create mode 100644 include/asm-sparc/posix_types_32.h
 create mode 100644 include/asm-sparc/posix_types_64.h
 create mode 100644 include/asm-sparc/processor_32.h
 create mode 100644 include/asm-sparc/processor_64.h
 create mode 100644 include/asm-sparc/psrcompat.h
 create mode 100644 include/asm-sparc/pstate.h
 create mode 100644 include/asm-sparc/ptrace_32.h
 create mode 100644 include/asm-sparc/ptrace_64.h
 create mode 100644 include/asm-sparc/reboot.h
 create mode 100644 include/asm-sparc/reg_32.h
 create mode 100644 include/asm-sparc/reg_64.h
 create mode 100644 include/asm-sparc/rwsem-const.h
 create mode 100644 include/asm-sparc/rwsem.h
 create mode 100644 include/asm-sparc/sbus_32.h
 create mode 100644 include/asm-sparc/sbus_64.h
 create mode 100644 include/asm-sparc/scatterlist_32.h
 create mode 100644 include/asm-sparc/scatterlist_64.h
 create mode 100644 include/asm-sparc/scratchpad.h
 create mode 100644 include/asm-sparc/seccomp.h
 create mode 100644 include/asm-sparc/sections_32.h
 create mode 100644 include/asm-sparc/sections_64.h
 create mode 100644 include/asm-sparc/sfafsr.h
 create mode 100644 include/asm-sparc/sfp-machine_32.h
 create mode 100644 include/asm-sparc/sfp-machine_64.h
 create mode 100644 include/asm-sparc/shmparam_32.h
 create mode 100644 include/asm-sparc/shmparam_64.h
 create mode 100644 include/asm-sparc/sigcontext_32.h
 create mode 100644 include/asm-sparc/sigcontext_64.h
 create mode 100644 include/asm-sparc/siginfo_32.h
 create mode 100644 include/asm-sparc/siginfo_64.h
 create mode 100644 include/asm-sparc/signal_32.h
 create mode 100644 include/asm-sparc/signal_64.h
 create mode 100644 include/asm-sparc/smp_32.h
 create mode 100644 include/asm-sparc/smp_64.h
 create mode 100644 include/asm-sparc/sparsemem.h
 create mode 100644 include/asm-sparc/spinlock_32.h
 create mode 100644 include/asm-sparc/spinlock_64.h
 create mode 100644 include/asm-sparc/spitfire.h
 create mode 100644 include/asm-sparc/sstate.h
 create mode 100644 include/asm-sparc/stacktrace.h
 create mode 100644 include/asm-sparc/starfire.h
 create mode 100644 include/asm-sparc/stat_32.h
 create mode 100644 include/asm-sparc/stat_64.h
 create mode 100644 include/asm-sparc/statfs_32.h
 create mode 100644 include/asm-sparc/statfs_64.h
 create mode 100644 include/asm-sparc/string_32.h
 create mode 100644 include/asm-sparc/string_64.h
 create mode 100644 include/asm-sparc/syscalls.h
 create mode 100644 include/asm-sparc/system_32.h
 create mode 100644 include/asm-sparc/system_64.h
 create mode 100644 include/asm-sparc/thread_info_32.h
 create mode 100644 include/asm-sparc/thread_info_64.h
 create mode 100644 include/asm-sparc/timer_32.h
 create mode 100644 include/asm-sparc/timer_64.h
 create mode 100644 include/asm-sparc/timex_32.h
 create mode 100644 include/asm-sparc/timex_64.h
 create mode 100644 include/asm-sparc/tlb_32.h
 create mode 100644 include/asm-sparc/tlb_64.h
 create mode 100644 include/asm-sparc/tlbflush_32.h
 create mode 100644 include/asm-sparc/tlbflush_64.h
 create mode 100644 include/asm-sparc/topology_32.h
 create mode 100644 include/asm-sparc/topology_64.h
 create mode 100644 include/asm-sparc/tsb.h
 create mode 100644 include/asm-sparc/ttable.h
 create mode 100644 include/asm-sparc/uaccess_32.h
 create mode 100644 include/asm-sparc/uaccess_64.h
 create mode 100644 include/asm-sparc/uctx.h
 create mode 100644 include/asm-sparc/unistd_32.h
 create mode 100644 include/asm-sparc/unistd_64.h
 create mode 100644 include/asm-sparc/upa.h
 create mode 100644 include/asm-sparc/utrap.h
 create mode 100644 include/asm-sparc/vio.h
 create mode 100644 include/asm-sparc/visasm.h
 create mode 100644 include/asm-sparc/watchdog.h
 create mode 100644 include/asm-sparc/xor_32.h
 create mode 100644 include/asm-sparc/xor_64.h
