Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYBMIk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYBMIk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYBMIkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:40:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41835
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751972AbYBMIks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:40:48 -0500
Date: Wed, 13 Feb 2008 00:41:20 -0800 (PST)
Message-Id: <20080213.004120.22092044.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT]: Make LMB code sharable with sparc64.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As I mentioned to a few ppc folks at LCA08 I plan to use
the LMB code from powerpc as a basis for NUMA support on
sparc64.

There are two changes.

1) Move arch/powerpc/mm/lmb.c to lib/lmb.c, put the main
   interface bits in include/linux/lmb.h, put arch-specific
   bits in asm/lmb.h and add Kconfig machinery to build this
   stuff on sparc64.

2) Fix a bug in lmb_alloc() wherein the size was not aligned
   so we could easily run out of reserve blocks because
   every aligned allocation would create a tiny hole, and
   secondly the lmb_reserve() call there did not have it's
   return value checked.

Powerpc folks, if there are no objections please pull, thanks!

The following changes since commit 96b5a46e2a72dc1829370c87053e0cd558d58bc0:
  Linus Torvalds (1):
        WMI: initialize wmi_blocks.list even if ACPI is disabled

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/lmb-2.6.git master

David S. Miller (2):
      [LIB]: Make PowerPC LMB code generic so sparc64 can use it too.
      [LMB]: Fix bug in __lmb_alloc_base().

 arch/powerpc/Kconfig                    |    3 +
 arch/powerpc/kernel/btext.c             |    2 +-
 arch/powerpc/kernel/crash.c             |    2 +-
 arch/powerpc/kernel/crash_dump.c        |    2 +-
 arch/powerpc/kernel/machine_kexec.c     |    2 +-
 arch/powerpc/kernel/prom.c              |    2 +-
 arch/powerpc/kernel/rtas.c              |    2 +-
 arch/powerpc/kernel/setup-common.c      |    2 +-
 arch/powerpc/kernel/setup_64.c          |    2 +-
 arch/powerpc/kernel/vdso.c              |    2 +-
 arch/powerpc/mm/Makefile                |    2 +-
 arch/powerpc/mm/hash_utils_64.c         |    2 +-
 arch/powerpc/mm/init_32.c               |    2 +-
 arch/powerpc/mm/init_64.c               |    2 +-
 arch/powerpc/mm/mem.c                   |    2 +-
 arch/powerpc/mm/numa.c                  |    2 +-
 arch/powerpc/mm/ppc_mmu_32.c            |    2 +-
 arch/powerpc/mm/stab.c                  |    2 +-
 arch/powerpc/platforms/cell/iommu.c     |    2 +-
 arch/powerpc/platforms/maple/setup.c    |    2 +-
 arch/powerpc/platforms/powermac/setup.c |    2 +-
 arch/powerpc/platforms/ps3/htab.c       |    2 +-
 arch/powerpc/platforms/ps3/mm.c         |    2 +-
 arch/powerpc/platforms/ps3/os-area.c    |    2 +-
 arch/powerpc/sysdev/dart_iommu.c        |    2 +-
 arch/sparc64/Kconfig                    |    3 +
 include/asm-powerpc/abs_addr.h          |    2 +-
 include/asm-powerpc/lmb.h               |   82 +++---------------------------
 include/asm-sparc64/lmb.h               |   10 ++++
 include/linux/lmb.h                     |   83 +++++++++++++++++++++++++++++++
 lib/Makefile                            |    2 +
 {arch/powerpc/mm => lib}/lmb.c          |   39 ++++++++-------
 32 files changed, 155 insertions(+), 117 deletions(-)
 create mode 100644 include/asm-sparc64/lmb.h
 create mode 100644 include/linux/lmb.h
 rename {arch/powerpc/mm => lib}/lmb.c (92%)
