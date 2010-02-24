Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab0BXK2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:28:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab0BXK2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:28:07 -0500
Message-ID: <4B84FF2F.5040705@redhat.com>
Date: Wed, 24 Feb 2010 12:27:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Thomas Gleixner <tglx@linutronix.de>, KVM <kvm@vger.kernel.org>,
       Gleb Natapov <gleb@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Kick VCPU outside PIC lock again
References: <20100217135901.331576359@linutronix.de> <4B842A1F.50601@siemens.com> <alpine.LFD.2.00.1002232321320.3232@localhost.localdomain> <4B84F466.2080009@siemens.com> <4B84F5D4.5020202@redhat.com> <4B84F765.5040209@siemens.com> <4B84F9AF.8060804@redhat.com> <4B84FBDB.1070006@siemens.com> <4B84FCBB.8070702@redhat.com> <4B84FDF5.5080106@siemens.com>
In-Reply-To: <4B84FDF5.5080106@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2010 12:22 PM, Jan Kiszka wrote:
> Avi Kivity wrote:
>    
>> On 02/24/2010 12:13 PM, Jan Kiszka wrote:
>>      
>>>
>>>        
>>>> I see.  Won't we hit the same issue when we call pic functions from
>>>> atomic context during the guest entry sequence?
>>>>
>>>>
>>>>          
>>> If there are such call paths, for sure. What concrete path(s) do you
>>> have in mind?
>>>
>>>
>>>        
>> vcpu_enter_guest() ->  inject_pending_event() ->
>> kvm_cpu_{has,get}_interrupt() ->  various pic functions if you're unlucky.
>>      
> But do they kick anyone or just check/pull information?

Probably not, kicking should be a side effect (or rather the main 
effect) of queueing an interrupt, not dequeuing it.

> Never saw any
> warnings during my tests last year (granted: with older -rt and kvm
> versions).
>    

Well, most guests kill the pic early on.  Will apply the patch.

-- 
error compiling committee.c: too many arguments to function

