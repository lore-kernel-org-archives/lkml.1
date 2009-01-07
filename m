Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZAGQCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZAGQCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZAGQCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:02:14 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:53612 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZAGQCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=dwt+9CGXu6bNVk4TZZZt1rKknXMTIyrUhuTMfxME6GJAQpwzRn4BKtRiijhGhY7E5+
         p1vUATsv0Hn/mlBh1/n3IbJ1uApLaZDWuzlMgnFPQ92MjzK5xfGN9Z3wlnh47/TFGqPK
         NghAXP/TOvHm9uWUv3QbWGvjD+D/aQ0++wAa0=
Message-ID: <386072610901070802r2819c656y6a6619b44e91550@mail.gmail.com>
Date: Thu, 8 Jan 2009 00:02:10 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin updates for 2.6.29 merge window
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: b6f331d3dce9d58e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

In this merge window, Blackfin arch has several significant changes:

 - SMP-like patches for dual core processor BF561
 - RT feature ADEOS patch for Blackfin port
 - New processor support BF51x and BF538
 - Faster C implementation of  no-MPU CPLB handler
 - Oprofile stuff updates
 - bug fixing and code cleanup

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 Documentation/blackfin/00-INDEX                    |    3 +
 Documentation/blackfin/bfin-gpio-notes.txt         |   71 +
 arch/blackfin/Kconfig                              |  204 +-
 arch/blackfin/Kconfig.debug                        |   30 +-
 arch/blackfin/Makefile                             |   18 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig       | 1191 ++++++
 arch/blackfin/configs/BF526-EZBRD_defconfig        |  345 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig        |  551 ++-
 arch/blackfin/configs/BF533-EZKIT_defconfig        |  316 ++-
 arch/blackfin/configs/BF533-STAMP_defconfig        |  403 ++-
 arch/blackfin/configs/BF537-STAMP_defconfig        |  463 ++-
 arch/blackfin/configs/BF538-EZKIT_defconfig        | 1368 +++++++
 arch/blackfin/configs/BF548-EZKIT_defconfig        |  518 ++-
 arch/blackfin/configs/BF561-EZKIT_defconfig        |  321 ++-
 arch/blackfin/configs/BlackStamp_defconfig         |    3 +-
 arch/blackfin/configs/CM-BF527_defconfig           |   24 +-
 arch/blackfin/configs/CM-BF533_defconfig           |    6 +-
 arch/blackfin/configs/CM-BF537E_defconfig          |   22 +-
 arch/blackfin/configs/CM-BF537U_defconfig          |   22 +-
 arch/blackfin/configs/CM-BF548_defconfig           |   10 +-
 arch/blackfin/configs/CM-BF561_defconfig           |    6 +-
 arch/blackfin/configs/H8606_defconfig              |    3 +-
 arch/blackfin/configs/IP0X_defconfig               |    3 +-
 arch/blackfin/configs/PNAV-10_defconfig            |  596 ++--
 arch/blackfin/configs/SRV1_defconfig               |   21 +-
 arch/blackfin/configs/TCM-BF537_defconfig          |  165 +-
 arch/blackfin/include/asm/atomic.h                 |  151 +-
 arch/blackfin/include/asm/bfin-global.h            |    7 +-
 arch/blackfin/include/asm/bfin5xx_spi.h            |   28 +-
 arch/blackfin/include/asm/bfin_sdh.h               |   19 +
 arch/blackfin/include/asm/bfin_sport.h             |    3 -
 arch/blackfin/include/asm/bfrom.h                  |    5 +
 arch/blackfin/include/asm/bitops.h                 |  203 +-
 arch/blackfin/include/asm/blackfin.h               |   10 +-
 arch/blackfin/include/asm/cache.h                  |   29 +
 arch/blackfin/include/asm/cacheflush.h             |   20 +-
 arch/blackfin/include/asm/checksum.h               |    3 +-
 arch/blackfin/include/asm/context.S                |   47 +-
 arch/blackfin/include/asm/cplb-mpu.h               |   61 -
 arch/blackfin/include/asm/cplb.h                   |   25 +-
 arch/blackfin/include/asm/cplbinit.h               |   83 +-
 arch/blackfin/include/asm/cpu.h                    |   41 +
 arch/blackfin/include/asm/dma.h                    |  220 +-
 arch/blackfin/include/asm/entry.h                  |   11 +
 arch/blackfin/include/asm/gpio.h                   |  226 +-
 arch/blackfin/include/asm/hardirq.h                |    2 +
 arch/blackfin/include/asm/io.h                     |   14 +-
 arch/blackfin/include/asm/ipipe.h                  |  278 ++
 arch/blackfin/include/asm/ipipe_base.h             |   80 +
 arch/blackfin/include/asm/irq.h                    |  296 ++-
 arch/blackfin/include/asm/l1layout.h               |    5 +-
 .../include/mach => include/asm}/mem_init.h        |  164 +-
 arch/blackfin/include/asm/mem_map.h                |   75 +
 arch/blackfin/include/asm/mmu_context.h            |   27 +-
 arch/blackfin/include/asm/mutex-dec.h              |  112 +
 arch/blackfin/include/asm/mutex.h                  |   63 +
 arch/blackfin/include/asm/pda.h                    |   70 +
 arch/blackfin/include/asm/percpu.h                 |   12 +-
 arch/blackfin/include/asm/pgtable.h                |    1 +
 arch/blackfin/include/asm/processor.h              |   28 +-
 arch/blackfin/include/asm/reboot.h                 |    4 +-
 arch/blackfin/include/asm/rwlock.h                 |    6 +
 arch/blackfin/include/asm/serial.h                 |    1 +
 arch/blackfin/include/asm/smp.h                    |   44 +
 arch/blackfin/include/asm/spinlock.h               |   87 +-
 arch/blackfin/include/asm/spinlock_types.h         |   22 +
 arch/blackfin/include/asm/system.h                 |  185 +-
 arch/blackfin/include/asm/thread_info.h            |    5 +-
 arch/blackfin/include/asm/uaccess.h                |   89 +-
 arch/blackfin/include/asm/xor.h                    |    1 +
 arch/blackfin/kernel/Makefile                      |    7 +-
 arch/blackfin/kernel/asm-offsets.c                 |   29 +
 arch/blackfin/kernel/bfin_dma_5xx.c                |  936 ++----
 arch/blackfin/kernel/bfin_gpio.c                   |  448 ++-
 arch/blackfin/kernel/bfin_ksyms.c                  |  101 +-
 arch/blackfin/kernel/cplb-mpu/Makefile             |    6 +-
 arch/blackfin/kernel/cplb-mpu/cacheinit.c          |    4 +-
 arch/blackfin/kernel/cplb-mpu/cplbinfo.c           |  136 -
 arch/blackfin/kernel/cplb-mpu/cplbinit.c           |   48 +-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |  119 +-
 arch/blackfin/kernel/cplb-nompu/Makefile           |    8 +-
 arch/blackfin/kernel/cplb-nompu/cacheinit.c        |   25 +-
 arch/blackfin/kernel/cplb-nompu/cplbhdlr.S         |  130 -
 arch/blackfin/kernel/cplb-nompu/cplbinfo.c         |  195 -
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |  521 +--
 arch/blackfin/kernel/cplb-nompu/cplbmgr.S          |  646 ---
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c          |  283 ++
 arch/blackfin/kernel/cplbinfo.c                    |  177 +
 arch/blackfin/kernel/early_printk.c                |    4 +-
 arch/blackfin/kernel/entry.S                       |    5 +
 arch/blackfin/kernel/fixed_code.S                  |    6 +-
 arch/blackfin/kernel/ipipe.c                       |  428 ++
 arch/blackfin/kernel/irqchip.c                     |   46 +-
 arch/blackfin/kernel/kgdb.c                        |  125 +-
 arch/blackfin/kernel/kgdb_test.c                   |  123 +
 arch/blackfin/kernel/mcount.S                      |   70 +
 arch/blackfin/kernel/module.c                      |  152 +-
 arch/blackfin/kernel/process.c                     |   32 +-
 arch/blackfin/kernel/ptrace.c                      |   17 +-
 arch/blackfin/kernel/reboot.c                      |   24 +-
 arch/blackfin/kernel/setup.c                       |  218 +-
 arch/blackfin/kernel/time.c                        |  162 +-
 arch/blackfin/kernel/traps.c                       |   75 +-
 arch/blackfin/kernel/vmlinux.lds.S                 |    9 +-
 arch/blackfin/lib/checksum.c                       |    4 +
 arch/blackfin/lib/ins.S                            |  272 +-
 arch/blackfin/lib/muldi3.S                         |   68 +
 arch/blackfin/lib/muldi3.c                         |   99 -
 arch/blackfin/mach-bf518/Kconfig                   |  233 ++
 arch/blackfin/mach-bf518/Makefile                  |    5 +
 arch/blackfin/mach-bf518/boards/Kconfig            |   12 +
 arch/blackfin/mach-bf518/boards/Makefile           |    5 +
 arch/blackfin/mach-bf518/boards/ezbrd.c            |  669 +++
 arch/blackfin/mach-bf518/dma.c                     |  118 +
 arch/blackfin/mach-bf518/include/mach/anomaly.h    |   79 +
 arch/blackfin/mach-bf518/include/mach/bf518.h      |  132 +
 .../mach-bf518/include/mach/bfin_serial_5xx.h      |  169 +
 arch/blackfin/mach-bf518/include/mach/blackfin.h   |  105 +
 arch/blackfin/mach-bf518/include/mach/cdefBF512.h  |   46 +
 arch/blackfin/mach-bf518/include/mach/cdefBF514.h  |   48 +
 arch/blackfin/mach-bf518/include/mach/cdefBF516.h  |  213 +
 arch/blackfin/mach-bf518/include/mach/cdefBF518.h  |  282 ++
 .../mach-bf518/include/mach/cdefBF51x_base.h       | 1208 ++++++
 arch/blackfin/mach-bf518/include/mach/defBF512.h   |   42 +
 arch/blackfin/mach-bf518/include/mach/defBF514.h   |  113 +
 arch/blackfin/mach-bf518/include/mach/defBF516.h   |  490 +++
 arch/blackfin/mach-bf518/include/mach/defBF518.h   |  651 +++
 .../mach-bf518/include/mach/defBF51x_base.h        | 1940 +++++++++
 arch/blackfin/mach-bf518/include/mach/dma.h        |   33 +
 arch/blackfin/mach-bf518/include/mach/gpio.h       |   60 +
 arch/blackfin/mach-bf518/include/mach/irq.h        |  260 ++
 arch/blackfin/mach-bf518/include/mach/mem_map.h    |  108 +
 arch/blackfin/mach-bf518/include/mach/portmux.h    |  188 +
 arch/blackfin/mach-bf518/ints-priority.c           |   99 +
 arch/blackfin/mach-bf527/Kconfig                   |   34 +-
 arch/blackfin/mach-bf527/Makefile                  |    2 -
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |  111 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c            |   90 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |  176 +-
 arch/blackfin/mach-bf527/dma.c                     |    2 +-
 arch/blackfin/mach-bf527/head.S                    |  146 -
 arch/blackfin/mach-bf527/include/mach/anomaly.h    |   10 +-
 arch/blackfin/mach-bf527/include/mach/bf527.h      |    8 +-
 arch/blackfin/mach-bf527/include/mach/bfin_sir.h   |  142 -
 .../mach-bf527/include/mach/cdefBF52x_base.h       |  102 +-
 arch/blackfin/mach-bf527/include/mach/dma.h        |   32 +-
 arch/blackfin/mach-bf527/include/mach/gpio.h       |   68 +
 arch/blackfin/mach-bf527/include/mach/irq.h        |   32 +-
 arch/blackfin/mach-bf527/include/mach/mem_map.h    |    6 +
 arch/blackfin/mach-bf527/ints-priority.c           |   16 +-
 arch/blackfin/mach-bf533/Kconfig                   |    2 +-
 arch/blackfin/mach-bf533/Makefile                  |    2 -
 arch/blackfin/mach-bf533/boards/H8606.c            |   24 +-
 arch/blackfin/mach-bf533/boards/blackstamp.c       |   24 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   39 +-
 arch/blackfin/mach-bf533/boards/ezkit.c            |   26 +-
 arch/blackfin/mach-bf533/boards/generic_board.c    |   35 +
 arch/blackfin/mach-bf533/boards/ip0x.c             |   24 +-
 arch/blackfin/mach-bf533/boards/stamp.c            |   58 +-
 arch/blackfin/mach-bf533/dma.c                     |    2 +-
 arch/blackfin/mach-bf533/head.S                    |  137 -
 arch/blackfin/mach-bf533/include/mach/anomaly.h    |   11 +-
 arch/blackfin/mach-bf533/include/mach/bf533.h      |    4 +-
 arch/blackfin/mach-bf533/include/mach/bfin_sir.h   |  125 -
 arch/blackfin/mach-bf533/include/mach/blackfin.h   |    7 +
 arch/blackfin/mach-bf533/include/mach/cdefBF532.h  |  177 +-
 arch/blackfin/mach-bf533/include/mach/dma.h        |   40 +-
 arch/blackfin/mach-bf533/include/mach/gpio.h       |   34 +
 arch/blackfin/mach-bf533/include/mach/irq.h        |   14 +-
 arch/blackfin/mach-bf533/include/mach/mem_init.h   |  297 --
 arch/blackfin/mach-bf533/include/mach/mem_map.h    |    6 +
 arch/blackfin/mach-bf537/Kconfig                   |   34 +-
 arch/blackfin/mach-bf537/Makefile                  |    2 -
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |   63 +-
 arch/blackfin/mach-bf537/boards/generic_board.c    |  109 +-
 arch/blackfin/mach-bf537/boards/minotaur.c         |   48 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |   50 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |  280 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |   63 +-
 arch/blackfin/mach-bf537/dma.c                     |    2 +-
 arch/blackfin/mach-bf537/head.S                    |  146 -
 arch/blackfin/mach-bf537/include/mach/anomaly.h    |   13 +-
 arch/blackfin/mach-bf537/include/mach/bf537.h      |    2 +-
 arch/blackfin/mach-bf537/include/mach/bfin_sir.h   |  142 -
 arch/blackfin/mach-bf537/include/mach/blackfin.h   |    2 +-
 arch/blackfin/mach-bf537/include/mach/cdefBF534.h  |   91 +-
 arch/blackfin/mach-bf537/include/mach/dma.h        |   32 +-
 arch/blackfin/mach-bf537/include/mach/gpio.h       |   68 +
 arch/blackfin/mach-bf537/include/mach/irq.h        |   32 +-
 arch/blackfin/mach-bf537/include/mach/mem_init.h   |  303 --
 arch/blackfin/mach-bf537/include/mach/mem_map.h    |    6 +
 arch/blackfin/mach-bf537/ints-priority.c           |   16 +-
 arch/blackfin/mach-bf538/Kconfig                   |  164 +
 arch/blackfin/mach-bf538/Makefile                  |    5 +
 arch/blackfin/mach-bf538/boards/Kconfig            |   12 +
 arch/blackfin/mach-bf538/boards/Makefile           |    5 +
 arch/blackfin/mach-bf538/boards/ezkit.c            |  606 +++
 arch/blackfin/mach-bf538/dma.c                     |  161 +
 arch/blackfin/mach-bf538/include/mach/anomaly.h    |  132 +
 arch/blackfin/mach-bf538/include/mach/bf538.h      |  124 +
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |  183 +
 arch/blackfin/mach-bf538/include/mach/blackfin.h   |  101 +
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h  | 2108 ++++++++++
 arch/blackfin/mach-bf538/include/mach/cdefBF539.h  |  240 ++
 arch/blackfin/mach-bf538/include/mach/defBF539.h   | 4243 ++++++++++++++++++++
 arch/blackfin/mach-bf538/include/mach/dma.h        |   41 +
 arch/blackfin/mach-bf538/include/mach/gpio.h       |   79 +
 arch/blackfin/mach-bf538/include/mach/irq.h        |  211 +
 arch/blackfin/mach-bf538/include/mach/mem_map.h    |  113 +
 arch/blackfin/mach-bf538/include/mach/portmux.h    |  106 +
 arch/blackfin/mach-bf538/ints-priority.c           |   94 +
 arch/blackfin/mach-bf548/Kconfig                   |    2 +-
 arch/blackfin/mach-bf548/Makefile                  |    2 -
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |  166 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |  156 +-
 arch/blackfin/mach-bf548/dma.c                     |    2 +-
 arch/blackfin/mach-bf548/head.S                    |  158 -
 arch/blackfin/mach-bf548/include/mach/anomaly.h    |    5 +
 arch/blackfin/mach-bf548/include/mach/bf548.h      |    2 +-
 arch/blackfin/mach-bf548/include/mach/bfin_sir.h   |  166 -
 arch/blackfin/mach-bf548/include/mach/blackfin.h   |    2 +-
 .../mach-bf548/include/mach/cdefBF54x_base.h       |  114 +-
 arch/blackfin/mach-bf548/include/mach/dma.h        |   32 +-
 arch/blackfin/mach-bf548/include/mach/irq.h        |    2 +-
 arch/blackfin/mach-bf548/include/mach/mem_init.h   |  255 --
 arch/blackfin/mach-bf548/include/mach/mem_map.h    |    6 +
 arch/blackfin/mach-bf561/Kconfig                   |    8 +-
 arch/blackfin/mach-bf561/Makefile                  |    3 +-
 arch/blackfin/mach-bf561/atomic.S                  |  919 +++++
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   39 +-
 arch/blackfin/mach-bf561/boards/ezkit.c            |   89 +-
 arch/blackfin/mach-bf561/boards/generic_board.c    |   35 +
 arch/blackfin/mach-bf561/boards/tepla.c            |   34 +
 arch/blackfin/mach-bf561/dma.c                     |    2 +-
 arch/blackfin/mach-bf561/head.S                    |  136 -
 arch/blackfin/mach-bf561/include/mach/anomaly.h    |   16 +-
 arch/blackfin/mach-bf561/include/mach/bf561.h      |    2 +-
 arch/blackfin/mach-bf561/include/mach/bfin_sir.h   |  125 -
 arch/blackfin/mach-bf561/include/mach/blackfin.h   |    4 +
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h  |  103 +-
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |    3 +
 arch/blackfin/mach-bf561/include/mach/dma.h        |   16 +-
 arch/blackfin/mach-bf561/include/mach/gpio.h       |   68 +
 arch/blackfin/mach-bf561/include/mach/mem_init.h   |  295 --
 arch/blackfin/mach-bf561/include/mach/mem_map.h    |   80 +
 arch/blackfin/mach-bf561/include/mach/smp.h        |   22 +
 arch/blackfin/mach-bf561/secondary.S               |  215 +
 arch/blackfin/mach-bf561/smp.c                     |  167 +
 arch/blackfin/mach-common/Makefile                 |    4 +-
 arch/blackfin/mach-common/cache-c.c                |   24 +
 arch/blackfin/mach-common/cache.S                  |    6 +-
 arch/blackfin/mach-common/clocks-init.c            |   93 +
 arch/blackfin/mach-common/cpufreq.c                |    6 +-
 arch/blackfin/mach-common/dpmc_modes.S             |    3 +-
 arch/blackfin/mach-common/entry.S                  |  132 +-
 arch/blackfin/mach-common/head.S                   |  117 +-
 arch/blackfin/mach-common/interrupt.S              |   80 +-
 arch/blackfin/mach-common/ints-priority.c          |  541 ++-
 arch/blackfin/mach-common/irqpanic.c               |   12 -
 arch/blackfin/mach-common/lock.S                   |    4 +-
 arch/blackfin/mach-common/pm.c                     |   20 +-
 arch/blackfin/mach-common/smp.c                    |  476 +++
 arch/blackfin/mm/init.c                            |   50 +-
 arch/blackfin/mm/sram-alloc.c                      |  339 +-
 arch/blackfin/oprofile/Makefile                    |    3 +-
 arch/blackfin/oprofile/bfin_oprofile.c             |   18 +
 arch/blackfin/oprofile/common.c                    |  168 -
 arch/blackfin/oprofile/op_blackfin.h               |   98 -
 arch/blackfin/oprofile/op_model_bf533.c            |  161 -
 arch/blackfin/oprofile/timer_int.c                 |   73 -
 270 files changed, 30818 insertions(+), 9970 deletions(-)
 create mode 100644 Documentation/blackfin/bfin-gpio-notes.txt
 create mode 100644 arch/blackfin/configs/BF518F-EZBRD_defconfig
 create mode 100644 arch/blackfin/configs/BF538-EZKIT_defconfig
 create mode 100644 arch/blackfin/include/asm/bfin_sdh.h
 delete mode 100644 arch/blackfin/include/asm/cplb-mpu.h
 create mode 100644 arch/blackfin/include/asm/cpu.h
 create mode 100644 arch/blackfin/include/asm/ipipe.h
 create mode 100644 arch/blackfin/include/asm/ipipe_base.h
 rename arch/blackfin/{mach-bf527/include/mach => include/asm}/mem_init.h (67%)
 create mode 100644 arch/blackfin/include/asm/mutex-dec.h
 create mode 100644 arch/blackfin/include/asm/pda.h
 create mode 100644 arch/blackfin/include/asm/rwlock.h
 create mode 100644 arch/blackfin/include/asm/smp.h
 create mode 100644 arch/blackfin/include/asm/spinlock_types.h
 create mode 100644 arch/blackfin/include/asm/xor.h
 delete mode 100644 arch/blackfin/kernel/cplb-mpu/cplbinfo.c
 delete mode 100644 arch/blackfin/kernel/cplb-nompu/cplbhdlr.S
 delete mode 100644 arch/blackfin/kernel/cplb-nompu/cplbinfo.c
 delete mode 100644 arch/blackfin/kernel/cplb-nompu/cplbmgr.S
 create mode 100644 arch/blackfin/kernel/cplb-nompu/cplbmgr.c
 create mode 100644 arch/blackfin/kernel/cplbinfo.c
 create mode 100644 arch/blackfin/kernel/ipipe.c
 create mode 100644 arch/blackfin/kernel/kgdb_test.c
 create mode 100644 arch/blackfin/kernel/mcount.S
 create mode 100644 arch/blackfin/lib/muldi3.S
 delete mode 100644 arch/blackfin/lib/muldi3.c
 create mode 100644 arch/blackfin/mach-bf518/Kconfig
 create mode 100644 arch/blackfin/mach-bf518/Makefile
 create mode 100644 arch/blackfin/mach-bf518/boards/Kconfig
 create mode 100644 arch/blackfin/mach-bf518/boards/Makefile
 create mode 100644 arch/blackfin/mach-bf518/boards/ezbrd.c
 create mode 100644 arch/blackfin/mach-bf518/dma.c
 create mode 100644 arch/blackfin/mach-bf518/include/mach/anomaly.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/bf518.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/blackfin.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/cdefBF512.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/cdefBF514.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/cdefBF516.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/cdefBF518.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/cdefBF51x_base.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/defBF512.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/defBF514.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/defBF516.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/defBF518.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/dma.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/gpio.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/irq.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/mem_map.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/portmux.h
 create mode 100644 arch/blackfin/mach-bf518/ints-priority.c
 delete mode 100644 arch/blackfin/mach-bf527/head.S
 delete mode 100644 arch/blackfin/mach-bf527/include/mach/bfin_sir.h
 create mode 100644 arch/blackfin/mach-bf527/include/mach/gpio.h
 delete mode 100644 arch/blackfin/mach-bf533/head.S
 delete mode 100644 arch/blackfin/mach-bf533/include/mach/bfin_sir.h
 create mode 100644 arch/blackfin/mach-bf533/include/mach/gpio.h
 delete mode 100644 arch/blackfin/mach-bf533/include/mach/mem_init.h
 delete mode 100644 arch/blackfin/mach-bf537/head.S
 delete mode 100644 arch/blackfin/mach-bf537/include/mach/bfin_sir.h
 create mode 100644 arch/blackfin/mach-bf537/include/mach/gpio.h
 delete mode 100644 arch/blackfin/mach-bf537/include/mach/mem_init.h
 create mode 100644 arch/blackfin/mach-bf538/Kconfig
 create mode 100644 arch/blackfin/mach-bf538/Makefile
 create mode 100644 arch/blackfin/mach-bf538/boards/Kconfig
 create mode 100644 arch/blackfin/mach-bf538/boards/Makefile
 create mode 100644 arch/blackfin/mach-bf538/boards/ezkit.c
 create mode 100644 arch/blackfin/mach-bf538/dma.c
 create mode 100644 arch/blackfin/mach-bf538/include/mach/anomaly.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/bf538.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/blackfin.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/cdefBF538.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/cdefBF539.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/defBF539.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/dma.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/gpio.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/irq.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/mem_map.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/portmux.h
 create mode 100644 arch/blackfin/mach-bf538/ints-priority.c
 delete mode 100644 arch/blackfin/mach-bf548/head.S
 delete mode 100644 arch/blackfin/mach-bf548/include/mach/bfin_sir.h
 delete mode 100644 arch/blackfin/mach-bf548/include/mach/mem_init.h
 create mode 100644 arch/blackfin/mach-bf561/atomic.S
 delete mode 100644 arch/blackfin/mach-bf561/head.S
 delete mode 100644 arch/blackfin/mach-bf561/include/mach/bfin_sir.h
 create mode 100644 arch/blackfin/mach-bf561/include/mach/gpio.h
 delete mode 100644 arch/blackfin/mach-bf561/include/mach/mem_init.h
 create mode 100644 arch/blackfin/mach-bf561/include/mach/smp.h
 create mode 100644 arch/blackfin/mach-bf561/secondary.S
 create mode 100644 arch/blackfin/mach-bf561/smp.c
 create mode 100644 arch/blackfin/mach-common/cache-c.c
 create mode 100644 arch/blackfin/mach-common/clocks-init.c
 create mode 100644 arch/blackfin/mach-common/smp.c
 create mode 100644 arch/blackfin/oprofile/bfin_oprofile.c
 delete mode 100644 arch/blackfin/oprofile/common.c
 delete mode 100644 arch/blackfin/oprofile/op_blackfin.h
 delete mode 100644 arch/blackfin/oprofile/op_model_bf533.c
 delete mode 100644 arch/blackfin/oprofile/timer_int.c

