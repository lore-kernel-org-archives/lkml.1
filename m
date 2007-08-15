Return-Path: <linux-kernel-owner+w=401wt.eu-S934335AbXHORDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335AbXHORDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934113AbXHORCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:02:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934193AbXHORCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:02:47 -0400
Message-ID: <46C3319F.4050809@redhat.com>
Date: Wed, 15 Aug 2007 13:02:23 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Andi Kleen <ak@suse.de>, sebastian@breakpoint.cc,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations
 already do.
References: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au>
In-Reply-To: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Andi Kleen <ak@suse.de> wrote:
>>> My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
>>>   text    data     bss     dec     hex filename
>>> 3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
>>> 3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux
>> What is the difference between atomic_normal and atomic_inlineasm? 
> 
> The inline asm stops certain optimisations from occuring.
> 
> I'm still unconvinced why we need this because nobody has
> brought up any examples of kernel code that legitimately
> need this.

There's plenty of kernel code that *wants* this though.  If we can 
reduce the need for register-clobbering barriers, shrink our binaries, 
shrink our code, improve performance, and avoid heisenbugs, I think it's 
a win, whether or not we *need* it.

	-- Chris
