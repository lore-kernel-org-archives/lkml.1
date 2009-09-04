Return-Path: <linux-kernel-owner+w=401wt.eu-S933457AbZIDJmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbZIDJmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933352AbZIDJmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:00 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:36915
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933340AbZIDJl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:41:57 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXLN-04-HX2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/14] Page table handling updates for AMD-IOMMU (AMD-Vi)
Date: Fri, 4 Sep 2009 11:40:38 +0200
Message-ID: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0205 (UTC) FILETIME=[CC97F550:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series of patches enhance the page table handling code for
AMD-IOMMU (AMD-Vi). With these patches the page table handling code is
able to map a full 64 bit device address space. The old limit was a 39
bit address space.
This series also contains initial patches for upcoming large page
support in the AMD-Vi driver. Full large page support requires changes
to the IOMMU-API which are not part of this patch set.

Joerg

Diffstat:


 arch/x86/include/asm/amd_iommu_types.h |   38 +++---
 arch/x86/kernel/amd_iommu.c            |  242 ++++++++++++++++++++------------
 2 files changed, 170 insertions(+), 110 deletions(-)

Shortlog:

Joerg Roedel (14):
      x86/amd-iommu: Make fetch_pte aware of dynamic mapping levels
      x86/amd-iommu: Use fetch_pte in iommu_unmap_page
      x86/amd-iommu: Use fetch_pte in amd_iommu_iova_to_phys
      x86/amd-iommu: Add a gneric version of amd_iommu_flush_all_devices
      x86/amd-iommu: Introduce set_dte_entry function
      x86/amd-iommu: Flush domains if address space size was increased
      x86/amd-iommu: Introduce increase_address_space function
      x86/amd-iommu: Change alloc_pte to support 64 bit address space
      x86/amd-iommu: Remove last usages of IOMMU_PTE_L0_INDEX
      x86/amd-iommu: Remove bus_addr check in iommu_map_page
      x86/amd-iommu: Use 2-level page tables for dma_ops domains
      x86/amd-iommu: Remove old page table handling macros
      x86/amd-iommu: Support higher level PTEs in iommu_page_unmap
      x86/amd-iommu: Change iommu_map_page to support multiple page sizes


