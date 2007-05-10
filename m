Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXEJUD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXEJUD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbXEJUDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:03:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757533AbXEJUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:03:05 -0400
Date: Thu, 10 May 2007 22:02:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: vatsa@in.ibm.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, tingy@cs.umass.edu, tong.n.li@intel.com
Subject: Re: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
Message-ID: <20070510200202.GA22852@elte.hu>
References: <20070508150431.GA26977@elte.hu> <20070509180205.GA27462@in.ibm.com> <1178787118.6035.26.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178787118.6035.26.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2007-05-09 at 23:32 +0530, Srivatsa Vaddagiri wrote:
> 
> > Ingo,
> > 	I had a question with respect to the definition of fairness used, esp
> > for tasks that are not 100% cpu hogs.
> > 
> > Ex: consider two equally important tasks T1 and T2 running on same CPU and 
> > whose execution nature is:
> > 
> > 	T1 = 100% cpu hog
> > 	T2 = 60% cpu hog (run for 600ms, sleep for 400ms)
> > 
> > Over a arbitrary observation period of 10 sec, 
> > 
> > 	T1 was ready to run for all 10sec
> > 	T2 was ready to run for 6 sec
> > 
> > Over this observation period, how much execution time should T2 get,
> > under a "fair" scheduler?
> > 
> > I was expecting both T2 and T1 to get 5 sec (50:50 split). Is this a
> > wrong expectation of fairness?
> 
> Depends on how long your fairness yardstick is I suppose.

yeah, i'd agree with that. I think a 400 msecs sleep period is still 
within the range that we should define as being within the scope, but 
it's probably borderline. The ultimate threshold is the reaction time of 
humans - somewhere between 30 msecs and 1 second. Sleep periods beyond 
that are typically not expected to be 'smoothly and fairly scheduled' 
the same way as say a CPU hogs are scheduled - because you can already 
'see' the effects of the sleep - so 'smoothness' is not possible 
anymore.

	Ingo
