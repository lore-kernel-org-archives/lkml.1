Return-Path: <linux-kernel-owner+w=401wt.eu-S936989AbXG0JxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936989AbXG0JxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936865AbXG0JtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:49:10 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36766 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936261AbXG0JtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:49:07 -0400
Date: Fri, 27 Jul 2007 11:47:41 +0200 (MEST)
Message-Id: <200707270947.LAA17582@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 19/68] 0 -> NULL, for arch/x86_64
Cc: ak@suse.de, discuss@x86-64.org, akpm@linux-foundation.org,
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
Cc: ak@suse.de
Cc: discuss@x86-64.org
Cc: akpm@linux-foundation.org
---

 numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
index 6da2355..97e8ac7 100644
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -166,7 +166,7 @@ early_node_mem(int nodeid, unsigned long
 		return __va(mem);
 	ptr = __alloc_bootmem_nopanic(size,
 				SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS));
-	if (ptr == 0) {
+	if (ptr == NULL) {
 		printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
 			size, nodeid);
 		return NULL;

