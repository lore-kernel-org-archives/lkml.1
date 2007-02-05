Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbXBEHi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbXBEHi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 02:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXBEHi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 02:38:28 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:17774 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbXBEHi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 02:38:26 -0500
X-IronPort-AV: i="4.13,280,1167627600"; 
   d="scan'208"; a="26065913:sNHT30077089"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 1/3] Blackfin: architecture patch against Linux kernel 2.6.20
Date: Mon, 5 Feb 2007 02:28:40 -0500
Message-ID: <D3664A3D9376A94BB603EE19E4AA246D10D64758@nwd2exm4.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] Blackfin: architecture patch against Linux kernel 2.6.20
Thread-Index: AcdI90IvR9d9C+1KTOawDvAu4GsZwg==
From: "Wu, Bryan" <Bryan.Wu@analog.com>
To: <akpm@osdl.org>, <arnd@arndb.de>, <rdunlap@xenotime.net>,
       <rdreier@cisco.com>, <castet.matthieu@free.fr>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is the Blackfin architecture patch against Linux kernel 2.6.20,
again. As we promised, some issues are fixed in the latest release with
the help from lkml.

The blackfin-arch patch is at 
https://blackfin.uclinux.org/gf/download/frsrelease/25/2490/blackfin-arc
h-linux-2.6.20.patch
Which, at 1.9M bytes, is too large to attach here. Please let me know if
you want me to do it anyway.

