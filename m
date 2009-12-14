Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZLNIBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZLNIBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 03:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZLNIBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 03:01:44 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41391 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbZLNIBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 03:01:41 -0500
Message-ID: <4B25F0BD.3090108@monstr.eu>
Date: Mon, 14 Dec 2009 09:01:01 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [GIT PULL] arch/microblaze patches 2.6.33
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes to your tree. There could be small 
overlapping additions conflicts in scripts/recordmcount.pl with MIPS
if come first. My patches are against current your head.

Thanks,
Michal


The following changes since commit f40542532e96dda5506eb76badea322f2ae4731c:
   Linus Torvalds (1):
         Merge branch 'ixp4xx' of git://git.kernel.org/.../chris/linux-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

John Linn (1):
       microblaze: Fix the heartbeat gpio to be more robust

John Williams (4):
       microblaze: Remove the buggy ALLOW_EDIT_AUTO config option
       microblaze: Use lowest-common-denominator default CPU settings
       microblaze: Simple __copy_tofrom_user for noMMU
       microblaze: Core oprofile configs and hooks

Michal Simek (38):
       microblaze: GPIO reset support
       microblaze: __init_begin symbol must be aligned
       microblaze: Add IRQENTRY_TEXT to lds
       microblaze: Stack trace support
       microblaze: Register timecounter/cyclecounter
       microblaze: Lockdep support
       microblaze: preliminary enabling for LATENCYTOP support in Kconfig
       microblaze: Add TRACE_IRQFLAGS_SUPPORT
       microblaze: ftrace: add static function tracer
       microblaze: ftrace: enable HAVE_FUNCTION_TRACE_MCOUNT_TEST
       microblaze: ftrace: Add dynamic trace support
       microblaze: ftrace: add function graph support
       microblaze: ftrace: Add dynamic function graph tracer
       microblaze: Remove saving and restoring before calling signal code
       microblaze: Fix announce message for reset gpio
       microblaze: Support both levels for reset
       microblaze: Detect new 7.20.d version
       microblaze: Fix cache_line_lenght
       microblaze: Extend cpuinfo for support write-back caches
       microblaze: Ptrace notifying from signal code
       microblaze: support U-BOOT image format
       microblaze: Move cache macro from cache.h to cacheflush.h
       microblaze: Enable asm optimization only for HW with barrel-shifter
       microblaze: Update default generic DTS
       microblaze: Export memory_start for modules
       microblaze: Adding dev_arch_data functions
       microblaze: Futex support
       microblaze: Remove duplicity from pgalloc.h
       microblaze: Checking DTS against PVR for write-back cache
       microblaze: Enable futimesat syscall
       microblaze: Enable DTC compilation
       microblaze: Do not count system calls in default
       microblaze: Remove panic_timeout init value
       microblaze: Remove ancient and fake microblaze version from 
cpu_ver table
       microblaze: Add PVR for Microblaze v7.30.a
       microblaze: Support for WB cache
       microblaze: Remove show_tmem function
       microblaze: Remove rt_sigsuspend wrapper

steve@digidescorp.com (3):
       microblaze: Fix pfn_valid() for noMMU
       microblaze: Fix level interrupt ACKing
       microblaze: nommu: Don't clobber R11 on syscalls

  arch/microblaze/Kconfig                        |   19 +
  arch/microblaze/Kconfig.debug                  |    3 +
  arch/microblaze/Makefile                       |    2 +
  arch/microblaze/boot/Makefile                  |   15 +-
  arch/microblaze/include/asm/cache.h            |   16 -
  arch/microblaze/include/asm/cacheflush.h       |  123 +++---
  arch/microblaze/include/asm/cpuinfo.h          |    5 +-
  arch/microblaze/include/asm/device.h           |   12 +
  arch/microblaze/include/asm/ftrace.h           |   25 +
  arch/microblaze/include/asm/futex.h            |  127 +++++-
  arch/microblaze/include/asm/irqflags.h         |  112 ++---
  arch/microblaze/include/asm/page.h             |    3 +-
  arch/microblaze/include/asm/pgalloc.h          |    9 +-
  arch/microblaze/include/asm/pvr.h              |   30 +-
  arch/microblaze/include/asm/setup.h            |    2 +
  arch/microblaze/include/asm/system.h           |    2 +
  arch/microblaze/include/asm/uaccess.h          |   12 +-
  arch/microblaze/kernel/Makefile                |   14 +-
  arch/microblaze/kernel/cpu/Makefile            |    4 +
  arch/microblaze/kernel/cpu/cache.c             |  663 
+++++++++++++++++-------
  arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c  |   15 +-
  arch/microblaze/kernel/cpu/cpuinfo-static.c    |   17 +-
  arch/microblaze/kernel/cpu/cpuinfo.c           |    7 +-
  arch/microblaze/kernel/cpu/mb.c                |    8 +-
  arch/microblaze/kernel/cpu/pvr.c               |    2 +-
  arch/microblaze/kernel/entry-nommu.S           |    2 -
  arch/microblaze/kernel/entry.S                 |   19 +-
  arch/microblaze/kernel/ftrace.c                |  237 +++++++++
  arch/microblaze/kernel/heartbeat.c             |   15 +-
  arch/microblaze/kernel/intc.c                  |   10 +-
  arch/microblaze/kernel/mcount.S                |  170 ++++++
  arch/microblaze/kernel/microblaze_ksyms.c      |    5 +
  arch/microblaze/kernel/process.c               |    1 +
  arch/microblaze/kernel/reset.c                 |  140 +++++
  arch/microblaze/kernel/setup.c                 |   40 +--
  arch/microblaze/kernel/signal.c                |   35 ++-
  arch/microblaze/kernel/stacktrace.c            |   65 +++
  arch/microblaze/kernel/syscall_table.S         |    4 +-
  arch/microblaze/kernel/timer.c                 |   28 +
  arch/microblaze/kernel/vmlinux.lds.S           |    6 +-
  arch/microblaze/lib/uaccess.c                  |    7 +
  arch/microblaze/mm/init.c                      |    1 +
  arch/microblaze/mm/pgtable.c                   |   10 -
  arch/microblaze/oprofile/Makefile              |   13 +
  arch/microblaze/oprofile/microblaze_oprofile.c |   22 +
  arch/microblaze/platform/Kconfig.platform      |   21 +-
  arch/microblaze/platform/generic/Kconfig.auto  |   29 +-
  arch/microblaze/platform/generic/system.dts    |   38 ++-
  arch/microblaze/platform/platform.c            |    2 +
  scripts/recordmcount.pl                        |    3 +
  50 files changed, 1686 insertions(+), 484 deletions(-)
  create mode 100644 arch/microblaze/kernel/ftrace.c
  create mode 100644 arch/microblaze/kernel/mcount.S
  create mode 100644 arch/microblaze/kernel/reset.c
  create mode 100644 arch/microblaze/kernel/stacktrace.c
  create mode 100644 arch/microblaze/oprofile/Makefile
  create mode 100644 arch/microblaze/oprofile/microblaze_oprofile.c


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
