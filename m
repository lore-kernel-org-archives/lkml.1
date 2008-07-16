Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYGPBf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYGPBf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYGPBfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:35:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:49673 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYGPBfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:35:05 -0400
Subject: [git pull] Please pull from powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 Jul 2008 11:34:03 +1000
Message-Id: <1216172043.7740.136.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I apologize in advance for the couple of merge commits in there. I
merged your tree yesterday in order to fix a (fairly minor) conflict,
and waited for our autobuilder to test a whole bunch of configs
overnight before asking you to pull, at which point, sfr informed me of
a bunch of this time non-trivial conflicts with whatever you pulled in
the meantime...

So here it is with 2 merge csets at the top, I'll try to do better next
time. I don't want to rebase or my sub-maintainers will hate me.

So please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

﻿This is the first batch of powerpc merges for this merge window.
There's a few morsels left for a second batch, probably next week, but
let's get that one in first. Note that it removes arch/ppc (finally !)

Thanks,
Ben.

 Documentation/kprobes.txt                          |    1 
 Documentation/powerpc/booting-without-of.txt       | 1082 --------
 Documentation/powerpc/bootwrapper.txt              |  141 +
 Documentation/powerpc/dts-bindings/fsl/board.txt   |   29 
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm.txt        |   67 +
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt    |   21 
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt    |   41 
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt    |   18 
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt    |   15 
 .../powerpc/dts-bindings/fsl/cpm_qe/network.txt    |   45 
 .../powerpc/dts-bindings/fsl/cpm_qe/qe.txt         |   58 
 .../dts-bindings/fsl/cpm_qe/qe/firmware.txt        |   24 
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt  |   51 
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt  |   60 +
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt     |   70 +
 .../powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt     |   22 
 .../powerpc/dts-bindings/fsl/cpm_qe/serial.txt     |   21 
 Documentation/powerpc/dts-bindings/fsl/diu.txt     |   18 
 Documentation/powerpc/dts-bindings/fsl/dma.txt     |  127 +
 Documentation/powerpc/dts-bindings/fsl/gtm.txt     |   31 
 Documentation/powerpc/dts-bindings/fsl/guts.txt    |   25 
 Documentation/powerpc/dts-bindings/fsl/i2c.txt     |   32 
 Documentation/powerpc/dts-bindings/fsl/lbc.txt     |   35 
 Documentation/powerpc/dts-bindings/fsl/msi-pic.txt |   36 
 Documentation/powerpc/dts-bindings/fsl/sata.txt    |   29 
 Documentation/powerpc/dts-bindings/fsl/sec.txt     |   68 +
 Documentation/powerpc/dts-bindings/fsl/spi.txt     |   24 
 Documentation/powerpc/dts-bindings/fsl/ssi.txt     |   38 
 Documentation/powerpc/dts-bindings/fsl/tsec.txt    |   69 +
 Documentation/powerpc/dts-bindings/fsl/usb.txt     |   59 
 MAINTAINERS                                        |    4 
 Makefile                                           |    1 
 arch/powerpc/Kconfig                               |   27 
 arch/powerpc/Kconfig.debug                         |   10 
 arch/powerpc/Makefile                              |   23 
 arch/powerpc/boot/Makefile                         |   13 
 arch/powerpc/boot/addnote.c                        |    2 
 arch/powerpc/boot/cuboot-c2k.c                     |  190 +
 arch/powerpc/boot/cuboot-sam440ep.c                |   49 
 arch/powerpc/boot/cuboot-warp.c                    |   47 
 arch/powerpc/boot/dts/asp834x-redboot.dts          |  282 ++
 arch/powerpc/boot/dts/bamboo.dts                   |  142 +
 arch/powerpc/boot/dts/c2k.dts                      |  371 +++
 arch/powerpc/boot/dts/canyonlands.dts              |  226 +-
 arch/powerpc/boot/dts/ebony.dts                    |  164 +
 arch/powerpc/boot/dts/ep405.dts                    |  100 -
 arch/powerpc/boot/dts/glacier.dts                  |  262 +-
 arch/powerpc/boot/dts/haleakala.dts                |  138 +
 arch/powerpc/boot/dts/holly.dts                    |  122 -
 arch/powerpc/boot/dts/katmai.dts                   |  210 +-
 arch/powerpc/boot/dts/kilauea.dts                  |  186 +
 arch/powerpc/boot/dts/ksi8560.dts                  |   64 
 arch/powerpc/boot/dts/makalu.dts                   |  186 +
 arch/powerpc/boot/dts/mpc5121ads.dts               |  310 ++
 arch/powerpc/boot/dts/mpc7448hpc2.dts              |    2 
 arch/powerpc/boot/dts/mpc8272ads.dts               |   32 
 arch/powerpc/boot/dts/mpc8313erdb.dts              |   50 
 arch/powerpc/boot/dts/mpc8315erdb.dts              |   50 
 arch/powerpc/boot/dts/mpc832x_mds.dts              |   50 
 arch/powerpc/boot/dts/mpc832x_rdb.dts              |   86 -
 arch/powerpc/boot/dts/mpc8349emitx.dts             |   47 
 arch/powerpc/boot/dts/mpc8349emitxgp.dts           |   47 
 arch/powerpc/boot/dts/mpc834x_mds.dts              |   50 
 arch/powerpc/boot/dts/mpc836x_mds.dts              |   48 
 arch/powerpc/boot/dts/mpc836x_rdk.dts              |  432 +++
 arch/powerpc/boot/dts/mpc8377_mds.dts              |   69 -
 arch/powerpc/boot/dts/mpc8377_rdb.dts              |   49 
 arch/powerpc/boot/dts/mpc8378_mds.dts              |   48 
 arch/powerpc/boot/dts/mpc8378_rdb.dts              |   49 
 arch/powerpc/boot/dts/mpc8379_mds.dts              |   48 
 arch/powerpc/boot/dts/mpc8379_rdb.dts              |   49 
 arch/powerpc/boot/dts/mpc8536ds.dts                |  432 +++
 arch/powerpc/boot/dts/mpc8540ads.dts               |   46 
 arch/powerpc/boot/dts/mpc8541cds.dts               |   57 
 arch/powerpc/boot/dts/mpc8544ds.dts                |   32 
 arch/powerpc/boot/dts/mpc8548cds.dts               |   57 
 arch/powerpc/boot/dts/mpc8555cds.dts               |   57 
 arch/powerpc/boot/dts/mpc8560ads.dts               |   44 
 arch/powerpc/boot/dts/mpc8568mds.dts               |   60 
 arch/powerpc/boot/dts/mpc8572ds.dts                |  116 +
 arch/powerpc/boot/dts/mpc8610_hpcd.dts             |   20 
 arch/powerpc/boot/dts/mpc8641_hpcn.dts             |   43 
 arch/powerpc/boot/dts/mpc866ads.dts                |   11 
 arch/powerpc/boot/dts/mpc885ads.dts                |   11 
 arch/powerpc/boot/dts/ps3.dts                      |   16 
 arch/powerpc/boot/dts/rainier.dts                  |  163 +
 arch/powerpc/boot/dts/sam440ep.dts                 |  293 ++
 arch/powerpc/boot/dts/sbc8349.dts                  |   49 
 arch/powerpc/boot/dts/sbc8548.dts                  |   57 
 arch/powerpc/boot/dts/sbc8560.dts                  |   46 
 arch/powerpc/boot/dts/sbc8641d.dts                 |   41 
 arch/powerpc/boot/dts/sequoia.dts                  |  172 +
 arch/powerpc/boot/dts/storcenter.dts               |    1 
 arch/powerpc/boot/dts/stx_gp3_8560.dts             |   45 
 arch/powerpc/boot/dts/taishan.dts                  |  241 +-
 arch/powerpc/boot/dts/tqm5200.dts                  |   14 
 arch/powerpc/boot/dts/tqm8540.dts                  |   49 
 arch/powerpc/boot/dts/tqm8541.dts                  |   60 
 arch/powerpc/boot/dts/tqm8548-bigflash.dts         |  406 +++
 arch/powerpc/boot/dts/tqm8548.dts                  |  411 +++
 arch/powerpc/boot/dts/tqm8555.dts                  |   60 
 arch/powerpc/boot/dts/tqm8560.dts                  |  114 +
 arch/powerpc/boot/dts/virtex440-ml507.dts          |  296 ++
 arch/powerpc/boot/dts/walnut.dts                   |  118 -
 arch/powerpc/boot/dts/warp.dts                     |  145 +
 arch/powerpc/boot/dts/yosemite.dts                 |  146 +
 arch/powerpc/boot/oflib.c                          |   15 
 arch/powerpc/boot/redboot-83xx.c                   |   60 
 arch/powerpc/boot/simpleboot.c                     |    6 
 arch/powerpc/boot/virtex.c                         |  100 +
 arch/powerpc/boot/wrapper                          |   32 
 arch/powerpc/boot/zImage.coff.lds.S                |    1 
 arch/powerpc/boot/zImage.lds.S                     |    1 
 arch/powerpc/configs/44x/sam440ep_defconfig        | 1192 +++++++++
 arch/powerpc/configs/44x/taishan_defconfig         |   79 +
 arch/powerpc/configs/44x/virtex5_defconfig         | 1107 ++++++++
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig    | 1128 ++++++++
 arch/powerpc/configs/85xx/tqm8548_defconfig        | 1225 +++++++++
 arch/powerpc/configs/asp8347_defconfig             | 1214 +++++++++
 arch/powerpc/configs/c2k_defconfig                 | 1872
