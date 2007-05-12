Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbXELPLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbXELPLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbXELPLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:11:47 -0400
Received: from www.osadl.org ([213.239.205.134]:46953 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755749AbXELPLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:11:46 -0400
Subject: Re: clockevent questions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
References: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 12 May 2007 17:14:52 +0200
Message-Id: <1178982892.22481.183.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis,

On Sat, 2007-05-12 at 16:54 +0200, Francis Moreau wrote:
> I'm trying to use clocksource and clockevent new subsystem. My
> platform has a timer that I'd like to use both as a clocksource and a
> clockevent devices.

See arch/i386/kernel/hpet.c

> This timer is continueous in sense that it can run
> without any interruption

-ENOPARSE

Has your timer a free running counter and a match register based event
mechanism ?

> so I assume I can flag the clocksource device
> with "CLOCK_SOURCE_IS_CONTINUOUS". However I noticed that clockevent
> device can be stopped by using "set_mode()" method. Are these two
> behaviours compatible ?

the clock event stop only stops the event mechanism, it does not stop
the counter.

See arch/i386/kernel/hpet.c

> Another question is that I have another embedded 16 bits timer that I
> would like to use. Since the timer is only 16 bits, the maximum
> interval is tiny, My question if a user ask for a clockevent device
> using an interval is bigger that 2^16, the clockevent system doesn't
> return an error. Instead it silently reduce the interval to 2^16. Is
> this correct ? if so why ?

Yes, it is correct. The generic timer code requests an event in the
future. It does not care, whether the hardware device can handle that or
not. So the clock event code limits the delta to the maximum delta the
device can handle. The interrupt fires and the generic timer code
reschedules the event with the remaining delta time.

	tglx


