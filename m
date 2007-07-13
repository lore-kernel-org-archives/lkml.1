Return-Path: <linux-kernel-owner+w=401wt.eu-S933341AbXGMVUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341AbXGMVUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 17:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbXGMVUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 17:20:25 -0400
Received: from mail.tmr.com ([64.65.253.246]:55487 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbXGMVUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 17:20:25 -0400
Message-ID: <4697EC49.4070303@tmr.com>
Date: Fri, 13 Jul 2007 17:19:05 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v19
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu>
In-Reply-To: <20070711205556.GA27266@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Bill Davidsen <davidsen@tmr.com> wrote:
> 
>>> I've taken mainline git tree (freshly integrated CFS!) out for a 
>>> multimedia spin.  I tested watching movies and listenign to music in 
>>> the presence of various sleep/burn loads, pure burn loads, and mixed 
>>> loads. All was peachy here.. I saw no frame drops or sound skips or 
>>> other artifacts under any load where the processor could possibly 
>>> meet demand.
>> I would agree with preliminary testing, save that if you get a lot of 
>> processes updating the screen at once, there seems to be a notable 
>> case of processes getting no CPU for 100-300ms, followed by a lot of 
>> CPU.
>>
>> I see this clearly with the "glitch1" test with four scrolling xterms 
>> and glxgears, but also watching videos with little busy processes on 
>> the screen. The only version where I never see this in test or with 
>> real use is cfs-v13.
> 
> just as a test, does this go away if you:
> 
> 	renice -20 pidof `Xorg`
> 
> i.e. is this connected to the way X is scheduled?
> 
Doing this slows down the display rates, but doesn't significantly help 
the smoothness of the gears.

> Another thing to check would be whether it goes away if you set the 
> granularity to some really finegrained value:
> 
>     echo 0 > /proc/sys/kernel/sched_wakeup_granularity_ns
>     echo 500000 > /proc/sys/kernel/sched_granularity_ns
> 
> this really pushes things - but it tests the theory whether this is 
> related to granularity.
> 
I didn't test this with standard Xorg priority, I should go back and try 
that. But it didn't really make much difference. The gears and scrolling 
xterms ran slower with Xorg at -20 with any sched settings. I'll do that 
as soon as a build finishes and I can reboot.

I should really go back to 2.6.21.6, 2.6.22 has many bizarre behaviors 
with FC6. Automount starts taking 30% of CPU (unused at the moment), the 
sensors applet doesn't work, etc. I hope over the weekend I can get bug 
reports out on all this, but there are lots of non-critical oddities.
> 	Ingo


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
