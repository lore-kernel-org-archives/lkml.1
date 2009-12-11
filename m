Return-Path: <linux-kernel-owner+w=401wt.eu-S1762592AbZLKMAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbZLKMAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbZLKMAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:00:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52920 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbZLKMAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:00:32 -0500
Date: Fri, 11 Dec 2009 12:00:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [GIT PULL] mmap/mremap fixes
Message-ID: <20091211120038.GU14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	mmap/mremap fixes and cleanups.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/mmap.git/ master

	Compared to the last posted variant:
* added Acked-by as posted on l-k
* fixed braino in do_brk() spotted by Hugh
* expanded comment on sun3 mmap2()
* removed useless check in score mmap2()
* added missing check in score mmap()
All changes had been discussed in the thread.

Shortlog:
Al Viro (20):
      untangling do_mremap(), part 1
      do_mremap() untangling, part 2
      do_mremap() untangling, part 3
      fix checks for expand-in-place mremap
      fix the arch checks in MREMAP_FIXED case
      fix pgoff in "have to relocate" case of mremap()
      kill useless checks in sparc mremap variants
      file ->get_unmapped_area() shouldn't duplicate work of get_unmapped_area()
      arm: add arch_mmap_check(), get rid of sys_arm_mremap()
      Kill ancient crap in s390 compat mmap
      arch_mmap_check() on mn10300
      Cut hugetlb case early for 32bit on ia64
      Unify sys_mmap*
      fix a struct file leak in do_mmap_pgoff()
      Take arch_mmap_check() into get_unmapped_area()
      switch do_brk() to get_unmapped_area()
      sparc_brk() is not needed anymore
      Get rid of open-coding in ia64_brk()
      fix broken aliasing checks for MAP_FIXED on sparc32, mips, arm and sh
      Add missing alignment check in arch/score sys_mmap()

Diffstat:
 arch/alpha/kernel/osf_sys.c               |   19 +--
 arch/arm/include/asm/mman.h               |    3 +
 arch/arm/kernel/calls.S                   |    2 +-
 arch/arm/kernel/entry-common.S            |    4 +-
 arch/arm/kernel/sys_arm.c                 |   55 +-------
 arch/arm/mm/mmap.c                        |    3 +-
 arch/avr32/include/asm/syscalls.h         |    4 -
 arch/avr32/kernel/sys_avr32.c             |   31 ----
 arch/avr32/kernel/syscall-stubs.S         |    2 +-
 arch/blackfin/kernel/sys_bfin.c           |   33 ----
 arch/blackfin/mach-common/entry.S         |    2 +-
 arch/cris/kernel/sys_cris.c               |   30 +----
 arch/frv/kernel/sys_frv.c                 |   66 +--------
 arch/h8300/kernel/sys_h8300.c             |   83 +----------
 arch/h8300/kernel/syscalls.S              |    2 +-
 arch/ia64/ia32/sys_ia32.c                 |    3 +
 arch/ia64/kernel/sys_ia64.c               |   83 +----------
 arch/m32r/kernel/sys_m32r.c               |   24 ---
 arch/m32r/kernel/syscall_table.S          |    2 +-
 arch/m68k/kernel/sys_m68k.c               |   83 +---------
 arch/m68knommu/kernel/sys_m68k.c          |   38 +-----
 arch/m68knommu/kernel/syscalltable.S      |    2 +-
 arch/microblaze/kernel/sys_microblaze.c   |   38 +----
 arch/microblaze/kernel/syscall_table.S    |    2 +-
 arch/mips/kernel/linux32.c                |   19 +--
 arch/mips/kernel/syscall.c                |   32 +----
 arch/mn10300/include/asm/mman.h           |    5 +
 arch/mn10300/kernel/entry.S               |    2 +-
 arch/mn10300/kernel/sys_mn10300.c         |   36 +----
 arch/parisc/kernel/sys_parisc.c           |   30 +---
 arch/powerpc/kernel/syscalls.c            |   15 +--
 arch/s390/kernel/compat_linux.c           |   37 +----
 arch/s390/kernel/sys_s390.c               |   30 +----
 arch/score/kernel/sys_score.c             |   28 +---
 arch/sh/kernel/sys_sh.c                   |   28 +---
 arch/sh/mm/mmap.c                         |    3 +-
 arch/sparc/kernel/sys_sparc32.c           |   22 ---
 arch/sparc/kernel/sys_sparc_32.c          |   64 +-------
 arch/sparc/kernel/sys_sparc_64.c          |   50 ++-----
 arch/sparc/kernel/systbls.h               |    1 -
 arch/sparc/kernel/systbls_32.S            |    4 +-
 arch/sparc/kernel/systbls_64.S            |    6 +-
 arch/um/kernel/syscall.c                  |   28 +---
 arch/um/sys-i386/shared/sysdep/syscalls.h |    4 -
 arch/x86/ia32/ia32entry.S                 |    2 +-
 arch/x86/ia32/sys_ia32.c                  |   43 +-----
 arch/x86/include/asm/sys_ia32.h           |    3 -
 arch/x86/include/asm/syscalls.h           |    2 -
 arch/x86/kernel/sys_i386_32.c             |   27 +---
 arch/x86/kernel/sys_x86_64.c              |   17 +--
 arch/x86/kernel/syscall_table_32.S        |    2 +-
 arch/xtensa/include/asm/syscall.h         |    2 -
 arch/xtensa/include/asm/unistd.h          |    2 +-
 arch/xtensa/kernel/syscall.c              |   25 ---
 include/linux/syscalls.h                  |    4 +
 ipc/shm.c                                 |   31 ++--
 mm/mmap.c                                 |   42 ++----
 mm/mremap.c                               |  241 +++++++++++++++++++----------
 mm/util.c                                 |   44 ++++++
 59 files changed, 343 insertions(+), 1202 deletions(-)
