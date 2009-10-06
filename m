Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZJGCf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZJGCf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZJGCf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:35:28 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:47197 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503AbZJGCf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:35:28 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 3
	times
Message-Id: <20091006233730.469188837@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 19:36:59 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Miller <davem@davemloft.net>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V5 05/19] use this_cpu ops for network statistics
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
