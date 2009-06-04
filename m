Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZFDM3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZFDM3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZFDM3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:29:15 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35262 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZFDM3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:29:12 -0400
Date: Thu, 4 Jun 2009 21:28:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: What's in sh-2.6.git for 2.6.31?
Message-ID: <20090604122842.GA17339@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a summary of the stuff in the queue for 2.6.31.

Primary features of note in no sort of coherent order:

	- Switch to generic time (including TMU and MTU2).
	- New CPU support (SH7724 (SH-Mobile R2R)).
	- New board support (Solution Engine 7724).
	- earlytimer support
	- power management improvements
	- clock framework rework and support for SH7785
	- Removal of old pci-auto code and general PCI work.
	- sparseirq support
	- ptrace fixups for nommu
	- .. and some _64/_32 consolidation for good measure.

Most of the churn is in the PCI and clock framework bits, which has
consolidated a lot of code, and sorted out a number of long-standing
issues between 29/32-bit phys mappings.

As usual, the tree is at:

        git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git

and contains:

Jean-Christophe PLAGNIOL-VILLARD (1):
      sh: mach-r2d: add physmap-flash support for R2D+ boards.

John Stultz (2):
      timekeeping: create arch_gettimeoffset infrastructure
      time: sh: convert to use arch_getoffset() infrastructure

Kieran Bingham (2):
      sh: Add in some ptrace definitions from GDB.
      sh: Fix UBC setup and registers for SH2A

Kuninori Morimoto (12):
      sh: Add support for SH7724 (SH-Mobile R2R) CPU subtype.
      serial: sh-sci: SH7724 support.
      sh: sh7724: Add I2C support.
      sh: sh7724: Add VPU support.
      sh: sh7724: Add VEU support.
      sh: Add ms7724se (SH7724) board support
      sh: SH7724 has an L2 cache.
      sh: fix CONFIG_SH_PCLK_FREQ bug for sh7724
      sh: add RAMCR definition for sh4
      sh: add weak l2_cache_init function.
      sh: sh7724: L2 cache initialization.
      sh: sh7723: L2 cache initialization.

Magnus Damm (79):
      sh: pass along struct pci_channel
      sh: add init member to pci_channel data
      sh: avoid using PCIBIOS_MIN_xxx
      sh: hook in struct pci_channel in sysdata
      sh: add reg_base member to pci_channel
      sh: add io_base member to pci_channel
      sh: pci memory range checking code
      sh: pci io port base address code
      sh: export board_pci_channels in one place
      clocksource: sh_cmt earlytimer support
      sh: arch earlytimer support
      sh: Add plat_early_device_setup()
      sh: Early Platform Data for SuperH Mobile
      clocksource: sh_cmt clocksource support
      clocksource: improve sh_cmt clocksource overflow handling
      sh: setup timers in late_time_init()
      sh: pass through ioremap() for non-mmu processors.
      clocksource: sh_cmt 16-bit fixes
      sh: sh2/sh2a 16-bit CMT platform data
      sh: remove old CMT driver
      clocksource: setup mult_orig in clocksource_enable()
      clocksource: SuperH MTU2 Timer driver
      sh: sh2a MTU2 platform data
      sh: remove old MTU2 driver
      clocksource: SuperH TMU Timer driver
      sh: TMU platform data for sh7722
      sh: sh7785 early scif fix
      sh: call clock framework init() callback once
      sh: r7785 highlander clock fixes
      sh: TMU platform data for sh7785
      sh: clock framework update, fix count and kill off kref
      sh: enable TMU clocksource on sh7722
      sh: TMU platform data for sh7723
      sh-sci: add platform device private data
      sh-sci: remove early_sci_setup()
      sh-sci: rework serial console support
      sh-sci: use to_sci_port() if possible
      sh-sci: allow single port platform devices
      sh-sci: replace sci_init_ports()
      sh-sci: ioremap() in a single place
      sh-sci: improve clock framework support
      sh: include empty_zero_page in text
      sh: TMU platform data for sh775x
      sh: TMU platform data for sh7760
      sh: multiple vectors per irq - sh7760
      sh: r7780 highlander clock fixes
      sh: TMU platform data for sh7780
      sh: TMU platform data for sh7763
      sh: add sh7770_generic_defconfig
      sh: TMU platform data for sh7770
      sh: TMU platform data for sh4-202
      sh: add sh4-202 INTC tables
      sh: TMU platform data for sh7343
      sh: TMU platform data for sh7366
      sh: TMU platform data for sh7724
      sh: TMU platform data for sh7705
      sh: TMU platform data for sh7706/sh7707/sh7708/sh7709
      sh: TMU platform data for sh7710/sh7712
      sh: TMU platform data for sh7720/sh7721
      sh: CMT platform data for sh7720/sh7721
      sh: remove old TMU driver
      sh: intc tables for sh7770
      sound: oss: sh_dac_audio timer fixes.
      sh: clkfwk branch compile fix for clock-sh7722
      sh: ap325 camera without i2c driver fix
      video: stop sh_mobile_lcdcfb only if started
      sh: add pll_clk to sh7785
      sh: add shared clock framework frequency table code
      sh: use shared frequency tables on sh7785
      sh: remove clk_ops->build_rate_table()
      sh: boot word / mode pin support V2
      sh: sh7785 mode pin definitions
      sh: sh7785lcr mode pin configuration
      sh: sh7785 pll configuration from mode pin
      sh: shared mstp32 clock code
      sh: hook up shared mstp32 clock code to sh7785
      sh: shared div4 clock code
      sh: hook up shared div4 clock code to sh7785
      sh: 16-bit get_unaligned() sh4a fix

