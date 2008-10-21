Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYJUTPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYJUTPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYJUTOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:14:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYJUTOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:14:51 -0400
Subject: [GIT *] iommu fixes for 2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
Content-Type: text/plain
Date: Tue, 21 Oct 2008 20:14:24 +0100
Message-Id: <1224616464.16910.103.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from git://git.infradead.org/iommu-2.6.git

This contains a few iommu-related fixes -- it restores DMA remapping on
newer Intel hardware, which was disabled by the interrupt remapping
patches, adds IA64 support for the Intel IOMMU, and some other small
fixes.

 MAINTAINERS                      |    7 +
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 arch/x86/kernel/pci-dma.c        |   16 ---
 drivers/pci/dmar.c               |  119 +++++++++++++-----
 drivers/pci/intel-iommu.c        |  250 ++++++++++++++++++++------------------
 drivers/pci/quirks.c             |   14 ++
 include/asm-x86/iommu.h          |    4 +
 include/linux/dma_remapping.h    |   27 ++--
 include/linux/intel-iommu.h      |   66 ++++++++---
 9 files changed, 305 insertions(+), 200 deletions(-)

Andreas Herrmann (1):
      amd_iommu: fix nasty bug that caused ILLEGAL_DEVICE_TABLE_ENTRY errors

David Woodhouse (4):
      dmar: fix uninitialised 'ret' variable in dmar_parse_dev()
      Admit to maintaining VT-d, for my sins.
      Merge branch 'master' of master.kernel.org:/.../torvalds/linux-2.6
      Merge branch 'master' of master.kernel.org:/.../torvalds/linux-2.6

FUJITA Tomonori (1):
      intel-iommu: use coherent_dma_mask in alloc_coherent

Fenghua Yu (1):
      intel-iommu: IA64 support

Suresh Siddha (1):
      dmar: use spin_lock_irqsave() in qi_submit_sync()

Youquan Song (3):
      dmar: context cache and IOTLB invalidation using queued invalidation
      dmar: Use queued invalidation interface for IOTLB and context invalidation
      dmar: remove the quirk which disables dma-remapping when intr-remapping enabled

-- 
dwmw2

