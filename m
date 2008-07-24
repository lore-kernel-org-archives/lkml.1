Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYGXLLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYGXLLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYGXLLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:11:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbYGXLLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:11:00 -0400
Date: Thu, 24 Jul 2008 04:09:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler updates for v2.6.27, phase #2
Message-Id: <20080724040954.6402e73f.akpm@linux-foundation.org>
In-Reply-To: <1216896193.7257.267.camel@twins>
References: <20080721153804.GA26072@elte.hu>
	<1216657892.2294.34.camel@dhcp32.mvista.com>
	<1216668182.7257.80.camel@twins>
	<1216671393.2294.49.camel@dhcp32.mvista.com>
	<1216896193.7257.267.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 12:43:13 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

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

ain't life grand.

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

Can't use div_s64() here?

>  			if (rt_rq->rt_runtime + diff > rt_period)
>  				diff = rt_period - rt_rq->rt_runtime;
>  			iter->rt_runtime -= diff;
> 
