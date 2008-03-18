Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYCRC2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYCRC2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 22:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYCRC1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 22:27:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41723 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYCRC1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 22:27:52 -0400
Subject: Re: [PATCH 2/5] introduce CLOCK_MONOTONIC_RAW
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1205805818.28128.91.camel@localhost>
References: <1205553852.6122.76.camel@localhost.localdomain>
	 <1205553938.6122.79.camel@localhost.localdomain>
	 <1205554018.6122.81.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0803150536290.1791@scrub.home>
	 <1205805818.28128.91.camel@localhost>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 19:27:50 -0700
Message-Id: <1205807270.28128.96.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-17 at 19:03 -0700, john stultz wrote:
> On Sat, 2008-03-15 at 05:50 +0100, Roman Zippel wrote:
> > > @@ -439,6 +475,7 @@ static void clocksource_adjust(s64 offset)
> > >  void update_wall_time(void)
> > >  {
> > >  	cycle_t offset;
> > > +	static u64 raw_snsec; /* shifted raw nanosecnds */
> > >  
> > >  	/* Make sure we're fully resumed: */
> > >  	if (unlikely(timekeeping_suspended))
> > 
> > IMO that's really a clock property, so this belongs in the clock 
> > structure.
> > (Some day we may want to have multiple active clocks for various purposes 
> > and thus export multiple raw clocks.)
> 
> I disagree. I think that crufts up the clocksource structure (which is
> ideally just a simple hw counter abstraction), with timekeeping state.

Bah. Ok, I've talked myself out of this one. 

I still think it crufts up the clocksource structure, but its more
consistent that we follow the established cruft (such as the
pre-calculated cycle_interval/xtime_interval/raw_interval combo) rather
then me trying to arbitrarily draw the line in the sand at this
variable.


> I'm still not sold on the multiple clocks with multiple notions of time
> idea you keep on bringing up. But if/when we cross that bridge, maybe it
> would be better to add a timekeeping_clock mid-layer abstraction that
> keeps the clocksource specific timekeeping state. That way we don't add
> lots of complexity for the clocksource driver writers to deal with and
> we allow the clocksources to be better re-purposed (for maybe more sane
> things like performance counters) without getting too bloated.

I still think pulling out all of the non-counter-abstraction bits out of
the clocksource and into a mid-level timekeeping_clock structure would
still be ideal here, but I'll save our time/energy on that one for
another day. :)

thanks
-john


