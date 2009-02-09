Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbZBITMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbZBITMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZBITMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:12:09 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55545 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZBITMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:12:08 -0500
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
From: John Stultz <johnstul@us.ibm.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Jon Hunter <jon-hunter@ti.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090207092021.GD1411@ucw.cz>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
	 <20090114221624.76ee8aa4.akpm@linux-foundation.org>
	 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
	 <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>
	 <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com>
	 <1233081369.28350.68.camel@jamoon.sc.intel.com>
	 <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com>
	 <4981D957.8040409@ti.com>
	 <1f1b08da0901290936k71d016fcme81f04ca16029a7c@mail.gmail.com>
	 <20090207092021.GD1411@ucw.cz>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 11:10:42 -0800
Message-Id: <1234206642.10457.45.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-07 at 10:20 +0100, Pavel Machek wrote:
> On Thu 2009-01-29 09:36:00, john stultz wrote:
> > On Thu, Jan 29, 2009 at 8:29 AM, Jon Hunter <jon-hunter@ti.com> wrote:
> > > Pallipadi, Venkatesh wrote:
> > > I have spent several weeks trying to suppress kernel timers using the
> > > deferred timers and lengthen the sleep time. I am now able to get the device
> > > to sleep for minutes but I found that max_delta_ns is a limiting factor. I
> > > will be surprised if you can sleep for longer than ~2.15 seconds with the
> > > current implementation.
> > 
> > As an aside, there are some further hardware limitations in the
> > timekeeping core that limit the amount of time the hardware can sleep.
> > For instance, the acpi_pm clocksource wraps every 2.5 seconds or so,
> > so we have to wake up periodically to sample it to avoid wrapping
> > issues.
> > 
> > Just to be able to deal with all the different hardware out there, the
> > timekeeping core expects to wake up twice a second to do this
> > sampling. It may be possible to push this out if you are using other
> 
> That's strange... I think I seen less than 2 wakeups per second on
> powertop...? (thinkpad x60, nothing exotic).

Yea, I don't think there is an interface that the timekeeping code
communicates that through. Probably a good idea to get that established
before folks try to push further then a second and end up with trouble
on hardware with short clocksources.

thanks
-john


