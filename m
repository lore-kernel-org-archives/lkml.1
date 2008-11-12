Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYKLMOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYKLMOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYKLMO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:14:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53110 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYKLMO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:14:29 -0500
Date: Wed, 12 Nov 2008 13:13:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] tracing: branch tracer, tweak output
Message-ID: <20081112121346.GA14739@elte.hu>
References: <20081112051438.843792214@goodmis.org> <20081112051518.503323629@goodmis.org> <20081112112536.GC31958@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112112536.GC31958@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> a small detail:
> 
> > For example:
> >
> >  bash-3471  [003]   357.014755: [INCORRECT] sched_info_dequeued:sched_stats.h:177
> >  bash-3471  [003]   357.014756: [correct] update_curr:sched_fair.c:489
> >  bash-3471  [003]   357.014758: [correct] calc_delta_fair:sched_fair.c:411
> >  bash-3471  [003]   357.014759: [correct] account_group_exec_runtime:sched_stats.h:356
> >  bash-3471  [003]   357.014761: [correct] update_curr:sched_fair.c:489
> >  bash-3471  [003]   357.014763: [INCORRECT] calc_delta_fair:sched_fair.c:411
> >  bash-3471  [003]   357.014765: [correct] calc_delta_mine:sched.c:1279
> 
> it's always good to have such fields aligned vertically. Something 
> like this would be shorter and visually much easier to parse:
> 
>  bash-3471  [003]   357.014755: [ MISS ] sched_info_dequeued:sched_stats.h:177
>  bash-3471  [003]   357.014756: [ .... ] update_curr:sched_fair.c:489
>  bash-3471  [003]   357.014758: [ .... ] calc_delta_fair:sched_fair.c:411
> 
> any objections against the patch below which implements this?

and note that this is really a "branch tracer/profiler", with branch 
taken/untaken prediction hits/misses. The likely()/unlikely() is an 
in-kernel tool to manually predict branch likelyhood - and for now we 
trace and profile those points that we tweaked manually - but there's 
no reason why that should be true for future versions too.

So i think it's generally better to think of these events as hit/miss 
events.

	Ingo
