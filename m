Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbYDSSIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbYDSSIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYDSSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:08:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbYDSSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:08:38 -0400
Date: Sat, 19 Apr 2008 20:08:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 changes for v2.6.26, part two
Message-ID: <20080419180818.GA21353@elte.hu>
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


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

the tree touches the following generic files:

   include/linux/efi.h                                |    7 +
   include/linux/irqflags.h                           |    6 +-
   include/linux/prctl.h                              |    6 +
   kernel/fork.c                                      |   35 ++-
   kernel/sys.c                                       |   13 +-
   kernel/time/timekeeping.c                          |    2 +

these are for changes that have their main (only) use in arch/x86 - the 
fork.c impact is for lazy FPU state allocation. Cross-build test results 
are at:

   http://www.tglx.de/autoqa-cgi/index?run=88&tree=1

Thanks,

	Ingo

------------------>
Alexander van Heukelum (1):
      x86: cleanup boot-heap usage

Erik Bosman (3):
      generic, x86: add prctl commands PR_GET_TSC and PR_SET_TSC
      x86: implement prctl PR_GET_TSC and PR_SET_TSC
      generic, x86: add tests for prctl PR_GET_TSC and PR_SET_TSC

Glauber Costa (48):
      x86: move dma_ops struct definition to dma-mapping.h
      x86: implement dma_map_single through dma_ops
      x86: move dma_unmap_single to common header
      x86: move dma_map_sg to common header
      x86: move dma_unmap_sg to common header
      x86: move dma_sync_single_for_cpu to common header
      x86: move dma_sync_single_for_device to common header
      x86: move dma_sync_single_range_for_cpu to common header
      x86: move dma_sync_single_range_for_device to common header
      x86: move dma_sync_sg_for_cpu to common header
      x86: move dma_sync_sg_for_device to common header
      x86: move alloc and free coherent to common header
      x86: move dma_map_page and dma_unmap_page to common header
      x86: move dma_cache_sync to common header
      x86: move dma_supported and dma_set_mask to pci-dma_32.c
      x86: align to clflush size
      x86: provide a bad_dma_address symbol for i386
      x86: unify dma_mapping_error
      x86: move ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY to dma-mapping.h
      x86: delete the arch-specific dma-mapping headers.
      x86: introduce pci-dma.c
      x86: delete empty functions from pci-nommu_64.c
      x86: implement mapping_error in pci-nommu_64.c
      x86: Add flush_write_buffers in nommu functions
      x86: use sg_phys in x86_64
      x86: use WARN_ON in mapping functions
      x86: use dma_length in i386
      x86: move definition to pci-dma.c
      x86: unify pci-nommu
      x86: move initialization functions to pci-dma.c
      x86: move x86_64-specific to common code.
      x86: move pci fixup to pci-dma.c
      x86: merge dma_supported
      x86: merge iommu initialization parameters
      x86: move dma_coherent functions to pci-dma.c
      x86: isolate coherent mapping functions
      x86: move bad_dma_address
      x86: adjust dma_free_coherent for i386
      x86: remove virt_to_bus in pci-dma_64.c
      x86: use numa allocation function in i386
      x86: use a fallback dev for i386
      x86: don't try to allocate from DMA zone at first
      x86: retry allocation if failed
      x86: unify gfp masks
      x86: remove kludge from x86_64
      x86: return conditional to mmu
      x86: don't do dma if mask is NULL.
      x86: integrate pci-dma.c

Harvey Harrison (1):
      x86: pageattr.c fix shadowed variable warning

Huang, Ying (1):
      x86: EFI_PAGE_SHIFT fix

Ingo Molnar (4):
      x86: KGDB build fix
      x86: clean up cpu capabilities accesses, p4-clockmod.c
      x86: rename find_max_pfn() to propagate_e820_map()
      x86: dma-ops on highmem fix

Jacek Luczak (2):
      x86: remove vm86.h inclusion from process_32.c
      x86: e820_64, fix section mismatch warning

Jack Steiner (1):
      x86: UV startup of slave cpus

Jiri Slaby (1):
      x86: fix exec mappings comments

Mark McLoughlin (1):
      x86: move dma_supported and dma_set_mask to pci-dma_32.c, fix

