Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZJZX3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZJZX3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZJZX3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:29:00 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:34623 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZJZX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:28:59 -0400
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH 0/5] intel-iommu fixes
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 26 Oct 2009 17:24:53 -0600
Message-ID: <20091026232401.9646.90540.stgit@nehalem.aw>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements several fixes for intel-iommu.  The first
is to make use of the device coherent_dma_mask when allocating
coherent DMA buffers, for which we move dma_generic_alloc_coherent
out of the x86 code so we can use it by both of the current users
of intel-iommu.  Next, we add a little more to detecting when a
device can't support passthrough mode.  Then we reinstate RMRRs
for devices that get kicked out of passthrough mode.  And finally,
a trivial printk change to be less verbose on boot.

Ideally I'd like to entertain the idea of getting these into 2.6.32
because the coherent mapping issue is actually a regression since
2.6.31 and will cause some devices to fail to initialize in passthrough
mode (cciss for one).  Thanks,

Alex

---

Alex Williamson (5):
      intel-iommu: Quiet unnecessary output
      intel-iommu: Reinstate RMRRs if a device is removed from passthrough domain
      intel-iommu: Use max_pfn to determine whether a device can passthrough
      intel-iommu: Use dma_generic_alloc_coherent() for passthrough mappings
      dma: create dma_generic_alloc/free_coherent()


 arch/x86/include/asm/dma-mapping.h |    3 --
 arch/x86/kernel/pci-dma.c          |   31 --------------------
 arch/x86/kernel/pci-nommu.c        |   10 +++++--
 drivers/pci/intel-iommu.c          |   55 +++++++++++++++++++++++++++++++++---
 include/linux/dma-mapping.h        |   44 +++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+), 41 deletions(-)