Bernd Schmidt (5):
      Blackfin arch: Remove all traces of the relocation stack
      Blackfin arch: fix bugs in linker script when using upstream binutils
      Blackfin arch: fix bug - crashes in tcp_v4_send_reset
      Blackfin arch: Replace C version of 64 bit multiply with hand
optimized assembly
      Blackfin arch: Faster C implementation of  no-MPU CPLB handler

Bryan Wu (4):
      Blackfin arch: add support for Blackfin latest processor family BF51x
      Blackfin arch: fix bug - gpio_bank() macros messed up bank
number caculating with positioning a gpio
      Blackfin arch: Use GPIO_BANKSIZE macro to replace const number
16 for GPIO_BANK_NUM macro caculating
      Blackfin arch: Fix bug - wrong endpoint number and dma channels of USB

Cliff Cai (2):
      Blackfin arch: add sdh support for bf518f-ezbrd
      Blackfin arch: add SDIO host driver platform data

Grace Pan (1):
      Blackfin arch: Enlarge flash partition for kenel for bf533/bf537 boards

Graf Yang (19):
      Blackfin arch: fix bug - kernel with SMP patch can not bootup
      Blackfin arch: SMP supporting patchset: BF561 related code
      Blackfin arch: SMP supporting patchset: Blackfin header files