++++++++++++++
 arch/powerpc/configs/mpc8536_ds_defconfig          | 1637 ++++++++++++
 arch/powerpc/configs/ppc44x_defconfig              |  149 +
 arch/powerpc/configs/pseries_defconfig             |    1 
 arch/powerpc/kernel/Makefile                       |    3 
 arch/powerpc/kernel/align.c                        |   70 -
 arch/powerpc/kernel/asm-offsets.c                  |   27 
 arch/powerpc/kernel/cpu_setup_44x.S                |    1 
 arch/powerpc/kernel/cputable.c                     |  105 -
 arch/powerpc/kernel/crash.c                        |    2 
 arch/powerpc/kernel/crash_dump.c                   |    7 
 arch/powerpc/kernel/dma_64.c                       |   45 
 arch/powerpc/kernel/entry_32.S                     |  158 +
 arch/powerpc/kernel/entry_64.S                     |   17 
 arch/powerpc/kernel/fpu.S                          |   41 
 arch/powerpc/kernel/head_32.S                      |    6 
 arch/powerpc/kernel/head_40x.S                     |   24 
 arch/powerpc/kernel/head_44x.S                     |  295 +-
 arch/powerpc/kernel/head_64.S                      |   82 +
 arch/powerpc/kernel/head_booke.h                   |  126 +
 arch/powerpc/kernel/head_fsl_booke.S               |   66 
 arch/powerpc/kernel/ibmebus.c                      |   16 
 arch/powerpc/kernel/idle_6xx.S                     |    2 
 arch/powerpc/kernel/idle_e500.S                    |   93 +
 arch/powerpc/kernel/iommu.c                        |   16 
 arch/powerpc/kernel/irq.c                          |   35 
 arch/powerpc/kernel/kprobes.c                      |   36 
 arch/powerpc/kernel/lparcfg.c                      |    6 
 arch/powerpc/kernel/machine_kexec_64.c             |    4 
 arch/powerpc/kernel/misc.S                         |    5 
 arch/powerpc/kernel/misc_32.S                      |    2 
 arch/powerpc/kernel/misc_64.S                      |   33 
 arch/powerpc/kernel/module.c                       |  116 +
 arch/powerpc/kernel/module_32.c                    |   72 -
 arch/powerpc/kernel/module_64.c                    |   81 -
 arch/powerpc/kernel/msi.c                          |    2 
 arch/powerpc/kernel/of_device.c                    |   48 
 arch/powerpc/kernel/ppc32.h                        |    1 
 arch/powerpc/kernel/ppc_ksyms.c                    |    3 
 arch/powerpc/kernel/process.c                      |  113 -
 arch/powerpc/kernel/prom.c                         |    4 
 arch/powerpc/kernel/prom_init.c                    |    5 
 arch/powerpc/kernel/ptrace.c                       |  114 +
 arch/powerpc/kernel/ptrace32.c                     |   14 
 arch/powerpc/kernel/rtas-proc.c                    |   14 
 arch/powerpc/kernel/rtas.c                         |    6 
 arch/powerpc/kernel/rtas_flash.c                   |    4 
 arch/powerpc/kernel/rtas_pci.c                     |    4 
 arch/powerpc/kernel/setup-common.c                 |    2 
 arch/powerpc/kernel/setup_32.c                     |   33 
 arch/powerpc/kernel/setup_64.c                     |    2 
 arch/powerpc/kernel/signal.c                       |   12 
 arch/powerpc/kernel/signal.h                       |   10 
 arch/powerpc/kernel/signal_32.c                    |  184 +
 arch/powerpc/kernel/signal_64.c                    |  101 +
 arch/powerpc/kernel/smp.c                          |    4 
 arch/powerpc/kernel/softemu8xx.c                   |    4 
 arch/powerpc/kernel/stacktrace.c                   |   36 
 arch/powerpc/kernel/syscalls.c                     |    3 
 arch/powerpc/kernel/time.c                         |   14 
 arch/powerpc/kernel/traps.c                        |   55 
 arch/powerpc/kernel/vdso.c                         |   10 
 arch/powerpc/kernel/vdso32/vdso32.lds.S            |    5 
 arch/powerpc/kernel/vdso64/vdso64.lds.S            |   11 
 arch/powerpc/kernel/vmlinux.lds.S                  |    8 
 arch/powerpc/lib/Makefile                          |    4 
 arch/powerpc/lib/code-patching.c                   |  448 +++
 arch/powerpc/lib/dma-noncoherent.c                 |   11 
 arch/powerpc/lib/feature-fixups-test.S             |  742 +++++
 arch/powerpc/lib/feature-fixups.c                  |  351 +++
 arch/powerpc/math-emu/math.c                       |   56 
 arch/powerpc/mm/44x_mmu.c                          |   29 
 arch/powerpc/mm/fault.c                            |    3 
 arch/powerpc/mm/hash_low_64.S                      |   17 
 arch/powerpc/mm/hash_utils_64.c                    |   42 
 arch/powerpc/mm/hugetlbpage.c                      |   13 
 arch/powerpc/mm/init_32.c                          |    7 
 arch/powerpc/mm/init_64.c                          |    4 
 arch/powerpc/mm/mem.c                              |    9 
 arch/powerpc/mm/mmu_decl.h                         |    6 
 arch/powerpc/mm/numa.c                             |  310 ++
 arch/powerpc/mm/pgtable_32.c                       |    6 
 arch/powerpc/mm/ppc_mmu_32.c                       |   27 
 arch/powerpc/mm/slice.c                            |  177 +
 arch/powerpc/mm/stab.c                             |    4 
 arch/powerpc/mm/tlb_64.c                           |    7 
 arch/powerpc/platforms/44x/Kconfig                 |   35 
 arch/powerpc/platforms/44x/Makefile                |    2 
 arch/powerpc/platforms/44x/sam440ep.c              |   79 +
 arch/powerpc/platforms/44x/virtex.c                |   60 
 arch/powerpc/platforms/44x/warp-nand.c             |   57 
 arch/powerpc/platforms/44x/warp.c                  |  293 ++
 arch/powerpc/platforms/512x/Kconfig                |   17 
 arch/powerpc/platforms/512x/Makefile               |    4 
 arch/powerpc/platforms/512x/clock.c                |  729 +++++
 arch/powerpc/platforms/512x/mpc5121_ads.c          |   69 -
 arch/powerpc/platforms/512x/mpc5121_ads.h          |   16 
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c     |  204 ++
 arch/powerpc/platforms/512x/mpc5121_generic.c      |   58 
 arch/powerpc/platforms/512x/mpc512x.h              |   17 
 arch/powerpc/platforms/512x/mpc512x_shared.c       |   83 +
 arch/powerpc/platforms/52xx/mpc52xx_pci.c          |    3 
 arch/powerpc/platforms/82xx/Kconfig                |   11 
 arch/powerpc/platforms/82xx/mpc8272_ads.c          |    4 
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c       |    2 
 arch/powerpc/platforms/83xx/Kconfig                |   30 
 arch/powerpc/platforms/83xx/Makefile               |    2 
 arch/powerpc/platforms/83xx/asp834x.c              |   90 +
 arch/powerpc/platforms/83xx/mpc836x_rdk.c          |  102 +
 arch/powerpc/platforms/85xx/Kconfig                |   14 
 arch/powerpc/platforms/85xx/Makefile               |    1 
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |  125 +
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |    8 
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |   14 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |   12 
 arch/powerpc/platforms/85xx/tqm85xx.c              |   23 
 arch/powerpc/platforms/86xx/Kconfig                |   16 
 arch/powerpc/platforms/86xx/Makefile               |    1 
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |   25 
 arch/powerpc/platforms/86xx/mpc86xx.h              |    3 
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |   64 
 arch/powerpc/platforms/86xx/mpc86xx_smp.c          |    6 
 arch/powerpc/platforms/86xx/pic.c                  |   78 +
 arch/powerpc/platforms/86xx/sbc8641d.c             |   25 
 arch/powerpc/platforms/8xx/mpc86xads_setup.c       |    4 
 arch/powerpc/platforms/8xx/mpc885ads_setup.c       |    3 
 arch/powerpc/platforms/Kconfig                     |   33 
 arch/powerpc/platforms/Kconfig.cputype             |   25 
 arch/powerpc/platforms/cell/axon_msi.c             |   76 -
 arch/powerpc/platforms/cell/beat_htab.c            |    4 
 arch/powerpc/platforms/cell/iommu.c                |    8 
 arch/powerpc/platforms/cell/ras.c                  |   22 
 arch/powerpc/platforms/cell/spider-pic.c           |    2 
 arch/powerpc/platforms/cell/spufs/context.c        |   12 
 arch/powerpc/platforms/cell/spufs/file.c           |  203 +
 arch/powerpc/platforms/cell/spufs/inode.c          |   47 
 arch/powerpc/platforms/cell/spufs/sched.c          |    9 
 arch/powerpc/platforms/cell/spufs/spufs.h          |   19 
 arch/powerpc/platforms/cell/spufs/sputrace.c       |    8 
 arch/powerpc/platforms/chrp/setup.c                |    7 
 arch/powerpc/platforms/embedded6xx/Kconfig         |   10 
 arch/powerpc/platforms/embedded6xx/Makefile        |    1 
 arch/powerpc/platforms/embedded6xx/c2k.c           |  158 +
 arch/powerpc/platforms/iseries/iommu.c             |    4 
 arch/powerpc/platforms/maple/time.c                |    2 
 arch/powerpc/platforms/powermac/pic.c              |    8 
 arch/powerpc/platforms/powermac/smp.c              |    6 
 arch/powerpc/platforms/ps3/system-bus.c            |   38 
 arch/powerpc/platforms/pseries/eeh.c               |   14 
 arch/powerpc/platforms/pseries/firmware.c          |    1 
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  117 +
 arch/powerpc/platforms/pseries/iommu.c             |   15 
 arch/powerpc/platforms/pseries/kexec.c             |    2 
 arch/powerpc/platforms/pseries/lpar.c              |    4 
 arch/powerpc/platforms/pseries/ras.c               |    2 
 arch/powerpc/platforms/pseries/reconfig.c          |   38 
 arch/powerpc/platforms/pseries/rtasd.c             |    4 
 arch/powerpc/platforms/pseries/setup.c             |    4 
 arch/powerpc/sysdev/6xx-suspend.S                  |   52 
 arch/powerpc/sysdev/Makefile                       |    9 
 arch/powerpc/sysdev/bestcomm/bestcomm.c            |    2 
 arch/powerpc/sysdev/bestcomm/gen_bd.c              |   95 +
 arch/powerpc/sysdev/bestcomm/gen_bd.h              |    5 
 arch/powerpc/sysdev/bestcomm/sram.c                |    2 
 arch/powerpc/sysdev/cpm1.c                         |    2 
 arch/powerpc/sysdev/cpm2_pic.c                     |    2 
 arch/powerpc/sysdev/cpm_common.c                   |   19 
 arch/powerpc/sysdev/dcr.c                          |  156 +
 arch/powerpc/sysdev/fsl_gtm.c                      |  434 +++
 arch/powerpc/sysdev/fsl_msi.c                      |  429 +++
 arch/powerpc/sysdev/fsl_msi.h                      |   42 
 arch/powerpc/sysdev/fsl_pci.c                      |   14 
 arch/powerpc/sysdev/fsl_soc.c                      |  122 -
 arch/powerpc/sysdev/i8259.c                        |    2 
 arch/powerpc/sysdev/indirect_pci.c                 |    6 
 arch/powerpc/sysdev/ipic.c                         |   16 
 arch/powerpc/sysdev/mpic.c                         |   18 
 arch/powerpc/sysdev/mpic_msi.c                     |    1 
 arch/powerpc/sysdev/mpic_pasemi_msi.c              |    6 
 arch/powerpc/sysdev/mpic_u3msi.c                   |    8 
 arch/powerpc/sysdev/mv64x60_dev.c                  |   10 
 arch/powerpc/sysdev/ppc4xx_pci.c                   |   14 
 arch/powerpc/sysdev/qe_lib/Kconfig                 |   13 
 arch/powerpc/sysdev/qe_lib/Makefile                |    2 
 arch/powerpc/sysdev/qe_lib/gpio.c                  |  149 +
 arch/powerpc/sysdev/qe_lib/qe.c                    |   94 -
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |   14 
 arch/powerpc/sysdev/qe_lib/qe_io.c                 |   94 -
 arch/powerpc/sysdev/qe_lib/ucc.c                   |    7 
 arch/powerpc/sysdev/qe_lib/usb.c                   |   55 
 arch/powerpc/sysdev/tsi108_pci.c                   |    3 
 arch/powerpc/sysdev/uic.c                          |    6 
 arch/powerpc/xmon/xmon.c                           |   66 
 arch/ppc/.gitignore                                |    1 
 arch/ppc/4xx_io/Makefile                           |    6 
 arch/ppc/4xx_io/serial_sicc.c                      | 2005
---------------
 arch/ppc/8260_io/Kconfig                           |   65 
 arch/ppc/8260_io/Makefile                          |    6 
 arch/ppc/8260_io/enet.c                            |  865 ------
 arch/ppc/8260_io/fcc_enet.c                        | 2379
-----------------
 arch/ppc/8xx_io/Kconfig                            |  134 -
 arch/ppc/8xx_io/Makefile                           |    9 
 arch/ppc/8xx_io/commproc.c                         |  432 ---
 arch/ppc/8xx_io/enet.c                             |  982 -------
 arch/ppc/8xx_io/fec.c                              | 1983
