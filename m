Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZLABoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZLABoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 20:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZLABoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 20:44:05 -0500
Received: from mail1.radix.net ([207.192.128.31]:40063 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZLABoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:44:05 -0500
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
From: Andy Walls <awalls@radix.net>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <200911301238.35750.david-b@pacbell.net>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
	 <20091130144702.14bea0ee@lxorguk.ukuu.org.uk>
	 <200911301238.35750.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 30 Nov 2009 20:42:53 -0500
Message-Id: <1259631774.3099.26.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 12:38 -0800, David Brownell wrote:
> On Monday 30 November 2009, Alan Cox wrote:
> > SHARED|DISABLED ought to WARN_ON() and if that doesn't motivate people
> > then return -EINVAL. And with any luck that'll prove 6 months later that
> > most of the offenders are not used and we can delete them wholesale.
> 
> So ... merge an updated version of the original patch, to
> get full WARN coverage?
> 
> We've had that warning for a long time now.  The original
> patch just covered non-request_irq() cases.  So by your
> timetable we're ready for the "return -EINVAL" stage of
> the migration... at least, for request_irq() callers.

OK, I'm motivated.  I haven't followed the discussion closely though.

Can someone give me a clue as to the preferred way to correct this:

        /* Register IRQ */
        retval = request_irq(cx->pci_dev->irq, cx18_irq_handler,
                             IRQF_SHARED | IRQF_DISABLED,
                             cx->v4l2_dev.name, (void *)cx);


?
The top half handler performs as little work as it possibly can and
schedules the long duration activites on a workqueue already.

The device is always on a plug-in PCI card.

Regards,
Andy