and machine common code
      Blackfin arch: SMP supporting patchset: Blackfin CPLB related code
      Blackfin arch: SMP supporting patchset: Blackfin kernel and
memory management code
      Blackfin arch: SMP supporting patchset: some other misc code
      Blackfin arch: Add code to free gpio when shutdown irq
      Blackfin arch: Request the gpio resource when making it as an
irq pin, avoiding override it.
      Blackfin arch: Allow a gpio pin be requested both as gpio and irq.
      Blackfin arch: Add document about bfin-gpio
      Blackfin arch: get oprofile work for user space
      Blackfin arch: smp patch cleanup from LKML review
      Blackfin arch: implement support for /proc/dma
      Blackfin arch: update header to match new location
      Blackfin arch: Modify bfin_sir device configuration to board file
      Blackfin arch: Remove wasted SIR header files
      Blackfin arch: Fix bug - IrDA SIR build failed for BF533.
      Blackfin arch: remove hardware PM code, oprofile not use it
      Blackfin arch: Clean oprofile build path for blackfin

Jean Delvare (1):
      Blackfin arch: Fix typo (channel)

Jie Zhang (1):
      Blackfin arch: Print FP at level KERN_NOTICE

Michael Hennerich (18):
      Blackfin arch: BF538/9 Linux kernel Support
      Blackfin arch: lookup channel2irq() only once
      Blackfin arch: Remove useless SSYNCs in DMA code
      Blackfin arch: remove most BUG_ON channel checks
      Blackfin arch: don't assume a specific SPI flash part - take
