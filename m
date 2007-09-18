Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbXIRV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbXIRV3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbXIRV33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:29:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbXIRV32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:29:28 -0400
Message-ID: <46F00417.7080301@redhat.com>
Date: Tue, 18 Sep 2007 13:00:07 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu> <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu>
In-Reply-To: <20070914153216.GA27213@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2007 11:32 AM, Ingo Molnar wrote:
> * Antoine Martin <antoine@nagafix.co.uk> wrote:
> 
>>>> have an impact) Keep CONFIG_SCHED_DEBUG=y to be able to twiddle the
>>>> sysctl.
>> It looks good now! Updated results here:
>> http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests5-10msYield-noload.png
>> http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests5-10msYield.png
>> Compared with more kernels here - a bit more cluttered:
>> http://devloop.org.uk/documentation/database-performance/Linux-Kernels/Kernels-ManyThreads-CombinedTests4-10msYield-noload.png
>>
>> Thanks Ingo!
>> Does this mean that I'll have to keep doing:
>> echo 1 > /proc/sys/kernel/sched_yield_bug_workaround
>> Or are you planning on finding a more elegant solution?
> 
> just to make sure - can you get it to work fast with the 
> -rc6+yield-patch solution too? (i.e. not CFS-devel) We need a (tested) 
> solution for 2.6.23 and the CFS-devel patches are not for 2.6.23. I've 
> attached below the latest version of the -rc6 yield patch - the switch 
> is not dependent on SCHED_DEBUG anymore but always available.
> 

Is this going to be merged? And will you be making the default == 1 or
just leaving it at 0, which forces people who want the older behavior to
modify the default?

