Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbXHQLIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbXHQLIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 07:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbXHQLIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 07:08:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbXHQLIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 07:08:21 -0400
Message-ID: <46C581A0.7090000@stud.feec.vutbr.cz>
Date: Fri, 17 Aug 2007 13:08:16 +0200
From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
User-Agent: Thunderbird 1.5.0.12 (X11/20070718)
MIME-Version: 1.0
To: GolovaSteek <golovasteek@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: nanosleep() accuracy
References: <f40fb4250708161552ub87bf8ve8168eec1b3955e7@mail.gmail.com>	 <46C54787.1010909@stud.feec.vutbr.cz> <f40fb4250708170044q9a259c3wb50186880d6b7f51@mail.gmail.com>
In-Reply-To: <f40fb4250708170044q9a259c3wb50186880d6b7f51@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

GolovaSteek wrote:
> 2007/8/17, Michal Schmidt <xschmi00@stud.feec.vutbr.cz>:
>   
>> GolovaSteek skrev:
>>     
>>> Hello!
>>> I need use sleep with accurat timing.
>>> I use 2.6.21 with rt-prempt patch.
>>> with enabled rt_preempt, dyn_ticks, and local_apic
>>> But
>>>
>>> req.tv_nsec = 300000;
>>> req.tv_sec = 0;
>>> nanosleep(&req,NULL)
>>>
>>> make pause around 310-330 microseconds.
>>>       
>> How do you measure this?
>> If you want to have something done every 300 microseconds, you must not
>> sleep for 300 microseconds in each iteration, because you'd accumulate
>> errors. Use a periodic timer or use the current time to compute how long
>> to sleep in each iteration. Take a look how cyclictest does it.
>>     
>
> no. I just want my programm go to sleep sometimes and wake up in correct time.
>   

What does your program do that it has such a strict requirement on the
exact length of sleeping?

>>> I tried to understend how work nanosleep(), but it not depends from
>>> jiffies and from smp_apic_timer_interrupt.
>>>
>>> When can accuracy be lost?
>>> And how are process waked up?
>>>
>>>
>>> GolovaSteek
>>>       
>> Don't forget the process will always have non-zero wakeup latency. It
>> takes some time to process an interrupt, wakeup the process and schedule
>> it to run on the CPU. 10-30 microseconds is not unreasonable.
>>     
>
> But 20000 operations can be done in 10 microseconds?
> and why is there that inconstancy? Why sametimes 10 and sometimes 30?
> In which points of implementation it happens?
>
> GolovaSteek
>   

If a jitter of 20 microseconds is unacceptable for your application,
don't use PC hardware. Consider using a microcontroller.

Michal

