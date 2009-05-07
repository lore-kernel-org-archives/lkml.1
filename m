Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbZEHA3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbZEHA3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759657AbZEHAKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:49 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52719
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756757AbZEHAKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:03 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen: dom0 support for PCI access
Date: Thu,  7 May 2009 14:45:26 -0700
Message-Id: <1241732737-7669-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This branch allows a Xen dom0 kernel to access PCI devices properly.  Mostly
this involves making sure that memory being used for DMA is both
logically contigious in the kernel's pseudo-physical memory and physically
contigious in machine memory.

Again, this is pretty much unchanged from the last time I posted it.

The following changes since commit 0c96e43850feb7c7c4a4950f24533491fbd63b5a:
  Jeremy Fitzhardinge (1):
        xen: checkpatch cleanups

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-tip/dom0/pci

Alex Nixon (7):
      xen: Don't disable the I/O space
      xen: Allow unprivileged Xen domains to create iomap pages
      Xen: Rename the balloon lock
      xen: Add xen_create_contiguous_region
      x86/PCI: Clean up pci_cache_line_size
      x86/PCI: Enable scanning of all pci functions
      Xen/x86/PCI: Add support for the Xen PCI subsytem

Jeremy Fitzhardinge (4):
      xen/swiotlb: use dma_alloc_from_coherent to get device coherent memory
      x86/pci: make sure _PAGE_IOMAP it set on pci mappings
      xen/pci: clean up Kconfig a bit
      xen: checkpatch cleanups

 arch/x86/Kconfig                 |    4 +
 arch/x86/include/asm/io.h        |    2 +
 arch/x86/include/asm/pci.h       |    8 +-
 arch/x86/include/asm/pci_x86.h   |    2 +
 arch/x86/include/asm/xen/iommu.h |   12 ++
 arch/x86/kernel/pci-dma.c        |    3 +
 arch/x86/pci/Makefile            |    1 +
 arch/x86/pci/common.c            |   18 ++-
 arch/x86/pci/i386.c              |    3 +
 arch/x86/pci/init.c              |    6 +
 arch/x86/pci/xen.c               |   51 +++++++
 arch/x86/xen/Kconfig             |    2 +
 arch/x86/xen/enlighten.c         |    6 +-
 arch/x86/xen/mmu.c               |  225 ++++++++++++++++++++++++++++++-
 arch/x86/xen/setup.c             |    3 -
 drivers/pci/Makefile             |    2 +
 drivers/pci/xen-iommu.c          |  279 ++++++++++++++++++++++++++++++++++++++
 drivers/xen/balloon.c            |   15 +--
 include/xen/interface/memory.h   |   50 +++++++
 include/xen/xen-ops.h            |    6 +
 20 files changed, 671 insertions(+), 27 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/iommu.h
 create mode 100644 arch/x86/pci/xen.c
 create mode 100644 drivers/pci/xen-iommu.c

Thanks,
	J