---------------
 arch/ppc/8xx_io/micropatch.c                       |  743 -----
 arch/ppc/Kconfig                                   | 1186 ---------
 arch/ppc/Kconfig.debug                             |   66 
 arch/ppc/Makefile                                  |  135 -
 arch/ppc/boot/Makefile                             |   37 
 arch/ppc/boot/common/Makefile                      |   10 
 arch/ppc/boot/common/bootinfo.c                    |   68 -
 arch/ppc/boot/common/crt0.S                        |   80 -
 arch/ppc/boot/common/misc-common.c                 |  555 ----
 arch/ppc/boot/common/ns16550.c                     |  103 -
 arch/ppc/boot/common/serial_stub.c                 |   21 
 arch/ppc/boot/common/string.S                      |  150 -
 arch/ppc/boot/common/util.S                        |  293 --
 arch/ppc/boot/images/.gitignore                    |    6 
 arch/ppc/boot/images/Makefile                      |   34 
 arch/ppc/boot/include/cpc700.h                     |   26 
 arch/ppc/boot/include/iso_font.h                   |  257 --
 arch/ppc/boot/include/mpc10x.h                     |   63 
 arch/ppc/boot/include/mpsc_defs.h                  |  146 -
 arch/ppc/boot/include/nonstdio.h                   |   34 
 arch/ppc/boot/include/of1275.h                     |   42 
 arch/ppc/boot/include/rs6000.h                     |  243 --
 arch/ppc/boot/include/serial.h                     |   46 
 arch/ppc/boot/ld.script                            |   85 -
 arch/ppc/boot/lib/.gitignore                       |    3 
 arch/ppc/boot/lib/Makefile                         |   23 
 arch/ppc/boot/lib/div64.S                          |   58 
 arch/ppc/boot/lib/kbd.c                            |  248 --
 arch/ppc/boot/lib/vreset.c                         |  805 ------
 arch/ppc/boot/of1275/Makefile                      |    6 
 arch/ppc/boot/of1275/call_prom.c                   |   74 -
 arch/ppc/boot/of1275/claim.c                       |   92 -
 arch/ppc/boot/of1275/enter.c                       |   22 
 arch/ppc/boot/of1275/exit.c                        |   24 
 arch/ppc/boot/of1275/finddevice.c                  |   16 
 arch/ppc/boot/of1275/getprop.c                     |   37 
 arch/ppc/boot/of1275/map.c                         |   48 
 arch/ppc/boot/of1275/ofinit.c                      |   27 
 arch/ppc/boot/of1275/ofstdio.c                     |   32 
 arch/ppc/boot/of1275/read.c                        |   35 
 arch/ppc/boot/of1275/release.c                     |   30 
 arch/ppc/boot/of1275/write.c                       |   35 
 arch/ppc/boot/simple/Makefile                      |  277 --
 arch/ppc/boot/simple/chrpmap.c                     |   12 
 arch/ppc/boot/simple/clear.S                       |   19 
 arch/ppc/boot/simple/cpc700_memory.c               |   34 
 arch/ppc/boot/simple/dummy.c                       |    4 
 arch/ppc/boot/simple/embed_config.c                |  938 -------
 arch/ppc/boot/simple/head.S                        |  137 -
 arch/ppc/boot/simple/iic.c                         |  214 --
 arch/ppc/boot/simple/m8260_tty.c                   |  325 --
 arch/ppc/boot/simple/m8xx_tty.c                    |  289 --
 arch/ppc/boot/simple/misc-chestnut.c               |   32 
 arch/ppc/boot/simple/misc-cpci690.c                |   65 
 arch/ppc/boot/simple/misc-embedded.c               |  276 --
 arch/ppc/boot/simple/misc-ev64260.c                |   54 
 arch/ppc/boot/simple/misc-ev64360.c                |   42 
 arch/ppc/boot/simple/misc-katana.c                 |   42 
 arch/ppc/boot/simple/misc-mv64x60.c                |   85 -
 arch/ppc/boot/simple/misc-prep.c                   |  209 --
 arch/ppc/boot/simple/misc-radstone_ppc7d.c         |   24 
 arch/ppc/boot/simple/misc-spruce.c                 |  271 --
 arch/ppc/boot/simple/misc.c                        |  278 --
 arch/ppc/boot/simple/mpc10x_memory.c               |  109 -
 arch/ppc/boot/simple/mpc52xx_tty.c                 |  137 -
 arch/ppc/boot/simple/mv64x60_tty.c                 |  364 ---
 arch/ppc/boot/simple/openbios.c                    |  128 -
 arch/ppc/boot/simple/pci.c                         |  274 --
 arch/ppc/boot/simple/pibs.c                        |  104 -
 arch/ppc/boot/simple/prepmap.c                     |   12 
 arch/ppc/boot/simple/qspan_pci.c                   |  269 --
 arch/ppc/boot/simple/relocate.S                    |  213 --
 arch/ppc/boot/simple/rw4/ppc_40x.h                 |  664 -----
 arch/ppc/boot/simple/rw4/rw4_init.S                |   78 -
 arch/ppc/boot/simple/rw4/rw4_init_brd.S            | 1125 --------
 arch/ppc/boot/simple/rw4/stb.h                     |  239 --
 arch/ppc/boot/simple/uartlite_tty.c                |   45 
 arch/ppc/boot/utils/.gitignore                     |    3 
 arch/ppc/boot/utils/elf.pl                         |   33 
 arch/ppc/boot/utils/mkbugboot.c                    |  147 -
 arch/ppc/boot/utils/mkprep.c                       |  241 --
 arch/ppc/boot/utils/mktree.c                       |  152 -
 arch/ppc/configs/FADS_defconfig                    |  520 ----
 arch/ppc/configs/IVMS8_defconfig                   |  548 ----
 arch/ppc/configs/TQM823L_defconfig                 |  521 ----
 arch/ppc/configs/TQM8260_defconfig                 |  499 ----
 arch/ppc/configs/TQM850L_defconfig                 |  521 ----
 arch/ppc/configs/TQM860L_defconfig                 |  549 ----
 arch/ppc/configs/bamboo_defconfig                  |  944 -------
 arch/ppc/configs/bseip_defconfig                   |  517 ----
 arch/ppc/configs/bubinga_defconfig                 |  592 ----
 arch/ppc/configs/chestnut_defconfig                |  794 ------
 arch/ppc/configs/cpci405_defconfig                 |  631 -----
 arch/ppc/configs/cpci690_defconfig                 |  798 ------
 arch/ppc/configs/ebony_defconfig                   |  585 ----
 arch/ppc/configs/ep405_defconfig                   |  572 ----
 arch/ppc/configs/est8260_defconfig                 |  491 ----
 arch/ppc/configs/ev64260_defconfig                 |  758 ------
 arch/ppc/configs/ev64360_defconfig                 |  817 ------
 arch/ppc/configs/hdpu_defconfig                    |  890 -------
 arch/ppc/configs/katana_defconfig                  |  948 -------
 arch/ppc/configs/lite5200_defconfig                |  436 ---
 arch/ppc/configs/lopec_defconfig                   |  814 ------
 arch/ppc/configs/luan_defconfig                    |  668 -----
 arch/ppc/configs/mbx_defconfig                     |  512 ----
 arch/ppc/configs/ml300_defconfig                   |  739 -----
 arch/ppc/configs/ml403_defconfig                   |  740 -----
 arch/ppc/configs/mvme5100_defconfig                |  746 -----
 arch/ppc/configs/ocotea_defconfig                  |  599 ----
 arch/ppc/configs/pplus_defconfig                   |  720 -----
 arch/ppc/configs/prep_defconfig                    | 1679 ------------
 arch/ppc/configs/prpmc750_defconfig                |  594 ----
 arch/ppc/configs/prpmc800_defconfig                |  656 -----
 arch/ppc/configs/radstone_ppc7d_defconfig          |  991 -------
 arch/ppc/configs/redwood5_defconfig                |  557 ----
 arch/ppc/configs/redwood6_defconfig                |  535 ----
 arch/ppc/configs/rpx8260_defconfig                 |  555 ----
 arch/ppc/configs/rpxcllf_defconfig                 |  582 ----
 arch/ppc/configs/rpxlite_defconfig                 |  581 ----
 arch/ppc/configs/sandpoint_defconfig               |  737 -----
 arch/ppc/configs/spruce_defconfig                  |  577 ----
 arch/ppc/configs/sycamore_defconfig                |  663 -----
 arch/ppc/configs/taishan_defconfig                 | 1077 --------
 arch/ppc/configs/walnut_defconfig                  |  578 ----
 arch/ppc/kernel/Makefile                           |   21 
 arch/ppc/kernel/asm-offsets.c                      |  164 -
 arch/ppc/kernel/cpu_setup_power4.S                 |  197 -
 arch/ppc/kernel/entry.S                            |  960 -------
 arch/ppc/kernel/head.S                             | 1220 ---------
 arch/ppc/kernel/head_44x.S                         |  769 ------
 arch/ppc/kernel/head_4xx.S                         | 1021 --------
 arch/ppc/kernel/head_8xx.S                         |  959 -------
 arch/ppc/kernel/head_booke.h                       |  308 --
 arch/ppc/kernel/machine_kexec.c                    |  118 -
 arch/ppc/kernel/misc.S                             |  868 ------
 arch/ppc/kernel/pci.c                              | 1233 ---------
 arch/ppc/kernel/ppc-stub.c                         |  866 ------
 arch/ppc/kernel/ppc_htab.c                         |  464 ---
 arch/ppc/kernel/ppc_ksyms.c                        |  258 --
 arch/ppc/kernel/relocate_kernel.S                  |  123 -
 arch/ppc/kernel/setup.c                            |  572 ----
 arch/ppc/kernel/smp-tbsync.c                       |  180 -
 arch/ppc/kernel/smp.c                              |  414 ---
 arch/ppc/kernel/softemu8xx.c                       |  147 -
 arch/ppc/kernel/time.c                             |  445 ---
 arch/ppc/kernel/traps.c                            |  826 ------
 arch/ppc/kernel/vmlinux.lds.S                      |  164 -
 arch/ppc/lib/Makefile                              |    5 
 arch/ppc/lib/checksum.S                            |  225 --
 arch/ppc/lib/div64.S                               |   58 
 arch/ppc/lib/locks.c                               |  189 -
 arch/ppc/lib/string.S                              |  732 -----
 arch/ppc/mm/44x_mmu.c                              |  101 -
 arch/ppc/mm/4xx_mmu.c                              |  135 -
 arch/ppc/mm/Makefile                               |   10 
 arch/ppc/mm/fault.c                                |  436 ---
 arch/ppc/mm/hashtable.S                            |  617 -----
 arch/ppc/mm/init.c                                 |  603 ----
 arch/ppc/mm/mem_pieces.c                           |  162 -
 arch/ppc/mm/mem_pieces.h                           |   48 
 arch/ppc/mm/mmu_context.c                          |   85 -
 arch/ppc/mm/mmu_decl.h                             |   79 -
 arch/ppc/mm/pgtable.c                              |  403 ---
 arch/ppc/mm/ppc_mmu.c                              |  269 --
 arch/ppc/mm/tlb.c                                  |  183 -
 arch/ppc/platforms/4xx/Kconfig                     |  285 --
 arch/ppc/platforms/4xx/Makefile                    |   31 
 arch/ppc/platforms/4xx/bamboo.c                    |  442 ---
 arch/ppc/platforms/4xx/bamboo.h                    |  133 -
 arch/ppc/platforms/4xx/bubinga.c                   |  265 --
 arch/ppc/platforms/4xx/bubinga.h                   |   54 
 arch/ppc/platforms/4xx/cpci405.c                   |  201 -
 arch/ppc/platforms/4xx/cpci405.h                   |   28 
 arch/ppc/platforms/4xx/ebony.c                     |  334 --
 arch/ppc/platforms/4xx/ebony.h                     |   97 -
 arch/ppc/platforms/4xx/ep405.c                     |  196 -
 arch/ppc/platforms/4xx/ep405.h                     |   52 
 arch/ppc/platforms/4xx/ibm405ep.c                  |  141 -
 arch/ppc/platforms/4xx/ibm405ep.h                  |  145 -
 arch/ppc/platforms/4xx/ibm405gp.c                  |  120 -
 arch/ppc/platforms/4xx/ibm405gp.h                  |  148 -
 arch/ppc/platforms/4xx/ibm405gpr.c                 |  115 -
 arch/ppc/platforms/4xx/ibm405gpr.h                 |  148 -
 arch/ppc/platforms/4xx/ibm440ep.c                  |  220 --
 arch/ppc/platforms/4xx/ibm440ep.h                  |   73 -
 arch/ppc/platforms/4xx/ibm440gp.c                  |  163 -
 arch/ppc/platforms/4xx/ibm440gp.h                  |   63 
 arch/ppc/platforms/4xx/ibm440gx.c                  |  231 --
 arch/ppc/platforms/4xx/ibm440gx.h                  |   71 -
 arch/ppc/platforms/4xx/ibm440sp.c                  |  129 -
 arch/ppc/platforms/4xx/ibm440sp.h                  |   61 
 arch/ppc/platforms/4xx/ibmnp405h.c                 |  170 -
 arch/ppc/platforms/4xx/ibmnp405h.h                 |  154 -
 arch/ppc/platforms/4xx/ibmstb4.c                   |  122 -
 arch/ppc/platforms/4xx/ibmstb4.h                   |  235 --
 arch/ppc/platforms/4xx/ibmstbx25.c                 |   66 
 arch/ppc/platforms/4xx/ibmstbx25.h                 |  258 --
 arch/ppc/platforms/4xx/luan.c                      |  371 ---
 arch/ppc/platforms/4xx/luan.h                      |   77 -
 arch/ppc/platforms/4xx/ocotea.c                    |  350 ---
 arch/ppc/platforms/4xx/ocotea.h                    |   94 -
 arch/ppc/platforms/4xx/ppc440spe.c                 |  146 -
 arch/ppc/platforms/4xx/ppc440spe.h                 |   63 
 arch/ppc/platforms/4xx/redwood5.c                  |  120 -
 arch/ppc/platforms/4xx/redwood5.h                  |   52 
 arch/ppc/platforms/4xx/redwood6.c                  |  156 -
 arch/ppc/platforms/4xx/redwood6.h                  |   53 
 arch/ppc/platforms/4xx/sycamore.c                  |  272 --
 arch/ppc/platforms/4xx/sycamore.h                  |   49 
 arch/ppc/platforms/4xx/taishan.c                   |  395 ---
 arch/ppc/platforms/4xx/taishan.h                   |   67 
 arch/ppc/platforms/4xx/virtex.h                    |   35 
 arch/ppc/platforms/4xx/walnut.c                    |  246 --
 arch/ppc/platforms/4xx/walnut.h                    |   52 
 arch/ppc/platforms/4xx/xilinx_ml300.c              |  118 -
 arch/ppc/platforms/4xx/xilinx_ml403.c              |  120 -
 arch/ppc/platforms/4xx/xparameters/xparameters.h   |  104 -
 .../platforms/4xx/xparameters/xparameters_ml300.h  |  310 ---
 .../platforms/4xx/xparameters/xparameters_ml403.h  |  243 --
 arch/ppc/platforms/4xx/yucca.c                     |  393 ---
 arch/ppc/platforms/4xx/yucca.h                     |  108 -
 arch/ppc/platforms/Makefile                        |   25 
 arch/ppc/platforms/bseip.h                         |   38 
 arch/ppc/platforms/ccm.h                           |   27 
 arch/ppc/platforms/chestnut.c                      |  574 ----
 arch/ppc/platforms/chestnut.h                      |  127 -
 arch/ppc/platforms/cpci690.c                       |  453 ---
 arch/ppc/platforms/cpci690.h                       |   74 -
 arch/ppc/platforms/est8260.h                       |   35 
 arch/ppc/platforms/ev64260.c                       |  649 -----
 arch/ppc/platforms/ev64260.h                       |  126 -
 arch/ppc/platforms/ev64360.c                       |  517 ----
 arch/ppc/platforms/ev64360.h                       |  114 -
 arch/ppc/platforms/fads.h                          |  130 -
 arch/ppc/platforms/hdpu.c                          | 1015 -------
 arch/ppc/platforms/hdpu.h                          |   80 -
 arch/ppc/platforms/hermes.h                        |   26 
 arch/ppc/platforms/ip860.h                         |   35 
 arch/ppc/platforms/ivms8.h                         |   55 
 arch/ppc/platforms/katana.c                        |  902 -------
 arch/ppc/platforms/katana.h                        |  253 --
 arch/ppc/platforms/lantec.h                        |   20 
 arch/ppc/platforms/lite5200.c                      |  245 --
 arch/ppc/platforms/lite5200.h                      |   21 
 arch/ppc/platforms/lopec.c                         |  310 --
 arch/ppc/platforms/lopec.h                         |   39 
 arch/ppc/platforms/lwmon.h                         |   59 
 arch/ppc/platforms/mbx.h                           |  117 -
 arch/ppc/platforms/mpc866ads_setup.c               |  413 ---
 arch/ppc/platforms/mvme5100.c                      |  340 ---
 arch/ppc/platforms/mvme5100.h                      |   91 -
 arch/ppc/platforms/pal4.h                          |   40 
 arch/ppc/platforms/pal4_pci.c                      |   75 -
 arch/ppc/platforms/pal4_serial.h                   |   37 
 arch/ppc/platforms/pal4_setup.c                    |  173 -
 arch/ppc/platforms/pcu_e.h                         |   27 
 arch/ppc/platforms/powerpmc250.c                   |  378 ---
 arch/ppc/platforms/powerpmc250.h                   |   52 
 arch/ppc/platforms/pplus.c                         |  844 ------
 arch/ppc/platforms/pplus.h                         |   65 
 arch/ppc/platforms/prep_pci.c                      | 1339 ----------
 arch/ppc/platforms/prep_setup.c                    | 1043 --------
 arch/ppc/platforms/prpmc750.c                      |  360 ---
 arch/ppc/platforms/prpmc750.h                      |   95 -
 arch/ppc/platforms/prpmc800.c                      |  472 ---
 arch/ppc/platforms/prpmc800.h                      |   82 -
 arch/ppc/platforms/radstone_ppc7d.c                | 1492 -----------
 arch/ppc/platforms/radstone_ppc7d.h                |  433 ---
 arch/ppc/platforms/residual.c                      | 1034 --------
 arch/ppc/platforms/rpx8260.h                       |   81 -
 arch/ppc/platforms/rpxclassic.h                    |  114 -
 arch/ppc/platforms/rpxlite.h                       |   91 -
 arch/ppc/platforms/sandpoint.c                     |  651 -----
 arch/ppc/platforms/sandpoint.h                     |   75 -
 arch/ppc/platforms/sbc82xx.c                       |  256 --
 arch/ppc/platforms/sbc82xx.h                       |   36 
 arch/ppc/platforms/sbs8260.h                       |   28 
 arch/ppc/platforms/spruce.c                        |  322 --
 arch/ppc/platforms/spruce.h                        |   71 -
 arch/ppc/platforms/tqm8260.h                       |   22 
 arch/ppc/platforms/tqm8260_setup.c                 |   42 
 arch/ppc/platforms/tqm8xx.h                        |  155 -
 arch/ppc/syslib/Makefile                           |   96 -
 arch/ppc/syslib/btext.c                            |  860 ------
 arch/ppc/syslib/cpc700.h                           |   96 -
 arch/ppc/syslib/cpc700_pic.c                       |  181 -
 arch/ppc/syslib/cpm2_common.c                      |  196 -
 arch/ppc/syslib/cpm2_pic.c                         |  177 -
 arch/ppc/syslib/cpm2_pic.h                         |    8 
 arch/ppc/syslib/gen550.h                           |   14 
 arch/ppc/syslib/gen550_dbg.c                       |  179 -
 arch/ppc/syslib/gen550_kgdb.c                      |   83 -
 arch/ppc/syslib/gt64260_pic.c                      |  323 --
 arch/ppc/syslib/harrier.c                          |  300 --
 arch/ppc/syslib/hawk_common.c                      |  317 --
 arch/ppc/syslib/i8259.c                            |  213 --
 arch/ppc/syslib/ibm440gp_common.c                  |   73 -
 arch/ppc/syslib/ibm440gp_common.h                  |   32 
 arch/ppc/syslib/ibm440gx_common.c                  |  294 --
 arch/ppc/syslib/ibm440gx_common.h                  |   58 
 arch/ppc/syslib/ibm440sp_common.c                  |   68 -
 arch/ppc/syslib/ibm440sp_common.h                  |   23 
 arch/ppc/syslib/ibm44x_common.c                    |  235 --
 arch/ppc/syslib/ibm44x_common.h                    |   45 
 arch/ppc/syslib/ibm_ocp.c                          |   10 
 arch/ppc/syslib/indirect_pci.c                     |  134 -
 arch/ppc/syslib/m8260_pci_erratum9.c               |  455 ---
 arch/ppc/syslib/m8260_setup.c                      |  266 --
 arch/ppc/syslib/m82xx_pci.c                        |  346 ---
 arch/ppc/syslib/m82xx_pci.h                        |   92 -
 arch/ppc/syslib/m8xx_setup.c                       |  465 ---
 arch/ppc/syslib/m8xx_wdt.c                         |  148 -
 arch/ppc/syslib/m8xx_wdt.h                         |   20 
 arch/ppc/syslib/mpc10x_common.c                    |  654 -----
 arch/ppc/syslib/mpc52xx_devices.c                  |  317 --
 arch/ppc/syslib/mpc52xx_pci.c                      |  289 --
 arch/ppc/syslib/mpc52xx_pci.h                      |  137 -
 arch/ppc/syslib/mpc52xx_pic.c                      |  254 --
 arch/ppc/syslib/mpc52xx_setup.c                    |  313 --
 arch/ppc/syslib/mpc52xx_sys.c                      |   36 
 arch/ppc/syslib/mpc8xx_devices.c                   |  243 --
 arch/ppc/syslib/mpc8xx_sys.c                       |   61 
 arch/ppc/syslib/mv64360_pic.c                      |  423 ---
 arch/ppc/syslib/mv64x60.c                          | 2485
