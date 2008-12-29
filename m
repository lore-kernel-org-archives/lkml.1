Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYL2AG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYL2AG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYL2AGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:06:48 -0500
Received: from ozlabs.org ([203.10.76.45]:52534 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYL2AGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:06:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18776.5211.191341.999452@cargo.ozlabs.ibm.com>
Date: Mon, 29 Dec 2008 11:05:47 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git next branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'next' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git next

to get a powerpc update.

This has a minor conflict with your tree in drivers/char/Makefile
where two lines were added at the same place; the resolution is to
keep both.  If you prefer me to do the merge, just let me know.

This will also have a conflict with the KVM tree in
arch/powerpc/kvm/powerpc.c.  The resolution is to take the KVM tree's
version of that file.

The change to arch/sparc/include/asm/device.h has been acked by Dave
Miller.

I will be handing over the powerpc maintainership to Ben Herrenschmidt
in the new year.  I'll make a formal announcement about that in a few
days' time.

Thanks,
Paul.

 arch/powerpc/Kconfig                           |   64 ++
 arch/powerpc/Kconfig.debug                     |    9 
 arch/powerpc/Makefile                          |    1 
 arch/powerpc/boot/Makefile                     |    1 
 arch/powerpc/boot/devtree.c                    |    2 
 arch/powerpc/boot/dts/bamboo.dts               |    3 
 arch/powerpc/boot/dts/canyonlands.dts          |   14 
 arch/powerpc/boot/dts/gef_sbc610.dts           |   11 
 arch/powerpc/boot/dts/kuroboxHD.dts            |    1 
 arch/powerpc/boot/dts/kuroboxHG.dts            |    1 
 arch/powerpc/boot/dts/lite5200.dts             |    1 
 arch/powerpc/boot/dts/lite5200b.dts            |    1 
 arch/powerpc/boot/dts/motionpro.dts            |    1 
 arch/powerpc/boot/dts/mpc8315erdb.dts          |    1 
 arch/powerpc/boot/dts/mpc8349emitx.dts         |    1 
 arch/powerpc/boot/dts/mpc8349emitxgp.dts       |    1 
 arch/powerpc/boot/dts/mpc8377_rdb.dts          |    1 
 arch/powerpc/boot/dts/mpc8378_rdb.dts          |    1 
 arch/powerpc/boot/dts/mpc8379_rdb.dts          |    1 
 arch/powerpc/boot/dts/mpc8572ds.dts            |  113 ++++
 arch/powerpc/boot/dts/mpc8572ds_camp_core0.dts |  483 ++++++++++++++++
 arch/powerpc/boot/dts/mpc8572ds_camp_core1.dts |  234 ++++++++
 arch/powerpc/boot/dts/pcm030.dts               |    2 
 arch/powerpc/boot/dts/tqm5200.dts              |    1 
 arch/powerpc/boot/libfdt-wrapper.c             |    2 
 arch/powerpc/configs/86xx/gef_sbc610_defconfig |    8 
 arch/powerpc/configs/ppc44x_defconfig          |   12 
 arch/powerpc/include/asm/atomic.h              |   18 -
 arch/powerpc/include/asm/bug.h                 |   11 
 arch/powerpc/include/asm/byteorder.h           |   38 +
 arch/powerpc/include/asm/cputable.h            |  113 ++--
 arch/powerpc/include/asm/dcr-native.h          |   63 ++
 arch/powerpc/include/asm/dcr.h                 |    4 
 arch/powerpc/include/asm/device.h              |   12 
 arch/powerpc/include/asm/dma-mapping.h         |  156 +++--
 arch/powerpc/include/asm/eeh.h                 |    8 
 arch/powerpc/include/asm/feature-fixups.h      |   30 +
 arch/powerpc/include/asm/highmem.h             |   23 +
 arch/powerpc/include/asm/io.h                  |    7 
 arch/powerpc/include/asm/kdump.h               |   13 
 arch/powerpc/include/asm/kexec.h               |   15 -
 arch/powerpc/include/asm/local.h               |    4 
 arch/powerpc/include/asm/lppaca.h              |    3 
 arch/powerpc/include/asm/mmu-40x.h             |    5 
 arch/powerpc/include/asm/mmu-44x.h             |   22 +
 arch/powerpc/include/asm/mmu-8xx.h             |    3 
 arch/powerpc/include/asm/mmu-fsl-booke.h       |    7 
 arch/powerpc/include/asm/mmu.h                 |   57 ++
 arch/powerpc/include/asm/mmu_context.h         |  257 +--------
 arch/powerpc/include/asm/mpc52xx.h             |   19 +
 arch/powerpc/include/asm/mpc52xx_psc.h         |   11 
 arch/powerpc/include/asm/mutex.h               |  135 ++++-
 arch/powerpc/include/asm/page.h                |   13 
 arch/powerpc/include/asm/page_32.h             |    7 
 arch/powerpc/include/asm/pci-bridge.h          |   30 +
 arch/powerpc/include/asm/pci.h                 |   15 -
 arch/powerpc/include/asm/pgalloc-32.h          |   11 
 arch/powerpc/include/asm/pgalloc-64.h          |   34 -
 arch/powerpc/include/asm/pgalloc.h             |   41 +
 arch/powerpc/include/asm/pgtable-ppc32.h       |   42 +
 arch/powerpc/include/asm/pgtable-ppc64.h       |   15 -
 arch/powerpc/include/asm/pgtable.h             |   26 +
 arch/powerpc/include/asm/ppc_asm.h             |    4 
 arch/powerpc/include/asm/processor.h           |    8 
 arch/powerpc/include/asm/prom.h                |    3 
 arch/powerpc/include/asm/ps3.h                 |   56 +-
 arch/powerpc/include/asm/ps3av.h               |    4 
 arch/powerpc/include/asm/reg.h                 |    4 
 arch/powerpc/include/asm/rtas.h                |    1 
 arch/powerpc/include/asm/sfp-machine.h         |   58 +-
 arch/powerpc/include/asm/smp.h                 |    7 
 arch/powerpc/include/asm/spinlock.h            |    2 
 arch/powerpc/include/asm/synch.h               |    4 
 arch/powerpc/include/asm/system.h              |   24 -
 arch/powerpc/include/asm/time.h                |   20 -
 arch/powerpc/include/asm/tlbflush.h            |   87 +--
 arch/powerpc/include/asm/vdso_datapage.h       |    3 
 arch/powerpc/kernel/Makefile                   |    4 
 arch/powerpc/kernel/asm-offsets.c              |    6 
 arch/powerpc/kernel/cputable.c                 |  117 ++++
 arch/powerpc/kernel/dma.c                      |   26 +
 arch/powerpc/kernel/head_32.S                  |   31 +
 arch/powerpc/kernel/head_44x.S                 |   34 +
 arch/powerpc/kernel/head_fsl_booke.S           |  107 +++-
 arch/powerpc/kernel/ibmebus.c                  |    3 
 arch/powerpc/kernel/machine_kexec.c            |   91 +++
 arch/powerpc/kernel/machine_kexec_64.c         |   78 ---
 arch/powerpc/kernel/misc_32.S                  |  238 --------
 arch/powerpc/kernel/module.c                   |    6 
 arch/powerpc/kernel/of_device.c                |   18 -
 arch/powerpc/kernel/paca.c                     |    1 
 arch/powerpc/kernel/pci-common.c               |  300 ++++++----
 arch/powerpc/kernel/pci_32.c                   |  108 +---
 arch/powerpc/kernel/pci_64.c                   |  134 ++--
 arch/powerpc/kernel/ppc_ksyms.c                |    9 
 arch/powerpc/kernel/ppc_save_regs.S            |    2 
 arch/powerpc/kernel/process.c                  |    4 
 arch/powerpc/kernel/prom.c                     |   47 ++
 arch/powerpc/kernel/prom_parse.c               |    5 
 arch/powerpc/kernel/rtas.c                     |   26 +
 arch/powerpc/kernel/rtas_pci.c                 |   48 --
 arch/powerpc/kernel/setup_32.c                 |   15 -
 arch/powerpc/kernel/setup_64.c                 |    5 
 arch/powerpc/kernel/smp-tbsync.c               |   12 
 arch/powerpc/kernel/smp.c                      |   71 ++
 arch/powerpc/kernel/swsusp.c                   |    2 
 arch/powerpc/kernel/swsusp_32.S                |    6 
 arch/powerpc/kernel/sysfs.c                    |    7 
 arch/powerpc/kernel/time.c                     |   36 -
 arch/powerpc/kernel/traps.c                    |   62 ++
 arch/powerpc/kernel/vdso.c                     |   10 
 arch/powerpc/kernel/vdso32/gettimeofday.S      |  208 ++++---
 arch/powerpc/kernel/vdso32/vdso32.lds.S        |    3 
 arch/powerpc/kernel/vdso64/gettimeofday.S      |  141 +++--
 arch/powerpc/kernel/vdso64/vdso64.lds.S        |    3 
 arch/powerpc/kernel/vio.c                      |   12 
 arch/powerpc/kernel/vmlinux.lds.S              |    6 
 arch/powerpc/kvm/powerpc.c                     |    3 
 arch/powerpc/lib/copyuser_64.S                 |   17 +
 arch/powerpc/lib/dma-noncoherent.c             |   25 -
 arch/powerpc/lib/memcpy_64.S                   |   16 -
 arch/powerpc/math-emu/Makefile                 |    2 
 arch/powerpc/math-emu/fadd.c                   |    1 
 arch/powerpc/math-emu/fcmpo.c                  |    5 
 arch/powerpc/math-emu/fdiv.c                   |    9 
 arch/powerpc/math-emu/fdivs.c                  |    9 
 arch/powerpc/math-emu/fmadd.c                  |    5 
 arch/powerpc/math-emu/fmadds.c                 |    5 
 arch/powerpc/math-emu/fmsub.c                  |    5 
 arch/powerpc/math-emu/fmsubs.c                 |    5 
 arch/powerpc/math-emu/fmul.c                   |    3 
 arch/powerpc/math-emu/fmuls.c                  |    3 
 arch/powerpc/math-emu/fnmadd.c                 |    5 
 arch/powerpc/math-emu/fnmadds.c                |    5 
 arch/powerpc/math-emu/fnmsub.c                 |    5 
 arch/powerpc/math-emu/fnmsubs.c                |    5 
 arch/powerpc/math-emu/fsqrt.c                  |    5 
 arch/powerpc/math-emu/fsqrts.c                 |    5 
 arch/powerpc/math-emu/fsub.c                   |    3 
 arch/powerpc/math-emu/fsubs.c                  |    3 
 arch/powerpc/math-emu/math_efp.c               |  720 ++++++++++++++++++++++++
 arch/powerpc/mm/Makefile                       |   10 
 arch/powerpc/mm/fault.c                        |   14 
 arch/powerpc/mm/hash_low_32.S                  |  111 +++-
 arch/powerpc/mm/hugetlbpage.c                  |   22 -
 arch/powerpc/mm/init_32.c                      |    6 
 arch/powerpc/mm/mem.c                          |    6 
 arch/powerpc/mm/mmu_context_32.c               |   84 ---
 arch/powerpc/mm/mmu_context_hash32.c           |  103 +++
 arch/powerpc/mm/mmu_context_hash64.c           |    8 
 arch/powerpc/mm/mmu_context_nohash.c           |  397 +++++++++++++
 arch/powerpc/mm/mmu_decl.h                     |   65 ++
 arch/powerpc/mm/pgtable.c                      |  117 ++++
 arch/powerpc/mm/pgtable_32.c                   |   56 +-
 arch/powerpc/mm/ppc_mmu_32.c                   |   10 
 arch/powerpc/mm/tlb_hash32.c                   |    4 
 arch/powerpc/mm/tlb_hash64.c                   |   86 ---
 arch/powerpc/mm/tlb_nohash.c                   |  209 +++++++
 arch/powerpc/mm/tlb_nohash_low.S               |  166 ++++++
 arch/powerpc/platforms/40x/ep405.c             |    2 
 arch/powerpc/platforms/40x/kilauea.c           |    2 
 arch/powerpc/platforms/40x/ppc40x_simple.c     |    2 
 arch/powerpc/platforms/44x/ebony.c             |    2 
 arch/powerpc/platforms/44x/ppc44x_simple.c     |    2 
 arch/powerpc/platforms/44x/sam440ep.c          |    2 
 arch/powerpc/platforms/52xx/lite5200_pm.c      |    1 
 arch/powerpc/platforms/52xx/mpc52xx_pci.c      |    2 
 arch/powerpc/platforms/52xx/mpc52xx_pic.c      |  237 ++++++--
 arch/powerpc/platforms/52xx/mpc52xx_pic.h      |   53 --
 arch/powerpc/platforms/52xx/mpc52xx_pm.c       |    3 
 arch/powerpc/platforms/82xx/pq2.c              |    2 
 arch/powerpc/platforms/85xx/Makefile           |    2 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c       |   11 
 arch/powerpc/platforms/85xx/mpc85xx_mds.c      |    8 
 arch/powerpc/platforms/85xx/smp.c              |  104 +++
 arch/powerpc/platforms/86xx/Kconfig            |    2 
 arch/powerpc/platforms/86xx/Makefile           |    3 
 arch/powerpc/platforms/86xx/gef_gpio.c         |  143 +++++
 arch/powerpc/platforms/Kconfig.cputype         |   12 
 arch/powerpc/platforms/cell/Kconfig            |   23 -
 arch/powerpc/platforms/cell/Makefile           |   17 -
 arch/powerpc/platforms/cell/celleb_setup.c     |    9 
 arch/powerpc/platforms/cell/iommu.c            |    5 
 arch/powerpc/platforms/cell/qpace_setup.c      |  152 +++++
 arch/powerpc/platforms/cell/setup.c            |    6 
 arch/powerpc/platforms/cell/spufs/file.c       |   27 -
 arch/powerpc/platforms/chrp/pci.c              |    3 
 arch/powerpc/platforms/embedded6xx/c2k.c       |    6 
 arch/powerpc/platforms/embedded6xx/prpmc2800.c |    6 
 arch/powerpc/platforms/iseries/Kconfig         |    1 
 arch/powerpc/platforms/maple/setup.c           |    6 
 arch/powerpc/platforms/powermac/cpufreq_32.c   |    2 
 arch/powerpc/platforms/powermac/pci.c          |    6 
 arch/powerpc/platforms/powermac/setup.c        |   10 
 arch/powerpc/platforms/powermac/sleep.S        |    5 
 arch/powerpc/platforms/powermac/smp.c          |    2 
 arch/powerpc/platforms/ps3/device-init.c       |   33 +
 arch/powerpc/platforms/ps3/mm.c                |    2 
 arch/powerpc/platforms/ps3/setup.c             |    8 
 arch/powerpc/platforms/ps3/system-bus.c        |   38 +
 arch/powerpc/platforms/pseries/Kconfig         |    2 
 arch/powerpc/platforms/pseries/cmm.c           |   29 +
 arch/powerpc/platforms/pseries/eeh.c           |   44 +
 arch/powerpc/platforms/pseries/hotplug-cpu.c   |    2 
 arch/powerpc/platforms/pseries/pci_dlpar.c     |  163 +++--
 arch/powerpc/platforms/pseries/phyp_dump.c     |    5 
 arch/powerpc/platforms/pseries/xics.c          |   43 +
 arch/powerpc/sysdev/bestcomm/ata.c             |    3 
 arch/powerpc/sysdev/bestcomm/ata.h             |   19 -
 arch/powerpc/sysdev/bestcomm/bestcomm.c        |    7 
 arch/powerpc/sysdev/bestcomm/bestcomm.h        |   61 +-
 arch/powerpc/sysdev/bestcomm/bestcomm_priv.h   |   20 +
 arch/powerpc/sysdev/dcr-low.S                  |    8 
 arch/powerpc/sysdev/dcr.c                      |    5 
 arch/powerpc/sysdev/fsl_pci.c                  |    4 
 arch/powerpc/sysdev/grackle.c                  |    2 
 arch/powerpc/sysdev/mpic.c                     |   32 -
 arch/powerpc/sysdev/ppc4xx_pci.c               |  306 +++++++---
 arch/powerpc/sysdev/qe_lib/qe.c                |    3 
 arch/powerpc/sysdev/qe_lib/ucc.c               |    4 
 arch/powerpc/xmon/Makefile                     |    2 
 arch/powerpc/xmon/xmon.c                       |    5 
 arch/sparc/include/asm/device.h                |   12 
 drivers/ata/Kconfig                            |    3 
 drivers/ata/pata_mpc52xx.c                     |  546 ++++++++++++++++--
 drivers/char/Kconfig                           |    6 
 drivers/char/Makefile                          |    1 
 drivers/char/bsr.c                             |   84 ++-
 drivers/char/hvc_console.c                     |   13 
 drivers/char/hvc_console.h                     |    2 
 drivers/char/hvc_iseries.c                     |    4 
 drivers/char/hvc_udbg.c                        |   96 +++
 drivers/char/hvc_vio.c                         |    4 
 drivers/char/hvcs.c                            |    2 
 drivers/char/hvsi.c                            |    2 
 drivers/edac/Kconfig                           |    2 
 drivers/macintosh/via-pmu.c                    |    4 
 drivers/macintosh/windfarm_smu_sat.c           |    5 
 drivers/net/fec_mpc52xx_phy.c                  |    5 
 drivers/of/base.c                              |   68 ++
 drivers/of/gpio.c                              |   70 ++
 drivers/of/of_i2c.c                            |   11 
 drivers/pci/hotplug/rpadlpar_core.c            |   69 +-
 drivers/ps3/ps3av.c                            |   20 -
 drivers/ps3/ps3av_cmd.c                        |    4 
 drivers/rapidio/rio-scan.c                     |    8 
 drivers/serial/mpc52xx_uart.c                  |   74 ++
 drivers/serial/pmac_zilog.c                    |   27 +
 drivers/video/controlfb.c                      |    4 
 drivers/video/ps3fb.c                          |   23 -
 fs/proc/proc_devtree.c                         |    3 
 include/linux/of.h                             |    6 
 include/linux/of_gpio.h                        |   44 +
 include/linux/rio_drv.h                        |    4 
 254 files changed, 7138 insertions(+), 2728 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/mpc8572ds_camp_core0.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8572ds_camp_core1.dts
 rename arch/powerpc/{xmon/setjmp.S => kernel/ppc_save_regs.S} (98%)
 create mode 100644 arch/powerpc/math-emu/math_efp.c
 delete mode 100644 arch/powerpc/mm/mmu_context_32.c
 create mode 100644 arch/powerpc/mm/mmu_context_hash32.c
 rename arch/powerpc/mm/{mmu_context_64.c => mmu_context_hash64.c} (86%)
 create mode 100644 arch/powerpc/mm/mmu_context_nohash.c
 create mode 100644 arch/powerpc/mm/pgtable.c
 rename arch/powerpc/mm/{tlb_32.c => tlb_hash32.c} (97%)
 rename arch/powerpc/mm/{tlb_64.c => tlb_hash64.c} (75%)
 create mode 100644 arch/powerpc/mm/tlb_nohash.c
 create mode 100644 arch/powerpc/mm/tlb_nohash_low.S
 delete mode 100644 arch/powerpc/platforms/52xx/mpc52xx_pic.h
 create mode 100644 arch/powerpc/platforms/85xx/smp.c
 create mode 100644 arch/powerpc/platforms/86xx/gef_gpio.c
 create mode 100644 arch/powerpc/platforms/cell/qpace_setup.c
 create mode 100644 drivers/char/hvc_udbg.c

Anton Vorontsov (14):
      powerpc: Remove device_type = "rtc" properties in .dts files
      powerpc and sparc: Introduce dev_archdata node accessors
      of/i2c: Fill the archdata for I2C devices
      of/gpio: Implement of_get_gpio_flags()
      powerpc/qe: Move cmxgcr_lock definition from the ucc.c into the qe.c
      powerpc: Remove `have_of' global variable
      of: Minor simplification for the of_parse_phandles_with_args()
      of: of_parse_phandles_with_args() learns to differentiate 'hole' cells
      of/gpio: Implement of_gpio_count()
      powerpc: Make default kexec/crash_kernel ops implicit
      powerpc: Remove default kexec/crash_kernel ops assignments
      powerpc: Prepare xmon_save_regs for use with kdump
      powerpc/32/kdump: Implement crash_setup_regs() using ppc_save_regs()
      powerpc/32: Allow __ioremap on RAM addresses for kdump kernel

Arnd Bergmann (1):
      powerpc/cell: fix build breakage with CONFIG_SPUFS disabled

Becky Bruce (2):
      powerpc: Add sync_*_for_* to dma_ops
      powerpc: Fix !CONFIG_PPC_NEED_DMA_SYNC_OPS build warning

Benjamin Herrenschmidt (28):
      powerpc: Fix domain numbers in /proc on 64-bit
      powerpc: Silence software timebase sync
      powerpc/pci: Cleanup debug printk's
      powerpc/pci: Use common PHB resource hookup
      powerpc/pci: Remove pcibios_do_bus_setup()
      powerpc/pci: Split pcibios_fixup_bus() into bus setup and device setup
      powerpc/eeh: Make EEH device add/remove more robust
      powerpc/pci: Make pcibios_allocate_bus_resources more robust
      powerpc/pci: Fix various pseries PCI hotplug issues
      powerpc/pci: Cosmetic cleanups of pci-common.c
      powerpc: Fix ppc32 mm_struct CPU tracking in SMP
      powerpc/4xx: Add support for ISA holes on 4xx PCI/X/E
      powerpc: Fix bogus cache flushing on all 40x and BookE processors v2
      powerpc: Fix asm EMIT_BUG_ENTRY with !CONFIG_BUG
      powerpc/mm: Add local_flush_tlb_mm() to SW loaded TLB implementations
      powerpc/mm: Rename tlb_32.c and tlb_64.c to tlb_hash32.c and tlb_hash64.c
      powerpc/mm: Remove flush_HPTE()
      powerpc/4xx: Extended DCR support v2
      powerpc/mm: Split mmu_context handling
      powerpc/mm: Rework context management for CPUs with no hash table
      powerpc/mm: Introduce MMU features
      powerpc/mm: Add SMP support to no-hash TLB handling
      powerpc/mm: Split low level tlb invalidate for nohash processors
      powerpc/44x: No need to mask MSR:CE, ME or DE in _tlbil_va on 440
      powerpc/mm: Runtime allocation of mmu context maps for nohash CPUs
      powerpc/mm: Rework usage of _PAGE_COHERENT/NO_CACHE/GUARDED
      powerpc/44x: 44x TLB doesn't need "Guarded" set for all pages
      powerpc: Fix missing 'blr' in _tlbia()

Benjamin Krill (1):
      powerpc/cell: add QPACE as a separate Cell platform

Brian King (3):
      powerpc: Update page-in counter for CMM
      powerpc: Disable Collaborative Memory Manager for kdump
      powerpc: Add reboot notifier to Collaborative Memory Manager

Chris J Arges (1):
      serial/pmac_zilog: Add console polling support

Dale Farnsworth (4):
      powerpc: Setup OF properties for ppc32 kexec
      powerpc/32: Setup OF properties for kdump
      powerpc/32: Add the ability for a classic ppc kernel to be loaded at 32M
      powerpc/32: Wire up the trampoline code for kdump

David Gibson (1):
      powerpc: udbg-based backend for hvc_console

David Howells (1):
      powerpc: Rename struct vm_region to avoid conflict with NOMMU

FUJITA Tomonori (1):
      powerpc: Remove dead BIO_VMERGE_BOUNDARY definition

Geert Uytterhoeven (2):
      powerpc/ps3: Replace the flip_ctl logic in ps3av and ps3fb by a mutex
      powerpc/ps3: Add sub-match id modalias support

Geoff Levand (2):
      powerpc: Fix typo in pgtable-ppc64.h
      powerpc/ps3: Quiet dmesg output

Grant Erickson (1):
      powerpc: Const-qualify Device Node Argument to DCR Resource Extent API

Grant Likely (4):
      powerpc/mpc5200: Document and tidy irq driver
      powerpc/mpc5200: Make internal 5200 PIC the default interrupt controller
      powerpc/mpc5200: Bugfix on handling variable sized buffer descriptors
      powerpc/mpc5200: Disable bestcomm prefetching when ATA DMA enabled

Haiying Wang (3):
      powerpc/85xx: Add localbus node in mpc8572ds dts file
      powerpc/85xx: Don't reset the MPIC for CAMP mode on MPC8572DS
      powerpc/85xx: Create dts for each core in CAMP mode for MPC8572DS

Harvey Harrison (1):
      powerpc: Use the new byteorder headers

Hendrik Brueckner (2):
      hvc_console: Always schedule resize work on resize
      hvc_console: Escape magic sysrq key

Hollis Blanchard (3):
      powerpc: Remove superfluous WARN_ON() from dma-noncoherent.c
      powerpc/kvm: update KVM config options in ppc44x_defconfig
      powerpc: Force memory size to be a multiple of PAGE_SIZE

Ilya Yanok (1):
      powerpc/44x: Support 16K/64K base page sizes on 44x

Johannes Berg (1):
      powerpc: Allow the max stack trace depth to be configured

Jon Tollefson (1):
      powerpc: Hugetlb pgtable cache access cleanup

Josh Boyer (1):
      powerpc: Introduce ppc_pci_flags accessors

Julia Lawall (1):
      powerpc: Eliminate NULL test and memset after alloc_bootmem

Kay Sievers (2):
      powerpc: struct device - replace bus_id with dev_name(), dev_set_name()
      rapidio: struct device - replace bus_id with dev_name(), dev_set_name()

Kumar Gala (9):
      powerpc: Add MSR[CE, DE] to the MSR bits we print on show_regs()
      powerpc: hash_page_sync should only be used on SMP & STD_MMU_32
      powerpc: Add a local_flush_tlb_page to handle kmap_atomic invalidates
      powerpc: Use RCU based pte freeing mechanism for all powerpc
      powerpc: Remove unncessary SPE related compiler flag
      powerpc/85xx: minor head_fsl_booke.S cleanup
      powerpc/85xx: Add support for SMP initialization
      powerpc/85xx: Fix compile warnings in mpc85xx_mds.c
      powerpc/85xx: Fix compile issues with mpc8572ds.dts

Liu Yu (4):
      powerpc/math-emu: Fix single float point division bug
      powerpc/math-emu: Adopt new version of _FP_CHOOSENAN
      powerpc/math-emu: Remove redundant 'ret'
      powerpc: Add SPE/EFP math emulation for E500v1/v2 processors.

Mark Nelson (4):
      powerpc: Add new CPU feature: CPU_FTR_UNALIGNED_LD_STD
      powerpc: Update 64bit memcpy() using CPU_FTR_UNALIGNED_LD_STD
      powerpc: Remove map_/unmap_single() from dma_mapping_ops
      powerpc: Update 64bit __copy_tofrom_user() using CPU_FTR_UNALIGNED_LD_STD

Martyn Welch (2):
      powerpc/86xx: Add use of Epson RTX-8581 RTC to GE Fanuc SBC610 dts
      powerpc/86xx: Basic GPIO support for GE Fanuc SBC610

Masakazu Mokuno (1):
      powerpc/ps3: Fix memory leak in device init

Michael Ellerman (4):
      of: Add helpers for finding device nodes which have a given property
      powerpc: Use for_each_node_with_property() in of_irq_map_init()
      powerpc: Use of_find_node_with_property() in cell_iommu_fixed_mapping_init()
      powerpc/pmac: Use of_find_node_with_property() in pmac_setup_arch()

Milton Miller (2):
      powerpc: Provide a separate handler for each IPI action
      powerpc/mpic: Use new smp_request_message_ipi

Nathan Lynch (6):
      powerpc: Move smp_hw_index to 32-bit code
      powerpc/powermac: Use set_hard_smp_processor_id() instead of smp_hw_index
      powerpc/pseries: Check for GIQ indicator before calling set-indicator
      powerpc: Add of_find_next_cache_node()
      powerpc: Convert cpu_to_l2cache() to of_find_next_cache_node()
      powerpc: Convert sysfs cache code to of_find_next_cache_node()

Nick Piggin (3):
      powerpc: Optimise smp_wmb
      powerpc: Optimise smp_rmb
      powerpc: Optimise mutex

Nicolas Palix (2):
      drivers/hvc: Add missing of_node_put
      powerpc/chrp: Add missing of_node_put in pci.c

Paul Mackerras (4):
      powerpc: Improve resolution of VDSO clock_gettime
      powerpc: Eliminate unused do_gtod variable
      powerpc: Tell gcc when we clobber the carry in inline asm
      powerpc: Fix KVM build on ppc440

René Bürgel (1):
      powerpc/mpc5200: Make PSC UART driver update serial errors counters

Robert Jennings (1):
      powerpc: Correct page-in counter for CMM with 64k pages

Scott Wood (1):
      powerpc/bootwrapper: Use the child-bus #address-cells to decide which range entry to use

Sebastian Siewior (1):
      powerpc/boot: Allocate more memory for dtb

Sebastien Dugue (3):
      powerpc/pseries: Fix getting the server number size
      powerpc/ibmebus: Get rid of the IRQ mapping in ibmebus_free_irq()
      powerpc/pseries: Fix cpu hotplug

Sonny Rao (1):
      powerpc/BSR: Support multiple OF-node description of BSR

Stefan Roese (1):
      powerpc/4xx: Add L2 cache node to AMCC Canyonlands dts file

Stephen Rothwell (2):
      powerpc/44x: update ppc44x_defconfig
      powerpc/iseries: viodasd needs to depend on CONFIG_BLOCK

Tim Yamin (2):
      powerpc/mpc5200: Bestcomm fixes to ATA support
      powerpc/mpc5200: Add MDMA/UDMA support to MPC5200 ATA driver

Tony Breeds (2):
      powerpc: Protect against NULL pointer deref in phyp-dump code
      powerpc: Pass a valid token to rtas_call() in phyp-dump code

Trent Piepho (1):
      powerpc: Better setup of boot page TLB entry

Wolfram Sang (3):
      powerpc/mpc5200: Remove obsolete code from mpc5200 MDIO driver
      powerpc/mpc5200: add rts/cts handling in PSC UART driver
      powerpc/mpc5200: fix error paths in PSC UART probe function

roel kluin (2):
      powerpc/macintosh: Fix unsigned check in smu_sat_get_sdb_partition()
      powerpc: Make open count variables signed in hvcs/hvsi/hvc_console

