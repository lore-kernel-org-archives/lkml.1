Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZK3WBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZK3WBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZK3WBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:01:31 -0500
Received: from www.tglx.de ([62.245.132.106]:55274 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZK3WBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:01:30 -0500
Date: Mon, 30 Nov 2009 22:59:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       Jamie Lokier <jamie@shareable.org>, LKML <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
In-Reply-To: <20091130145122.7057a1e3@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0911302255590.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain> <20091130143703.GA7028@n2100.arm.linux.org.uk>
 <20091130145122.7057a1e3@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Alan Cox wrote:

> > However, I think we still have a number of corner cases.  The SMC91x
> > driver comes to mind, with its stupidly small FIFOs, where the majority
> > of implementations have to have the packets loaded via PIO - and this
> > seems to generally happen from IRQ context.
> 
> Everything 8390 based is in the same boat. It relies on being able to
> use disable_irq_nosync/enable_irq and knows all about the joys of
> interrupt bus asynchronicity internally. That does however allow it to
> get sane results by using the irq controller to mask the potentially
> shared IRQ at source.

So that would be a known candidate for IRQF_NEEDS_IRQS_ENABLED, right?

Either that or we decide to push such beasts into the threaded irq
space to keep them working until the last card hits the trashcan. I
know that this would still need to disable the interrupt on the PIC
level, but we have already mechanisms for that in the threaded code.

Thanks,

	tglx



