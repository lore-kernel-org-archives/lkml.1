Return-Path: <linux-kernel-owner+w=401wt.eu-S1765588AbXHPTYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765588AbXHPTYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 15:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbXHPTYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 15:24:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbXHPTYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 15:24:06 -0400
Message-ID: <46C4A445.6070802@redhat.com>
Date: Thu, 16 Aug 2007 15:23:49 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Herbert Xu <herbert.xu@redhat.com>
CC: Andi Kleen <ak@suse.de>, sebastian@breakpoint.cc,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations
 already do.
References: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au> <46C3319F.4050809@redhat.com> <20070815234434.GC28775@gondor.apana.org.au>
In-Reply-To: <20070815234434.GC28775@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Wed, Aug 15, 2007 at 01:02:23PM -0400, Chris Snook wrote:
>> Herbert Xu wrote:
>>> Andi Kleen <ak@suse.de> wrote:
>>>>> My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
>>>>>  text    data     bss     dec     hex filename
>>>>> 3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
>>>>> 3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux
>>>> What is the difference between atomic_normal and atomic_inlineasm? 
>>> The inline asm stops certain optimisations from occuring.
>>>
>>> I'm still unconvinced why we need this because nobody has
>>> brought up any examples of kernel code that legitimately
>>> need this.
>> There's plenty of kernel code that *wants* this though.  If we can 
> 
> You keep saying this yet everytime I ask for an example I
> get nothing.

Just look for all the code (and there's an immense amount) that has a 
barrier() between two atomic_* operations, or in a loop with such 
operations.  With these patches merged, we can proceed to *remove* those 
barriers.

>> reduce the need for register-clobbering barriers, shrink our binaries, 
>> shrink our code, improve performance, and avoid heisenbugs, I think it's 
>> a win, whether or not we *need* it.
> 
> Hmm, you're increasing our binary size and probably killing
> performance.

The cost of these patches themselves is negligible, since people pretty 
much always use barriers in places where it would matter.  The long-term 
benefit is that with guaranteed volatile behavior, we can go through and 
remove a whole bunch of these barriers.

	-- Chris