whatever you probe
      Blackfin arch: Enable ISP1760 USB Host Driver in platform device
initialization code.
      Blackfin arch: Cleanup and unify Blackfin IRQ and GPIO IRQ handling
      Blackfin arch: Convert Blackfin GPIO driver to use common
gpiolib/gpiochip infrastructure
      Blackfin arch: Fix BUG - Kernel does not link when CONFIG_CPU_FREQ_STAT=m
      Blackfin arch: Fix bug - change cpufreq doesn't take effect on bf537 now
      Blackfin arch: fix bugs and unify BFIN_KERNEL_CLOCK option
      Blackfin arch: gpio.h split into machine subfolders like already
done for BF54x
      Blackfin arch: fix bug - kernel build fails with undefined
reference to pm_overflow_handler
      Blackfin arch: Add BF537-STAMP platform support for ENC28J60 SPI
Ethernet MAC
      Blackfin arch:  ADP5588 QWERTY I2C Keyboard Input device driver
      Blackfin arch: Make the interrupt edge and polarity type
configurable based on IORESOURCE_BITS
      Blackfin arch: Add AD7879 defaults for the Blackfin Landscape
LCD EZ-Extender
      Blackfin arch: fix bug - kernel crash after config IP for ethernet port

Michael McTernan (1):
      Blackfin arch: add const to some function prototype and struct dma_channel

