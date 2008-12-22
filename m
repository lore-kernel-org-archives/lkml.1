Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYLVSbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYLVSbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYLVS24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:56 -0500
Received: from gw.goop.org ([64.81.55.164]:44727 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753041AbYLVS2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:55 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 9] swiotlb: Rename SG_ENT_PHYS_ADDRESS to
	SG_ENT_BUS_ADDRESS
X-Mercurial-Node: c1bf3fa00ed0792831618ba879fb37e067255b40
Message-Id: <c1bf3fa00ed079283161.1229970367@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

Also add hwdev argument - some platforms will need this to
calculate an actual bus address.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -38,7 +38,7 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(sg_virt(sg))
+#define SG_ENT_BUS_ADDRESS(hwdev, sg)	swiotlb_virt_to_bus(hwdev, sg_virt(sg))
 
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
@@ -811,7 +811,7 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
+		if (sg->dma_address != SG_ENT_BUS_ADDRESS(hwdev, sg))
 			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
@@ -844,7 +844,7 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
+		if (sg->dma_address != SG_ENT_BUS_ADDRESS(hwdev, sg))
 			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)


