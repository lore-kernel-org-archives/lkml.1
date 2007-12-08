Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXLHPjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXLHPjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 10:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbXLHPjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 10:39:05 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:56210 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXLHPjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 10:39:03 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Date: Sat, 8 Dec 2007 16:36:45 +0100
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, Guillaume Chazarain <guichaz@yahoo.fr>,
       stefano.brivio@polimi.it, Nick Piggin <nickpiggin@yahoo.com.au>,
       Robert Love <rml@tech9.net>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <20071207084559.GA11162@elte.hu> <200712081627.45937.mb@bu3sch.de> <20071208153327.GC30270@elte.hu>
In-Reply-To: <20071208153327.GC30270@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712081636.45828.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 December 2007 16:33:27 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Saturday 08 December 2007 16:13:41 Ingo Molnar wrote:
> > > 
> > > * Mark Lord <lkml@rtr.ca> wrote:
> > > 
> > > > Ingo Molnar wrote:
> > > >> ...
> > > >> thanks. I do get the impression that most of this can/should wait until 
> > > >> 2.6.25. The patches look quite dangerous.
> > > > ..
> > > >
> > > > I confess to not really trying hard to understand everything in this 
> > > > thread, but the implication seems to be that this bug might affect 
> > > > udelay() and possibly jiffies ?
> > > 
> > > no, it cannot affect jiffies. (jiffies was a red herring all along)
> > > 
> > > udelay() cannot be affected either - sched_clock() has no effect on 
> > > udelay(). _But_, when there are TSC problems then tsc based udelay() 
> > > suffers too so the phenomenons may _seem_ related.
> > 
> > What about msleep()? I suspect problems in b43 because of this issue. 
> > msleep() returning too early. Is that possible with this bug?
> 
> i cannot see how. You can verify msleep by running something like this:
> 
>   while :; do time usleep 111000; done
> 
> you should see a steady stream of:
> 
>  real    0m0.113s
>  real    0m0.113s
>  real    0m0.113s
> 
> (on an idle system). If it fluctuates, with occasional longer delays, 
> there's some timer problem present.

Does the sleeping and timing use different time references?
I mean, if it uses the same reference and that reference does fluctuate
you won't see it in the result.

But anyway, Stefano. Can you test this?

-- 
Greetings Michael.
