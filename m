Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbZEYFNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbZEYFNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZEYFNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:13:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49314 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZEYFNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:13:22 -0400
Message-ID: <4A1A28AD.8060600@redhat.com>
Date: Mon, 25 May 2009 08:12:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <20090519123548.GA26439@elte.hu> <4A19A9A4.8010002@redhat.com> <20090525035158.GB9396@elte.hu> <4A1A24C0.20701@redhat.com> <20090525050630.GB23032@elte.hu>
In-Reply-To: <20090525050630.GB23032@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>>> We do something similar for Windows (by patching it) very  
>>>> successfully; Windows likes to touch the APIC TPR ~ 100,000 times  
>>>> per second, usually without triggering an interrupt.  We hijack  
>>>> these writes, do the checks in guest context, and only exit if the  
>>>> TPR write would trigger an interrupt.
>>>>     
>>>>         
>>> I suspect you aware of that this is about the io-apic not the local  
>>> APIC. The local apic methods are already driver-ized - and they sit  
>>> closer to the CPU so they matter more to performance.
>>>   
>>>       
>> Yeah, I gave this as an example.  It's very different -- io-apic 
>> vs.  local apic, paravirtualization vs. patching the guest behind 
>> its back, Linux vs. Windows.
>>
>> Of course if we hook the io-apic EOI we'll want to hook the local 
>> apic EOI as well.
>>     
>
> Yeah. Eventually anything that matters to performance will be 
> accelerated by hardware (and properly virtualized), which in turn 
> will be faster than any hypercall based approach, right?
>   

Right.  That's already happened to the TPR (Intel processors accelerate 
that 4-bit registers but ignore everything else in the local apic).  As 
another example, we have mmu paravirtualization in kvm, but 
automatically disable it when the hardware does nested paging.  The 
problem is that hardware support has a long pipeline, and even when 
support does appear, there's a massive installed base to care about.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

