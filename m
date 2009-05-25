Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZEYFU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZEYFU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZEYFUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:20:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37918 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbZEYFUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:20:17 -0400
Date: Mon, 25 May 2009 07:19:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
Message-ID: <20090525051954.GD23032@elte.hu>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <20090519123548.GA26439@elte.hu> <4A19A9A4.8010002@redhat.com> <20090525035158.GB9396@elte.hu> <4A1A24C0.20701@redhat.com> <20090525050630.GB23032@elte.hu> <4A1A28AD.8060600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A28AD.8060600@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Avi Kivity <avi@redhat.com> wrote:
>>
>>   
>>> Ingo Molnar wrote:
>>>     
>>>>> We do something similar for Windows (by patching it) very   
>>>>> successfully; Windows likes to touch the APIC TPR ~ 100,000 times 
>>>>>  per second, usually without triggering an interrupt.  We hijack  
>>>>> these writes, do the checks in guest context, and only exit if 
>>>>> the  TPR write would trigger an interrupt.
>>>>>             
>>>> I suspect you aware of that this is about the io-apic not the local 
>>>>  APIC. The local apic methods are already driver-ized - and they 
>>>> sit  closer to the CPU so they matter more to performance.
>>>>         
>>> Yeah, I gave this as an example.  It's very different -- io-apic vs.  
>>> local apic, paravirtualization vs. patching the guest behind its 
>>> back, Linux vs. Windows.
>>>
>>> Of course if we hook the io-apic EOI we'll want to hook the local  
>>> apic EOI as well.
>>>     
>>
>> Yeah. Eventually anything that matters to performance will be 
>> accelerated by hardware (and properly virtualized), which in turn 
>> will be faster than any hypercall based approach, right?
>
> Right.  That's already happened to the TPR (Intel processors 
> accelerate that 4-bit registers but ignore everything else in the 
> local apic).  As another example, we have mmu paravirtualization 
> in kvm, but automatically disable it when the hardware does nested 
> paging.  The problem is that hardware support has a long pipeline, 
> and even when support does appear, there's a massive installed 
> base to care about.

Yeah. Btw., i also think that in-kernel IO-APIC and APIC emulation 
could have uses elsewhere as well - such as in testing. Currently 
you actually have to own a big box to be able to test certain 
hardware limits. This has a negative effect on test coverage and a 
subsequent negative effect on kernel quality. If KVM provided clean 
code to emulate certain hw environments we could check out limits 
(and our bugs) far more effectively.

	Ingo
