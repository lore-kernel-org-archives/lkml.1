Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbYJKWeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbYJKWeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 18:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbYJKWeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 18:34:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35445
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbYJKWeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 18:34:11 -0400
Date: Sat, 11 Oct 2008 15:33:46 -0700 (PDT)
Message-Id: <20081011.153346.78012869.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are the Sparc changes queued up for 2.6.28.

Highlights:

1) Complete removal of EBUS and SBUS device layers.  Everything sparc
   uses the OpenFirmware bus layer and generic dma_*() interfaces now.

2) Sparc converted to use the generic RTC device layer and drivers.

3) The scheduled CONFIG_SUN4 removal, from Adrian Bunk.

4) NUMA detection for JBUS based sparc64 machines.

5) JBUS UltraSPARC-III memory controller driver.

6) Ultra45 workstation hwmon driver.

7) Move sparc watchdog drivers under drivers/watchdog/

8) More work towards being able to use the generic IRQ layer on sparc32.
   But we're still not quite there yet.

9) More sparse warning progress on sparc64.

Thanks especially to Krzysztof Helt for his RTC layer work and
Robert Reif for testing, feedback, and some patches of his own.

Please pull, thanks a lot!

The following changes since commit ead9d23d803ea3a73766c3cb27bf7563ac8d7266:
  Linus Torvalds (1):
        Merge phase #4 (X2APIC, APIC unification, CPU identification unification) of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

Adrian Bunk (1):
      sparc: remove CONFIG_SUN4

Andrew Morton (1):
      drivers/rtc/Kconfig: don't build rtc-cmos.o on sparc32

Bjoern B. Brandenburg (1):
      sparc: remove unused includes

David Brownell (1):
      sparc: arch/sparc/kernel/pmc.c -- extra #include?

