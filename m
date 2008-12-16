Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbYLPUXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbYLPUXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbYLPUSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:54 -0500
Received: from gw.goop.org ([64.81.55.164]:45941 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbYLPUSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 13 of 14] x86/swiotlb: add default phys<->bus conversion
X-Mercurial-Node: 187360c1deb35224f86029e9cae9655133fd8d44
Message-Id: <187360c1deb35224f860.1229458657@abulafia.goop.org>
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jan Beulich <jbeulich@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Xen will override these later on.

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
 
+dma_addr_t swiotlb_phys_to_bus(phys_addr_t paddr)
+{
+	return paddr;
+}
+
+phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
+{
+	return baddr;
+}
+
 static dma_addr_t
 swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 			int direction)