Paul Mundt (143):
      sh: sh7724: Add CMT clockevents support.
      sh: Have SH7724 select ARCH_SHMOBILE.
      sh: Add a generic defconfig for SH7724 platforms.
      sh: drop duplicate symbol export on dreamcast and sh7785lcr.
      sh: sh7785lcr: Update for recent PCI changes.
      sh: pci: drop duplicate PCIC fixups for SE7780 and SH7785LCR.
      sh: pci: Kill off unused SH4_PCIC_NO_RESET code.
      sh: pci: Kill off useless debugging printk() in pci-sh7780 init.
      sh: pci: Move se7780 INTC fixups out of pci-sh7780.c.
      sh: pci: Prefer P1SEG over P1SEGADDR for CONFIG_CMD.
      sh: pci: Set class/sub-class code correctly for SH7780 PCIC.
      sh: pci: Rework SH7780 host controller detection.
      sh: pci: Use the proper write size for class/sub-class code.
      sh: pci: Set pci_cache_line_size on SH7780 via the PCICLS register.
      sh: pci: Set the I/O port base to the SH7780 I/O window default.
      sh: pci: Consolidate PCI I/O and mem window definitions for SH7780.
      sh: pci: Kill off platform-specific multi-window mappings.
      sh: pci: Consolidate SH7780 PCIC IRQ routing.
      sh: pci: Start unifying the SH7780 PCIC initialization.
      sh: sh7724: Don't default enable the RTC clock.
      sh: sh7724: Register CMT as an early platform device here too.
      sh: pci: Drop asm-generic/pci.h, so we can use our own fixups.
      sh: pci: Split out new-style PCI core.
      sh: pci: HAVE_PCI_MMAP support.
      sh: pci: Consolidate pcibios_align_resource() definitions.
      sh: pci: Kill off unused pcibios_fixup().
      sh: pci: Consolidate pci_iomap() and use the generic I/O base.
      sh: pci: Rework fixed region checks in ioremap().
      sh: pci: New-style controller registration.
      sh: pci: Track io and mem_offset per-channel.
      sh: pci: Consolidate bus<->resource mapping in pci-lib.
      sh: pci: Consolidate the remaining common bits.
      sh: pci: Kill off the now unused hose->io_base.
      sh: pci: Kill off superfluous lboxre2 pci fixups.
      sh: pci: Flag the dreamcast BBA as IORESOURCE_PCI_FIXED.
      sh: pci: Kill off dead references to is_pci_ioaddr and friends.
      sh: pci: Consolidate pcibios_setup() in pci-lib.
      sh: pci: Kill off legacy ide quirks.
      sh: pci: Tidy up the dreamcast PCI support.
      sh: pci: Convert the SH-5 code over to the new interface.
      sh: pci: Rename ops-cayman -> fixups-cayman.
      sh: pci: Rewrite SH7751 PCI support to follow SH7780.
      sh: pci: Rename SH7751 platform ops files to fixups.
      sh: pci: Consolidate lboxre2 and r2d IRQ fixups.
      sh: pci: Convert dreamcast to new-style interface.
      sh: pci: Move the se7751 fixups in to arch/sh/drivers/pci/.
      sh: pci: Kill off the last remnants of the now unused pci-auto code.
      sh: pci: Roll pci-lib in to pci-new.
      sh: pci: Rename pci-new.c to pci.c.
      sh: pci: Fix up the build for CONFIG_PCI=n.
      sh: update defconfigs for PCI changes.
      sh: select GENERIC_TIME for new CMT driver.
      sh: rtc-generic support.
      sh: register the rtc-generic platform device properly.
      sh: Consolidate MTU2/CMT/TMU timer platform data.
      clocksource: sh_mtu2/cmt_register() should be static.
      sh: select both GENERIC_TIME and GENERIC_CLOCKEVENTS.
      sh: Kill off the now unused ARCH_USES_GETTIMEOFFSET code.
      sh: Move dummy clockevents broadcast timer to its new home.
      sh: Flag IRQSTACKS as BROKEN for now.
      sh: Handle shm_align_mask also for HAVE_ARCH_UNMAPPED_AREA_TOPDOWN.
      sh: sh64 still needs ARCH_USES_GETTIMEOFFSET temporarily.
      sh: Integrate the SH-5 onchip_remap() more coherently.
      sh: Kill off unused SH-5 irq_describe cruft.
      sh: Enable new TMU driver support for all SH-3 and SH-4 CPUs.
      sh: Move out rtc-sh registration from time_64.c to setup-sh5.c
      sh: Finish the sh64 migration off of ARCH_USES_GETTIMEOFFSET.
      sh: Rename arch/sh/kernel/time_32.c to arch/sh/kernel/time.c.
      sh: Wire up GENERIC_CMOS_UPDATE for the platforms that need it.
      sh: Kill off dead handle_timer_tick() code.
      sh: Kill off dead timer sysclass pm hooks.
      sh: mach-sh03: Give the sh03 rtc its own spinlock.
      sh: Kill off the global rtc_lock with extreme prejudice.
      sh: Kill off sh64's hand-rolled syscall tracer.
      sh: Kill off unused sh64 debug code.
      sh: Move out cayman-specific panic handler code to its own file.
      sh: Drop dead rules from arch/sh/kernel/Makefile_64.
      sh: Always select RTC_LIB, not just for SUPERH32.
      sh: Kill off extra cflags Kconfig entry.
      sh: Always fixup unaligned userspace accesses on sh64.
      sh: TMU platform data for SH7786.
      sh: TMU platform data for SH-X3 proto CPU.
      sh: Kill off the GENERIC_CALIBRATE_DELAY ifndef.
      sh: Add clock id to sh-sci platform data on SH-Mobile CPUs.
      serial: sh-sci: Fix up section mismatch in error path.
      sh: Fix up the sh64 earlyprintk build.
      sh: Cleanup irqflags size mismatch on SH-5 build.
      sh: Provide __read_{read,write}sl() definitions for sh64.
      sh: Rename opcode_t to insn_size_t.
      sh: Provide an __sdivsi3_2 export for sh64.
      sh: Fix up SHmedia module ELF relocations.
      sh: Integrate sh64 bits in vmlinux_32.lds.S.
      sh: Move the unified linker script in place, kill off old _64 one.
      sh: Tidy up the ldscript output format specifier.
      sh: Fix up the sh64 zImage build.
      sh: Provide a tighter BOOT_LINK_OFFSET definition for the Cayman board.
      sh: Provide a BITS definition, use it in the arch/sh/boot/ Makefiles.
      sh: Merge the split arch/sh/boot/compressed/ Makefiles.
      sh: Consolidate the boot link and entry offset definitions.
      sh: Hook up cc-cross-prefix support.
      sh: Fix up R0 dependence in __arch_swab16/32.
      sh: Fix up typo in arch/sh/kernel/vmlinux.lds.S
      sh: Account for INITIAL_JIFFIES when using jiffies clocksource.
      sh: clkfwk: Make recalc return an unsigned long.
      sh: clkfwk: Add a followparent_recalc() helper.
      sh: clkfwk: refactor rate propagation.
      sh: clkfwk: Consolidate the ALWAYS_ENABLED / NEEDS_INIT mess.
      sh: clkfwk: Convert SH-Mobile CPUs to use CLK_ENABLE_ON_INIT.
      sh: clkfwk: Fix up the clk_enable() error path.
      sh: clkfwk: Improve the generic clk_set_parent() implementation.
      sh: clkfwk: Tidy up on-chip clock registration and rate propagation.
      sh: clkfwk: Kill off clk_recalc_rate().
      sh: clkfwk: Wire up clk_get_sys() support.
      sh: clkfwk: Handle clk_get_sys() returning an ERR_PTR.
      sh: clkfwk: Use arch_clk_init() for on-chip clock registration.
      sh: Kill off the remnants of the old timer code.
      sh: clkfwk: module_clk -> peripheral_clk rename.
      sh: clkfwk: Handle NULL clkops for root clocks.
      sh: clkfwk: Provide a generic clk_set_rate_ex() path for root clocks.
      sh: clkfwk: Rework legacy CPG clock handling.
      sh: clkfwk: Update SH7785 for refactored clock framework.
      sh: clkfwk: rate table construction and rounding for SH7785.
      sh: clkfwk: Map tree hierarchy in debugfs.
      sh: clkfwk: Add MSTP bits to SH7785 clock framework.
      sh: Provide FORCE_MAX_ZONEORDER.
      sh: hd64461: Fix up I/O base register offsets.
      sh: mach-hp6xx: Fix up the hp6xx build for hd64461 changes.
      sh: irq: Rework the SR.IMASK bitmap handling.
      sh: irq: Convert from irq_desc[] to irq_to_desc().
      sh: irq: Teach ipr and intc about dynamically allocating irq_descs.
      sh: irq: Provide an arch_probe_nr_irqs() that wraps the machvec def.
      sh: Wrap irq_to_desc_alloc_cpu() around CONFIG_SPARSE_IRQ temporarily.
      sh: Add a NR_IRQS_LEGACY for external IRQ0-7.
      sh: clkfwk: Make clock-cpg usable for non-legacy platforms.
      sh: Prefer slab_is_available() over after_bootmem.
      sh: irq: Fix up imask build warnings.
      sh: Record ms7724se in mach-types.
      sh: Add a KBUILD_DEFCONFIG for sh64.
      sh: pci-sh7751: Initialize io_map_base in controller definition.
      sh: pci: Disable MWI and make pci_dma_burst_advice() a bit more accurate.
      sh: pci-sh7780: Fix up for PCI_DISABLE_MWI changes.
      sh: Tidy up the optional L2 probing, wire it up for SH7786.
      sh: Tidy up SH-4A boot_cpu_data.flags probing.