------------------
 arch/ppc/syslib/mv64x60_dbg.c                      |  121 -
 arch/ppc/syslib/mv64x60_win.c                      | 1165 ---------
 arch/ppc/syslib/ocp.c                              |  482 ----
 arch/ppc/syslib/open_pic.c                         | 1087 --------
 arch/ppc/syslib/open_pic2.c                        |  710 -----
 arch/ppc/syslib/open_pic_defs.h                    |  287 --
 arch/ppc/syslib/pci_auto.c                         |  515 ----
 arch/ppc/syslib/ppc403_pic.c                       |  125 -
 arch/ppc/syslib/ppc405_pci.c                       |  170 -
 arch/ppc/syslib/ppc440spe_pcie.c                   |  441 ---
 arch/ppc/syslib/ppc440spe_pcie.h                   |  149 -
 arch/ppc/syslib/ppc4xx_dma.c                       |  710 -----
 arch/ppc/syslib/ppc4xx_pic.c                       |  284 --
 arch/ppc/syslib/ppc4xx_setup.c                     |  271 --
 arch/ppc/syslib/ppc4xx_sgdma.c                     |  464 ---
 arch/ppc/syslib/ppc8xx_pic.c                       |  126 -
 arch/ppc/syslib/ppc8xx_pic.h                       |   19 
 arch/ppc/syslib/ppc_sys.c                          |  329 --
 arch/ppc/syslib/pq2_devices.c                      |  393 ---
 arch/ppc/syslib/pq2_sys.c                          |  203 -
 arch/ppc/syslib/prep_nvram.c                       |  135 -
 arch/ppc/syslib/qspan_pci.c                        |  380 ---
 arch/ppc/syslib/todc_time.c                        |  511 ----
 arch/ppc/syslib/virtex_devices.c                   |  276 --
 arch/ppc/syslib/virtex_devices.h                   |   35 
 arch/ppc/syslib/xilinx_pic.c                       |  153 -
 arch/ppc/xmon/Makefile                             |    8 
 arch/ppc/xmon/ansidecl.h                           |  141 -
 arch/ppc/xmon/nonstdio.h                           |   22 
 arch/ppc/xmon/ppc-dis.c                            |  190 -
 arch/ppc/xmon/ppc-opc.c                            | 2720
