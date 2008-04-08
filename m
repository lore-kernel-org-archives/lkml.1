Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbYDHQcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbYDHQcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbYDHQ2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758815AbYDHQ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:45 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 18/28] x86: move bad_dma_address
Date: Tue,  8 Apr 2008 13:21:00 -0300
Message-Id: <1207671790886-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It goes to pci-dma.c, and is removed from the arch-specific files.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma.c    |    2 ++
 arch/x86/kernel/pci-dma_32.c |    4 ----
 arch/x86/kernel/pci-dma_64.c |    2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index d06d8df..d6734ed 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -35,6 +35,8 @@ int iommu_detected __read_mostly = 0;
 int iommu_bio_merge __read_mostly = 0;
 EXPORT_SYMBOL(iommu_bio_merge);
 
+dma_addr_t bad_dma_address __read_mostly = 0;
+EXPORT_SYMBOL(bad_dma_address);
 
 int dma_set_mask(struct device *dev, u64 mask)
 {
diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 49166a4..5ae3470 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -14,10 +14,6 @@
 #include <linux/module.h>
 #include <asm/io.h>
 
-/* For i386, we make it point to the NULL address */
-dma_addr_t bad_dma_address __read_mostly = 0x0;
-EXPORT_SYMBOL(bad_dma_address);
-
 static int dma_alloc_from_coherent_mem(struct device *dev, ssize_t size,
 				       dma_addr_t *dma_handle, void **ret)
 {
diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 6eacd58..5f03e41 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -14,8 +14,6 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 
-dma_addr_t bad_dma_address __read_mostly;
-EXPORT_SYMBOL(bad_dma_address);
 
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
-- 
1.5.0.6

