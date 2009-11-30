Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbZK3O0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbZK3O0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZK3O0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:26:18 -0500
Received: from www.tglx.de ([62.245.132.106]:46610 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZK3O0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:26:17 -0500
Date: Mon, 30 Nov 2009 15:24:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
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
       linux-arm-kernel@lists.infradead.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
In-Reply-To: <1259589780.26472.18.camel@laptop>
Message-ID: <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>  <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>  <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain> <1259589780.26472.18.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Peter Zijlstra wrote:
> On Mon, 2009-11-30 at 14:54 +0100, Thomas Gleixner wrote:
> > The correct solution IMNSHO is to get rid of IRQF_DISABLED and run
> > interrupt handlers always with interrupts disabled and require them
> > not to reenable interrupts themself.
> > 
> > Thoughts ?
> 
> I'm all for removing that brain damage:
> 
>   http://lkml.org/lkml/2009/3/2/33

Darn, I knew that we discussed that before, but my memory tricked me
into believing that it was years ago :)

> We should convert the broken hardware PIO and 3com interrupt things to
> threaded interrupts, and simply mandate all IRQ handlers run short and
> with IRQs disabled.

The ide stuff seems to be the only one which uses
local_irq_enable_in_hardirq() so that at least it tripped over lockdep
already.

What's the 3com wreckage about ?

> Except I guess that will upset some of the IRQ priority folks, like
> power, where they (iirc) have a stack per irq prio level.

Is that actually used ? Ben ?
 
> But its not like the core kernel knows about these nesting rules and can
> actually track any of that muck.

True.

	tglx
 
