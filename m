Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZLRHaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZLRHaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 02:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZLRHaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 02:30:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:58642 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751860AbZLRHaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 02:30:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19xCG5RqgBxNGwkF5jbRH/Vpo6yu/LH7WBLJu7pqJ
	AlUOVB7exHYbQq
Subject: Re: x264 benchmarks BFS vs CFS
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Garrett-Glaser <darkshikari@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091218052344.GD417@elte.hu>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
	 <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
	 <20091218052344.GD417@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 08:30:05 +0100
Message-Id: <1261121405.30469.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 06:23 +0100, Ingo Molnar wrote:

> Having said that, we generally try to make things perform well without apps 
> having to switch themselves to SCHED_BATCH. Mike, do you think we can make 
> x264 perform as well (or nearly as well) under SCHED_OTHER as under 
> SCHED_BATCH?

It's not bad as is, except for ultrafast mode.  START_DEBIT is the
biggest problem there.  I don't think SCHED_OTHER will ever match
SCHED_BATCH for this load, though I must say I haven't full-spectrum
tested.  This load really wants RR scheduling, and wakeup preemption
necessarily perturbs run order.

I'll probably piddle with it some more, it's an interesting load.

	-Mike

