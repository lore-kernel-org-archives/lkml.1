Return-Path: <linux-kernel-owner+w=401wt.eu-S933867AbZLMBlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbZLMBlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933851AbZLMBlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:41:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:52513 "HELO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933844AbZLMBlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:41:07 -0500
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 08:51:37 +1100
Message-ID: <1260654697.16332.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-MIME-Autoconverted: from 8bit to quoted-printable by gate.crashing.org id nBCLpbVB010755
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

So here's finally the powerpc merge for this window. I was waiting to
sort out some stuff with the Nintendo Gamecube and Wii patches but in
the end, I may as well have them in a separate pull request rather than
waiting longer.

Among the highlights this time around, there's Alex new 64-bit ppc KVM
which uses the same technique as MacOnLinux to run 32 or 64-bit
"classic" kernels in userspace and emulate all supervisor operations.
There's some hugetlb support rework by David that's preliminary to get
hugetlb implemented on BookE (the later will probably come in the next
merge window). I finally did a libata variant of the "macio" powermac
IDE controller so that's one less thing blocking a full transition to
libata. Many embedded updates, some new pSeries kernel infrastructure
for dynamic partitionning, some improvements to CPU hotplug, etc...

Most changes are to arch/powerpc or powerpc specific drivers. There's a
few things elsewhere, such as a libata bug fix that you should also get
via Jeff, a small KVM bit that we need and should also be in Avi tree,
some sysfs additions to drivers/base/cpu that nobody objected to (Greg
explicitely said "no objections" though I couldn't extract an actual
Acked-by from anybody either). And that should be about it.

Cheers,
Ben.

The following changes since commit 3ff6a468b45b5dfeb0e903e56f4eb27d34b2437c:
  Linus Torvalds (1):
        Merge branch 'x86-xen-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Albrecht Dreß (5):
      powerpc: tiny memcpy_(to|from)io optimisation
      mpc5200/gpt: tiny fix for gpt period limitation
      mpc52xx/wdt: OF property to enable the WDT on boot
      mpc52xx/wdt: merge WDT code into the GPT driver
      mpc52xx/wdt: remove obsolete old WDT implementation

Alexander Graf (28):
      Move dirty logging code to sub-arch
      Pass PVR in sregs
      Add Book3s definitions
      Add Book3s fields to vcpu structs
      Add asm/kvm_book3s.h
      Add Book3s_64 intercept helpers
      Add book3s_64 highmem asm code
      Add SLB switching code for entry/exit
      Add interrupt handling code
      Add book3s.c
      Add book3s_64 Host MMU handling
      Add book3s_64 guest MMU
      Add book3s_32 guest MMU
      Add book3s_64 specific opcode emulation
      Add mfdec emulation
      Add desktop PowerPC specific emulation
      Make head_64.S aware of KVM real mode code
      Add Book3s_64 offsets to asm-offsets.c
      Export symbols for KVM module
      Split init_new_context and destroy_context
      Export KVM symbols for module
      Add fields to PACA
      Export new PACA constants in asm-offsets
      Include Book3s_64 target in buildsystem
      Fix trace.h
      Use Little Endian for Dirty Bitmap
      Use hrtimers for the decrementer
      powerpc/kvm: Sync guest visible MMU state

Alexey Dobriyan (2):
      Convert /proc/device-tree/ to seq_file
      powerpc/via-pmu: Convert to proc_fops/seq_file

