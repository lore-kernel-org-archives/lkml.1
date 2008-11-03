Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYKCK3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYKCK3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbYKCK3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:29:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53500 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbYKCK3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:29:34 -0500
Date: Mon, 3 Nov 2008 11:29:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] small optimization to update_curr_rt
Message-ID: <20081103102916.GK13671@elte.hu>
References: <20081031130341.GA12018@sgi.com> <1225707724.7803.1612.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225707724.7803.1612.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2008-10-31 at 08:03 -0500, Dimitri Sivanich wrote:
> > A very minor improvement, but might it be better to check sched_rt_runtime(rt_rq)
> > before taking the rt_runtime_lock?
> 
> Yes, I think its ok to do so.
> 
> Like pointed out in the other thread, there are two races:
> 
>  - sched_rt_runtime() going to RUNTIME_INF, and that will be handled
>    properly by sched_rt_runtime_exceeded()
> 
>  - sched_rt_runtime() going to !RUNTIME_INF, and here we can miss an
>    accounting cycle, but I don't think that is something to worry too
>    much about.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/sched/rt, thanks guys!

	Ingo