Mike Frysinger (101):
      Blackfin arch: unify duplicated bss init code
      Blackfin arch: move EXPORT_SYMBOL to the place where it is
actually defined
      Blackfin arch: add an option to allow people to stick exception
stack into L1 scratch
      Blackfin arch: drop unused exports and comment remaining exports
      Blackfin arch: drop redundant BFIN_DMA_5XX depends
      Blackfin arch: put quotes around error to silence a ton of
warnings from gcc-4.3
      Blackfin arch: remove unused local define
      Blackfin arch: unify check_gpio() to reduce arch differences
      Blackfin arch: fix cmp_label() so it doesnt incorrectly accept
partial leading matches
      Blackfin arch: unify peripheral_request() to reduce arch differences
      Blackfin arch: unify port_setup() to reduce arch differences
      Blackfin arch: refine the gpio check
      Blackfin arch: update anomaly lists to match latest sheets
      Blackfin arch: only add IFLUSH nop padding when anomaly 443 is enabled
      Blackfin arch: update defconfig file for all boards
      Blackfin arch: use sti to set the mask rather than banging on imask
      Blackfin arch: do not bother initializing the first 4k
      Blackfin arch: fixup get_user() macros
      Blackfin arch: enable i2c_bfin_twi0_device in cm_bf548 board
      Blackfin arch: remove useless SSYNC() in irq priority code
      Blackfin arch: use physmap in board resources rather than legacy
