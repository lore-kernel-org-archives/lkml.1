Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbZKXLmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbZKXLmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbZKXLmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:42:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45354 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251AbZKXLmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:42:18 -0500
Date: Tue, 24 Nov 2009 12:42:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tim Blechmann <tim@klingt.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/5] slab.c: remove branch hint
Message-ID: <20091124114218.GA24396@elte.hu>
References: <cover.1259059549.git.tim@klingt.org>
 <4B0BBBA8.2090604@klingt.org>
 <20091124112058.GA23765@elte.hu>
 <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, Nov 24, 2009 at 1:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > (Pekka Cc:-ed)
> >
> > * Tim Blechmann <tim@klingt.org> wrote:
> >
> >> branch profiling on my nehalem machine showed 99% incorrect branch hints:
> >>
> >> ? ?28459 ?7678524 ?99 __cache_alloc_node ? ? ? ? ? ? slab.c
> >> ? 3551
> >>
> >> Signed-off-by: Tim Blechmann <tim@klingt.org>
> >> ---
> >> ?mm/slab.c | ? ?2 +-
> >> ?1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/mm/slab.c b/mm/slab.c
> >> index f70b326..4125fcd 100644
> >> --- a/mm/slab.c
> >> +++ b/mm/slab.c
> >> @@ -3548,7 +3548,7 @@ __cache_alloc_node(struct kmem_cache *cachep,
> >> gfp_t flags, int nodeid,
> >> ? ? ? slab_irq_save(save_flags, this_cpu);
> >> ? ? ? this_node = cpu_to_node(this_cpu);
> >> - ? ? if (unlikely(nodeid == -1))
> >> + ? ? if (nodeid == -1)
> >> ? ? ? ? ? ? ? nodeid = this_node;
> >> ? ? ? if (unlikely(!cachep->nodelists[nodeid])) {
> 
> That sounds odd to me. Can you see where the incorrectly predicted
> calls are coming from? Calling kmem_cache_alloc_node() with node set
> to -1 most of the time could be a real bug somewhere.

I think it could occur in too limited tests - the branch prediction 
looks 'wrong' in certain tests - while it's OK in general.

Is there some easy to run workload you consider more or less 
representative of typical SLAB patterns?

<plug> You might want to pull even with the scheduler subsystem and in 
       addition to 'perf bench sched', add a 'perf bench slab' set of 
       interesting testcases for SLAB performance testing. :-) 
</plug>

	Ingo