David S. Miller (169):
      sparc64: Add JBUS NUMA detection.
      sparc: Add mutex for set property calls.
      sparc: Implement irq_of_parse_and_map() and irq_dispose_mapping().
      sparc: Add GPIO layer support.
      sparc64: Split syscall_trace() into two functions.
      sparc64: Kill duplicated sys_pause() implementation.
      hwmon: Add Ultra45 workstation hwmon driver.
      sparc64: Convert UltraSPARC-III memory controller driver to OF driver probing.
      sparc64: Use consistent chmc_ prefix in variables, types, and functions.
      sparc64: Add generic interface for registering a dimm printing handler.
      sparc64: Allow chmc to be built as a module.
      sparc64: Add JBUS UltraSPARC-IIIi support to memory controller driver.
      sparc64: Use the cond_syscall()s in kernel/sys_ni.c instead of home-grown copy.
      sparc64: Fix irq_of_parse_and_map() and irq_dispose_mapping().
      sparc: Delete bare sbus char bpp driver, obsoleted by parport_sunbpp
      sparc: Kill videopix SBUS driver.
      sparc: Kill SBUS DVMA layer.
      sparc32: Make IOMMU and IO-UNIT init work with device nodes.
      sparc: Propagate SBUS iommu archdata into real of_device objects.
      sparc: Make SBUS DMA interfaces take struct device.
      sparc32: Make mmu_{get,release}_*() take a struct device pointer.
      sparc32: Implement more generic dma_*() interfaces.
      sparc: Convert all SBUS drivers to dma_*() interfaces.
      sparc: Move SBUS DMA attribute interfaces out of asm/sbus.h
      myri_sbus: Convert to pure OF driver.
      sunbmac: Convert to pure OF driver.
      sunhme: Convert to pure OF driver.
      sunlance: Convert to pure OF driver.
      sunqe: Convert to pure OF driver.
      parport_sunbpp: Convert to pure OF driver.
      sun_esp: Convert to pure OF driver.
      qlogicpti: Convert to pure OF driver.
      amd7930: Convert to pure OF driver.
      dbri: Convert to pure OF driver.
      cs4231: Use SNDRV_DMA_TYPE_DEV instead of SNDRV_DMA_TYPE_SBUS.
      alsa: Remove special SBUS dma support code.
      cs4231: Convert SBUS side to OF driver.
      fore200e: Convert over to pure OF driver.
      sparc: Convert flash driver to OF device probing.
      sparc: Convert uctrl driver to OF driver.
      sparc64: Convert SBUS floppy probing to use OF device objects.
      sparc32: Kill mmu_translate_dvma() usage.
      sparc32: Kill mmu_translate_dvma and implementations.
      sparc32: Make mmu_map_dma_area and mmu_unmap_dma_area take a device pointer.
      sparc32: Convert apc to OF driver.
      sparc32: Convert pmc to OF driver.
      sparc32: Convert sun4d IRQ code to use generic device tree probing.
      sparc: Kill SBUS layer IRQ hooks.
      sparc: Remove SBUS layer resource and irq handling.
      sparc: Remove dinky old-style SBUS probing facilities.
      sparc: Convert remaining sbus_ioremap() and sbus_iounmap() users.
      sparc: Kill sbus_ioremap() and sbus_iounmap().
      sparc: Kill sbus_devaddr() and sbus_dev_slot().
      sparc: Kill OBP property members of sbus_dev and sbus_bus
      sparc32: Kill sbus_is_slave().
      sparc: Kill sbus_arch_preinit().
      sparc: Add OF archdata propagation helper.
      sparc: Remove generic SBUS probing layer.
      sparc: Kill sbus_bus_type.
      sparc32: Kill iounit_map_dma_*().
      sparc: Kill now spurious includes of sbus.h
      sparc: Delete asm/sbus*.h
      sparc: Remove Documentation/sparc/sbus_drivers.txt
      rtc: Allow RTC_DRV_CMOS to be used on SPARC.
      sparc64: Select RTC_CLASS
      sparc64: Check for RTC class device in update_persistent_clock().
      sparc64: Convert Mostek rtc to use generic RTC layer driver.
      sparc: asm/mostek.h is now 32-bit only
      sparc64: Use generic CMOS driver.
      rtc: Add TI BQ4802 RTC driver.
      sparc64: Use generic BQ4802 RTC driver.
      rtc: Add Sun4V hypervisor RTC driver.
      sparc64: Use generic sun4v RTC driver.
      rtc: Add Starfire platform RTC driver.
      sparc64: Use generic starfire RTC driver.
      riowatchdog: Convert to pure OF driver.
      riowatchdog: Move under drivers/watchdog
      riowd: Distinguish between driver name and OF device node name.
      cpwatchdog: Cleanup and convert to pure OF driver.
      cpwatchdog: Move to drivers/watchdog/cpwd.c
      sun_uflash: Convert to pure OF driver.
      display7seg: Convert to pure OF device driver.
      envctrl: Convert to pure OF driver.
      bbc_i2c: Convert to pure OF driver.
      sparc64: Propagate PCI device archdata into OF device tree for EBUS.
      bbc_envctrl: Fix build errors from bbc_i2c OF conversion.
      sparc: Move EBUS DMA interfaces into seperate header file.
      sparc64: Convert EBUS floppy support to pure OF driver.
      cs4231: Convert to EBUS side to pure OF driver.
      sparc32: Convert PC RTC probing to pure OF driver.
      sparc: Kill EBUS driver layer.
      sparc: Kill ebus_bus_type.
      sparc64: Don't invoke power_init() from pcibios_init().
      sparc64: Convert SCHIZO PCI controller driver into a real driver.
      sparc64: Convert SUN4V PCI controller driver into a real driver.
      sparc64: Convert PSYCHO PCI controller driver into a real driver.
      sparc64: Convert SABRE PCI controller driver into a real driver.
      sparc64: Convert FIRE PCI controller driver into a real driver.
      sparc: Stop setting NO_DMA.
      sparc: Annotate of_device_id arrays with const or __initdata.
      sparc64: Simplify error handling in PCI controller probing.
      sparc64: Delete starfire_cpu_setup().
      leds: Add driver for Sunfire UltraSPARC server LEDs.
      sparc64: Rewrite central driver.
      sparc64: Clean up CPU chip type probing code.
      sparc64: Apply const or __initdata to vio_device_id[]
      sparc64: Use ENTRY/ENDPROC in hypervisor asm.
      sparc64: Use ENTRY/ENDPROC in PCI SUN4V asm.
      sparc64: Kill the scan_bus function pointer in struct pci_pbm_info.
      sparc64: Pass proper parent device down into root pci_create_bus() call.
      sparc64: Move reboot handling into seperate file and kill power reg programming.
      sparc64: Implement SSTATE purely using notifiers and initcalls.
      pci_psycho: Use of_getintprop_default().
      pci_schizo: Use of_get_property() and delete spurious local vars.
      pci_sun4v: Use of_get_property().
      sparc32: Fix sun4c build warnings.
      sparc: Fix handling of LANCE and ESP parent nodes in of_device.c
      sparc32: use RTC subsystem
      sparc: Kill sbus mostek RTC driver.
      sparc32: Kill remaining asm/mostek.h inclusions.
      sparc32: Kill asm/mostek.h.
      sparc: Remove asm/rtc.h
      Merge branch 'master' of master.kernel.org:/.../davem/sparc-2.6
      sparc32: Fix coding style of sparc_cpu_model setting code.
      sparc32: Move sun4d show_leds() out of asm/obio.h
      sparc64: Add missing rtc_close() in update_persistent_clock()
      rtc-bq4802: Fix sparse warnings.
      sparc64: Fix return value in update_persistent_clock().
      sparc32: Need to close openned RTC device just like sparc64.
      sparc64: Get rid of pci_controller_info.
      sparc64: Record OF device instead of device node pointer in pci_pbm_info.
      sparc64: Start commonizing code common between SABRE and PSYCHO.
      sparc64: Create and use psycho_pbm_init_common().
      sparc64: Commonize large portions of PSYCHO error handling.
      sparc64: Kill hand-crafted I/O accessors in PCI controller drivers.
      sparc32: Call parse_early_param() in setup_arch().
      sparc64: Add __arch64__ to CHECKFLAGS
      sparc64: Fix sparse warnings in global reg snapshotting.
      sysctl: Use CONFIG_SPARC instead of __sparc__ for ifdef tests.
      sysctl: Use header file for sysctl knob declarations on sparc.
      sparc64: Define WANT_PAGE_VIRTUAL
      sparc64: Fix sparse warnings in kernel/time.c
      sparc64: Fix sparse warnings in visemul.c
      sparc64: Fix sparse warnings in prom.c
      sparc64: Fix sparse warnings in of_device.c
      sparc64: Fix sparse warnings in pci.c
      sparc64: Fix sparse warnings in pci_sun4v.c
      sparc64: Fix sparse warnings in vio.c
      sparc64: Remove explicit initialization of mmu_gathers
      sparc64: Fix sparse warnings in fault.c
      sparc64: Kill sparse warnings in mm/init.h
      sparc64: Fix sparse warnings in chmc.c
      sparc: Fix user_regset 'n' field values.
      sparc32: Use PROM device probing for sun4m timer registers.
      Merge branch 'master' of master.kernel.org:/.../davem/sparc-2.6
      sparc32: Use PROM device probing for sun4m irq registers.
      sparc32: Use PROM infrastructure for probing and mapping sun4d timers.
      sparc32: Remove some SMP ifdefs in sun4d_irq.c
      sparc32: Remove #if 0'd code from sun4c_irq.c
      sparc32: Call sun4m_clear_profile_irq() directly from sun4m_smp.c
      sparc32: Kill clear_profile_irq btfixup entry.
      sparc32: Stop calling claim_ticker14() from sun4c_irq.c
      sparc32: Delete claim_ticker14().
      sparc32: Use PROM device probing for sun4c interrupt register.
      sparc32: Use PROM device probing for sun4c timers.
      sparc32: Delete master_l10_limit.
      sparc32: Kill irq_rcvreg from sun4m_irq.c
      sparc32: Add more extensive documentation of sun4m interrupts.
      Merge branch 'master' of master.kernel.org:/.../torvalds/linux-2.6

