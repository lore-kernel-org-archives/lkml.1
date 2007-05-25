Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbXEYJD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbXEYJD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXEYJDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:03:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47184 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbXEYJDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:03:18 -0400
Date: Fri, 25 May 2007 11:03:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525090315.GK8094@one.firstfloor.org>
References: <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080209.GE8094@one.firstfloor.org> <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org> <20070525015544.bce3cb99.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525015544.bce3cb99.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This?    I sent it to you earlier this week:

Sorry haven't processed those yet.

Ah. The correct fix here is to clear the tsc flag in boot_cpu_data
when the option is set. Will do that.

-Andi


> 
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
> divide by zero on boot.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/kernel/sched-clock.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share arch/i386/kernel/sched-clock.c
> --- a/arch/i386/kernel/sched-clock.c~fix-x86_64-mm-sched-clock-share
> +++ a/arch/i386/kernel/sched-clock.c
> @@ -115,7 +115,7 @@ unsigned long long printk_clock(void)
>  static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
>  {
>  	sc->sync_base = jiffies;
> -	if (!cpu_has_tsc) {
> +	if (!cpu_has_tsc || tsc_disable) {
>  		sc->unstable = 1;
>  		return;
>  	}
> _
> 
