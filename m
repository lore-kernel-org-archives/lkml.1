Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYKUBow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYKUBow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYKUBon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:44:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYKUBon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:44:43 -0500
Message-ID: <49261276.10408@zytor.com>
Date: Thu, 20 Nov 2008 17:44:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dimitri Sivanich <sivanich@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2 v3] SGI RTC: add clocksource/clockevent driver and
 generic timer vector
References: <20081023163041.GA14574@sgi.com> <20081119212202.GA3377@sgi.com> <20081120095943.GF6885@elte.hu>
In-Reply-To: <20081120095943.GF6885@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
>> The following patches provide a driver for synchronized RTC 
>> clocksource and clockevents for SGI systems, as well as a generic 
>> timer system interrupt.
>>
>> With these patches, a module can be installed that registers the 
>> system-wide synchronized RTC clocksource and timers as both a 
>> clocksource and clockevents device running in high resolution mode.
>>
>> [PATCH 1/2 v3] SGI RTC: add clocksource driver
>> [PATCH 2/2 v3] SGI RTC: add generic timer system interrupt
> 
> Looks very clean and well-done to me.
> 
> I had to take a good look at the rtc_timer_head->expires[] construct - 
> but i guess that's the best approach, as the max number of entries is 
> hard to judge at build time. (and we wont get any real limit 
> protection from gcc anyway)
> 
> Thomas, any objections?

I have *extremely* serious reservations about reserving even more
hardware vectors for SGI only.  This affects all systems, and quite
frankly should not be necessary at all.

The SGI UV people have pushed this at a number of points in the past,
and we have told them to use an irqchip instead.  This patch tries to
allocate yet another reserved vector, instead.

	-hpa
