Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbZIIIe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbZIIIe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZIIIe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:34:58 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:40363 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbZIIIe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:34:57 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net 4037D332D93
Message-ID: <4AA768B1.708@arcor.de>
Date: Wed, 09 Sep 2009 11:34:57 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk> <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk> <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu>
In-Reply-To: <20090909061308.GA28109@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 09:13 AM, Ingo Molnar wrote:
>
> * Jens Axboe<jens.axboe@oracle.com>  wrote:
>
>> On Tue, Sep 08 2009, Peter Zijlstra wrote:
>>> On Tue, 2009-09-08 at 11:13 +0200, Jens Axboe wrote:
>>>> And here's a newer version.
>>>
>>> I tinkered a bit with your proglet and finally found the
>>> problem.
>>>
>>> You used a single pipe per child, this means the loop in
>>> run_child() would consume what it just wrote out until it got
>>> force preempted by the parent which would also get woken.
>>>
>>> This results in the child spinning a while (its full quota) and
>>> only reporting the last timestamp to the parent.
>>
>> Oh doh, that's not well thought out. Well it was a quick hack :-)
>> Thanks for the fixup, now it's at least usable to some degree.
>
> What kind of latencies does it report on your box?
>
> Our vanilla scheduler default latency targets are:
>
>    single-core: 20 msecs
>      dual-core: 40 msecs
>      quad-core: 60 msecs
>      opto-core: 80 msecs
>
> You can enable CONFIG_SCHED_DEBUG=y and set it directly as well via
> /proc/sys/kernel/sched_latency_ns:
>
>     echo 10000000>  /proc/sys/kernel/sched_latency_ns

I've tried values ranging from 10000000 down to 100000.  This results in 
the stalls/freezes being a bit shorter, but clearly still there.  It 
does not eliminate them.

If there's anything else I can try/test, I would be happy to do so.
