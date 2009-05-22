Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZEVMXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZEVMXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbZEVMWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21596 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbZEVMWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:16 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KK1P0R-02-JFU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/12] extended allocator for amd iommu
Date: Fri, 22 May 2009 14:21:21 +0200
Message-ID: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 22 May 2009 12:21:32.0705 (UTC) FILETIME=[D79E0110:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset changes the allocator for dma addresses in the AMD IOMMU
driver for Linux to support a dynamic size. This patchset extends the
default size for the dma_ops aperture to 128MB per default with
pre-allocated page tables. If the address space is too small it will be
extended dynamically by another 128MB, this time without preallocating
the page tables. This way the aperture can grow up to 4GB. It is
designed to be easily extendable to even larger dma_ops apertures.
The code also introduces three changes to enable stress testing of this
code with CONFIG_IOMMU_STRESS. Please review.

diffstat:

 Documentation/kernel-parameters.txt    |    5 -
 arch/x86/include/asm/amd_iommu_types.h |   41 +++-
 arch/x86/kernel/amd_iommu.c            |  439 +++++++++++++++++++++++---------
 arch/x86/kernel/amd_iommu_init.c       |   15 -
 4 files changed, 352 insertions(+), 148 deletions(-)

shortlog:

Joerg Roedel (12):
      amd-iommu: introduce aperture_range structure
      amd-iommu: move page table allocation code to seperate function
      amd-iommu: handle page table allocation failures in dma_ops code
      amd-iommu: make address allocator aware of multiple aperture ranges
      amd-iommu: change dma_dom->next_bit to dma_dom->next_address
      amd-iommu: move aperture_range allocation code to seperate function
      amd-iommu: handle exlusion ranges and unity mappings in alloc_new_range
      amd-iommu: enlarge the aperture dynamically
      amd-iommu: remove amd_iommu_size kernel parameter
      amd-iommu: disable round-robin allocator for CONFIG_IOMMU_STRESS
      amd-iommu: don't preallocate page tables with CONFIG_IOMMU_STRESS
      amd-iommu: don't free dma adresses below 512MB with CONFIG_IOMMU_STRESS


