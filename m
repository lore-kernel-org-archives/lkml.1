Return-Path: <linux-kernel-owner+w=401wt.eu-S933681AbXCWGEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681AbXCWGEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXCWGEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:04:34 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:21743 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXCWGEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:04:33 -0400
X-IronPort-AV: i="4.14,317,1170651600"; 
   d="scan'208"; a="25247686:sNHT27364274"
Subject: [PATCH -mm try#2] Blackfin: architecture update patch
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Cc: "Wu, Bryan" <bryan.wu@analog.com>
In-Reply-To: <20070321125631.GA13192@linux-sh.org>
References: <1174471618.5648.50.camel@roc-desktop>
	 <20070321125631.GA13192@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 23 Mar 2007 14:04:30 +0800
Message-Id: <1174629871.18866.22.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks:

This is the latest blackfin update patch. Because there are lots of
issue fixing in this one, I put all modification in one update patch
which is located in:
https://blackfin.uclinux.org/gf/download/frsrelease/39/2707/blackfin-arch-2.6.21-rc4-mm1-update.patch

Changlogs:

1) fixed most of issues according to Arnd and Paul's review.
2) Remove RCS tags
3) Remove unsupported BF535 machine.
4) applied and tested based on blackfin-arch-balance-parenthesis-in-macros.patch

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 arch/blackfin/Kconfig                           |  173 +-
 arch/blackfin/Makefile                          |    1 
 arch/blackfin/kernel/Makefile                   |    3 
 arch/blackfin/kernel/asm-offsets.c              |    2 
 arch/blackfin/kernel/bfin_dma_5xx.c             |  245 +--
 arch/blackfin/kernel/bfin_gpio.c                |   41 
 arch/blackfin/kernel/bfin_ksyms.c               |    2 
 arch/blackfin/kernel/dma-mapping.c              |   25 
 arch/blackfin/kernel/dualcore_test.c            |    2 
 arch/blackfin/kernel/entry.S                    |    6 
 arch/blackfin/kernel/flat.c                     |  101 +
 arch/blackfin/kernel/init_task.c                |    5 
 arch/blackfin/kernel/irqchip.c                  |    7 
 arch/blackfin/kernel/module.c                   |    2 
 arch/blackfin/kernel/process.c                  |   56 
 arch/blackfin/kernel/ptrace.c                   |   41 
 arch/blackfin/kernel/setup.c                    |   79 -
 arch/blackfin/kernel/signal.c                   |  193 --
 arch/blackfin/kernel/sys_bfin.c                 |   18 
 arch/blackfin/kernel/time.c                     |   18 
 arch/blackfin/kernel/traps.c                    |  110 -
 arch/blackfin/kernel/vmlinux.lds.S              |    2 
 arch/blackfin/lib/ashldi3.c                     |    6 
 arch/blackfin/lib/ashrdi3.c                     |    6 
 arch/blackfin/lib/checksum.c                    |    6 
 arch/blackfin/lib/divsi3.S                      |    9 
 arch/blackfin/lib/gcclib.h                      |    2 
 arch/blackfin/lib/ins.S                         |    2 
 arch/blackfin/lib/lshrdi3.c                     |    6 
 arch/blackfin/lib/memchr.S                      |    2 
 arch/blackfin/lib/memcmp.S                      |    2 
 arch/blackfin/lib/memcpy.S                      |    7 
 arch/blackfin/lib/memmove.S                     |    2 
 arch/blackfin/lib/memset.S                      |    8 
 arch/blackfin/lib/modsi3.S                      |    9 
 arch/blackfin/lib/muldi3.c                      |    6 
 arch/blackfin/lib/outs.S                        |    2 
 arch/blackfin/lib/smulsi3_highpart.S            |    6 
 arch/blackfin/lib/udivsi3.S                     |   11 
 arch/blackfin/lib/umodsi3.S                     |    7 
 arch/blackfin/lib/umulsi3_highpart.S            |    6 
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    2 
 arch/blackfin/mach-bf533/boards/ezkit.c         |   11 
 arch/blackfin/mach-bf533/boards/generic_board.c |    2 
 arch/blackfin/mach-bf533/boards/stamp.c         |   17 
 arch/blackfin/mach-bf533/cpu.c                  |    2 
 arch/blackfin/mach-bf533/head.S                 |    2 
 arch/blackfin/mach-bf533/ints-priority.c        |    2 
 arch/blackfin/mach-bf537/boards/Makefile        |    9 
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |   13 
 arch/blackfin/mach-bf537/boards/eth_mac.c       |   52 
 arch/blackfin/mach-bf537/boards/generic_board.c |   24 
 arch/blackfin/mach-bf537/boards/pnav10.c        |   34 
 arch/blackfin/mach-bf537/boards/stamp.c         |   95 -
 arch/blackfin/mach-bf537/cpu.c                  |    2 
 arch/blackfin/mach-bf537/head.S                 |    3 
 arch/blackfin/mach-bf537/ints-priority.c        |    2 
 arch/blackfin/mach-bf561/boards/Makefile        |    1 
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |   23 
 arch/blackfin/mach-bf561/boards/ezkit.c         |   19 
 arch/blackfin/mach-bf561/boards/generic_board.c |    4 
 arch/blackfin/mach-bf561/coreb.c                |    2 
 arch/blackfin/mach-bf561/head.S                 |    2 
 arch/blackfin/mach-bf561/ints-priority.c        |    2 
 arch/blackfin/mach-common/cache.S               |    4 
 arch/blackfin/mach-common/cacheinit.S           |    2 
 arch/blackfin/mach-common/cplbhdlr.S            |    6 
 arch/blackfin/mach-common/cplbinfo.c            |    2 
 arch/blackfin/mach-common/cplbmgr.S             |    6 
 arch/blackfin/mach-common/dpmc.S                |    2 
 arch/blackfin/mach-common/entry.S               |   19 
 arch/blackfin/mach-common/interrupt.S           |    2 
 arch/blackfin/mach-common/ints-priority-dc.c    |   29 
 arch/blackfin/mach-common/ints-priority-sc.c    |   28 
 arch/blackfin/mach-common/irqpanic.c            |    2 
 arch/blackfin/mach-common/lock.S                |    2 
 arch/blackfin/mach-common/pm.c                  |    2 
 arch/blackfin/mm/Makefile                       |    2 
 arch/blackfin/mm/blackfin_sram.c                |   23 
 arch/blackfin/mm/blackfin_sram.h                |    2 
 arch/blackfin/mm/init.c                         |    5 
 arch/blackfin/mm/kmap.c                         |   84 -
 arch/blackfin/oprofile/common.c                 |   16 
 arch/blackfin/oprofile/op_blackfin.h            |    2 
 arch/blackfin/oprofile/op_model_bf533.c         |    4 
 arch/blackfin/oprofile/timer_int.c              |    2 
 include/asm-blackfin/bfin-global.h              |    3 
 include/asm-blackfin/bfin_spi_channel.h         |  182 --
 include/asm-blackfin/bfin_sport.h               |   16 
 include/asm-blackfin/blackfin.h                 |   87 -
 include/asm-blackfin/bug.h                      |   11 
 include/asm-blackfin/cacheflush.h               |    3 
 include/asm-blackfin/cplbinit.h                 |  395 ++---
 include/asm-blackfin/delay.h                    |    5 
 include/asm-blackfin/dma-mapping.h              |   21 
 include/asm-blackfin/dma.h                      |   33 
 include/asm-blackfin/dpmc.h                     |    4 
 include/asm-blackfin/entry.h                    |    5 
 include/asm-blackfin/flat.h                     |   88 -
 include/asm-blackfin/io.h                       |  107 +
 include/asm-blackfin/irq.h                      |    2 
 include/asm-blackfin/irq_handler.h              |   22 
 include/asm-blackfin/mach-bf533/bf533.h         |   13 
 include/asm-blackfin/mach-bf533/mem_map.h       |   63 
 include/asm-blackfin/mach-bf535/bf535.h         | 1277 ----------------
 include/asm-blackfin/mach-bf535/bf535_serial.h  |  109 -
 include/asm-blackfin/mach-bf535/blackfin.h      |   43 
 include/asm-blackfin/mach-bf535/cdefBF535.h     |  121 -
 include/asm-blackfin/mach-bf535/cdefblackfin.h  |   69 
 include/asm-blackfin/mach-bf535/defBF535.h      | 1818 ------------------------
 include/asm-blackfin/mach-bf535/defblackfin.h   |  444 -----
 include/asm-blackfin/mach-bf535/irq.h           |  125 -
 include/asm-blackfin/mach-bf537/bf537.h         |   13 
 include/asm-blackfin/mach-bf537/defBF534.h      |    3 
 include/asm-blackfin/mach-bf537/mem_map.h       |   79 -
 include/asm-blackfin/mach-bf561/bf561.h         |    7 
 include/asm-blackfin/mach-bf561/mem_map.h       |   29 
 include/asm-blackfin/pgtable.h                  |    8 
 include/asm-blackfin/sigcontext.h               |   25 
 include/asm-blackfin/uaccess.h                  |   58 
 include/asm-blackfin/ucontext.h                 |   15 
 include/asm-blackfin/unistd.h                   |    2 
 init/Kconfig                                    |    3 
 123 files changed, 1518 insertions(+), 5598 deletions(-)

https://blackfin.uclinux.org/gf/download/frsrelease/39/2707/blackfin-arch-2.6.21-rc4-mm1-update.patch
_

Thanks
-Bryan Wu
