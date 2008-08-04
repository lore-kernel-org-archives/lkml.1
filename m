Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYHDLTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYHDLTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbYHDLSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:18:46 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:2714 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754961AbYHDLSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:18:44 -0400
Date: Mon, 4 Aug 2008 20:17:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.27-rc2
Message-ID: <20080804111756.GA13735@linux-sh.org>
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

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Adrian Bunk (2):
      sh: fix LIBGCC
      sh/boards/Makefile typo fix

Adrian McMenamin (2):
      maple: allow removal and reinsertion of keyboard driver module
      input: Clean up maple keyboard driver

Huang Weiyi (2):
      arch/sh/boards/board-ap325rxa.c: removed duplicated #include
      arch/sh/boards/mach-se/7343/irq.c: removed duplicated #include

Paul Mundt (20):
      sh: Tidy up the _TIF work masks, and fix syscall trace bug on singlestep.
      sh: seccomp support.
      sh: ptrace single stepping cleanups.
      sh: Make syscall tracer use tracehook notifiers, add TIF_NOTIFY_RESUME.
      sh: Fix up the audit arch endian specification.
      net: stnic: Fix up fallout from SH header migration.
      sh: Revert the location change of auto-generated asm/machtypes.h
      sh: /proc/asids depends on MMU.
      maple: Clean up maple_driver_register/unregister routines.
      maple: Kill useless private_data pointer.
      sh: Fix up broken kerneldoc comments.
      sh: Add documentation and integrate into docbook build.
      sh: Fix up __bug_table handling in module loader.
      sh: module_alloc() should be using vmalloc_exec().
      sh: Save NUMA node data in vmcore for crash dumps.
      sh: define GENERIC_LOCKBREAK.
      sh: define GENERIC_HARDIRQS_NO__DO_IRQ.
      sh: Kill off ARCH_SUPPORTS_AOUT and remnants of a.out support.
      nommu: Provide vmalloc_exec().
      sh: enable maple_keyb in dreamcast_defconfig.

Simon Horman (1):
      kdump: sh: parse elfcorehdr command line argument

Takashi Yoshii (1):
      add addrespace definition for sh2a.

Yoshinori Sato (1):
      SH2(A) cache update

 Documentation/DocBook/Makefile            |    2 +-
 Documentation/DocBook/sh.tmpl             |  105 ++++++++++++++++++
 arch/sh/Kconfig                           |   27 ++++-
 arch/sh/Kconfig.debug                     |    2 +-
 arch/sh/Makefile                          |   16 ++--
 arch/sh/boards/Makefile                   |    2 +-
 arch/sh/boards/board-ap325rxa.c           |    1 -
 arch/sh/boards/mach-se/7343/irq.c         |    1 -
 arch/sh/configs/dreamcast_defconfig       |   14 +--
 arch/sh/include/asm/a.out.h               |   20 ----
 arch/sh/include/asm/ptrace.h              |    9 ++
 arch/sh/include/asm/seccomp.h             |   10 ++
 arch/sh/include/asm/thread_info.h         |   51 ++++++---
 arch/sh/include/asm/tlb_64.h              |   12 +--
 arch/sh/include/cpu-sh2/cpu/cache.h       |    6 +-
 arch/sh/include/cpu-sh2a/cpu/addrspace.h  |   10 ++
 arch/sh/include/cpu-sh2a/cpu/cache.h      |    3 +
 arch/sh/include/cpu-sh2a/cpu/cacheflush.h |   34 ++++++
 arch/sh/kernel/cpu/sh4/sq.c               |    2 +-
 arch/sh/kernel/cpu/sh5/entry.S            |   19 ++--
 arch/sh/kernel/entry-common.S             |   16 +--
 arch/sh/kernel/machine_kexec.c            |    8 ++
 arch/sh/kernel/module.c                   |    7 +-
 arch/sh/kernel/ptrace_32.c                |  157 ++++++++++-----------------
 arch/sh/kernel/ptrace_64.c                |  144 +++++++++---------------
 arch/sh/kernel/setup.c                    |   20 ++++
 arch/sh/kernel/signal_32.c                |   22 +++-
 arch/sh/kernel/signal_64.c                |  166 +++++++++++++++-------------
 arch/sh/mm/Kconfig                        |    1 -
 arch/sh/mm/Makefile_32                    |   11 +-
 arch/sh/mm/cache-sh2.c                    |   45 ++++++--
 arch/sh/mm/cache-sh2a.c                   |  129 +++++++++++++++++++++
 arch/sh/mm/tlb-sh5.c                      |   20 +---
 arch/sh/tools/Makefile                    |    4 +-
 drivers/input/keyboard/maple_keyb.c       |  172 +++++++++++++++--------------
 drivers/net/stnic.c                       |    2 +-
 drivers/sh/maple/maple.c                  |   65 +++++++----
 include/linux/maple.h                     |    8 +-
 mm/nommu.c                                |   21 ++++
 39 files changed, 854 insertions(+), 510 deletions(-)
 create mode 100644 Documentation/DocBook/sh.tmpl
 delete mode 100644 arch/sh/include/asm/a.out.h
 create mode 100644 arch/sh/include/asm/seccomp.h
 create mode 100644 arch/sh/include/cpu-sh2a/cpu/addrspace.h
 create mode 100644 arch/sh/include/cpu-sh2a/cpu/cacheflush.h
 create mode 100644 arch/sh/mm/cache-sh2a.c
