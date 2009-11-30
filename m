Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZK3Oku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZK3Oku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZK3Okt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:40:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45533 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbZK3Oks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:40:48 -0500
Date: Mon, 30 Nov 2009 14:39:56 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
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
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
	IRQF_SHARED|IRQF_DISABLED)
Message-ID: <20091130143956.GA8227@n2100.arm.linux.org.uk>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain> <20091130143703.GA7028@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130143703.GA7028@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 02:37:03PM +0000, Russell King - ARM Linux wrote:
> Now, at the risk of covering old ground, how about we have two separate
> irqaction lists, one for handlers to be called with irqs disabled and
> one for handlers with irqs enabled.  We run the irqs-disabled list
> first, naturally with irqs disabled.  If, at the end of that run (or
> maybe after each handler), IRQs have ended being enabled, print some
> diagnostics.  (We're going to need something like this to ensure that
> drivers interrupt handlers don't enable IRQs themselves.)  Then enable
> IRQs and run the irqs-enabled chain.

Oh, and the other interesting thing to do may be to have a way of
measuring how much time irq handlers run for, so that handlers taking
an excessive time (more than 0.5ms or so - thinking about the 1000Hz
timer rate found on some arches) can be targetted.
