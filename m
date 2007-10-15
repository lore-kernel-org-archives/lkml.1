Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbXJOLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbXJOLQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbXJOLQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:16:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:35037 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707AbXJOLQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:16:07 -0400
Message-ID: <47134BCE.1080306@qumranet.com>
Date: Mon, 15 Oct 2007 13:15:26 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time	accounting.
References: <46E550EF.5080209@bull.net> <20071015093800.GA22818@elte.hu> <47133732.2090809@qumranet.com> <20071015095125.GB28367@elte.hu> <47133ABD.8050608@qumranet.com> <471346B0.8050102@bull.net>
In-Reply-To: <471346B0.8050102@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> Avi Kivity wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> * Avi Kivity <avi@qumranet.com> wrote:
>>>
>>>  
>>>       
>>>> This bit can go; for the external module I can add it back in
>>>> external-module-compat.h.  No need to pollute mainline with backward
>>>> compatibility stuff.
>>>>     
>>>>         
>>> hm:
>>>
>>> static inline void kvm_guest_enter(void)
>>> {
>>>         current->flags |= PF_VCPU;
>>> }
>>>
>>> static inline void kvm_guest_exit(void)
>>> {
>>> }
>>>
>>> shouldnt PF_VCPU be cleared in kvm_guest_exit()?
>>>   
>>>       
>> IIRC the accounting code clears it, but yes, it may not have been called
>> at all, so clearing it here is needed.
>>
>>     
>
> No, It must not be cleared here because we can't enter in the accounting code
> between kvm_guest_enter(void) and kvm_guest_exit(void).
>
>   

Right.

> This is why the accounting code clears it.
>   

But if we didn't get an interrupt in that time?

We can clear it a bit later, after local_irq_enable() in __vcpu_run().  
However we need a nop instruction first because "sti" keeps interrupts 
disabled for one more instruction.


-- 
error compiling committee.c: too many arguments to function

