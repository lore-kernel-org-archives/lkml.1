Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYIJIiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYIJIiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYIJIiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:38:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46903 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYIJIiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:38:04 -0400
Date: Wed, 10 Sep 2008 10:37:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's
	mmap_sem...
Message-ID: <20080910083749.GH15255@elte.hu>
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com> <200809101407.16323.nickpiggin@yahoo.com.au> <1221033455.31904.1221.camel@twins.programming.kicks-ass.net> <200809101803.20758.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101803.20758.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 10 September 2008 17:57, Peter Zijlstra wrote:
> > On Wed, 2008-09-10 at 14:07 +1000, Nick Piggin wrote:
> > > On Wednesday 10 September 2008 07:03, Daniel J Blueman wrote:
> > > > I observed this locking violation [1] while gnome-panel was loading;
> > > > this was previously reported at
> > > > http://uwsg.iu.edu/hypermail/linux/kernel/0806.3/2881.html .
> > > >
> > > > Let me know for more information/config/testing. Thanks!
> > >
> > > Thanks for the report. I've attached a patch you could test. It compiles
> > > (and boots a UML here) but I don't think I've actually tested the inotify
> > > path at all, so it may explode on you.
> > >
> > > Peter, this copy_*_user stuff is quite a nightmare... Well actually it
> > > isn't, if the code is designed with it in mind from the start, but it is
> > > easy for people to forget it can take mmap_sem and filesystem locks... Is
> > > there a way to annotate it and say "might take mmap_sem for read" for
> > > example? So that these LORs will _always_ trigger rather than just once
> > > in a million times when the reclaim gods frown on us?
> >
> > Sure, how about the below - untested - uncompiled, might eat kittens,
> > etc..
> >
> > Just sprinkle something like:
> >
> >   might_lock_read(&mm->mmap_sem);
> >
> > in the right places.
> 
> Ahh, very nice, thanks! I'll give that a try...

cool! Please send in an RFC patch once you have something that boots - 
we can stick it into tip/core/locking and see whether there's any new 
messages on a wide range of systems and workloads. (and we'd also check 
whether the number of kittens is an invariant.)

	Ingo
