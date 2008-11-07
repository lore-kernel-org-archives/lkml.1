Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYKGVNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYKGVNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYKGVNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:13:34 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:57973 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYKGVNd (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:13:33 -0500
Subject: [PATCH][RT] Dereference pointer to cpu id, not to address of CPUID
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: RT Users List <linux-rt-users@vger.kernel.org>
Cc: LKML <Linux-kernel@vger.kernel.org>, Tony Jones <tonyj@suse.de>
Content-Type: text/plain
Organization: The Big Corporation
Date: Fri, 07 Nov 2008 13:13:27 -0800
Message-Id: <1226092407.5685.7.camel@dd>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies to 2.6.25-rt, 2.6.26-rt and 2.6.27-rt


From: Sven-Thorsten Dietrich <sdietrich@suse.de>
Subject: Dereference pointer to cpu id, when evaluating condition.

Without dereferencing, the condition always evaluates to true.

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2033,7 +2033,7 @@ slab_destroy(struct kmem_cache *cachep,
 	} else {
 		kmem_freepages(cachep, addr);
 		if (OFF_SLAB(cachep)) {
-			if (this_cpu)
+			if (*this_cpu)
 				__cache_free(cachep->slabp_cache, slabp, this_cpu);
 			else
 				kmem_cache_free(cachep->slabp_cache, slabp);


