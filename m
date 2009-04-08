Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbZDHPZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbZDHPZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZDHPZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:25:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:52357 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbZDHPZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:25:28 -0400
Date: Wed, 8 Apr 2009 15:24:31 GMT
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       galak@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
In-Reply-To: <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
Subject: [tip:core/iommu] swiotlb: comment corrections
Message-ID: <tip-ceb5ac3264686e75e6951de6a18d4baa9bdecb92@git.kernel.org>
Git-Commit-ID: ceb5ac3264686e75e6951de6a18d4baa9bdecb92
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 15:24:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ceb5ac3264686e75e6951de6a18d4baa9bdecb92
Gitweb:     http://git.kernel.org/tip/ceb5ac3264686e75e6951de6a18d4baa9bdecb92
Author:     Becky Bruce <beckyb@kernel.crashing.org>
AuthorDate: Wed, 8 Apr 2009 09:09:15 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 16:18:35 +0200

swiotlb: comment corrections

Impact: cleanup

swiotlb_map/unmap_single are now swiotlb_map/unmap_page;
trivially change all the comments to reference new names.

Also, there were some comments that should have been
referring to just plain old map_single, not swiotlb_map_single;
fix those as well.

Also change a use of the word "pointer", when what is
referred to is actually a dma/physical address.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: jeremy@goop.org
Cc: ian.campbell@citrix.com
LKML-Reference: <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/swiotlb.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 2b0b5a7..170cf56 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -60,8 +60,8 @@ enum dma_sync_target {
 int swiotlb_force;
 
 /*
- * Used to do a quick range check in swiotlb_unmap_single and
- * swiotlb_sync_single_*, to see if the memory was in fact allocated by this
+ * Used to do a quick range check in unmap_single and
+ * sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
 static char *io_tlb_start, *io_tlb_end;
@@ -560,7 +560,6 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 				   size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
-		 * Fall back on swiotlb_map_single().
 		 */
 		free_pages((unsigned long) ret, order);
 		ret = NULL;
@@ -568,9 +567,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	if (!ret) {
 		/*
 		 * We are either out of memory or the device can't DMA
-		 * to GFP_DMA memory; fall back on
-		 * swiotlb_map_single(), which will grab memory from
-		 * the lowest available address range.
+		 * to GFP_DMA memory; fall back on map_single(), which
+		 * will grab memory from the lowest available address range.
 		 */
 		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
 		if (!ret)
@@ -634,7 +632,7 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
  * physical address to use is returned.
  *
  * Once the device is given the dma address, the device owns this memory until
- * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
+ * either swiotlb_unmap_page or swiotlb_dma_sync_single is performed.
  */
 dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    unsigned long offset, size_t size,
@@ -648,7 +646,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 
 	BUG_ON(dir == DMA_NONE);
 	/*
-	 * If the pointer passed in happens to be in the device's DMA window,
+	 * If the address happens to be in the device's DMA window,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
@@ -679,7 +677,7 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
 
 /*
  * Unmap a single streaming mode DMA translation.  The dma_addr and size must
- * match what was provided for in a previous swiotlb_map_single call.  All
+ * match what was provided for in a previous swiotlb_map_page call.  All
  * other usages are undefined.
  *
  * After this call, reads by the cpu to the buffer are guaranteed to see
@@ -703,7 +701,7 @@ EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
  * Make physical memory consistent for a single streaming mode DMA translation
  * after a transfer.
  *
- * If you perform a swiotlb_map_single() but wish to interrogate the buffer
+ * If you perform a swiotlb_map_page() but wish to interrogate the buffer
  * using the cpu, yet do not wish to teardown the dma mapping, you must
  * call this function before doing so.  At the next point you give the dma
  * address back to the card, you must first perform a
@@ -777,7 +775,7 @@ EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
 
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
- * This is the scatter-gather version of the above swiotlb_map_single
+ * This is the scatter-gather version of the above swiotlb_map_page
  * interface.  Here the scatter gather list elements are each tagged with the
  * appropriate dma address and length.  They are obtained via
  * sg_dma_{address,length}(SG).
@@ -788,7 +786,7 @@ EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
  *       The routine returns the number of addr/length pairs actually
  *       used, at most nents.
  *
- * Device ownership issues as mentioned above for swiotlb_map_single are the
+ * Device ownership issues as mentioned above for swiotlb_map_page are the
  * same here.
  */
 int
@@ -836,7 +834,7 @@ EXPORT_SYMBOL(swiotlb_map_sg);
 
 /*
  * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
- * concerning calls here are the same as for swiotlb_unmap_single() above.
+ * concerning calls here are the same as for swiotlb_unmap_page() above.
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
