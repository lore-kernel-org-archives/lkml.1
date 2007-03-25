Return-Path: <linux-kernel-owner+w=401wt.eu-S1751280AbXCYO7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbXCYO7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXCYO6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:58:42 -0400
Received: from comtv.ru ([217.10.32.17]:54007 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXCYO6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:58:05 -0400
X-UCL: actv
Date: Sun, 25 Mar 2007 18:57:18 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Con Kolivas <kernel@kolivas.org>
cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <200703260015.37535.kernel@kolivas.org>
Message-ID: <Pine.LNX.4.64.0703251854430.8043@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org> <200703252202.48022.kernel@kolivas.org>
 <Pine.LNX.4.64.0703251705160.7018@linmac.oyster.ru> <200703260015.37535.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Con Kolivas wrote:

> On Sunday 25 March 2007 23:06, malc wrote:
>> On Sun, 25 Mar 2007, Con Kolivas wrote:
>>> On Sunday 25 March 2007 21:46, Con Kolivas wrote:
>>>> On Sunday 25 March 2007 21:34, malc wrote:
>>>>> On Sun, 25 Mar 2007, Ingo Molnar wrote:
>>>>>> * Con Kolivas <kernel@kolivas.org> wrote:
>>>>>>> For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
>>
>> [..snip..]
>>
>>> ---
>>> Currently we only do cpu accounting to userspace based on what is
>>> actually happening precisely on each tick. The accuracy of that
>>> accounting gets progressively worse the lower HZ is. As we already keep
>>> accounting of nanosecond resolution we can accurately track user cpu,
>>> nice cpu and idle cpu if we move the accounting to update_cpu_clock with
>>> a nanosecond cpu_usage_stat entry. This increases overhead slightly but
>>> avoids the problem of tick aliasing errors making accounting unreliable.
>>>
>>> Signed-off-by: Con Kolivas <kernel@kolivas.org>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>> [..snip..]
>>
>> Forgot to mention. Given that this goes into the kernel, shouldn't
>> Documentation/cpu-load.txt be amended/removed?
>
> Yes that's a good idea. Also there should be a sanity check because sometimes
> for some reason noone's been able to explain to me sched_clock gives a value
> which doesn't make sense (time appears to have gone backwards) and that will
> completely ruin the accounting from then on.

After running this new kernel for a while i guess i have hit this issue:
http://www.boblycat.org/~malc/apc/bad-load.png

Top and icewm's monitor do show incredibly huge load while in reality 
nothing like that is really happening. Both ad-hoc and `/proc/stat' (idle)
show normal CPU utilization (7% since i'm doing some A/V stuff in the
background)

-- 
vale