Peter Griffin (2):
      sh: Add ptrace support for NOMMU debugging
      sh: Add UBC trap vector for SH2A

Roel Kluin (1):
      sh: clkfwk: beyond ARRAY_SIZE of onchip_ops for sh7722.

SUGIOKA Toshinobu (1):
      serial: sh-sci: Fix up PORT_SCI console output ordering.

Thomas Gleixner (2):
      sh: remove obsolete no_irq_type
      sh: remove obsolete hw_interrupt_type

Yoshihiro Shimoda (1):
      sh: sh7785lcr: fix I2C device address map for 32-bit mode

Yoshinori Sato (1):
      serial: sh-sci: Fix up h8300 support.

 arch/sh/Kconfig                                    |  114 +-
 arch/sh/Kconfig.cpu                                |    8 -
 arch/sh/Kconfig.debug                              |   23 +-
 arch/sh/Makefile                                   |   72 +-
 arch/sh/boards/Kconfig                             |   15 +-
 arch/sh/boards/board-ap325rxa.c                    |    3 +
 arch/sh/boards/board-sh7785lcr.c                   |   44 +-
 arch/sh/boards/mach-cayman/Makefile                |    2 +-
 arch/sh/boards/mach-cayman/irq.c                   |   17 +-
 arch/sh/boards/mach-cayman/panic.c                 |   49 +
 arch/sh/boards/mach-cayman/setup.c                 |    2 +-
 arch/sh/boards/mach-dreamcast/setup.c              |    6 -
 arch/sh/boards/mach-r2d/setup.c                    |   50 +
 arch/sh/boards/mach-se/7724/Makefile               |   10 +
 arch/sh/boards/mach-se/7724/irq.c                  |  139 ++
 arch/sh/boards/mach-se/7724/setup.c                |  448 ++++
 arch/sh/boards/mach-se/7751/Makefile               |    2 -
 arch/sh/boards/mach-se/7751/io.c                   |   16 -
 arch/sh/boards/mach-se/7751/pci.c                  |  147 --
 arch/sh/boards/mach-se/7780/irq.c                  |   27 +-
 arch/sh/boards/mach-se/Makefile                    |    1 +
 arch/sh/boards/mach-sh03/rtc.c                     |   10 +-
 arch/sh/boards/mach-snapgear/io.c                  |   16 -
 arch/sh/boards/mach-systemh/io.c                   |   16 -
 arch/sh/boards/mach-titan/io.c                     |   20 +-
 arch/sh/boot/Makefile                              |    6 +-
 arch/sh/boot/compressed/Makefile                   |   50 +-
 arch/sh/boot/compressed/Makefile_32                |   46 -
 arch/sh/boot/compressed/Makefile_64                |   43 -
 arch/sh/boot/compressed/head_64.S                  |    5 +-
 arch/sh/boot/compressed/vmlinux_64.lds             |   64 -
 arch/sh/cchips/Kconfig                             |    5 -
 arch/sh/cchips/hd6446x/hd64461.c                   |    2 +-
 arch/sh/configs/ap325rxa_defconfig                 |   37 +-
 arch/sh/configs/cayman_defconfig                   |   71 +-
 arch/sh/configs/dreamcast_defconfig                |   39 +-
 arch/sh/configs/edosk7705_defconfig                |   29 +-
 arch/sh/configs/edosk7760_defconfig                |   32 +-
 arch/sh/configs/espt_defconfig                     |   39 +-
 arch/sh/configs/hp6xx_defconfig                    |   35 +-
 arch/sh/configs/landisk_defconfig                  |   48 +-
 arch/sh/configs/lboxre2_defconfig                  |   44 +-
 arch/sh/configs/magicpanelr2_defconfig             |   30 +-
 arch/sh/configs/microdev_defconfig                 |   36 +-
 arch/sh/configs/migor_defconfig                    |   36 +-
 arch/sh/configs/polaris_defconfig                  |   30 +-
 arch/sh/configs/r7780mp_defconfig                  |   38 +-
 arch/sh/configs/r7785rp_defconfig                  |   38 +-
 arch/sh/configs/rsk7201_defconfig                  |   37 +-
 arch/sh/configs/rsk7203_defconfig                  |   40 +-
 arch/sh/configs/rts7751r2d1_defconfig              |   43 +-
 arch/sh/configs/rts7751r2dplus_defconfig           |  130 ++-
 arch/sh/configs/sdk7780_defconfig                  |   38 +-
 arch/sh/configs/se7206_defconfig                   |   35 +-
 arch/sh/configs/se7343_defconfig                   |   42 +-
 arch/sh/configs/se7619_defconfig                   |   35 +-
 arch/sh/configs/se7705_defconfig                   |   34 +-
 arch/sh/configs/se7712_defconfig                   |   30 +-
 arch/sh/configs/se7721_defconfig                   |   33 +-
 arch/sh/configs/se7722_defconfig                   |   38 +-
 arch/sh/configs/se7724_defconfig                   | 1552 ++++++++++++++
 arch/sh/configs/se7750_defconfig                   |   34 +-
 arch/sh/configs/se7751_defconfig                   |   34 +-
 arch/sh/configs/se7780_defconfig                   |   38 +-
 arch/sh/configs/sh03_defconfig                     |   43 +-
 arch/sh/configs/sh7710voipgw_defconfig             |   35 +-
 arch/sh/configs/sh7724_generic_defconfig           |  707 +++++++
 arch/sh/configs/sh7763rdp_defconfig                |   35 +-
 arch/sh/configs/sh7770_generic_defconfig           |  700 ++++++
 arch/sh/configs/sh7785lcr_32bit_defconfig          |   37 +-
 arch/sh/configs/sh7785lcr_defconfig                |    6 +-
 arch/sh/configs/shmin_defconfig                    |   31 +-
 arch/sh/configs/shx3_defconfig                     |   32 +-
 arch/sh/configs/snapgear_defconfig                 |   40 +-
 arch/sh/configs/systemh_defconfig                  |   39 +-
 arch/sh/configs/titan_defconfig                    |   40 +-
 arch/sh/configs/ul2_defconfig                      |   37 +-
 arch/sh/configs/urquell_defconfig                  |   39 +-
 arch/sh/drivers/dma/Kconfig                        |    3 +-
 arch/sh/drivers/pci/Kconfig                        |   18 -
 arch/sh/drivers/pci/Makefile                       |   28 +-
 .../drivers/pci/{ops-cayman.c => fixups-cayman.c}  |   12 -
 arch/sh/drivers/pci/fixups-dreamcast.c             |    9 +-
 arch/sh/drivers/pci/fixups-landisk.c               |   34 +
 arch/sh/drivers/pci/fixups-lboxre2.c               |   41 -
 arch/sh/drivers/pci/fixups-r7780rp.c               |   41 +-
 arch/sh/drivers/pci/fixups-rts7751r2d.c            |   48 +-
 arch/sh/drivers/pci/fixups-sdk7780.c               |   63 +-
 arch/sh/drivers/pci/fixups-se7751.c                |  111 +
 arch/sh/drivers/pci/fixups-se7780.c                |   60 -
 arch/sh/drivers/pci/fixups-sh7785lcr.c             |   46 -
 arch/sh/drivers/pci/fixups-snapgear.c              |   38 +
 arch/sh/drivers/pci/fixups-titan.c                 |   38 +
 arch/sh/drivers/pci/ops-dreamcast.c                |  107 +-
 arch/sh/drivers/pci/ops-landisk.c                  |   67 -
 arch/sh/drivers/pci/ops-lboxre2.c                  |   63 -
 arch/sh/drivers/pci/ops-r7780rp.c                  |   68 -
 arch/sh/drivers/pci/ops-rts7751r2d.c               |   74 -
 arch/sh/drivers/pci/ops-sdk7780.c                  |   73 -
 arch/sh/drivers/pci/ops-se7780.c                   |   96 -
 arch/sh/drivers/pci/ops-sh03.c                     |   45 -
 arch/sh/drivers/pci/ops-sh4.c                      |   79 +-
 arch/sh/drivers/pci/ops-sh5.c                      |   25 -
 arch/sh/drivers/pci/ops-sh7785lcr.c                |   66 -
 arch/sh/drivers/pci/ops-snapgear.c                 |   94 -
 arch/sh/drivers/pci/ops-titan.c                    |   77 -
 arch/sh/drivers/pci/pci-auto.c                     |  545 -----
 arch/sh/drivers/pci/pci-dreamcast.c                |  102 +
 arch/sh/drivers/pci/pci-sh4.h                      |   19 +-
 arch/sh/drivers/pci/pci-sh5.c                      |   55 +-
 arch/sh/drivers/pci/pci-sh5.h                      |    3 -
 arch/sh/drivers/pci/pci-sh7751.c                   |  215 +-
 arch/sh/drivers/pci/pci-sh7751.h                   |   12 +-
 arch/sh/drivers/pci/pci-sh7780.c                   |  224 +-
 arch/sh/drivers/pci/pci-sh7780.h                   |   16 +-
 arch/sh/drivers/pci/pci.c                          |  279 ++-
 arch/sh/include/asm/cacheflush.h                   |    2 -
 arch/sh/include/asm/clock.h                        |   99 +-
 arch/sh/include/asm/device.h                       |    2 +
 arch/sh/include/asm/hd64461.h                      |  148 +-
 arch/sh/include/asm/io.h                           |   22 +-
 arch/sh/include/asm/irq.h                          |    3 +-
 arch/sh/include/asm/kprobes.h                      |    2 +-
 arch/sh/include/asm/machvec.h                      |    3 +
 arch/sh/include/asm/pci.h                          |  118 +-
 arch/sh/include/asm/pgtable.h                      |    4 +
 arch/sh/include/asm/processor.h                    |    6 +-
 arch/sh/include/asm/ptrace.h                       |    5 +
 arch/sh/include/asm/rtc.h                          |   11 +
 arch/sh/include/asm/swab.h                         |   12 +-
 arch/sh/include/asm/system_32.h                    |    2 +-
 arch/sh/include/asm/timer.h                        |   44 -
 arch/sh/include/asm/types.h                        |    4 +-
 arch/sh/include/asm/ubc.h                          |   11 +
 arch/sh/include/asm/unaligned-sh4a.h               |   10 +-
 arch/sh/include/cpu-sh2a/cpu/ubc.h                 |   29 +-
 arch/sh/include/cpu-sh3/cpu/timer.h                |   67 -
 arch/sh/include/cpu-sh4/cpu/cache.h                |    2 +
 arch/sh/include/cpu-sh4/cpu/freq.h                 |   18 +
 arch/sh/include/cpu-sh4/cpu/sh7724.h               |  255 +++
 arch/sh/include/cpu-sh4/cpu/sh7785.h               |   24 +
 arch/sh/include/cpu-sh4/cpu/timer.h                |   60 -
 arch/sh/include/cpu-sh5/cpu/irq.h                  |    1 -
 arch/sh/include/mach-common/mach/sh7785lcr.h       |   10 +-
 arch/sh/include/mach-dreamcast/mach/pci.h          |    2 +
 arch/sh/include/mach-se/mach/se7724.h              |   67 +
 arch/sh/kernel/Makefile_32                         |    6 +-
 arch/sh/kernel/Makefile_64                         |    9 +-
 arch/sh/kernel/cpu/Makefile                        |    1 +
 arch/sh/kernel/cpu/clock-cpg.c                     |  152 ++
 arch/sh/kernel/cpu/clock.c                         |  593 ++++--
 arch/sh/kernel/cpu/init.c                          |    7 +
 arch/sh/kernel/cpu/irq/imask.c                     |   68 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c                  |   36 +-
 arch/sh/kernel/cpu/irq/ipr.c                       |   12 +
 arch/sh/kernel/cpu/sh2/clock-sh7619.c              |   16 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c              |   84 +
 arch/sh/kernel/cpu/sh2a/clock-sh7201.c             |   14 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7203.c             |   15 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7206.c             |   12 +-
 arch/sh/kernel/cpu/sh2a/setup-mxg.c                |  111 +-
 arch/sh/kernel/cpu/sh2a/setup-sh7201.c             |  115 +
 arch/sh/kernel/cpu/sh2a/setup-sh7203.c             |  154 ++
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c             |  187 ++
 arch/sh/kernel/cpu/sh3/clock-sh3.c                 |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7705.c              |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7706.c              |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7709.c              |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7710.c              |   12 +-
 arch/sh/kernel/cpu/sh3/clock-sh7712.c              |    8 +-
 arch/sh/kernel/cpu/sh3/setup-sh7705.c              |  108 +
 arch/sh/kernel/cpu/sh3/setup-sh770x.c              |  108 +
 arch/sh/kernel/cpu/sh3/setup-sh7710.c              |  108 +
 arch/sh/kernel/cpu/sh3/setup-sh7720.c              |  270 +++
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c             |   43 +-
 arch/sh/kernel/cpu/sh4/clock-sh4.c                 |   12 +-
 arch/sh/kernel/cpu/sh4/probe.c                     |  130 +-
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c             |  164 ++-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c              |  187 ++
 arch/sh/kernel/cpu/sh4/setup-sh7760.c              |  140 ++-
 arch/sh/kernel/cpu/sh4a/Makefile                   |    3 +
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |  428 +++--
 arch/sh/kernel/cpu/sh4a/clock-sh7763.c             |   46 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7770.c             |   12 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7780.c             |   43 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c             |  208 +--
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c             |   47 +-
 arch/sh/kernel/cpu/sh4a/clock-shx3.c               |   41 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c            | 2230 ++++++++++++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c             |  122 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c             |  119 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c             |  123 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c             |  231 ++-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c             |  762 +++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c             |  204 ++
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c             |  546 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c             |  204 ++
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c             |  210 ++
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c             |  393 ++++
 arch/sh/kernel/cpu/sh4a/setup-shx3.c               |  209 ++-
 arch/sh/kernel/cpu/sh5/Makefile                    |    3 +
 arch/sh/kernel/cpu/sh5/clock-sh5.c                 |   14 +-
 arch/sh/kernel/cpu/sh5/entry.S                     |   65 +-
 arch/sh/kernel/cpu/sh5/setup-sh5.c                 |  195 ++
 arch/sh/kernel/io.c                                |    1 +
 arch/sh/kernel/io_trapped.c                        |    2 +-
 arch/sh/kernel/irq.c                               |   77 +-
 arch/sh/kernel/kgdb.c                              |    4 +-
 .../{timers/timer-broadcast.c => localtimer.c}     |    0
 arch/sh/kernel/machvec.c                           |    1 +
 arch/sh/kernel/module.c                            |    2 +-
 arch/sh/kernel/process_32.c                        |    4 +-
 arch/sh/kernel/ptrace_32.c                         |    8 +
 arch/sh/kernel/setup.c                             |   26 +-
 arch/sh/kernel/sh_ksyms_32.c                       |    9 -
 arch/sh/kernel/sh_ksyms_64.c                       |    2 +
 arch/sh/kernel/time.c                              |  125 ++
 arch/sh/kernel/time_32.c                           |  240 ---
 arch/sh/kernel/time_64.c                           |  363 ----
 arch/sh/kernel/timers/Makefile                     |   11 -
 arch/sh/kernel/timers/timer-cmt.c                  |  188 --
 arch/sh/kernel/timers/timer-mtu2.c                 |  202 --
 arch/sh/kernel/timers/timer-tmu.c                  |  297 ---
 arch/sh/kernel/timers/timer.c                      |   55 -
 arch/sh/kernel/traps.c                             |    6 +-
 arch/sh/kernel/traps_32.c                          |   15 +-
 arch/sh/kernel/traps_64.c                          |   35 +-
 arch/sh/kernel/vmlinux.lds.S                       |  179 ++-
 arch/sh/kernel/vmlinux_32.lds.S                    |  154 --
 arch/sh/kernel/vmlinux_64.lds.S                    |  163 --
 arch/sh/lib64/.gitignore                           |    1 -
 arch/sh/lib64/dbg.c                                |  182 --
 arch/sh/lib64/panic.c                              |   43 -
 arch/sh/lib64/sdivsi3.S                            |    6 +-
 arch/sh/lib64/udelay.c                             |    2 +-
 arch/sh/mm/Kconfig                                 |   31 +-
 arch/sh/mm/cache-sh5.c                             |    8 +-
 arch/sh/mm/init.c                                  |    3 -
 arch/sh/mm/ioremap_32.c                            |   14 +-
 arch/sh/mm/ioremap_64.c                            |  266 +--
 arch/sh/mm/mmap.c                                  |  136 ++-
 arch/sh/oprofile/common.c                          |    1 +
 arch/sh/tools/mach-types                           |    1 +
 drivers/clocksource/Makefile                       |    2 +
 drivers/clocksource/sh_cmt.c                       |  116 +-
 drivers/clocksource/sh_mtu2.c                      |  357 ++++
 drivers/clocksource/sh_tmu.c                       |  461 ++++
 drivers/i2c/busses/i2c-sh7760.c                    |    2 +-
 drivers/rtc/Kconfig                                |    2 +-
 drivers/serial/sh-sci.c                            |  388 ++--
 drivers/serial/sh-sci.h                            |   42 +-
 drivers/sh/intc.c                                  |   17 +-
 drivers/video/hitfb.c                              |    4 +-
 drivers/video/sh_mobile_lcdcfb.c                   |    7 +-
 include/linux/clocksource.h                        |   10 +-
 include/linux/serial_sci.h                         |    3 +-
 include/linux/sh_cmt.h                             |   13 -
 include/linux/sh_timer.h                           |   13 +
 include/linux/time.h                               |   15 +
 kernel/time/clocksource.c                          |    3 -
 kernel/time/timekeeping.c                          |    7 +
 sound/oss/Kconfig                                  |    2 +-
 sound/oss/sh_dac_audio.c                           |   85 +-
 263 files changed, 17198 insertions(+), 6713 deletions(-)
 create mode 100644 arch/sh/boards/mach-cayman/panic.c
 create mode 100644 arch/sh/boards/mach-se/7724/Makefile
 create mode 100644 arch/sh/boards/mach-se/7724/irq.c
 create mode 100644 arch/sh/boards/mach-se/7724/setup.c
 delete mode 100644 arch/sh/boards/mach-se/7751/pci.c
 delete mode 100644 arch/sh/boot/compressed/Makefile_32
 delete mode 100644 arch/sh/boot/compressed/Makefile_64
 delete mode 100644 arch/sh/boot/compressed/vmlinux_64.lds
 create mode 100644 arch/sh/configs/se7724_defconfig
 create mode 100644 arch/sh/configs/sh7724_generic_defconfig
 create mode 100644 arch/sh/configs/sh7770_generic_defconfig
 rename arch/sh/drivers/pci/{ops-cayman.c => fixups-cayman.c} (88%)
 create mode 100644 arch/sh/drivers/pci/fixups-landisk.c
 delete mode 100644 arch/sh/drivers/pci/fixups-lboxre2.c
 create mode 100644 arch/sh/drivers/pci/fixups-se7751.c
 delete mode 100644 arch/sh/drivers/pci/fixups-se7780.c
 delete mode 100644 arch/sh/drivers/pci/fixups-sh7785lcr.c
 create mode 100644 arch/sh/drivers/pci/fixups-snapgear.c
 create mode 100644 arch/sh/drivers/pci/fixups-titan.c
 delete mode 100644 arch/sh/drivers/pci/ops-landisk.c
 delete mode 100644 arch/sh/drivers/pci/ops-lboxre2.c
 delete mode 100644 arch/sh/drivers/pci/ops-r7780rp.c
 delete mode 100644 arch/sh/drivers/pci/ops-rts7751r2d.c
 delete mode 100644 arch/sh/drivers/pci/ops-sdk7780.c
 delete mode 100644 arch/sh/drivers/pci/ops-se7780.c
 delete mode 100644 arch/sh/drivers/pci/ops-sh03.c
 delete mode 100644 arch/sh/drivers/pci/ops-sh7785lcr.c
 delete mode 100644 arch/sh/drivers/pci/ops-snapgear.c
 delete mode 100644 arch/sh/drivers/pci/ops-titan.c
 delete mode 100644 arch/sh/drivers/pci/pci-auto.c
 create mode 100644 arch/sh/drivers/pci/pci-dreamcast.c
 delete mode 100644 arch/sh/include/asm/timer.h
 delete mode 100644 arch/sh/include/cpu-sh3/cpu/timer.h
 create mode 100644 arch/sh/include/cpu-sh4/cpu/sh7724.h
 delete mode 100644 arch/sh/include/cpu-sh4/cpu/timer.h
 create mode 100644 arch/sh/include/mach-se/mach/se7724.h
 create mode 100644 arch/sh/kernel/cpu/clock-cpg.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/setup-sh7724.c
 create mode 100644 arch/sh/kernel/cpu/sh5/setup-sh5.c
 rename arch/sh/kernel/{timers/timer-broadcast.c => localtimer.c} (100%)
 create mode 100644 arch/sh/kernel/time.c
 delete mode 100644 arch/sh/kernel/time_32.c
 delete mode 100644 arch/sh/kernel/time_64.c
 delete mode 100644 arch/sh/kernel/timers/Makefile
 delete mode 100644 arch/sh/kernel/timers/timer-cmt.c
 delete mode 100644 arch/sh/kernel/timers/timer-mtu2.c
 delete mode 100644 arch/sh/kernel/timers/timer-tmu.c
 delete mode 100644 arch/sh/kernel/timers/timer.c
 delete mode 100644 arch/sh/kernel/vmlinux_32.lds.S
 delete mode 100644 arch/sh/kernel/vmlinux_64.lds.S
 delete mode 100644 arch/sh/lib64/.gitignore
 create mode 100644 drivers/clocksource/sh_mtu2.c
 create mode 100644 drivers/clocksource/sh_tmu.c
 delete mode 100644 include/linux/sh_cmt.h
 create mode 100644 include/linux/sh_timer.h
