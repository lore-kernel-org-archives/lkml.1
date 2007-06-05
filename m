Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbXFEVAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbXFEVAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765282AbXFEVAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:00:41 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58954 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbXFEVAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:00:40 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 5 Jun 2007 16:58:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] lib:  Replace calls to __get_free_pages() with __get_dma_pages().
Message-ID: <Pine.LNX.4.64.0706051657350.20029@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replace a couple calls to __get_free_pages() with the corresponding
calls to __get_dma_pages().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  that's the lot of them.

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 10c13ad..8fc38dc 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -201,8 +201,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;

 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
-		                                        order);
+		io_tlb_start = (char *)__get_dma_pages(__GFP_NOWARN, order);
 		if (io_tlb_start)
 			break;
 		order--;
@@ -244,7 +243,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
+	io_tlb_overflow_buffer = (void *)__get_dma_pages(0,
 	                                          get_order(io_tlb_overflow));
 	if (!io_tlb_overflow_buffer)
 		goto cleanup4;
@@ -449,9 +448,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	 * instead, or use ZONE_DMA32 (ia64 overloads ZONE_DMA to be a ~32
 	 * bit range instead of a 16MB one).
 	 */
-	flags |= GFP_DMA;

-	ret = (void *)__get_free_pages(flags, order);
+	ret = (void *)__get_dma_pages(flags, order);
 	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
 		/*
 		 * The allocated memory isn't reachable by the device.
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
