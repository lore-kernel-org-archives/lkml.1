Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZBGJU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZBGJU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 04:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZBGJUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 04:20:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43608 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbZBGJUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 04:20:37 -0500
Date: Sat, 7 Feb 2009 10:20:21 +0100
From: Pavel Machek <pavel@suse.cz>
To: john stultz <johnstul@us.ibm.com>
Cc: Jon Hunter <jon-hunter@ti.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
Message-ID: <20090207092021.GD1411@ucw.cz>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com> <20090114221624.76ee8aa4.akpm@linux-foundation.org> <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com> <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com> <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com> <1233081369.28350.68.camel@jamoon.sc.intel.com> <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com> <4981D957.8040409@ti.com> <1f1b08da0901290936k71d016fcme81f04ca16029a7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f1b08da0901290936k71d016fcme81f04ca16029a7c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-01-29 09:36:00, john stultz wrote:
> On Thu, Jan 29, 2009 at 8:29 AM, Jon Hunter <jon-hunter@ti.com> wrote:
> > Pallipadi, Venkatesh wrote:
> > I have spent several weeks trying to suppress kernel timers using the
> > deferred timers and lengthen the sleep time. I am now able to get the device
> > to sleep for minutes but I found that max_delta_ns is a limiting factor. I
> > will be surprised if you can sleep for longer than ~2.15 seconds with the
> > current implementation.
> 
> As an aside, there are some further hardware limitations in the
> timekeeping core that limit the amount of time the hardware can sleep.
> For instance, the acpi_pm clocksource wraps every 2.5 seconds or so,
> so we have to wake up periodically to sample it to avoid wrapping
> issues.
> 
> Just to be able to deal with all the different hardware out there, the
> timekeeping core expects to wake up twice a second to do this
> sampling. It may be possible to push this out if you are using other

That's strange... I think I seen less than 2 wakeups per second on
powertop...? (thinkpad x60, nothing exotic).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