Krzysztof Helt (5):
      rtc-m48t59: reduce structure m48t59_private
      rtc-m48t59: add support for M48T02 and M48T59 chips
      rtc-m48t59: allow externally mapped ioaddr
      sparc64: fix wrong m48t59 RTC year
      rtc-m48t59: fix setting of a year on m48t08 and m48t02 rtcs

Robert Reif (5):
      sparc32: add init memory poisoning
      rtc-m48t59: Only check century bits on m48t59 chips.
      sparc32: sun4m interrupt mask cleanup
      cg6: disable cursor when leaving graphics mode
      leo: disable cursor when leaving graphics mode

 .../sound/alsa/DocBook/writing-an-alsa-driver.tmpl |    3 +-
 Documentation/sparc/sbus_drivers.txt               |  309 -----
 arch/sparc/Kconfig                                 |   26 +-
 arch/sparc/include/asm/Kbuild                      |    2 -
 arch/sparc/include/asm/asmmacro.h                  |    5 -
 arch/sparc/include/asm/bpp.h                       |   73 --
 arch/sparc/include/asm/bugs.h                      |    7 -
 arch/sparc/include/asm/cpudata_64.h                |    1 -
 arch/sparc/include/asm/dma-mapping_32.h            |   59 +-
 arch/sparc/include/asm/dma.h                       |  141 +++-
 arch/sparc/include/asm/dma_32.h                    |  288 -----
 arch/sparc/include/asm/dma_64.h                    |  205 ----
 arch/sparc/include/asm/ebus.h                      |    8 -
 arch/sparc/include/asm/ebus_32.h                   |   99 --
 arch/sparc/include/asm/ebus_64.h                   |   95 --
 arch/sparc/include/asm/ebus_dma.h                  |   35 +
 arch/sparc/include/asm/elf_32.h                    |    7 +-
 arch/sparc/include/asm/fhc.h                       |   43 +-
 arch/sparc/include/asm/floppy_32.h                 |   16 +-
 arch/sparc/include/asm/floppy_64.h                 |  130 +--
 arch/sparc/include/asm/gpio.h                      |   36 +
 arch/sparc/include/asm/io-unit.h                   |    4 -
 arch/sparc/include/asm/io_32.h                     |   19 +-
 arch/sparc/include/asm/io_64.h                     |   22 +-
 arch/sparc/include/asm/iommu_64.h                  |    3 +
 arch/sparc/include/asm/irq_64.h                    |    1 -
 arch/sparc/include/asm/mc146818rtc_64.h            |   10 +-
 arch/sparc/include/asm/memctrl.h                   |    9 +
 arch/sparc/include/asm/mostek.h                    |    8 -
 arch/sparc/include/asm/mostek_32.h                 |  171 ---
 arch/sparc/include/asm/mostek_64.h                 |  143 ---
 arch/sparc/include/asm/obio.h                      |   11 -
 arch/sparc/include/asm/of_device.h                 |    2 +
 arch/sparc/include/asm/of_platform.h               |    3 -
 arch/sparc/include/asm/oplib_32.h                  |    1 -
 arch/sparc/include/asm/page_32.h                   |    5 +-
 arch/sparc/include/asm/page_64.h                   |    2 +
 arch/sparc/include/asm/parport.h                   |    4 +-
 arch/sparc/include/asm/pci_32.h                    |    2 +
 arch/sparc/include/asm/pgtable_32.h                |    4 -
 arch/sparc/include/asm/pgtable_64.h                |    2 +
 arch/sparc/include/asm/prom.h                      |   12 +
 arch/sparc/include/asm/ptrace_64.h                 |    3 +
 arch/sparc/include/asm/reboot.h                    |    6 -
 arch/sparc/include/asm/rtc.h                       |   26 -
 arch/sparc/include/asm/sbus.h                      |    8 -
 arch/sparc/include/asm/sbus_32.h                   |  153 ---
 arch/sparc/include/asm/sbus_64.h                   |  190 ----
 arch/sparc/include/asm/spinlock_32.h               |    2 -
 arch/sparc/include/asm/spinlock_64.h               |    2 -
 arch/sparc/include/asm/sstate.h                    |   13 -
 arch/sparc/include/asm/starfire.h                  |    1 -
 arch/sparc/include/asm/sun4paddr.h                 |   56 -
 arch/sparc/include/asm/sun4prom.h                  |   83 --
 arch/sparc/include/asm/system_32.h                 |    9 +-
 arch/sparc/include/asm/system_64.h                 |    6 +-
 arch/sparc/include/asm/thread_info_32.h            |    4 -
 arch/sparc/include/asm/timer_32.h                  |   87 --
 arch/sparc/include/asm/vac-ops.h                   |    7 -
 arch/sparc/include/asm/vfc_ioctls.h                |   58 -
 arch/sparc/include/asm/visasm.h                    |    1 +
 arch/sparc/kernel/Makefile                         |    4 +-
 arch/sparc/kernel/apc.c                            |   72 +-
 arch/sparc/kernel/auxio.c                          |    6 +-
 arch/sparc/kernel/devices.c                        |    2 +-
 arch/sparc/kernel/dma.c                            |  227 ++++
 arch/sparc/kernel/dma.h                            |   14 +
 arch/sparc/kernel/ebus.c                           |  393 -------
 arch/sparc/kernel/entry.S                          |   94 +--
 arch/sparc/kernel/head.S                           |   28 +-
 arch/sparc/kernel/idprom.c                         |    7 -
 arch/sparc/kernel/ioport.c                         |  227 +----
 arch/sparc/kernel/irq.h                            |    6 -
 arch/sparc/kernel/of_device.c                      |   74 +-
 arch/sparc/kernel/pcic.c                           |   15 +-
 arch/sparc/kernel/pmc.c                            |   59 +-
 arch/sparc/kernel/process.c                        |    2 +-
 arch/sparc/kernel/prom.c                           |    7 +-
 arch/sparc/kernel/setup.c                          |   32 +-
 arch/sparc/kernel/sparc_ksyms.c                    |   25 -
 arch/sparc/kernel/sun4c_irq.c                      |  156 +--
 arch/sparc/kernel/sun4d_irq.c                      |  286 +++---
 arch/sparc/kernel/sun4d_smp.c                      |   12 +-
 arch/sparc/kernel/sun4m_irq.c                      |  495 +++++----
 arch/sparc/kernel/sun4m_smp.c                      |    4 +-
 arch/sparc/kernel/sun4setup.c                      |   75 --
 arch/sparc/kernel/sys_sparc.c                      |    8 +-
 arch/sparc/kernel/tick14.c                         |   47 -
 arch/sparc/kernel/time.c                           |  382 ++------
 arch/sparc/kernel/traps.c                          |   17 -
 arch/sparc/mm/Makefile                             |    9 +-
 arch/sparc/mm/btfixup.c                            |    6 +-
 arch/sparc/mm/fault.c                              |    2 +-
 arch/sparc/mm/init.c                               |   14 +-
 arch/sparc/mm/io-unit.c                            |  136 +--
 arch/sparc/mm/iommu.c                              |  113 +-
 arch/sparc/mm/nosrmmu.c                            |   59 -
 arch/sparc/mm/srmmu.c                              |    1 -
 arch/sparc/mm/sun4c.c                              |  204 +---
 arch/sparc/prom/Makefile                           |    2 -
 arch/sparc/prom/bootstr.c                          |    4 -
 arch/sparc/prom/console.c                          |    3 -
 arch/sparc/prom/init.c                             |   12 -
 arch/sparc/prom/memory.c                           |   14 -
 arch/sparc/prom/ranges.c                           |    1 -
 arch/sparc/prom/sun4prom.c                         |  161 ---
 arch/sparc64/Kconfig                               |   23 +
 arch/sparc64/Makefile                              |    2 +-
 arch/sparc64/kernel/Makefile                       |    9 +-
 arch/sparc64/kernel/auxio.c                        |    2 +-
 arch/sparc64/kernel/central.c                      |  617 ++++-------
 arch/sparc64/kernel/chmc.c                         |  817 ++++++++++----
 arch/sparc64/kernel/cpu.c                          |  208 ++--
 arch/sparc64/kernel/ds.c                           |    4 +-
 arch/sparc64/kernel/ebus.c                         |  299 +-----
 arch/sparc64/kernel/entry.h                        |    7 +-
 arch/sparc64/kernel/head.S                         |    1 +
 arch/sparc64/kernel/hvapi.c                        |    3 -
 arch/sparc64/kernel/hvcalls.S                      |  354 ++----
 arch/sparc64/kernel/irq.c                          |    1 -
 arch/sparc64/kernel/of_device.c                    |   62 +-
 arch/sparc64/kernel/pci.c                          |  172 +---
 arch/sparc64/kernel/pci_common.c                   |    8 +-
 arch/sparc64/kernel/pci_fire.c                     |  254 ++---
 arch/sparc64/kernel/pci_impl.h                     |   27 +-
 arch/sparc64/kernel/pci_msi.c                      |   18 +-
 arch/sparc64/kernel/pci_psycho.c                   |  750 +++----------
 arch/sparc64/kernel/pci_sabre.c                    |  507 ++-------
 arch/sparc64/kernel/pci_schizo.c                   |  368 ++++---
 arch/sparc64/kernel/pci_sun4v.c                    |  197 ++--
 arch/sparc64/kernel/pci_sun4v_asm.S                |   99 +-
 arch/sparc64/kernel/power.c                        |   55 +-
 arch/sparc64/kernel/process.c                      |   35 -
 arch/sparc64/kernel/prom.c                         |   91 +-
 arch/sparc64/kernel/psycho_common.c                |  470 ++++++++
 arch/sparc64/kernel/psycho_common.h                |   48 +
 arch/sparc64/kernel/ptrace.c                       |   38 +-
 arch/sparc64/kernel/reboot.c                       |   53 +
 arch/sparc64/kernel/sbus.c                         |  166 ++--
 arch/sparc64/kernel/sparc64_ksyms.c                |   23 +-
 arch/sparc64/kernel/sstate.c                       |   67 +-
 arch/sparc64/kernel/starfire.c                     |    5 -
 arch/sparc64/kernel/sys_sparc32.c                  |    8 -
 arch/sparc64/kernel/syscalls.S                     |   20 +-
 arch/sparc64/kernel/systbls.S                      |    2 +-
 arch/sparc64/kernel/time.c                         | 1187 +++-----------------
 arch/sparc64/kernel/traps.c                        |   69 +-
 arch/sparc64/kernel/vio.c                          |    8 +-
 arch/sparc64/kernel/visemul.c                      |   12 +-
 arch/sparc64/mm/fault.c                            |   37 -
 arch/sparc64/mm/init.c                             |   84 +-
 arch/sparc64/mm/init.h                             |   49 +
 arch/sparc64/mm/tlb.c                              |    2 +-
 drivers/ata/Kconfig                                |    1 -
 drivers/atm/fore200e.c                             |  410 ++++----
 drivers/atm/fore200e.h                             |    7 +-
 drivers/block/sunvdc.c                             |    4 +-
 drivers/char/hw_random/n2-drv.c                    |    2 +-
 drivers/char/rtc.c                                 |   30 +-
 drivers/hwmon/Kconfig                              |    7 +
 drivers/hwmon/Makefile                             |    1 +
 drivers/hwmon/ultra45_env.c                        |  320 ++++++
 drivers/input/misc/sparcspkr.c                     |    4 +-
 drivers/input/serio/i8042-sparcio.h                |    2 +-
 drivers/leds/Kconfig                               |    8 +
 drivers/leds/Makefile                              |    1 +
 drivers/leds/leds-sunfire.c                        |  273 +++++
 drivers/mtd/maps/sun_uflash.c                      |   75 +-
 drivers/net/myri_sbus.c                            |  196 ++--
 drivers/net/myri_sbus.h                            |    2 +-
 drivers/net/niu.c                                  |    2 +-
 drivers/net/sunbmac.c                              |  204 ++--
 drivers/net/sunbmac.h                              |    4 +-
 drivers/net/sunhme.c                               |  322 +++----
 drivers/net/sunhme.h                               |    7 +-
 drivers/net/sunlance.c                             |  180 ++--
 drivers/net/sunqe.c                                |  162 ++--
 drivers/net/sunqe.h                                |    4 +-
 drivers/net/sunvnet.c                              |    4 +-
 drivers/parport/parport_sunbpp.c                   |   49 +-
 drivers/rtc/Kconfig                                |   32 +-
 drivers/rtc/Makefile                               |    3 +
 drivers/rtc/rtc-bq4802.c                           |  230 ++++
 drivers/rtc/rtc-cmos.c                             |    5 +-
 drivers/rtc/rtc-m48t59.c                           |   68 +-
 drivers/rtc/rtc-starfire.c                         |  120 ++
 drivers/rtc/rtc-sun4v.c                            |  153 +++
 drivers/sbus/Makefile                              |    4 -
 drivers/sbus/char/Kconfig                          |   29 +-
 drivers/sbus/char/Makefile                         |    6 -
 drivers/sbus/char/bbc_envctrl.c                    |  121 +--
 drivers/sbus/char/bbc_i2c.c                        |  267 ++---
 drivers/sbus/char/bbc_i2c.h                        |   75 ++-
 drivers/sbus/char/bpp.c                            | 1055 -----------------
 drivers/sbus/char/cpwatchdog.c                     |  858 --------------
 drivers/sbus/char/display7seg.c                    |  251 +++--
 drivers/sbus/char/envctrl.c                        |  147 ++--
 drivers/sbus/char/flash.c                          |  130 +--
 drivers/sbus/char/rtc.c                            |  275 -----
 drivers/sbus/char/uctrl.c                          |  216 ++--
 drivers/sbus/char/vfc.h                            |  171 ---
 drivers/sbus/char/vfc_dev.c                        |  736 ------------
 drivers/sbus/char/vfc_i2c.c                        |  335 ------
 drivers/sbus/char/vfc_i2c.h                        |   44 -
 drivers/sbus/dvma.c                                |  136 ---
 drivers/sbus/sbus.c                                |  316 ------
 drivers/scsi/esp_scsi.h                            |    3 +-
 drivers/scsi/qlogicpti.c                           |  146 ++--
 drivers/scsi/qlogicpti.h                           |    2 +-
 drivers/scsi/sun_esp.c                             |  267 +++--
 drivers/serial/sunhv.c                             |    2 +-
 drivers/serial/sunsab.c                            |    2 +-
 drivers/serial/sunsu.c                             |    2 +-
 drivers/serial/sunzilog.c                          |    2 +-
 drivers/video/bw2.c                                |    2 +-
 drivers/video/cg14.c                               |    2 +-
 drivers/video/cg3.c                                |    2 +-
 drivers/video/cg6.c                                |   38 +-
 drivers/video/ffb.c                                |    2 +-
 drivers/video/leo.c                                |   96 +-
 drivers/video/p9100.c                              |    2 +-
 drivers/video/tcx.c                                |    2 +-
 drivers/watchdog/Makefile                          |    3 +
 drivers/watchdog/cpwd.c                            |  695 ++++++++++++
 .../{sbus/char/riowatchdog.c => watchdog/riowd.c}  |  236 ++---
 include/linux/rtc/m48t59.h                         |   47 +-
 include/sound/core.h                               |    3 -
 include/sound/memalloc.h                           |    2 -
 kernel/sysctl.c                                    |    8 +-
 sound/core/memalloc.c                              |   48 +-
 sound/sparc/amd7930.c                              |   85 +--
 sound/sparc/cs4231.c                               |  199 ++--
 sound/sparc/dbri.c                                 |   89 +-
 233 files changed, 8453 insertions(+), 15194 deletions(-)
 delete mode 100644 Documentation/sparc/sbus_drivers.txt
 delete mode 100644 arch/sparc/include/asm/bpp.h
 delete mode 100644 arch/sparc/include/asm/dma_32.h
 delete mode 100644 arch/sparc/include/asm/dma_64.h
 delete mode 100644 arch/sparc/include/asm/ebus.h
 delete mode 100644 arch/sparc/include/asm/ebus_32.h
 delete mode 100644 arch/sparc/include/asm/ebus_64.h
 create mode 100644 arch/sparc/include/asm/ebus_dma.h
 create mode 100644 arch/sparc/include/asm/gpio.h
 create mode 100644 arch/sparc/include/asm/memctrl.h
 delete mode 100644 arch/sparc/include/asm/mostek.h
 delete mode 100644 arch/sparc/include/asm/mostek_32.h
 delete mode 100644 arch/sparc/include/asm/mostek_64.h
 delete mode 100644 arch/sparc/include/asm/reboot.h
 delete mode 100644 arch/sparc/include/asm/rtc.h
 delete mode 100644 arch/sparc/include/asm/sbus.h
 delete mode 100644 arch/sparc/include/asm/sbus_32.h
 delete mode 100644 arch/sparc/include/asm/sbus_64.h
 delete mode 100644 arch/sparc/include/asm/sstate.h
 delete mode 100644 arch/sparc/include/asm/sun4paddr.h
 delete mode 100644 arch/sparc/include/asm/sun4prom.h
 delete mode 100644 arch/sparc/include/asm/vfc_ioctls.h
 create mode 100644 arch/sparc/kernel/dma.c
 create mode 100644 arch/sparc/kernel/dma.h
 delete mode 100644 arch/sparc/kernel/ebus.c
 delete mode 100644 arch/sparc/kernel/sun4setup.c
 delete mode 100644 arch/sparc/mm/nosrmmu.c
 delete mode 100644 arch/sparc/prom/sun4prom.c
 create mode 100644 arch/sparc64/kernel/psycho_common.c
 create mode 100644 arch/sparc64/kernel/psycho_common.h
 create mode 100644 arch/sparc64/kernel/reboot.c
 create mode 100644 arch/sparc64/mm/init.h
 create mode 100644 drivers/hwmon/ultra45_env.c
 create mode 100644 drivers/leds/leds-sunfire.c
 create mode 100644 drivers/rtc/rtc-bq4802.c
 create mode 100644 drivers/rtc/rtc-starfire.c
 create mode 100644 drivers/rtc/rtc-sun4v.c
 delete mode 100644 drivers/sbus/char/bpp.c
 delete mode 100644 drivers/sbus/char/cpwatchdog.c
 delete mode 100644 drivers/sbus/char/rtc.c
 delete mode 100644 drivers/sbus/char/vfc.h
 delete mode 100644 drivers/sbus/char/vfc_dev.c
 delete mode 100644 drivers/sbus/char/vfc_i2c.c
 delete mode 100644 drivers/sbus/char/vfc_i2c.h
 delete mode 100644 drivers/sbus/dvma.c
 delete mode 100644 drivers/sbus/sbus.c
 create mode 100644 drivers/watchdog/cpwd.c
 rename drivers/{sbus/char/riowatchdog.c => watchdog/riowd.c} (51%)
