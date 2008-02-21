Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbYBUKWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbYBUKWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 05:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbYBUKWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 05:22:08 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52816 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbYBUKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 05:22:07 -0500
Message-ID: <47BD4FBF.8010701@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 15:47:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com> <20080221090430.GA20055@elte.hu> <47BD44FF.7070104@linux.vnet.ibm.com>
In-Reply-To: <47BD44FF.7070104@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Ingo Molnar wrote:
>> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>>> If you insist that sched_yield() is bad, I might agree, but how does 
>>> my patch make things worse. [...]
>> it puts new instructions into the hotpath.
>>
>>> [...] In my benchmarks, it has helped the sched_yield case, why is 
>>> that bad? [...]
>> I had the same cache for the rightmost task in earlier CFS (it's a 
>> really obvious thing) but removed it. It wasnt a bad idea, but it hurt 
>> the fastpath hence i removed it. Algorithms and implementations are a 
>> constant balancing act.
> 
> This is more convincing, was the code ever in git? How did you measure the
> overhead? What are your plans for reports with regressions where
> kernel.compat_sched_yield is set to 1?
> 

Ingo,

I was looking through nptl/sysdeps/unix/sysv/linux/pthread_yield.c in the glibc
sources and it looks like pthread_yield() calls sched_yield(). Applications
using compat_sched_yield and pthread_yield() are also going to be impacted.

I searched for pthread_yield and sched_yield using google codesearch to look at
the applications that use these routines, the search list is too big for me to
mark applications as candidates for potential improvement.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
