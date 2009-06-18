Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZFRR4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZFRR4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZFRRzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:55:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51126 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZFRRzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:55:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/11] microblaze: use generic headers
Date: Thu, 18 Jun 2009 19:55:24 +0200
Message-Id: <cover.1245345894.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
X-Provags-ID: V01U2FsdGVkX1+DMDnJ68I5wd5U0r4+8QSvoXQaUfLtb5zPAUX
 WZjju2VZd6jpOkt2F17SgQ6SaqtQEtkxTkBsn7gjujbNq+KQPf
 FBLkEo10e9Mf8ZcAHBtgw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series changes the microblaze architecture to just
fall back on generic headers. This is especially important
for those header files that define the user space ABI.

While there has already been a release (2.6.30) with
a different ABI, I hope that changing it now will still
simplify life in the future.
The unistd.h file still defines a lof of the legacy
system calls by setting __ARCH_WANT_SYSCALL_* macros.
These should be removed once the C libraries have been
adapted to work without them. Unfortunately, doing that
will change the ABI one more time in a forward-compatible
way: new C libraries and applications will still work on
older kernels, but old applications may not run on new
kernels after that change.

Michal, please apply for 2.6.31 or pull from
git://git.kernel.org:/pub/scm/linux/kernel/git/arnd/asm-generic.git microblaze

	Arnd <><

Arnd Bergmann (8):
  ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
  microblaze: remove init_mm
  microblaze: fall back on generic header files for the ABI
  microblaze: use generic unistd.h syscall list
  microblaze: clean up signal handling
  microblaze: use generic syscalls.h
  microblaze: make syscall_table implementation generic
  microblaze: remove sys_ipc

Remis Lima Baima (3):
  microblaze: use the generic lib/checksum.c
  microblaze: convert all simple headers to use asm-generic
  microblaze: use generic system.h

 arch/microblaze/Kconfig                      |    6 +
 arch/microblaze/include/asm/atomic.h         |  124 +--------
 arch/microblaze/include/asm/bitops.h         |   28 +--
 arch/microblaze/include/asm/bug.h            |   14 -
 arch/microblaze/include/asm/bugs.h           |   18 +-
 arch/microblaze/include/asm/checksum.h       |  134 ++------
 arch/microblaze/include/asm/cmpxchg-local.h  |    1 +
 arch/microblaze/include/asm/fb.h             |    1 +
 arch/microblaze/include/asm/hardirq.h        |   14 +-
 arch/microblaze/include/asm/ioctls.h         |   92 +------
 arch/microblaze/include/asm/ipcbuf.h         |   37 +---
 arch/microblaze/include/asm/irq.h            |    6 +-
 arch/microblaze/include/asm/irqflags.h       |    2 +-
 arch/microblaze/include/asm/mman.h           |   26 +--
 arch/microblaze/include/asm/mmu.h            |    7 +-
 arch/microblaze/include/asm/mmu_context.h    |    2 +-
 arch/microblaze/include/asm/mmu_context_no.h |   23 --
 arch/microblaze/include/asm/module.h         |   10 +-
 arch/microblaze/include/asm/msgbuf.h         |   32 +--
 arch/microblaze/include/asm/param.h          |   31 +--
 arch/microblaze/include/asm/parport.h        |    1 +
 arch/microblaze/include/asm/pci.h            |    2 +-
 arch/microblaze/include/asm/posix_types.h    |   94 ++-----
 arch/microblaze/include/asm/scatterlist.h    |   29 +--
 arch/microblaze/include/asm/sembuf.h         |   35 +--
 arch/microblaze/include/asm/serial.h         |   15 +-
 arch/microblaze/include/asm/shmbuf.h         |   43 +---
 arch/microblaze/include/asm/shmparam.h       |    7 +-
 arch/microblaze/include/asm/siginfo.h        |   14 -
 arch/microblaze/include/asm/signal.h         |  166 +----------
 arch/microblaze/include/asm/socket.h         |   70 +----
 arch/microblaze/include/asm/sockios.h        |   24 +--
 arch/microblaze/include/asm/stat.h           |   69 +----
 arch/microblaze/include/asm/swab.h           |    9 +-
 arch/microblaze/include/asm/syscalls.h       |   56 +---
 arch/microblaze/include/asm/system.h         |  121 ++------
 arch/microblaze/include/asm/termbits.h       |  204 +------------
 arch/microblaze/include/asm/termios.h        |   89 +------
 arch/microblaze/include/asm/timex.h          |    6 +-
 arch/microblaze/include/asm/types.h          |   39 +---
 arch/microblaze/include/asm/ucontext.h       |   23 +--
 arch/microblaze/include/asm/unistd.h         |  435 +-------------------------
 arch/microblaze/include/asm/vga.h            |    2 +-
 arch/microblaze/kernel/entry-nommu.S         |   35 +--
 arch/microblaze/kernel/init_task.c           |    2 -
 arch/microblaze/kernel/signal.c              |  178 +++--------
 arch/microblaze/kernel/sys_microblaze.c      |  109 +------
 arch/microblaze/kernel/syscall_table.S       |  371 ----------------------
 arch/microblaze/lib/Makefile                 |    2 +-
 arch/microblaze/lib/checksum.c               |  172 ----------
 ipc/util.h                                   |    2 +-
 kernel/Makefile                              |    1 +
 kernel/syscall_table.c                       |   12 +
 53 files changed, 218 insertions(+), 2827 deletions(-)
 rewrite arch/microblaze/include/asm/atomic.h (100%)
 rewrite arch/microblaze/include/asm/bitops.h (95%)
 rewrite arch/microblaze/include/asm/checksum.h (69%)
 create mode 100644 arch/microblaze/include/asm/cmpxchg-local.h
 create mode 100644 arch/microblaze/include/asm/fb.h
 rewrite arch/microblaze/include/asm/ioctls.h (100%)
 rewrite arch/microblaze/include/asm/ipcbuf.h (100%)
 rewrite arch/microblaze/include/asm/mman.h (96%)
 delete mode 100644 arch/microblaze/include/asm/mmu_context_no.h
 rewrite arch/microblaze/include/asm/msgbuf.h (100%)
 rewrite arch/microblaze/include/asm/param.h (100%)
 create mode 100644 arch/microblaze/include/asm/parport.h
 rewrite arch/microblaze/include/asm/posix_types.h (96%)
 rewrite arch/microblaze/include/asm/scatterlist.h (100%)
 rewrite arch/microblaze/include/asm/sembuf.h (100%)
 rewrite arch/microblaze/include/asm/shmbuf.h (100%)
 rewrite arch/microblaze/include/asm/signal.h (100%)
 rewrite arch/microblaze/include/asm/socket.h (100%)
 rewrite arch/microblaze/include/asm/sockios.h (100%)
 rewrite arch/microblaze/include/asm/stat.h (100%)
 rewrite arch/microblaze/include/asm/syscalls.h (95%)
 rewrite arch/microblaze/include/asm/system.h (66%)
 rewrite arch/microblaze/include/asm/termbits.h (100%)
 rewrite arch/microblaze/include/asm/termios.h (100%)
 rewrite arch/microblaze/include/asm/types.h (100%)
 rewrite arch/microblaze/include/asm/ucontext.h (100%)
 rewrite arch/microblaze/include/asm/unistd.h (99%)
 delete mode 100644 arch/microblaze/kernel/syscall_table.S
 delete mode 100644 arch/microblaze/lib/checksum.c
 create mode 100644 kernel/syscall_table.c

