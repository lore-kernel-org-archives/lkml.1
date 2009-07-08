Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbZGHG1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbZGHG1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZGHG13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:27:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:40300 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZGHG12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:27:28 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 16:26:44 +1000
Message-Id: <1247034404.6066.121.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a bunch of minor powerpc updates for 2.6.31. Mostly a few
more alloc_bootmem -> km/zalloc changes to avoid warnings at boot,
a bug or two, minor cosmetic stuffs, and some changes of a whole
bunch of pr_debug() into pr_devel() for low level stuff that really
doesn't want those built in normal kernels.

Cheers,
Ben.

The following changes since commit faf80d62e44dc627efb741f48db50c1858d1667c:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Anton Vorontsov (1):
      powerpc: Don't use alloc_bootmem() in init_IRQ() path

Benjamin Herrenschmidt (1):
      Merge commit 'jwb/merge' into merge

Grant Likely (1):
      powerpc: Fix spin_event_timeout() to be robust over context switches

Huang Weiyi (1):
      powerpc/perf_counter: Remove duplicated #include

Joe Perches (1):
      powerpc: Remove unnecessary semicolons

Josh Boyer (1):
      powerpc/44x: Fix build error with -Werror for Warp platform

Michael Ellerman (7):
      powerpc/pseries: Use pr_devel() in pseries LPAR HPTE routines
      powerpc/pseries: Use pr_devel() in xics.c
      powerpc: Use pr_devel() in arch/powerpc/mm/mmu_context_nohash.c
      powerpc: Cleanup & use pr_devel() in arch/powerpc/mm/slb.c
      powerpc: Use pr_devel() in arch/powerpc/mm/gup.c
      powerpc/cell: Use pr_devel() in axon_msi.c
      powerpc: Use pr_devel() in do_dcache_icache_coherency()

Sean MacLennan (2):
      powerpc/44x: Update Warp defconfig
      powerpc/4xx: Have Warp take advantage of GPIO LEDs default-state = keep

 arch/powerpc/boot/dts/warp.dts               |    3 +-
 arch/powerpc/configs/44x/warp_defconfig      |  200 ++++++++++++++++++++------
 arch/powerpc/include/asm/delay.h             |    2 +
 arch/powerpc/kernel/mpc7450-pmu.c            |    1 -
 arch/powerpc/kernel/ppc970-pmu.c             |    1 -
 arch/powerpc/mm/gup.c                        |   10 +-
 arch/powerpc/mm/mmu_context_nohash.c         |   16 +-
 arch/powerpc/mm/pgtable.c                    |    4 +-
 arch/powerpc/mm/slb.c                        |   13 +--
 arch/powerpc/mm/tlb_hash64.c                 |    2 +-
 arch/powerpc/oprofile/cell/vma_map.c         |    2 +-
 arch/powerpc/platforms/44x/warp.c            |   19 +--
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c |    2 +-
 arch/powerpc/platforms/cell/axon_msi.c       |   22 ++--
 arch/powerpc/platforms/powermac/cpufreq_64.c |    2 +-
 arch/powerpc/platforms/powermac/pic.c        |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c      |    1 -
 arch/powerpc/platforms/pseries/lpar.c        |   18 ++--
 arch/powerpc/platforms/pseries/xics.c        |    8 +-
 arch/powerpc/sysdev/fsl_rio.c                |    2 +-
 arch/powerpc/sysdev/ipic.c                   |    4 +-
 arch/powerpc/sysdev/mpic.c                   |    9 +-
 arch/powerpc/sysdev/ppc4xx_pci.c             |    4 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c           |    4 +-
 arch/powerpc/sysdev/uic.c                    |    3 +-
 25 files changed, 225 insertions(+), 129 deletions(-)


