Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZLCP1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZLCP1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbZLCP13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:27:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:57234 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420AbZLCP1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:27:24 -0500
Date: Thu, 3 Dec 2009 16:27:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: What's in trivial.git for 2.6.33
Message-ID: <alpine.LNX.2.00.0912031623160.3755@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

below is a summary of what is currently queued in trivial.git for 2.6.33.

The diffstat looks huge, mostly because this time we have several patches 
that fix up some common typos all over the tree (but usually it makes 
sense to fix these, as they make grepping for things much more 
convenient).

In addition to that, we have some Documentation updates, __init/__exit 
cleanups and removal of some code that has been dead for years.

 Documentation/ABI/testing/procfs-diskstats         |    2 +-
 Documentation/ABI/testing/sysfs-block              |    2 +-
 Documentation/DocBook/genericirq.tmpl              |    4 +-
 Documentation/DocBook/mtdnand.tmpl                 |    2 +-
 Documentation/DocBook/v4l/videodev2.h.xml          |    2 +-
 Documentation/DocBook/writing-an-alsa-driver.tmpl  |    2 +-
 Documentation/dvb/README.dvb-usb                   |    2 +-
 Documentation/edac.txt                             |    7 +-
 Documentation/filesystems/ocfs2.txt                |    6 +-
 Documentation/i2c/busses/i2c-piix4                 |    2 +-
 Documentation/lguest/lguest.c                      |    2 +-
 Documentation/oops-tracing.txt                     |    2 +
 Documentation/power/regulator/consumer.txt         |    2 +-
 Documentation/scsi/ChangeLog.megaraid_sas          |    2 +-
 Documentation/spi/spi-summary                      |    2 +-
 Documentation/sysctl/kernel.txt                    |    6 +-
 Documentation/sysctl/vm.txt                        |    2 +-
 Documentation/thermal/sysfs-api.txt                |  389 ++++++-------
 Documentation/timers/hpet.txt                      |    2 +-
 Documentation/video4linux/gspca.txt                |    2 +-
 Documentation/vm/page-types.c                      |    4 +-
 MAINTAINERS                                        |   52 +-
 Makefile                                           |    4 +-
 arch/alpha/boot/tools/objstrip.c                   |    2 +-
 arch/alpha/include/asm/fcntl.h                     |    2 +
 arch/alpha/include/asm/thread_info.h               |    4 +-
 arch/alpha/mm/numa.c                               |    2 +-
 arch/arm/common/scoop.c                            |    2 +-
 arch/arm/configs/ams_delta_defconfig               |   24 +-
 arch/arm/configs/kirkwood_defconfig                |  260 +++------
 arch/arm/configs/omap3_pandora_defconfig           |   49 +--
 arch/arm/configs/omap_3430sdp_defconfig            |    9 +-
 arch/arm/configs/orion5x_defconfig                 |  278 ++++------
 arch/arm/include/asm/unistd.h                      |    9 -
 arch/arm/kernel/entry-armv.S                       |    7 +-
 arch/arm/kernel/head-common.S                      |    2 +-
 arch/arm/kernel/smp_scu.c                          |    4 -
 arch/arm/kernel/traps.c                            |    4 +-
 arch/arm/mach-at91/Kconfig                         |   20 +-
 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c     |   23 +-
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |    2 +-
 arch/arm/mach-bcmring/include/mach/dma.h           |    2 +-
 arch/arm/mach-ep93xx/micro9.c                      |    1 -
 arch/arm/mach-kirkwood/addr-map.c                  |    2 +-
 arch/arm/mach-kirkwood/common.c                    |   10 +-
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h  |    3 -
 arch/arm/mach-kirkwood/include/mach/io.h           |    2 +-
 arch/arm/mach-kirkwood/include/mach/kirkwood.h     |    1 -
 arch/arm/mach-kirkwood/openrd_base-setup.c         |   12 -
 arch/arm/mach-kirkwood/pcie.c                      |    6 +-
 arch/arm/mach-ks8695/include/mach/regs-switch.h    |    2 +-
 arch/arm/mach-lh7a40x/include/mach/hardware.h      |    2 +-
 arch/arm/mach-mmp/include/mach/mfp-pxa910.h        |    2 +-
 arch/arm/mach-mv78xx0/common.c                     |    2 -
 arch/arm/mach-mv78xx0/include/mach/mv78xx0.h       |    1 -
 arch/arm/mach-omap2/board-omap3beagle.c            |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   78 ++--
 arch/arm/mach-omap2/board-zoom2.c                  |   87 ++--
 arch/arm/mach-omap2/clock34xx.c                    |    2 +-
 arch/arm/mach-omap2/clock34xx.h                    |    4 +-
 arch/arm/mach-omap2/gpmc.c                         |    4 +-
 arch/arm/mach-omap2/mailbox.c                      |    2 +-
 arch/arm/mach-orion5x/pci.c                        |    2 +-
 arch/arm/mach-pxa/colibri-pxa320.c                 |    4 +-
 arch/arm/mach-pxa/hx4700.c                         |    2 +-
 arch/arm/mach-pxa/include/mach/entry-macro.S       |    1 -
 arch/arm/mach-pxa/include/mach/palmld.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmt5.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmtc.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmte2.h           |    2 +-
 arch/arm/mach-pxa/include/mach/palmtx.h            |    2 +-
 arch/arm/mach-pxa/include/mach/palmz72.h           |    2 +-
 arch/arm/mach-pxa/irq.c                            |   11 +-
 arch/arm/mach-pxa/palmtc.c                         |    8 +-
 arch/arm/mach-pxa/spitz.c                          |   39 +-
 arch/arm/mach-realview/Kconfig                     |    5 +-
 arch/arm/mach-realview/core.c                      |   42 +--
 arch/arm/mach-realview/core.h                      |    6 -
 arch/arm/mach-realview/include/mach/memory.h       |   49 --
 arch/arm/mach-realview/platsmp.c                   |    5 +-
 arch/arm/mach-realview/realview_eb.c               |    1 -
 arch/arm/mach-realview/realview_pb1176.c           |   13 -
 arch/arm/mach-realview/realview_pb11mp.c           |    1 -
 arch/arm/mach-realview/realview_pba8.c             |    1 -
 arch/arm/mach-realview/realview_pbx.c              |   21 -
 arch/arm/mach-s3c2400/Kconfig                      |    6 -
 arch/arm/mach-s3c2410/Kconfig                      |    2 -
 arch/arm/mach-s3c2412/Kconfig                      |    4 -
 arch/arm/mach-s3c2440/Kconfig                      |    3 -
 arch/arm/mach-s3c2442/Kconfig                      |    4 -
 arch/arm/mach-s3c2443/Kconfig                      |    2 -
 arch/arm/mach-s3c6400/Kconfig                      |    2 -
 arch/arm/mach-s3c6400/include/mach/dma.h           |   12 +-
 arch/arm/mach-s3c6400/setup-sdhci.c                |    2 +-
 arch/arm/mach-s3c6410/Kconfig                      |    3 -
 arch/arm/mach-s3c6410/mach-smdk6410.c              |    3 -
 arch/arm/mach-s3c6410/setup-sdhci.c                |    2 +-
 arch/arm/mach-s5pc100/Kconfig                      |    2 -
 arch/arm/mach-sa1100/dma.c                         |    2 +-
 arch/arm/mach-u300/core.c                          |    2 +-
 arch/arm/mm/proc-v7.S                              |    7 +-
 arch/arm/plat-mxc/include/mach/iomux-mx3.h         |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mxc91231.h    |    2 +-
 arch/arm/plat-mxc/pwm.c                            |    2 +-
 arch/arm/plat-omap/cpu-omap.c                      |    2 +-
 arch/arm/plat-omap/dma.c                           |   16 +-
 arch/arm/plat-omap/gpio.c                          |    2 +-
 arch/arm/plat-omap/include/mach/omap16xx.h         |    2 +-
 arch/arm/plat-pxa/include/plat/mfp.h               |    2 +-
 arch/arm/plat-pxa/mfp.c                            |    4 +-
 arch/arm/plat-s3c/Kconfig                          |    2 -
 arch/arm/plat-s3c24xx/Kconfig                      |    2 -
 arch/arm/plat-s3c24xx/include/plat/map.h           |    2 +-
 arch/arm/plat-s3c64xx/Kconfig                      |    2 -
 arch/arm/plat-s3c64xx/dma.c                        |   76 +--
 arch/arm/plat-s5pc1xx/Kconfig                      |    2 -
 arch/avr32/boards/hammerhead/Kconfig               |    2 +-
 arch/blackfin/kernel/traps.c                       |    2 +-
 .../mach-bf518/include/mach/defBF51x_base.h        |    4 +-
 .../mach-bf527/include/mach/defBF52x_base.h        |    4 +-
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF544.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF548.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF549.h   |    4 +-
 arch/cris/arch-v10/mm/fault.c                      |    3 +-
 arch/cris/arch-v10/mm/tlb.c                        |   22 -
 arch/cris/mm/fault.c                               |    2 +-
 arch/ia64/hp/common/sba_iommu.c                    |    2 +-
 arch/ia64/ia32/ia32_entry.S                        |    2 +-
 arch/ia64/include/asm/perfmon_default_smpl.h       |    2 +-
 arch/ia64/include/asm/sn/shubio.h                  |    2 +-
 arch/ia64/kernel/esi.c                             |    2 +-
 arch/ia64/kernel/perfmon.c                         |    2 +-
 arch/m32r/boot/compressed/Makefile                 |    4 +-
 arch/m68k/ifpsp060/src/fpsp.S                      |   28 +-
 arch/m68k/ifpsp060/src/pfpsp.S                     |   26 +-
 arch/m68k/include/asm/bootinfo.h                   |    2 +-
 arch/microblaze/lib/memcpy.c                       |    2 +-
 arch/microblaze/lib/memmove.c                      |    2 +-
 arch/microblaze/lib/memset.c                       |    2 +-
 arch/mips/Kconfig                                  |    1 -
 arch/mips/bcm47xx/prom.c                           |    2 +-
 arch/mips/configs/rbtx49xx_defconfig               |  252 ++------
 arch/mips/include/asm/dma-mapping.h                |   11 +-
 arch/mips/include/asm/mach-pnx833x/gpio.h          |    2 +-
 arch/mips/include/asm/sgi/ioc.h                    |    2 +-
 arch/mips/include/asm/sibyte/sb1250_mac.h          |    2 +-
 arch/mips/include/asm/sn/sn0/hubio.h               |    2 +-
 arch/mips/kernel/cevt-smtc.c                       |    3 +-
 arch/mips/kernel/smtc.c                            |    2 +-
 arch/mips/math-emu/cp1emu.c                        |   41 +-
 arch/mips/math-emu/dp_sub.c                        |    2 +-
 arch/mips/mm/dma-default.c                         |    7 -
 arch/mips/mti-malta/malta-memory.c                 |    3 +-
 arch/mips/rb532/prom.c                             |    2 +-
 arch/mips/txx9/generic/setup.c                     |    4 +-
 arch/mips/txx9/generic/smsc_fdc37m81x.c            |    2 +-
 arch/parisc/include/asm/fcntl.h                    |    2 +
 arch/parisc/kernel/perf.c                          |    2 +-
 arch/powerpc/boot/addRamDisk.c                     |    6 +-
 arch/powerpc/boot/dts/mpc8377_wlan.dts             |    2 +-
 arch/powerpc/boot/dts/mpc8569mds.dts               |    4 +-
 arch/powerpc/boot/dts/sbc8548.dts                  |   17 +-
 arch/powerpc/configs/83xx/asp8347_defconfig        |   60 +--
 arch/powerpc/configs/83xx/kmeter1_defconfig        |   46 +-
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig    |   73 +--
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig    |   76 +--
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig    |   62 +--
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig    |   66 +--
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig    |   60 +--
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig  |   58 +--
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig    |   58 +--
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig    |   64 +--
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig    |   60 +--
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig    |   64 +--
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig    |   70 +--
 arch/powerpc/configs/83xx/sbc834x_defconfig        |   61 +--
 arch/powerpc/configs/85xx/ksi8560_defconfig        |   61 +--
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig    |   57 +--
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig    |   63 +--
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig    |   58 +--
 arch/powerpc/configs/85xx/sbc8548_defconfig        |   53 +--
 arch/powerpc/configs/85xx/sbc8560_defconfig        |   57 +--
 arch/powerpc/configs/85xx/socrates_defconfig       |   68 +--
 arch/powerpc/configs/85xx/stx_gp3_defconfig        |   77 +--
 arch/powerpc/configs/85xx/tqm8540_defconfig        |   59 +--
 arch/powerpc/configs/85xx/tqm8541_defconfig        |   64 +--
 arch/powerpc/configs/85xx/tqm8548_defconfig        |   64 +--
 arch/powerpc/configs/85xx/tqm8555_defconfig        |   64 +--
 arch/powerpc/configs/85xx/tqm8560_defconfig        |   64 +--
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig    |   76 +--
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |   74 +--
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     |   72 +--
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |   80 +--
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig   |   64 +--
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig   |   65 +--
 arch/powerpc/configs/86xx/sbc8641d_defconfig       |   66 +--
 arch/powerpc/configs/adder875_defconfig            |   48 +-
 arch/powerpc/configs/c2k_defconfig                 |   77 +--
 arch/powerpc/configs/ep8248e_defconfig             |   49 +-
 arch/powerpc/configs/ep88xc_defconfig              |   47 +-
 arch/powerpc/configs/linkstation_defconfig         |   72 +--
 arch/powerpc/configs/mgcoge_defconfig              |   51 +-
 arch/powerpc/configs/mgsuvd_defconfig              |   45 +-
 arch/powerpc/configs/mpc7448_hpc2_defconfig        |   58 +--
 arch/powerpc/configs/mpc8272_ads_defconfig         |   52 +--
 arch/powerpc/configs/mpc83xx_defconfig             |   90 +--
 arch/powerpc/configs/mpc85xx_defconfig             |   98 ++--
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   99 ++--
 arch/powerpc/configs/mpc866_ads_defconfig          |   54 +-
 arch/powerpc/configs/mpc86xx_defconfig             |   70 +--
 arch/powerpc/configs/mpc885_ads_defconfig          |   47 +-
 arch/powerpc/configs/pasemi_defconfig              |  628 ++++++--------------
 arch/powerpc/configs/pq2fads_defconfig             |   55 +--
 arch/powerpc/configs/prpmc2800_defconfig           |   67 +--
 arch/powerpc/configs/storcenter_defconfig          |   54 +-
 arch/powerpc/include/asm/reg_fsl_emb.h             |    2 +-
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/powerpc/kernel/tau_6xx.c                      |    2 +-
 arch/powerpc/kernel/vdso.c                         |    2 +-
 arch/powerpc/oprofile/op_model_cell.c              |    6 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |    2 +-
 arch/powerpc/platforms/82xx/ep8248e.c              |   15 +-
 arch/powerpc/platforms/powermac/pci.c              |    2 +-
 arch/powerpc/sysdev/dart_iommu.c                   |    2 +-
 arch/s390/kernel/early.c                           |    9 -
 arch/s390/kernel/entry.S                           |    8 +-
 arch/s390/kernel/entry64.S                         |    8 +-
 arch/s390/math-emu/math.c                          |    4 +-
 arch/sh/include/asm/rwsem.h                        |    2 +-
 arch/sh/kernel/cpu/irq/imask.c                     |    2 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c                  |    2 +-
 arch/sh/kernel/dwarf.c                             |    2 +-
 arch/sh/mm/cache-sh4.c                             |    5 +-
 arch/sparc/boot/btfixupprep.c                      |    8 +-
 arch/sparc/boot/piggyback_32.c                     |   10 +-
 arch/sparc/boot/piggyback_64.c                     |    2 +-
 arch/sparc/include/asm/system_64.h                 |    4 -
 arch/sparc/kernel/prom_common.c                    |    4 +-
 arch/sparc/kernel/visemul.c                        |    2 +-
 arch/x86/include/asm/desc_defs.h                   |    4 +-
 arch/x86/include/asm/dma-mapping.h                 |   10 +-
 arch/x86/include/asm/mmzone_32.h                   |    2 +-
 arch/x86/include/asm/uv/uv_bau.h                   |    2 +-
 arch/x86/kernel/acpi/boot.c                        |    2 +-
 arch/x86/kernel/amd_iommu.c                        |    4 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c         |   23 +-
 arch/x86/kernel/cpu/cpufreq/longhaul.c             |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c          |    2 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c        |   19 +-
 arch/x86/kernel/cpu/perf_event.c                   |    2 +-
 arch/x86/kernel/kprobes.c                          |    4 +-
 arch/x86/kernel/microcode_amd.c                    |    6 -
 arch/x86/kernel/pci-dma.c                          |    6 +-
 arch/x86/kernel/setup.c                            |    7 -
 arch/x86/mm/ioremap.c                              |   24 +-
 arch/x86/mm/kmmio.c                                |    4 +-
 block/blk-iopoll.c                                 |    2 +-
 drivers/Kconfig                                    |    2 -
 drivers/acpi/acpica/acconfig.h                     |    4 +-
 drivers/acpi/acpica/exregion.c                     |   35 +-
 drivers/acpi/power_meter.c                         |    6 +-
 drivers/acpi/proc.c                                |    2 +-
 drivers/acpi/processor_core.c                      |    2 +-
 drivers/acpi/processor_throttling.c                |    6 +-
 drivers/acpi/sleep.c                               |   24 -
 drivers/acpi/video.c                               |    8 +-
 drivers/acpi/video_detect.c                        |   10 +-
 drivers/ata/ata_piix.c                             |    2 +-
 drivers/ata/libata-sff.c                           |    6 +-
 drivers/ata/pata_cs5535.c                          |    2 +-
 drivers/ata/sata_fsl.c                             |    6 +-
 drivers/atm/iphase.c                               |    2 +-
 drivers/base/dd.c                                  |    2 +-
 drivers/block/ataflop.c                            |    3 -
 drivers/bluetooth/btmrvl_sdio.c                    |    2 +-
 drivers/bluetooth/btusb.c                          |    5 +-
 drivers/bluetooth/hci_ldisc.c                      |    2 +-
 drivers/char/agp/intel-agp.c                       |   11 +-
 drivers/char/mem.c                                 |    2 +-
 drivers/char/mspec.c                               |    2 +-
 drivers/char/n_r3964.c                             |    2 +-
 drivers/char/rio/route.h                           |    2 +-
 drivers/char/tty_ioctl.c                           |    2 +-
 drivers/char/tty_port.c                            |    3 -
 drivers/char/vt_ioctl.c                            |    6 +-
 drivers/cpufreq/cpufreq.c                          |   48 +--
 drivers/cpufreq/cpufreq_conservative.c             |    4 +-
 drivers/cpufreq/cpufreq_ondemand.c                 |    4 +-
 drivers/cpuidle/governor.c                         |    4 +-
 drivers/crypto/hifn_795x.c                         |    2 +-
 drivers/dma/at_hdmac.c                             |    2 +-
 drivers/firewire/core-topology.c                   |    2 +-
 drivers/gpio/gpiolib.c                             |    8 +-
 drivers/gpu/drm/drm_crtc.c                         |    4 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |    1 -
 drivers/gpu/drm/drm_fb_helper.c                    |    2 +-
 drivers/gpu/drm/i915/i915_gem.c                    |    2 +-
 drivers/gpu/drm/i915/intel_fb.c                    |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    2 +-
 drivers/gpu/drm/radeon/Makefile                    |    2 +-
 drivers/gpu/drm/radeon/atombios.h                  |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |  357 ++++++------
 drivers/gpu/drm/radeon/mkregtable.c                |   12 +-
 drivers/gpu/drm/radeon/r100.c                      |   42 +-
 drivers/gpu/drm/radeon/r300.c                      |    2 +-
 drivers/gpu/drm/radeon/r420.c                      |    2 -
 drivers/gpu/drm/radeon/r500_reg.h                  |    9 -
 drivers/gpu/drm/radeon/r520.c                      |    2 -
 drivers/gpu/drm/radeon/r600.c                      |  112 ++--
 drivers/gpu/drm/radeon/r600_blit.c                 |   58 +--
 drivers/gpu/drm/radeon/r600_blit_kms.c             |    5 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   18 -
 drivers/gpu/drm/radeon/r600d.h                     |   14 -
 drivers/gpu/drm/radeon/radeon.h                    |   11 -
 drivers/gpu/drm/radeon/radeon_asic.h               |   23 -
 drivers/gpu/drm/radeon/radeon_atombios.c           |  282 ++-------
 drivers/gpu/drm/radeon/radeon_benchmark.c          |    4 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |    3 +
 drivers/gpu/drm/radeon/radeon_clocks.c             |    2 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |  287 +++-------
 drivers/gpu/drm/radeon/radeon_connectors.c         |  199 ++-----
 drivers/gpu/drm/radeon/radeon_cursor.c             |   10 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   29 +-
 drivers/gpu/drm/radeon/radeon_display.c            |   28 +-
 drivers/gpu/drm/radeon/radeon_encoders.c           |  125 +++--
 drivers/gpu/drm/radeon/radeon_fb.c                 |    2 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |   20 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    9 -
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |   40 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |   27 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |   34 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |   65 --
 drivers/gpu/drm/radeon/radeon_reg.h                |    6 -
 drivers/gpu/drm/radeon/radeon_state.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_test.c               |    6 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |    8 +-
 drivers/gpu/drm/radeon/rs400.c                     |    2 -
 drivers/gpu/drm/radeon/rs600.c                     |   20 +-
 drivers/gpu/drm/radeon/rs690.c                     |    2 -
 drivers/gpu/drm/radeon/rv515.c                     |    4 -
 drivers/gpu/drm/radeon/rv770.c                     |   63 +--
 drivers/gpu/drm/radeon/rv770d.h                    |    5 -
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    2 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |    1 -
 drivers/hwmon/adm1029.c                            |    2 +-
 drivers/hwmon/adt7475.c                            |   17 +-
 drivers/hwmon/lm93.c                               |    2 +-
 drivers/hwmon/s3c-hwmon.c                          |   11 +-
 drivers/i2c/busses/Kconfig                         |    2 +-
 drivers/i2c/busses/i2c-piix4.c                     |    8 +-
 drivers/i2c/busses/i2c-pnx.c                       |    5 -
 drivers/ide/ide-probe.c                            |    9 +
 drivers/ieee1394/dv1394.c                          |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c        |    2 +-
 drivers/infiniband/hw/ipath/ipath_sd7220.c         |    4 +-
 drivers/infiniband/hw/mlx4/qp.c                    |    2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |    2 +-
 drivers/input/ff-core.c                            |   20 +-
 drivers/input/ff-memless.c                         |   26 +-
 drivers/input/input.c                              |   29 +-
 drivers/input/keyboard/atkbd.c                     |   13 -
 drivers/input/mouse/lifebook.c                     |    3 +-
 drivers/input/mouse/psmouse-base.c                 |    4 +-
 drivers/input/serio/hp_sdc.c                       |    2 +-
 drivers/input/serio/hp_sdc_mlc.c                   |    2 +-
 drivers/input/touchscreen/atmel-wm97xx.c           |    2 +-
 drivers/input/touchscreen/mainstone-wm97xx.c       |    4 +-
 drivers/input/touchscreen/zylonite-wm97xx.c        |    2 +-
 drivers/isdn/act2000/Kconfig                       |    4 -
 drivers/isdn/capi/Kconfig                          |    4 -
 drivers/isdn/capi/capidrv.c                        |    2 +-
 drivers/isdn/hardware/eicon/di.c                   |    2 +-
 drivers/isdn/hardware/eicon/maintidi.c             |    9 +-
 drivers/isdn/hardware/eicon/message.c              |   18 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.h              |    2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |    2 +-
 drivers/isdn/hisax/amd7930_fn.c                    |    1 -
 drivers/isdn/hisax/diva.c                          |    2 +-
 drivers/isdn/hisax/elsa_ser.c                      |   22 +-
 drivers/isdn/hisax/hfc_usb.c                       |    6 +-
 drivers/isdn/hisax/hscx_irq.c                      |    2 +-
 drivers/isdn/hisax/icc.c                           |    1 -
 drivers/isdn/hysdn/Kconfig                         |    4 -
 drivers/isdn/i4l/isdn_net.c                        |    2 +-
 drivers/isdn/i4l/isdn_ppp.c                        |  358 ++++++------
 drivers/isdn/i4l/isdn_ttyfax.c                     |    2 +-
 drivers/isdn/icn/Kconfig                           |    4 -
 drivers/isdn/mISDN/dsp_core.c                      |    2 +-
 drivers/isdn/mISDN/stack.c                         |    2 +-
 drivers/isdn/mISDN/tei.c                           |    2 +-
 drivers/isdn/pcbit/Kconfig                         |    4 -
 drivers/isdn/sc/Kconfig                            |    4 -
 drivers/leds/leds-gpio.c                           |    2 -
 drivers/macintosh/therm_windtunnel.c               |    2 +-
 drivers/md/dm-crypt.c                              |    2 +-
 drivers/md/md.c                                    |   46 +--
 drivers/md/raid5.c                                 |   87 +---
 drivers/media/common/saa7146_i2c.c                 |    2 +-
 drivers/media/common/tuners/tda18271-fe.c          |    8 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    2 +-
 drivers/media/dvb/dvb-usb/anysee.c                 |    2 +-
 drivers/media/dvb/dvb-usb/ce6230.c                 |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c        |   15 +-
 drivers/media/dvb/dvb-usb/dibusb-mb.c              |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c         |    2 +-
 drivers/media/dvb/dvb-usb/usb-urb.c                |    4 +-
 drivers/media/dvb/firewire/firedtv-avc.c           |   38 +-
 drivers/media/dvb/firewire/firedtv-fe.c            |    8 +-
 drivers/media/dvb/frontends/au8522_decoder.c       |    2 +-
 drivers/media/dvb/frontends/cx24110.c              |    4 +-
 drivers/media/dvb/frontends/cx24113.c              |    2 +-
 drivers/media/dvb/frontends/dib0070.h              |    7 +-
 drivers/media/dvb/frontends/dib3000mb.c            |    2 +-
 drivers/media/dvb/frontends/dib7000p.c             |    5 -
 drivers/media/dvb/frontends/drx397xD.c             |    2 +-
 drivers/media/dvb/frontends/lgdt330x.c             |    4 +-
 drivers/media/dvb/frontends/stb0899_drv.c          |    2 +-
 drivers/media/dvb/pt1/pt1.c                        |    1 -
 drivers/media/dvb/siano/smsusb.c                   |    6 -
 drivers/media/dvb/ttpci/av7110.c                   |    4 +-
 drivers/media/dvb/ttpci/budget-patch.c             |    2 +-
 drivers/media/radio/radio-mr800.c                  |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c            |   33 +-
 drivers/media/video/cx18/cx18-driver.c             |    4 +-
 drivers/media/video/cx231xx/cx231xx-avcore.c       |    8 +-
 drivers/media/video/cx23885/cx23885-core.c         |    4 +-
 drivers/media/video/cx23885/cx23885-dvb.c          |    2 +-
 drivers/media/video/cx88/cx88-core.c               |    2 +-
 drivers/media/video/davinci/dm355_ccdc.c           |    6 +-
 drivers/media/video/davinci/dm644x_ccdc.c          |    4 +-
 drivers/media/video/davinci/vpss.c                 |    2 +-
 drivers/media/video/em28xx/em28xx-audio.c          |    5 -
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |   20 -
 drivers/media/video/gspca/mr97310a.c               |    2 +-
 drivers/media/video/gspca/ov519.c                  |    2 +-
 drivers/media/video/gspca/sonixb.c                 |    2 +-
 drivers/media/video/gspca/spca500.c                |    2 +-
 drivers/media/video/gspca/spca501.c                |    6 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |    3 +-
 drivers/media/video/gspca/sunplus.c                |    2 +-
 drivers/media/video/gspca/zc3xx.c                  |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c             |    4 +-
 drivers/media/video/ov772x.c                       |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +-
 drivers/media/video/pxa_camera.c                   |    5 +-
 drivers/media/video/s2255drv.c                     |    7 +-
 drivers/media/video/saa7134/saa7134-cards.c        |    1 -
 drivers/media/video/saa7134/saa7134-core.c         |    4 +-
 drivers/media/video/saa7134/saa7134-ts.c           |    6 +-
 drivers/media/video/saa7134/saa7134.h              |    1 -
 drivers/media/video/saa7164/saa7164-cmd.c          |    2 +-
 drivers/media/video/saa7164/saa7164-core.c         |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |    4 +-
 drivers/media/video/soc_camera.c                   |   16 +-
 drivers/media/video/uvc/uvc_ctrl.c                 |    2 +-
 drivers/media/video/uvc/uvc_video.c                |    3 +-
 drivers/media/video/zoran/zoran.h                  |    2 +-
 drivers/message/i2o/i2o_block.c                    |    2 +-
 drivers/message/i2o/iop.c                          |    4 +-
 drivers/misc/sgi-gru/grufile.c                     |    2 +-
 drivers/mmc/card/sdio_uart.c                       |   40 +-
 drivers/mmc/host/omap.c                            |    1 -
 drivers/mmc/host/s3cmci.c                          |    2 +-
 drivers/mtd/chips/Kconfig                          |    3 -
 drivers/mtd/devices/Kconfig                        |    3 -
 drivers/mtd/devices/slram.c                        |    2 +-
 drivers/mtd/lpddr/Kconfig                          |    3 -
 drivers/mtd/maps/Kconfig                           |    8 +-
 drivers/mtd/maps/Makefile                          |    2 -
 drivers/mtd/maps/sa1100-flash.c                    |    4 +-
 drivers/mtd/nand/Kconfig                           |    2 -
 drivers/mtd/nand/diskonchip.c                      |    2 +-
 drivers/mtd/nand/nand_ecc.c                        |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    2 +-
 drivers/mtd/onenand/Kconfig                        |    4 -
 drivers/mtd/ubi/Kconfig                            |    2 -
 drivers/net/82596.c                                |    2 +-
 drivers/net/amd8111e.c                             |    7 +-
 drivers/net/appletalk/cops.c                       |    2 +-
 drivers/net/ariadne.h                              |    2 +-
 drivers/net/atl1c/atl1c_main.c                     |    2 +-
 drivers/net/benet/be.h                             |    2 -
 drivers/net/benet/be_cmds.h                        |    4 +-
 drivers/net/benet/be_ethtool.c                     |    8 +-
 drivers/net/benet/be_main.c                        |   30 +-
 drivers/net/bnx2x_reg.h                            |    2 +-
 drivers/net/bonding/bond_alb.c                     |    2 +-
 drivers/net/can/Kconfig                            |   60 ++-
 drivers/net/can/dev.c                              |   23 -
 drivers/net/can/sja1000/Kconfig                    |   47 --
 drivers/net/can/usb/Kconfig                        |   10 -
 drivers/net/can/usb/Makefile                       |    2 -
 drivers/net/can/usb/ems_usb.c                      |    5 +-
 drivers/net/cassini.c                              |    5 +-
 drivers/net/cxgb3/sge.c                            |    6 +-
 drivers/net/davinci_emac.c                         |    5 +-
 drivers/net/ehea/ehea_ethtool.c                    |    4 +-
 drivers/net/forcedeth.c                            |    5 +-
 drivers/net/fsl_pq_mdio.c                          |    1 -
 drivers/net/hamradio/baycom_ser_fdx.c              |    2 +-
 drivers/net/ibm_newemac/emac.h                     |    4 +-
 drivers/net/irda/smsc-ircc2.c                      |    2 +-
 drivers/net/iseries_veth.c                         |    2 +-
 drivers/net/ixgbe/ixgbe_main.c                     |   85 +---
 drivers/net/lasi_82596.c                           |    2 +-
 drivers/net/lib82596.c                             |    2 +-
 drivers/net/macsonic.c                             |  117 ++--
 drivers/net/mlx4/en_rx.c                           |    2 +-
 drivers/net/mlx4/en_tx.c                           |    2 +-
 drivers/net/mlx4/mlx4_en.h                         |    2 +-
 drivers/net/phy/mdio-gpio.c                        |    2 +-
 drivers/net/ppp_generic.c                          |   11 +-
 drivers/net/ps3_gelic_net.c                        |    2 +-
 drivers/net/ps3_gelic_wireless.h                   |    2 +-
 drivers/net/qla3xxx.c                              |    2 +-
 drivers/net/qlge/qlge_main.c                       |    2 -
 drivers/net/qlge/qlge_mpi.c                        |    2 +-
 drivers/net/r6040.c                                |    2 +-
 drivers/net/r8169.c                                |    4 +-
 drivers/net/s2io.c                                 |    3 +-
 drivers/net/sfc/sfe4001.c                          |    4 +-
 drivers/net/sis900.c                               |    4 +-
 drivers/net/skfp/h/smc.h                           |    8 +-
 drivers/net/skfp/skfddi.c                          |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/smsc911x.c                             |    4 +-
 drivers/net/smsc911x.h                             |    2 +-
 drivers/net/spider_net.c                           |    2 +-
 drivers/net/stmmac/gmac.c                          |    2 +-
 drivers/net/stmmac/gmac.h                          |    4 +-
 drivers/net/sungem.c                               |   10 +-
 drivers/net/tokenring/ibmtr.c                      |    2 +-
 drivers/net/tokenring/smctr.c                      |    2 +-
 drivers/net/ucc_geth.c                             |    2 +-
 drivers/net/ucc_geth.h                             |   20 +-
 drivers/net/usb/Kconfig                            |    2 +-
 drivers/net/usb/cdc_ether.c                        |   42 +--
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/virtio_net.c                           |    6 +-
 drivers/net/wan/hdlc_fr.c                          |    2 +-
 drivers/net/wan/lmc/lmc_main.c                     |    2 +-
 drivers/net/wimax/i2400m/rx.c                      |    2 +-
 drivers/net/wireless/ath/ath5k/base.c              |    1 +
 drivers/net/wireless/ath/ath5k/base.h              |    2 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    2 +-
 drivers/net/wireless/ath/ath5k/led.c               |    4 -
 drivers/net/wireless/ath/ath5k/phy.c               |    6 +-
 drivers/net/wireless/ath/ath9k/rc.c                |    2 +-
 drivers/net/wireless/b43/main.c                    |    5 +-
 drivers/net/wireless/b43legacy/main.c              |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |   17 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |  151 ++++-
 drivers/net/wireless/ipw2x00/libipw.h              |    9 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |   48 ++-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c            |    5 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |    9 -
 drivers/net/wireless/iwlwifi/iwl-agn.c             |   10 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |    2 -
 drivers/net/wireless/iwmc3200wifi/hal.c            |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    2 +-
 drivers/net/wireless/libertas/ethtool.c            |   17 +-
 drivers/net/wireless/libertas/if_sdio.c            |    2 +-
 drivers/net/wireless/orinoco/hermes_dld.c          |    4 +-
 drivers/net/wireless/p54/p54usb.c                  |   10 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |   11 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |    9 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_leds.c        |    4 +-
 drivers/net/wireless/rtl818x/rtl8187_rfkill.c      |    1 -
 drivers/net/wireless/wavelan_cs.c                  |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    2 +-
 drivers/parisc/ccio-dma.c                          |    2 +-
 drivers/pci/dmar.c                                 |   52 +--
 drivers/pci/intel-iommu.c                          |   39 +--
 drivers/pci/pcie/aspm.c                            |    6 +-
 drivers/platform/Kconfig                           |    2 -
 drivers/platform/x86/eeepc-laptop.c                |   30 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/pnp/pnpbios/rsparser.c                     |    8 +-
 drivers/pps/kapi.c                                 |   20 +-
 drivers/pps/pps.c                                  |   11 +-
 drivers/ps3/ps3-sys-manager.c                      |    2 +-
 drivers/regulator/core.c                           |    3 +-
 drivers/regulator/fixed.c                          |    5 +-
 drivers/regulator/wm831x-ldo.c                     |    6 +-
 drivers/rtc/rtc-coh901331.c                        |   11 -
 drivers/rtc/rtc-ds1511.c                           |    4 +-
 drivers/rtc/rtc-pcf50633.c                         |    7 +-
 drivers/rtc/rtc-stk17ta8.c                         |    2 +-
 drivers/rtc/rtc-v3020.c                            |    4 +-
 drivers/rtc/rtc-vr41xx.c                           |    9 +-
 drivers/s390/block/dasd_proc.c                     |    2 +-
 drivers/s390/char/fs3270.c                         |    2 +-
 drivers/s390/char/monreader.c                      |    1 -
 drivers/s390/char/sclp_quiesce.c                   |   48 +--
 drivers/s390/cio/chp.c                             |    2 +-
 drivers/s390/cio/cmf.c                             |    2 +-
 drivers/sbus/char/envctrl.c                        |    4 +-
 drivers/scsi/3w-9xxx.c                             |    2 +-
 drivers/scsi/3w-xxxx.c                             |    2 +-
 drivers/scsi/53c700.c                              |    2 +-
 drivers/scsi/aacraid/aacraid.h                     |    6 +-
 drivers/scsi/aacraid/comminit.c                    |    2 +-
 drivers/scsi/aic7xxx/aic79xx.seq                   |    4 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |    2 +-
 drivers/scsi/aic7xxx/aic7xxx.seq                   |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    2 +-
 drivers/scsi/bfa/bfad_fwimg.c                      |    2 -
 drivers/scsi/bfa/bfad_im.c                         |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h   |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |    2 +-
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/scsi/gdth.c                                |    2 +-
 drivers/scsi/hptiop.c                              |    2 +-
 drivers/scsi/ipr.c                                 |   42 +-
 drivers/scsi/ipr.h                                 |    1 -
 drivers/scsi/libfc/fc_lport.c                      |    2 +-
 drivers/scsi/libiscsi_tcp.c                        |    2 +-
 drivers/scsi/libsas/sas_expander.c                 |    1 +
 drivers/scsi/lpfc/lpfc_attr.c                      |    4 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    4 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   62 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   10 +-
 drivers/scsi/megaraid.h                            |    2 +-
 drivers/scsi/megaraid/mbox_defs.h                  |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    2 +-
 drivers/scsi/ncr53c8xx.c                           |    2 +-
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/pmcraid.c                             |   16 +-
 drivers/scsi/pmcraid.h                             |    6 +-
 drivers/scsi/scsi_netlink.c                        |    2 +-
 drivers/scsi/scsi_transport_fc.c                   |    3 -
 drivers/scsi/scsi_transport_sas.c                  |    6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h                |    2 +-
 drivers/serial/8250.c                              |    2 +-
 drivers/serial/8250_pci.c                          |    8 +-
 drivers/serial/8250_pnp.c                          |    4 +-
 drivers/serial/pmac_zilog.h                        |    2 +-
 drivers/serial/sh-sci.c                            |    2 +-
 drivers/serial/ucc_uart.c                          |    2 +-
 drivers/spi/spi_stmp.c                             |    2 +-
 drivers/spi/spidev.c                               |    2 +-
 drivers/ssb/scan.c                                 |    6 +-
 drivers/staging/rtl8187se/r8180.h                  |    2 +-
 drivers/telephony/ixj.c                            |    4 +-
 drivers/thermal/thermal_sys.c                      |   10 +-
 drivers/uio/uio_pdrv_genirq.c                      |    1 -
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/class/cdc-acm.c                        |   18 +-
 drivers/usb/class/usbtmc.c                         |    2 +-
 drivers/usb/core/message.c                         |    2 +-
 drivers/usb/gadget/f_acm.c                         |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    2 +-
 drivers/usb/host/ehci-hcd.c                        |    2 +-
 drivers/usb/host/fhci-sched.c                      |    2 +-
 drivers/usb/host/ohci-hcd.c                        |    5 -
 drivers/usb/host/ohci-pci.c                        |   20 -
 drivers/usb/host/ohci-q.c                          |   18 +-
 drivers/usb/host/ohci.h                            |    9 -
 drivers/usb/host/xhci-mem.c                        |   10 +-
 drivers/usb/host/xhci-ring.c                       |    7 +-
 drivers/usb/mon/mon_bin.c                          |   11 +-
 drivers/usb/serial/cp210x.c                        |   21 -
 drivers/usb/serial/option.c                        |    2 -
 drivers/usb/wusbcore/crypto.c                      |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                     |    4 +-
 drivers/uwb/i1480/dfu/usb.c                        |    2 +-
 drivers/uwb/neh.c                                  |    2 +-
 drivers/uwb/wlp/txrx.c                             |    2 +-
 drivers/video/Kconfig                              |    2 +-
 drivers/video/atafb.c                              |    6 +
 drivers/video/atmel_lcdfb.c                        |   13 +-
 drivers/video/aty/atyfb_base.c                     |    4 +-
 drivers/video/backlight/atmel-pwm-bl.c             |    2 +-
 drivers/video/backlight/corgi_lcd.c                |    5 +-
 drivers/video/backlight/lcd.c                      |    2 +-
 drivers/video/backlight/tosa_lcd.c                 |    2 +-
 drivers/video/console/fbcon.c                      |    5 +-
 drivers/video/console/sticore.c                    |    2 +-
 drivers/video/da8xx-fb.c                           |    2 +-
 drivers/video/fb_defio.c                           |    2 +-
 drivers/video/gbefb.c                              |    2 +-
 drivers/video/msm/mddi.c                           |    1 -
 drivers/video/msm/mddi_client_nt35399.c            |    1 -
 drivers/video/msm/mddi_client_toshiba.c            |    1 -
 drivers/video/msm/mdp.c                            |   18 +
 drivers/video/msm/mdp_ppp.c                        |   20 +
 drivers/video/omap/lcd_ams_delta.c                 |    4 +-
 drivers/video/omap/lcd_mipid.c                     |    4 +-
 drivers/video/savage/savagefb_driver.c             |   20 +-
 drivers/video/sgivwfb.c                            |    4 +-
 drivers/video/stifb.c                              |    4 +-
 drivers/video/tdfxfb.c                             |    2 +-
 drivers/video/uvesafb.c                            |   28 +
 drivers/video/via/dvi.c                            |    4 +-
 drivers/video/vt8623fb.c                           |    2 +-
 drivers/watchdog/coh901327_wdt.c                   |    2 +-
 drivers/watchdog/machzwd.c                         |    2 +-
 drivers/watchdog/sb_wdog.c                         |    4 +-
 drivers/watchdog/sbc_fitpc2_wdt.c                  |    2 +-
 drivers/watchdog/wdrtas.c                          |    6 +-
 fs/binfmt_elf.c                                    |    2 +-
 fs/bio.c                                           |    2 +-
 fs/btrfs/extent-tree.c                             |  113 +---
 fs/btrfs/extent_map.c                              |    4 +-
 fs/btrfs/free-space-cache.c                        |    2 +-
 fs/btrfs/inode.c                                   |   95 +---
 fs/btrfs/root-tree.c                               |    2 +
 fs/btrfs/transaction.c                             |   19 +-
 fs/cifs/README                                     |    2 +-
 fs/cifs/cifsglob.h                                 |    2 +-
 fs/cifs/cifsproto.h                                |    1 -
 fs/cifs/connect.c                                  |    8 +
 fs/cifs/inode.c                                    |   11 +-
 fs/cifs/misc.c                                     |   14 -
 fs/cifs/readdir.c                                  |    7 +-
 fs/cifs/smbdes.c                                   |    2 +-
 fs/compat_ioctl.c                                  |    4 +-
 fs/debugfs/inode.c                                 |    6 +-
 fs/dlm/plock.c                                     |    2 +-
 fs/exec.c                                          |    8 +-
 fs/ext3/fsync.c                                    |   36 +-
 fs/ext3/inode.c                                    |   38 +--
 fs/ext3/super.c                                    |    2 -
 fs/ext4/ext4.h                                     |    1 -
 fs/ext4/extents.c                                  |   36 +-
 fs/ext4/inode.c                                    |   32 +-
 fs/ext4/mballoc.c                                  |    2 +-
 fs/ext4/namei.c                                    |   16 +-
 fs/fcntl.c                                         |    4 +-
 fs/ioctl.c                                         |    2 +-
 fs/jbd/journal.c                                   |    3 -
 fs/jbd2/journal.c                                  |    2 -
 fs/jffs2/compr.c                                   |    2 +-
 fs/jffs2/readinode.c                               |    2 +-
 fs/jffs2/xattr.c                                   |    2 +-
 fs/jfs/jfs_dmap.c                                  |    4 +-
 fs/ncpfs/ioctl.c                                   |    2 +-
 fs/nfs/nfs4proc.c                                  |    2 +-
 fs/nfsd/nfs3xdr.c                                  |    2 +-
 fs/nilfs2/cpfile.c                                 |    2 +
 fs/nilfs2/inode.c                                  |    1 +
 fs/nilfs2/ioctl.c                                  |   39 +-
 fs/ntfs/compress.c                                 |    2 +-
 fs/ntfs/file.c                                     |    4 +-
 fs/ntfs/logfile.c                                  |    2 +-
 fs/ocfs2/alloc.c                                   |    2 +-
 fs/ocfs2/blockcheck.c                              |    2 +-
 fs/ocfs2/dlm/dlmmaster.c                           |    2 +-
 fs/ocfs2/dlmglue.c                                 |    2 +-
 fs/ocfs2/file.c                                    |    3 +-
 fs/ocfs2/journal.c                                 |    2 +-
 fs/ocfs2/ocfs2.h                                   |    7 +-
 fs/ocfs2/refcounttree.c                            |   71 +--
 fs/ocfs2/super.c                                   |   20 +-
 fs/ocfs2/uptodate.c                                |    5 +
 fs/omfs/bitmap.c                                   |    2 +-
 fs/proc/array.c                                    |    2 +-
 fs/proc/base.c                                     |    3 +-
 fs/qnx4/bitmap.c                                   |    2 +-
 fs/qnx4/dir.c                                      |    6 +-
 fs/qnx4/inode.c                                    |   26 +-
 fs/qnx4/namei.c                                    |    6 +-
 fs/ubifs/recovery.c                                |    2 +-
 fs/xfs/quota/xfs_dquot.h                           |    2 +-
 fs/xfs/xfs_log_recover.c                           |    4 +-
 fs/xfs/xfs_trans_ail.c                             |   23 +-
 include/asm-generic/fcntl.h                        |   21 +-
 include/asm-generic/memory_model.h                 |    2 +-
 include/asm-generic/unistd.h                       |    2 +-
 include/linux/chio.h                               |    2 +-
 include/linux/dm-log-userspace.h                   |    2 +-
 include/linux/ext3_fs_i.h                          |    8 -
 include/linux/fb.h                                 |    6 +
 include/linux/i2c-pnx.h                            |    2 +-
 include/linux/i2c.h                                |   18 -
 include/linux/input.h                              |    4 -
 include/linux/irq.h                                |    2 +-
 include/linux/isdn_ppp.h                           |    2 +-
 include/linux/mfd/ezx-pcap.h                       |    4 +-
 include/linux/nilfs2_fs.h                          |    9 +
 include/linux/pci_ids.h                            |    4 +-
 include/linux/pktcdvd.h                            |    2 +-
 include/linux/serial_reg.h                         |    8 +-
 include/linux/spi/spi_bitbang.h                    |    2 +-
 include/linux/suspend.h                            |   21 +-
 include/linux/sysctl.h                             |   10 +-
 include/linux/videodev2.h                          |    2 +-
 include/linux/vt.h                                 |    4 +-
 include/net/netfilter/nf_conntrack.h               |    8 +-
 include/net/netfilter/nf_nat_helper.h              |    4 -
 include/net/sctp/structs.h                         |    4 +-
 include/net/tcp.h                                  |    2 +-
 include/net/wimax.h                                |    2 +-
 include/scsi/scsi_host.h                           |   29 +-
 include/sound/ac97_codec.h                         |    2 +-
 include/sound/wm8993.h                             |    2 +-
 include/video/sgivw.h                              |   11 +-
 init/Kconfig                                       |    4 +-
 ipc/msg.c                                          |    2 +-
 kernel/irq/chip.c                                  |    4 +-
 kernel/irq/spurious.c                              |    4 +-
 kernel/perf_event.c                                |    4 +-
 kernel/rcutree.c                                   |   16 +-
 kernel/rcutree.h                                   |    7 +-
 kernel/sched.c                                     |    5 +-
 kernel/time/clocksource.c                          |    2 +-
 kernel/user.c                                      |    2 +-
 kernel/workqueue.c                                 |   28 +-
 lib/Kconfig.debug                                  |    2 +-
 lib/decompress_bunzip2.c                           |    2 +-
 lib/dma-debug.c                                    |    2 +-
 lib/idr.c                                          |    4 +-
 lib/string.c                                       |   20 +-
 lib/swiotlb.c                                      |    2 +-
 mm/Kconfig                                         |    5 +-
 mm/filemap.c                                       |    2 +-
 mm/highmem.c                                       |   17 +-
 mm/kmemleak.c                                      |    4 +-
 mm/ksm.c                                           |    1 -
 mm/memcontrol.c                                    |    6 +-
 mm/memory-failure.c                                |    2 +-
 mm/memory_hotplug.c                                |   24 +-
 mm/migrate.c                                       |    2 +-
 mm/page_alloc.c                                    |    4 +-
 mm/percpu.c                                        |  121 ++---
 mm/truncate.c                                      |    2 +-
 net/8021q/vlan.c                                   |    7 +-
 net/bluetooth/bnep/core.c                          |    4 +-
 net/bluetooth/hci_conn.c                           |    1 -
 net/bluetooth/l2cap.c                              |   13 +-
 net/bridge/br_if.c                                 |    6 +-
 net/can/bcm.c                                      |   19 +-
 net/core/dev.c                                     |   11 +-
 net/core/skbuff.c                                  |    3 +-
 net/decnet/sysctl_net_decnet.c                     |    7 +-
 net/ipv4/ipip.c                                    |   32 +-
 net/ipv4/ipmr.c                                    |    4 +-
 net/ipv4/netfilter/ipt_ECN.c                       |    2 +-
 net/ipv4/netfilter/nf_nat_core.c                   |    3 -
 net/ipv4/netfilter/nf_nat_helper.c                 |   34 +-
 net/ipv4/tcp.c                                     |   19 +-
 net/irda/irlap.c                                   |   14 +-
 net/irda/irlap_event.c                             |    2 +-
 net/irda/irlmp.c                                   |    4 +-
 net/mac80211/mesh_pathtbl.c                        |    4 +-
 net/netfilter/nf_conntrack_core.c                  |    8 -
 net/netfilter/nf_conntrack_proto_tcp.c             |   64 ++-
 net/netfilter/xt_connlimit.c                       |   10 +-
 net/netlabel/netlabel_domainhash.c                 |    2 +-
 net/rose/rose_route.c                              |   16 +-
 net/sched/act_api.c                                |    2 +-
 net/sctp/associola.c                               |    4 +-
 net/sctp/sm_sideeffect.c                           |    2 +-
 net/sctp/sm_statefuns.c                            |   17 +-
 net/sctp/socket.c                                  |   40 +-
 net/sctp/transport.c                               |    3 +-
 net/sunrpc/addr.c                                  |   18 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |    2 +-
 net/wimax/op-reset.c                               |    2 +-
 samples/Kconfig                                    |    3 -
 scripts/dtc/data.c                                 |    2 +-
 scripts/dtc/dtc-lexer.l                            |    2 +-
 scripts/dtc/dtc-lexer.lex.c_shipped                |   69 +--
 scripts/dtc/libfdt/fdt_ro.c                        |    2 +-
 scripts/dtc/treesource.c                           |    2 +-
 scripts/genksyms/keywords.c_shipped                |   95 ++--
 scripts/genksyms/keywords.gperf                    |    2 -
 scripts/get_maintainer.pl                          |    4 +-
 scripts/kconfig/lex.zconf.c_shipped                |   25 +-
 scripts/kconfig/mconf.c                            |    2 +-
 scripts/kconfig/zconf.gperf                        |    2 -
 scripts/kconfig/zconf.hash.c_shipped               |    2 -
 scripts/kconfig/zconf.l                            |    6 +-
 scripts/kconfig/zconf.tab.c_shipped                |  379 +++++++------
 scripts/kconfig/zconf.y                            |   13 +-
 security/integrity/ima/ima_iint.c                  |    4 +-
 security/selinux/netlabel.c                        |    2 +-
 security/selinux/ss/services.c                     |    2 +-
 sound/Kconfig                                      |    6 +-
 sound/core/rawmidi.c                               |   42 +-
 sound/isa/cs423x/cs4236.c                          |    2 +-
 sound/isa/opti9xx/miro.c                           |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |    2 +-
 sound/oss/Kconfig                                  |    2 -
 sound/oss/dmasound/dmasound_core.c                 |    4 +-
 sound/oss/dmasound/dmasound_paula.c                |    2 +-
 sound/oss/hex2hex.c                                |    2 +-
 sound/oss/sb_common.c                              |    4 +-
 sound/oss/sb_ess.c                                 |    2 +-
 sound/pci/ca0106/ca0106_proc.c                     |    2 +-
 sound/pci/cs46xx/imgs/cwcdma.asp                   |    9 +-
 sound/pci/emu10k1/emu10k1x.c                       |    2 +-
 sound/pci/hda/hda_intel.c                          |   12 +-
 sound/pci/hda/patch_cirrus.c                       |    2 +-
 sound/pci/hda/patch_cmedia.c                       |    2 +-
 sound/pci/hda/patch_conexant.c                     |   16 +-
 sound/pci/hda/patch_nvhdmi.c                       |    2 -
 sound/pci/hda/patch_realtek.c                      |   19 +-
 sound/pci/hda/patch_sigmatel.c                     |   70 ---
 sound/pci/ice1712/ice1712.h                        |    4 +-
 sound/pci/ice1712/juli.c                           |    2 +-
 sound/pci/ice1712/prodigy_hifi.c                   |    2 +-
 sound/pci/intel8x0.c                               |    6 -
 sound/pci/rme9652/hdspm.c                          |    4 +-
 sound/sh/aica.c                                    |    1 -
 sound/soc/codecs/tlv320aic23.c                     |    2 +-
 sound/soc/codecs/uda134x.c                         |    4 +-
 sound/soc/codecs/wm8903.c                          |    6 +-
 sound/soc/codecs/wm8993.c                          |    4 +-
 sound/soc/omap/omap-pcm.c                          |    8 +-
 sound/soc/omap/omap3evm.c                          |    2 +-
 sound/soc/omap/omap3pandora.c                      |    3 +-
 sound/soc/s3c24xx/s3c24xx_simtec.c                 |    2 +-
 sound/soc/s3c24xx/s3c64xx-i2s.c                    |    2 -
 sound/soc/s6000/s6000-pcm.c                        |    2 +-
 sound/sound_core.c                                 |    2 +-
 sound/synth/emux/soundfont.c                       |    2 +-
 sound/usb/usbaudio.h                               |    2 +-
 sound/usb/usbmixer.c                               |    9 -
 tools/perf/builtin-record.c                        |    2 +-
 tools/perf/builtin-top.c                           |    2 +-
 942 files changed, 5322 insertions(+), 8961 deletions(-)

