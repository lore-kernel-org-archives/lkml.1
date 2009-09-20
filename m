Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZITSra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZITSra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZITSr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:47:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63222 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755081AbZITSr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:47:28 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 0/4] Use macros rather than hardcoding section names
Date: Sun, 20 Sep 2009 14:43:09 -0400
Message-Id: <1253472193-21106-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up the kernel's explicit references to
.data.page_aligned, .bss.page_aligned, and .data.init_task in C and
assembly code to instead use the standard macros for that purpose.

Version 3 differs from version 2 in two ways:
- The .data.init_task patch also updates the score architecture
- The powerpc __page_aligned_data patch was removed (since Benjamin
Herrenschmidt said he was taking it).

Version 2 differed from version 1 in that it added the kbuild patch,
fixing breakage in the x86 linker script caused indirectly by
including linux/linkage.h in x86's asm/cache.h.

This cleanup is in preparation for being able to change the names of
the .data.page_aligned and .bss.page_aligned sections to be
compatible with -ffunction-sections -fdata-sections (a prerequisite
for Ksplice).

Joe Perches (1):
  Use new __init_task_data macro in arch init_task.c files.

Tim Abbott (3):
  kbuild: Don't define ALIGN and ENTRY when preprocessing linker
    scripts.
  Use macros for .bss.page_aligned section.
  Use macros for .data.page_aligned section.

 arch/arm/kernel/init_task.c                 |    5 ++---
 arch/avr32/kernel/init_task.c               |    5 ++---
 arch/avr32/mm/init.c                        |    4 +---
 arch/cris/kernel/process.c                  |    5 ++---
 arch/frv/kernel/init_task.c                 |    5 ++---
 arch/h8300/kernel/init_task.c               |    5 ++---
 arch/ia64/kernel/init_task.c                |    3 ++-
 arch/m32r/kernel/init_task.c                |    5 ++---
 arch/m68k/kernel/process.c                  |    6 +++---
 arch/m68knommu/kernel/init_task.c           |    5 ++---
 arch/microblaze/kernel/init_task.c          |    5 ++---
 arch/mips/kernel/init_task.c                |    5 ++---
 arch/mn10300/kernel/init_task.c             |    5 ++---
 arch/parisc/kernel/init_task.c              |    4 ++--
 arch/powerpc/kernel/init_task.c             |    5 ++---
 arch/powerpc/kernel/machine_kexec_64.c      |    5 +++--
 arch/powerpc/kernel/vdso.c                  |    3 ++-
 arch/powerpc/kernel/vdso32/vdso32_wrapper.S |    3 ++-
 arch/powerpc/kernel/vdso64/vdso64_wrapper.S |    3 ++-
 arch/s390/kernel/init_task.c                |    5 ++---
 arch/s390/kernel/vdso.c                     |    2 +-
 arch/s390/kernel/vdso32/vdso32_wrapper.S    |    3 ++-
 arch/s390/kernel/vdso64/vdso64_wrapper.S    |    3 ++-
 arch/score/kernel/init_task.c               |    5 ++---
 arch/sh/kernel/init_task.c                  |    5 ++---
 arch/sh/kernel/irq.c                        |    6 ++----
 arch/sparc/kernel/init_task.c               |    5 ++---
 arch/um/kernel/init_task.c                  |    5 ++---
 arch/x86/include/asm/cache.h                |    4 +++-
 arch/x86/kernel/head_32.S                   |    4 ++--
 arch/x86/kernel/head_64.S                   |    2 +-
 arch/x86/kernel/init_task.c                 |    5 ++---
 arch/xtensa/kernel/head.S                   |    2 +-
 arch/xtensa/kernel/init_task.c              |    5 ++---
 include/linux/linkage.h                     |    2 ++
 scripts/Makefile.build                      |    3 ++-
 36 files changed, 71 insertions(+), 81 deletions(-)