Amit Shah (1):
      hvc_console: Export (GPL'ed) hvc_remove

Anton Blanchard (1):
      powerpc: Move ehea hcall definitions into hvcall.h

Anton Vorontsov (20):
      powerpc: Make it possible to select hibernation on all PowerPCs
      of/platform: Implement support for dev_pm_ops
      powerpc/qe: Increase MAX_QE_RISC to 4
      powerpc/qe: Add qe_upload_firmware() stub for non-QE builds
      powerpc/qe: Make qe_reset() code path safe for repeated invocation
      powerpc/qe: QE also shuts down on MPC8568
      powerpc/cpm: Remove SPI defines and spi structs
      powerpc/qe&cpm2: Avoid redefinitions in CPM2 and QE headers
      powerpc/cpm: Move CPMFCR_* defines into cpm.h
      powerpc/qe&cpm: Implement static inline stubs for non-QE/CPM builds
      spi_mpc8xxx: Fix uninitialized variable
      spi_mpc8xxx: Factor out SPI mode change steps into a call
      spi_mpc8xxx: Turn qe_mode into flags
      spi_mpc8xxx: Add support for QE DMA mode and CPM1/CPM2 chips
      powerpc/qe: Implement QE driver for handling resume on MPC85xx
      powerpc/85xx/86xx: Add suspend/resume support
      powerpc/85xx: Add power management support for MPC85xxMDS boards
      powerpc/86xx: Add power management support for MPC8610HPCD boards
      powerpc/83xx: Add power management support for MPC83xx QE boards
      powerpc/fsl: Make fsl_deep_sleep() usable w/ modules and non-83xx builds

Arnd Bergmann (1):
      powerpc: Fix wrong error code from ppc32 select syscall

Becky Bruce (1):
      powerpc: Fix DEBUG_HIGHMEM build break from d4515646699

Benjamin Herrenschmidt (21):
      powerpc: Move /proc/ppc64 to /proc/powerpc and add symlink
      powerpc/chrp: Use the same RTAS daemon as pSeries
      powerpc/8xx: Fix build breakage with sparse irq changes
      powerpc/kvm: Remove problematic BUILD_BUG_ON statement
      Merge branch 'kvm' into next
      powerpc/kvm: Fix non-modular build
      Merge commit 'origin/master' into next
      Merge commit 'jwb/next' into next
      powerpc: kill the obsolete code under is_global_init()
      powerpc: Fix build of some FSL platforms
      Merge commit 'origin/master' into next
      Revert "powerpc/mm: Fix bug in pagetable cache cleanup with CONFIG_PPC_SUBPAGE_PROT"
      powerpc/macio: Add devres support to macio_device
      powerpc/macio: Add dma_parms support to macio
      powerpc/macio: Rework hotplug media bay support
      libata/sff: Use ops->bmdma_stop instead of ata_bmdma_stop()
      libata/drivers: Add driver for Apple "MacIO" IDE controller
      Merge commit 'gcl/next' into next
      Merge commit 'jwb/next' into next
      Merge commit 'origin/master' into next
      powerpc: Fix usage of 64-bit instruction in 32-bit altivec code

Bolko Maass (1):
      powerpc/windfarm: Add detection for second cpu pump

Brian King (1):
      powerpc: Add kdump support to Collaborative Memory Manager

Curtis Wald (1):
      powerpc/44x: Fix PCI node in Yosemite DTS

Darrick J. Wong (1):
      powerpc/therm_adt746x: Record pwm invert bit at module load time]

Dave Airlie (1):
      offb: Add support for framebuffer handoff to offb.

Dave Mitchell (1):
      powerpc/4xx: Add 16K FIFO size DTS entries on supported platforms

David Gibson (9):
      powerpc/mm: Make hpte_need_flush() correctly mask for multiple page sizes
      powerpc/mm: Cleanup management of kmem_caches for pagetables
      powerpc/mm: Allow more flexible layouts for hugepage pagetables
      powerpc/mm: Cleanup initialization of hugepages on powerpc
      powerpc/mm: Split hash MMU specific hugepage code into a new file
      powerpc/mm: Bring hugepage PTE accessor functions back into sync with normal accessors
      powerpc/mm: Fix bug in pagetable cache cleanup with CONFIG_PPC_SUBPAGE_PROT
      powerpc/mm: Fix bug in gup_hugepd()
      powerpc/mm: Fix pgtable cache cleanup with CONFIG_PPC_SUBPAGE_PROT

