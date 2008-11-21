Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbYKURXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbYKURXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYKURXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:23:05 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53247 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753896AbYKURXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:23:03 -0500
Date: Fri, 21 Nov 2008 11:23:02 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 1/2 v3] SGI RTC: add clocksource driver
Message-ID: <20081121172302.GD12370@sgi.com>
References: <20081023163041.GA14574@sgi.com> <20081119212202.GA3377@sgi.com> <20081119212350.GB3377@sgi.com> <20081120150813.d7d1901e.akpm@linux-foundation.org> <1227226089.6921.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227226089.6921.13.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

Thanks for the reply.  I will address this in forthcoming patchsets.

On Thu, Nov 20, 2008 at 04:08:08PM -0800, john stultz wrote:
> On Thu, 2008-11-20 at 15:08 -0800, Andrew Morton wrote:
> > On Wed, 19 Nov 2008 15:23:50 -0600
> > Dimitri Sivanich <sivanich@sgi.com> wrote:
> > 
> > > This patch provides a driver for SGI RTC clocks and timers.
> > > 
> > > This provides a high resolution clock and timer source using the SGI
> > > system-wide synchronized RTC clock/timer hardware.
> [snip]
> > > +static struct clocksource clocksource_uv = {
> > > +	.name		= RTC_NAME,
> > > +	.rating		= 400,
> > > +	.read		= uv_read_rtc,
> > > +	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
> > > +	.shift		= 0,
> > > +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> > > +};
> 
> Hey Dimitri,
> 	One issue with this clocksource is the shift value. The clocksource
> frequency is calculated from the mult/shift pair (f = mult/2^shift).
> When NTP steers the clock in the generic timekeeping code, it does so by
> tweaking the mult value up or down. However if the shift value is too
> low, that ends up being quite a large change to the frequency.
> 
> So in order to get fine grained frequency adjustments I'd recommend
> using a larger shift value (8 at least). Ideally you want the largest
> shift value possible, but some care is needed that it isn't too big,
> because larger shift values mean larger mult values, and you don't want
> to overflow on the multiplication.
> 
> A rule of thumb I use is to find a shift value so the resulting mult
> value won't overflow 1 second worth of cycles.
> 