I understand that a full review is a huge job, but I'd appreciate a
pointer or two in the general direction that I need to take this in
order to get it acceptable for mainline.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/Kconfig                              |  891 +++++++
 arch/blackfin/Makefile                             |   81 
 arch/blackfin/boot/Makefile                        |   27 
 arch/blackfin/defconfig                            | 1314 +++++++++++
 arch/blackfin/kernel/Makefile                      |   13 
 arch/blackfin/kernel/asm-offsets.c                 |  138 +
 arch/blackfin/kernel/bfin_dma_5xx.c                |  747 ++++++
 arch/blackfin/kernel/bfin_gpio.c                   |  654 +++++
 arch/blackfin/kernel/bfin_ksyms.c                  |  115 
 arch/blackfin/kernel/dma-mapping.c                 |  174 +
 arch/blackfin/kernel/dualcore_test.c               |   51 
 arch/blackfin/kernel/entry.S                       |   92 
 arch/blackfin/kernel/init_task.c                   |   63 
 arch/blackfin/kernel/irqchip.c                     |  144 +
 arch/blackfin/kernel/module.c                      |  431 +++
 arch/blackfin/kernel/process.c                     |  348 ++
 arch/blackfin/kernel/ptrace.c                      |  413 +++
 arch/blackfin/kernel/setup.c                       |  894 +++++++
 arch/blackfin/kernel/signal.c                      |  431 +++
 arch/blackfin/kernel/sys_bfin.c                    |  133 +
 arch/blackfin/kernel/time.c                        |  326 ++
 arch/blackfin/kernel/traps.c                       |  622 +++++
 arch/blackfin/kernel/vmlinux.lds.S                 |  221 +
 arch/blackfin/lib/Makefile                         |   10 
 arch/blackfin/lib/ashldi3.c                        |   56 
 arch/blackfin/lib/ashrdi3.c                        |   57 
 arch/blackfin/lib/checksum.c                       |  138 +
 arch/blackfin/lib/divsi3.S                         |  156 +
 arch/blackfin/lib/gcclib.h                         |   49 
 arch/blackfin/lib/ins.S                            |   71 
 arch/blackfin/lib/lshrdi3.c                        |   70 
 arch/blackfin/lib/memchr.S                         |   65 
 arch/blackfin/lib/memcmp.S                         |  110 
 arch/blackfin/lib/memcpy.S                         |  129 +
 arch/blackfin/lib/memmove.S                        |  103 
 arch/blackfin/lib/memset.S                         |  103 
 arch/blackfin/lib/modsi3.S                         |   74 
 arch/blackfin/lib/muldi3.c                         |   97 
 arch/blackfin/lib/outs.S                           |   64 
 arch/blackfin/lib/strcmp.c                         |   11 
 arch/blackfin/lib/strcpy.c                         |   11 
 arch/blackfin/lib/strncmp.c                        |   11 
 arch/blackfin/lib/strncpy.c                        |   11 
 arch/blackfin/lib/udivsi3.S                        |  157 +
 arch/blackfin/lib/umodsi3.S                        |   63 
 arch/blackfin/mach-bf533/Kconfig                   |   92 
 arch/blackfin/mach-bf533/Makefile                  |    9 
 arch/blackfin/mach-bf533/boards/Makefile           |    8 
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |  271 ++
 arch/blackfin/mach-bf533/boards/ezkit.c            |  231 +
 arch/blackfin/mach-bf533/boards/generic_board.c    |   97 
 arch/blackfin/mach-bf533/boards/stamp.c            |  328 ++
 arch/blackfin/mach-bf533/cpu.c                     |  163 +
 arch/blackfin/mach-bf533/head.S                    |  776 ++++++
 arch/blackfin/mach-bf533/ints-priority.c           |   67 
 arch/blackfin/mach-bf537/Kconfig                   |  141 +
 arch/blackfin/mach-bf537/Makefile                  |    9 
 arch/blackfin/mach-bf537/boards/Makefile           |    8 
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |  379 +++
 arch/blackfin/mach-bf537/boards/generic_board.c    |  464 +++
 arch/blackfin/mach-bf537/boards/led.S              |  183 +
 arch/blackfin/mach-bf537/boards/pnav10.c           |  541 ++++
 arch/blackfin/mach-bf537/boards/stamp.c            |  575 ++++
 arch/blackfin/mach-bf537/cpu.c                     |  163 +
 arch/blackfin/mach-bf537/head.S                    |  605 +++++
 arch/blackfin/mach-bf537/ints-priority.c           |   76 
 arch/blackfin/mach-bf561/Kconfig                   |  222 +
 arch/blackfin/mach-bf561/Makefile                  |    9 
 arch/blackfin/mach-bf561/boards/Makefile           |    6 
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |  295 ++
 arch/blackfin/mach-bf561/boards/ezkit.c            |  151 +
 arch/blackfin/mach-bf561/boards/generic_board.c    |   82 
 arch/blackfin/mach-bf561/coreb.c                   |  404 +++
 arch/blackfin/mach-bf561/head.S                    |  514 ++++
 arch/blackfin/mach-bf561/ints-priority.c           |  110 
 arch/blackfin/mach-common/Makefile                 |   12 
 arch/blackfin/mach-common/cache.S                  |  255 ++
 arch/blackfin/mach-common/cacheinit.S              |  139 +
 arch/blackfin/mach-common/cplbhdlr.S               |  128 +
 arch/blackfin/mach-common/cplbinfo.c               |  213 +
 arch/blackfin/mach-common/cplbmgr.S                |  605 +++++
 arch/blackfin/mach-common/dpmc.S                   |  420 +++
 arch/blackfin/mach-common/entry.S                  | 1198 ++++++++++
 arch/blackfin/mach-common/interrupt.S              |  255 ++
 arch/blackfin/mach-common/ints-priority-dc.c       |  462 +++
 arch/blackfin/mach-common/ints-priority-sc.c       |  569 ++++
 arch/blackfin/mach-common/irqpanic.c               |  196 +
 arch/blackfin/mach-common/lock.S                   |  206 +
 arch/blackfin/mach-common/pm.c                     |  183 +
 arch/blackfin/mm/Makefile                          |    5 
 arch/blackfin/mm/blackfin_sram.c                   |  537 ++++
 arch/blackfin/mm/blackfin_sram.h                   |   40 
 arch/blackfin/mm/init.c                            |  212 +
 arch/blackfin/mm/kmap.c                            |   84 
 arch/blackfin/oprofile/Kconfig                     |   29 
 arch/blackfin/oprofile/Makefile                    |   14 
 arch/blackfin/oprofile/common.c                    |  170 +
 arch/blackfin/oprofile/op_blackfin.h               |  100 
 arch/blackfin/oprofile/op_model_bf533.c            |  163 +
 arch/blackfin/oprofile/timer_int.c                 |   76 
 fs/Kconfig.binfmt                                  |    2 
 include/asm-blackfin/Kbuild                        |    3 
 include/asm-blackfin/a.out.h                       |   25 
 include/asm-blackfin/atomic.h                      |  144 +
 include/asm-blackfin/auxvec.h                      |    4 
 include/asm-blackfin/bf5xx_timers.h                |  209 +
 include/asm-blackfin/bfin-global.h                 |  121 +
 include/asm-blackfin/bfin5xx_spi.h                 |  170 +
 include/asm-blackfin/bfin_simple_timer.h           |   13 
 include/asm-blackfin/bfin_spi_channel.h            |  182 +
 include/asm-blackfin/bfin_sport.h                  |  177 +
 include/asm-blackfin/bitops.h                      |  213 +
 include/asm-blackfin/blackfin.h                    |   67 
 include/asm-blackfin/bug.h                         |   15 
 include/asm-blackfin/bugs.h                        |   16 
 include/asm-blackfin/byteorder.h                   |   48 
 include/asm-blackfin/cache.h                       |   18 
 include/asm-blackfin/cacheflush.h                  |   91 
 include/asm-blackfin/checksum.h                    |  101 
 include/asm-blackfin/cplb.h                        |   51 
 include/asm-blackfin/cplbinit.h                    |  192 +
 include/asm-blackfin/cpumask.h                     |    6 
 include/asm-blackfin/cputime.h                     |    6 
 include/asm-blackfin/current.h                     |   23 
 include/asm-blackfin/delay.h                       |   43 
 include/asm-blackfin/device.h                      |    7 
 include/asm-blackfin/div64.h                       |    1 
 include/asm-blackfin/dma-mapping.h                 |   68 
 include/asm-blackfin/dma.h                         |  203 +
 include/asm-blackfin/dpmc.h                        |   66 
 include/asm-blackfin/elf.h                         |  127 +
 include/asm-blackfin/emergency-restart.h           |    6 
 include/asm-blackfin/entry.h                       |   61 
 include/asm-blackfin/errno.h                       |    6 
 include/asm-blackfin/fcntl.h                       |   13 
 include/asm-blackfin/flat.h                        |  130 +
 include/asm-blackfin/futex.h                       |    6 
 include/asm-blackfin/gpio.h                        |  369 +++
 include/asm-blackfin/hardirq.h                     |   41 
 include/asm-blackfin/hw_irq.h                      |    6 
 include/asm-blackfin/ide.h                         |   32 
 include/asm-blackfin/io.h                          |  152 +
 include/asm-blackfin/ioctl.h                       |    1 
 include/asm-blackfin/ioctls.h                      |   82 
 include/asm-blackfin/ipc.h                         |    1 
 include/asm-blackfin/ipcbuf.h                      |   30 
 include/asm-blackfin/irq.h                         |   72 
 include/asm-blackfin/irq_regs.h                    |    1 
 include/asm-blackfin/kmap_types.h                  |   21 
 include/asm-blackfin/l1layout.h                    |   31 
 include/asm-blackfin/linkage.h                     |    7 
 include/asm-blackfin/local.h                       |    6 
 include/asm-blackfin/mach-bf533/anomaly.h          |  176 +
 include/asm-blackfin/mach-bf533/bf533.h            |  319 ++
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h  |  105 
 include/asm-blackfin/mach-bf533/blackfin.h         |   46 
 include/asm-blackfin/mach-bf533/cdefBF532.h        |  707 +++++
 include/asm-blackfin/mach-bf533/defBF532.h         | 1178 +++++++++
 include/asm-blackfin/mach-bf533/dma.h              |   56 
 include/asm-blackfin/mach-bf533/irq.h              |  178 +
 include/asm-blackfin/mach-bf533/mem_init.h         |  316 ++
 include/asm-blackfin/mach-bf533/mem_map.h          |  135 +
 include/asm-blackfin/mach-bf535/bf535.h            | 1277 ++++++++++
 include/asm-blackfin/mach-bf535/bf535_serial.h     |  109 
 include/asm-blackfin/mach-bf535/blackfin.h         |   43 
 include/asm-blackfin/mach-bf535/cdefBF535.h        |  121 +
 include/asm-blackfin/mach-bf535/cdefblackfin.h     |   69 
 include/asm-blackfin/mach-bf535/defBF535.h         | 1818
