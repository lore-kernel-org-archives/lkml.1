Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbZIIJk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbZIIJk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZIIJk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:40:26 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:36558 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbZIIJk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:40:26 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 770FA33A7BF
Message-ID: <4AA7780A.3000008@arcor.de>
Date: Wed, 09 Sep 2009 12:40:26 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu>	 <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk>	 <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>	 <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk>	 <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>	 <20090909061308.GA28109@elte.hu>	 <1252486344.28645.18.camel@marge.simson.net>  <4AA76FD2.1050103@arcor.de> <1252487869.7746.181.camel@twins>
In-Reply-To: <1252487869.7746.181.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 12:17 PM, Peter Zijlstra wrote:
> On Wed, 2009-09-09 at 12:05 +0300, Nikos Chantziaras wrote:
>
>> Thank you for mentioning min_granularity.  After:
>>
>>     echo 10000000>  /proc/sys/kernel/sched_latency_ns
>>     echo 2000000>  /proc/sys/kernel/sched_min_granularity_ns
>
> You might also want to do:
>
>       echo 2000000>  /proc/sys/kernel/sched_wakeup_granularity_ns
>
> That affects when a newly woken task will preempt an already running
> task.

Lowering wakeup_granularity seems to make things worse in an interesting 
way:

With low wakeup_granularity, the video itself will start skipping if I 
move the window around.  However, the window manager's effect of moving 
a window around is smooth.

With high wakeup_granularity, the video itself will not skip while 
moving the window around.  But this time, the window manager's effect of 
the window move is skippy.

(I should point out that only with the BFS-patched kernel can I have a 
smooth video *and* a smooth window-moving effect at the same time.) 
Mainline seems to prioritize one of the two according to whether 
wakeup_granularity is raised or lowered.  However, I have not tested 
Mike's patch yet (but will do so ASAP.)
