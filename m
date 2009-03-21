Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZCUPzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZCUPzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZCUPzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:55:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbZCUPzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:55:03 -0400
Date: Sat, 21 Mar 2009 16:54:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perfcounters: record time running and time enabled
	for each counter
Message-ID: <20090321155442.GB6356@elte.hu>
References: <18884.55232.197620.696687@cargo.ozlabs.ibm.com> <20090321055252.eb0673ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321055252.eb0673ea.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > @@ -243,6 +259,8 @@ struct perf_counter {
> >  
> >  	struct perf_counter		*parent;
> >  	struct list_head		child_list;
> > +	atomic64_t			child_time_enabled;
> > +	atomic64_t			child_time_running;
> 
> These read like booleans, but why are they atomic64_t's?

for inherited counters these values get collected back into a 
'parent counter' in a lockless way - hence to not lose statistics on 
SMP they need to be atomic64_t.

> > @@ -290,6 +308,8 @@ struct perf_counter_context {
> >  	int			nr_active;
> >  	int			is_active;
> >  	struct task_struct	*task;
> > +	u64			time_now;
> > +	u64			time_lost;
> >  #endif
> >  };
> 
> I don't have a copy of this header file handy, but from the 
> snippet I see here, it doesn't look as though it is as clear and 
> as understadable as we can possibly make it?

i'll post the latest perfcounters tree - it's time for that anyway.

	Ingo
