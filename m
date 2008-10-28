Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYJ1Rha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYJ1Rha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYJ1RhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:37:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJ1RhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:37:21 -0400
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200810281022.42803.david-b@pacbell.net>
References: <200810271426.27110.david-b@pacbell.net>
	 <1225213442.15763.20.camel@lappy.programming.kicks-ass.net>
	 <200810281022.42803.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:36:56 +0100
Message-Id: <1225215416.15763.32.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 10:22 -0700, David Brownell wrote:
> On Tuesday 28 October 2008, Peter Zijlstra wrote:
> > On Mon, 2008-10-27 at 14:26 -0700, David Brownell wrote:
> > > From: David Brownell <dbrownell@users.sourceforge.net>
> > > 
> > > Lockdep reported a problem in the at91_mci driver ... in this case, the
> > > issue is with lockdep, not with the driver. ...
> > > 
> > > When __flush_dcache_aliases() returns -- inlined into flush_dcache_page(),
> > > above -- it re-enables IRQs ... since that evidently may only be called with
> > > IRQs enabled.  That's OK since the (unshared) IRQ handler doesn't ask for IRQs
> > > to be disabled.   Except ... that lockdep went and disabled them, then went on
> > > to complains about the breakage *it* caused!
> > > 
> > > Workaround: depend on LOCKDEP=n ... 
> > 
> > In all previous such cases it was deemed the IRQ handler should deal
> > with whatever it gets.
> 
> In which case I'll wait until someone changes that IRQ handler (or that
> ARM MM utility, or lockdep), and give up using AT91 platforms for sanity
> testing kernel changes; lockdep is important, when it doesn't lie.
> 
> I do think that lockdep should warn when that it's ignoring such driver
> requests, however.  I seem to have been tripping over it a lot lately,
> and knowing that IRQ handlers were using strange modes would have saved
> a bunch of time from being wasted.
> 
> Threaded IRQ handlers are going to need to rely even more on running
> with IRQs enabled ... not to mention needing to sleep.  So it's clear
> to me that there *are* lockdep issues yet to be adressed here.

Sure, care so send a patch fixing those? :-)