--------------------
 arch/ppc/xmon/ppc.h                                |  240 --
 arch/ppc/xmon/privinst.h                           |   90 -
 arch/ppc/xmon/setjmp.c                             |   29 
 arch/ppc/xmon/start.c                              |  342 ---
 arch/ppc/xmon/start_8xx.c                          |  287 --
 arch/ppc/xmon/subr_prf.c                           |   55 
 arch/ppc/xmon/xmon.c                               | 1780 -------------
 drivers/ata/pata_mpc52xx.c                         |    2 
 drivers/char/Kconfig                               |    8 
 drivers/char/Makefile                              |    1 
 drivers/char/bsr.c                                 |  312 ++
 drivers/char/hvc_console.c                         |    8 
 drivers/char/hvc_console.h                         |   10 
 drivers/char/hw_random/pasemi-rng.c                |    2 
 drivers/char/viotape.c                             |   23 
 drivers/hwmon/ams/ams-core.c                       |    2 
 drivers/i2c/busses/i2c-mpc.c                       |  104 -
 drivers/macintosh/adb.c                            |    5 
 drivers/macintosh/adbhid.c                         |    2 
 drivers/macintosh/macio_sysfs.c                    |   12 
 drivers/macintosh/mediabay.c                       |   27 
 drivers/macintosh/smu.c                            |   38 
 drivers/macintosh/therm_adt746x.c                  |    2 
 drivers/macintosh/therm_pm72.c                     |    4 
 drivers/macintosh/therm_windtunnel.c               |   18 
 drivers/macintosh/via-pmu68k.c                     |    5 
 drivers/net/Kconfig                                |    1 
 drivers/net/Makefile                               |    1 
 drivers/net/fec_8xx/Kconfig                        |   20 
 drivers/net/fec_8xx/Makefile                       |   12 
 drivers/net/fec_8xx/fec_8xx-netta.c                |  151 -
 drivers/net/fec_8xx/fec_8xx.h                      |  220 --
 drivers/net/fec_8xx/fec_main.c                     | 1264 ---------
 drivers/net/fec_8xx/fec_mii.c                      |  418 ---
 drivers/net/fs_enet/fs_enet-main.c                 |    2 
 drivers/net/fs_enet/mac-scc.c                      |    2 
 drivers/net/fs_enet/mii-fec.c                      |    2 
 drivers/net/ibm_newemac/core.c                     |   61 
 drivers/net/ibm_newemac/core.h                     |   85 +
 drivers/net/ibm_newemac/debug.c                    |   52 
 drivers/net/ibm_newemac/emac.h                     |  101 +
 drivers/net/ibm_newemac/rgmii.c                    |    6 
 drivers/net/ucc_geth.c                             |    2 
 drivers/net/ucc_geth_mii.c                         |    2 
 drivers/of/device.c                                |   84 +
 drivers/of/gpio.c                                  |   38 
 drivers/of/of_i2c.c                                |    1 
 drivers/of/platform.c                              |    3 
 drivers/pcmcia/electra_cf.c                        |    2 
 drivers/pcmcia/m8xx_pcmcia.c                       |    4 
 drivers/serial/cpm_uart/cpm_uart.h                 |   11 
 drivers/serial/cpm_uart/cpm_uart_core.c            |  393 ---
 drivers/serial/cpm_uart/cpm_uart_cpm1.c            |  170 -
 drivers/serial/cpm_uart/cpm_uart_cpm1.h            |   12 
 drivers/serial/cpm_uart/cpm_uart_cpm2.c            |  283 --
 drivers/serial/cpm_uart/cpm_uart_cpm2.h            |   12 
 drivers/serial/of_serial.c                         |    2 
 drivers/spi/mpc52xx_psc_spi.c                      |    2 
 drivers/video/platinumfb.c                         |    4 
 drivers/watchdog/mpc5200_wdt.c                     |    2 
 include/asm-powerpc/Kbuild                         |    2 
 include/asm-powerpc/asm-compat.h                   |   51 
 include/asm-powerpc/cache.h                        |    3 
 include/asm-powerpc/code-patching.h                |   54 
 include/asm-powerpc/cpm.h                          |    1 
 include/asm-powerpc/cpm1.h                         |   20 
 include/asm-powerpc/cpm2.h                         |   26 
 include/asm-powerpc/cputable.h                     |   84 -
 include/asm-powerpc/dcr-generic.h                  |   49 
 include/asm-powerpc/dcr-mmio.h                     |   20 
 include/asm-powerpc/dcr-native.h                   |   16 
 include/asm-powerpc/dcr.h                          |   39 
 include/asm-powerpc/dma-mapping.h                  |  125 +
 include/asm-powerpc/elf.h                          |   37 
 include/asm-powerpc/feature-fixups.h               |  126 +
 include/asm-powerpc/firmware.h                     |   13 
 include/asm-powerpc/fsl_gtm.h                      |   47 
 include/asm-powerpc/io.h                           |   59 
 include/asm-powerpc/ioctl.h                        |   58 
 include/asm-powerpc/iommu.h                        |   16 
 include/asm-powerpc/irq.h                          |   13 
 include/asm-powerpc/kexec.h                        |   13 
 include/asm-powerpc/machdep.h                      |    1 
 include/asm-powerpc/mman.h                         |   36 
 include/asm-powerpc/mmu-hash32.h                   |   28 
 include/asm-powerpc/mmu-hash64.h                   |    1 
 include/asm-powerpc/mpc6xx.h                       |    6 
 include/asm-powerpc/mpic.h                         |    2 
 include/asm-powerpc/of_device.h                    |    2 
 include/asm-powerpc/pSeries_reconfig.h             |    6 
 include/asm-powerpc/page_64.h                      |    6 
 include/asm-powerpc/pci-bridge.h                   |    3 
 include/asm-powerpc/pgtable-4k.h                   |    1 
 include/asm-powerpc/pgtable-64k.h                  |   17 
 include/asm-powerpc/pgtable-ppc32.h                |   71 -
 include/asm-powerpc/pgtable-ppc64.h                |    4 
 include/asm-powerpc/ppc_asm.h                      |  114 +
 include/asm-powerpc/processor.h                    |   28 
 include/asm-powerpc/prom.h                         |   16 
 include/asm-powerpc/ptrace.h                       |   13 
 include/asm-powerpc/qe.h                           |   82 -
 include/asm-powerpc/reg.h                          |    6 
 include/asm-powerpc/reg_booke.h                    |   74 +
 include/asm-powerpc/sigcontext.h                   |   37 
 include/asm-powerpc/smp.h                          |    2 
 include/asm-powerpc/sparsemem.h                    |    4 
 include/asm-powerpc/spinlock.h                     |   27 
 include/asm-powerpc/spu.h                          |    1 
 include/asm-powerpc/synch.h                        |   38 
 include/asm-powerpc/system.h                       |   72 -
 include/asm-powerpc/thread_info.h                  |   19 
 include/asm-powerpc/time.h                         |    1 
 include/asm-powerpc/timex.h                        |    2 
 include/asm-powerpc/xmon.h                         |    9 
 include/asm-ppc/8xx_immap.h                        |  564 ----
 include/asm-ppc/amigayle.h                         |    1 
 include/asm-ppc/amipcmcia.h                        |    1 
 include/asm-ppc/bootinfo.h                         |   46 
 include/asm-ppc/bootx.h                            |  135 -
 include/asm-ppc/btext.h                            |   34 
 include/asm-ppc/cpm1.h                             |  688 -----
 include/asm-ppc/cpm2.h                             | 1248 ---------
 include/asm-ppc/delay.h                            |   66 
 include/asm-ppc/device.h                           |    7 
 include/asm-ppc/floppy.h                           |  178 -
 include/asm-ppc/fs_pd.h                            |   36 
 include/asm-ppc/gg2.h                              |   61 
 include/asm-ppc/gt64260.h                          |  322 --
 include/asm-ppc/gt64260_defs.h                     | 1010 -------
 include/asm-ppc/harrier.h                          |   43 
 include/asm-ppc/hawk.h                             |   32 
 include/asm-ppc/hawk_defs.h                        |   76 -
 include/asm-ppc/highmem.h                          |  135 -
 include/asm-ppc/hydra.h                            |  102 -
 include/asm-ppc/ibm403.h                           |  478 ----
 include/asm-ppc/ibm405.h                           |  299 --
 include/asm-ppc/ibm44x.h                           |  674 -----
 include/asm-ppc/ibm4xx.h                           |  124 -
 include/asm-ppc/ibm_ocp.h                          |  204 --
 include/asm-ppc/ibm_ocp_pci.h                      |   32 
 include/asm-ppc/immap_cpm2.h                       |  648 -----
 include/asm-ppc/io.h                               |  502 ----
 include/asm-ppc/irq_regs.h                         |    1 
 include/asm-ppc/kdebug.h                           |    1 
 include/asm-ppc/kgdb.h                             |   57 
 include/asm-ppc/m8260_pci.h                        |  187 -
 include/asm-ppc/machdep.h                          |  178 -
 include/asm-ppc/md.h                               |   15 
 include/asm-ppc/mk48t59.h                          |   27 
 include/asm-ppc/mmu.h                              |  444 ---
 include/asm-ppc/mmu_context.h                      |  198 -
 include/asm-ppc/mpc10x.h                           |  180 -
 include/asm-ppc/mpc52xx.h                          |  450 ---
 include/asm-ppc/mpc52xx_psc.h                      |  200 -
 include/asm-ppc/mpc8260.h                          |   98 -
 include/asm-ppc/mpc8260_pci9.h                     |   47 
 include/asm-ppc/mpc8xx.h                           |  122 -
 include/asm-ppc/mv64x60.h                          |  353 ---
 include/asm-ppc/mv64x60_defs.h                     |  976 -------
 include/asm-ppc/ocp.h                              |  204 --
 include/asm-ppc/ocp_ids.h                          |   73 -
 include/asm-ppc/open_pic.h                         |   98 -
 include/asm-ppc/page.h                             |  140 -
 include/asm-ppc/pc_serial.h                        |   42 
 include/asm-ppc/pci-bridge.h                       |  151 -
 include/asm-ppc/pci.h                              |  156 -
 include/asm-ppc/pgalloc.h                          |   45 
 include/asm-ppc/pgtable.h                          |  771 ------
 include/asm-ppc/pnp.h                              |  645 -----
 include/asm-ppc/ppc4xx_dma.h                       |  579 ----
 include/asm-ppc/ppc4xx_pic.h                       |   52 
 include/asm-ppc/ppc_sys.h                          |  106 -
 include/asm-ppc/ppcboot.h                          |  100 -
 include/asm-ppc/prep_nvram.h                       |  153 -
 include/asm-ppc/prom.h                             |   40 
 include/asm-ppc/raven.h                            |   35 
 include/asm-ppc/reg_booke.h                        |  443 ---
 include/asm-ppc/residual.h                         |  350 ---
 include/asm-ppc/rtc.h                              |   95 -
 include/asm-ppc/serial.h                           |   43 
 include/asm-ppc/smp.h                              |   75 -
 include/asm-ppc/spinlock.h                         |  168 -
 include/asm-ppc/suspend.h                          |   12 
 include/asm-ppc/system.h                           |  289 --
 include/asm-ppc/time.h                             |  161 -
 include/asm-ppc/todc.h                             |  488 ----
 include/asm-ppc/traps.h                            |    1 
 include/asm-ppc/zorro.h                            |   30 
 include/linux/adb.h                                |    1 
 include/linux/elf.h                                |    1 
 include/linux/mm.h                                 |    1 
 include/linux/mman.h                               |   29 
 include/linux/of_device.h                          |    3 
 include/linux/pci_ids.h                            |    2 
 mm/mmap.c                                          |    5 
 mm/mprotect.c                                      |    2 
 875 files changed, 27827 insertions(+), 145692 deletions(-)
 create mode 100644 Documentation/powerpc/bootwrapper.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/board.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt
 create mode 100644
Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/diu.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/dma.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/gtm.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/guts.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/i2c.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/lbc.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/sata.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/sec.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/spi.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/ssi.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/tsec.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/usb.txt
 create mode 100644 arch/powerpc/boot/cuboot-c2k.c
 create mode 100644 arch/powerpc/boot/cuboot-sam440ep.c
 create mode 100644 arch/powerpc/boot/dts/asp834x-redboot.dts
 create mode 100644 arch/powerpc/boot/dts/c2k.dts
 create mode 100644 arch/powerpc/boot/dts/mpc836x_rdk.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8536ds.dts
 create mode 100644 arch/powerpc/boot/dts/sam440ep.dts
 create mode 100644 arch/powerpc/boot/dts/tqm8548-bigflash.dts
 create mode 100644 arch/powerpc/boot/dts/tqm8548.dts
 create mode 100644 arch/powerpc/boot/dts/virtex440-ml507.dts
 create mode 100644 arch/powerpc/boot/redboot-83xx.c
 create mode 100644 arch/powerpc/boot/virtex.c
 create mode 100644 arch/powerpc/configs/44x/sam440ep_defconfig
 create mode 100644 arch/powerpc/configs/44x/virtex5_defconfig
 create mode 100644 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
 create mode 100644 arch/powerpc/configs/85xx/tqm8548_defconfig
 create mode 100644 arch/powerpc/configs/asp8347_defconfig
 create mode 100644 arch/powerpc/configs/c2k_defconfig
 create mode 100644 arch/powerpc/configs/mpc8536_ds_defconfig
 create mode 100644 arch/powerpc/kernel/idle_e500.S
 create mode 100644 arch/powerpc/kernel/module.c
 create mode 100644 arch/powerpc/lib/code-patching.c
 create mode 100644 arch/powerpc/lib/feature-fixups-test.S
 create mode 100644 arch/powerpc/lib/feature-fixups.c
 create mode 100644 arch/powerpc/platforms/44x/sam440ep.c
 create mode 100644 arch/powerpc/platforms/44x/virtex.c
 create mode 100644 arch/powerpc/platforms/512x/clock.c
 create mode 100644 arch/powerpc/platforms/512x/mpc5121_ads.h
 create mode 100644 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
 create mode 100644 arch/powerpc/platforms/512x/mpc5121_generic.c
 create mode 100644 arch/powerpc/platforms/512x/mpc512x.h
 create mode 100644 arch/powerpc/platforms/512x/mpc512x_shared.c
 create mode 100644 arch/powerpc/platforms/83xx/asp834x.c
 create mode 100644 arch/powerpc/platforms/83xx/mpc836x_rdk.c
 create mode 100644 arch/powerpc/platforms/85xx/mpc8536_ds.c
 create mode 100644 arch/powerpc/platforms/86xx/pic.c
 create mode 100644 arch/powerpc/platforms/embedded6xx/c2k.c
 create mode 100644 arch/powerpc/sysdev/6xx-suspend.S
 create mode 100644 arch/powerpc/sysdev/fsl_gtm.c
 create mode 100644 arch/powerpc/sysdev/fsl_msi.c
 create mode 100644 arch/powerpc/sysdev/fsl_msi.h
 create mode 100644 arch/powerpc/sysdev/qe_lib/gpio.c
 create mode 100644 arch/powerpc/sysdev/qe_lib/usb.c
 delete mode 100644 arch/ppc/.gitignore
 delete mode 100644 arch/ppc/4xx_io/Makefile
 delete mode 100644 arch/ppc/4xx_io/serial_sicc.c
 delete mode 100644 arch/ppc/8260_io/Kconfig
 delete mode 100644 arch/ppc/8260_io/Makefile
 delete mode 100644 arch/ppc/8260_io/enet.c
 delete mode 100644 arch/ppc/8260_io/fcc_enet.c
 delete mode 100644 arch/ppc/8xx_io/Kconfig
 delete mode 100644 arch/ppc/8xx_io/Makefile
 delete mode 100644 arch/ppc/8xx_io/commproc.c
 delete mode 100644 arch/ppc/8xx_io/enet.c
 delete mode 100644 arch/ppc/8xx_io/fec.c
 delete mode 100644 arch/ppc/8xx_io/micropatch.c
 delete mode 100644 arch/ppc/Kconfig
 delete mode 100644 arch/ppc/Kconfig.debug
 delete mode 100644 arch/ppc/Makefile
 delete mode 100644 arch/ppc/boot/Makefile
 delete mode 100644 arch/ppc/boot/common/Makefile
 delete mode 100644 arch/ppc/boot/common/bootinfo.c
 delete mode 100644 arch/ppc/boot/common/crt0.S
 delete mode 100644 arch/ppc/boot/common/misc-common.c
 delete mode 100644 arch/ppc/boot/common/ns16550.c
 delete mode 100644 arch/ppc/boot/common/serial_stub.c
 delete mode 100644 arch/ppc/boot/common/string.S
 delete mode 100644 arch/ppc/boot/common/util.S
 delete mode 100644 arch/ppc/boot/images/.gitignore
 delete mode 100644 arch/ppc/boot/images/Makefile
 delete mode 100644 arch/ppc/boot/include/cpc700.h
 delete mode 100644 arch/ppc/boot/include/iso_font.h
 delete mode 100644 arch/ppc/boot/include/mpc10x.h
 delete mode 100644 arch/ppc/boot/include/mpsc_defs.h
 delete mode 100644 arch/ppc/boot/include/nonstdio.h
 delete mode 100644 arch/ppc/boot/include/of1275.h
 delete mode 100644 arch/ppc/boot/include/rs6000.h
 delete mode 100644 arch/ppc/boot/include/serial.h
 delete mode 100644 arch/ppc/boot/ld.script
 delete mode 100644 arch/ppc/boot/lib/.gitignore
 delete mode 100644 arch/ppc/boot/lib/Makefile
 delete mode 100644 arch/ppc/boot/lib/div64.S
 delete mode 100644 arch/ppc/boot/lib/kbd.c
 delete mode 100644 arch/ppc/boot/lib/vreset.c
 delete mode 100644 arch/ppc/boot/of1275/Makefile
 delete mode 100644 arch/ppc/boot/of1275/call_prom.c
 delete mode 100644 arch/ppc/boot/of1275/claim.c
 delete mode 100644 arch/ppc/boot/of1275/enter.c
 delete mode 100644 arch/ppc/boot/of1275/exit.c
 delete mode 100644 arch/ppc/boot/of1275/finddevice.c
 delete mode 100644 arch/ppc/boot/of1275/getprop.c
 delete mode 100644 arch/ppc/boot/of1275/map.c
 delete mode 100644 arch/ppc/boot/of1275/ofinit.c
 delete mode 100644 arch/ppc/boot/of1275/ofstdio.c
 delete mode 100644 arch/ppc/boot/of1275/read.c
 delete mode 100644 arch/ppc/boot/of1275/release.c
 delete mode 100644 arch/ppc/boot/of1275/write.c
 delete mode 100644 arch/ppc/boot/simple/Makefile
 delete mode 100644 arch/ppc/boot/simple/chrpmap.c
 delete mode 100644 arch/ppc/boot/simple/clear.S
 delete mode 100644 arch/ppc/boot/simple/cpc700_memory.c
 delete mode 100644 arch/ppc/boot/simple/dummy.c
 delete mode 100644 arch/ppc/boot/simple/embed_config.c
 delete mode 100644 arch/ppc/boot/simple/head.S
 delete mode 100644 arch/ppc/boot/simple/iic.c
 delete mode 100644 arch/ppc/boot/simple/m8260_tty.c
 delete mode 100644 arch/ppc/boot/simple/m8xx_tty.c
 delete mode 100644 arch/ppc/boot/simple/misc-chestnut.c
 delete mode 100644 arch/ppc/boot/simple/misc-cpci690.c
 delete mode 100644 arch/ppc/boot/simple/misc-embedded.c
 delete mode 100644 arch/ppc/boot/simple/misc-ev64260.c
 delete mode 100644 arch/ppc/boot/simple/misc-ev64360.c
 delete mode 100644 arch/ppc/boot/simple/misc-katana.c
 delete mode 100644 arch/ppc/boot/simple/misc-mv64x60.c
 delete mode 100644 arch/ppc/boot/simple/misc-prep.c
 delete mode 100644 arch/ppc/boot/simple/misc-radstone_ppc7d.c
 delete mode 100644 arch/ppc/boot/simple/misc-spruce.c
 delete mode 100644 arch/ppc/boot/simple/misc.c
 delete mode 100644 arch/ppc/boot/simple/mpc10x_memory.c
 delete mode 100644 arch/ppc/boot/simple/mpc52xx_tty.c
 delete mode 100644 arch/ppc/boot/simple/mv64x60_tty.c
 delete mode 100644 arch/ppc/boot/simple/openbios.c
 delete mode 100644 arch/ppc/boot/simple/pci.c
 delete mode 100644 arch/ppc/boot/simple/pibs.c
 delete mode 100644 arch/ppc/boot/simple/prepmap.c
 delete mode 100644 arch/ppc/boot/simple/qspan_pci.c
 delete mode 100644 arch/ppc/boot/simple/relocate.S
 delete mode 100644 arch/ppc/boot/simple/rw4/ppc_40x.h
 delete mode 100644 arch/ppc/boot/simple/rw4/rw4_init.S
 delete mode 100644 arch/ppc/boot/simple/rw4/rw4_init_brd.S
 delete mode 100644 arch/ppc/boot/simple/rw4/stb.h
 delete mode 100644 arch/ppc/boot/simple/uartlite_tty.c
 delete mode 100644 arch/ppc/boot/utils/.gitignore
 delete mode 100644 arch/ppc/boot/utils/elf.pl
 delete mode 100644 arch/ppc/boot/utils/mkbugboot.c
 delete mode 100644 arch/ppc/boot/utils/mkprep.c
 delete mode 100644 arch/ppc/boot/utils/mktree.c
 delete mode 100644 arch/ppc/configs/FADS_defconfig
 delete mode 100644 arch/ppc/configs/IVMS8_defconfig
 delete mode 100644 arch/ppc/configs/TQM823L_defconfig
 delete mode 100644 arch/ppc/configs/TQM8260_defconfig
 delete mode 100644 arch/ppc/configs/TQM850L_defconfig
 delete mode 100644 arch/ppc/configs/TQM860L_defconfig
 delete mode 100644 arch/ppc/configs/bamboo_defconfig
 delete mode 100644 arch/ppc/configs/bseip_defconfig
 delete mode 100644 arch/ppc/configs/bubinga_defconfig
 delete mode 100644 arch/ppc/configs/chestnut_defconfig
 delete mode 100644 arch/ppc/configs/cpci405_defconfig
 delete mode 100644 arch/ppc/configs/cpci690_defconfig
 delete mode 100644 arch/ppc/configs/ebony_defconfig
 delete mode 100644 arch/ppc/configs/ep405_defconfig
 delete mode 100644 arch/ppc/configs/est8260_defconfig
 delete mode 100644 arch/ppc/configs/ev64260_defconfig
 delete mode 100644 arch/ppc/configs/ev64360_defconfig
 delete mode 100644 arch/ppc/configs/hdpu_defconfig
 delete mode 100644 arch/ppc/configs/katana_defconfig
 delete mode 100644 arch/ppc/configs/lite5200_defconfig
 delete mode 100644 arch/ppc/configs/lopec_defconfig
 delete mode 100644 arch/ppc/configs/luan_defconfig
 delete mode 100644 arch/ppc/configs/mbx_defconfig
 delete mode 100644 arch/ppc/configs/ml300_defconfig
 delete mode 100644 arch/ppc/configs/ml403_defconfig
 delete mode 100644 arch/ppc/configs/mvme5100_defconfig
 delete mode 100644 arch/ppc/configs/ocotea_defconfig
 delete mode 100644 arch/ppc/configs/pplus_defconfig
 delete mode 100644 arch/ppc/configs/prep_defconfig
 delete mode 100644 arch/ppc/configs/prpmc750_defconfig
 delete mode 100644 arch/ppc/configs/prpmc800_defconfig
 delete mode 100644 arch/ppc/configs/radstone_ppc7d_defconfig
 delete mode 100644 arch/ppc/configs/redwood5_defconfig
 delete mode 100644 arch/ppc/configs/redwood6_defconfig
 delete mode 100644 arch/ppc/configs/rpx8260_defconfig
 delete mode 100644 arch/ppc/configs/rpxcllf_defconfig
 delete mode 100644 arch/ppc/configs/rpxlite_defconfig
 delete mode 100644 arch/ppc/configs/sandpoint_defconfig
 delete mode 100644 arch/ppc/configs/spruce_defconfig
 delete mode 100644 arch/ppc/configs/sycamore_defconfig
 delete mode 100644 arch/ppc/configs/taishan_defconfig
 delete mode 100644 arch/ppc/configs/walnut_defconfig
 delete mode 100644 arch/ppc/kernel/Makefile
 delete mode 100644 arch/ppc/kernel/asm-offsets.c
 delete mode 100644 arch/ppc/kernel/cpu_setup_power4.S
 delete mode 100644 arch/ppc/kernel/entry.S
 delete mode 100644 arch/ppc/kernel/head.S
 delete mode 100644 arch/ppc/kernel/head_44x.S
 delete mode 100644 arch/ppc/kernel/head_4xx.S
 delete mode 100644 arch/ppc/kernel/head_8xx.S
 delete mode 100644 arch/ppc/kernel/head_booke.h
 delete mode 100644 arch/ppc/kernel/machine_kexec.c
 delete mode 100644 arch/ppc/kernel/misc.S
 delete mode 100644 arch/ppc/kernel/pci.c
 delete mode 100644 arch/ppc/kernel/ppc-stub.c
 delete mode 100644 arch/ppc/kernel/ppc_htab.c
 delete mode 100644 arch/ppc/kernel/ppc_ksyms.c
 delete mode 100644 arch/ppc/kernel/relocate_kernel.S
 delete mode 100644 arch/ppc/kernel/setup.c
 delete mode 100644 arch/ppc/kernel/smp-tbsync.c
 delete mode 100644 arch/ppc/kernel/smp.c
 delete mode 100644 arch/ppc/kernel/softemu8xx.c
 delete mode 100644 arch/ppc/kernel/time.c
 delete mode 100644 arch/ppc/kernel/traps.c
 delete mode 100644 arch/ppc/kernel/vmlinux.lds.S
 delete mode 100644 arch/ppc/lib/Makefile
 delete mode 100644 arch/ppc/lib/checksum.S
 delete mode 100644 arch/ppc/lib/div64.S
 delete mode 100644 arch/ppc/lib/locks.c
 delete mode 100644 arch/ppc/lib/string.S
 delete mode 100644 arch/ppc/mm/44x_mmu.c
 delete mode 100644 arch/ppc/mm/4xx_mmu.c
 delete mode 100644 arch/ppc/mm/Makefile
 delete mode 100644 arch/ppc/mm/fault.c
 delete mode 100644 arch/ppc/mm/hashtable.S
 delete mode 100644 arch/ppc/mm/init.c
 delete mode 100644 arch/ppc/mm/mem_pieces.c
 delete mode 100644 arch/ppc/mm/mem_pieces.h
 delete mode 100644 arch/ppc/mm/mmu_context.c
 delete mode 100644 arch/ppc/mm/mmu_decl.h
 delete mode 100644 arch/ppc/mm/pgtable.c
 delete mode 100644 arch/ppc/mm/ppc_mmu.c
 delete mode 100644 arch/ppc/mm/tlb.c
 delete mode 100644 arch/ppc/platforms/4xx/Kconfig
 delete mode 100644 arch/ppc/platforms/4xx/Makefile
 delete mode 100644 arch/ppc/platforms/4xx/bamboo.c
 delete mode 100644 arch/ppc/platforms/4xx/bamboo.h
 delete mode 100644 arch/ppc/platforms/4xx/bubinga.c
 delete mode 100644 arch/ppc/platforms/4xx/bubinga.h
 delete mode 100644 arch/ppc/platforms/4xx/cpci405.c
 delete mode 100644 arch/ppc/platforms/4xx/cpci405.h
 delete mode 100644 arch/ppc/platforms/4xx/ebony.c
 delete mode 100644 arch/ppc/platforms/4xx/ebony.h
 delete mode 100644 arch/ppc/platforms/4xx/ep405.c
 delete mode 100644 arch/ppc/platforms/4xx/ep405.h
 delete mode 100644 arch/ppc/platforms/4xx/ibm405ep.c
 delete mode 100644 arch/ppc/platforms/4xx/ibm405ep.h
 delete mode 100644 arch/ppc/platforms/4xx/ibm405gp.c
 delete mode 100644 arch/ppc/platforms/4xx/ibm405gp.h
 delete mode 100644 arch/ppc/platforms/4xx/ibm405gpr.c
 delete mode 100644 arch/ppc/platforms/4xx/ibm405gpr.h
 delete mode 100644 arch/ppc/platforms/4xx/ibm440ep.c
 delete mode 100644 arch/ppc/platforms/4xx/ibm440ep.h
 delete mode 100644 arch/ppc/platforms/4xx/ibm440gp.c
 delete mode 100644 arch/ppc/platforms/4xx/ibm440gp.h
 delete mode 100644 arch/ppc/platforms/4xx/ibm440gx.c
 delete mode 100644 arch/ppc/platforms/4xx/ibm440gx.h
 delete mode 100644 arch/ppc/platforms/4xx/ibm440sp.c
 delete mode 100644 arch/ppc/platforms/4xx/ibm440sp.h
 delete mode 100644 arch/ppc/platforms/4xx/ibmnp405h.c
 delete mode 100644 arch/ppc/platforms/4xx/ibmnp405h.h
 delete mode 100644 arch/ppc/platforms/4xx/ibmstb4.c
 delete mode 100644 arch/ppc/platforms/4xx/ibmstb4.h
 delete mode 100644 arch/ppc/platforms/4xx/ibmstbx25.c
 delete mode 100644 arch/ppc/platforms/4xx/ibmstbx25.h
 delete mode 100644 arch/ppc/platforms/4xx/luan.c
 delete mode 100644 arch/ppc/platforms/4xx/luan.h
 delete mode 100644 arch/ppc/platforms/4xx/ocotea.c
 delete mode 100644 arch/ppc/platforms/4xx/ocotea.h
 delete mode 100644 arch/ppc/platforms/4xx/ppc440spe.c
 delete mode 100644 arch/ppc/platforms/4xx/ppc440spe.h
 delete mode 100644 arch/ppc/platforms/4xx/redwood5.c
 delete mode 100644 arch/ppc/platforms/4xx/redwood5.h
 delete mode 100644 arch/ppc/platforms/4xx/redwood6.c
 delete mode 100644 arch/ppc/platforms/4xx/redwood6.h
 delete mode 100644 arch/ppc/platforms/4xx/sycamore.c
 delete mode 100644 arch/ppc/platforms/4xx/sycamore.h
 delete mode 100644 arch/ppc/platforms/4xx/taishan.c
 delete mode 100644 arch/ppc/platforms/4xx/taishan.h
 delete mode 100644 arch/ppc/platforms/4xx/virtex.h
 delete mode 100644 arch/ppc/platforms/4xx/walnut.c
 delete mode 100644 arch/ppc/platforms/4xx/walnut.h
 delete mode 100644 arch/ppc/platforms/4xx/xilinx_ml300.c
 delete mode 100644 arch/ppc/platforms/4xx/xilinx_ml403.c
 delete mode 100644 arch/ppc/platforms/4xx/xparameters/xparameters.h
 delete mode 100644
