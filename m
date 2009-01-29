Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbZA2Q3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbZA2Q3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbZA2Q3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:29:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57906 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZA2Q3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:29:34 -0500
Message-ID: <4981D957.8040409@ti.com>
Date: Thu, 29 Jan 2009 10:29:11 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>	 <20090114221624.76ee8aa4.akpm@linux-foundation.org>	 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>	 <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>	 <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com> <1233081369.28350.68.camel@jamoon.sc.intel.com> <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:

> max_delta would depend on the timer in the platform. With HPET this
> should be much larger than 2.15 secs.

So I agree that the HPET hardware in newer devices themselves would 
allow longer sleep periods. However, this is not the problem I was raising.

The problem is that the dynamic tick uses a 32-bit variable, 
max_delta_ns, to define that max sleep time of a device in nanoseconds. 
The maximum value that this variable can be assigned is LONG_MAX or 
0x7fffffff nanoseconds (see function clockevent_delta2ns). The value 
0x7fffffff nanoseconds equates to ~2.15 seconds. Hence, without 
increasing the dynamic range of max_delta_ns (ie. make this a 64-bit 
integer) or change the base of this variable from nanoseconds to 
milliseconds, I don't see how the device will ever sleep for longer than 
~2.15 seconds.

I have spent several weeks trying to suppress kernel timers using the 
deferred timers and lengthen the sleep time. I am now able to get the 
device to sleep for minutes but I found that max_delta_ns is a limiting 
factor. I will be surprised if you can sleep for longer than ~2.15 
seconds with the current implementation.

Let me know if this makes sense.

> Ok. ﻿Thinking about it a bit more, I think we can push this 
> patch along.
> Thomas/Andrew, can one of you pick up this patch..

Great thanks.

Jon
