Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbYBUNd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbYBUNd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759432AbYBUNdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:33:43 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:34997 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751093AbYBUNdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:33:41 -0500
Message-ID: <47BD7CA4.6070609@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 18:59:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com> <20080221090430.GA20055@elte.hu>  <47BD44FF.7070104@linux.vnet.ibm.com> <1203595354.19641.5.camel@homer.simson.net>
In-Reply-To: <1203595354.19641.5.camel@homer.simson.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Hi,
> 
> On Thu, 2008-02-21 at 15:01 +0530, Balbir Singh wrote:
>> Ingo Molnar wrote:
>>> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>
>>>> If you insist that sched_yield() is bad, I might agree, but how does 
>>>> my patch make things worse. [...]
>>> it puts new instructions into the hotpath.
>>>
>>>> [...] In my benchmarks, it has helped the sched_yield case, why is 
>>>> that bad? [...]
>>> I had the same cache for the rightmost task in earlier CFS (it's a 
>>> really obvious thing) but removed it. It wasnt a bad idea, but it hurt 
>>> the fastpath hence i removed it. Algorithms and implementations are a 
>>> constant balancing act.
>> This is more convincing, was the code ever in git? How did you measure the
>> overhead?
> 
> Counting enqueue/dequeue cycles on my 3GHz P4/HT running a 60 seconds
> netperf test that does ~85k/s context switches  shows:
> 
> sched_cycles: 7198444348 unpatched
> vs
> sched_cycles: 8574036268 patched


Thanks for the numbers! I am very convinced that the patch should stay out until
we can find a way to reduce the overhead. I'll try your patch and see what the
numbers look like as well.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
