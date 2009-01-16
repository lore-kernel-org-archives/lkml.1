Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbZAPIht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbZAPIht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZAPIhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:37:32 -0500
Received: from smtp.nokia.com ([192.100.105.134]:29305 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZAPIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:37:31 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 0/6] arm: omap iommu: add initial support
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:37:04 +0200
Message-ID: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:37:05.0995 (UTC) FILETIME=[9CC8A1B0:01C977B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add initial support of omap iommu.

Some of TI OMAP series have the peripheral devices with their own
MMU(iommu), which is composed of its own tlb and optional h/w
pagetable(twl). These MMUs don't depend on mpu(arm) mmu at all, but
their algorithms are somewhat similar and they share the same physical
address space. This patch provides with common in-kernel iommu APIs
such OMAP peripheral devices(Camera ISP, IVA1, IVA2, DSP and the
equivalent ones in the latest OMAP successors) to handle peripheral
device iommus in the same manner.

---

Hiroshi DOYU (6):
      omap2 iommu: entries for Kconfig and Makefile
      omap iommu: entries for Kconfig and Makefile
      omap iommu: simple virtual address space management
      omap iommu: omap3 iommu device registration
      omap iommu: omap2 architecture specific functions
      omap iommu: tlb and pagetable primitives


 arch/arm/include/asm/io.h                |    6 
 arch/arm/mach-omap2/Makefile             |    5 
 arch/arm/mach-omap2/iommu2.c             |  325 +++++++++++
 arch/arm/mach-omap2/omap3-iommu.c        |  111 ++++
 arch/arm/mm/ioremap.c                    |   11 
 arch/arm/plat-omap/Kconfig               |    8 
 arch/arm/plat-omap/Makefile              |    1 
 arch/arm/plat-omap/include/mach/iommu.h  |  157 +++++
 arch/arm/plat-omap/include/mach/iommu2.h |   94 +++
 arch/arm/plat-omap/include/mach/iovmm.h  |   94 +++
 arch/arm/plat-omap/iommu.c               |  913 ++++++++++++++++++++++++++++++
 arch/arm/plat-omap/iopgtable.h           |   72 ++
 arch/arm/plat-omap/iovmm.c               |  892 +++++++++++++++++++++++++++++
 13 files changed, 2689 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/iommu2.c
 create mode 100644 arch/arm/mach-omap2/omap3-iommu.c
 create mode 100644 arch/arm/plat-omap/include/mach/iommu.h
 create mode 100644 arch/arm/plat-omap/include/mach/iommu2.h
 create mode 100644 arch/arm/plat-omap/include/mach/iovmm.h
 create mode 100644 arch/arm/plat-omap/iommu.c
 create mode 100644 arch/arm/plat-omap/iopgtable.h
 create mode 100644 arch/arm/plat-omap/iovmm.c

-- 
   Hiroshi DOYU