arch/ppc/platforms/4xx/xparameters/xparameters_ml300.h
 delete mode 100644
arch/ppc/platforms/4xx/xparameters/xparameters_ml403.h
 delete mode 100644 arch/ppc/platforms/4xx/yucca.c
 delete mode 100644 arch/ppc/platforms/4xx/yucca.h
 delete mode 100644 arch/ppc/platforms/Makefile
 delete mode 100644 arch/ppc/platforms/bseip.h
 delete mode 100644 arch/ppc/platforms/ccm.h
 delete mode 100644 arch/ppc/platforms/chestnut.c
 delete mode 100644 arch/ppc/platforms/chestnut.h
 delete mode 100644 arch/ppc/platforms/cpci690.c
 delete mode 100644 arch/ppc/platforms/cpci690.h
 delete mode 100644 arch/ppc/platforms/est8260.h
 delete mode 100644 arch/ppc/platforms/ev64260.c
 delete mode 100644 arch/ppc/platforms/ev64260.h
 delete mode 100644 arch/ppc/platforms/ev64360.c
 delete mode 100644 arch/ppc/platforms/ev64360.h
 delete mode 100644 arch/ppc/platforms/fads.h
 delete mode 100644 arch/ppc/platforms/hdpu.c
 delete mode 100644 arch/ppc/platforms/hdpu.h
 delete mode 100644 arch/ppc/platforms/hermes.h
 delete mode 100644 arch/ppc/platforms/ip860.h
 delete mode 100644 arch/ppc/platforms/ivms8.h
 delete mode 100644 arch/ppc/platforms/katana.c
 delete mode 100644 arch/ppc/platforms/katana.h
 delete mode 100644 arch/ppc/platforms/lantec.h
 delete mode 100644 arch/ppc/platforms/lite5200.c
 delete mode 100644 arch/ppc/platforms/lite5200.h
 delete mode 100644 arch/ppc/platforms/lopec.c
 delete mode 100644 arch/ppc/platforms/lopec.h
 delete mode 100644 arch/ppc/platforms/lwmon.h
 delete mode 100644 arch/ppc/platforms/mbx.h
 delete mode 100644 arch/ppc/platforms/mpc866ads_setup.c
 delete mode 100644 arch/ppc/platforms/mvme5100.c
 delete mode 100644 arch/ppc/platforms/mvme5100.h
 delete mode 100644 arch/ppc/platforms/pal4.h
 delete mode 100644 arch/ppc/platforms/pal4_pci.c
 delete mode 100644 arch/ppc/platforms/pal4_serial.h
 delete mode 100644 arch/ppc/platforms/pal4_setup.c
 delete mode 100644 arch/ppc/platforms/pcu_e.h
 delete mode 100644 arch/ppc/platforms/powerpmc250.c
 delete mode 100644 arch/ppc/platforms/powerpmc250.h
 delete mode 100644 arch/ppc/platforms/pplus.c
 delete mode 100644 arch/ppc/platforms/pplus.h
 delete mode 100644 arch/ppc/platforms/prep_pci.c
 delete mode 100644 arch/ppc/platforms/prep_setup.c
 delete mode 100644 arch/ppc/platforms/prpmc750.c
 delete mode 100644 arch/ppc/platforms/prpmc750.h
 delete mode 100644 arch/ppc/platforms/prpmc800.c
 delete mode 100644 arch/ppc/platforms/prpmc800.h
 delete mode 100644 arch/ppc/platforms/radstone_ppc7d.c
 delete mode 100644 arch/ppc/platforms/radstone_ppc7d.h
 delete mode 100644 arch/ppc/platforms/residual.c
 delete mode 100644 arch/ppc/platforms/rpx8260.h
 delete mode 100644 arch/ppc/platforms/rpxclassic.h
 delete mode 100644 arch/ppc/platforms/rpxlite.h
 delete mode 100644 arch/ppc/platforms/sandpoint.c
 delete mode 100644 arch/ppc/platforms/sandpoint.h
 delete mode 100644 arch/ppc/platforms/sbc82xx.c
 delete mode 100644 arch/ppc/platforms/sbc82xx.h
 delete mode 100644 arch/ppc/platforms/sbs8260.h
 delete mode 100644 arch/ppc/platforms/spruce.c
 delete mode 100644 arch/ppc/platforms/spruce.h
 delete mode 100644 arch/ppc/platforms/tqm8260.h
 delete mode 100644 arch/ppc/platforms/tqm8260_setup.c
 delete mode 100644 arch/ppc/platforms/tqm8xx.h
 delete mode 100644 arch/ppc/syslib/Makefile
 delete mode 100644 arch/ppc/syslib/btext.c
 delete mode 100644 arch/ppc/syslib/cpc700.h
 delete mode 100644 arch/ppc/syslib/cpc700_pic.c
 delete mode 100644 arch/ppc/syslib/cpm2_common.c
 delete mode 100644 arch/ppc/syslib/cpm2_pic.c
 delete mode 100644 arch/ppc/syslib/cpm2_pic.h
 delete mode 100644 arch/ppc/syslib/gen550.h
 delete mode 100644 arch/ppc/syslib/gen550_dbg.c
 delete mode 100644 arch/ppc/syslib/gen550_kgdb.c
 delete mode 100644 arch/ppc/syslib/gt64260_pic.c
 delete mode 100644 arch/ppc/syslib/harrier.c
 delete mode 100644 arch/ppc/syslib/hawk_common.c
 delete mode 100644 arch/ppc/syslib/i8259.c
 delete mode 100644 arch/ppc/syslib/ibm440gp_common.c
 delete mode 100644 arch/ppc/syslib/ibm440gp_common.h
 delete mode 100644 arch/ppc/syslib/ibm440gx_common.c
 delete mode 100644 arch/ppc/syslib/ibm440gx_common.h
 delete mode 100644 arch/ppc/syslib/ibm440sp_common.c
 delete mode 100644 arch/ppc/syslib/ibm440sp_common.h
 delete mode 100644 arch/ppc/syslib/ibm44x_common.c
 delete mode 100644 arch/ppc/syslib/ibm44x_common.h
 delete mode 100644 arch/ppc/syslib/ibm_ocp.c
 delete mode 100644 arch/ppc/syslib/indirect_pci.c
 delete mode 100644 arch/ppc/syslib/m8260_pci_erratum9.c
 delete mode 100644 arch/ppc/syslib/m8260_setup.c
 delete mode 100644 arch/ppc/syslib/m82xx_pci.c
 delete mode 100644 arch/ppc/syslib/m82xx_pci.h
 delete mode 100644 arch/ppc/syslib/m8xx_setup.c
 delete mode 100644 arch/ppc/syslib/m8xx_wdt.c
 delete mode 100644 arch/ppc/syslib/m8xx_wdt.h
 delete mode 100644 arch/ppc/syslib/mpc10x_common.c
 delete mode 100644 arch/ppc/syslib/mpc52xx_devices.c
 delete mode 100644 arch/ppc/syslib/mpc52xx_pci.c
 delete mode 100644 arch/ppc/syslib/mpc52xx_pci.h
 delete mode 100644 arch/ppc/syslib/mpc52xx_pic.c
 delete mode 100644 arch/ppc/syslib/mpc52xx_setup.c
 delete mode 100644 arch/ppc/syslib/mpc52xx_sys.c
 delete mode 100644 arch/ppc/syslib/mpc8xx_devices.c
 delete mode 100644 arch/ppc/syslib/mpc8xx_sys.c
 delete mode 100644 arch/ppc/syslib/mv64360_pic.c
 delete mode 100644 arch/ppc/syslib/mv64x60.c
 delete mode 100644 arch/ppc/syslib/mv64x60_dbg.c
 delete mode 100644 arch/ppc/syslib/mv64x60_win.c
 delete mode 100644 arch/ppc/syslib/ocp.c
 delete mode 100644 arch/ppc/syslib/open_pic.c
 delete mode 100644 arch/ppc/syslib/open_pic2.c
 delete mode 100644 arch/ppc/syslib/open_pic_defs.h
 delete mode 100644 arch/ppc/syslib/pci_auto.c
 delete mode 100644 arch/ppc/syslib/ppc403_pic.c
 delete mode 100644 arch/ppc/syslib/ppc405_pci.c
 delete mode 100644 arch/ppc/syslib/ppc440spe_pcie.c
 delete mode 100644 arch/ppc/syslib/ppc440spe_pcie.h
 delete mode 100644 arch/ppc/syslib/ppc4xx_dma.c
 delete mode 100644 arch/ppc/syslib/ppc4xx_pic.c
 delete mode 100644 arch/ppc/syslib/ppc4xx_setup.c
 delete mode 100644 arch/ppc/syslib/ppc4xx_sgdma.c
 delete mode 100644 arch/ppc/syslib/ppc8xx_pic.c
 delete mode 100644 arch/ppc/syslib/ppc8xx_pic.h
 delete mode 100644 arch/ppc/syslib/ppc_sys.c
 delete mode 100644 arch/ppc/syslib/pq2_devices.c
 delete mode 100644 arch/ppc/syslib/pq2_sys.c
 delete mode 100644 arch/ppc/syslib/prep_nvram.c
 delete mode 100644 arch/ppc/syslib/qspan_pci.c
 delete mode 100644 arch/ppc/syslib/todc_time.c
 delete mode 100644 arch/ppc/syslib/virtex_devices.c
 delete mode 100644 arch/ppc/syslib/virtex_devices.h
 delete mode 100644 arch/ppc/syslib/xilinx_pic.c
 delete mode 100644 arch/ppc/xmon/Makefile
 delete mode 100644 arch/ppc/xmon/ansidecl.h
 delete mode 100644 arch/ppc/xmon/nonstdio.h
 delete mode 100644 arch/ppc/xmon/ppc-dis.c
 delete mode 100644 arch/ppc/xmon/ppc-opc.c
 delete mode 100644 arch/ppc/xmon/ppc.h
 delete mode 100644 arch/ppc/xmon/privinst.h
 delete mode 100644 arch/ppc/xmon/setjmp.c
 delete mode 100644 arch/ppc/xmon/start.c
 delete mode 100644 arch/ppc/xmon/start_8xx.c
 delete mode 100644 arch/ppc/xmon/subr_prf.c
 delete mode 100644 arch/ppc/xmon/xmon.c
 create mode 100644 drivers/char/bsr.c
 delete mode 100644 drivers/net/fec_8xx/Kconfig
 delete mode 100644 drivers/net/fec_8xx/Makefile
 delete mode 100644 drivers/net/fec_8xx/fec_8xx-netta.c
 delete mode 100644 drivers/net/fec_8xx/fec_8xx.h
 delete mode 100644 drivers/net/fec_8xx/fec_main.c
 delete mode 100644 drivers/net/fec_8xx/fec_mii.c
 create mode 100644 include/asm-powerpc/code-patching.h
 create mode 100644 include/asm-powerpc/dcr-generic.h
 create mode 100644 include/asm-powerpc/feature-fixups.h
 create mode 100644 include/asm-powerpc/fsl_gtm.h
 create mode 100644 include/asm-powerpc/mpc6xx.h
 delete mode 100644 include/asm-ppc/8xx_immap.h
 delete mode 100644 include/asm-ppc/amigayle.h
 delete mode 100644 include/asm-ppc/amipcmcia.h
 delete mode 100644 include/asm-ppc/bootinfo.h
 delete mode 100644 include/asm-ppc/bootx.h
 delete mode 100644 include/asm-ppc/btext.h
 delete mode 100644 include/asm-ppc/cpm1.h
 delete mode 100644 include/asm-ppc/cpm2.h
 delete mode 100644 include/asm-ppc/delay.h
 delete mode 100644 include/asm-ppc/device.h
 delete mode 100644 include/asm-ppc/floppy.h
 delete mode 100644 include/asm-ppc/fs_pd.h
 delete mode 100644 include/asm-ppc/gg2.h
 delete mode 100644 include/asm-ppc/gt64260.h
 delete mode 100644 include/asm-ppc/gt64260_defs.h
 delete mode 100644 include/asm-ppc/harrier.h
 delete mode 100644 include/asm-ppc/hawk.h
 delete mode 100644 include/asm-ppc/hawk_defs.h
 delete mode 100644 include/asm-ppc/highmem.h
 delete mode 100644 include/asm-ppc/hydra.h
 delete mode 100644 include/asm-ppc/ibm403.h
 delete mode 100644 include/asm-ppc/ibm405.h
 delete mode 100644 include/asm-ppc/ibm44x.h
 delete mode 100644 include/asm-ppc/ibm4xx.h
 delete mode 100644 include/asm-ppc/ibm_ocp.h
 delete mode 100644 include/asm-ppc/ibm_ocp_pci.h
 delete mode 100644 include/asm-ppc/immap_cpm2.h
 delete mode 100644 include/asm-ppc/io.h
 delete mode 100644 include/asm-ppc/irq_regs.h
 delete mode 100644 include/asm-ppc/kdebug.h
 delete mode 100644 include/asm-ppc/kgdb.h
 delete mode 100644 include/asm-ppc/m8260_pci.h
 delete mode 100644 include/asm-ppc/machdep.h
 delete mode 100644 include/asm-ppc/md.h
 delete mode 100644 include/asm-ppc/mk48t59.h
 delete mode 100644 include/asm-ppc/mmu.h
 delete mode 100644 include/asm-ppc/mmu_context.h
 delete mode 100644 include/asm-ppc/mpc10x.h
 delete mode 100644 include/asm-ppc/mpc52xx.h
 delete mode 100644 include/asm-ppc/mpc52xx_psc.h
 delete mode 100644 include/asm-ppc/mpc8260.h
 delete mode 100644 include/asm-ppc/mpc8260_pci9.h
 delete mode 100644 include/asm-ppc/mpc8xx.h
 delete mode 100644 include/asm-ppc/mv64x60.h
 delete mode 100644 include/asm-ppc/mv64x60_defs.h
 delete mode 100644 include/asm-ppc/ocp.h
 delete mode 100644 include/asm-ppc/ocp_ids.h
 delete mode 100644 include/asm-ppc/open_pic.h
 delete mode 100644 include/asm-ppc/page.h
 delete mode 100644 include/asm-ppc/pc_serial.h
 delete mode 100644 include/asm-ppc/pci-bridge.h
 delete mode 100644 include/asm-ppc/pci.h
 delete mode 100644 include/asm-ppc/pgalloc.h
 delete mode 100644 include/asm-ppc/pgtable.h
 delete mode 100644 include/asm-ppc/pnp.h
 delete mode 100644 include/asm-ppc/ppc4xx_dma.h
 delete mode 100644 include/asm-ppc/ppc4xx_pic.h
 delete mode 100644 include/asm-ppc/ppc_sys.h
 delete mode 100644 include/asm-ppc/ppcboot.h
 delete mode 100644 include/asm-ppc/prep_nvram.h
 delete mode 100644 include/asm-ppc/prom.h
 delete mode 100644 include/asm-ppc/raven.h
 delete mode 100644 include/asm-ppc/reg_booke.h
 delete mode 100644 include/asm-ppc/residual.h
 delete mode 100644 include/asm-ppc/rtc.h
 delete mode 100644 include/asm-ppc/serial.h
 delete mode 100644 include/asm-ppc/smp.h
 delete mode 100644 include/asm-ppc/spinlock.h
 delete mode 100644 include/asm-ppc/suspend.h
 delete mode 100644 include/asm-ppc/system.h
 delete mode 100644 include/asm-ppc/time.h
 delete mode 100644 include/asm-ppc/todc.h
 delete mode 100644 include/asm-ppc/traps.h
 delete mode 100644 include/asm-ppc/zorro.h