config method
      Blackfin arch: fix unused warning for some blackfin derivatives
      Blackfin arch: make ADI board names consistent
      Blackfin arch: rewrite blackfin_invalidate_entire_dcache function
      Blackfin arch: overlay thread.usp over PT_USP
      Blackfin arch: delete old comments and NO_IRQ define
      Blackfin arch: move ack_bad_irq() prototype to hardirq.h to
match other arches
      Blackfin arch: move SIC_SYSIRQ() to the one file that actually uses it
      Blackfin arch: dont export ack_bad_irq as no one else does
      Blackfin arch: delay PLL_CTL/VR_CTL wrappers
      Blackfin arch: set PM_WAKEUP_GPIO_NUMBER default to 2 for everyone
      Blackfin arch: remove superficial check on blackfin watchdog
      Blackfin arch: move fixed code into init section
      Blackfin arch: delete unused vars and add parenthesis to fixup warnings
      Blackfin arch: fix off-by-one errors on end of memory range
      Blackfin arch: introduce an IM_MEM macro to kgdb
      Blackfin arch: move the PORT registers down
      Blackfin arch: move out irq related functions
      Blackfin arch: rename irq_flags to bfin_irq_flags
      Blackfin arch: do not define decode_instruction if hwtrace is turned off
      Blackfin arch: fix building with CONFIG_DEBUG_DOUBLEFAULT
      Blackfin arch: cleanup the time.c code
      Blackfin arch: use generic xor.h
      Blackfin arch: rename cache_lock() to bfin_cache_lock()
      Blackfin arch: add mmiowb() as some drivers expect
      Blackfin arch: remove BFIN_DMA_5XX option
      Blackfin arch: define BASE_BAUD like everyone else
      Blackfin arch: unify cplbinfo files
      Blackfin arch: remove pointless define IN_KERNEL
      Blackfin arch: change return value
      Blackfin arch: do not include init sections in the kernel lock
