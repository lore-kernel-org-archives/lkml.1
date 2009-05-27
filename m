Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbZE0HYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbZE0HYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbZE0HYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:24:43 -0400
Received: from claw.goop.org ([74.207.240.146]:33504 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760188AbZE0HYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:24:42 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [GIT PULL REPOST] xen/dom0/pci - Xen dom0 PCI access
Date: Wed, 27 May 2009 00:24:32 -0700
Message-Id: <1243409082-21349-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This is a repost of the Xen PCI access changes.  There are no differences
from the last repost, and no outstanding issues.

This branch adds the core pieces to allow PCI access and DMA to work,
including mapping of device memory into the Xen domain and rearranging
the guest kernel memory to be physically contiguous for DMA.

Please pull into tip.git as x86/xen/dom0/pci.

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
 include/asm-generic/pci.h        |    2 +
 include/xen/interface/memory.h   |   50 +++++++
 include/xen/xen-ops.h            |    6 +
 23 files changed, 693 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/iommu.h
 create mode 100644 arch/x86/pci/xen.c
 create mode 100644 drivers/pci/xen-iommu.c
 create mode 100644 drivers/xen/biomerge.c

