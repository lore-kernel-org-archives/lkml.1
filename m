Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZK3PdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZK3PdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZK3PdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:33:02 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42621 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752107AbZK3PdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:33:01 -0500
Date: Mon, 30 Nov 2009 15:32:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       Jamie Lokier <jamie@shareable.org>, LKML <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Uwe =?ISO-8859-14?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
Message-ID: <20091130153223.0e510a9b@lxorguk.ukuu.org.uk>
In-Reply-To: <20091130150100.GB7028@n2100.arm.linux.org.uk>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
	<1259589780.26472.18.camel@laptop>
	<alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
	<20091130144702.14bea0ee@lxorguk.ukuu.org.uk>
	<20091130150100.GB7028@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 15:01:00 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Nov 30, 2009 at 02:47:02PM +0000, Alan Cox wrote:
> > SHARED|DISABLED ought to WARN_ON() and if that doesn't motivate people
> > then return -EINVAL.
> 
> That is an impossibility.  There is hardware out there (AT91) where
> the timer interrupt is shared with other peripherals, and you end
> up with a mixture of irqs-disabled and irqs-enabled handlers sharing
> the same interrupt.

Well that will encourage people to fix it.

> My point is that if we outlaw irqs-disabled shared interrupts, it puts
> Atmel AT91 support into immediate difficulties.

If a driver disables the timer irq across a tick aren't you already in
trouble ?