down as it gets released afterwards
      Blackfin arch: noMMU CPLB lookup tables can be in L1 SRAM
      Blackfin arch: make ROM_BASE depend on ROMKERNEL
      Blackfin arch: add BUG_ON() checks to make sure we dont overflow
the cplb tables
      Blackfin arch: only define HI/LO macros for assembly files
      Blackfin arch: add ANOMALY_05000435 to our headers
      Blackfin arch: fix bug - reboot fails on BF527
      Blackfin arch: delete now unused "cclk" member of blackfin_cpudata
      Blackfin arch: do not allow L2 to be cached on BF561 SMP
      Blackfin arch: add simple-gpio resources to all adi/tinyboards
      Blackfin arch: rewrite cplbinfo to use seq files
      Blackfin arch: cleanup the header file comments
      Blackfin arch: tweak the BUG_ON() check to allow for equal values
      Blackfin arch: rename MAX_BLACKFIN_DMA_CHANNEL to
MAX_DMA_CHANNELS to match everyone else
      Blackfin arch: remove #if check on L2_LENGTH
      Blackfin arch: dma_memcpy() - do not return NULL when
transferring a multiple of 65k
      Blackfin arch: Set TWI/I2C Clock to 100kHz
      Blackfin arch: cleanup - use scm for changelog, not file headers
      Blackfin arch: push bf561 PERIPHERAL_MAP oddity into bf561-specific code
      Blackfin arch: check pointers in safe_dma_memcpy
      Blackfin arch: rewrite dma_memcpy() and dma in/out functions
      Blackfin arch: enable DEBUG_KERNEL for ADI boards
      Blackfin arch: include linux/mm.h since we use PAGE_ALIGN and such
      Blackfin arch: drop custom dma_interrupt_t and just use irq_handler_t
      Blackfin arch: drop irq_callback from struct dma_channel
      Blackfin arch: set_dma_callback: do not store .irq
      Blackfin arch: dma header file: strip down includes to only necessary ones
      Blackfin arch: move most dma functions into static inlines
      Blackfin arch: desc_ptr is a pointer, so declare it as such
      Blackfin arch: request_dma() returns 0 on success, not channel
      Blackfin arch: push cache flushing up to dma_memcpy
      Blackfin arch: add bfin_read_MDMA_S0_CONFIG compat for dma_memcpy
      Blackfin arch: dma code: cannot simply OR the ndsize
      Blackfin arch: add __must_check markings to our user functions
