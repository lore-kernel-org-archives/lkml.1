Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYGXLYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYGXLYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYGXLY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:24:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59072 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbYGXLY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:24:28 -0400
Date: Thu, 24 Jul 2008 13:24:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Walker <dwalker@mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] scheduler updates for v2.6.27, phase #2
Message-ID: <20080724112412.GA12465@elte.hu>
References: <20080721153804.GA26072@elte.hu> <1216657892.2294.34.camel@dhcp32.mvista.com> <1216668182.7257.80.camel@twins> <1216671393.2294.49.camel@dhcp32.mvista.com> <1216896193.7257.267.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216896193.7257.267.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2008-07-21 at 13:16 -0700, Daniel Walker wrote:
> > On Mon, 2008-07-21 at 21:23 +0200, Peter Zijlstra wrote:
> > 
> > > Does this work for you?
> > > 
> > 
> > Yours removed the warning .. I made an alternate one below only compile
> > tested, your choice..
> 
> How about this one - it seems there is a whole scala of new division
> instructions these days... :-)
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 47ceac9..3c38686 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -253,7 +253,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
>  
>  		diff = iter->rt_runtime - iter->rt_time;
>  		if (diff > 0) {
> -			do_div(diff, weight);
> +			diff = div_u64((u64)diff, weight);

/me likes.

applied to tip/sched/urgent, thanks guys.

	Ingo
