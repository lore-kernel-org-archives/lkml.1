Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZCBWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZCBWUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZCBWUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:20:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbZCBWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:20:03 -0500
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: dbrownell@users.sourceforge.net
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
In-Reply-To: <200903021409.21344.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200903021337.20887.david-b@pacbell.net>
	 <1236030106.5330.1553.camel@laptop>
	 <200903021409.21344.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 23:19:31 +0100
Message-Id: <1236032371.5330.1654.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 14:09 -0800, David Brownell wrote:
> On Monday 02 March 2009, Peter Zijlstra wrote:
> > > > How so?, its the natural extension of that work.
> > > 
> > > Not the work to shrink the amount of time IRQ latencies
> > > by shrinking the amount of time IRQs are disabled by
> > > IRQ handlers.
> > 
> > Ugh, that's done by pushing work out of the hardirq context,
> 
> That's one of many techniques currently used.
> 
> Tradeoffs don't always favor larger driver updates
> and re-validation though.  Sometimes it's simpler
> to just leverage the reality that "hardirq context"
> does not require using IRQF_DISABLED.

Simpler doesn't mean its a good idea, it opens the door to stack
overruns for one.

Its very unfortunate that people think its a good idea.

> > not by doing silly things like enabling irqs from hardirq context.
> 
> Somehow I'm certain you have NOT analysed every one of the
> thousands of IRQ handlers in various Linux drivers to know
> with certainty that's not the reason IRQ_DISABLED is cleared.
> 
> There are also *other* reasons to leave IRQ_DISABLED clear.

There might be reasons to do so, that doesn't mean its a good idea and
the desired thing to do.

I state that every !IRQF_DISABLED usage is a bug, either due to broken
hardware or broken drivers.

