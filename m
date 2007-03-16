Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXCPKDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXCPKDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933565AbXCPKDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:03:11 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:52902 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320AbXCPKDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:03:10 -0400
Date: Fri, 16 Mar 2007 10:03:07 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc3-mm1
In-Reply-To: <200703160743.52204.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.64.0703161001080.32458@skynet.skynet.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
 <200703151637.14558.m.kozlowski@tuxland.pl> <20070315195932.GB6236@skynet.ie>
 <200703160743.52204.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, Mariusz Kozlowski wrote:

> Hello Mel,
>

Hi

>>>>>> 	Today after +- 24h of uptime I found some more page allocation
>>>>>> failures ('eth1: Can't allocate skb for Rx'). You'll find more here:
>>>>>>
>>>>>> http://tuxland.pl/misc/2.6.21-rc3-mm1-page-allocation-failure.txt
>>>>>>
>>>>>> System wasn't doing anything unusual, as usual ;-) X, some p2p
>>>>>> software, firefox+flash playing music.
>>>>>
>>>>> Do other kernels do this, or is 2.6.21-rc3-mm1 worse?
>>>>>
>>>>> It is of course a non-fatal problem and will inevitably happen sometimes,
>>>>> but we would like the VM to be able to minimise the occurrence of this
>>>>> problem.
>>>>
>>>> Mariusz, I would be interested in finding out if this problem still occurs when
>>>> you set min_free_kbytes to 16384 via /proc/sys/vm/min_free_kbytes. I understand
>>>> that the problem is not easily reproduced and requiring configuration changes
>>>> is far from ideal but it'd allow me to find out if options 2 or 3 below make
>>>> sense in advance.
>>>
>>> After a few hours I can confirm that this happens with
>>>
>>> $ cat /proc/sys/vm/min_free_kbytes
>>> 16384
>>>
>>> as well. See the syslog output below. Feel free to mail me to do some more tests.
>>
>> Ok, great. Well, not great because it's broken, but I know what's going
>> on. I was able to reproduce the problem based on your report on my desktop
>> and put together a fix for it. Full regression tests are still running but
>> it should be in good enough state for you to test.
>>
>> Without this patch, I got allocation failures within 15 minutes by stressing
>> the machine. With the patch below, it's been up an hour and 15 minutes and
>> I'm seeing no problems so far. Will keep the machine running a few days to
>> see what happens.
>>
>
> [...]
>
>> Mariusz, please try the following patch. It should not be necessary to
>> adjust your min_free_kbytes again but if you see a failure, please try
>> with min_free_kbytes set to 16384. Thanks a lot.
>
> Works for me. min_free_kbytes was left at default 2791. I left the laptop with
> X + aMule + azureus + firefox&flash (playing music) + kernel compilation so
> the box was pushed a bit. Uptime close to 9 hours and no page allocation
> failures. I leave it running some more. If anything pops out you'll know it :-)
>

Excellent news.

This patch has a few flaws in it and it failed regression tests on 
sparsemem so it's far from ready but I know the basic idea appears sound 
now. I'll work on bringing the patch up to scratch and hopefully send on 
another version later today.

Thanks a million for testing.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
