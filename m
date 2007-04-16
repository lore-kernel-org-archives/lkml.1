Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbXDPC33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbXDPC33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 22:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbXDPC33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 22:29:29 -0400
Received: from mail.suse.de ([195.135.220.2]:35233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbXDPC32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 22:29:28 -0400
Date: Mon, 16 Apr 2007 04:28:38 +0200
From: Nick Piggin <npiggin@suse.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Jonathan Lundell <linux@lundell-bros.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Willy Tarreau <w@1wt.eu>, hui Bill Huey <billh@gnuppy.monkey.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416022838.GA13626@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <Pine.LNX.4.64.0704151054080.5473@woody.linux-foundation.org> <6741477B-4621-4A50-952E-0D03260D9526@lundell-bros.com> <200704160852.34241.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704160852.34241.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 08:52:33AM +1000, Con Kolivas wrote:
> On Monday 16 April 2007 05:00, Jonathan Lundell wrote:
> > On Apr 15, 2007, at 10:59 AM, Linus Torvalds wrote:
> > > It's a really good thing, and it means that if somebody shows that
> > > your
> > > code is flawed in some way (by, for example, making a patch that
> > > people
> > > claim gets better behaviour or numbers), any *good* programmer that
> > > actually cares about his code will obviously suddenly be very
> > > motivated to
> > > out-do the out-doer!
> >
> > "No one who cannot rejoice in the discovery of his own mistakes
> > deserves to be called a scholar."
> 
> Lovely comment. I realise this is not truly directed at me but clearly in the 
> context it has been said people will assume it is directed my way, so while 
> we're all spinning lkml quality rhetoric, let me have a right of reply.
> 
> One thing I have never tried to do was to ignore bug reports. I'm forever 
> joking that I keep pulling code out of my arse to improve what I've done. 
> RSDL/SD was no exception; heck it had 40 iterations. The reason I could not 
> reply to bug report A with "Oh that is problem B so I'll fix it with code C" 
> was, as I've said many many times over, health related. I did indeed try to 
> fix many of them without spending hours replying to sometimes unpleasant 
> emails. If health wasn't an issue there might have been 1000 iterations of 
> SD.

Well what matters is the code and development. I don't think Ingo's
scheduler is the final word, although I worry that Linus might jump the
gun and merge something "just to give it a test", which we then get
stuck with :P

I don't know how anybody can think Ingo's new scheduler is anything but
a good thing (so long as it has to compete before being merged). And
that's coming from someone who wants *their* scheduler to get merged...
I think mine can compete ;) and if it can't, then I'd rather be using
the scheduler that beats it.


> There was only ever _one_ thing that I was absolutely steadfast on as a 
> concept that I refused to fix that people might claim was "a mistake I did 
> not rejoice in to be a scholar". That was that the _correct_ behaviour for a 
> scheduler is to be fair such that proportional slowdown with load is (using 
> that awful pun) a feature, not a bug.

If something is using more than a fair share of CPU time, over some macro
period, in order to be interactive, then definitely it should get throttled.
I've always maintained (since starting scheduler work) that the 2.6 scheduler
is horrible because it allows these cases where some things can get more CPU
time just by how they behave.

Glad people are starting to come around on that point.


So, on to something productive, we have 3 candidates for a new scheduler so
far. How do we decide which way to go? (and yes, I still think switchable
schedulers is wrong and a copout) This is one area where it is virtually
impossible to discount any decent design on correctness/performance/etc.
and even testing in -mm isn't really enough.

