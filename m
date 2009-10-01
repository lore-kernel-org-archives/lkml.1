Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZJBDd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZJBDd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 23:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZJBDd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 23:33:27 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:42151 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753866AbZJBDdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 23:33:25 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20091001212558.534705127@gentwo.org>
References: <20091001212521.123389189@gentwo.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Oct 2009 17:25:26 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Miller <davem@davemloft.net>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V4 05/20] use this_cpu ops for network statistics
Content-Disposition: inline; filename=this_cpu_net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/net/neighbour.h              |    7 +------
 include/net/netfilter/nf_conntrack.h |    4 ++--
 2 files changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6/include/net/neighbour.h
===================================================================
--- linux-2.6.orig/include/net/neighbour.h	2009-09-30 18:32:31.000000000 -0500
+++ linux-2.6/include/net/neighbour.h	2009-09-30 18:32:55.000000000 -0500
@@ -90,12 +90,7 @@ struct neigh_statistics
 	unsigned long unres_discards;	/* number of unresolved drops */
 };
 
-#define NEIGH_CACHE_STAT_INC(tbl, field)				\
-	do {								\
-		preempt_disable();					\
-		(per_cpu_ptr((tbl)->stats, smp_processor_id())->field)++; \
-		preempt_enable();					\
-	} while (0)
+#define NEIGH_CACHE_STAT_INC(tbl, field) this_cpu_inc((tbl)->stats->field)
 
 struct neighbour
 {
Index: linux-2.6/include/net/netfilter/nf_conntrack.h
===================================================================
--- linux-2.6.orig/include/net/netfilter/nf_conntrack.h	2009-09-30 18:32:57.000000000 -0500
+++ linux-2.6/include/net/netfilter/nf_conntrack.h	2009-09-30 18:34:13.000000000 -0500
@@ -295,11 +295,11 @@ extern unsigned int nf_conntrack_htable_
 extern unsigned int nf_conntrack_max;
 
 #define NF_CT_STAT_INC(net, count)	\
-	(per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++)
+	__this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count)		\
 do {							\
 	local_bh_disable();				\
-	per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++;	\
+	__this_cpu_inc((net)->ct.stat->count);		\
 	local_bh_enable();				\
 } while (0)
 

-- 