like other arches
      Blackfin arch: stub out pgprot_noncached() like other people
seem to do on nommu
      Blackfin arch: remove unused members of dma_channel struct
      Blackfin arch: add volatile markings to DMA MMRs
      Blackfin arch: add get_dma_config() func to match set_dma_config()
      Blackfin arch: add __init markings to Blackfin timer init functions
      Blackfin arch: show_cpuinfo - consolidate ugly casts
      Blackfin arch: allow clkin_hz to be specified on the command line
      Blackfin arch: do not allow people to pass in a diff clkin_hz value
      Blackfin arch: update anomaly headers to match latest sheets
      Blackfin arch: merge kgdb test code using common CONFIG_KGDB_TESTS
      Blackfin arch: cleanup and unify the ins functions
      Blackfin arch: rewrite get_sclk()/get_vco()
      Blackfin arch: change HWTRACE Kconfig and set it on default
      Blackfin arch: add () to avoid warnings from gcc
      Blackfin arch: fix typo in early printk bit size processing
      Blackfin arch: drop ad73311 test code
      Blackfin arch: fix bug: kernel crash when enable SDIO host driver

Nick Andrew (1):
      Blackfin arch: Fix incorrect use of loose in cpufreq.c

Robin Getz (5):
      Blackfin arch: Add basic irq stack checking for Blackfin
      Blackfin arch: Update some inline assembly, tweak some register
constraints
      Blackfin arch: panic when running on a chip rev below what we
are compiled for
      Blackfin arch: fix bug - kernel detects BF532 incorrectly
      Blackfin arch: fix bug - BF527 0.2 silicon has different CPUID
(DSPID) value

Sonic Zhang (8):
      Blackfin arch: Fix bug - hardware breakpoint doesn't always work in kgdb
      Blackfin arch: Use reads/writes instead of ins/outs directly
      Blackfin arch: disable pthread stack check for SMP at runtime
      Blackfin arch: Make bfin_mac built for bf51x
      Blackfin arch: fix bug - kernel stops at initial console
      Blackfin arch: enable reprogram cclk and sclk for bf518f-ezbrd
      Blackfin arch: Set PB4 as the default irq for bf548 board v1.4+.
      Blackfin arch: update board default configs

Yi Li (4):
      Blackfin arch: workaround bug: spi_mmc driver working in dma
mode may hang the system
      Blackfin arch: add mmc_spi support to BF537-STAMP
      Blackfin arch: Retire old spi_mmc driver
      Blackfin arch:  merge adeos blackfin part to arch/blackfin/