FUJITA Tomonori (1):
      powerpc: Kill unused swiotlb variable

Gautham R Shenoy (4):
      powerpc/pseries: Add extended_cede_processor() helper function.
      powerpc/pseries: Add hooks to put the CPU into an appropriate offline state
      pseries/pseries: Add code to online/offline CPUs of a DLPAR node
      powerpc/pseries: Serialize cpu hotplug operations during deactivate Vs deallocate

Grant Likely (4):
      spi/mpc5200: Register SPI devices described in device tree
      powerpc/5200: Add mpc5200-spi (non-PSC) device driver
      powerpc/5200: add general purpose timer API for the MPC5200
      mmc: fix missing module license declaration in of_mmc_spi.c

Jean Delvare (1):
      powerpc/therm_adt746x: Don't access non-existing register

Joakim Tjernlund (9):
      powerpc/8xx: Invalidate non present TLBs
      powerpc/8xx: Update TLB asm so it behaves as linux mm expects.
      powerpc/8xx: Tag DAR with 0x00f0 to catch buggy instructions.
      powerpc/8xx: Fixup DAR from buggy dcbX instructions.
      powerpc/8xx: Add missing Guarded setting in DTLB Error.
      powerpc/8xx: Restore _PAGE_WRITETHRU
      powerpc/8xx: Start using dcbX instructions in various copy routines
      powerpc/8xx: Remove DIRTY pte handling in DTLB Error.
      powerpc/8xx: DTLB Miss cleanup

Joe Perches (1):
      MAINTAINERS: Add PowerPC patterns

John Bonesio (1):
      powerpc/5200: add LocalPlus bus FIFO device driver

John Linn (1):
      Xilinx: SPI: Fix bits_per_word for transfers

Kumar Gala (4):
      powerpc/85xx: Kconfig cleanup
      powerpc/fsl-booke: Rework TLB CAM code
      powerpc/fsl: Add PCI device ids for new QoirQ chips
      powerpc/p4080: Add basic support for p4080ds platform

Mark Nelson (1):
      powerpc/pseries: Track previous CPPR values to correctly EOI interrupts

Martyn Welch (3):
      powerpc/86xx: Enable NVRAM on GE Fanuc's SBC610
      powerpc/86xx: Support for NVRAM on GE Fanuc's SBC310
      powerpc/86xx: Support for NVRAM on GE Fanuc's PPC9A

Michael Ellerman (7):
      powerpc/ps3: Use pr_devel() in ps3/mm.c
      powerpc: Make NR_IRQS a CONFIG option
      powerpc/pseries: Use irq_has_action() in eeh_disable_irq()
      powerpc: Remove get_irq_desc()
      powerpc: Make virq_debug_show() cope with sparse irq_descs
      powerpc: Rearrange and fix show_interrupts() for sparse irq_descs
      powerpc: Enable sparse irq_descs on powerpc

Michael Neuling (1):
      powerpc: Fix potential compile error irqs_disabled_flags

Michal Simek (1):
      powerpc/of_serial: Add missing ns16550a id

Michel Dänzer (2):
      agp/uninorth: Also handle user memory types in u3_remove_memory().
      agp/uninorth: Unify U3 and pre-U3 insert_memory and remove_memory hooks.

Nathan Fontenot (4):
      powerpc/pseries: Kernel DLPAR Infrastructure
      sysfs/cpu: Add probe/release files
      powerpc/pseries: Add kernel based CPU DLPAR handling
      powerpc/pseries: Correct pseries/dlpar.c build break without CONFIG_SMP

Olof Johansson (1):
      powerpc: pasemi_defconfig update

Poonam Aggrwal (2):
      powerpc/85xx: Create dts for each core in CAMP mode for P2020RDB
      powerpc/85xx: Added P1020RDB Platform support.

