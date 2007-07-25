Return-Path: <linux-kernel-owner+w=401wt.eu-S934926AbXGYSal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926AbXGYSal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932999AbXGYSaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:30:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3019 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761083AbXGYSaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:30:10 -0400
Date: Wed, 25 Jul 2007 14:18:14 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dor Laor <dor.laor@qumranet.com>, Avi Kivity <avik@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070725141813.GE9256@ucw.cz>
References: <005901c7c921$79c006c0$6d401440$@com> <20070718123040.615795b7@the-village.bc.nu> <64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net> <20070718174736.0baf6d0e@the-village.bc.nu> <469E43D5.70802@qumranet.com> <64F9B87B6B770947A9F8391472E032160CC16D06@ehost011-8.exch011.intermedia.net> <20070718183358.0a0886aa@the-village.bc.nu> <64F9B87B6B770947A9F8391472E032160CC16F3C@ehost011-8.exch011.intermedia.net> <20070718224649.3e49a978@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718224649.3e49a978@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I guess this will also allow UIO to work without _any_ kernel parts,
with only slight performance penalty in 'almost-never-happens'
deadlock case?

(Greg, details are below, and better description is in the lkml
thread).
							Pavel

> > - Our dummy handler will always return IRQ_HANDLED in case any other
> > previous
> >   irqaction did not return such. It will also issue the timer and mask
> > the irq in this case.
> 
> Ok
> 
> >   btw, if I'm not mistaken only after bad 99900/100000 the irq is
> > disabled.
> 
> (and with GIT providing that they occurred in a short time period)
> 
> > - If the timer pops before the guest acks the irq, the timer handler
> > will
> >   ack the irq and unmask it. The timer's job is only to prevent
> > deadlocks.
> 
> Ok I see what you are doing. It's either inspired or insane and I am not
> quite sure which of the two. I agree it should work although may cause
> performance crunches now and then and will also need care getting the
> locking right.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
