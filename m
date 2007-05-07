Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbXEGCSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbXEGCSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 22:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbXEGCSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 22:18:44 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:48543 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbXEGCSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 22:18:43 -0400
Date: Mon, 7 May 2007 11:18:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates
Message-ID: <20070507021817.GA26372@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Kristoffer Ericson (3):
      sh: hp6xx driver compile fixes.
      sh: hp6xx pata_platform support.
      sh: Fix APM emulation on hp6xx.

Nobuhiro Iwamatsu (7):
      sh: pata_platform pcmcia support for SolutionEngine boards.
      sh: L-BOX RE2 support.
      sh: MS7712SE01 board support.
      sh: Add defconfig for se7712.
      sh: SH7780 Solution Engine board support.
      sh: se7780 PCI support.
      sh: Solution Engine SH7705 board and CPU updates.

Paul Mundt (20):
      sh: Bring kgdb back from the dead.
      sh: Rip out broken kgdb thread support.
      sh: speculative execution support for SH7780.
      sh: generic BUG() support.
      sh: NR_IRQS consolidation.
      sh: Add SH7785 Highlander board support (R7785RP).
      serial: sh-sci: Kill off breakpoint in break IRQ.
      doc: Update sysrq doc for sh kgdb trigger.
      sh: bootmem tidying for discontig/sparsemem preparation.
      sh: Kill off udivdi3 div64_32 wrapping.
      sh: Add defconfig for se7722.
      sh: Tidy up L-BOX area5 addresses.
      sh: Add a dummy SH-4 PCIC fixup.
      sh: Obey CONFIG_HZ for HZ definition.
      serial: sh-sci: Fix module clock refcount for serial console.
      sh: Move clock reporting to its own proc entry.
      sh: kdump support.
      sh: Fix r7780rp build.
      sh: Add die chain notifiers.
      sh: Update r7780rp defconfig.

Ryusuke Sakato (2):
      sh: Solution Engine 7722 board support.
      sh: R7785RP board updates.

SUGIOKA Toshinobu (1):
      sh: Fix fstatat64() syscall.

Takashi YOSHII (2):
      sh: heartbeat double 0 fix.
      sh: Wire up more IRQs for SH7709.

dmitry pervushin (2):
      sh: SH7722 clock framework support.
      serial: sh-sci: Fix module clock refcounting.

