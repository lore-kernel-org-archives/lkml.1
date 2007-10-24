Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbXJXOzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbXJXOzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbXJXOzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:55:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:40836 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbXJXOzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:55:23 -0400
Message-ID: <471F5CAB.9020300@qumranet.com>
Date: Wed, 24 Oct 2007 16:54:35 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, bunk@kernel.org
Subject: Re: [PATCH] Define smp_call_function_mask() on uniprocessor builds
References: <11932158852325-git-send-email-avi@qumranet.com> <20071024074354.9edd4cee.akpm@linux-foundation.org>
In-Reply-To: <20071024074354.9edd4cee.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 24 Oct 2007 10:51:25 +0200 Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> Rather than #ifdef users of smp_call_function_mask(), define it as an
>> empty macro to avoid build errors.  The function explicitly prohibits
>> callers from specifying the current cpu, so nothing needs to be done.
>>
>> This unbreaks uniprocessor KVM builds.
>>
>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>>
>> diff --git a/include/linux/smp.h b/include/linux/smp.h
>> index 259a13c..24e2e31 100644
>> --- a/include/linux/smp.h
>> +++ b/include/linux/smp.h
>> @@ -108,6 +108,9 @@ static inline void smp_send_reschedule(int cpu) { }
>>  	0;			\
>>  })
>>  
>> +#define smp_call_function_mask(mask, func, info, wait) \
>> +	do { (void)(mask); (void)(func); (void)(info); (void)(wait); } while (0)
>> +
>>  #endif /* !SMP */
>>  
>>  /*
>>     
>
> The real smp_call_function_mask() returns int, so this version should do so
> also.
>
>   

Right.  Ingo sent a patch which does this.

[I can't think of a way to use that int though]

> An inlined C function will provide the needed references to the arguments -
> no need for those funny (void) thingies.  And it will provide typechecking.
>   

Last time I did this (on smp_call_function_single()), the build broke on 
a zillion-and-a-half archs due to include file hell.  That got patched 
into a macro. I saw the cpumask_t in there and got cold feet.

-- 
error compiling committee.c: too many arguments to function