Adrian Bunk (3):
      drivers/macintosh: Various cleanups
      powerpc: Don't export asm/asm-compat.h to userspace
      powerpc: asm/elf.h: Reduce userspace header

Andre Schwarz (1):
      powerpc/mpc5200: PCI write combine timer

Andrew Lewis (1):
      powerpc: Prevent memory corruption due to cache invalidation of
unaligned DMA buffer

Andy Whitcroft (1):
      powerpc: Add 64 bit version of huge_ptep_set_wrprotect

Anton Vorontsov (13):
      [POWERPC] of/gpio: Use dynamic base allocation
      [POWERPC] fsl_msi: few (mostly cosmetic) fixes
      powerpc/mpic: Fix ambiguous else statement
      powerpc/sysdev: implement FSL GTM support
      powerpc/QE: add support for QE USB clocks routing
      powerpc/QE: prepare QE PIO code for GPIO LIB support
      powerpc/QE: implement support for the GPIO LIB API
      powerpc/83xx: new board support: MPC8360E-RDK
      powerpc/QE: switch to the cpm_muram implementation
      powerpc/QE: qe_reset should be __init
      powerpc/QE: use arch_initcall to probe QUICC Engine GPIOs
      powerpc: Implement OF PCI address accessors stubs for CONFIG_PCI=n
      powerpc/86xx: mpc8610_hpcd: fix interrupt trigger type for ULi IDE

Arnd Bergmann (5):
      powerpc: Provide dummy crash_shutdown_register
      powerpc/pseries: Call pseries_kexec_setup only on pseries
      powerpc/cell: Disable ptcal in case of crash kdump
      powerpc: Increase CRASH_HANDLER_MAX
      powerpc: support for latencytop

Bart Van Assche (1):
      powerpc: Make sure that include/asm-powerpc/spinlock.h does not
trigger compilation warnings

Becky Bruce (4):
      [POWERPC] Delete unused fec_8xx net driver
      powerpc: Silly spelling fix in pgtable-ppc32
      powerpc: Change BAT code to use phys_addr_t
      powerpc: Get rid of bitfields in ppc_bat struct

Benjamin Herrenschmidt (3):
      powerpc: Free a PTE bit on ppc64 with 64K pages
      powerpc: Use new printk extension %pS to print symbols on oops
      powerpc: rework 4xx PTE access and TLB miss

Bernhard Walle (1):
      powerpc: Remove experimental status of kdump on 64-bit powerpc

Bryan O'Donoghue (1):
      [POWERPC] 83xx: Add support for Analogue & Micro ASP837E board

Daniel Walker (2):
      macintosh/therm_windtunnel: Convert semaphore to mutex
      macintosh/media bay: Convert semaphore to mutex

Dave Jiang (1):
      powerpc/85xx: publish of device for cds platforms

Dave Kleikamp (7):
      powerpc: hash_huge_page() should get the WIMG bits from the lpte
      mm: Allow architectures to define additional protection bits
      powerpc/mm: Define flags for Strong Access Ordering
      powerpc/mm: Add SAO Feature bit to the cputable
      powerpc/mm: Add Strong Access Ordering support
      powerpc/mm: Don't clear _PAGE_COHERENT when _PAGE_SAO is set
      powerpc: Remove unnecessary condition when sanity-checking WIMG
bits

David Gibson (1):
      [POWERPC] Convert remaining dts-v0 files to v1

Emil Medve (1):
      powerpc: Add the PC speaker only when requested

Eric B Munson (1):
      powerpc: Keep 3 high personality bytes across exec

Geoff Levand (1):
      powerpc/ps3: Quiet system bus match output

Giuseppe Coviello (2):
      powerpc/4xx: Sam440ep support
      powerpc/4xx: Convert Sam440ep DTS to dts-v1

Grant Erickson (2):
      ibm_newemac: Parameterize EMAC Multicast Match Handling
      ibm_newemac: Add MII mode support to the EMAC RGMII bridge.

Grant Likely (7):
      powerpc/bootwrapper: Add documentation of boot wrapper targets
      powerpc/bootwrapper: add missing bit of simpleImage target
      powerpc/bootwrapper: Allow user to specify additional default
