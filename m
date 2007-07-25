Return-Path: <linux-kernel-owner+w=401wt.eu-S1765816AbXGYNU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765816AbXGYNU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761993AbXGYNUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:20:11 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:57152 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761975AbXGYNUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:20:09 -0400
Message-ID: <46A74E05.50504@free.fr>
Date: Wed, 25 Jul 2007 15:20:05 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070723095357.GA886@elte.hu> <46A4B7C2.1070304@free.fr> <20070723160442.GA7995@elte.hu> <46A5B8E3.4060004@free.fr> <46A74A58.1070704@free.fr> <20070725130536.GA12334@elte.hu>
In-Reply-To: <20070725130536.GA12334@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Dropping oprofile-list@lists.sourceforge.net)

Ingo Molnar wrote:

> John Sigler wrote:
> 
>>> With a pair of the following in the middle:
>>>
>>> softirq--4     0....  670us : call_rcu (rt_run_flush)
>>> softirq--4     0D..1  670us : __rcu_advance_callbacks (call_rcu)
> 
>> Any idea what went wrong in the above function trace? Why is the 
>> kernel spinning in circles that way?
> 
> does your test-app have higher priority than softirq--4 ?

PID 4 is [softirq-timer/0] and has priority 50 in SCHED_FIFO.
My process has priority 80 in SCHED_RR. It is waiting for IRQ10.

My user-space app has higher priority than everything except
PID 2 which is [posix_cpu_timer]

Is this a priority inversion issue?

Regards.
