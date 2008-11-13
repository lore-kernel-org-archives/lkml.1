Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYKMTje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYKMTje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYKMTeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:17 -0500
Received: from gw.goop.org ([64.81.55.164]:34391 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYKMTeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:07 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 17 of 38] x86: add swiotlb allocation functions
X-Mercurial-Node: c171d938f6ca950ab8ef0f9fb032f2f56750fd3a
Message-Id: <c171d938f6ca950ab8ef.1226603415@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add x86-specific swiotlb allocation functions.  These are purely
default for the moment.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -3,6 +3,8 @@
 #include <linux/pci.h>
 #include <linux/cache.h>
 #include <linux/module.h>
+#include <linux/swiotlb.h>
+#include <linux/bootmem.h>
 #include <linux/dma-mapping.h>
 
 #include <asm/iommu.h>
@@ -11,6 +13,16 @@
 
 int swiotlb __read_mostly;
 
+void *swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	return alloc_bootmem_low_pages(size);
+}
+
+void *swiotlb_alloc(unsigned order, unsigned long nslabs)
+{
+	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+}
+
 static dma_addr_t
 swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 			int direction)


