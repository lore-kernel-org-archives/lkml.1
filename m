Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZCXSIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZCXSIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZCXSIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:08:45 -0400
Received: from gw.goop.org ([64.81.55.164]:50670 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbZCXSIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:08:44 -0400
Message-ID: <49C921A8.3090200@goop.org>
Date: Tue, 24 Mar 2009 11:08:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: 2.6.30 Xen merge plan (what's in xen.git)
References: <49C915A3.3020809@goop.org> <20090324174859.GB31117@elte.hu>
In-Reply-To: <20090324174859.GB31117@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Branches which mostly or entirely Xen (only trivial non-Xen changes):
>>
>> push2/xen/core
>>
>>    Updates to existing Xen support, features, optimisations, etc.
>>
>> push2/xen/control
>>
>>    A set of usermode interfaces for Xen (/sys/hypervisor, /dev/evtchn,
>>    updates to xenbus and xenfs)
>>     
>
> Will take a look.
>   

Thanks.

>> push2/xen/dom0/core
>>
>>    Core set of changes to add Xen dom0 functionality.  (Mostly
>>    Xen-only, but adds a new Xen mtrr driver.)
>>     
>
> I suspect this makes limited sense without the arch dom0 changes so 
> they should go with this bucket:
>   

Yes, you wouldn't get much beyond some console messages and a crash 
without the rest.

>> Branches with non-trivial non-Xen changes:
>>
>> push2/x86/paravirt
>>
>>    Allow preemption while doing a lazy mmu update.
>>     
>
> That's probably OK, just a bit late. If Thomas signs off on them 
> then i guess it might be OK later in the window - he's the one who 
> was struggling with paravirt lazy mmu fallout in the past. Thomas?
>   

I've posted those patches several times over the last month.  I needed 
to add a preempt_disable/enable pair in .29 to apply_to_page_range as a 
bugfix, which PeterZ, NickP and AKPM were not particularly happy about.  
This is the proper fix.

That said, they're not essential to the rest of the changes, and it 
would be fairly simple to drop them out (it would be a matter of 
clearing up some conflicts; no functional interactions).

>> push2/xen/dom0/apic
>>
>>    Changes to hook the Xen dom0 apic model into the standard platform
>>    apic code.  HPA reviewed and OKed this.
>>
>> push2/xen/dom0/pci
>>
>>    Add a Xen pci driver and dma_ops implementations.  Small changes to
>>    x86 pci+swiotlb code to add some function calls.
>>
>> push2/xen/dom0/agp
>>
>>    Change the AGP driver to allocate its memory using the
>>    pci_alloc_coherent to get guaranteed physically contiguous memory,
>>    and use proper phys<->bus functions so that Xen's pseudo-phys <->
>>    machine mappings are handled properly.
>>     
>
> hpa wanted dom0 changes in some cleaner fashion - he knows the 
> details. (he'll be back in a few days)
>   

When I spoke to him last week about this he said he was OK with it.  He 
didn't make any specific (or even general) objections.  Do you know 
which subsystem he was referring to?

    J
