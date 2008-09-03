Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYICQoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYICQoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYICQn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:43:58 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51968 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYICQn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:43:58 -0400
Date: Wed, 3 Sep 2008 18:43:56 +0200
From: Andreas Mohr <andi@lisas.de>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH] Prevent clockevent event_handler ending up handler_noop
Message-ID: <20080903164356.GA31969@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902232015.GA3180@linux-os.sc.intel.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> This does not have any issue in normal case as most likely all the clockevent
> devices are setup before the highres switch. But, can potentially be affecting
> some corner case where HPET force detect happens after the highres switch.

So... does that apply to a nice sound card with an even nicer
1 MHz "DirectX timer" as well
which I would soon force into registering a clock_event_device? ;)
(I might add that this sound driver is _modular_, BTW it's azt3328.c)

Or did I completely slide off the usual tracks of what is "politically
correct" to do with kernel source code here? ;)

Oh, and how would this integrate (or rather, "conflict"?)
with globally managed PIT / HPET event device handling?

I'm halfway through converting this driver, thus a not entirely negative
reply would be helpful...

See what such highres-deprived people as myself (PIT, acpi_pm,
_no_ HPET and thus no IRQed highres timer) are doing now,
PITy (sic!) my poor soul...

This timer could even be considered the predecessor of HPET,
since AFAIK several sound cards have such a feature
(maybe it's even semi-standardized?)
and thus it might be very worthwhile for tuning of rotten hardware.

And any hints on how to possibly (reliably!) provide both clock_event_device
(oneshot) _and_ clocksource for a _single_ IRQed countdown timer?

Thanks,

Andreas Mohr
