Return-Path: <linux-kernel-owner+w=401wt.eu-S1761885AbYBUIzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761885AbYBUIzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYBUIzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:55:07 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:42666 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751759AbYBUIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:55:05 -0500
Message-ID: <47BD3B56.3090404@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 14:20:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: Make yield_task_fair more efficient
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu>  <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy>
In-Reply-To: <1203583439.6243.119.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2008-02-21 at 13:09 +0530, Balbir Singh wrote:
> 
>> sched_yield() is supported API
> 
> For SCHED_FIFO/SCHED_RR.
> 
>>  and also look at http://lkml.org/lkml/2007/9/19/351.
> 
> Read on (http://lkml.org/lkml/2007/9/19/371) and find:
>         
>         The sched_yield() behaviour is actually very well-defined for RT
>         tasks (now, whether it's a good interface to use or not is still
>         open to debate, but at least it's a _defined_ interface ;), and
>         I think we should at least try to approximate that behaviour for
>         normal tasks, even if they aren't RT.
> 
> sched_yield() just isn't a very useful API except in RT and even there
> one can question it.
> 

But it's being used very heavily by existing applications. Can we break/penalize
them because we think it's not a good interface or a method to program?


>> I am trying to make sched_yield() efficient
>> when compat_sched_yield is turned on (which is most likely), since people will
>> want that behaviour (Hint, please read the man-page for sched_yield).
> 
> I did, so what? read the POSIX spec - its just plain undefined for
> SCHED_OTHER. We already do something 'sensible' for those few broken
> applications relying on unspecified behaviour.
> 
>> There are
>> already several applications using sched_yield(), so they all suffer.
> 
> Who is using it, where is their source so we can show its faster to not
> use it?
> 
> Really, hiding behind closed sores doesn't make it good.
> 
> 

I am not hiding behind closed source. Please refer to the regression reported by
Yanmin where he used compat_sched_yield=1 (see
http://lkml.org/lkml/2008/2/18/7). The regression might be due to other reasons,
but the point is that people are using compat_sched_yield=1

If you insist that sched_yield() is bad, I might agree, but how does my patch
make things worse. In my benchmarks, it has helped the sched_yield case, why is
that bad? As far as touching the hot-path is concerned, give me a benchmark that
I can run on my desktop, that will convince you that the overhead of the patch
is not all that high. If there is an overhead that is very visible, I'll stop
pushing the patch.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
