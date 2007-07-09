Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbXGIGlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbXGIGlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXGIGlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:41:44 -0400
Received: from il.qumranet.com ([82.166.9.18]:39810 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXGIGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:41:44 -0400
Message-ID: <4691D8A2.2040706@qumranet.com>
Date: Mon, 09 Jul 2007 09:41:38 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, KVM <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com> <p73ir8uzpcx.fsf@bingen.suse.de>
In-Reply-To: <p73ir8uzpcx.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 09 Jul 2007 09:41:39 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc list restored]

Andi Kleen wrote:
> Avi Kivity <avi-atKUWr5tajBWk0Htik3J/w@public.gmane.org> writes:
>   
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 693f0e6..b705876 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -875,6 +875,10 @@ struct task_struct {
>>  	pid_t pid;
>>  	pid_t tgid;
>>  
>> +#ifdef CONFIG_SCHED_KVM
>> +	struct kvm_vcpu *kvm_vcpu;
>> +#endif
>>     
>
> You should be careful to put this into a cache line that 
> is already touched during context switch. Otherwise
> if it needs an additional cache miss it might become
> very costly
>   

Yeah, I'll look into task_struct again to find a good place.

> Also it's a bit worrying to expose hooks into the scheduler
> to any modules. How would others be stopped from abusing this?
>   

The functions for installing a hook are out-of-line and
EXPORT_SYMBOL_GPL'ed, in case that helps.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

