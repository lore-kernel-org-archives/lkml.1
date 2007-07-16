Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbXGPQzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbXGPQzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759812AbXGPQy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:54:56 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1249 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbXGPQyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:54:55 -0400
Date: Mon, 16 Jul 2007 18:55:14 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
In-Reply-To: <20070716161025.GA1797@elte.hu>
Message-ID: <Pine.LNX.4.64.0707161829580.1817@scrub.home>
References: <21003.1184596954@lwn.net> <Pine.LNX.4.64.0707161654130.1817@scrub.home>
 <20070716161025.GA1797@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2007, Ingo Molnar wrote:

> I explained it numerous times (remember the 'timeout' vs. 'timer event' 
> discussion?) that i consider timer granularity important to scalability. 
> Basically, in every case where we know with great certainty that a 
> time-out will _not_ occur (where the time-out is in essence just an 
> exception handling mechanism), using struct timer_list is the best 
> solution.

Whether the timer expires or not is in many cases completely irrelevant.
You need special cases, where the timer wheel behaviour becomes an issue 
and whether hrtimer would behave any better in such situations is 
questionable.
Again, for the average user such details are pretty much irrelevant.

> what i consider harmful on the other hand are all the HZ assumptions 
> embedded into various pieces of code. The most harmful ones are design 
> details that depend on HZ and kernel-internal API details that depends 
> on HZ. Yes, NTP was such an example, and it was hard to fix, and you 
> didnt help much with that.

Stop spreading lies! :-(
One only has to look at the history of kernel/time/ntp.c
John's rather simple "HZ free ntp" patch wouldn't have been that simple 
without all the cleanup patches before that done by me, which were 
precisely intended to make this possible.

> (perhaps that is one source of this 
> increasingly testy exchange ;-)

No, it's your prejudice against me based on wrong facts.
Get your facts straight and stop being an ass.

bye, Roman
