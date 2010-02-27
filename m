Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936293Ab0B0VSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:18:44 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:58568 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab0B0VSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:18:42 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Feb 2010 16:18:41 EST
Date: Sat, 27 Feb 2010 22:13:34 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 2.6.34
Message-ID: <alpine.DEB.2.00.1002272207450.9843@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

Please pull to receive the m68k updates for 2.6.34.

The parts that impact m68knommu have been acked by Greg.
The pmac_zilog parts have been acked by BenH.

Thanks!

The following changes since commit 06a79b82b2a3e4bebb9a20638ca208c780e9e507:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../rafael/suspend-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Finn Thain (13):
      mac68k: cleanup
      mac68k: rework SWIM platform device
      pmac-zilog: cleanup
      pmac-zilog: add platform driver
      mac68k: replace mac68k SCC code with platform device
      mac68k: move mac_esp platform device
      mac68k: move macsonic and macmace platform devices
      fbdev: mac_var_to_mode() fix
      valkyriefb: various fixes
      mac68k: start CUDA early
      fbdev: add some missing mac modes
      macfb: cleanup
      macfb: fix 24-bit visual and stuff

Geert Uytterhoeven (2):
      ataflop: Killl warning about unused variable flags
      m68k: Eliminate unused variable in page_to_phys()

Julia Lawall (1):
      m68k: Use DIV_ROUND_CLOSEST

Maxim Kuvyrkov (5):
      m68k: Fix asm/swab.h for ColdFire
      m68k: Switch to generic siginfo layout
      m68k: Add NPTL support
      m68knommu: NPTL support for uClinux
      m68k: Define sigcontext ABI of ColdFire

Peter Huewe (1):
      m68k: vme_scc - __init annotations

Philippe De Muyter (2):
      m68k: Allow ioremapping top of memory
      m68k{,nommu}/h8300: Remove obsolete comment about map_chunk

 arch/h8300/mm/memory.c                 |    4 +-
 arch/m68k/Kconfig                      |    6 +-
 arch/m68k/amiga/config.c               |    2 +-
 arch/m68k/configs/mac_defconfig        |    7 +-
 arch/m68k/configs/multi_defconfig      |    6 +-
 arch/m68k/include/asm/machw.h          |   25 --
 arch/m68k/include/asm/macints.h        |   22 +-
 arch/m68k/include/asm/ptrace.h         |    2 +
 arch/m68k/include/asm/sigcontext.h     |    6 +
 arch/m68k/include/asm/siginfo.h        |   91 ----
 arch/m68k/include/asm/swab.h           |    2 +-
 arch/m68k/include/asm/thread_info_mm.h |    1 +
 arch/m68k/include/asm/thread_info_no.h |    1 +
 arch/m68k/include/asm/ucontext.h       |    4 +
 arch/m68k/include/asm/unistd.h         |    6 +-
 arch/m68k/include/asm/virtconvert.h    |    7 +-
 arch/m68k/kernel/entry.S               |    4 +
 arch/m68k/kernel/process.c             |    4 +
 arch/m68k/kernel/ptrace.c              |    5 +
 arch/m68k/kernel/signal.c              |    7 +
 arch/m68k/kernel/sys_m68k.c            |   81 ++++
 arch/m68k/mac/Makefile                 |    2 +-
 arch/m68k/mac/config.c                 |  344 ++++++++++------
 arch/m68k/mac/debug.c                  |  365 ----------------
 arch/m68k/mac/macints.c                |  101 +----
 arch/m68k/mac/oss.c                    |   20 +-
 arch/m68k/mac/via.c                    |    7 -
 arch/m68k/mm/kmap.c                    |    5 +-
 arch/m68knommu/kernel/process.c        |    4 +
 arch/m68knommu/kernel/ptrace.c         |    5 +
 arch/m68knommu/kernel/sys_m68k.c       |   36 ++
 arch/m68knommu/kernel/syscalltable.S   |    4 +
 arch/m68knommu/mm/memory.c             |    1 -
 drivers/block/ataflop.c                |    2 -
 drivers/block/swim.c                   |    4 +-
 drivers/char/vme_scc.c                 |   12 +-
 drivers/macintosh/adb.c                |    6 +-
 drivers/macintosh/via-cuda.c           |   74 ++--
 drivers/net/macmace.c                  |   33 +--
 drivers/net/macsonic.c                 |   33 +--
 drivers/scsi/mac_esp.c                 |   57 +---
 drivers/serial/Kconfig                 |   12 +-
 drivers/serial/pmac_zilog.c            |  240 ++++++++---
 drivers/serial/pmac_zilog.h            |   34 +-
 drivers/video/macfb.c                  |  736 +++++++++++++++-----------------
 drivers/video/macmodes.c               |   80 +++--
 drivers/video/valkyriefb.c             |    6 +-
 drivers/video/valkyriefb.h             |   31 +-
 48 files changed, 1111 insertions(+), 1436 deletions(-)
 delete mode 100644 arch/m68k/mac/debug.c

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
