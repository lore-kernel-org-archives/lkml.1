Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbZEGReh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbZEGReh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZEGRe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:34:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:1466 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZEGRe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:34:28 -0400
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to use a different sched_clock() for ftrace on omap?
References: <cyZbZ-7Eg-9@gated-at.bofh.it>
	<8763gdt37p.fsf@deeprootsystems.com> <4A03181D.50900@am.sony.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 07 May 2009 10:34:26 -0700
In-Reply-To: <4A03181D.50900@am.sony.com> (Tim Bird's message of "Thu\, 7 May 2009 10\:19\:25 -0700")
Message-ID: <8763gcrf4t.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird <tim.bird@am.sony.com> writes:

> Kevin Hilman wrote:
>> Tim Bird <tim.bird@am.sony.com> writes:
>> 
>>> Hi all,
>>>
>>> I've worked up a replacement sched_clock for ftrace on my omap platform.
>>> The current sched_clock, based on the 32K timer, has low resolution and
>>> doesn't provide very useful results.
>>>
>>> Unfortunately, I'm not sure the best way to use my special one, in place
>>> of a common one in arch/arm/plat-omap/common.c
>> 
>> Hi Tim,
>> 
>> If you're comiling mach-omap1/time.c than you've enabled the
>> higher-resolution MPU timer with CONFIG_OMAP_MPU_TIMER, right?
>
> Yes.
>
>> In that case, you could make the one in plat-omap/common.c inside and
>> #ifndef CONFIG_OMAP_MPU_TIMER and put the new one in the MPU_TIMER
>> code.
>> 
>> To be complete, you should add the same to the mach-omap2/timer-gp.c
>> as well.
>
> I was trying to avoid using #ifdefs, but maybe in this case it
> makes sense.  There are tradeoffs in using the different timers
> (nicely described in plat-omap/Kconfig help entries), so IMHO it
> would be good to make this a config preference.

Yes, we have PM reasons for wanting to choose between the different
timers.

> I'll work up a patch in this style and send it along.

OK, please send it to linux-omap as well.

On a related note, and not your problem here but something that would
be nice to see is the default sched_clock implementation using the
clocksource instead of jiffies.

Then, platform code just registers its preferred clocksource and
sched_clock() gets the same resolution as the clocksource.  Not sure
how yet to handle clocksources being added and removed though...

Kevin
