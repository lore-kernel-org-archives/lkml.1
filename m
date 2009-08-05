Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZHEFL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZHEFL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZHEFKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:10:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:38945 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbZHEFKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:10:11 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Cc: galak@kernel.crashing.orga, beckyb@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
Date: Wed,  5 Aug 2009 14:08:21 +0900
Message-Id: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 05 Aug 2009 14:09:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version of the patchset to convert POWERPC to use
asm-generic/dma-mapping-common.h:

http://marc.info/?l=linux-kernel&m=124840628128189&w=2

There are some minor changes since the first version are:

- removed unused CONFIG_PPC_NEED_DMA_SYNC_OPS [5/7] (Becky pointed
  out).

- added Becky's Acked-by

- added two new patches ([6/7] and [7/7]). [6/7] fixes SWIOTLB's
  dma_mapping_error(). [7/7] addes CONFIG_DMA_API_DEBUG support.


This is on the top of my swiotlb cleanup patchset:

http://marc.info/?l=linuxppc-embedded&m=124718920320951&w=2


The above swiotlb patchset was merged in -tip so I think that merging
this patchset via -tip too is the easiest way to handle this patchset.

The patchset also is available via a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git powerpc


=
 arch/powerpc/Kconfig                       |    7 +-
 arch/powerpc/include/asm/device.h          |    7 +-
 arch/powerpc/include/asm/dma-mapping.h     |  318 +++-------------------------
 arch/powerpc/include/asm/pci.h             |    4 +-
 arch/powerpc/include/asm/swiotlb.h         |    8 +-
 arch/powerpc/kernel/dma-iommu.c            |    2 +-
 arch/powerpc/kernel/dma-swiotlb.c          |   53 ++---
 arch/powerpc/kernel/dma.c                  |   13 +-
 arch/powerpc/kernel/ibmebus.c              |    2 +-
 arch/powerpc/kernel/pci-common.c           |    6 +-
 arch/powerpc/kernel/vio.c                  |    2 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c   |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c   |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    3 +-
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    3 +-
 arch/powerpc/platforms/cell/iommu.c        |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c    |    4 +-
 include/linux/dma-mapping.h                |    1 +
 18 files changed, 89 insertions(+), 352 deletions(-)









