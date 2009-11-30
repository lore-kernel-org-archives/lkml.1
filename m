Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbZK3VrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbZK3VrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZK3VrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:47:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:51741 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZK3VrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:47:12 -0500
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
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
In-Reply-To: <alpine.LFD.2.00.0911302225050.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
	 <1259589780.26472.18.camel@laptop>
	 <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
	 <1259611151.2076.101.camel@pasglop>
	 <alpine.LFD.2.00.0911302225050.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 08:42:11 +1100
Message-ID: <1259617331.2076.146.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 22:31 +0100, Thomas Gleixner wrote:

> Are the perf events on power generally coming through the standard irq
> handler code path and/or sensitive to local_irq_disable() ?

They are in HW yes. On ppc64, we do soft-disabling, which mean that we
can still get the perf events within a local_irq_disable() region
provided we don't get another interrupt within that region that forces
us to hard disable so it would make the problem less bad I suppose.

> > I would suggest we timestamp the handlers in the core btw and warn
> if
> > they take too long so we get a chance to track down the bad guys.
> 
> The hassle is to find a time which we think is appropriate as a
> threshold which is of course depending on the cpu power of a
> system. Also I wonder whether we'd need to make such a warning thing
> aware of irq nesting.

But if we always disable interrupts while running the handlers, we don't
nest right ?

Cheers,
Ben.

