Return-Path: <linux-kernel-owner+w=401wt.eu-S964829AbXG0Jrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829AbXG0Jrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932199AbXG0JqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:03 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:35853 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935836AbXG0JqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:00 -0400
Date: Fri, 27 Jul 2007 11:44:35 +0200 (MEST)
Message-Id: <200707270944.LAA17167@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 06/68] 0 -> NULL, for arch/frv
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: dhowells@redhat.com
Cc: akpm@linux-foundation.org
---

 dma-alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/mm/dma-alloc.c b/arch/frv/mm/dma-alloc.c
index dc6522c..eb67cef 100644
--- a/arch/frv/mm/dma-alloc.c
+++ b/arch/frv/mm/dma-alloc.c
@@ -61,7 +61,7 @@ static int map_page(unsigned long va, un
 
 	/* Use middle 10 bits of VA to index the second-level map */
 	pte = pte_alloc_kernel(pme, va);
-	if (pte != 0) {
+	if (pte != NULL) {
 		err = 0;
 		set_pte(pte, mk_pte_phys(pa & PAGE_MASK, prot));
 	}
@@ -99,7 +99,7 @@ void *consistent_alloc(gfp_t gfp, size_t
 
 	/* allocate some common virtual space to map the new pages */
 	area = get_vm_area(size, VM_ALLOC);
-	if (area == 0) {
+	if (area == NULL) {
 		free_pages(page, order);
 		return NULL;
 	}

