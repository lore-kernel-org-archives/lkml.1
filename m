Return-Path: <linux-kernel-owner+w=401wt.eu-S968942AbXHMQFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968942AbXHMQFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760827AbXHMOaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:30:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:57636 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S946016AbXHMOaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:30:12 -0400
Message-ID: <46C06AFE.2050702@qumranet.com>
Date: Mon, 13 Aug 2007 17:30:22 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net>	<200708131605.40479.borntraeger@de.ibm.com> <46C0693A.1080900@bull.net>
In-Reply-To: <46C0693A.1080900@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> Christian Borntraeger wrote:
>   
>> Am Freitag, 10. August 2007 schrieb Laurent Vivier:
>>     
>>> The aim of these two patches is to measure the CPU time used by a virtual
>>> machine. All comments are welcome... I'm not sure it's the good way to do 
>>>       
>> that.
>>
>> I did something similar for or s390guest prototype, that Carsten posted in 
>> May.  I decided to account guest time to the user process instead of adding a 
>> new field to avoid hazzle with old top. As you can read in the patch comment, 
>> I personally prefer a new field if we can get one.
>>
>> My implementation uses a similar mechanism like hard and softirq. So I have an 
>> sie_enter an sie_exit and a task_is_in_sie function - like irq_enter and 
>> irq_exit. The main difference is based on the fact, that s390 has precise 
>> accouting for irq, steal, user and system time, and therefore my patch is 
>> based on architecture specifc code using CONFIG_VIRT_CPU_ACCOUNT. 
>>
>> In general my patch has the same idea as your patch, so I am going to review 
>> your patch and see if it would fit for s390.
>>
>> For reference this is the (never posted) old patch for our virtualisation 
>> prototype. It wont work with kvm but it gives you the idea what we had in 
>> mind on s390.
>>
>>     
>
> thank you for your comment.
>
> As virtualization becomes very popular, perhaps we should implement something
> which could be used by all linux supported architectures ?
> (yes, I know it's non-sense for archs like m68k...)
> But my [PATCH 1/2] can be a good start (adding "guest" in cpustat)
> As guest accounting is hw dependent, I think we should add a hook in the
> accounting functions.
>   

Isn't PF_VM exactly such a hook?  All the hypervisor needs to do is to 
set/unset it correctly?

-- 
error compiling committee.c: too many arguments to function