Alberto Bertogli (1):
      fs/debugfs/inode.c: fix comment typos

Amerigo Wang (1):
      fix URL in hpet.txt

Anders Larsen (1):
      qnx4fs: add missing KERN_xxx to printk() calls

Andrew Sharp (1):
      fix my email address.

André Goddard Rosa (1):
      tree-wide: fix assorted typos all over the place

Brandon Philips (1):
      sky2: fix sky2_link_down copy/paste comment error

Claudio Scordino (1):
      atmel_lcdfb.c: fix printk() type mismatch

Davidlohr Bueso (1):
      fix typos/grammos in Documentation/edac.txt

Dirk Hohndel (1):
      tree-wide: fix a very frequent spelling mistake

Dr. David Alan Gilbert (1):
      doc: fix regulator docs cut-and-pasteism

Felipe Contreras (1):
      ipc: fix unused variable warning

Jean Delvare (1):
      comment typo fix: sybsystem -> subsystem

Jiri Kosina (3):
      CIRS: turn local_save_flags() + local_irq_disable()into local_irq_save()
      CRIS: remove code that has been commented out for many years
      ataflop: remove buggy/commented-out IRQ disable from do_fd_request()

Krzysztof Halasa (3):
      drivers/ata/libata-sff.c: comment spelling fixes
      doc: Fix IRQ chip docs
      mtd: Fix comment in Kconfig

