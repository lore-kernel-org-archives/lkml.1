Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZBTPJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZBTPJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZBTPJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:09:16 -0500
Received: from svb-lan-93.maglan.ru ([62.64.8.93]:49862 "EHLO
	zimbra.svb.sbrf.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbZBTPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:09:15 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.499
Message-ID: <499EC717.3000502@sbmag.ru>
Date: Sat, 21 Feb 2009 02:07:03 +1100
From: zaharov <zaharov@sbmag.ru>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SMP Kernel
References: <499EB742.4050208@sundmangroup.com> <499EBAC6.60804@sbmag.ru> <499EC317.6010506@sundmangroup.com>
In-Reply-To: <499EC317.6010506@sundmangroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matias wrote:
> Hi,
> Ok, since the memory is shared between all the cores the Kernel can be
> invoked by any core receiving an interrupt and thus executed by that
> core?
>
> If the above is right then how come that two separate CPUs can wake
> up, schedule and context-switch completely in parallel?
> Are there an independent scheduler per cpu?
>
> Directly from the sched-design.txt
>
> - 'perfect' SMP scalability. With the new scheduler there is no 'big'
>   runqueue_lock anymore - it's all per-CPU runqueues and locks - two
>   tasks on two separate CPUs can wake up, schedule and context-switch
>   completely in parallel, without any interlocking. All
>   scheduling-relevant data is structured for maximum scalability.
>
>
> Thx // Matias
>
>
>
>
>
> zaharov skrev:
>> Matias wrote:
>>  
>>> Hello,
>>> When an SMP enabled kernel is booted on a Dual Core x86 machine ( Core
>>> 0-1 ) I guess the Kernel is decompressed and started on core 0.
>>> At some point in time the kernel becomes SMP aware and can then
>>> distribute threads on Cores 0 and 1.
>>>
>>> Now, does the non-threaded part of the kernel with the scheduler
>>> continue to run solely on Core 0?
>>>
>>> Cheers // Matias
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>     
>> Kernel may run on any core .
>> When kernel end bootstrap and run init he execute hlt op.
>> After all live in kernel  interrupt driven.
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>   
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Kernel use IPC primitives. All shared resources like lists, buffers,etc
protect by spinlock,mutex,etc.
Scheduler not run completely in parallel.
Scheduler  run like this [lock_shred_resource -> shcedule ->
unlock_shared_resource]
I think this list not for discuss this. You need read any Operating
system design book.
IMHO
 
