Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZGFM3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZGFM3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZGFM3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:29:38 -0400
Received: from ey-out-1920.google.com ([74.125.78.144]:28480 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZGFM3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:29:37 -0400
Message-ID: <4A51EE30.709@monstr.eu>
Date: Mon, 06 Jul 2009 14:29:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.31-rc3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal


The following changes since commit 8e4a718ff38d8539938ec3421935904c27e00c39:
  Linus Torvalds (1):
        Linux 2.6.31-rc2

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus

Arnd Bergmann (3):
      microblaze: fall back on generic header files for the ABI
      microblaze: clean up signal handling
      microblaze: use generic syscalls.h

Michal Simek (2):
      microblaze: Wire up new syscalls
      microblaze: Fix cast warning for init.c

Remis Lima Baima (2):
      microblaze: use the generic lib/checksum.c
      microblaze: convert all simple headers to use asm-generic

 arch/microblaze/Kconfig                      |    3 +
 arch/microblaze/include/asm/atomic.h         |  101 +-------------
 arch/microblaze/include/asm/bitops.h         |   26 ----
 arch/microblaze/include/asm/bug.h            |   14 --
 arch/microblaze/include/asm/bugs.h           |   18 +--
 arch/microblaze/include/asm/checksum.h       |   70 +---------
 arch/microblaze/include/asm/fb.h             |    1 +
 arch/microblaze/include/asm/hardirq.h        |   14 +--
 arch/microblaze/include/asm/ioctls.h         |   92 +------------
 arch/microblaze/include/asm/ipcbuf.h         |   37 +-----
 arch/microblaze/include/asm/irq.h            |    6 +-
 arch/microblaze/include/asm/mman.h           |   24 ---
 arch/microblaze/include/asm/mmu.h            |    7 +-
 arch/microblaze/include/asm/mmu_context.h    |    2 +-
 arch/microblaze/include/asm/mmu_context_no.h |   23 ---
 arch/microblaze/include/asm/module.h         |   10 +-
 arch/microblaze/include/asm/msgbuf.h         |   32 +----
 arch/microblaze/include/asm/param.h          |   31 +----
 arch/microblaze/include/asm/parport.h        |    1 +
 arch/microblaze/include/asm/pci.h            |    2 +-
 arch/microblaze/include/asm/posix_types.h    |   68 +---------
 arch/microblaze/include/asm/scatterlist.h    |   29 +----
 arch/microblaze/include/asm/sembuf.h         |   35 +-----
 arch/microblaze/include/asm/serial.h         |   15 +--
 arch/microblaze/include/asm/shmbuf.h         |   43 +------
 arch/microblaze/include/asm/shmparam.h       |    7 +-
 arch/microblaze/include/asm/siginfo.h        |   14 --
 arch/microblaze/include/asm/signal.h         |  166 +---------------------
 arch/microblaze/include/asm/socket.h         |   70 +---------
 arch/microblaze/include/asm/sockios.h        |   24 +---
 arch/microblaze/include/asm/stat.h           |   69 +---------
 arch/microblaze/include/asm/swab.h           |    9 +-
 arch/microblaze/include/asm/syscalls.h       |   46 +------
 arch/microblaze/include/asm/system.h         |    3 +
 arch/microblaze/include/asm/termbits.h       |  204 +-------------------------
 arch/microblaze/include/asm/termios.h        |   89 +-----------
 arch/microblaze/include/asm/timex.h          |    6 +-
 arch/microblaze/include/asm/types.h          |   39 +-----
 arch/microblaze/include/asm/ucontext.h       |   23 +---
 arch/microblaze/include/asm/unistd.h         |    6 +-
 arch/microblaze/include/asm/vga.h            |    2 +-
 arch/microblaze/kernel/entry-nommu.S         |   20 +--
 arch/microblaze/kernel/entry.S               |   34 +----
 arch/microblaze/kernel/signal.c              |  174 +++++-----------------
 arch/microblaze/kernel/sys_microblaze.c      |   20 ++--
 arch/microblaze/kernel/syscall_table.S       |   14 +-
 arch/microblaze/lib/Makefile                 |    2 +-
 arch/microblaze/lib/checksum.c               |  172 ----------------------
 arch/microblaze/mm/init.c                    |    6 +-
 49 files changed, 120 insertions(+), 1803 deletions(-)
 create mode 100644 arch/microblaze/include/asm/fb.h
 delete mode 100644 arch/microblaze/include/asm/mmu_context_no.h
 create mode 100644 arch/microblaze/include/asm/parport.h
 delete mode 100644 arch/microblaze/lib/checksum.c


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
