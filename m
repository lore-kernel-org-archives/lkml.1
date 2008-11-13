Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYKMTli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYKMTli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYKMTeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:22 -0500
Received: from gw.goop.org ([64.81.55.164]:34414 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbYKMTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:09 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 19 of 38] x86: add arch specific version of the swiotlb
	virt<->bus<->virt functions
X-Mercurial-Node: 8405f18a95e67aa16fe1ed4436b99f247f19aa30
Message-Id: <8405f18a95e67aa16fe1.1226603417@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

These are to be used later and contain the default implementation.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -23,6 +23,16 @@
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
+unsigned long swiotlb_virt_to_bus(volatile void *address)
+{
+	return virt_to_bus(address);
+}
+
+void * swiotlb_bus_to_virt(unsigned long address)
+{
+	return bus_to_virt(address);
+}
+
 static dma_addr_t
 swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 			int direction)


