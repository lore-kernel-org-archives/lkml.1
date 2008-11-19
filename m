Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYKSRkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYKSRkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYKSRkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:40:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34121 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbYKSRj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:39:59 -0500
Date: Wed, 19 Nov 2008 18:39:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: fix inconsistency when redistribute per-cpu
	tg->cfs_rq  shares.
Message-ID: <20081119173946.GA31560@elte.hu>
References: <b040c32a0811182241r3cf5e7c7l25d3627c2265ead2@mail.gmail.com> <1227113269.29743.43.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227113269.29743.43.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2008-11-18 at 22:41 -0800, Ken Chen wrote:
> > In the update_shares() path leading to tg_shares_up(), the calculation of
> > per-cpu cfs_rq shares is rather erratic even under moderate task wake up
> > rate.  The problem is that the per-cpu tg->cfs_rq load weight used in the
> > sd_rq_weight aggregation and actual redistribution of the cfs_rq->shares
> > are collected at different time.  Under moderate system load, we've seen
> > quite a bit of variation on the cfs_rq->shares and ultimately wildly
> > affects sched_entity's load weight.
> 
> Another thing we could possibly do is put a low-pass filter on the
> per-cpu load values so that we smooth out the fluctuations, hmm?
> 
> > This patch caches the result of initial per-cpu load weight when doing the
> > sum calculation, and then pass it down to update_group_shares_cpu() for
> > redistributing per-cpu cfs_rq shares.  This allows consistent total cfs_rq
> > shares across all CPUs. It also simplifies the rounding and zero load
> > weight check.
> > 
> > Signed-off-by: Ken Chen <kenchen@google.com>
> 
> This does indeed look much better, the cleanup factor alone makes it 
> a worthwhile patch, he fact that is improves behaviour makes it even 
> better :-)
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Thanks Ken!

applied to tip/sched/core (for v2.6.29), thanks guys!

	Ingo
