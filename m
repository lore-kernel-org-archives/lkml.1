Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYKTTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYKTTua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYKTTuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:50:22 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:10893 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYKTTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:50:21 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KANDR3-03-47M-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH] x86: always define DECLARE_PCI_UNMAP* macros
Date: Thu, 20 Nov 2008 20:49:56 +0100
Message-ID: <1227210596-1196-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 20 Nov 2008 19:49:56.0417 (UTC) FILETIME=[29E26B10:01C94B49]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently these macros evaluate to a no-op except the kernel is compiled
with GART or Calgary support. But we also need these macros when we have
SWIOTLB, VT-d or AMD IOMMU in the kernel. Since we always compile at
least with SWIOTLB we can define these macros always.
This patch is also for stable backport for the same reason the SWIOTLB
default selection patch is.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/pci_64.h |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/pci_64.h b/arch/x86/include/asm/pci_64.h
index 5b28995..d02d936 100644
--- a/arch/x86/include/asm/pci_64.h
+++ b/arch/x86/include/asm/pci_64.h
@@ -34,8 +34,6 @@ extern void pci_iommu_alloc(void);
  */
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_GART_IOMMU) || defined(CONFIG_CALGARY_IOMMU)
-
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
 #define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
@@ -49,18 +47,6 @@ extern void pci_iommu_alloc(void);
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
 	(((PTR)->LEN_NAME) = (VAL))
 
-#else
-/* No IOMMU */
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
-
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PCI_64_H */
-- 
1.5.6.4