targets
      powerpc/440: Convert Virtex ML507 device tree to dts-v1
      powerpc/mpc5200: Add PSC helpers for bestcomm engine
      powerpc/mpc5200: fix compile warnings in bestcomm driver
      powerpc: Modify MPC52xx maintainers entry to cover all MPC5xxx
parts

Imre Kaloz (1):
      powerpc/4xx: MTD support for the AMCC Taishan Board

Jason Jin (5):
      [POWERPC] Update booting-without-of for Freescale PCIe MSI
      [POWERPC] fsl: PCIe MSI support for 83xx/85xx/86xx processors.
      [POWERPC] 86xx: Enable MSI support for MPC8610HPCD board
      [POWERPC] 85xx: Enable MSI support for 85xxds board
      powerpc/85xx: Minor fixes for 85xxds and 8536ds board.

Jeremy Kerr (4):
      powerpc/spufs: avoid magic numbers for mapping sizes
      powerpc/spufs: allow spufs files to specify sizes
      powerpc/spufs: add sizes for context files
      powerpc/spufs: only add ".ctx" file with "debug" mount option

Jerone Young (1):
      powerpc/booke: Fix definitions for dbcr[1-2] and dbsr registers

Jochen Friedrich (1):
      powerpc/CPM: Add i2c pins to dts and board setup

Joel Schopp (2):
      powerpc: Add cputable entry for Power7 architected mode
      powerpc: Tell firmware we support architecture V2.06

John Linn (5):
      powerpc/virtex: add dts file for ML507 reference design
      powerpc/virtex: Fix booting of Xilinx FPGAs with 16550 for 405 and
440
      powerpc/virtex: add Xilinx Virtex 5 ppc440 platform support
      powerpc/virtex: add Xilinx 440 cpu to the cputable
      powerpc/virtex: add defconfig for virtex 5 platforms

John Rigby (4):
      powerpc/mpc5121: Update device tree for MPC5121ADS evaluation
board
      powerpc/mpc5121: Add clock driver
      powerpc/mpc5121: Add generic board support for MPC5121 platforms
      powerpc/mpc5121: Add support for CPLD on MPC5121ADS board

Jon Smirl (1):
      powerpc/i2c: Convert i2c-mpc into an of_platform driver

Josh Boyer (5):
      [POWERPC] 4xx: Fix PCI mem in rainier DTS
      [POWERPC] 4xx: Fix compiler warning on DCR_NATIVE only builds
      Revert "[POWERPC] 4xx: Fix 460GT support to not enable FPU"
      powerpc/4xx: Workaround for PPC440EPx/GRx PCI_28 Errata
      powerpc/44x: Update ppc44x_defconfig

Julia Lawall (1):
      drivers/macintosh/smu.c: Improve error handling

Kim Phillips (1):
      powerpc/fsl: update crypto node definition and device tree
instances

Kumar Gala (29):
      [POWERPC] Set lower flag bits in regs->trap to indicate debug
level exception
      [POWERPC] mpic: Deal with bogus NIRQ in Feature Reporting Register
      [POWERPC] Cleanup mpic nodes in .dts
      [POWERPC] 85xx: Add next-level-cache property
      [POWERPC] Move to runtime allocated exception stacks
      [POWERPC] Rework EXC_LEVEL_EXCEPTION_PROLOG code
      [POWERPC] 40x/Book-E: Save/restore volatile exception registers
      powerpc/booke: Fix some comments related to debug level exceptions
      powerpc/booke: Add support for new e500mc core
      powerpc/85xx: add DOZE/NAP support for e500 core
      powerpc/e500mc: flush L2 on NAP for e500mc
      cpm_uart: fix whitespace issues
      cpm_uart: Remove !CONFIG_PPC_CPM_NEW_BINDING code
      powerpc/cpm: Remove !CONFIG_PPC_CPM_NEW_BINDING code
      powerpc/kprobes: Some minor fixes
      powerpc/booke: Add kprobes support for booke style processors
      powerpc: Add dma nodes to 83xx, 85xx and 86xx boards
      powerpc: Move common module code into its own file
      powerpc/bootwrapper: Pad .dtb by default
      powerpc: Fix building of feature-fixup tests on ppc32
      powerpc: Fixup lwsync at runtime
      powerpc/85xx: Fix KSI8560 .dts
      powerpc/85xx: minor fixes for MPC85xx DS board port
      powerpc/85xx: Add support for MPC8536DS
      powerpc/86xx: Refactor pic init
      powerpc/booke: don't reinitialize time base
      powerpc: Add 82xx/83xx/86xx to 6xx Multiplatform
      powerpc/fsl: Refactor device bindings
      powerpc: Fix pte_update for CONFIG_PTE_64BIT and !
PTE_ATOMIC_UPDATES

Laurent Pinchart (1):
      cpm_uart: Support uart_wait_until_sent()

Luke Browning (2):
      powerpc/spufs: provide context debug file
      powerpc/spufs: don't extend time time slice if context is not in
spu_run

Mark Nelson (4):
      powerpc/dma: Add struct iommu_table argument to iommu_map_sg()
      powerpc/dma: implement new dma_*map*_attrs() interfaces
      powerpc/cell: cell_dma_dev_setup_iommu() return the iommu table
      powerpc: move device_to_mask() to dma-mapping.h

Maxim Shchetynin (1):
      powerpc/spufs: add atomic busy_spus counter to struct cbe_spu_info

Michael Ellerman (32):
      [POWERPC] Move declaration of init_bootmem_done into system.h
      [POWERPC] Fix sparse warnings in arch/powerpc/mm
      [POWERPC] Move declaration of tce variables into mmu-hash64.h
      [POWERPC] Remove duplicate variable definitions in mm/tlb_64.c
      [POWERPC] sysdev/mpic_msi.c should include sysdev/mpic.h
      [POWERPC] Add a declaration for xmon()
      [POWERPC] Move xmon_irq() declaration into xmon.h
      [POWERPC] Fix sparse warnings in xmon.c
      [POWERPC] Make cpus_in_xmon static and remove extern mess from
hvc_console.c
      [POWERPC] Fix sparse warnings in arch/powerpc/kernel
      [POWERPC] pseries/firmware.c should include pseries/pseries.h
      [POWERPC] Fix sparse warnings in arch/powerpc/platforms/pseries
      [POWERPC] Add debugging trigger to Axon MSI code
      [POWERPC] Remove unnecessary cast in arch_deref_entry_point()
      powerpc: Rework Axon MSI setup so we can avoid freeing the
irq_host
      powerpc: Rework ipic_init() so we can avoid freeing the irq_host
      powerpc: Rework qe_ic_init() so we can avoid freeing the irq_host
      powerpc: Fix irq_alloc_host() reference counting and callers
      powerpc: Move code patching code into
arch/powerpc/lib/code-patching.c
      powerpc: Allow create_branch() to return errors
      powerpc: Make create_branch() return errors if the branch target
is too large
      powerpc: Add ppc_function_entry() which gets the entry point for a
function
      powerpc: Add new code patching routines
      powerpc: Add tests of the code patching routines
      powerpc: Add PPC_NOP_INSTR, a hash define for the preferred nop
instruction
      powerpc: Split out do_feature_fixups() from cputable.c
      powerpc: Consolidate CPU and firmware feature fixup macros
      powerpc: Consolidate feature fixup macros for 64/32 bit
      powerpc: Introduce infrastructure for feature sections with
alternatives
      powerpc: Add logic to patch alternative feature sections
      powerpc: Add self-tests of the feature fixup code
      powerpc: Use an alternative feature section in entry_64.S

Michael Neuling (19):
      powerpc: Add cputable entry for POWER7
      powerpc: Fix MSR setting in 32 bit signal code
      powerpc: Add macros to access floating point registers in
thread_struct.
      powerpc: Move altivec_unavailable
      powerpc: Make load_up_fpu and load_up_altivec callable
      powerpc: Introduce VSX thread_struct and CONFIG_VSX
      powerpc: Add VSX CPU feature
      powerpc: Add VSX assembler code macros
      powerpc: Add VSX context save/restore, ptrace and signal support
      powerpc: Add CONFIG_VSX config option
      powerpc: Fix compile error for CONFIG_VSX
      powerpc: Update for VSX core file and ptrace
      powerpc: Fix compile warning in init_thread
      powerpc: Clean up copy_to/from_user for vsx and fpr
      powerpc: Remove old dump_task_* functions
      powerpc: fix swapcontext backwards compat. with VSX ucontext
changes
      powerpc: remove unused variable in emulate_fp_pair
      powerpc: fix giveup_vsx to save registers correctly
      powerpc: Add VSX load/store alignment exception handler

Mike Mason (1):
      powerpc/eeh: PERR/SERR bit settings during EEH device recovery

Nathan Fontenot (5):
      powerpc/pseries: Allow phandle to be specified in formats other
than decimal
      powerpc/pseries: Use base address to derive starting page frame
number
      powerpc/pseries: Update the device tree correctly for drconf
memory add/remove
      powerpc/pseries: Split code into helper routines for drconf memory
      powerpc/pseries: Update numa association of hotplug memory add for
drconf memory

Nathan Lynch (1):
      powerpc: Add PPC_FEATURE_PSERIES_PERFMON_COMPAT

Nick Piggin (2):
      powerpc: Optimise smp_wmb on 64-bit processors
      spufs: Convert nopfn to fault

Nye Liu (1):
      powerpc/CPM: Minor cosmetic changes to udbg_putc

Olaf Hering (1):
      [POWERPC] Create modalias file in sysfs for of_platform bus

Paul Gortmaker (1):
      powerpc/ibmebus: more meaningful variable name

Paul Mackerras (3):
      [POWERPC] Defer processing of interrupts when the CPU wakes from
sleep mode
      powerpc: Remove arch/ppc and include/asm-ppc
      powerpc: Only demote individual slices rather than whole process

Remi Machet (6):
      [POWERPC] Create of_buses for MV64x60 devices
      powerpc: DTS file for the C2K
      powerpc: Boot code for the C2K
      powerpc: C2K board driver
      powerpc: Default configuration for C2K
      powerpc: Add C2K to configuration

Robert P. J. Day (2):
      [POWERPC] Get most of ioctl.h content from <asm-generic/ioctl.h>
      OpenFirmware: Include <linux/of_i2c.h> from of_i2c.c.

Roel Kluin (2):
      [POWERPC] mpic_pasemi_msi: Failed allocation unnoticed
      [POWERPC] mpic_u3msi: Failed allocation unnoticed

Roland McGrath (2):
      [POWERPC] Define and use TLF_RESTORE_SIGMASK
      [POWERPC] Tweak VDSO linker script to avoid upsetting old binutils

Rune Torgersen (3):
      powerpc: Check that TASK_SIZE does not overlap KERNEL_START
      cpm_uart: Fix cpm uart corruption with PREEMPT_RT
      powerpc: Fix pq2fads irq handling with PREEMPT_RT

Scott Wood (2):
      [POWERPC] Add 6xx-style HID0_SLEEP support.
      powerpc: Fix copy-and-paste error in clrsetbits_le16

Sean MacLennan (3):
      [POWERPC] PIKA Warp: Update DTS to support Rev B boards
      [POWERPC] PIKA Warp: Update platform code to support Rev B boards
      powerpc/44x: Support NAND boot for Rev A Warp boards

Segher Boessenkool (1):
      powerpc: Get rid of CROSS32{AS,LD,OBJCOPY}

Sonny Rao (2):
      powerpc: Add driver for Barrier Synchronization Register
      powerpc: Don't spin on sync instruction at boot time

Srinivasa Ds (1):
      powerpc: Implement task_pt_regs() accessor

Stefan Roese (2):
      powerpc/4xx: PCIe driver now detects if a port is disabled via the
dev-tree
      powerpc: Fix problems with 32bit PPC's running with >= 4GB of RAM

Stephen Neuendorffer (1):
      [POWERPC] Refactor DCR code

Stephen Rothwell (14):
      [POWERPC] Move of_device_get_modalias to drivers/of
      of_serial: Use linux/of_platform.h instead of asm
      platinumfb: Use linux/of_{device,platform}.h instead of asm
      viotape: Use unlocked_ioctl
      pasemi-rng: Use linux/of_platform.h instead of asm
      hwmon: Use linux/of_platform.h instead of asm
      macintosh: Use linux/of_{device,platform}.h instead of asm
      drivers/net: Use linux/of_{device,platform}.h instead of asm
      pcmcia: Use linux/of_{device,platform}.h instead of asm
      powerpc: Explicitly copy elements of pt_regs
      powerpc/pata_mpc52xx: use linux/of_platform.h instead of asm
      powerpc/mpc52xx_psc_spi: use linux/of_platform.h instead of asm
      powerpc/mpc5200_wdt: use linux/of_platform.h instead of asm
      powerpc: mman.h export fixups

Takashi Iwai (1):
      powerpc: Fix a build problem on ppc32 with new DMA_ATTRs

Timur Tabi (3):
      [POWERPC] fsl: Add warning for unrecognized I2C nodes in the
device tree
      [POWERPC] fsl: Add CS4270 i2c data to fsl_soc.c
      [POWERPC] fsl: Update fsl_soc to use cell-index property of I2C
nodes

Tony Breeds (2):
      powerpc: Change the default link address for pSeries zImage
kernels
      powerpc: Fix building of arch/powerpc/mm/mem.o when
MEMORY_HOTPLUG=y and SPARSEMEM=n

Trent Piepho (1):
      powerpc: Improve (in|out)_[bl]eXX() asm code

Valentine Barshak (1):
      powerpc/4xx: Fix resource issue in warp-nand.c

Vitaly Bordug (1):
      powerpc/85xx: Update pin setup for 8560ads

Wolfgang Grandegger (6):
      powerpc/85xx: correct vendor prefix in DTS files for TQM85xx
modules
      powerpc/85xx: add board support for the TQM8548 modules
      powerpc/85xx: support for the TQM8548 module using the big Flash
      powerpc/85xx: add local bus nodes for Flash and CAN to tqm8560.dts
      powerpc/mpc5200: add missing MSCAN FDT nodes for TQM52xx
      powerpc/85xx: TQM8548: add missing support for RTC and LM75



