Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0BXJsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:48:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab0BXJsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:48:12 -0500
Message-ID: <4B84F5D4.5020202@redhat.com>
Date: Wed, 24 Feb 2010 11:48:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Thomas Gleixner <tglx@linutronix.de>, KVM <kvm@vger.kernel.org>,
       Gleb Natapov <gleb@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Kick VCPU outside PIC lock again
References: <20100217135901.331576359@linutronix.de> <4B842A1F.50601@siemens.com> <alpine.LFD.2.00.1002232321320.3232@localhost.localdomain> <4B84F466.2080009@siemens.com>
In-Reply-To: <4B84F466.2080009@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 11:41 AM, Jan Kiszka wrote:
> Thomas Gleixner wrote:
>    
>> On Tue, 23 Feb 2010, Jan Kiszka wrote:
>>
>>      
>>> Thomas Gleixner wrote:
>>>        
>>>> The i8254/i8259 locks need to be real spinlocks on preempt-rt. Convert
>>>> them to raw_spinlock. No change for !RT kernels.
>>>>          
>>> Doesn't fly for -rt anymore: pic_irq_update runs under this raw lock and
>>> calls kvm_vcpu_kick which tries to wake_up some thread ->  scheduling
>>> while atomic.
>>>        
>> Hmm, a wakeup itself is fine. Is that code waking a wake queue ?
>>      
> Yes, it's a wake queue.
>    

So what's the core issue?  Is the lock_t in the wait_queue a sleeping mutex?

> This restores the deferred VCPU kicking before 956f97cf. We need this
> over -rt as wake_up* requires non-atomic context in this configuration.
>
>    

Seems sane, will apply once I understand why the current code fails.

-- 
error compiling committee.c: too many arguments to function

