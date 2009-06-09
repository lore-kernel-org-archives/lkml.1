Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZFIP4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZFIP4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZFIP4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:56:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46132 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbZFIP4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:56:41 -0400
Message-ID: <4A2E860D.8070903@redhat.com>
Date: Tue, 09 Jun 2009 18:55:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <alpine.LFD.2.01.0906090749380.6847@localhost.localdomain> <20090609145736.GA31535@elte.hu>
In-Reply-To: <20090609145736.GA31535@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>   
>> I was benchmarking btrfs on my little EeePC. There, kmap overhead 
>> was 25% of file access time. Part of it is that people have been 
>> taught to use "kmap_atomic()", which is usable under spinlocks and 
>> people have been told that it's "fast". It's not fast. The whole 
>> TLB thing is slow as hell.
>>     
>
> yeah. I noticed it some time ago that INVLPG is unreasonably slow.
>
> My theory is that in the CPU it's perhaps a loop (in microcode?) 
> over _all_ TLBs - so as TLB caches get larger, INVLPG gets slower 
> and slower ...
>   

The tlb already content-addresses entries when looking up translations, 
so it shouldn't be that bad.

invlpg does have to invalidate all the intermediate entries 
("paging-structure caches"), and it does (obviously) force a tlb reload.

I seem to recall 50 cycles for invlpg, what do you characterize as 
unreasonably slow?

-- 
error compiling committee.c: too many arguments to function

