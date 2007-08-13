Return-Path: <linux-kernel-owner+w=401wt.eu-S972218AbXHMQA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972218AbXHMQA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765991AbXHMOTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:19:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:40947 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S944551AbXHMOTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:19:39 -0400
Message-ID: <46C06885.3020908@qumranet.com>
Date: Mon, 13 Aug 2007 17:19:49 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: kvm-devel@lists.sourceforge.net, Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       cotte@de.ibm.com
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <46C00FC1.1070306@qumranet.com> <46C012A8.2040908@bull.net> <200708131615.42643.borntraeger@de.ibm.com>
In-Reply-To: <200708131615.42643.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Montag, 13. August 2007 schrieb Laurent Vivier:
>   
>>> [copying Ingo and Rusty]
>>>       
>
> @Avi, seems that sourceforge is mangling the cc list?
>
>   

It's not configured to do so.  Can you be more specific?


>>> The patches look good.  A couple of comments:
>>>
>>> - perhaps the new fields should be guarded by a #ifdef CONFIG_HYPERVISOR
>>> (selected by CONFIG_KVM)?  that way the (minor) additional overhead is
>>> only incurred if it can possibly be used.  I imagine that our canine
>>> cousin will want to use this as well.
>>>       
>> There is also a CONFIG_VIRTUALIZATION and a CONFIG_VIRT_CPU_ACCOUNTING (from
>> s390 and powerpc) Which one to use ?
>>     
>
> CONFIG_VIRT_CPU_ACCOUNTING is used for the precise accouting of user,system, 
> steal and irq time on these platforms and is not what you want for the on/off 
> decision. 
>   

Ah, ok.

>> I'm wondering if we can have a more accurate accounting:
>>
>> - For the moment we add all system time since the previous entering to the
>> VCPU to the guest time (and I guess there is some real system time in
>> it ???) 
>> - Perhaps we can sum nanoseconds spent in the VCPU and add it to cpustat
>> when these ns are greater than 1 ms ? (I'm trying to make something in this 
>>     
> way)
>
> If you look at the patch I have posted some minutes ago, I use a method 
> similar to irq_enter and irq_exit to separate real system time from guest 
> time. 

Yes.  This is orthogonal to the current accounting patch and should make 
a nice extension.  It's probably useful with dynamic tick where timer 
interrupts can be rare.


-- 
error compiling committee.c: too many arguments to function

