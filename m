Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbYCUSGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbYCUSGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbYCUSGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:06:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2111 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756239AbYCUSGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:06:01 -0400
Date: Fri, 21 Mar 2008 14:05:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jean Delvare <khali@linux-fr.org>, Michael Buesch <mb@bu3sch.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
In-Reply-To: <20080321103732.ea08e189.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0803211343240.24421-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Andrew Morton wrote:

> On Fri, 21 Mar 2008 10:53:11 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> 
> > On Thu, 20 Mar 2008 20:17:23 -0700, Andrew Morton wrote:
> > > in_atomic() is for core kernel use only.  (...)
> > 
> > Then why is it made available to drivers through <linux/hardirq.h>?
> 
> Because we suck.
> 
> > If
> > it's such a dangerous macro to call from drivers, it shouldn't be made
> > available, or at the very least there should be a big fat warning in
> > <linux/hardirq.h> that drivers aren't supposed to use it. This would
> > have avoided the 23 uses cases in drivers we have right now.
> 
> True.

There's also a section about in_atomic() in the Linux Device Drivers 
(3rd ed.) book which may have contributed to the confusion.  On p. 198:

	A function related to in_interrupt() is in_atomic().  Its 
	return value is nonzero whenever scheduling is not allowed;
	this includes hardware and software interrupt contexts as well
	as any time when a spinlock is held.  In the latter case, 
	current may be valid, but access to user space is forbidden, 
	since it can cause scheduling to happen.  Whenever you are
	using in_interrupt(), you should really consider whether 
	in_atomic() is what you actually mean.  Both functions are
	declared in <asm/hardirq.h>.

Alan Stern

