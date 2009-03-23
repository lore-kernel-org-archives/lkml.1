Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbZCWQoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbZCWQoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbZCWQoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:44:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbZCWQoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:44:06 -0400
Date: Mon, 23 Mar 2009 17:43:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Lojkin <ia6432@inbox.ru>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, rjw@sisk.pl
Subject: Re: 2.6.28, limiting cpu time doesn't work
Message-ID: <20090323164341.GA1304@elte.hu>
References: <20090322201436.GA12838@redhat.com> <E1LlVpr-0000Rv-00.ia6432-inbox-ru@f62.mail.ru> <20090322231111.GA21775@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322231111.GA21775@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 03/23, Peter Lojkin wrote:
> >
> > Oleg Nesterov wrote:
> >
> > > Found this message on http://bugzilla.kernel.org/show_bug.cgi?id=12911 ...
> > >
> > > I _think_ posix_cpu_timers_init_group() is not right, it should copy
> > > cputime_expires->prof_exp.
> > >
> > > Peter, any chance you can test the (uncompiled/untested) patch below?
> >
> > yes, with this patch 2.6.28.8 works as expected, thank you!
> 
> Great, thanks!
> 
> > if you need to test any more patches on the subject i'm ready to do it.
> > regression test system for our project depends on ability to limit cpu time,
> > so it's major problem for us...
> 
> I am not sure what should we do, this needs more discussion.
> 
> Probably the most simple patch for -stable and 2.6.29 is below.
> (with this patch we don't even need update_rlimit_cpu(), afaics).
> 
> Oleg.
> 
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -1263,7 +1263,8 @@ static inline int fastpath_timer_check(s
>  		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
>  			return 1;
>  	}
> -	return 0;
> +
> +	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;

Once this version of the patch is confirmed to fix the bug, please 
send a full patch with a full changelog, SOB, Reported-by and 
Tested-by lines.

Thanks,

	Ingo
