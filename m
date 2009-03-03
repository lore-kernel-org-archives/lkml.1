Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZCCTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZCCTyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCCTyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:54:09 -0500
Received: from cmpxchg.org ([85.214.51.133]:47662 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbZCCTyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:54:08 -0500
Date: Tue, 3 Mar 2009 20:54:01 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Johannes Weiner <jw@emlix.com>, Chris Zankel <chris@zankel.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] xtensa: ccount clocksource
Message-ID: <20090303195401.GA2654@cmpxchg.org>
References: <E1LeXCe-0006wA-5k@mailer.emlix.com> <E1LeXJ1-00071v-Dy@mailer.emlix.com> <1236102945.5937.1.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236102945.5937.1.camel@desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 09:55:45AM -0800, Daniel Walker wrote:
> On Tue, 2009-03-03 at 16:30 +0100, Johannes Weiner wrote:
> > @ -29,6 +30,19 @@ unsigned long ccount_per_jiffy;              /* per 
> >  unsigned long nsec_per_ccount;         /* nsec per ccount increment
> > */
> >  #endif
> >  
> > +static cycle_t ccount_read(void)
> > +{
> > +       return (cycle_t)get_ccount();
> > +}
> > +
> > +static struct clocksource ccount_clocksource = {
> > +       .name = "ccount",
> > +       .rating = 200,
> > +       .read = ccount_read,
> > +       .mask = CLOCKSOURCE_MASK(32),
> > +       .mult = NSEC_PER_CCOUNT,
> > +};
> 
> You don't want to use the shift field?

Thanks for pointing it out.

To make sure I understood this:

If shift is 0, then a walltime adjustment would be done in 1/2^0
steps, meaning an adjustment of counting one nanosecond more or less
per ccount.

To give this a finer granularity and smooth out adjustments, the shift
should be a trade-off between too much adjustment and no adjustment
progress in a sane amount of time (and, of course, to stay within
bounds of the used type).

Does that make sense?

I found a patch of yours that introduced clocksource_hz2shift() but it
seems it hasn't been merged (yet).  Is it yet to get integrated?

Thanks in advance,

	Hannes
