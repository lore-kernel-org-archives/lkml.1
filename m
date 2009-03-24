Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZCXRoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZCXRoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZCXRn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:43:56 -0400
Received: from gw.goop.org ([64.81.55.164]:39001 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZCXRnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:43:55 -0400
Message-ID: <49C91BD8.4030304@goop.org>
Date: Tue, 24 Mar 2009 10:43:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: [GIT PULL] xen.git 2.6.30: xen dom0 PCI device support
References: <49C915A3.3020809@goop.org>
In-Reply-To: <49C915A3.3020809@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6b36d6251e178636a3c032611948a5c7af44582e:
  Jeremy Fitzhardinge (1):
        x86: don't need "changed" parameter for set_io_bitmap()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/xen/dom0/pci

Alex Nixon (7):
      xen: Don't disable the I/O space
      xen: Allow unprivileged Xen domains to create iomap pages
      Xen: Rename the balloon lock
      xen: Add xen_create_contiguous_region
      x86/PCI: Clean up pci_cache_line_size
      x86/PCI: Enable scanning of all pci functions
      Xen/x86/PCI: Add support for the Xen PCI subsytem

Ian Campbell (4):
      xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER
      xen: add hooks for mapping phys<->bus addresses in swiotlb
      xen/swiotlb: add hook for swiotlb_arch_range_needs_mapping
      xen: enable swiotlb for xen domain 0.

Jeremy Fitzhardinge (7):
      x86/pci: make sure _PAGE_IOMAP it set on pci mappings
      xen/pci: clean up Kconfig a bit
      xen: make sure swiotlb allocation is physically contigious
      xen/swiotlb: use dma_alloc_from_coherent to get device coherent memory
      swiotlb: use swiotlb_alloc_boot to allocate emergency pool
      xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
      xen/swiotlb: add sync functions

 arch/x86/Kconfig                 |    4 +
 arch/x86/include/asm/pci.h       |    8 +-
 arch/x86/include/asm/pci_x86.h   |    2 +
 arch/x86/include/asm/xen/iommu.h |   12 ++
 arch/x86/kernel/pci-dma.c        |    4 +-
 arch/x86/kernel/pci-swiotlb.c    |   28 +++-
 arch/x86/pci/Makefile            |    1 +
 arch/x86/pci/common.c            |   18 ++-
 arch/x86/pci/i386.c              |    3 +
 arch/x86/pci/init.c              |    6 +
 arch/x86/pci/xen.c               |   52 ++++++
 arch/x86/xen/Kconfig             |    3 +
 arch/x86/xen/enlighten.c         |    6 +-
 arch/x86/xen/mmu.c               |  225 +++++++++++++++++++++++++-
 arch/x86/xen/setup.c             |    3 -
 drivers/pci/Makefile             |    2 +
 drivers/pci/xen-iommu.c          |  331 ++++++++++++++++++++++++++++++++++++++
 drivers/xen/balloon.c            |   15 +--
 include/xen/interface/memory.h   |   50 ++++++
 include/xen/swiotlb.h            |   19 +++
 include/xen/xen-ops.h            |    6 +
 lib/swiotlb.c                    |    3 +-
 22 files changed, 770 insertions(+), 31 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/iommu.h
 create mode 100644 arch/x86/pci/xen.c
 create mode 100644 drivers/pci/xen-iommu.c
 create mode 100644 include/xen/swiotlb.h


