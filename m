Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZANMGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZANMGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZANMGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:06:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49715 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbZANMGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:06:09 -0500
Date: Wed, 14 Jan 2009 13:05:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: introduce avg_wakeup
Message-ID: <20090114120558.GA5711@elte.hu>
References: <20090114113917.199690328@chello.nl> <20090114114026.969559732@chello.nl> <1231934371.7141.29.camel@twins> <1231934594.7141.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231934594.7141.30.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-01-14 at 12:59 +0100, Peter Zijlstra wrote:
> > +       /*
> > +        * Only attribute actual wakeups done by this task.
> > +        */
> > +       if (!in_interrupt()) {
> > +               struct sched_entity *se = &current->se;
> > +               u64 sample = se->sum_exec_runtime;
> > +
> > +               if (se->last_wakeup)
> > +                       sample -= se->last_wakeup;
> > +               else
> > +                       sample -= se->start_runtime;
> > +               update_avg(&se->avg_wakeup, sample);
> > +
> > +               current->se.last_wakeup = current->se.sum_exec_runtime;
> > +       }
> 
> time for lunch apparently...
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2424,7 +2424,7 @@ out_activate:
>  			sample -= se->start_runtime;
>  		update_avg(&se->avg_wakeup, sample);
>  
> -		current->se.last_wakeup = current->se.sum_exec_runtime;
> +		se.last_wakeup = se.sum_exec_runtime;
>  	}

mind sending a delta against the first submission? Whenever you are done 
with the lunch stuff ;-)

	Ingo
