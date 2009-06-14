Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbZFNMBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbZFNMBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbZFNMB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:28 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52641 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbZFNMB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 00/17] Blackfin arch conversion to asm-generic
Date: Sun, 14 Jun 2009 08:01:01 -0400
Message-Id: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new asm-generic code in place, we can convert the Blackfin arch
over to it.  This in turn fixes a few outdated headers and rather than
manually update them, just drop our version in favor of the asm-generic
one.  I've tried to group the changes somewhat logically so that if some
conversion did go bad, it'll be easier to narrow things down with bisect
rather than one large changeset.

Mike Frysinger (17):
  Blackfin: use common test_bit() rather than __test_bit()
  Blackfin: pull in asm/io.h in ksyms for prototypes
  Blackfin: only build irqpanic.c when needed
  Blackfin: convert asm/ioctls.h to asm-generic/ioctls.h
  Blackfin: convert to generic checksum code
  Blackfin: convert shm/sysv/ipc to asm-generic
  Blackfin: convert user/elf to asm-generic
  Blackfin: convert socket/poll to asm-generic
  Blackfin: convert simple headers to asm-generic
  Blackfin: convert dma/pci to asm-generic
  Blackfin: convert termios to asm-generic
  Blackfin: convert locking primitives to asm-generic
  Blackfin: convert signal/mmap to asm-generic
  Blackfin: convert irq/process to asm-generic
  Blackfin: convert types to asm-generic
  Blackfin: convert page/tlb to asm-generic
  Blackfin: convert uaccess to asm-generic

 arch/blackfin/Kconfig                         |    3 +
 arch/blackfin/include/asm/atomic.h            |  109 +----------
 arch/blackfin/include/asm/auxvec.h            |    5 +-
 arch/blackfin/include/asm/bitops.h            |  198 +------------------
 arch/blackfin/include/asm/bugs.h              |   17 +--
 arch/blackfin/include/asm/checksum.h          |   72 +-------
 arch/blackfin/include/asm/cputime.h           |    5 -
 arch/blackfin/include/asm/current.h           |   24 +---
 arch/blackfin/include/asm/device.h            |    6 -
 arch/blackfin/include/asm/dma-mapping.h       |   91 +--------
 arch/blackfin/include/asm/dma.h               |    5 +-
 arch/blackfin/include/asm/elf.h               |    2 +-
 arch/blackfin/include/asm/emergency-restart.h |    5 -
 arch/blackfin/include/asm/errno.h             |    7 +-
 arch/blackfin/include/asm/fb.h                |   13 +--
 arch/blackfin/include/asm/futex.h             |    5 -
 arch/blackfin/include/asm/hardirq.h           |   36 +---
 arch/blackfin/include/asm/hw_irq.h            |    7 +-
 arch/blackfin/include/asm/io.h                |    1 -
 arch/blackfin/include/asm/ioctls.h            |   84 +--------
 arch/blackfin/include/asm/ipcbuf.h            |   31 +---
 arch/blackfin/include/asm/irq.h               |    5 +-
 arch/blackfin/include/asm/kmap_types.h        |   22 +--
 arch/blackfin/include/asm/local.h             |    5 -
 arch/blackfin/include/asm/mman.h              |   44 +----
 arch/blackfin/include/asm/msgbuf.h            |   32 +---
 arch/blackfin/include/asm/mutex.h             |    2 +-
 arch/blackfin/include/asm/page.h              |   85 +--------
 arch/blackfin/include/asm/param.h             |   23 +--
 arch/blackfin/include/asm/pci.h               |  149 +--------------
 arch/blackfin/include/asm/percpu.h            |    5 -
 arch/blackfin/include/asm/pgalloc.h           |    9 +-
 arch/blackfin/include/asm/poll.h              |   21 +--
 arch/blackfin/include/asm/posix_types.h       |   56 +-----
 arch/blackfin/include/asm/processor.h         |   35 +---
 arch/blackfin/include/asm/resource.h          |    5 -
 arch/blackfin/include/asm/scatterlist.h       |   29 +---
 arch/blackfin/include/asm/segment.h           |    8 +-
 arch/blackfin/include/asm/sembuf.h            |   26 +---
 arch/blackfin/include/asm/serial.h            |    6 +-
 arch/blackfin/include/asm/setup.h             |   18 +--
 arch/blackfin/include/asm/shmbuf.h            |   43 +----
 arch/blackfin/include/asm/shmparam.h          |    7 +-
 arch/blackfin/include/asm/signal.h            |  159 +---------------
 arch/blackfin/include/asm/socket.h            |   60 +------
 arch/blackfin/include/asm/sockios.h           |   14 +--
 arch/blackfin/include/asm/spinlock.h          |    6 +
 arch/blackfin/include/asm/statfs.h            |    5 -
 arch/blackfin/include/asm/swab.h              |    6 +-
 arch/blackfin/include/asm/termbits.h          |  199 +------------------
 arch/blackfin/include/asm/termios.h           |   95 +---------
 arch/blackfin/include/asm/tlbflush.h          |   57 +------
 arch/blackfin/include/asm/topology.h          |    5 -
 arch/blackfin/include/asm/types.h             |   37 +----
 arch/blackfin/include/asm/uaccess.h           |  265 +------------------------
 arch/blackfin/include/asm/ucontext.h          |   18 +--
 arch/blackfin/include/asm/unaligned.h         |   12 +-
 arch/blackfin/include/asm/user.h              |   90 +---------
 arch/blackfin/kernel/bfin_ksyms.c             |    1 +
 arch/blackfin/kernel/process.c                |   23 +++
 arch/blackfin/lib/Makefile                    |    2 +-
 arch/blackfin/lib/checksum.c                  |  145 --------------
 arch/blackfin/mach-common/Makefile            |    3 +-
 arch/blackfin/mach-common/ints-priority.c     |    4 +-
 arch/blackfin/mach-common/irqpanic.c          |   11 +-
 65 files changed, 141 insertions(+), 2437 deletions(-)
 delete mode 100644 arch/blackfin/lib/checksum.c

