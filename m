Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab0BXJzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:55:42 -0500
Received: from goliath.siemens.de ([192.35.17.28]:21158 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0BXJzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:55:05 -0500
Message-ID: <4B84F765.5040209@siemens.com>
Date: Wed, 24 Feb 2010 10:54:45 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, KVM <kvm@vger.kernel.org>,
       Gleb Natapov <gleb@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Kick VCPU outside PIC lock again
References: <20100217135901.331576359@linutronix.de> <4B842A1F.50601@siemens.com> <alpine.LFD.2.00.1002232321320.3232@localhost.localdomain> <4B84F466.2080009@siemens.com> <4B84F5D4.5020202@redhat.com>
In-Reply-To: <4B84F5D4.5020202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 02/24/2010 11:41 AM, Jan Kiszka wrote:
>> Thomas Gleixner wrote:
>>    
>>> On Tue, 23 Feb 2010, Jan Kiszka wrote:
>>>
>>>      
>>>> Thomas Gleixner wrote:
>>>>        
>>>>> The i8254/i8259 locks need to be real spinlocks on preempt-rt. Convert
>>>>> them to raw_spinlock. No change for !RT kernels.
>>>>>          
>>>> Doesn't fly for -rt anymore: pic_irq_update runs under this raw lock and
>>>> calls kvm_vcpu_kick which tries to wake_up some thread ->  scheduling
>>>> while atomic.
>>>>        
>>> Hmm, a wakeup itself is fine. Is that code waking a wake queue ?
>>>      
>> Yes, it's a wake queue.
>>    
> 
> So what's the core issue?  Is the lock_t in the wait_queue a sleeping mutex?

Yep.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
