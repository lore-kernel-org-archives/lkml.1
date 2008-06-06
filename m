Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYFFPBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYFFPBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbYFFPBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:01:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbYFFPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:01:30 -0400
Date: Fri, 6 Jun 2008 17:01:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606150102.GA14141@elte.hu>
References: <20080606024811.70db9ab2.akpm@linux-foundation.org> <20080606035413.37f340ef.akpm@linux-foundation.org> <20080606115759.GA29321@elte.hu> <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com> <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com> <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com> <484947A9.5050804@sgi.com> <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com> <20080606145717.GA5300@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606145717.GA5300@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Subject: [PATCH] sched: don't call node_to_cpumask() on nodes > 
> > nr_node_ids
> 
> AFAICS this is not yet required for v2.6.26, as the requirement to 
> never iterate to MAX_NUMNODES and call nr_cpus_node() with the index 
> only got introduced by Mike's patch.

the one below is needed as well i think.

	Ingo
---
 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -6576,9 +6576,9 @@ static int find_next_best_node(int node,
 
 	min_val = INT_MAX;
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		/* Start at @node */
-		n = (node + i) % MAX_NUMNODES;
+		n = (node + i) % nr_node_ids;
 
 		if (!nr_cpus_node(n))
 			continue;
