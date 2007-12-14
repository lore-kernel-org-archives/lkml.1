Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbXLNPvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbXLNPvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932383AbXLNPun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:50:43 -0500
Received: from gw.goop.org ([64.81.55.164]:52818 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbXLNPul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:50:41 -0500
Message-ID: <4762A640.2050600@goop.org>
Date: Fri, 14 Dec 2007 07:50:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 2/4] x86: unify pgtable*.h
References: <47623ADD.9090607@goop.org> <20071214093715.GB11266@elte.hu>
In-Reply-To: <20071214093715.GB11266@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> All x86 modes and architectures have very similar pagetable 
>> structures: the page flags, the accessors for testing/setting them, 
>> and the combinations of page flags used for kernel and usermode 
>> mappings are all the same.  The main difference is between 32 and 
>> 64-bit pagetable entries, with the latter supporting the NX bit.
>>
>> The most significant difference between the modes/architectures is the 
>> number of levels in the pagetable (4 for 64-bit, 3 for 32-bit/PAE, 2 
>> for non-PAE 32-bit).  This accounts for the remaining code in the 
>> various mode-specific headers.
>>
>> I've tried to avoid changing formatting as much as possible, so that 
>> the code motion is more obvious.  A subsequent patch will clean things 
>> up in place.
>>     
>
> the dreaded auto-qa - this patch fails to build:
>
>  arch/x86/mm/init_32.c: In function 'mark_rodata_ro':
>  arch/x86/mm/init_32.c:811: error: 'PAGE_KERNEL_RX' undeclared (first use in this function)
>  arch/x86/mm/init_32.c:811: error: (Each undeclared identifier is reported only once
>  arch/x86/mm/init_32.c:811: error: for each function it appears in.)
>  make[1]: *** [arch/x86/mm/init_32.o] Error 1
>   

Sigh.  Shouldn't be too hard to deal with.

> config attached. I'll skip this series of your patches for now. I'd 
> expect this to be one of the hardest areas to unify - it's one of the 
> areas with the largest amount of arbitrary deviations between 32-bit and 
> 64-bit and these include files permeate everything.
>   

Yeah, it's been great fun :(.  On the other hand, I think its getting
there; the interactions between the various headers is getting more
comprehensible, and moving to a consistent use of inline functions
rather than a mixture of macros and inlines is making things more
deterministic.

> ( In case you are thinking about approaching this differently, i'd 
>   suggest a strategy that doesnt just try to unify the whole kit at once 
>   but does it with very small steps where each step is trivially 
>   verifyable. 50 small patches are generally a lot easier to create than 
>   5 big patches. [ Of course if you can do 5 perfect patches that's just 
>   as good :-) ] )
>   

Yeah, I tried doing it in smaller pieces, but its fairly difficult just
because its all so inter-tangled.  But I think its close now.

    J
