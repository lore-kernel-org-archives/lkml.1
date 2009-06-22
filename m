Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZFVOKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZFVOKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZFVOKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:10:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60174 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZFVOKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:10:41 -0400
Date: Mon, 22 Jun 2009 16:10:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
	member in event_symbol
Message-ID: <20090622141009.GB6486@elte.hu>
References: <1245669194.17153.6.camel@localhost.localdomain> <1245669268.17153.8.camel@localhost.localdomain> <20090622113256.GA22479@elte.hu> <1245675657.7537.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245675657.7537.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Mon, 2009-06-22 at 13:32 +0200, Ingo Molnar wrote:
> 
> > Another nice thing would be for 'perf list' to actually start each 
> > counter and stop it - and see whether it ticks. Perhaps that could 
> > be a new sub-command: 'perf test' ?
> > 
> > New 'perf' subcommands are added easily:
> > 
> > create a new tools/perf/builtin-foo.c file, add it to 
> > command-list.txt and to the Makefile - add it to perf.c's array of 
> > built-in commands and add a Documentation/perf-foo.txt file to 
> > generate manpages and usage strings for it.
> > 
> 
> Ok this is just a ugly quick hack to get the idea what actually you are
> looking for :
> 
> [RFC] perf_counter tools: introduce perf test to test each event for ticks
> 
> perf test to Test all events for whether it ticks
> 
>   $ perf test
> 
>   Performance counter stats for 'test':
> 
>   task-clock-msecs      Tick
>   context-switches      Tick
>   CPU-migrations        Tick
>   page-faults           Tick
>   cycles                Tick
>   instructions          Tick
>   cache-references      Tick
>   cache-misses          Tick
> 
>      0.007693869  seconds time elapsed.

yeah, somethig like that. I'd suggest to print out the actual 
measured events:

    cache-references      10123 events
    cache-misses             15 events

and if something does not appear to be ticking then do something 
like:

    cache-misses          <inactive>

I.e. 'perf test' could be a quick way both to users and to 
developers to see all possible hw and sw events.

Perhaps builtin-test.c should also do specific testcases for certain 
counters - say intentionally migrate to a CPU and back to see the 
CPU-migration count.

Also, you seem to have copied builtin-stat.c, right? Try to 
librarize as much of the functionality (into util/*) to make the 
resulting linecount increase as small as possible.

	Ingo
