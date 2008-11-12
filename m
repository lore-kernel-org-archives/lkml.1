Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYKLLwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYKLLwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYKLLwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:52:44 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:38977 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYKLLwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:52:42 -0500
Message-ID: <491AC37D.6050105@linux.vnet.ibm.com>
Date: Wed, 12 Nov 2008 17:22:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Vaidyanathan S <svaidyan@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [PATCH][mmotm] Sched fix stale value in average load per task
References: <20081112104900.GA13896@balbir.in.ibm.com> <20081112113514.GB6372@elte.hu>
In-Reply-To: <20081112113514.GB6372@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> cpu_avg_load_per_task() returns a stale value when nr_running is 0. 
>> It returns an older stale (caculated when nr_running was non zero) 
>> value. This patch returns and sets rq->avg_load_per_task to zero 
>> when nr_running is 0.
>>
>> Compile and boot tested on a x86_64 box.
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> ---
>>
>>  kernel/sched.c |    2 ++
>>  1 file changed, 2 insertions(+)
> 
> applied to tip/sched/urgent, thanks Balbir!
> 
> i'm wondering, have you observed load-balancer misbehavior due to this 
> load-average imprecision bug, on some workload? (or have you found 
> this via code review)


Thanks, Ingo!

I found this issue through code review. I did not see any misbehaviour yet due
to load-average imprecision.


-- 
	Balbir

PS: FYI: I missed this email, since my name was missing in the to and cc list.
Could you check to see if there is any issue with your mailer, I'll do the same.
