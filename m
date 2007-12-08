Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbXLHPeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbXLHPeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXLHPe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:34:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37506 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXLHPe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:34:27 -0500
Date: Sat, 8 Dec 2007 16:33:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Mark Lord <lkml@rtr.ca>, Guillaume Chazarain <guichaz@yahoo.fr>,
       stefano.brivio@polimi.it, Nick Piggin <nickpiggin@yahoo.com.au>,
       Robert Love <rml@tech9.net>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Message-ID: <20071208153327.GC30270@elte.hu>
References: <20071207084559.GA11162@elte.hu> <475AB2FD.30600@rtr.ca> <20071208151341.GA25413@elte.hu> <200712081627.45937.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712081627.45937.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Michael Buesch <mb@bu3sch.de> wrote:

> On Saturday 08 December 2007 16:13:41 Ingo Molnar wrote:
> > 
> > * Mark Lord <lkml@rtr.ca> wrote:
> > 
> > > Ingo Molnar wrote:
> > >> ...
> > >> thanks. I do get the impression that most of this can/should wait until 
> > >> 2.6.25. The patches look quite dangerous.
> > > ..
> > >
> > > I confess to not really trying hard to understand everything in this 
> > > thread, but the implication seems to be that this bug might affect 
> > > udelay() and possibly jiffies ?
> > 
> > no, it cannot affect jiffies. (jiffies was a red herring all along)
> > 
> > udelay() cannot be affected either - sched_clock() has no effect on 
> > udelay(). _But_, when there are TSC problems then tsc based udelay() 
> > suffers too so the phenomenons may _seem_ related.
> 
> What about msleep()? I suspect problems in b43 because of this issue. 
> msleep() returning too early. Is that possible with this bug?

i cannot see how. You can verify msleep by running something like this:

  while :; do time usleep 111000; done

you should see a steady stream of:

 real    0m0.113s
 real    0m0.113s
 real    0m0.113s

(on an idle system). If it fluctuates, with occasional longer delays, 
there's some timer problem present.

	Ingo
