Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYLIPJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYLIPJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 10:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYLIPJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 10:09:51 -0500
Received: from www.crouse-house.com ([199.45.160.146]:35277 "EHLO
	mail.crouse-house.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYLIPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 10:09:50 -0500
Message-ID: <493E8A3D.90602@cosmicpenguin.net>
Date: Tue, 09 Dec 2008 08:09:49 -0700
From: Jordan Crouse <jordan@cosmicpenguin.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Harald Dunkel <harald.dunkel@t-online.de>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.7 built for Geode: Clock drift
References: <49358017.7080009@t-online.de>	 <1f1b08da0812051340t1967e753h354346d13ccb34d3@mail.gmail.com>	 <493A170C.90509@t-online.de> <1228788840.6918.33.camel@localhost.localdomain>
In-Reply-To: <1228788840.6918.33.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Sat, 2008-12-06 at 07:09 +0100, Harald Dunkel wrote:
>> john stultz wrote:
>>> For both configs, can you run:
>>>    cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>>> and:
>>>    cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>>>
>>> Then send back the output?
>>>
>> Sure. For 486:
>>
>> % cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>> pit jiffies
>> % cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> pit
>>
>>
>> For Geode (clock is running too fast):
>> % cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>> jiffies
>> % cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> jiffies
>>
>>
>> dmesg says for Geode:
>>
>> :
>> TSC: Unable to calibrate against PIT
>> TSC: No reference (HPET/PMTIMER) available
>> Marking TSC unstable due to could not calculate TSC khz
> 
> Could you send your .config?
> 
> It seems the PIT (which is used in 486 build) is being disabled in the
> Geode config. However, I thought the Geode's had their own clocksources,
> either the SCx200 or the GEODE_MFGPT_TIMER. Maybe one of those needs to
> be enabled?

He sent his original config in his first email - GEODE_MFGPT_TIMER was 
enabled. Its not always certain that there are MFGPT timers available 
(prior to about the middle of this year, most Geode BIOSes took all the 
timers for themselves).  But in any case the system should fall back to 
PIT automatically, so regardless of more advanced timers. the absence of 
a PIT is troubling.

Jordan



