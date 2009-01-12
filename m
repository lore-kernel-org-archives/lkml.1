Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZALUNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZALUNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbZALUMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:12:43 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:36134 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbZALUMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:12:41 -0500
Date: Mon, 12 Jan 2009 21:12:35 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [git] m68k
Message-ID: <Pine.LNX.4.64.0901122058450.15532@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

Please pull from

    git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

to receive the m68k-related updates for 2.6.29 below.

Most of them are cleanups (some similar ones already went in last week through
subsystem trees), but there are a few genuine fixes, incl. a fix for the very
visible corrupted penguin logo on Atari!

Thanks!

Al Viro (1):
      m68k: Fix --build-id breakage for sun3

Andreas Bombe (1):
      m68k: amiflop - Get rid of sleep_on calls

Andreas Schwab (1):
      m68k: Wire up sys_restart_syscall

Geert Uytterhoeven (25):
      fbdev: atafb - Fix line length handling
      fbdev: atafb - Fix 16 bpp console
      fbdev: c2p - Correct indentation
      fbdev: c2p - Cleanups
      fbdev: c2p - Extract common c2p core to c2p_core.h
      fbdev: c2p/atafb - Add support for Atari interleaved bitplanes
      fbdev: c2p - Rename c2p to c2p_planar
      m68k: Kill several external declarations in source files
      m68k: amiga core - Kill warn_unused_result warnings
      m68k: apollo core - Kill warn_unused_result warnings
      m68k: atari core - Kill warn_unused_result warnings
      m68k: hp300 core - Kill warn_unused_result warnings
      m68k: mac core - Kill warn_unused_result warnings
      m68k: mvme147 core - Kill warn_unused_result warnings
      m68k: sun3 core - Kill warn_unused_result warnings
      m68k: vme_scc - Kill warn_unused_result warnings
      m68k: ser_a2232 - Kill warn_unused_result warnings
      m68k: amiserial - Kill warn_unused_result warnings
      m68k: atafb - Kill warn_unused_result warnings
      m68k: dio - Kill warn_unused_result warnings
      m68k: zorro - Kill warn_unused_result warnings
      m68k: dmasound - Kill warn_unused_result warnings
      m68k: dio - Kill resource_size_t format warnings
      m68k: zorro - Use %pR to print resources
      fbdev: Kill Atari vblank cursor blinking

Kars de Jong (2):
      m68k: Add vmlinux.lds to .gitignore
      m68k: zorro - Add devlist.h and gen-devlist to .gitignore

 arch/m68k/amiga/amiints.c           |   12 ++-
 arch/m68k/amiga/cia.c               |    4 +-
 arch/m68k/amiga/config.c            |    3 +-
 arch/m68k/apollo/config.c           |    7 +-
 arch/m68k/atari/atakeyb.c           |   10 +-
 arch/m68k/atari/stdma.c             |    5 +-
 arch/m68k/atari/time.c              |    5 +-
 arch/m68k/bvme6000/config.c         |    1 -
 arch/m68k/hp300/time.c              |    3 +-
 arch/m68k/kernel/.gitignore         |    1 +
 arch/m68k/kernel/entry.S            |    2 +-
 arch/m68k/kernel/setup.c            |   11 +-
 arch/m68k/kernel/signal.c           |   15 +++
 arch/m68k/kernel/vmlinux-sun3.lds   |    1 +
 arch/m68k/mac/baboon.c              |    3 +-
 arch/m68k/mac/config.c              |   12 --
 arch/m68k/mac/debug.c               |    1 -
 arch/m68k/mac/iop.c                 |   10 +-
 arch/m68k/mac/macints.c             |   15 +--
 arch/m68k/mac/misc.c                |    1 -
 arch/m68k/mac/oss.c                 |   25 +++--
 arch/m68k/mac/psc.c                 |   12 ++-
 arch/m68k/mac/via.c                 |   35 +++--
 arch/m68k/math-emu/fp_log.c         |    1 -
 arch/m68k/mm/init.c                 |    4 +-
 arch/m68k/mm/motorola.c             |    7 +-
 arch/m68k/mvme147/config.c          |    6 +-
 arch/m68k/mvme16x/config.c          |    1 -
 arch/m68k/q40/config.c              |    3 -
 arch/m68k/sun3/config.c             |    8 +-
 arch/m68k/sun3/mmu_emu.c            |    1 -
 arch/m68k/sun3/sun3ints.c           |    9 +-
 arch/m68k/sun3x/config.c            |    1 -
 drivers/block/amiflop.c             |   40 +++----
 drivers/char/amiserial.c            |   36 +++++-
 drivers/char/ser_a2232.c            |   12 ++-
 drivers/char/vme_scc.c              |  166 ++++++++++++++++++++-----
 drivers/dio/dio-sysfs.c             |   19 ++-
 drivers/dio/dio.c                   |   18 +++-
 drivers/video/Makefile              |    4 +-
 drivers/video/amifb.c               |    6 +-
 drivers/video/atafb.c               |  112 +++++++----------
 drivers/video/c2p.c                 |  232 -----------------------------------
 drivers/video/c2p.h                 |   11 +-
 drivers/video/c2p_core.h            |  153 +++++++++++++++++++++++
 drivers/video/c2p_iplan2.c          |  153 +++++++++++++++++++++++
 drivers/video/c2p_planar.c          |  156 +++++++++++++++++++++++
 drivers/video/console/fbcon.c       |   38 ------
 drivers/zorro/.gitignore            |    2 +
 drivers/zorro/zorro-sysfs.c         |   20 ++--
 drivers/zorro/zorro.c               |   23 +++-
 drivers/zorro/zorro.h               |    2 +-
 include/asm-m68k/unistd.h           |    4 +-
 include/linux/dio.h                 |    2 +-
 sound/oss/dmasound/dmasound_atari.c |    5 +-
 sound/oss/dmasound/dmasound_q40.c   |   16 ++-
 56 files changed, 912 insertions(+), 553 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
