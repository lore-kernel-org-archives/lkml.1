Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZLOOvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZLOOvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 09:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbZLOOvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 09:51:50 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:53268 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbZLOOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 09:51:48 -0500
Date: Tue, 15 Dec 2009 08:50:39 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
 cleanup
In-Reply-To: <4B273108.9050301@kernel.org>
Message-ID: <alpine.DEB.2.00.0912150846530.16754@router.home>
References: <20091214220320.665065925@quilx.com> <1260859066.4770.0.camel@penberg-laptop> <4B273108.9050301@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small fixup patch to the slub patches:

Subject: Update remaining reference to get_cpu_slab

If CONFIG_SLUB_STATS is set then some additional code is being
compiled that was not updated since it was a recent addition to slub.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2009-12-15 08:47:44.000000000 -0600
+++ linux-2.6/mm/slub.c	2009-12-15 08:48:03.000000000 -0600
@@ -4221,7 +4221,7 @@ static void clear_stat(struct kmem_cache
 	int cpu;

 	for_each_online_cpu(cpu)
-		get_cpu_slab(s, cpu)->stat[si] = 0;
+		per_cpu_ptr(s->cpu_slab, cpu)->stat[si] = 0;
 }

 #define STAT_ATTR(si, text) 					\
