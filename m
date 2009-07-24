Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZGXD1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZGXD1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZGXD1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:27:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:45087 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbZGXD1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:27:18 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linuxppc-dev@lists.ozlabs.org
Cc: beckyb@kernel.crashing.org, galak@kernel.crashing.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/5] powerpc: use asm-generic/dma-mapping-common.h
Date: Fri, 24 Jul 2009 12:24:10 +0900
Message-Id: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 24 Jul 2009 12:27:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts POWERPC to use asm-generic/dma-mapping-common.h.

The major change is removing addr_needs_map in struct dma_mapping_ops
(1/5):

http://marc.info/?t=124719060200001&r=1&w=2

This is on the top of my swiotlb cleanup patchset:

http://marc.info/?l=linuxppc-embedded&m=124718920320951&w=2

The patchset also is available via a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git powerpc


=
 arch/powerpc/Kconfig                       |    2 +-
 arch/powerpc/include/asm/device.h          |    7 +-
 arch/powerpc/include/asm/dma-mapping.h     |  308 ++--------------------------
 arch/powerpc/include/asm/pci.h             |    4 +-
 arch/powerpc/include/asm/swiotlb.h         |    8 +-
 arch/powerpc/kernel/dma-iommu.c            |    2 +-
 arch/powerpc/kernel/dma-swiotlb.c          |   50 ++---
 arch/powerpc/kernel/dma.c                  |    2 +-
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
 18 files changed, 63 insertions(+), 349 deletions(-)



