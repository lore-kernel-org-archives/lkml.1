Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbXHFD37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbXHFD37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 23:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbXHFD3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 23:29:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:41345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbXHFD3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 23:29:51 -0400
Date: Mon, 6 Aug 2007 05:29:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070806032949.GA16401@wotan.suse.de>
References: <20070802021525.GC15595@wotan.suse.de> <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org> <20070802024132.GD15595@wotan.suse.de> <20070802071956.GA23300@elte.hu> <20070802073123.GB16744@wotan.suse.de> <20070802154447.GA13725@elte.hu> <20070803001447.GA14775@wotan.suse.de> <20070804065037.GA30816@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804065037.GA30816@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 08:50:37AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Oh good. Thanks for getting to the bottom of it. We have normally 
> > disliked too much runtime tunables in the scheduler, so I assume these 
> > are mostly going away or under a CONFIG option for 2.6.23? Or...?
> 
> yeah, they are all already under CONFIG_SCHED_DEBUG. (it's just that the 
> add-on optimization is not upstream yet - the tunings are still being 

Ah, OK. So long as that goes upstream I'm happy... and it is good
to see that with that patch, the base context switching performance
_has_ actually gone up like I had hoped. Nice.


> tested) Btw., with SCHED_DEBUG we now also have your domain-tree sysctl 
> patch upstream, which has been in -mm for a near eternity.
> 
> > What CPU did you get these numbers on? Do the indirect calls hurt much 
> > on those without an indirect predictor? (I'll try running some tests).
> 
> it was on an older Athlon64 X2. I never saw indirect calls really 
> hurting on modern x86 CPUs - dont both CPU makers optimize them pretty 
> efficiently? (as long as the target function is always the same - which 
> it is here.)

I think a lot of CPUs do. I think ia64 does not. It predicts
based on the contents of a branch target register which has to
be loaded I presume before instructoin fetch reaches the branch.
I don't know if this would hurt or not.


> > I must say that I don't really like the indirect calls a great deal, 
> > and they could be eliminated just with a couple of branches and direct 
> > calls.
> 
> yeah - i'll try that too. We can make the indirect call the uncommon 
> case and a NULL pointer be the common case, combined with a 'default', 
> direct function call. But i doubt it makes a big (or even measurable) 
> difference.

You might be right there.
