Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbZEHAh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbZEHAh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762584AbZEHAR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:17:26 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:48341
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932350AbZEHARW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:17:22 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen: swiotlb support for Xen dom0
Date: Thu,  7 May 2009 17:17:13 -0700
Message-Id: <1241741842-7966-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This branch adds the swiotlb hooks for Xen dom0.  We use swiotlb to handle
various device drivers which assume that multipage DMA transfers which are
contigious in kernel memory are also contigious in machine memory (mostly
lower-performance devices, as high-performance ones already do a good job
of scatter-gather).

Following Fujita's suggestion, these changes remove a lot of the
placeholder stubs in arch/x86/kernel/pci-swiotlb.c and moves them into
the Xen-specific arch/x86/xen/pci-swiotlb.c.  (It still relies on
overriding the weak functions defined in lib/swiotlb.c.)

The following changes since commit 2af252ab26150b4411889c9eaf1af4c5bf03de78:
  Jeremy Fitzhardinge (1):
        xen: checkpatch cleanups

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-tip/for-ingo/dom0/swiotlb

Ian Campbell (4):
      xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER
      xen: add hooks for mapping phys<->bus addresses in swiotlb
      xen/swiotlb: add swiotlb_arch_range_needs_mapping hook for xen
      xen: enable swiotlb for xen domain 0.

Jeremy Fitzhardinge (5):
      xen: make sure swiotlb allocation is physically contigious
      swiotlb: use swiotlb_alloc_boot to allocate emergency pool
      xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
      xen/swiotlb: add sync functions
      xen/swiotlb: update to new new dma_ops

 arch/x86/kernel/pci-swiotlb.c |   30 ++--------
 arch/x86/xen/Kconfig          |    1 +
 arch/x86/xen/Makefile         |    1 +
 arch/x86/xen/pci-swiotlb.c    |   53 ++++++++++++++++++
 drivers/pci/xen-iommu.c       |  123 +++++++++++++++++++++++++++++------------
 include/xen/swiotlb.h         |   18 ++++++
 lib/swiotlb.c                 |    3 +-
 7 files changed, 168 insertions(+), 61 deletions(-)
 create mode 100644 arch/x86/xen/pci-swiotlb.c
 create mode 100644 include/xen/swiotlb.h

Thanks,
	J
