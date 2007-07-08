Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXGHNxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXGHNxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXGHNxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:53:09 -0400
Received: from il.qumranet.com ([82.166.9.18]:38922 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbXGHNxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:53:08 -0400
Message-ID: <4690EC47.6060904@qumranet.com>
Date: Sun, 08 Jul 2007 16:53:11 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com> <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com> <20070708134850.GB22911@elte.hu>
In-Reply-To: <20070708134850.GB22911@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>>> +#ifdef CONFIG_SCHED_KVM
>>>> +static __read_mostly struct sched_kvm_hooks kvm_hooks;
>>>> +#endif
>>>>         
>>> please just add a current->put_vcpu() function pointer instead of 
>>> this hooks thing.
>>>       
>> Won't that increase task_struct (16 bytes on 64-bit) unnecessarily?  
>> The function pointers are common to all virtual machines.
>>     
>
> well, this function pointer could then be reused by other virtual 
> machines as well, couldnt it? 

I don't get this.  If we add a couple of members to task_struct, it 
can't be reused.  The values will be the same across all tasks, but the 
memory will be gone (including tasks which aren't virtual machines).

> If the task struct overhead is a problem 
> (it really isnt, and it's dependent on CONFIG_KVM) then we could switch 
> it around to a notifier-alike mechanism.
>   

I'm hoping that CONFIG_KVM will be enabled on most distro kernels, so we 
need to optimize for that case as well.

-- 
error compiling committee.c: too many arguments to function

