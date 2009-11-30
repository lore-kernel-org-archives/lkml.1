Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZK3Vzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZK3Vzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZK3Vzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:55:48 -0500
Received: from www.tglx.de ([62.245.132.106]:41728 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZK3Vzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:55:47 -0500
Date: Mon, 30 Nov 2009 22:54:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
In-Reply-To: <1259617331.2076.146.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0911302253570.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>  <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>  <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>  <1259589780.26472.18.camel@laptop> 
 <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>  <1259611151.2076.101.camel@pasglop>  <alpine.LFD.2.00.0911302225050.24119@localhost.localdomain> <1259617331.2076.146.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Benjamin Herrenschmidt wrote:
> On Mon, 2009-11-30 at 22:31 +0100, Thomas Gleixner wrote:
> 
> > Are the perf events on power generally coming through the standard irq
> > handler code path and/or sensitive to local_irq_disable() ?
> 
> They are in HW yes. On ppc64, we do soft-disabling, which mean that we
> can still get the perf events within a local_irq_disable() region
> provided we don't get another interrupt within that region that forces
> us to hard disable so it would make the problem less bad I suppose.
> 
> > > I would suggest we timestamp the handlers in the core btw and warn
> > if
> > > they take too long so we get a chance to track down the bad guys.
> > 
> > The hassle is to find a time which we think is appropriate as a
> > threshold which is of course depending on the cpu power of a
> > system. Also I wonder whether we'd need to make such a warning thing
> > aware of irq nesting.
> 
> But if we always disable interrupts while running the handlers, we don't
> nest right ?

Right, in that case we do not and it's easy to instrument.

Thanks,

	tglx
