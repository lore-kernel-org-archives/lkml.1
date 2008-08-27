Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbYH0BuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbYH0BuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 21:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYH0Bty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 21:49:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbYH0Btx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 21:49:53 -0400
Date: Tue, 26 Aug 2008 18:49:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Parag Warudkar <parag.lkml@gmail.com>
cc: Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808261837530.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>  <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>  <200808261111.19205.rusty@rustcorp.com.au>  <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>  <20080826183051.GB10925@cs181140183.pp.htv.fi>
  <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>  <20080826205916.GB11734@cs181140183.pp.htv.fi>  <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>  <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com> 
 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org> <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Parag Warudkar wrote:
>
> And although you said in your later reply that Linux x86 with 4K
> stacks should be more than usable - my experiences running a untainted
> desktop/file server with 4K stack have been always disastrous XFS or
> not.  It _might_ work for some well defined workloads but you would
> not want to risk 4K stacks otherwise.

Umm. How long?

4kB used to be the _only_ choice. And no, there weren't even irq stacks. 
So that 4kB was not just the whole kernel call-chain, it was also all the 
irq nesting above it.

And yes, we've gotten much worse over time, and no, I can't really suggest 
going back to that in general. The code bloat has certainly been 
accompanied by a stack bloat too.

But part of it is definitely gcc. Some versions of gcc used to be 
absolutely _horrid_ when it came to stack usage, especially with some 
flags, and especially with the crazy inlining that module-at-a-time 
caused.

But I'd be really happy if some embedded people tried to take some of that 
bloat back, and aim for 4kB stacks. Because it's definitely not 
unrealistic. At least it _shouldn't_ be. And a lot of the cases of us 
having structures on the stack is actually not worth it, and tends to be 
about being lazy rather than anything else.

			Linus
