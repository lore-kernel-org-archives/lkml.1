Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZCBVmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZCBVmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZCBVmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:42:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:42864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZCBVmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:42:06 -0500
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
In-Reply-To: <200903021337.20887.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200903021304.56881.david-b@pacbell.net> <1236028617.18955.14.camel@twins>
	 <200903021337.20887.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 22:41:46 +0100
Message-Id: <1236030106.5330.1553.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 13:37 -0800, David Brownell wrote:

> > How so?, its the natural extension of that work.
> 
> Not the work to shrink the amount of time IRQ latencies
> by shrinking the amount of time IRQs are disabled by
> IRQ handlers.

Ugh, that's done by pushing work out of the hardirq context, not by
doing silly things like enabling irqs from hardirq context.

> > > > we should simply always disable interrupts for 
> > > > interrupt handlers.
> > > 
> > > That would be why you have refused to fix the bug
> > > in lockdep, whereby it forcibly enables that flag?
> > > 
> > > I've been wondering for some months now why you've
> > > left that bug unfixed.
> > 
> > Because running irq handlers with irqs enabled it plain silly.
> 
> Not if you have hardware-prioritized IRQs, which are
> fairly common in some environments ... handling an IRQ
> for high priority device A needn't interfere with the
> handler for lower priority device B, and the system
> overall can work better.
> 
> Not if you need to shrink IRQ latencies by minimizing
> irqs-off critical sections everywhere ... IRQ handlers
> being common offenders for keeping IRQs off too long.
> 
> Not when IRQs can be disabled selectively around the
> real critical sections ... so drivers can leave IRQs
> enabled except in those brief sections.

Yeah, and who gets to debug the stack overflow?

Hardware with irq prio levels can do a prio mask and use a stack per
prio level.