+++++++++++++++
 include/asm-blackfin/mach-bf535/defblackfin.h      |  444 +++
 include/asm-blackfin/mach-bf535/irq.h              |  125 +
 include/asm-blackfin/mach-bf537/anomaly.h          |  120 +
 include/asm-blackfin/mach-bf537/bf537.h            |  300 ++
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h  |  139 +
 include/asm-blackfin/mach-bf537/blackfin.h         |  430 +++
 include/asm-blackfin/mach-bf537/cdefBF534.h        | 1823
+++++++++++++++
 include/asm-blackfin/mach-bf537/cdefBF537.h        |  209 +
 include/asm-blackfin/mach-bf537/defBF534.h         | 2502
+++++++++++++++++++++
 include/asm-blackfin/mach-bf537/defBF537.h         |  404 +++
 include/asm-blackfin/mach-bf537/dma.h              |   55 
 include/asm-blackfin/mach-bf537/irq.h              |  219 +
 include/asm-blackfin/mach-bf537/mem_init.h         |  330 ++
 include/asm-blackfin/mach-bf537/mem_map.h          |  143 +
 include/asm-blackfin/mach-bf561/anomaly.h          |  185 +
 include/asm-blackfin/mach-bf561/bf561.h            |  415 +++
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h  |  105 
 include/asm-blackfin/mach-bf561/blackfin.h         |   53 
 include/asm-blackfin/mach-bf561/cdefBF561.h        | 1544 ++++++++++++
 include/asm-blackfin/mach-bf561/defBF561.h         | 1718
