Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZBGJV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZBGJV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 04:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZBGJVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 04:21:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43691 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbZBGJVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 04:21:04 -0500
Date: Sat, 7 Feb 2009 10:20:49 +0100
From: Pavel Machek <pavel@suse.cz>
To: john stultz <johnstul@us.ibm.com>
Cc: Jon Hunter <jon-hunter@ti.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
Message-ID: <20090207092049.GE1411@ucw.cz>
References: <20090114221624.76ee8aa4.akpm@linux-foundation.org> <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com> <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com> <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com> <1233081369.28350.68.camel@jamoon.sc.intel.com> <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com> <4981D957.8040409@ti.com> <1f1b08da0901290936k71d016fcme81f04ca16029a7c@mail.gmail.com> <49834F30.3040706@ti.com> <1233347396.8861.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233347396.8861.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So what I was proposing is that for devices that have timers that would 
> > allow you to sleep beyond ~2.15 seconds (current max imposed by the 
> > clockevent_delta2ns function), why not increase the dynamic range (make 
> > this a 64-bit variable) or base (ie. from nanoseconds to milliseconds) 
> > to permit longer sleep times for devices that can support them? This 
> > should not have any negative impact on devices that cannot support such 
> > long sleep times.
> 
> No objection to max_delta_ns being increased, but whatever code manages
> it will probably need to query the timekeeping core in some fashion to
> make sure the timer hardware max isn't larger then the clocksource
> hardware max. I've provided a rough sketch at what the timekeeping code
> would probably look like below.
> 
> > So far I have not encountered any issues with doing this. Let me know if 
> > this does or does not address your concerns.
> 
> There may be some other issues here, such as NTP over-correction issues
> (for instance: ntp trying to correct for a 1us offset over the next
> second, but ends up applying it for 10 seconds) if we defer for a really
> long time. But at that point, we might as well suspend to ram, like the
> OLPC does.

Well, there's still some way to go before auto-sleep is
possible. android can do that, afaict, but on pc it is quite far away.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
