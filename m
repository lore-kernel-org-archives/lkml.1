Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0BKOdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:33:38 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:26055
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751726Ab0BKOdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:33:36 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXOLRN-02-7LK-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] amd iommu smart tlb flushing
Date: Thu, 11 Feb 2010 15:33:10 +0100
Message-ID: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 11 Feb 2010 14:33:21.0478 (UTC) FILETIME=[2914BE60:01CAAB27]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset implements a smarter io-tlb flushing strategy for the AMD IOMMU
driver. The old behavior was to flush only a single 4kb entry or the whole
domain io-tlb. This patchset implements book keeping about the ranges of PTEs
changed in the page table and flushes only that ranges when the flush is
actually done.

	Joerg

Joerg Roedel (7):
      x86/amd-iommu: Add flush_info to protection domains
      x86/amd-iommu: Introduce iommu_update_domain_tlb function
      x86/amd-iommu: Move dte udpate flag into flush_info structure
      x86/amd-iommu: Move functions to get rid of forward declarations
      x86/amd-iommu: Add function to commit domain changes
      x86/amd-iommu: Introduce iommu_update_dma_ops_domain()
      x86/amd-iommu: Reimplement iommu_flush_tlb_pde using iommu_update_domain_tlb

 arch/x86/include/asm/amd_iommu_types.h |   13 ++-
 arch/x86/kernel/amd_iommu.c            |  225 ++++++++++++++++----------------
 2 files changed, 124 insertions(+), 114 deletions(-)


