Return-Path: <linux-kernel-owner+w=401wt.eu-S2992652AbXCBRYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992652AbXCBRYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992655AbXCBRYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:24:47 -0500
Received: from 206-72-67-168.dsl.dock.net ([206.72.67.168]:35595 "EHLO
	elektro.pacujo.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992652AbXCBRYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:24:46 -0500
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is the clockevent resolution fine-grained enough?
References: <m3649kweyj.fsf@elektro.pacujo.net>
	<1172851546.24738.62.camel@localhost.localdomain>
Date: 02 Mar 2007 09:24:44 -0800
In-Reply-To: <1172851546.24738.62.camel@localhost.localdomain>
Message-ID: <m3k5xzy2w3.fsf@elektro.pacujo.net>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Delivery-Agent: TMDA/1.0.3 (Seattle Slew)
From: Marko Rauhamaa <marko@pacujo.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de>:

> On Thu, 2007-03-01 at 18:34 -0800, Marko Rauhamaa wrote:
> > It would appear the new clockevent API has a one-nanosecond
> > resolution. It certainly looks sufficiently fine-grained, but I'm
> > afraid it's too coarse for some applications.
> 
> That's an academic exercise, or are you talking about some real world
> hardware which runs Linux ?

Real hardware running linux.

> > In our application, we need periodic clock interrupts at about 100
> > kHz.
> 
> With a stock kernel ?

Well, with a "clockevent" patch of our own. We'd like to use a stock
kernel, though.

> > If the (programmable) frequency must be rounded to the nearest
> > nanosecond, we have a cumulative error of
> > 
> >    100,000 * 0.5 ns/s = 50 µs/s
> 
> clockevents is based on the monotonic system clock and depends on the
> accuracy of that and the device which deliveres the interrupts.
> [...]
> There is nothing to nugde. The clockevent subsystem operates on
> absolute time, so there is no cummulative error, except you setup your
> timers relative per event.

I'm afraid you didn't quite understand what I was getting at. Say the
user programs the frequency to be 109,000 Hz. That means a nominal clock
interval of ~9174.3119 ns. Now the clockevent interface forces me to
round it down to 9174 ns. That means the clock interrupts fall behind
with respect to the other parts in the system that implement 109,000 Hz
much more to the letter. The error grows by 34 µs every second so that
after 8 hours, we are lagging by a whole second.


Marko

-- 
Marko Rauhamaa      mailto:marko@pacujo.net     http://pacujo.net/marko/
