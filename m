Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZCANwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZCANwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 08:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZCANvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 08:51:55 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:38185 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZCANvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 08:51:54 -0500
Message-ID: <49AA92E6.6020103@krogh.cc>
Date: Sun, 01 Mar 2009 14:51:34 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc>	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>	 <49A70B24.6090706@krogh.cc> <1235684809.6811.5.camel@localhost.localdomain>
In-Reply-To: <1235684809.6811.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Thu, 2009-02-26 at 22:35 +0100, Jesper Krogh wrote:
>> john stultz wrote:
>>> On Thu, Feb 26, 2009 at 12:43 PM, Jesper Krogh <jesper@krogh.cc> wrote:
>>>> Linus Torvalds wrote:
>>>>> On Thu, 26 Feb 2009, Jesper Krogh wrote:
>>>>>> 2.6.26.8 doesnt have this problem.
>>>>>>
>>>>>> The "current_clocsource" is the same on both systems.
>>>>>>
>>>>>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>>>>>> tsc
>>>>> What does the frequency calibrate to? It should be in the dmesg. Does it
>>>>> differ by a big amount?
>>>> Non-working:
>>>> $ dmesg | grep -i freq
>>>> [    0.004007] Calibrating delay loop (skipped), value calculated using
>>>> timer frequency.. 4620.05 BogoMIPS (lpj=9240104)
>>>>
>>>> 2.6.26.8 doesn't have that information.
>>> I'm surprised the clocksource watchdog isn't catching it.
>>>
>>> What's the output from:
>>> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>> tsc acpi_pm jiffies
> 
> Hmm. Does booting w/ "clocksourc=acpi_pm" also show the severe (~550ppm,
> which NTP can't handle) drift?
> 
>>From the dmesg, I don't see any major calibration difference right off. 
> 
> So I'd suspect something like TSC halting in idle could be causing
> problems, but the watchdog should catch that as well. My only guess at
> this point is that the ACPI PM is halting in idle along with the TSC. 
> 
> And you said this only happens under load? 

That wasn't true.. I got some real sunday testing done today. A fresh 
2.6.28.7 has the same problem with a load of 0.00 0.00 0.00

2.6.27.19 doesn't have problems keeping time.

-- 
Jesper
