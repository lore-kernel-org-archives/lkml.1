Return-Path: <linux-kernel-owner+w=401wt.eu-S1031079AbXDQEaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031079AbXDQEaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 00:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031083AbXDQEaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 00:30:00 -0400
Received: from mx1.suse.de ([195.135.220.2]:34708 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031079AbXDQEaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 00:30:00 -0400
Date: Tue, 17 Apr 2007 06:29:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417042954.GG25513@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46244A52.4000403@bigpond.net.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 02:17:22PM +1000, Peter Williams wrote:
> Nick Piggin wrote:
> >On Tue, Apr 17, 2007 at 04:29:01AM +0200, Mike Galbraith wrote:
> >>On Tue, 2007-04-17 at 10:06 +1000, Peter Williams wrote:
> >>>Mike Galbraith wrote:
> >>>>Demystify what?   The casual observer need only read either your attempt
> >>>>at writing a scheduler, or my attempts at fixing the one we have, to see
> >>>>that it was high time for someone with the necessary skills to step in.
> >>>Make that "someone with the necessary clout".
> >>No, I was brutally honest to both of us, but quite correct.
> >>
> >>>>Now progress can happen, which was _not_ happening before.
> >>>>
> >>>This is true.
> >>Yup, and progress _is_ happening now, quite rapidly.
> >
> >Progress as in progress on Ingo's scheduler. I still don't know how we'd
> >decide when to replace the mainline scheduler or with what.
> >
> >I don't think we can say Ingo's is better than the alternatives, can we?
> >If there is some kind of bakeoff, then I'd like one of Con's designs to
> >be involved, and mine, and Peter's...
> 
> I myself was thinking of this as the chance for a much needed 
> simplification of the scheduling code and if this can be done with the 
> result being "reasonable" it then gives us the basis on which to propose 
> improvements based on the ideas of others such as you mention.
> 
> As the size of the cpusched indicates, trying to evaluate alternative 
> proposals based on the current O(1) scheduler is fraught.  Hopefully, 

I don't know why. The problem is that you can't really evaluate good
proposals by looking at the code (you can say that one is bad, ie. the
current one, which has a huge amount of temporal complexity and is
explicitly unfair), but it is pretty hard to say one behaves well.

And my scheduler for example cuts down the amount of policy code and
code size significantly. I haven't looked at Con's ones for a while,
but I believe they are also much more straightforward than mainline...

For example, let's say all else is equal between them, then why would
we go with the O(logN) implementation rather than the O(1)?

