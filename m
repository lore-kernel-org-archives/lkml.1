Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbZKJKuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbZKJKuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZKJKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:50:04 -0500
Received: from sh.osrg.net ([192.16.179.4]:33794 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbZKJKuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:50:01 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH v2 0/9] x86: handle HW IOMMU initialization failure gracefully
Date: Tue, 10 Nov 2009 19:46:11 +0900
Message-Id: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 10 Nov 2009 19:49:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is against tip/master.

The first version is:

http://marc.info/?l=linux-kernel&m=125671300920411&w=2

The changes since v1 are:

- replaced Chris' bootmem patches with the 6/9 patch to implement
  free_bootmem_late in a simple way (thanks to Pekka).

- fixed the bug to break 'iommu=soft' boot opiton (found by Joerg).

- moved iommu_init_noop() to x86_init.c

- added Muli's Acked-by to Calgary patch.


==
 arch/ia64/kernel/pci-swiotlb.c   |    4 +-
 arch/powerpc/kernel/setup_32.c   |    2 +-
 arch/powerpc/kernel/setup_64.c   |    2 +-
 arch/x86/include/asm/amd_iommu.h |    2 -
 arch/x86/include/asm/calgary.h   |    2 -
 arch/x86/include/asm/gart.h      |    5 +---
 arch/x86/include/asm/iommu.h     |    1 -
 arch/x86/include/asm/x86_init.h  |    9 +++++++
 arch/x86/kernel/amd_iommu.c      |    2 +-
 arch/x86/kernel/amd_iommu_init.c |   19 +++-----------
 arch/x86/kernel/aperture_64.c    |    4 ++-
 arch/x86/kernel/pci-calgary_64.c |   19 ++++-----------
 arch/x86/kernel/pci-dma.c        |   27 ++++++++++-----------
 arch/x86/kernel/pci-gart_64.c    |   16 ++++-------
 arch/x86/kernel/pci-nommu.c      |    9 -------
 arch/x86/kernel/pci-swiotlb.c    |   10 +++----
 arch/x86/kernel/x86_init.c       |    5 ++++
 drivers/pci/dmar.c               |    7 ++++-
 drivers/pci/intel-iommu.c        |    4 +-
 include/linux/bootmem.h          |    1 +
 include/linux/dmar.h             |   10 -------
 include/linux/swiotlb.h          |    5 ++-
 lib/swiotlb.c                    |   49 +++++++++++++++++++++++++++++++------
 mm/bootmem.c                     |   24 ++++++++++++++++++
 24 files changed, 131 insertions(+), 107 deletions(-)


