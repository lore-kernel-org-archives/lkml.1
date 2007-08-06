Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbXHFAJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbXHFAJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 20:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXHFAJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 20:09:04 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3403 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757567AbXHFAJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 20:09:03 -0400
Date: Mon, 6 Aug 2007 02:09:24 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <1186255149.2777.3.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0708060150270.1817@scrub.home>
References: <15327.1186166232@lwn.net>  <Pine.LNX.4.64.0708032116340.1817@scrub.home>
  <1186170407.3153.8.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708032152060.1817@scrub.home>
  <1186185229.3153.11.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708040345530.1817@scrub.home>
 <1186255149.2777.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 4 Aug 2007, Arjan van de Ven wrote:

> > hr_msleep makes no sense. Why should we tie this interface to millisecond 
> > resolution?
> 
> because a lot of parts of the kernel think and work in milliseconds,
> it's logical and USEFUL to at least provide an interface that works on
> milliseconds.

If the millisecond resolution is enough for these users, that means the 
current msleep will work fine for them.

> > Your suggested msleep_approx makes not much sense to me either, since 
> > neither interface guarantees anything and may "approximate" the sleep 
> > (and if the user is surprised by that something else already went wrong).
> 
> an interface should try to map to the implementation that provides the
> best implementation quality of the requested thing in general. That's
> the hrtimers based msleep().

This generalization is simply not true. First it requires the 
HIGH_RES_TIMERS option to be enabled to really make a real difference. 
Second a hrtimers based msleep has a higher setup cost, which can't be 
completely ignored. "Best" is a subjective term here and can't be that 
easily generalized to all current users.

> > If you don't like the hrsleep name, we can also call it nanosleep and so 
> > match what we already do for userspace.
> 
> having a nanosleep *in addition* to msleep (or maybe nsleep() and
> usleep() to have consistent naming) sounds reasonable to me.

We only need one sleep implementation of both and msleep is a fine name 
for the current implementation - not only does it describe the unit, but 
it also describe the best resolution one can expect from it.

> Do you have something against hrtimer use in general? From your emails
> on this msleep topic it sort of seems you do.... 

I can give the question back, what do you have against simple timers, that 
you want to make them as awkward as possible to use?
hrtimer have a higher usage cost depending on the clock source, so simply 
using them only because they are the new cool kid in town doesn't make 
sense. It may not be that critical for a simple sleep implementation, but 
that only means we should keep the API as simple as possible, that means 
one low resolution, cheap msleep and one high resolution nanosleep is 
enough. Why do you insist on making more complex than necessary?

bye, Roman
