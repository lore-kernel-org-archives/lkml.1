Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbZEMDQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbZEMDQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbZEMDGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:30 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36236
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756086AbZEMDGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:13 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [GIT PULL] xen dom0 PCI access
Date: Tue, 12 May 2009 14:48:01 -0700
Message-Id: <1242164891-3859-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is an updated version of the Xen dom0 PCI access changes with:
 - various comments resolved
 - acked/reviewed-by tags added
 - misc cleanups in patch structure

Ingo, if this is satisfactory with everyone, please pull into
tip/x86/xen/dom0/pci.

(I'll mail the swiotlb changes separately, but they're really part of
the same branch.)

Thanks,
	J

The following changes since commit ce791368bb4a53d05e78e1588bac0aacde8db84c:
  Jeremy Fitzhardinge (1):
        xen/i386: make sure initial VGA/ISA mappings are not overridden

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git for-ingo/xen/dom0/pci

Alex Nixon (7):
      xen: Don't disable the I/O space
      xen: Allow unprivileged Xen domains to create iomap pages
      Xen: Rename the balloon lock
      xen: Add xen_create_contiguous_region
      x86/PCI: Clean up pci_cache_line_size
      x86/PCI: Enable scanning of all pci functions
      Xen/x86/PCI: Add support for the Xen PCI subsystem

Jeremy Fitzhardinge (3):
      x86/pci: make sure _PAGE_IOMAP it set on pci mappings
      xen/pci: clean up Kconfig a bit
      xen: define BIOVEC_PHYS_MERGEABLE()

 arch/x86/Kconfig                 |    4 +
 arch/x86/include/asm/io.h        |   15 ++
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
 arch/x86/xen/mmu.c               |  225 +++++++++++++++++++++++++++++++-
 arch/x86/xen/setup.c             |    3 -
 drivers/pci/Makefile             |    2 +
 drivers/pci/xen-iommu.c          |  271 ++++++++++++++++++++++++++++++++++++++
 drivers/xen/Makefile             |    2 +-
 drivers/xen/balloon.c            |   15 +--
 drivers/xen/biomerge.c           |   14 ++
 include/xen/interface/memory.h   |   50 +++++++
 include/xen/xen-ops.h            |    6 +
 22 files changed, 691 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/iommu.h
 create mode 100644 arch/x86/pci/xen.c
 create mode 100644 drivers/pci/xen-iommu.c
 create mode 100644 drivers/xen/biomerge.c

