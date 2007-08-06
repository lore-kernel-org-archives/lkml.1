Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbXHFLHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbXHFLHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764132AbXHFLG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:06:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49320 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759225AbXHFLG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:06:57 -0400
Date: Mon, 6 Aug 2007 11:55:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: trenn@suse.de, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070806095504.GA1934@elf.ucw.cz>
References: <46B1988C.3090302@t-online.de> <20070802183830.GA4192@one.firstfloor.org> <1186139818.18821.590.camel@queen.suse.de> <200708031459.07108.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708031459.07108.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If we have something like this, we could still discuss a config option,
> > that also allows to increase trip points, marking it with "If you set
> > this you can destroy your machine, you have been warned...". While this
> > would not be an option for distributions to compile in, some people may
> > come around the biggest hammer -> overriding DSDT.
> > 
> > I cannot promise, but I try to get this for 2.6.24.
> 
> I think if you are enamored with overriding trip points at SuSE,
> that you should simply restore the original scheme as the "value add"
> for SuSE kernels.  Seriously, I'm totally fine with that.
> 
> You should be aware, however, that (one of) the fundamental flaws
> with that scheme, shared with what you describe above, is that the OS
> can not actually change the trip points in the thermal sensor.
> The sensor is going to trip at the temperature that _it_ thinks

Yep, you work around this one by enabling polling.

> This faking out the user, plus the fact that the BIOS does change
> trip-points at run-time, made the original scheme fundamentally
> unsound.  Further, I've not yet found a single system where use

Yes, this one is uglier. But maybe "enable polling automatically +
ignore any updates from bios" (+ maybe "only enable lowering") is
better solution than "just remove the knob"? After all, "the knob" is
still useful for debugging at least.

> of this scheme wasn't papering over some other problem.  For the
> upstream kernel, I think it is more appropriate to expose and fix
> the fundamental problems.  For distro kernels, I'm less concerned
> if you hide bugs instead of fixing them.

This is okay as long as you are willing to work around the fundamental
problems in kernel. You are unable to _fix_ them. They are broken
BIOSes.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