++++++++++++++
 include/asm-blackfin/mach-bf561/dma.h              |   36 
 include/asm-blackfin/mach-bf561/irq.h              |  451 +++
 include/asm-blackfin/mach-bf561/mem_init.h         |  322 ++
 include/asm-blackfin/mach-bf561/mem_map.h          |   61 
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |  474 +++
 include/asm-blackfin/mach-common/context.S         |  335 ++
 include/asm-blackfin/mach-common/def_LPBlackfin.h  |  694 +++++
 include/asm-blackfin/macros.h                      |   95 
 include/asm-blackfin/mem_map.h                     |   12 
 include/asm-blackfin/mman.h                        |   45 
 include/asm-blackfin/mmu.h                         |   30 
 include/asm-blackfin/mmu_context.h                 |  131 +
 include/asm-blackfin/module.h                      |   19 
 include/asm-blackfin/msgbuf.h                      |   31 
 include/asm-blackfin/mutex.h                       |    9 
 include/asm-blackfin/namei.h                       |   19 
 include/asm-blackfin/page.h                        |   89 
 include/asm-blackfin/page_offset.h                 |    6 
 include/asm-blackfin/param.h                       |   22 
 include/asm-blackfin/pci.h                         |  148 +
 include/asm-blackfin/percpu.h                      |    6 
 include/asm-blackfin/pgalloc.h                     |    8 
 include/asm-blackfin/pgtable.h                     |   62 
 include/asm-blackfin/poll.h                        |   24 
 include/asm-blackfin/posix_types.h                 |   65 
 include/asm-blackfin/processor.h                   |  104 
 include/asm-blackfin/ptrace.h                      |  102 
 include/asm-blackfin/resource.h                    |    6 
 include/asm-blackfin/scatterlist.h                 |   26 
 include/asm-blackfin/sections.h                    |    7 
 include/asm-blackfin/segment.h                     |    7 
 include/asm-blackfin/semaphore-helper.h            |   82 
 include/asm-blackfin/semaphore.h                   |  106 
 include/asm-blackfin/sembuf.h                      |   25 
 include/asm-blackfin/setup.h                       |   17 
 include/asm-blackfin/shmbuf.h                      |   42 
 include/asm-blackfin/shmparam.h                    |    6 
 include/asm-blackfin/sigcontext.h                  |   50 
 include/asm-blackfin/siginfo.h                     |   35 
 include/asm-blackfin/signal.h                      |  160 +
 include/asm-blackfin/socket.h                      |   52 
 include/asm-blackfin/sockios.h                     |   12 
 include/asm-blackfin/spinlock.h                    |    6 
 include/asm-blackfin/stat.h                        |   63 
 include/asm-blackfin/statfs.h                      |    6 
 include/asm-blackfin/string.h                      |  104 
 include/asm-blackfin/system.h                      |  253 ++
 include/asm-blackfin/termbits.h                    |  184 +
 include/asm-blackfin/termios.h                     |  106 
 include/asm-blackfin/thread_info.h                 |  144 +
 include/asm-blackfin/timex.h                       |   18 
 include/asm-blackfin/tlb.h                         |   16 
 include/asm-blackfin/tlbflush.h                    |   62 
 include/asm-blackfin/topology.h                    |    6 
 include/asm-blackfin/traps.h                       |   75 
 include/asm-blackfin/types.h                       |   66 
 include/asm-blackfin/uaccess.h                     |  280 ++
 include/asm-blackfin/ucontext.h                    |   30 
 include/asm-blackfin/unaligned.h                   |    6 
 include/asm-blackfin/unistd.h                      |  382 +++
 include/asm-blackfin/user.h                        |   89 
 include/linux/config.h                             |    8 
 include/linux/elf-em.h                             |    1 
 include/linux/spi/ad7877.h                         |   24 
 include/linux/usb_sl811.h                          |   26 
 init/Kconfig                                       |    3 
 lib/Kconfig.debug                                  |    2 
 scripts/genksyms/genksyms.c                        |    3 
 scripts/mkuboot.sh                                 |   11 
 scripts/mod/mk_elfconfig.c                         |    3 
 258 files changed, 50592 insertions(+), 9 deletions(-)
https://blackfin.uclinux.org/gf/download/frsrelease/25/2490/blackfin-arc
h-linux-2.6.20.patch (same as above link)
---

Thanks a lot
Best Regards
Bryan Wu <bryan.wu@analog.com>
