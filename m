Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbXBQEgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbXBQEgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 23:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965014AbXBQEgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 23:36:05 -0500
Received: from beta2.look.ca ([207.136.100.3]:48589 "EHLO twiddle.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965010AbXBQEgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 23:36:04 -0500
Date: Fri, 16 Feb 2007 23:36:57 -0500
To: Daniel Walker <dwalker@mvista.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <20070217043657.GB10754@infidigm.net>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <1171647921.3422.12.camel@imap.mvista.com> <20070216181027.GC6425@infidigm.net> <1171650530.3422.25.camel@imap.mvista.com> <20070216193428.GE6425@infidigm.net> <1171659979.3422.60.camel@imap.mvista.com> <20070216221022.GA8721@infidigm.net> <1171666065.3422.92.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1171666065.3422.92.camel@imap.mvista.com>
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: Re: Using sched_clock for mmio-trace
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 02:47:45PM -0800, Daniel Walker wrote:
> > > Gets pretty ugly .. The clocksource interface already has a positive
> > > rating to describe the "best" clocks in the system, which is used to
> > > return the "best" clock .. Where the maintainers of the system give each
> > > clock a rating. I would imagine most people would just get the so called
> > > "best" clock which has the best rating..
> > > 
> > > I'm starting to think this long flags stringing effect could happen with
> > > negative flags also, but it's seems a lot less likely.
> > 
> > The amount of flag stringing should be the same.
> 
> I don't think so .. The common case with negative flags is no flags,
> then next would be CLOCKSOURCE_UNSTABLE. At most I would guess two
> flags .. The other direction your likely to have people using all flags
> most of the time. That's why I showed a function call with all the flags
> listed.

I think you still misunderstand me. The common case is still no flags.

clocksource_get_clock_must_have(0) would return clocks that are stable
and unstable. clocksource_get_clock_must_have(CLOCKSOURCE_STABLE) would
only return clocks that are stable, just like
clocksource_get_clock_masked(CLOCKSOURCE_UNSTABLE) only returns clocks
that are stable.

> > > > instead of
> > > > 
> > > > clocksource_get_clock_masked(CLOCKSOURCE_UNSTABLE)
> > > > clocksource_get_clock_masked(CLOCKSOURCE_PM_AFFECTED)
> > > > 
> > > > Especially awkward is the CLOCKSOURCE_64BIT flag, as there isn't really
> > > > anyway to specify that I want a 64bit timer, only a way to specify that
> > > > I don't.
> > > 
> > > I might add a way to get specific flags, but I still think the flags
> > > should be mostly negative features.
> > 
> > Yeah, the problem is that all of the features are negative except for
> > CLOCKSOURCE_64BIT, so you can't mask for it.
> 
> It's meant as a negative feature. So you can mask it if you can't handle
> the math .. The only 64bit clock I know off is the tsc, and it's got the
> highest rating of all clocks.

Ah ok, I see that now. Maybe CLOCKSOURCE_OVER_32BITS would be a better
name? It might convey the negativity better...

-Jeff
