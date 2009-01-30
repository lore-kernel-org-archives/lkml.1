Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZA3TEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZA3TEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZA3TEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:04:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59824 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZA3TEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:04:37 -0500
Message-ID: <49834F30.3040706@ti.com>
Date: Fri, 30 Jan 2009 13:04:16 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>	 <20090114221624.76ee8aa4.akpm@linux-foundation.org>	 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>	 <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>	 <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com>	 <1233081369.28350.68.camel@jamoon.sc.intel.com>	 <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com>	 <4981D957.8040409@ti.com> <1f1b08da0901290936k71d016fcme81f04ca16029a7c@mail.gmail.com>
In-Reply-To: <1f1b08da0901290936k71d016fcme81f04ca16029a7c@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> As an aside, there are some further hardware limitations in the
> timekeeping core that limit the amount of time the hardware can sleep.
> For instance, the acpi_pm clocksource wraps every 2.5 seconds or so,
> so we have to wake up periodically to sample it to avoid wrapping
> issues.
> 
> Just to be able to deal with all the different hardware out there, the
> timekeeping core expects to wake up twice a second to do this
> sampling. It may be possible to push this out if you are using other
> clocksources (HPET/TSC), but if sleeps for longer then a second are a
> needed feature, we probably will need some infrastructure in the
> timekeeping core that can be queried to make sure its safe.

The variable "max_delta_ns" is used by the dynamic tick to govern the 
maximum time a given device can sleep. Hence, this variable should be 
configured as necessary for the device you are using. Therefore, if your 
device has a timer that will wrap every 2.5 seconds, then for this 
device the "max_delta_ns" should be configure so that it does not exceed 
this time.

So what I was proposing is that for devices that have timers that would 
allow you to sleep beyond ~2.15 seconds (current max imposed by the 
clockevent_delta2ns function), why not increase the dynamic range (make 
this a 64-bit variable) or base (ie. from nanoseconds to milliseconds) 
to permit longer sleep times for devices that can support them? This 
should not have any negative impact on devices that cannot support such 
long sleep times.

So far I have not encountered any issues with doing this. Let me know if 
this does or does not address your concerns.

Cheers
Jon



