Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXDQGKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXDQGKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXDQGKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:10:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:38931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbXDQGKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:10:53 -0400
Date: Tue, 17 Apr 2007 08:10:24 +0200
From: Nick Piggin <npiggin@suse.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Peter Williams <pwil3058@bigpond.net.au>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417061024.GB1057@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417055355.GQ943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417055355.GQ943@1wt.eu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 07:53:55AM +0200, Willy Tarreau wrote:
> Hi Nick,
> 
> On Tue, Apr 17, 2007 at 06:29:54AM +0200, Nick Piggin wrote:
> (...)
> > And my scheduler for example cuts down the amount of policy code and
> > code size significantly. I haven't looked at Con's ones for a while,
> > but I believe they are also much more straightforward than mainline...
> > 
> > For example, let's say all else is equal between them, then why would
> > we go with the O(logN) implementation rather than the O(1)?
> 
> Of course, if this is the case, the question will be raised. But as a
> general rule, I don't see much potential in O(1) to finely tune scheduling
> according to several criteria.

What do you mean? By what criteria?

> In O(logN), you can adjust scheduling in
> realtime at a very low cost. Better processing of varying priorities or
> fork() comes to mind.

The main problem as I see it is choosing which task to run next and
how much time to run it for. And given that there are typically far less
than 58 (the number of priorities in nicksched) runnable tasks for a
desktop system, I don't find it at all constraining to quantize my "next
runnable" criteria onto that size of key.

Even if you do expect a huge number of runnable tasks, you would hope
for fewer interactive ones toward the higher end of the priority scale.

Handwaving or even detailed design descriptions is simply not the best
way to decide on a new scheduler, is all I'm saying.

