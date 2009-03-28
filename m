Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbZC2CFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbZC2CFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZC2CEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:10 -0400
Received: from ozlabs.org ([203.10.76.45]:46563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbZC2CEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:05 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 5/10] cpumask: use mm_cpumask() wrapper: kernel/fork.c
Message-Id: <20090329020403.92320DDD1B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: futureproof

Makes code futureproof against the impending change to mm->cpu_vm_mask.

It's also a chance to use the new cpumask_ ops which take a pointer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -279,7 +279,7 @@ static int dup_mmap(struct mm_struct *mm
 	mm->free_area_cache = oldmm->mmap_base;
 	mm->cached_hole_size = ~0UL;
 	mm->map_count = 0;
-	cpus_clear(mm->cpu_vm_mask);
+	cpumask_clear(mm_cpumask(mm));
 	mm->mm_rb = RB_ROOT;
 	rb_link = &mm->mm_rb.rb_node;
 	rb_parent = NULL;

