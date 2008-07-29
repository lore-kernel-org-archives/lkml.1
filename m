Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbYG2R3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbYG2R3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYG2R30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:29:26 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:13113 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752765AbYG2R3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:29:23 -0400
Date: Wed, 30 Jul 2008 02:28:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.27-rc2
Message-ID: <20080729172842.GA4461@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rather disruptive set of changes, so I'm sending these out
early. This includes the migration from include/asm-sh to arch/sh/include,
as well as some mach group shuffling to go along with it. I figured it
made more sense to get this all out of the way in one shot.

Beyond that, lots of minor build fixes, defconfig updates for all the
platforms I built, and so on. Outside of the renames, most of the churn
is obviously in the defconfigs.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Adrian Bunk (1):
      mm/hugetlb.c must #include <asm/io.h>

Adrian McMenamin (1):
      sh/maple: clean maple bus code

Magnus Damm (1):
      sh: I2C fix for AP325RXA and Migo-R

Nobuhiro Iwamatsu (1):
      sh: Fix compile error of Solution Engine

OGAWA Hirofumi (1):
      sh: Proper __put_user_asm() size mismatch fix.

Paul Mundt (23):
      sh: rsk7203: Add smc911x platform data.
      sh: rsk7203: update defconfig.
      sh: Fix up unaligned current_text_addr().
      MAINTAINERS: Switch SUPERH to Supported.
      video: Kill off leaked CONFIG_FB_SH7343VOU reference.
      sh: migrate to arch/sh/include/
      sh: dreamcast: fix build failure from header reorg.
      sh: Add an arch/sh/kernel/.gitignore
      sh: Stub in a dummy ENTRY_OFFSET for uImage offset calculation.
      sh: Add ARCH_DEFCONFIG entries for sh and sh64.
      sh: Switch KBUILD_DEFCONFIG to shx3_defconfig.
      sh: dma-sh: Fix up dreamcast dma.h mach path.
      sh: Shuffle the board directories in to mach groups.
      sh: Move out the solution engine headers to arch/sh/include/mach-se/
      sh: More header path fixups for mach dir refactoring.
      sh: Provide common CPU headers, prune the SH-2 and SH-2A directories.
      sh: Allow SH-3 and SH-5 to use common headers.
      sh: Make sure AT_SYSINFO_EHDR is exposed to userspace in asm/auxvec.h.
      sh: Move out individual boards without mach groups.
      serial: sh-sci: Fix up SH7760/SH7780/SH7785 early printk regression.
      sh: Kill off stray mach-rsk7203 reference.
      sh: defconfig updates.
      video: Fix up hp6xx driver build regressions.

 MAINTAINERS                                        |    2 +-
 arch/sh/Kconfig                                    |  252 +------
 arch/sh/Makefile                                   |  139 +--
 arch/sh/boards/Kconfig                             |  258 ++++++
 arch/sh/boards/Makefile                            |    8 +
 .../{renesas/ap325rxa/setup.c => board-ap325rxa.c} |    4 +
 .../{magicpanelr2/setup.c => board-magicpanelr2.c} |    0 
 .../{renesas/rsk7203/setup.c => board-rsk7203.c}   |   10 +
 .../sh7785lcr/setup.c => board-sh7785lcr.c}        |    0 
 arch/sh/boards/{shmin/setup.c => board-shmin.c}    |    0 
 arch/sh/boards/{cayman => mach-cayman}/Makefile    |    0 
 arch/sh/boards/{cayman => mach-cayman}/irq.c       |    2 +-
 arch/sh/boards/{cayman => mach-cayman}/led.c       |    0 
 arch/sh/boards/{cayman => mach-cayman}/setup.c     |    2 +-
 .../boards/{dreamcast => mach-dreamcast}/Makefile  |    0 
 arch/sh/boards/{dreamcast => mach-dreamcast}/irq.c |    2 +-
 arch/sh/boards/{dreamcast => mach-dreamcast}/rtc.c |    0 
 .../boards/{dreamcast => mach-dreamcast}/setup.c   |    2 +-
 .../{renesas/edosk7705 => mach-edosk7705}/Makefile |    0 
 .../{renesas/edosk7705 => mach-edosk7705}/io.c     |    0 
 .../{renesas/edosk7705 => mach-edosk7705}/setup.c  |    0 
 .../{renesas/r7780rp => mach-highlander}/Kconfig   |    0 
 .../{renesas/r7780rp => mach-highlander}/Makefile  |    0 
 .../r7780rp => mach-highlander}/irq-r7780mp.c      |    0 
 .../r7780rp => mach-highlander}/irq-r7780rp.c      |    0 
 .../r7780rp => mach-highlander}/irq-r7785rp.c      |    0 
 .../{renesas/r7780rp => mach-highlander}/psw.c     |    2 +-
 .../{renesas/r7780rp => mach-highlander}/setup.c   |    0 
 arch/sh/boards/{hp6xx => mach-hp6xx}/Makefile      |    0 
 arch/sh/boards/{hp6xx => mach-hp6xx}/hp6xx_apm.c   |    0 
 arch/sh/boards/{hp6xx => mach-hp6xx}/pm.c          |    2 +-
 arch/sh/boards/{hp6xx => mach-hp6xx}/pm_wakeup.S   |    2 +-
 arch/sh/boards/{hp6xx => mach-hp6xx}/setup.c       |    2 +-
 arch/sh/boards/{landisk => mach-landisk}/Makefile  |    0 
 arch/sh/boards/{landisk => mach-landisk}/gio.c     |    4 +-
 arch/sh/boards/{landisk => mach-landisk}/irq.c     |    2 +-
 arch/sh/boards/{landisk => mach-landisk}/psw.c     |    2 +-
 arch/sh/boards/{landisk => mach-landisk}/setup.c   |    2 +-
 arch/sh/boards/{lboxre2 => mach-lboxre2}/Makefile  |    0 
 arch/sh/boards/{lboxre2 => mach-lboxre2}/irq.c     |    0 
 arch/sh/boards/{lboxre2 => mach-lboxre2}/setup.c   |    0 
 .../{superh/microdev => mach-microdev}/Makefile    |    0 
 .../boards/{superh/microdev => mach-microdev}/io.c |    0 
 .../{superh/microdev => mach-microdev}/irq.c       |    0 
 .../{superh/microdev => mach-microdev}/led.c       |    0 
 .../{superh/microdev => mach-microdev}/setup.c     |    0 
 .../boards/{renesas/migor => mach-migor}/Kconfig   |    0 
 .../boards/{renesas/migor => mach-migor}/Makefile  |    0 
 .../{renesas/migor => mach-migor}/lcd_qvga.c       |    0 
 .../boards/{renesas/migor => mach-migor}/setup.c   |    4 +
 .../{renesas/rts7751r2d => mach-r2d}/Kconfig       |    0 
 .../{renesas/rts7751r2d => mach-r2d}/Makefile      |    0 
 .../boards/{renesas/rts7751r2d => mach-r2d}/irq.c  |    0 
 .../{renesas/rts7751r2d => mach-r2d}/setup.c       |    0 
 .../{renesas/sdk7780 => mach-sdk7780}/Kconfig      |    0 
 .../{renesas/sdk7780 => mach-sdk7780}/Makefile     |    0 
 .../boards/{renesas/sdk7780 => mach-sdk7780}/irq.c |    0 
 .../{renesas/sdk7780 => mach-sdk7780}/setup.c      |    0 
 arch/sh/boards/{se => mach-se}/7206/Makefile       |    0 
 arch/sh/boards/{se => mach-se}/7206/io.c           |    2 +-
 arch/sh/boards/{se => mach-se}/7206/irq.c          |    2 +-
 arch/sh/boards/{se => mach-se}/7206/setup.c        |    2 +-
 arch/sh/boards/{se => mach-se}/7343/Makefile       |    0 
 arch/sh/boards/{se => mach-se}/7343/io.c           |    2 +-
 arch/sh/boards/{se => mach-se}/7343/irq.c          |    6 +-
 arch/sh/boards/{se => mach-se}/7343/setup.c        |    2 +-
 arch/sh/boards/{se => mach-se}/770x/Makefile       |    0 
 arch/sh/boards/{se => mach-se}/770x/io.c           |    2 +-
 arch/sh/boards/{se => mach-se}/770x/irq.c          |    2 +-
 arch/sh/boards/{se => mach-se}/770x/setup.c        |    8 +-
 arch/sh/boards/{se => mach-se}/7721/Makefile       |    0 
 arch/sh/boards/{se => mach-se}/7721/irq.c          |    2 +-
 arch/sh/boards/{se => mach-se}/7721/setup.c        |    2 +-
 arch/sh/boards/{se => mach-se}/7722/Makefile       |    0 
 arch/sh/boards/{se => mach-se}/7722/irq.c          |    2 +-
 arch/sh/boards/{se => mach-se}/7722/setup.c        |    2 +-
 arch/sh/boards/{se => mach-se}/7751/Makefile       |    0 
 arch/sh/boards/{se => mach-se}/7751/io.c           |    2 +-
 arch/sh/boards/{se => mach-se}/7751/irq.c          |    2 +-
 arch/sh/boards/{se => mach-se}/7751/pci.c          |    0 
 arch/sh/boards/{se => mach-se}/7751/setup.c        |    2 +-
 arch/sh/boards/{se => mach-se}/7780/Makefile       |    0 
 arch/sh/boards/{se => mach-se}/7780/irq.c          |    2 +-
 arch/sh/boards/{se => mach-se}/7780/setup.c        |    2 +-
 arch/sh/boards/mach-se/Makefile                    |    9 +
 .../{se/7619/setup.c => mach-se/board-se7619.c}    |    0 
 arch/sh/boards/{sh03 => mach-sh03}/Makefile        |    0 
 arch/sh/boards/{sh03 => mach-sh03}/rtc.c           |    0 
 arch/sh/boards/{sh03 => mach-sh03}/setup.c         |    4 +-
 .../{renesas/sh7763rdp => mach-sh7763rdp}/Makefile |    0 
 .../{renesas/sh7763rdp => mach-sh7763rdp}/irq.c    |    0 
 .../{renesas/sh7763rdp => mach-sh7763rdp}/setup.c  |    0 
 .../sh/boards/{snapgear => mach-snapgear}/Makefile |    0 
 arch/sh/boards/{snapgear => mach-snapgear}/io.c    |    0 
 arch/sh/boards/{snapgear => mach-snapgear}/setup.c |    2 +-
 .../{renesas/systemh => mach-systemh}/Makefile     |    0 
 .../boards/{renesas/systemh => mach-systemh}/io.c  |    0 
 .../boards/{renesas/systemh => mach-systemh}/irq.c |    0 
 .../{renesas/systemh => mach-systemh}/setup.c      |    0 
 arch/sh/boards/{titan => mach-titan}/Makefile      |    0 
 arch/sh/boards/{titan => mach-titan}/io.c          |    0 
 arch/sh/boards/{titan => mach-titan}/setup.c       |    0 
 .../{renesas/x3proto => mach-x3proto}/Makefile     |    0 
 .../{renesas/x3proto => mach-x3proto}/ilsel.c      |    0 
 .../{renesas/x3proto => mach-x3proto}/setup.c      |    0 
 arch/sh/boards/magicpanelr2/Kconfig                |   13 -
 arch/sh/boards/magicpanelr2/Makefile               |    5 -
 arch/sh/boards/renesas/ap325rxa/Makefile           |    1 -
 arch/sh/boards/renesas/rsk7203/Makefile            |    1 -
 arch/sh/boards/renesas/sh7785lcr/Makefile          |    1 -
 arch/sh/boards/se/7619/Makefile                    |    5 -
 arch/sh/boards/shmin/Makefile                      |    5 -
 arch/sh/boot/Makefile                              |    3 +-
 arch/sh/boot/compressed/head_64.S                  |    4 +-
 arch/sh/configs/ap325rxa_defconfig                 |   35 +-
 arch/sh/configs/dreamcast_defconfig                |  304 +++++--
 arch/sh/configs/hp6xx_defconfig                    |  258 ++++--
 arch/sh/configs/landisk_defconfig                  |  894 +++++++++-----------
 arch/sh/configs/lboxre2_defconfig                  |  725 +++++++---------
 arch/sh/configs/magicpanelr2_defconfig             |  195 +++--
 arch/sh/configs/microdev_defconfig                 |  630 +++++++--------
 arch/sh/configs/migor_defconfig                    |   63 ++-
 arch/sh/configs/r7780mp_defconfig                  |  194 +++--
 arch/sh/configs/r7785rp_defconfig                  |  258 ++++--
 arch/sh/configs/rsk7203_defconfig                  |  179 ++++-
 arch/sh/configs/rts7751r2d1_defconfig              |  259 ++++---
 arch/sh/configs/rts7751r2dplus_defconfig           |  259 ++++---
 arch/sh/configs/sdk7780_defconfig                  |  269 ++++---
 arch/sh/configs/se7206_defconfig                   |   38 +-
 arch/sh/configs/se7343_defconfig                   |   78 +-
 arch/sh/configs/se7619_defconfig                   |  261 +++----
 arch/sh/drivers/dma/dma-g2.c                       |    4 +-
 arch/sh/drivers/dma/dma-pvr2.c                     |    4 +-
 arch/sh/drivers/dma/dma-sh.c                       |    2 +-
 arch/sh/drivers/dma/dma-sh.h                       |    2 +-
 arch/sh/drivers/pci/fixups-dreamcast.c             |    2 +-
 arch/sh/drivers/pci/ops-cayman.c                   |    2 +-
 arch/sh/drivers/pci/ops-dreamcast.c                |    2 +-
 arch/sh/drivers/pci/ops-se7780.c                   |    2 +-
 arch/sh/drivers/pci/pci-sh5.c                      |    2 +-
 arch/sh/include/asm/.gitignore                     |    1 +
 {include/asm-sh => arch/sh/include/asm}/Kbuild     |    0 
 {include/asm-sh => arch/sh/include/asm}/a.out.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/adc.h      |    2 +-
 .../asm-sh => arch/sh/include/asm}/addrspace.h     |    2 +-
 .../asm-sh => arch/sh/include/asm}/atomic-grb.h    |    0 
 .../asm-sh => arch/sh/include/asm}/atomic-irq.h    |    0 
 .../asm-sh => arch/sh/include/asm}/atomic-llsc.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/atomic.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/auxvec.h   |    2 +-
 .../asm-sh => arch/sh/include/asm}/bitops-grb.h    |    0 
 .../asm-sh => arch/sh/include/asm}/bitops-irq.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/bitops.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/bug.h      |    0 
 {include/asm-sh => arch/sh/include/asm}/bugs.h     |    0 
 .../asm-sh => arch/sh/include/asm}/byteorder.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/cache.h    |    2 +-
 .../asm-sh => arch/sh/include/asm}/cacheflush.h    |    2 +-
 {include/asm-sh => arch/sh/include/asm}/checksum.h |    0 
 .../asm-sh => arch/sh/include/asm}/checksum_32.h   |    0 
 .../asm-sh => arch/sh/include/asm}/checksum_64.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/clock.h    |    0 
 .../asm-sh => arch/sh/include/asm}/cmpxchg-grb.h   |    0 
 .../asm-sh => arch/sh/include/asm}/cmpxchg-irq.h   |    0 
 .../asm-sh => arch/sh/include/asm}/cpu-features.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/cputime.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/current.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/delay.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/device.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/div64.h    |    0 
 .../asm-sh => arch/sh/include/asm}/dma-mapping.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/dma.h      |    2 +-
 {include/asm-sh => arch/sh/include/asm}/dmabrg.h   |    0 
 .../asm-sh => arch/sh/include/asm}/edosk7705.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/elf.h      |    0 
 .../sh/include/asm}/emergency-restart.h            |    0 
 .../asm-sh => arch/sh/include/asm}/entry-macros.S  |    0 
 {include/asm-sh => arch/sh/include/asm}/errno.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/fb.h       |    0 
 {include/asm-sh => arch/sh/include/asm}/fcntl.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/fixmap.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/flat.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/fpu.h      |    0 
 {include/asm-sh => arch/sh/include/asm}/freq.h     |    2 +-
 .../asm-sh => arch/sh/include/asm}/futex-irq.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/futex.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/gpio.h     |    2 +-
 {include/asm-sh => arch/sh/include/asm}/hardirq.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/hd64461.h  |    0 
 .../asm-sh => arch/sh/include/asm}/hd64465/gpio.h  |    0 
 .../sh/include/asm}/hd64465/hd64465.h              |    0 
 .../asm-sh => arch/sh/include/asm}/hd64465/io.h    |    0 
 .../asm-sh => arch/sh/include/asm}/heartbeat.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/hp6xx.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/hugetlb.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/hw_irq.h   |    0 
 .../asm-sh => arch/sh/include/asm}/i2c-sh7760.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/ilsel.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/io.h       |    0 
 .../asm-sh => arch/sh/include/asm}/io_generic.h    |    0 
 .../asm-sh => arch/sh/include/asm}/io_trapped.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/ioctl.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/ioctls.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/ipcbuf.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/irq.h      |    2 +-
 {include/asm-sh => arch/sh/include/asm}/irq_regs.h |    0 
 {include/asm-sh => arch/sh/include/asm}/irqflags.h |    0 
 .../asm-sh => arch/sh/include/asm}/irqflags_32.h   |    0 
 .../asm-sh => arch/sh/include/asm}/irqflags_64.h   |    2 +-
 {include/asm-sh => arch/sh/include/asm}/kdebug.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/kexec.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/kgdb.h     |    0 
 .../asm-sh => arch/sh/include/asm}/kmap_types.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/lboxre2.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/linkage.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/local.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/machvec.h  |    0 
 .../asm-sh => arch/sh/include/asm}/magicpanelr2.h  |    0 
 .../asm-sh => arch/sh/include/asm}/mc146818rtc.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/microdev.h |    0 
 {include/asm-sh => arch/sh/include/asm}/migor.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/mman.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/mmu.h      |    0 
 .../asm-sh => arch/sh/include/asm}/mmu_context.h   |    2 +-
 .../sh/include/asm}/mmu_context_32.h               |    0 
 .../sh/include/asm}/mmu_context_64.h               |    2 +-
 {include/asm-sh => arch/sh/include/asm}/mmzone.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/module.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/msgbuf.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/mutex.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/page.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/param.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/parport.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/pci.h      |    0 
 {include/asm-sh => arch/sh/include/asm}/percpu.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/pgalloc.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/pgtable.h  |    0 
 .../asm-sh => arch/sh/include/asm}/pgtable_32.h    |    0 
 .../asm-sh => arch/sh/include/asm}/pgtable_64.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/pm.h       |    0 
 {include/asm-sh => arch/sh/include/asm}/poll.h     |    0 
 .../asm-sh => arch/sh/include/asm}/posix_types.h   |    0 
 .../sh/include/asm}/posix_types_32.h               |    0 
 .../sh/include/asm}/posix_types_64.h               |    0 
 .../asm-sh => arch/sh/include/asm}/processor.h     |    0 
 .../asm-sh => arch/sh/include/asm}/processor_32.h  |    2 +-
 .../asm-sh => arch/sh/include/asm}/processor_64.h  |    2 +-
 {include/asm-sh => arch/sh/include/asm}/ptrace.h   |    0 
 .../asm-sh => arch/sh/include/asm}/push-switch.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/r7780rp.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/resource.h |    0 
 {include/asm-sh => arch/sh/include/asm}/rtc.h      |    2 +-
 .../asm-sh => arch/sh/include/asm}/rts7751r2d.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/rwsem.h    |    0 
 .../asm-sh => arch/sh/include/asm}/scatterlist.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/sdk7780.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/sections.h |    0 
 {include/asm-sh => arch/sh/include/asm}/segment.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/sembuf.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/serial.h   |    2 +-
 {include/asm-sh => arch/sh/include/asm}/setup.h    |    0 
 .../asm-sh => arch/sh/include/asm}/sfp-machine.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/sh7760fb.h |    0 
 .../asm-sh => arch/sh/include/asm}/sh7763rdp.h     |    0 
 .../asm-sh => arch/sh/include/asm}/sh7785lcr.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/sh_bios.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/sh_keysc.h |    0 
 .../sh/include/asm}/sh_mobile_lcdc.h               |    0 
 {include/asm-sh => arch/sh/include/asm}/shmbuf.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/shmin.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/shmparam.h |    0 
 .../asm-sh => arch/sh/include/asm}/sigcontext.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/siginfo.h  |    0 
 {include/asm-sh => arch/sh/include/asm}/signal.h   |    0 
 .../asm-sh => arch/sh/include/asm}/smc37c93x.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/smp.h      |    0 
 {include/asm-sh => arch/sh/include/asm}/snapgear.h |    0 
 {include/asm-sh => arch/sh/include/asm}/socket.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/sockios.h  |    0 
 .../asm-sh => arch/sh/include/asm}/sparsemem.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/spi.h      |    0 
 {include/asm-sh => arch/sh/include/asm}/spinlock.h |    0 
 .../sh/include/asm}/spinlock_types.h               |    0 
 {include/asm-sh => arch/sh/include/asm}/stat.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/statfs.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/string.h   |    0 
 .../asm-sh => arch/sh/include/asm}/string_32.h     |    0 
 .../asm-sh => arch/sh/include/asm}/string_64.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/system.h   |    0 
 .../asm-sh => arch/sh/include/asm}/system_32.h     |    0 
 .../asm-sh => arch/sh/include/asm}/system_64.h     |    0 
 .../asm-sh => arch/sh/include/asm}/systemh7751.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/termbits.h |    0 
 {include/asm-sh => arch/sh/include/asm}/termios.h  |    0 
 .../asm-sh => arch/sh/include/asm}/thread_info.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/timer.h    |    2 +-
 {include/asm-sh => arch/sh/include/asm}/timex.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/titan.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/tlb.h      |    0 
 {include/asm-sh => arch/sh/include/asm}/tlb_64.h   |    0 
 {include/asm-sh => arch/sh/include/asm}/tlbflush.h |    0 
 {include/asm-sh => arch/sh/include/asm}/topology.h |    0 
 {include/asm-sh => arch/sh/include/asm}/types.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/uaccess.h  |    6 +-
 .../asm-sh => arch/sh/include/asm}/uaccess_32.h    |    3 +-
 .../asm-sh => arch/sh/include/asm}/uaccess_64.h    |    0 
 {include/asm-sh => arch/sh/include/asm}/ubc.h      |    2 +-
 {include/asm-sh => arch/sh/include/asm}/ucontext.h |    0 
 .../asm-sh => arch/sh/include/asm}/unaligned.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/unistd.h   |    0 
 .../asm-sh => arch/sh/include/asm}/unistd_32.h     |    0 
 .../asm-sh => arch/sh/include/asm}/unistd_64.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/user.h     |    0 
 {include/asm-sh => arch/sh/include/asm}/vga.h      |    0 
 {include/asm-sh => arch/sh/include/asm}/watchdog.h |    4 +-
 {include/asm-sh => arch/sh/include/asm}/xor.h      |    0 
 .../sh/include/cpu-common/cpu}/addrspace.h         |    0 
 .../sh/include/cpu-common/cpu}/cacheflush.h        |    4 +-
 .../sh/include/cpu-common/cpu}/mmu_context.h       |    0 
 .../sh/include/cpu-common/cpu}/rtc.h               |    0 
 .../sh/include/cpu-common/cpu}/sigcontext.h        |    0 
 .../sh/include/cpu-common/cpu}/timer.h             |    0 
 .../sh/include/cpu-sh2/cpu}/cache.h                |    0 
 .../cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/dma.h  |    0 
 .../cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/freq.h |    0 
 .../cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/ubc.h  |    0 
 .../sh/include/cpu-sh2/cpu}/watchdog.h             |    0 
 .../sh/include/cpu-sh2a/cpu}/cache.h               |    0 
 arch/sh/include/cpu-sh2a/cpu/dma.h                 |    1 +
 .../sh/include/cpu-sh2a/cpu}/freq.h                |    0 
 .../sh/include/cpu-sh2a/cpu}/rtc.h                 |    0 
 arch/sh/include/cpu-sh2a/cpu/ubc.h                 |    1 +
 arch/sh/include/cpu-sh2a/cpu/watchdog.h            |    1 +
 .../cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/adc.h  |    0 
 .../sh/include/cpu-sh3/cpu}/cache.h                |    0 
 arch/sh/include/cpu-sh3/cpu/cacheflush.h           |   36 +
 .../cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/dac.h  |    0 
 .../cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/dma.h  |    0 
 .../cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/freq.h |    0 
 .../cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/gpio.h |    0 
 .../sh/include/cpu-sh3/cpu}/mmu_context.h          |    0 
 .../sh/include/cpu-sh3/cpu}/timer.h                |    0 
 .../cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/ubc.h  |    0 
 .../sh/include/cpu-sh3/cpu}/watchdog.h             |    0 
 .../sh/include/cpu-sh4/cpu}/addrspace.h            |    0 
 .../sh/include/cpu-sh4/cpu}/cache.h                |    0 
 .../sh/include/cpu-sh4/cpu}/cacheflush.h           |    0 
 .../sh/include/cpu-sh4/cpu}/dma-sh7780.h           |    0 
 .../cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/dma.h  |    2 +-
 .../cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/fpu.h  |    0 
 .../cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/freq.h |    0 
 .../sh/include/cpu-sh4/cpu}/mmu_context.h          |    0 
 .../cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/rtc.h  |    0 
 .../sh/include/cpu-sh4/cpu}/sigcontext.h           |    0 
 .../cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/sq.h   |    0 
 .../sh/include/cpu-sh4/cpu}/timer.h                |    0 
 .../cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/ubc.h  |    0 
 .../sh/include/cpu-sh4/cpu}/watchdog.h             |    0 
 .../sh/include/cpu-sh5/cpu}/addrspace.h            |    0 
 .../sh/include/cpu-sh5/cpu}/cache.h                |    0 
 .../sh/include/cpu-sh5/cpu}/cacheflush.h           |    0 
 .../cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/dma.h  |    0 
 .../cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/irq.h  |    0 
 .../sh/include/cpu-sh5/cpu}/mmu_context.h          |    0 
 .../sh/include/cpu-sh5/cpu}/registers.h            |    0 
 .../cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/rtc.h  |    0 
 .../sh/include/mach-dreamcast/mach}/dma.h          |    0 
 .../sh/include/mach-dreamcast/mach}/maple.h        |    0 
 .../sh/include/mach-dreamcast/mach}/pci.h          |    2 +-
 .../sh/include/mach-dreamcast/mach}/sysasic.h      |    0 
 .../sh/include/mach-landisk/mach}/gio.h            |    0 
 .../sh/include/mach-landisk/mach}/iodata_landisk.h |    0 
 .../asm-sh => arch/sh/include/mach-se/mach}/se.h   |    0 
 .../sh/include/mach-se/mach}/se7206.h              |    0 
 .../sh/include/mach-se/mach}/se7343.h              |    0 
 .../sh/include/mach-se/mach}/se7721.h              |    0 
 .../sh/include/mach-se/mach}/se7722.h              |    0 
 .../sh/include/mach-se/mach}/se7751.h              |    0 
 .../sh/include/mach-se/mach}/se7780.h              |    0 
 .../sh03 => arch/sh/include/mach-sh03/mach}/io.h   |    0 
 .../sh03 => arch/sh/include/mach-sh03/mach}/sh03.h |    0 
 arch/sh/kernel/.gitignore                          |    1 +
 arch/sh/kernel/cf-enabler.c                        |    6 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c                  |    2 +-
 arch/sh/kernel/cpu/sh2/entry.S                     |    2 +-
 arch/sh/kernel/cpu/sh2a/entry.S                    |    2 +-
 arch/sh/kernel/cpu/sh3/entry.S                     |    2 +-
 arch/sh/kernel/cpu/sh4/fpu.c                       |    2 +-
 arch/sh/kernel/cpu/sh4/softfloat.c                 |    2 +-
 arch/sh/kernel/cpu/sh4/sq.c                        |    2 +-
 arch/sh/kernel/cpu/sh5/entry.S                     |    2 +-
 arch/sh/kernel/head_64.S                           |    4 +-
 arch/sh/kernel/irq.c                               |    2 +-
 arch/sh/kernel/time_64.c                           |    4 +-
 arch/sh/lib64/panic.c                              |    2 +-
 arch/sh/mm/fault_64.c                              |    2 +-
 arch/sh/tools/Makefile                             |    4 +-
 drivers/cdrom/gdrom.c                              |    4 +-
 drivers/input/keyboard/maple_keyb.c                |    1 -
 drivers/serial/sh-sci.h                            |   12 +-
 drivers/sh/maple/maple.c                           |  265 ++++--
 drivers/video/Makefile                             |    1 -
 drivers/video/backlight/hp680_bl.c                 |    2 +-
 drivers/video/hitfb.c                              |    2 +-
 drivers/video/pvr2fb.c                             |    6 +-
 include/asm-sh/.gitignore                          |    3 -
 include/asm-sh/cpu-sh2a/addrspace.h                |   10 -
 include/asm-sh/cpu-sh2a/cacheflush.h               |    1 -
 include/asm-sh/cpu-sh2a/dma.h                      |    1 -
 include/asm-sh/cpu-sh2a/mmu_context.h              |    1 -
 include/asm-sh/cpu-sh2a/timer.h                    |    1 -
 include/asm-sh/cpu-sh2a/ubc.h                      |    1 -
 include/asm-sh/cpu-sh2a/watchdog.h                 |    1 -
 include/asm-sh/cpu-sh3/addrspace.h                 |   19 -
 include/asm-sh/cpu-sh3/cacheflush.h                |   70 --
 include/asm-sh/cpu-sh3/rtc.h                       |    8 -
 include/asm-sh/cpu-sh3/sigcontext.h                |   17 -
 include/asm-sh/cpu-sh5/timer.h                     |    4 -
 include/linux/maple.h                              |    6 +-
 mm/hugetlb.c                                       |    2 +-
 sound/sh/aica.c                                    |    2 +-
 421 files changed, 3358 insertions(+), 2943 deletions(-)
 create mode 100644 arch/sh/boards/Kconfig
 create mode 100644 arch/sh/boards/Makefile
 rename arch/sh/boards/{renesas/ap325rxa/setup.c => board-ap325rxa.c} (99%)
 rename arch/sh/boards/{magicpanelr2/setup.c => board-magicpanelr2.c} (100%)
 rename arch/sh/boards/{renesas/rsk7203/setup.c => board-rsk7203.c} (92%)
 rename arch/sh/boards/{renesas/sh7785lcr/setup.c => board-sh7785lcr.c} (100%)
 rename arch/sh/boards/{shmin/setup.c => board-shmin.c} (100%)
 rename arch/sh/boards/{cayman => mach-cayman}/Makefile (100%)
 rename arch/sh/boards/{cayman => mach-cayman}/irq.c (99%)
 rename arch/sh/boards/{cayman => mach-cayman}/led.c (100%)
 rename arch/sh/boards/{cayman => mach-cayman}/setup.c (99%)
 rename arch/sh/boards/{dreamcast => mach-dreamcast}/Makefile (100%)
 rename arch/sh/boards/{dreamcast => mach-dreamcast}/irq.c (99%)
 rename arch/sh/boards/{dreamcast => mach-dreamcast}/rtc.c (100%)
 rename arch/sh/boards/{dreamcast => mach-dreamcast}/setup.c (98%)
 rename arch/sh/boards/{renesas/edosk7705 => mach-edosk7705}/Makefile (100%)
 rename arch/sh/boards/{renesas/edosk7705 => mach-edosk7705}/io.c (100%)
 rename arch/sh/boards/{renesas/edosk7705 => mach-edosk7705}/setup.c (100%)
 rename arch/sh/boards/{renesas/r7780rp => mach-highlander}/Kconfig (100%)
 rename arch/sh/boards/{renesas/r7780rp => mach-highlander}/Makefile (100%)
 rename arch/sh/boards/{renesas/r7780rp => mach-highlander}/irq-r7780mp.c (100%)
 rename arch/sh/boards/{renesas/r7780rp => mach-highlander}/irq-r7780rp.c (100%)
 rename arch/sh/boards/{renesas/r7780rp => mach-highlander}/irq-r7785rp.c (100%)
 rename arch/sh/boards/{renesas/r7780rp => mach-highlander}/psw.c (98%)
 rename arch/sh/boards/{renesas/r7780rp => mach-highlander}/setup.c (100%)
 rename arch/sh/boards/{hp6xx => mach-hp6xx}/Makefile (100%)
 rename arch/sh/boards/{hp6xx => mach-hp6xx}/hp6xx_apm.c (100%)
 rename arch/sh/boards/{hp6xx => mach-hp6xx}/pm.c (98%)
 rename arch/sh/boards/{hp6xx => mach-hp6xx}/pm_wakeup.S (96%)
 rename arch/sh/boards/{hp6xx => mach-hp6xx}/setup.c (99%)
 rename arch/sh/boards/{landisk => mach-landisk}/Makefile (100%)
 rename arch/sh/boards/{landisk => mach-landisk}/gio.c (97%)
 rename arch/sh/boards/{landisk => mach-landisk}/irq.c (96%)
 rename arch/sh/boards/{landisk => mach-landisk}/psw.c (98%)
 rename arch/sh/boards/{landisk => mach-landisk}/setup.c (98%)
 rename arch/sh/boards/{lboxre2 => mach-lboxre2}/Makefile (100%)
 rename arch/sh/boards/{lboxre2 => mach-lboxre2}/irq.c (100%)
 rename arch/sh/boards/{lboxre2 => mach-lboxre2}/setup.c (100%)
 rename arch/sh/boards/{superh/microdev => mach-microdev}/Makefile (100%)
 rename arch/sh/boards/{superh/microdev => mach-microdev}/io.c (100%)
 rename arch/sh/boards/{superh/microdev => mach-microdev}/irq.c (100%)
 rename arch/sh/boards/{superh/microdev => mach-microdev}/led.c (100%)
 rename arch/sh/boards/{superh/microdev => mach-microdev}/setup.c (100%)
 rename arch/sh/boards/{renesas/migor => mach-migor}/Kconfig (100%)
 rename arch/sh/boards/{renesas/migor => mach-migor}/Makefile (100%)
 rename arch/sh/boards/{renesas/migor => mach-migor}/lcd_qvga.c (100%)
 rename arch/sh/boards/{renesas/migor => mach-migor}/setup.c (99%)
 rename arch/sh/boards/{renesas/rts7751r2d => mach-r2d}/Kconfig (100%)
 rename arch/sh/boards/{renesas/rts7751r2d => mach-r2d}/Makefile (100%)
 rename arch/sh/boards/{renesas/rts7751r2d => mach-r2d}/irq.c (100%)
 rename arch/sh/boards/{renesas/rts7751r2d => mach-r2d}/setup.c (100%)
 rename arch/sh/boards/{renesas/sdk7780 => mach-sdk7780}/Kconfig (100%)
 rename arch/sh/boards/{renesas/sdk7780 => mach-sdk7780}/Makefile (100%)
 rename arch/sh/boards/{renesas/sdk7780 => mach-sdk7780}/irq.c (100%)
 rename arch/sh/boards/{renesas/sdk7780 => mach-sdk7780}/setup.c (100%)
 rename arch/sh/boards/{se => mach-se}/7206/Makefile (100%)
 rename arch/sh/boards/{se => mach-se}/7206/io.c (98%)
 rename arch/sh/boards/{se => mach-se}/7206/irq.c (98%)
 rename arch/sh/boards/{se => mach-se}/7206/setup.c (98%)
 rename arch/sh/boards/{se => mach-se}/7343/Makefile (100%)
 rename arch/sh/boards/{se => mach-se}/7343/io.c (99%)
 rename arch/sh/boards/{se => mach-se}/7343/irq.c (96%)
 rename arch/sh/boards/{se => mach-se}/7343/setup.c (98%)
 rename arch/sh/boards/{se => mach-se}/770x/Makefile (100%)
 rename arch/sh/boards/{se => mach-se}/770x/io.c (99%)
 rename arch/sh/boards/{se => mach-se}/770x/irq.c (98%)
 rename arch/sh/boards/{se => mach-se}/770x/setup.c (96%)
 rename arch/sh/boards/{se => mach-se}/7721/Makefile (100%)
 rename arch/sh/boards/{se => mach-se}/7721/irq.c (96%)
 rename arch/sh/boards/{se => mach-se}/7721/setup.c (98%)
 rename arch/sh/boards/{se => mach-se}/7722/Makefile (100%)
 rename arch/sh/boards/{se => mach-se}/7722/irq.c (98%)
 rename arch/sh/boards/{se => mach-se}/7722/setup.c (99%)
 rename arch/sh/boards/{se => mach-se}/7751/Makefile (100%)
 rename arch/sh/boards/{se => mach-se}/7751/io.c (99%)
 rename arch/sh/boards/{se => mach-se}/7751/irq.c (96%)
 rename arch/sh/boards/{se => mach-se}/7751/pci.c (100%)
 rename arch/sh/boards/{se => mach-se}/7751/setup.c (98%)
 rename arch/sh/boards/{se => mach-se}/7780/Makefile (100%)
 rename arch/sh/boards/{se => mach-se}/7780/irq.c (97%)
 rename arch/sh/boards/{se => mach-se}/7780/setup.c (98%)
 create mode 100644 arch/sh/boards/mach-se/Makefile
 rename arch/sh/boards/{se/7619/setup.c => mach-se/board-se7619.c} (100%)
 rename arch/sh/boards/{sh03 => mach-sh03}/Makefile (100%)
 rename arch/sh/boards/{sh03 => mach-sh03}/rtc.c (100%)
 rename arch/sh/boards/{sh03 => mach-sh03}/setup.c (96%)
 rename arch/sh/boards/{renesas/sh7763rdp => mach-sh7763rdp}/Makefile (100%)
 rename arch/sh/boards/{renesas/sh7763rdp => mach-sh7763rdp}/irq.c (100%)
 rename arch/sh/boards/{renesas/sh7763rdp => mach-sh7763rdp}/setup.c (100%)
 rename arch/sh/boards/{snapgear => mach-snapgear}/Makefile (100%)
 rename arch/sh/boards/{snapgear => mach-snapgear}/io.c (100%)
 rename arch/sh/boards/{snapgear => mach-snapgear}/setup.c (98%)
 rename arch/sh/boards/{renesas/systemh => mach-systemh}/Makefile (100%)
 rename arch/sh/boards/{renesas/systemh => mach-systemh}/io.c (100%)
 rename arch/sh/boards/{renesas/systemh => mach-systemh}/irq.c (100%)
 rename arch/sh/boards/{renesas/systemh => mach-systemh}/setup.c (100%)
 rename arch/sh/boards/{titan => mach-titan}/Makefile (100%)
 rename arch/sh/boards/{titan => mach-titan}/io.c (100%)
 rename arch/sh/boards/{titan => mach-titan}/setup.c (100%)
 rename arch/sh/boards/{renesas/x3proto => mach-x3proto}/Makefile (100%)
 rename arch/sh/boards/{renesas/x3proto => mach-x3proto}/ilsel.c (100%)
 rename arch/sh/boards/{renesas/x3proto => mach-x3proto}/setup.c (100%)
 delete mode 100644 arch/sh/boards/magicpanelr2/Kconfig
 delete mode 100644 arch/sh/boards/magicpanelr2/Makefile
 delete mode 100644 arch/sh/boards/renesas/ap325rxa/Makefile
 delete mode 100644 arch/sh/boards/renesas/rsk7203/Makefile
 delete mode 100644 arch/sh/boards/renesas/sh7785lcr/Makefile
 delete mode 100644 arch/sh/boards/se/7619/Makefile
 delete mode 100644 arch/sh/boards/shmin/Makefile
 create mode 100644 arch/sh/include/asm/.gitignore
 rename {include/asm-sh => arch/sh/include/asm}/Kbuild (100%)
 rename {include/asm-sh => arch/sh/include/asm}/a.out.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/adc.h (88%)
 rename {include/asm-sh => arch/sh/include/asm}/addrspace.h (98%)
 rename {include/asm-sh => arch/sh/include/asm}/atomic-grb.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/atomic-irq.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/atomic-llsc.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/atomic.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/auxvec.h (94%)
 rename {include/asm-sh => arch/sh/include/asm}/bitops-grb.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/bitops-irq.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/bitops.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/bug.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/bugs.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/byteorder.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/cache.h (97%)
 rename {include/asm-sh => arch/sh/include/asm}/cacheflush.h (98%)
 rename {include/asm-sh => arch/sh/include/asm}/checksum.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/checksum_32.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/checksum_64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/clock.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/cmpxchg-grb.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/cmpxchg-irq.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/cpu-features.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/cputime.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/current.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/delay.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/device.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/div64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/dma-mapping.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/dma.h (99%)
 rename {include/asm-sh => arch/sh/include/asm}/dmabrg.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/edosk7705.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/elf.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/emergency-restart.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/entry-macros.S (100%)
 rename {include/asm-sh => arch/sh/include/asm}/errno.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/fb.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/fcntl.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/fixmap.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/flat.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/fpu.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/freq.h (94%)
 rename {include/asm-sh => arch/sh/include/asm}/futex-irq.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/futex.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/gpio.h (94%)
 rename {include/asm-sh => arch/sh/include/asm}/hardirq.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/hd64461.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/hd64465/gpio.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/hd64465/hd64465.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/hd64465/io.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/heartbeat.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/hp6xx.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/hugetlb.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/hw_irq.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/i2c-sh7760.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/ilsel.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/io.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/io_generic.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/io_trapped.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/ioctl.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/ioctls.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/ipcbuf.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/irq.h (97%)
 rename {include/asm-sh => arch/sh/include/asm}/irq_regs.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/irqflags.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/irqflags_32.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/irqflags_64.h (98%)
 rename {include/asm-sh => arch/sh/include/asm}/kdebug.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/kexec.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/kgdb.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/kmap_types.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/lboxre2.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/linkage.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/local.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/machvec.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/magicpanelr2.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/microdev.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/migor.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/mman.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/mmu.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/mmu_context.h (99%)
 rename {include/asm-sh => arch/sh/include/asm}/mmu_context_32.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/mmu_context_64.h (98%)
 rename {include/asm-sh => arch/sh/include/asm}/mmzone.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/module.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/msgbuf.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/mutex.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/page.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/param.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/parport.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/pci.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/percpu.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/pgalloc.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/pgtable.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/pgtable_32.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/pgtable_64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/pm.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/poll.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/posix_types.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/posix_types_32.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/posix_types_64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/processor.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/processor_32.h (98%)
 rename {include/asm-sh => arch/sh/include/asm}/processor_64.h (99%)
 rename {include/asm-sh => arch/sh/include/asm}/ptrace.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/push-switch.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/r7780rp.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/resource.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/rtc.h (92%)
 rename {include/asm-sh => arch/sh/include/asm}/rts7751r2d.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/rwsem.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/scatterlist.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sdk7780.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sections.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/segment.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sembuf.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/serial.h (96%)
 rename {include/asm-sh => arch/sh/include/asm}/setup.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sfp-machine.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sh7760fb.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sh7763rdp.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sh7785lcr.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sh_bios.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sh_keysc.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sh_mobile_lcdc.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/shmbuf.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/shmin.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/shmparam.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sigcontext.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/siginfo.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/signal.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/smc37c93x.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/smp.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/snapgear.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/socket.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sockios.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/sparsemem.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/spi.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/spinlock.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/spinlock_types.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/stat.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/statfs.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/string.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/string_32.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/string_64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/system.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/system_32.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/system_64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/systemh7751.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/termbits.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/termios.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/thread_info.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/timer.h (96%)
 rename {include/asm-sh => arch/sh/include/asm}/timex.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/titan.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/tlb.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/tlb_64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/tlbflush.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/topology.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/types.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/uaccess.h (97%)
 rename {include/asm-sh => arch/sh/include/asm}/uaccess_32.h (98%)
 rename {include/asm-sh => arch/sh/include/asm}/uaccess_64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/ubc.h (98%)
 rename {include/asm-sh => arch/sh/include/asm}/ucontext.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/unaligned.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/unistd.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/unistd_32.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/unistd_64.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/user.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/vga.h (100%)
 rename {include/asm-sh => arch/sh/include/asm}/watchdog.h (96%)
 rename {include/asm-sh => arch/sh/include/asm}/xor.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-common/cpu}/addrspace.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-common/cpu}/cacheflush.h (99%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-common/cpu}/mmu_context.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-common/cpu}/rtc.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-common/cpu}/sigcontext.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-common/cpu}/timer.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/cache.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/dma.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/freq.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/ubc.h (100%)
 rename {include/asm-sh/cpu-sh2 => arch/sh/include/cpu-sh2/cpu}/watchdog.h (100%)
 rename {include/asm-sh/cpu-sh2a => arch/sh/include/cpu-sh2a/cpu}/cache.h (100%)
 create mode 100644 arch/sh/include/cpu-sh2a/cpu/dma.h
 rename {include/asm-sh/cpu-sh2a => arch/sh/include/cpu-sh2a/cpu}/freq.h (100%)
 rename {include/asm-sh/cpu-sh2a => arch/sh/include/cpu-sh2a/cpu}/rtc.h (100%)
 create mode 100644 arch/sh/include/cpu-sh2a/cpu/ubc.h
 create mode 100644 arch/sh/include/cpu-sh2a/cpu/watchdog.h
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/adc.h (100%)
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/cache.h (100%)
 create mode 100644 arch/sh/include/cpu-sh3/cpu/cacheflush.h
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/dac.h (100%)
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/dma.h (100%)
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/freq.h (100%)
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/gpio.h (100%)
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/mmu_context.h (100%)
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/timer.h (100%)
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/ubc.h (100%)
 rename {include/asm-sh/cpu-sh3 => arch/sh/include/cpu-sh3/cpu}/watchdog.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/addrspace.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/cache.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/cacheflush.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/dma-sh7780.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/dma.h (97%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/fpu.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/freq.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/mmu_context.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/rtc.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/sigcontext.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/sq.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/timer.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/ubc.h (100%)
 rename {include/asm-sh/cpu-sh4 => arch/sh/include/cpu-sh4/cpu}/watchdog.h (100%)
 rename {include/asm-sh/cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/addrspace.h (100%)
 rename {include/asm-sh/cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/cache.h (100%)
 rename {include/asm-sh/cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/cacheflush.h (100%)
 rename {include/asm-sh/cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/dma.h (100%)
 rename {include/asm-sh/cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/irq.h (100%)
 rename {include/asm-sh/cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/mmu_context.h (100%)
 rename {include/asm-sh/cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/registers.h (100%)
 rename {include/asm-sh/cpu-sh5 => arch/sh/include/cpu-sh5/cpu}/rtc.h (100%)
 rename {include/asm-sh/dreamcast => arch/sh/include/mach-dreamcast/mach}/dma.h (100%)
 rename {include/asm-sh/dreamcast => arch/sh/include/mach-dreamcast/mach}/maple.h (100%)
 rename {include/asm-sh/dreamcast => arch/sh/include/mach-dreamcast/mach}/pci.h (93%)
 rename {include/asm-sh/dreamcast => arch/sh/include/mach-dreamcast/mach}/sysasic.h (100%)
 rename {include/asm-sh/landisk => arch/sh/include/mach-landisk/mach}/gio.h (100%)
 rename {include/asm-sh/landisk => arch/sh/include/mach-landisk/mach}/iodata_landisk.h (100%)
 rename {include/asm-sh => arch/sh/include/mach-se/mach}/se.h (100%)
 rename {include/asm-sh => arch/sh/include/mach-se/mach}/se7206.h (100%)
 rename {include/asm-sh => arch/sh/include/mach-se/mach}/se7343.h (100%)
 rename {include/asm-sh => arch/sh/include/mach-se/mach}/se7721.h (100%)
 rename {include/asm-sh => arch/sh/include/mach-se/mach}/se7722.h (100%)
 rename {include/asm-sh => arch/sh/include/mach-se/mach}/se7751.h (100%)
 rename {include/asm-sh => arch/sh/include/mach-se/mach}/se7780.h (100%)
 rename {include/asm-sh/sh03 => arch/sh/include/mach-sh03/mach}/io.h (100%)
 rename {include/asm-sh/sh03 => arch/sh/include/mach-sh03/mach}/sh03.h (100%)
 create mode 100644 arch/sh/kernel/.gitignore
 delete mode 100644 include/asm-sh/.gitignore
 delete mode 100644 include/asm-sh/cpu-sh2a/addrspace.h
 delete mode 100644 include/asm-sh/cpu-sh2a/cacheflush.h
 delete mode 100644 include/asm-sh/cpu-sh2a/dma.h
 delete mode 100644 include/asm-sh/cpu-sh2a/mmu_context.h
 delete mode 100644 include/asm-sh/cpu-sh2a/timer.h
 delete mode 100644 include/asm-sh/cpu-sh2a/ubc.h
 delete mode 100644 include/asm-sh/cpu-sh2a/watchdog.h
 delete mode 100644 include/asm-sh/cpu-sh3/addrspace.h
 delete mode 100644 include/asm-sh/cpu-sh3/cacheflush.h
 delete mode 100644 include/asm-sh/cpu-sh3/rtc.h
 delete mode 100644 include/asm-sh/cpu-sh3/sigcontext.h
 delete mode 100644 include/asm-sh/cpu-sh5/timer.h