Pavel Machek (1):
      x86: clean up =0 initializations in arch/x86/kernel/tsc_32.c

Randy Dunlap (1):
      x86: fix arch/x86/mm/ioremap.c warning

Roland McGrath (1):
      x86 vDSO: compile with -g, 64-bit

Steven Rostedt (1):
      ftrace: add notrace annotations for NMI routines

Suresh Siddha (5):
      x86, fpu: split FPU state from task struct - v5
      x86, fpu: lazy allocation of FPU area - v5
      x86: fpu xstate split cleanup
      x86: fpu xstate split fix
      srat, x86: add support for nodes spanning other nodes

Thomas Gleixner (1):
      x86: tsc prevent time going backwards

WANG Cong (1):
      x86: remove pointless comments

Yinghai Lu (3):
      x86_64: do not reserve ramdisk two times
      x86: cleanup: change _end to end_before_pgt
      x86: reserve dma32 early for gart

 Documentation/feature-removal-schedule.txt         |    7 +
 Documentation/kernel-parameters.txt                |   10 +-
 .../prctl/disable-tsc-ctxt-sw-stress-test.c        |   96 ++++
 .../prctl/disable-tsc-on-off-stress-test.c         |   95 ++++
 Documentation/prctl/disable-tsc-test.c             |   94 ++++
 arch/x86/Kconfig                                   |    9 +
 arch/x86/boot/a20.c                                |    2 -
 arch/x86/boot/apm.c                                |    2 -
 arch/x86/boot/bitops.h                             |    2 -
 arch/x86/boot/boot.h                               |    2 -
 arch/x86/boot/cmdline.c                            |    2 -
 arch/x86/boot/compressed/head_32.S                 |   15 +-
 arch/x86/boot/compressed/head_64.S                 |   30 +-
 arch/x86/boot/compressed/misc.c                    |    8 +-
 arch/x86/boot/compressed/vmlinux_64.lds            |    4 +-
 arch/x86/boot/copy.S                               |    2 -
 arch/x86/boot/cpucheck.c                           |    2 -
 arch/x86/boot/edd.c                                |    2 -
 arch/x86/boot/install.sh                           |    2 -
 arch/x86/boot/main.c                               |    2 -
 arch/x86/boot/mca.c                                |    2 -
 arch/x86/boot/memory.c                             |    2 -
 arch/x86/boot/pm.c                                 |    2 -
 arch/x86/boot/pmjump.S                             |    2 -
 arch/x86/boot/printf.c                             |    2 -
 arch/x86/boot/string.c                             |    2 -
 arch/x86/boot/tty.c                                |    2 -
 arch/x86/boot/version.c                            |    2 -
 arch/x86/boot/video-bios.c                         |    2 -
 arch/x86/boot/video-vesa.c                         |    2 -
 arch/x86/boot/video-vga.c                          |    2 -
 arch/x86/boot/video.c                              |    2 -
 arch/x86/boot/video.h                              |    2 -
 arch/x86/boot/voyager.c                            |    2 -
 arch/x86/kernel/Makefile                           |    9 +-
 arch/x86/kernel/acpi/cstate.c                      |    2 -
 arch/x86/kernel/acpi/processor.c                   |    2 -
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c          |    4 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |    1 -
 arch/x86/kernel/e820_32.c                          |    4 +-
 arch/x86/kernel/e820_64.c                          |    4 +-
 arch/x86/kernel/efi.c                              |   18 +-
 arch/x86/kernel/efi_64.c                           |   12 +-
 arch/x86/kernel/entry_32.S                         |    1 -
 arch/x86/kernel/genx2apic_uv_x.c                   |   17 +-
 arch/x86/kernel/head64.c                           |    2 +
 arch/x86/kernel/head_32.S                          |    1 -
 arch/x86/kernel/i387.c                             |  114 +++--
 arch/x86/kernel/kgdb.c                             |    6 +-
 arch/x86/kernel/nmi_32.c                           |    3 +-
 arch/x86/kernel/nmi_64.c                           |    6 +-
 arch/x86/kernel/pci-calgary_64.c                   |    3 +-
 arch/x86/kernel/pci-dma.c                          |  524 ++++++++++++++++++++
 arch/x86/kernel/pci-dma_32.c                       |  177 -------
 arch/x86/kernel/pci-dma_64.c                       |  344 -------------
 arch/x86/kernel/pci-gart_64.c                      |   15 +-
 arch/x86/kernel/{pci-nommu_64.c => pci-nommu.c}    |   34 +-
 arch/x86/kernel/pci-swiotlb_64.c                   |    9 +-
 arch/x86/kernel/process.c                          |   44 ++
 arch/x86/kernel/process_32.c                       |   50 ++-
 arch/x86/kernel/process_64.c                       |   74 +++-
 arch/x86/kernel/setup64.c                          |    4 +-
 arch/x86/kernel/setup_32.c                         |    4 +-
 arch/x86/kernel/setup_64.c                         |    9 +-
 arch/x86/kernel/smpboot.c                          |   29 +-
 arch/x86/kernel/traps_32.c                         |   35 +-
 arch/x86/kernel/traps_64.c                         |   36 +-
 arch/x86/kernel/tsc_32.c                           |   23 +-
 arch/x86/kernel/tsc_64.c                           |   23 +-
 arch/x86/mach-visws/visws_apic.c                   |    2 -
 arch/x86/mach-voyager/voyager_basic.c              |    2 -
 arch/x86/mach-voyager/voyager_cat.c                |    2 -
 arch/x86/mach-voyager/voyager_smp.c                |    2 -
 arch/x86/mach-voyager/voyager_thread.c             |    2 -
 arch/x86/math-emu/fpu_entry.c                      |    4 +-
 arch/x86/math-emu/fpu_system.h                     |   26 +-
 arch/x86/math-emu/reg_ld_str.c                     |    4 +-
 arch/x86/mm/discontig_32.c                         |    6 +-
 arch/x86/mm/init_32.c                              |    1 -
 arch/x86/mm/init_64.c                              |    3 -
 arch/x86/mm/ioremap.c                              |    5 +-
 arch/x86/mm/k8topology_64.c                        |    2 +-
 arch/x86/mm/numa_64.c                              |   16 +-
 arch/x86/mm/pgtable_32.c                           |    4 -
 arch/x86/mm/srat_64.c                              |   32 +-
 arch/x86/vdso/Makefile                             |    3 +-
 arch/x86/video/fbdev.c                             |    1 -
 include/asm-x86/boot.h                             |    8 +
 include/asm-x86/dma-mapping.h                      |  238 +++++++++-
 include/asm-x86/dma-mapping_32.h                   |  187 -------
 include/asm-x86/dma-mapping_64.h                   |  202 --------
 include/asm-x86/e820_32.h                          |    2 +-
 include/asm-x86/genapic_32.h                       |    1 +
 include/asm-x86/i387.h                             |   37 +-
 include/asm-x86/numa_64.h                          |    3 +-
 include/asm-x86/pci_64.h                           |    1 +
 include/asm-x86/processor.h                        |   16 +-
 include/asm-x86/scatterlist.h                      |    2 -
 include/asm-x86/thread_info.h                      |    9 +
 include/asm-x86/thread_info_32.h                   |    2 -
 include/asm-x86/thread_info_64.h                   |    6 +-
 include/asm-x86/tsc.h                              |    1 +
 include/linux/efi.h                                |    7 +
 include/linux/irqflags.h                           |    6 +-
 include/linux/prctl.h                              |    6 +
 kernel/fork.c                                      |   35 ++-
 kernel/sys.c                                       |   13 +-
 kernel/time/timekeeping.c                          |    2 +
 108 files changed, 1710 insertions(+), 1250 deletions(-)
 create mode 100644 Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
 create mode 100644 Documentation/prctl/disable-tsc-on-off-stress-test.c
 create mode 100644 Documentation/prctl/disable-tsc-test.c
 create mode 100644 arch/x86/kernel/pci-dma.c
 delete mode 100644 arch/x86/kernel/pci-dma_32.c
 delete mode 100644 arch/x86/kernel/pci-dma_64.c
 rename arch/x86/kernel/{pci-nommu_64.c => pci-nommu.c} (77%)
 create mode 100644 arch/x86/kernel/process.c
 delete mode 100644 include/asm-x86/dma-mapping_32.h
 delete mode 100644 include/asm-x86/dma-mapping_64.h

