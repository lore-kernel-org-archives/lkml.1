Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbZIJDP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbZIJDP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZIJDP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:15:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:48817 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751652AbZIJDP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:15:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/lNO9w2RTlfFAQgdMUYNQszC5Rn0eqaznmH1mQX2
	aDpQOFaDh8wdpY
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Mike Galbraith <efault@gmx.de>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4AA80C1E.2080901@arcor.de>
References: <20090907173846.GB18599@kernel.dk>
	 <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk>
	 <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>
	 <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>
	 <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk>
	 <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu>
	 <4AA80C1E.2080901@arcor.de>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 05:15:27 +0200
Message-Id: <1252552527.6342.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 23:12 +0300, Nikos Chantziaras wrote:

> With your version of latt.c, I get these results with 2.6-tip vs 
> 2.6.31-rc9-bfs:
> 
> 
> (mainline)
> Averages:
> ------------------------------
>          Max            50 usec
>          Avg            12 usec
>          Stdev           3 usec
> 
> 
> (BFS)
> Averages:
> ------------------------------
>          Max           474 usec
>          Avg            11 usec
>          Stdev          16 usec
> 
> 
> However, the interactivity problems still remain.  Does that mean it's 
> not a latency issue?

Could be a fairness issue.  If X+client needs more than it's fair share
of CPU, there's nothing to do but use nice levels.  I'm stuck with
unaccelerated X (nvidia card), so if I want a good DVD watching or
whatever eye-candy experience while my box does a lot of other work, I
either have to use SCHED_IDLE/nice for the background stuff, or renice
X.  That's the down side of a fair scheduler.

There is another variant of latency related interactivity issue for the
desktop though, too LOW latency.  If X and clients are switching too
fast, redraw can look nasty, sliced/diced.

	-Mike