Liuweni (1):
      fix kerneldoc for set_irq_msi()

Michael Roth (1):
      Kconfig: Remove useless and sometimes wrong comments

Nick Bowler (1):
      docs: Describe the 'C' taint flag in oops-tracing.txt

Otavio Salvador (1):
      pata_cs5535: fix comment header typo

Ozan Çaglyan (1):
      ehci-hcd: Fix typo in an error message

Peng Tao (1):
      mm: fix comments for invalidate_inode_pages2()

Peter Huewe (2):
      add __init/__exit macros to omap video drivers
      media/video: add __init/__exit macros to various drivers

Randy Dunlap (1):
      docs: fix core_pipe_limit info

Rudy Matela (1):
      hdlc: spelling fix in find_pvc() comment

Thadeu Lima de Souza Cascardo (4):
      tree-wide: fix some typos and punctuation in comments
      sdio_uart: coding style fixes
      spidev: fix double "of of" in comment
      sysctl: add missing comments

Thiago Farina (1):
      sgivwfb: Make use of ARRAY_SIZE.

Uwe Kleine-König (5):
      tree-wide: fix typos "selct" + "slect" -> "select"
      tree-wide: fix typos "aquire" -> "acquire", "cumsumed" -> "consumed"
      move stk17ta8's probe function to .devinit.text
      tree-wide: fix typos "offest" -> "offset"
      tree-wide: fix typos "couter" -> "counter"

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