kogiidena (1):
      sh: landisk updates.

 Documentation/sh/clk.txt                     |   32 +
 Documentation/sysrq.txt                      |    4 +-
 arch/sh/Kconfig                              |   97 ++-
 arch/sh/Kconfig.debug                        |   20 +-
 arch/sh/Makefile                             |    6 +-
 arch/sh/boards/hp6xx/Makefile                |    4 +-
 arch/sh/boards/hp6xx/setup.c                 |   67 +-
 arch/sh/boards/landisk/Makefile              |    2 +-
 arch/sh/boards/landisk/gio.c                 |  167 ++++
 arch/sh/boards/landisk/io.c                  |  250 -----
 arch/sh/boards/landisk/irq.c                 |   83 +--
 arch/sh/boards/landisk/landisk_pwb.c         |  346 -------
 arch/sh/boards/landisk/psw.c                 |  143 +++
 arch/sh/boards/landisk/rtc.c                 |   91 --
 arch/sh/boards/landisk/setup.c               |  163 +---
 arch/sh/boards/lboxre2/Makefile              |    5 +
 arch/sh/boards/lboxre2/irq.c                 |   31 +
 arch/sh/boards/lboxre2/setup.c               |   85 ++
 arch/sh/boards/renesas/r7780rp/Kconfig       |   18 +-
 arch/sh/boards/renesas/r7780rp/Makefile      |    6 +-
 arch/sh/boards/renesas/r7780rp/irq-r7780rp.c |   21 +
 arch/sh/boards/renesas/r7780rp/irq-r7785rp.c |   29 +
 arch/sh/boards/renesas/r7780rp/irq.c         |   25 +-
 arch/sh/boards/renesas/r7780rp/setup.c       |   78 +-
 arch/sh/boards/se/770x/io.c                  |    2 +
 arch/sh/boards/se/770x/irq.c                 |   57 +-
 arch/sh/boards/se/770x/setup.c               |   30 +-
 arch/sh/boards/se/7722/Makefile              |   10 +
 arch/sh/boards/se/7722/irq.c                 |  101 ++
 arch/sh/boards/se/7722/setup.c               |  148 +++
 arch/sh/boards/se/7751/setup.c               |  148 ---
 arch/sh/boards/se/7780/Makefile              |   10 +
 arch/sh/boards/se/7780/irq.c                 |   89 ++
 arch/sh/boards/se/7780/setup.c               |  122 +++
 arch/sh/configs/lboxre2_defconfig            | 1271 ++++++++++++++++++++++++
 arch/sh/configs/r7780rp_defconfig            |  108 ++-
 arch/sh/configs/r7785rp_defconfig            | 1334 ++++++++++++++++++++++++++
 arch/sh/configs/se7705_defconfig             |  106 ++-
 arch/sh/configs/se7712_defconfig             | 1088 +++++++++++++++++++++
 arch/sh/configs/se7722_defconfig             |  980 +++++++++++++++++++
 arch/sh/configs/se7780_defconfig             | 1309 +++++++++++++++++++++++++
 arch/sh/drivers/Kconfig                      |   10 +
 arch/sh/drivers/heartbeat.c                  |   13 +-
 arch/sh/drivers/pci/Makefile                 |    5 +-
 arch/sh/drivers/pci/fixups-lboxre2.c         |   41 +
 arch/sh/drivers/pci/fixups-se7780.c          |   60 ++
 arch/sh/drivers/pci/ops-landisk.c            |    4 +-
 arch/sh/drivers/pci/ops-lboxre2.c            |   63 ++
 arch/sh/drivers/pci/ops-r7780rp.c            |   27 +-
 arch/sh/drivers/pci/ops-se7780.c             |   96 ++
 arch/sh/drivers/pci/ops-sh4.c                |    6 +
 arch/sh/drivers/pci/pci-sh4.h                |    2 +-
 arch/sh/drivers/pci/pci-sh7751.c             |   15 +-
 arch/sh/drivers/pci/pci-sh7780.c             |   45 +-
 arch/sh/drivers/pci/pci-sh7780.h             |   19 +-
 arch/sh/kernel/Makefile                      |    1 +
 arch/sh/kernel/cf-enabler.c                  |   28 +-
 arch/sh/kernel/cpu/clock.c                   |  102 ++-
 arch/sh/kernel/cpu/init.c                    |   19 +
 arch/sh/kernel/cpu/irq/Makefile              |    2 +-
 arch/sh/kernel/cpu/irq/intc2.c               |    3 +-
 arch/sh/kernel/cpu/irq/pint.c                |   56 +-
 arch/sh/kernel/cpu/sh3/Makefile              |    1 +
 arch/sh/kernel/cpu/sh3/probe.c               |    3 +
 arch/sh/kernel/cpu/sh3/setup-sh7705.c        |   54 +-
 arch/sh/kernel/cpu/sh3/setup-sh7709.c        |   29 +-
 arch/sh/kernel/cpu/sh3/setup-sh7710.c        |   60 ++
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c       |    3 +-
 arch/sh/kernel/cpu/sh4/probe.c               |    8 +
 arch/sh/kernel/cpu/sh4a/Makefile             |    4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c       |  600 ++++++++++++
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c       |  162 ++++
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c       |  103 ++
 arch/sh/kernel/crash_dump.c                  |   46 +
 arch/sh/kernel/irq.c                         |    5 +-
 arch/sh/kernel/kgdb_stub.c                   |  490 ++---------
 arch/sh/kernel/machine_kexec.c               |   29 +-
 arch/sh/kernel/process.c                     |   14 +-
 arch/sh/kernel/setup.c                       |  267 ++----
 arch/sh/kernel/sh_ksyms.c                    |    1 -
 arch/sh/kernel/timers/timer-tmu.c            |    4 +-
 arch/sh/kernel/traps.c                       |   73 +-
 arch/sh/kernel/vmlinux.lds.S                 |   47 +-
 arch/sh/lib/Makefile                         |    4 +-
 arch/sh/lib/udivdi3.c                        |   16 -
 arch/sh/mm/Kconfig                           |   20 +
 arch/sh/mm/fault.c                           |   39 +-
 arch/sh/mm/init.c                            |  197 ++--
 arch/sh/tools/mach-types                     |    2 +
 drivers/input/touchscreen/hp680_ts_input.c   |    2 +-
 drivers/serial/sh-sci.c                      |  113 ++-
 drivers/serial/sh-sci.h                      |   83 ++-
 include/asm-sh/bug.h                         |   92 ++-
 include/asm-sh/clock.h                       |   32 +-
 include/asm-sh/cpu-sh3/mmu_context.h         |    1 +
 include/asm-sh/cpu-sh4/freq.h                |    8 +
 include/asm-sh/irq.h                         |   91 +--
 include/asm-sh/kdebug.h                      |   35 +
 include/asm-sh/kexec.h                       |   42 +-
 include/asm-sh/kgdb.h                        |   51 +-
 include/asm-sh/lboxre2.h                     |   27 +
 include/asm-sh/mmu_context.h                 |    6 +-
 include/asm-sh/page.h                        |   10 +-
 include/asm-sh/param.h                       |    2 +-
 include/asm-sh/pci.h                         |    2 +-
 include/asm-sh/processor.h                   |    2 +-
 include/asm-sh/r7780rp.h                     |   76 ++-
 include/asm-sh/se.h                          |    4 +-
 include/asm-sh/se7722.h                      |  118 +++
 include/asm-sh/se7751.h                      |    2 +
 include/asm-sh/se7780.h                      |  108 +++
 include/asm-sh/stat.h                        |   19 +-
 include/asm-sh/system.h                      |    3 +
 sound/oss/sh_dac_audio.c                     |    2 +-
 114 files changed, 10104 insertions(+), 2411 deletions(-)
