Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZCYFUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZCYFUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 01:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZCYFU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 01:20:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59707 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZCYFU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 01:20:26 -0400
Message-Id: <20090325052023.071564146@goodmis.org>
References: <20090325051920.406564281@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 01:19:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] mm: remove unlikly NULL from kfree
Content-Disposition: inline; filename=0002-mm-remove-unlikly-NULL-from-kfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: clean up

A NULL pointer to kfree is no longer unlikely, as seen by the
annotated branch profiler:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
  728571  1315540  64 kfree                          slab.c               3719

This makes sense, since we now encourage developers to just call kfree
without checking for NULL.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 mm/slab.c |    2 +-
 mm/slob.c |    2 +-
 mm/slub.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 4d00855..0386c33 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3716,7 +3716,7 @@ void kfree(const void *objp)
 	struct kmem_cache *c;
 	unsigned long flags;
 
-	if (unlikely(ZERO_OR_NULL_PTR(objp)))
+	if (ZERO_OR_NULL_PTR(objp))
 		return;
 	local_irq_save(flags);
 	kfree_debugcheck(objp);
diff --git a/mm/slob.c b/mm/slob.c
index 52bc8a2..e077174 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -491,7 +491,7 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
-	if (unlikely(ZERO_OR_NULL_PTR(block)))
+	if (ZERO_OR_NULL_PTR(block))
 		return;
 
 	sp = (struct slob_page *)virt_to_page(block);
diff --git a/mm/slub.c b/mm/slub.c
index 0280eee..65dc436 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2743,7 +2743,7 @@ void kfree(const void *x)
 	struct page *page;
 	void *object = (void *)x;
 
-	if (unlikely(ZERO_OR_NULL_PTR(x)))
+	if (ZERO_OR_NULL_PTR(x))
 		return;
 
 	page = virt_to_head_page(x);
-- 
1.6.2

-- 
