Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXGHNlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXGHNlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXGHNlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:41:03 -0400
Received: from il.qumranet.com ([82.166.9.18]:55818 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbXGHNlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:41:01 -0400
Message-ID: <4690E973.7000606@qumranet.com>
Date: Sun, 08 Jul 2007 16:41:07 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com> <20070708133539.GA12597@elte.hu>
In-Reply-To: <20070708133539.GA12597@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> +#ifdef CONFIG_SCHED_KVM
>> +static __read_mostly struct sched_kvm_hooks kvm_hooks;
>> +#endif
>>     
>
> please just add a current->put_vcpu() function pointer instead of this 
> hooks thing.
>
>   

Won't that increase task_struct (16 bytes on 64-bit) unnecessarily?  The 
function pointers are common to all virtual machines.

>>  static inline void prepare_task_switch(struct rq *rq, struct task_struct *next)
>>  {
>> +	unload_kvm_vcpu(current);
>>  	prepare_lock_switch(rq, next);
>>  	prepare_arch_switch(next);
>>  }
>> @@ -1860,6 +1912,7 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
>>  	prev_state = prev->state;
>>  	finish_arch_switch(prev);
>>  	finish_lock_switch(rq, prev);
>> +	reload_kvm_vcpu(current);
>>     
>
> ok, this looks certainly cheap enough from a scheduler POV, and it 
> cleans up the whole KVM/scheduling interaction quite nicely. (I'd not 
> bother with tweaking the migration logic, there's enough incentive for 
> the scheduler to keep tasks from migrating unnecessarily.)
>   

Okay.

-- 
error compiling committee.c: too many arguments to function

