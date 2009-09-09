Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbZIIGNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbZIIGNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 02:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZIIGNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 02:13:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZIIGNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 02:13:17 -0400
Date: Wed, 9 Sep 2009 08:13:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090909061308.GA28109@elte.hu>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk> <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk> <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908203409.GJ18599@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Sep 08 2009, Peter Zijlstra wrote:
> > On Tue, 2009-09-08 at 11:13 +0200, Jens Axboe wrote:
> > > And here's a newer version.
> > 
> > I tinkered a bit with your proglet and finally found the 
> > problem.
> > 
> > You used a single pipe per child, this means the loop in 
> > run_child() would consume what it just wrote out until it got 
> > force preempted by the parent which would also get woken.
> > 
> > This results in the child spinning a while (its full quota) and 
> > only reporting the last timestamp to the parent.
> 
> Oh doh, that's not well thought out. Well it was a quick hack :-) 
> Thanks for the fixup, now it's at least usable to some degree.

What kind of latencies does it report on your box?

Our vanilla scheduler default latency targets are:

  single-core: 20 msecs
    dual-core: 40 msecs
    quad-core: 60 msecs
    opto-core: 80 msecs

You can enable CONFIG_SCHED_DEBUG=y and set it directly as well via 
/proc/sys/kernel/sched_latency_ns:

   echo 10000000 > /proc/sys/kernel/sched_latency_ns

	Ingo