Roman Fietze (1):
      powerpc: Make "intspec" pointers in irq_host->xlate() const

Stefan Roese (1):
      powerpc/44x: Enable 64bit (>= 4GB) memory size in Katmai dts

Stephen Rothwell (1):
      powerpc: do not export pci_alloc/free_consistent

Thomas Gleixner (7):
      powerpc/nvram_64: Remove unused code
      powerpc/nvram_64: Check nvram_error_log_index in nvram_clear_error_log()
      powerpc/nvram_64: Mark init code __init
      powerpc: Use unlocked ioctl in nvram_64
      macintosh: Remove BKL from nvram driver
      powerpc: Replace old style lock initializer
      powerpc: Fixup last users of irq_chip->typename

Valentine Barshak (1):
      powerpc: stop_this_cpu: remove the cpu from the online map.

Wolfram Sang (2):
      spi/mpc52xx-psc-spi: check for valid PSC
      spi/mpc52xx: replace printk with dev_err

pbathija@amcc.com (1):
      powerpc/44x: Fix DMA ranges in DTS file for Katmai board.

roel kluin (1):
      powerpc/spufs: Fix test in spufs_switch_log_read()

 Documentation/ABI/testing/sysfs-devices-system-cpu |   15 +
 Documentation/cpu-hotplug.txt                      |    6 +
 Documentation/powerpc/dts-bindings/fsl/board.txt   |    4 +
 Documentation/powerpc/dts-bindings/fsl/mpc5200.txt |   17 +-
 MAINTAINERS                                        |   15 +
 arch/powerpc/Kconfig                               |   49 +-
 arch/powerpc/boot/dts/canyonlands.dts              |    2 +
 arch/powerpc/boot/dts/eiger.dts                    |    6 +
 arch/powerpc/boot/dts/gef_ppc9a.dts                |    6 +
 arch/powerpc/boot/dts/gef_sbc310.dts               |    6 +
 arch/powerpc/boot/dts/gef_sbc610.dts               |    6 +
 arch/powerpc/boot/dts/glacier.dts                  |    6 +
 arch/powerpc/boot/dts/haleakala.dts                |    2 +
 arch/powerpc/boot/dts/katmai.dts                   |   36 +-
 arch/powerpc/boot/dts/kilauea.dts                  |    4 +
 arch/powerpc/boot/dts/kmeter1.dts                  |    7 +
 arch/powerpc/boot/dts/makalu.dts                   |    4 +
 arch/powerpc/boot/dts/mpc832x_mds.dts              |    9 +
 arch/powerpc/boot/dts/mpc832x_rdb.dts              |    9 +
 arch/powerpc/boot/dts/mpc836x_mds.dts              |    9 +
 arch/powerpc/boot/dts/mpc836x_rdk.dts              |    9 +
 arch/powerpc/boot/dts/mpc8568mds.dts               |  119 ++-
 arch/powerpc/boot/dts/mpc8569mds.dts               |  111 +-
 arch/powerpc/boot/dts/mpc8610_hpcd.dts             |   26 +
 arch/powerpc/boot/dts/p1020rdb.dts                 |  477 +++++++
 arch/powerpc/boot/dts/p2020rdb_camp_core0.dts      |  363 +++++
 arch/powerpc/boot/dts/p2020rdb_camp_core1.dts      |  184 +++
 arch/powerpc/boot/dts/p4080ds.dts                  |  554 ++++++++
 arch/powerpc/boot/dts/redwood.dts                  |    1 +
 arch/powerpc/boot/dts/yosemite.dts                 |   14 +-
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |    2 +-
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     |    2 +-
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |    4 +-
 arch/powerpc/include/asm/cpm.h                     |   82 ++
 arch/powerpc/include/asm/cpm1.h                    |   45 -
 arch/powerpc/include/asm/cpm2.h                    |   47 -
 arch/powerpc/include/asm/exception-64s.h           |    2 +
 arch/powerpc/include/asm/hugetlb.h                 |   27 +-
 arch/powerpc/include/asm/hvcall.h                  |   13 +
 arch/powerpc/include/asm/hw_irq.h                  |    5 -
 arch/powerpc/include/asm/immap_cpm2.h              |    2 +-
 arch/powerpc/include/asm/immap_qe.h                |    8 +-
 arch/powerpc/include/asm/irq.h                     |   13 +-
 arch/powerpc/include/asm/kvm.h                     |   18 +
 arch/powerpc/include/asm/kvm_asm.h                 |   40 +
 arch/powerpc/include/asm/kvm_book3s.h              |  139 ++
 arch/powerpc/include/asm/kvm_book3s_64_asm.h       |   58 +
 arch/powerpc/include/asm/kvm_host.h                |   79 +-
 arch/powerpc/include/asm/kvm_ppc.h                 |    1 +
 arch/powerpc/include/asm/lppaca.h                  |    9 +-
 arch/powerpc/include/asm/machdep.h                 |    5 +
 arch/powerpc/include/asm/macio.h                   |    6 +
 arch/powerpc/include/asm/mediabay.h                |   27 +-
 arch/powerpc/include/asm/mmu-hash64.h              |   50 +-
 arch/powerpc/include/asm/mmu_context.h             |    2 +
 arch/powerpc/include/asm/mpc52xx.h                 |   47 +
 arch/powerpc/include/asm/nvram.h                   |    1 -
 arch/powerpc/include/asm/pSeries_reconfig.h        |    1 +
 arch/powerpc/include/asm/paca.h                    |    9 +
 arch/powerpc/include/asm/page.h                    |   14 +
 arch/powerpc/include/asm/page_64.h                 |    2 +-
 arch/powerpc/include/asm/pgalloc-32.h              |   10 +-
 arch/powerpc/include/asm/pgalloc-64.h              |   63 +-
 arch/powerpc/include/asm/pgalloc.h                 |   30 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |   14 +-
 arch/powerpc/include/asm/pgtable.h                 |    3 +
 arch/powerpc/include/asm/pte-8xx.h                 |   14 +-
 arch/powerpc/include/asm/pte-hash64-64k.h          |   37 -
 arch/powerpc/include/asm/qe.h                      |   43 +-
 arch/powerpc/include/asm/systbl.h                  |    2 +-
 arch/powerpc/kernel/Makefile                       |    3 +-
 arch/powerpc/kernel/asm-offsets.c                  |   21 +-
 arch/powerpc/kernel/crash.c                        |    2 +-
 arch/powerpc/kernel/dma-swiotlb.c                  |    1 -
 arch/powerpc/kernel/exceptions-64s.S               |    8 +
 arch/powerpc/kernel/head_64.S                      |    7 +
 arch/powerpc/kernel/head_8xx.S                     |  313 +++--
 arch/powerpc/kernel/head_fsl_booke.S               |   22 -
 arch/powerpc/kernel/io.c                           |    4 +-
 arch/powerpc/kernel/irq.c                          |  137 ++-
 arch/powerpc/kernel/lparcfg.c                      |    4 +-
 arch/powerpc/kernel/misc_32.S                      |   18 -
 arch/powerpc/kernel/nvram_64.c                     |   56 +-
 arch/powerpc/kernel/perf_callchain.c               |   20 +-
 arch/powerpc/kernel/ppc_ksyms.c                    |    3 -
 .../kernel/{proc_ppc64.c => proc_powerpc.c}        |  102 +-
 arch/powerpc/kernel/rtas_flash.c                   |   10 +-
 arch/powerpc/{platforms/pseries => kernel}/rtasd.c |   48 +-
 arch/powerpc/kernel/setup_64.c                     |    5 -
 arch/powerpc/kernel/smp.c                          |    3 +
 arch/powerpc/kernel/sysfs.c                        |   19 +
 arch/powerpc/kernel/time.c                         |    1 +
 arch/powerpc/kernel/traps.c                        |   22 -
 arch/powerpc/kernel/vector.S                       |    2 +-
 arch/powerpc/kvm/Kconfig                           |   17 +
 arch/powerpc/kvm/Makefile                          |   27 +-
 arch/powerpc/kvm/book3s.c                          |  974 +++++++++++++
 arch/powerpc/kvm/book3s_32_mmu.c                   |  372 +++++
 arch/powerpc/kvm/book3s_64_emulate.c               |  345 +++++
 arch/powerpc/kvm/book3s_64_exports.c               |   24 +
 arch/powerpc/kvm/book3s_64_interrupts.S            |  392 ++++++
 arch/powerpc/kvm/book3s_64_mmu.c                   |  478 +++++++
 arch/powerpc/kvm/book3s_64_mmu_host.c              |  408 ++++++
 arch/powerpc/kvm/book3s_64_rmhandlers.S            |  131 ++
 arch/powerpc/kvm/book3s_64_slb.S                   |  262 ++++
 arch/powerpc/kvm/booke.c                           |    5 +
 arch/powerpc/kvm/emulate.c                         |   66 +-
 arch/powerpc/kvm/powerpc.c                         |   28 +-
 arch/powerpc/kvm/timing.c                          |    1 +
 arch/powerpc/kvm/trace.h                           |    6 +-
 arch/powerpc/lib/copy_32.S                         |   24 -
 arch/powerpc/mm/Makefile                           |    5 +-
 arch/powerpc/mm/fault.c                            |    8 +-
 arch/powerpc/mm/fsl_booke_mmu.c                    |  132 +-
 arch/powerpc/mm/gup.c                              |  149 +--
 arch/powerpc/mm/hash_utils_64.c                    |   46 +-
 arch/powerpc/mm/hugetlbpage-hash64.c               |  139 ++
 arch/powerpc/mm/hugetlbpage.c                      |  792 ++++-------
 arch/powerpc/mm/init_64.c                          |   76 +-
 arch/powerpc/mm/mem.c                              |   17 +-
 arch/powerpc/mm/mmu_context_hash64.c               |   26 +-
 arch/powerpc/mm/mmu_decl.h                         |   11 -
 arch/powerpc/mm/pgtable.c                          |   25 +-
 arch/powerpc/mm/subpage-prot.c                     |   15 +-
 arch/powerpc/mm/tlb_hash64.c                       |    8 +-
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c     |    4 +-
 arch/powerpc/platforms/52xx/Kconfig                |    5 +
 arch/powerpc/platforms/52xx/Makefile               |    1 +
 arch/powerpc/platforms/52xx/media5200.c            |    6 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |  432 ++++++-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |  560 ++++++++
 arch/powerpc/platforms/52xx/mpc52xx_pic.c          |   10 +-
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c       |    3 +-
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |    2 +-
 arch/powerpc/platforms/83xx/suspend.c              |    1 +
 arch/powerpc/platforms/85xx/Kconfig                |   23 +-
 arch/powerpc/platforms/85xx/Makefile               |    1 +
 arch/powerpc/platforms/85xx/corenet_ds.c           |  125 ++
 arch/powerpc/platforms/85xx/corenet_ds.h           |   19 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |   34 +-
 arch/powerpc/platforms/85xx/p4080_ds.c             |   74 +
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c    |    6 +-
 arch/powerpc/platforms/86xx/Kconfig                |    3 +
 arch/powerpc/platforms/86xx/gef_pic.c              |    6 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |    5 +
 arch/powerpc/platforms/86xx/gef_sbc310.c           |    5 +
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    5 +
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |   48 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c            |    2 +-
 arch/powerpc/platforms/Kconfig                     |    9 +-
 arch/powerpc/platforms/Kconfig.cputype             |   17 +-
 arch/powerpc/platforms/Makefile                    |    2 +-
 arch/powerpc/platforms/cell/axon_msi.c             |    2 +-
 arch/powerpc/platforms/cell/beat_interrupt.c       |    8 +-
 arch/powerpc/platforms/cell/interrupt.c            |    6 +-
 arch/powerpc/platforms/cell/spider-pic.c           |    8 +-
 arch/powerpc/platforms/cell/spufs/file.c           |    2 +-
 arch/powerpc/platforms/chrp/Kconfig                |    2 +
 arch/powerpc/platforms/chrp/setup.c                |   50 -
 arch/powerpc/platforms/iseries/htab.c              |    8 +-
 arch/powerpc/platforms/iseries/irq.c               |    4 +-
 arch/powerpc/platforms/powermac/pic.c              |   12 +-
 arch/powerpc/platforms/ps3/interrupt.c             |    2 +-
 arch/powerpc/platforms/ps3/mm.c                    |    2 +-
 arch/powerpc/platforms/pseries/Kconfig             |    3 +-
 arch/powerpc/platforms/pseries/Makefile            |    4 +-
 arch/powerpc/platforms/pseries/cmm.c               |   29 +-
 arch/powerpc/platforms/pseries/dlpar.c             |  558 ++++++++
 arch/powerpc/platforms/pseries/eeh_driver.c        |   18 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |  182 +++-
 arch/powerpc/platforms/pseries/offline_states.h    |   18 +
 arch/powerpc/platforms/pseries/plpar_wrappers.h    |   22 +
 arch/powerpc/platforms/pseries/reconfig.c          |    8 +-
 arch/powerpc/platforms/pseries/scanlog.c           |    4 +-
 arch/powerpc/platforms/pseries/smp.c               |   19 +
 arch/powerpc/platforms/pseries/xics.c              |   70 +-
 arch/powerpc/sysdev/Makefile                       |    1 +
 arch/powerpc/sysdev/cpm1.c                         |    4 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |   14 +-
 arch/powerpc/sysdev/cpm_common.c                   |    5 +-
 arch/powerpc/sysdev/fsl_msi.c                      |    4 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   18 +-
 arch/powerpc/sysdev/fsl_pmc.c                      |   88 ++
 arch/powerpc/sysdev/fsl_soc.c                      |    2 +-
 arch/powerpc/sysdev/i8259.c                        |    8 +-
 arch/powerpc/sysdev/ipic.c                         |    8 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                   |    6 +-
 arch/powerpc/sysdev/mpic.c                         |   26 +-
 arch/powerpc/sysdev/mpic_pasemi_msi.c              |    2 +-
 arch/powerpc/sysdev/mpic_u3msi.c                   |    2 +-
 arch/powerpc/sysdev/mv64x60_pic.c                  |    2 +-
 arch/powerpc/sysdev/qe_lib/qe.c                    |   61 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |    8 +-
 arch/powerpc/sysdev/tsi108_pci.c                   |    6 +-
 arch/powerpc/sysdev/uic.c                          |   10 +-
 arch/powerpc/sysdev/xilinx_intc.c                  |    8 +-
 arch/powerpc/xmon/xmon.c                           |    3 +-
 drivers/ata/Kconfig                                |   10 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/pata_macio.c                           | 1427 ++++++++++++++++++++
 drivers/base/cpu.c                                 |   34 +
 drivers/block/swim3.c                              |   39 +-
 drivers/char/agp/uninorth-agp.c                    |   77 +-
 drivers/char/hvc_console.c                         |    1 +
 drivers/ide/pmac.c                                 |   92 +-
 drivers/macintosh/macio_asic.c                     |   52 +
 drivers/macintosh/mediabay.c                       |  328 ++---
 drivers/macintosh/nvram.c                          |   11 +-
 drivers/macintosh/therm_adt746x.c                  |   15 +-
 drivers/macintosh/via-pmu.c                        |  160 ++-
 drivers/macintosh/windfarm_smu_controls.c          |    2 +
 drivers/mmc/host/of_mmc_spi.c                      |    2 +
 drivers/net/ehea/ehea_hcall.h                      |   51 -
 drivers/net/ehea/ehea_phyp.h                       |    1 -
 drivers/of/platform.c                              |  305 ++++-
 drivers/spi/Kconfig                                |   11 +-
 drivers/spi/Makefile                               |    1 +
 drivers/spi/mpc52xx_psc_spi.c                      |   25 +-
 drivers/spi/mpc52xx_spi.c                          |  520 +++++++
 drivers/spi/spi_mpc8xxx.c                          |  618 ++++++++--
 drivers/spi/xilinx_spi.c                           |    3 +-
 drivers/usb/gadget/fsl_qe_udc.h                    |   15 -
 drivers/video/offb.c                               |   15 +-
 drivers/watchdog/Kconfig                           |    4 +-
 drivers/watchdog/Makefile                          |    1 -
 drivers/watchdog/mpc5200_wdt.c                     |  293 ----
 fs/proc/proc_devtree.c                             |   41 +-
 include/linux/cpu.h                                |   15 +
 include/linux/fsl_devices.h                        |   11 +-
 include/linux/kvm.h                                |    1 +
 include/linux/pci_ids.h                            |   14 +
 include/linux/spi/mpc52xx_spi.h                    |   10 +
 virt/kvm/kvm_main.c                                |    5 +-
 234 files changed, 13126 insertions(+), 2713 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/p1020rdb.dts
 create mode 100644 arch/powerpc/boot/dts/p2020rdb_camp_core0.dts
 create mode 100644 arch/powerpc/boot/dts/p2020rdb_camp_core1.dts
 create mode 100644 arch/powerpc/boot/dts/p4080ds.dts
 create mode 100644 arch/powerpc/include/asm/kvm_book3s.h
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_64_asm.h
 rename arch/powerpc/kernel/{proc_ppc64.c => proc_powerpc.c} (87%)
 rename arch/powerpc/{platforms/pseries => kernel}/rtasd.c (95%)
 create mode 100644 arch/powerpc/kvm/book3s.c
 create mode 100644 arch/powerpc/kvm/book3s_32_mmu.c
 create mode 100644 arch/powerpc/kvm/book3s_64_emulate.c
 create mode 100644 arch/powerpc/kvm/book3s_64_exports.c
 create mode 100644 arch/powerpc/kvm/book3s_64_interrupts.S
 create mode 100644 arch/powerpc/kvm/book3s_64_mmu.c
 create mode 100644 arch/powerpc/kvm/book3s_64_mmu_host.c
 create mode 100644 arch/powerpc/kvm/book3s_64_rmhandlers.S
 create mode 100644 arch/powerpc/kvm/book3s_64_slb.S
 create mode 100644 arch/powerpc/mm/hugetlbpage-hash64.c
 create mode 100644 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
 create mode 100644 arch/powerpc/platforms/85xx/corenet_ds.c
 create mode 100644 arch/powerpc/platforms/85xx/corenet_ds.h
 create mode 100644 arch/powerpc/platforms/85xx/p4080_ds.c
 create mode 100644 arch/powerpc/platforms/pseries/dlpar.c
 create mode 100644 arch/powerpc/platforms/pseries/offline_states.h
 create mode 100644 arch/powerpc/sysdev/fsl_pmc.c
 create mode 100644 drivers/ata/pata_macio.c
 delete mode 100644 drivers/net/ehea/ehea_hcall.h
 create mode 100644 drivers/spi/mpc52xx_spi.c
 delete mode 100644 drivers/watchdog/mpc5200_wdt.c
 create mode 100644 include/linux/spi/mpc52xx_spi.h


