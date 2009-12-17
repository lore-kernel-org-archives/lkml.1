Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbZLQKxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbZLQKxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964812AbZLQKxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:53:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45359 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbZLQKx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:53:28 -0500
Date: Thu, 17 Dec 2009 11:53:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Garrett-Glaser <darkshikari@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: x264 benchmarks BFS vs CFS
Message-ID: <20091217105316.GB26010@elte.hu>
References: <1261042383.14314.0.camel@localhost>
 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Garrett-Glaser <darkshikari@gmail.com> wrote:

> On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > well well :) nothing quite speaks out like graphs..
> >
> > http://doom10.org/index.php?topic=78.0
> >
> >
> >
> > regards,
> > Kasper Sandberg
> 
> Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically tied 
> it--and given the strict thread-ordering expectations of x264, you basically 
> can't expect it to do any better, though I'm curious what's responsible for 
> the gap in "veryslow", even with SCHED_BATCH enabled.
> 
> The most odd case is that of "ultrafast", in which CFS immediately ties BFS 
> when we enable SCHED_BATCH.  We're doing some further testing to see exactly 
> what the conditions of this are--is it because ultrafast is just so much 
> faster than all the other modes and so switches threads/loads faster?  Is it 
> because ultrafast has relatively equal workload among the threads, unlike 
> the other loads?  We'll probably know soon.

Thanks for testing it!

Btw., you might want to make use of 'perf sched record', 'perf sched map', 
'perf sched trace' etc. to get an insight into how a particular workload 
schedules and why those decisions are done. (You'll need CONFIG_SCHED_DEBUG=y 
for best results.)

Thanks,

	Ingo
