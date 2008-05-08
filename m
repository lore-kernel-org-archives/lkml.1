Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYEHMWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYEHMWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYEHMWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:22:08 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:36422 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYEHMWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:22:07 -0400
Message-ID: <4822F065.9080502@googlemail.com>
Date: Thu, 08 May 2008 14:21:57 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Martin Knoblauch <spamtrap@knobisoft.de>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from
 2.6.24)
References: <530038.77501.qm@web32608.mail.mud.yahoo.com> <alpine.LFD.1.10.0805081227250.3318@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805081227250.3318@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 7 May 2008, Martin Knoblauch wrote:
>>> no this looks different. As soon as the timesource is detected, I see non-zero 
>>> timestamps
>>> in dmesg, but they look smaller and jump in both directions. And I have never 
>>> seen this before
>>> 2.6.25.
>>>
>>> It actually might be a good idea to get the dmesg output from 2.6.24.
>>>
>>> Cheers
>>> Martin
>>  interesting - maybe related to clocksources. The HPET seems to be detected later in 2.6.25:
>>
>> 2.6.24:
>>
>> [    0.000000] Initializing CPU#0
>> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
>> -->[    0.000000] hpet clockevent registered
>> -->[    0.000000] TSC calibrated against HPET
>  
>> 2.6.25.2:
>>
>> [    0.000000] Initializing CPU#0
>> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
>> -->[    0.000000] TSC calibrated against PM_TIMER
>  
> That's odd indeed. Is HPET not registered at all in 2.6.25 or does it just happen late ?
> 
> please provide the output of:
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> /sys/devices/system/clocksource/clocksource0/current_clocksource

I was about to report / ask bout this issue too.

I see the same output for >=2.6.25 , TSC calibrated against PM_TIMER and not against HPET anymore.


[    0.000000] TSC calibrated against PM_TIMER
[    0.000016] time.c: Detected 2499.949 MHz processor.
...
[    0.000999] hpet clockevent registered

So it seems to register to late in >=2.6.25 kernels ?

cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc hpet acpi_pm jiffies

cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc


> 
> Thanks,
> 	tglx


Regards,

Gabriel C
