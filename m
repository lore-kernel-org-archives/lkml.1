Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbZHaILp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbZHaILp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZHaILo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:11:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZHaILo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:11:44 -0400
Date: Mon, 31 Aug 2009 10:11:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] perf tools: Complete support for dynamic strings
Message-ID: <20090831081133.GA15619@elte.hu>
References: <1251682323-10395-1-git-send-email-fweisbec@gmail.com> <1251693921-6579-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251693921-6579-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Complete support for __str_loc type strings of ftrace events which
> have dynamic offsets values set for each of them inside their sammples.
> 
> Before:
>         geany-5759  [000]     0.000000: lock_release: name
>         geany-5759  [000]     0.000000: lock_release: name
>         geany-5759  [000]     0.000000: lock_release: name
>   kondemand/0-362   [000]     0.000000: lock_release: name
>       pdflush-421   [000]     0.000000: lock_release: name
> 
> After:
>         geany-5759  [000]     0.000000: lock_release: &u->lock
>         geany-5759  [000]     0.000000: lock_release: key
>         geany-5759  [000]     0.000000: lock_release: &group->notification_mutex
>   kondemand/0-362   [000]     0.000000: lock_release: &rq->lock
>       pdflush-421   [000]     0.000000: lock_release: &rq->lock

I've applied all five patches, thanks Frederic!

Also, i think this makes perf trace quite functional already so i 
merged that topic (and these commits) into tracing/core, for v2.6.32 
merging.

One thing that i noticed which is still quite quirky are the 
parameters to perf record. (needing -R and the :r postfix to events) 
Could something more intuitive be done here?

Also, i think people would like to use wildcards in event 
specifiers, such as:

  perf record -e timer/*

To capture all timer events:

 hrtimer_cancel
 hrtimer_expire_entry
 hrtimer_expire_exit
 hrtimer_init
 hrtimer_start
 itimer_expire
 itimer_state
 timer_cancel
 timer_expire_entry
 timer_expire_exit
 timer_init
 timer_start

Instead of having to type:

perf record -e hrtimer_cancel -e hrtimer_expire_entry \
 -e hrtimer_expire_exit -e hrtimer_init -e hrtimer_start \
 -e itimer_expire -e itimer_state -e timer_cancel \
 -e timer_expire_entry -e timer_expire_exit -e timer_init \
 -e timer_start

which is not quite realistic.

	Ingo
