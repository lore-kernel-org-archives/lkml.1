Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZBZIlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZBZIlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZBZIlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:41:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65493 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbZBZIlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:41:00 -0500
Message-ID: <49A655B0.9020002@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 16:41:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
References: <49A6475F.4000502@cn.fujitsu.com> <20090226083702.GI11421@balbir.in.ibm.com>
In-Reply-To: <20090226083702.GI11421@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Li Zefan <lizf@cn.fujitsu.com> [2009-02-26 15:40:15]:
> 
>> cpuacct_charge() is in fast-path, and checking of !cpuacct_susys.active
>> always returns false after cpuacct has been initialized at system boot.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/sched.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 410eec4..fd2f7fc 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -9589,7 +9589,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>>  	struct cpuacct *ca;
>>  	int cpu;
>>
>> -	if (!cpuacct_subsys.active)
>> +	if (unlikely(!cpuacct_subsys.active))
> 
> What happens if most distros make cpuacct_subsys active? Can we decide
> on unlikely depending on how the system is configured?
> 

Note, it's ->active but not ->disabled. ;)

And note, I make it "unlikely(!cpuacct_subsys.active)", but not "unlikely(cpuacct_subsys.active)"

->active can't be configured by users. If CONFIG_CGROUP_CPUACCT is enabled,
cpuacct_subsys.active will be set to true after cpuacct is initialized.

