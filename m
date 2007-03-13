Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXCMWGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXCMWGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933764AbXCMWGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:06:39 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3591 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933760AbXCMWGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:06:39 -0400
Message-ID: <45F7206A.8020803@rtr.ca>
Date: Tue, 13 Mar 2007 18:06:34 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
References: <20070309053931.GA10459@waste.org> <200703111034.02159.kernel@kolivas.org> <45F6EBB2.8090700@rtr.ca> <200703140726.26994.kernel@kolivas.org>
In-Reply-To: <200703140726.26994.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Wednesday 14 March 2007 05:21, Mark Lord wrote:
>> Con Kolivas wrote:
>>> Can you try the new version of RSDL. Assuming it doesn't oops on you it
>>> has some accounting bugfixes which may have been biting you.
>> Retesting today with 2.6.21-rc3-git7 + 2.6.21-rc3-sched-rsdl-0.30.patch.
>>
>> Still not pleasant to use the GUI with a kernel build (-j1 or -j2)
>> happening unless the build is manually "nice'd".
>>
>> Also, accounting looks weird in top(1).
>>
>> With a 100% busy machine, top will show something like this :
>>> top - 14:20:11 up 10:22,  1 user,  load average: 2.65, 2.80, 2.18
>>> Tasks: 134 total,   4 running, 128 sleeping,   0 stopped,   2 zombie
>>> Cpu(s): 68.7% us,  6.7% sy, 24.7% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0%
>>> si Mem:   2076964k total,  2002560k used,    74404k free,   148924k
>>> buffers Swap:  2409740k total,      244k used,  2409496k free,  1448876k
>>> cached
>>>
>>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>>  1824 root      36  10 11748 7244 1936 R  4.0  0.3   0:00.12 cc1
>>>  1845 root      31   0  8080 5272 1412 R  1.7  0.3   0:00.05 cc1
>>>  4139 root      20   0  176m  35m 6860 S  1.3  1.7  18:59.35 Xorg
>>> 29381 root      20   0 33712  16m  12m R  1.0  0.8   0:27.24 konsole
>>>     3 root      20   0     0    0    0 S  0.3  0.0   0:00.49 events/0
>>>  1529 root      20   0  2556 1460  752 S  0.3  0.1   0:00.05 make
>>> 14623 root      20   0  2200 1144  860 R  0.3  0.1   0:00.89 top
>>>     1 root      20   0  1568  532  464 S  0.0  0.0   0:00.22 init
>>>     2 root      39  19     0    0    0 S  0.0  0.0   0:00.01 ksoftirqd/0
>>>     4 root      20   0     0    0    0 S  0.0  0.0   0:00.00 khelper
>>>     5 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthread
>> Mmm.. I wonder where all of that 100% CPU went to.. the busiest tasks
>> are only showing up as 4.0% and 1.7% (when in fact they are using near
>> 100%).
> 
> Nothing ever looks like it stays running for very long. That would be enough 
> to account for this sort of top picture.

Sorry, I just don't buy that one.  This was a 2-second sampling interval in top.
top(1) is a program that has to work, so if this scheduler breaks it like this,
then we need to understand and fix top(1) or the scheduler.

> What HZ are you running? Do you usually run two makes at different nice levels?

This was HZ=1000, with NO_HZ.  And, no, not normally different nice levels.
Here I was just trying to keep the machine usable while building a couple of things.

Keep at it.  Someday this might be good enough for mainline,
but right now the stock scheduler beats it for my desktop (notebook) loads.

Cheers
