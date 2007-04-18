Return-Path: <linux-kernel-owner+w=401wt.eu-S2993071AbXDRTYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993071AbXDRTYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993072AbXDRTYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:24:12 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993071AbXDRTYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:24:10 -0400
Date: Wed, 18 Apr 2007 12:23:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070418174945.GA7930@elte.hu>
Message-ID: <alpine.LFD.0.98.0704181215260.2828@woody.linux-foundation.org>
References: <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
 <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>
 <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
 <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
 <20070418174945.GA7930@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Apr 2007, Ingo Molnar wrote:
> 
> But note that most of the reported CFS interactivity wins, as surprising 
> as it might be, were due to fairness between _the same user's tasks_.

And *ALL* of the CFS interactivity *losses* and complaints have been 
because it did the wrong thing _between different user's tasks_

So what's your point? Your point was that when people try it out as a 
single user, it is indeed fair. But that's no point at all, since it 
totally missed _my_ point.

The problems with X scheduling is exactly that "other user" kind of thing.

The problem with kernel thread starvation due to user threads getting all 
the CPU time is exactly the same issue.

As logn as you think that all threads are equal, and should be treated 
equally, you CANNOT make it work well. People can say "ok, you can renice 
X", but the whole problem stems from the fact that you're trying to be 
fair based on A TOTALLY INVALID NOTION of what "fair" is.

> In the typical case, 99% of the desktop CPU time is executed either as X 
> (root user) or under the uid of the logged in user, and X is just one 
> task.

So? You are ignoring the argument again. You're totally bringing up a red 
herring:

> Even with a bad hack of making X super-high-prio, interactivity as 
> experienced by users still sucks without having fairness between the 
> other 100-200 user tasks that a desktop system is typically using.

I didn't say that you should be *unfair* within one user group. What kind 
of *idiotic* argument are you trying to put forth?

OF COURSE you should be fair "within the user group". Nobody contests that 
the "other 100-200 user tasks" should be scheduled fairly _amongst 
themselves_. 

The only point I had was that you cannot just lump all threads together 
and say "these threads are equally important". The 100-200 user tasks may 
be equally important, and should get equal amounts of preference, but that 
has absolutely _zero_ bearing on the _single_ task run in another 
"scheduling group", ie by other users or by X.

I'm not arguing against fairness. I'm arguing against YOUR notion of 
fairness, which is obviously bogus. It is *not* fair to try to give out 
CPU time evenly!

		Linus
