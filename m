Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbXHOMtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbXHOMtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbXHOMtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:49:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbXHOMtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:49:32 -0400
Date: Wed, 15 Aug 2007 18:32:10 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Andi Kleen <ak@suse.de>, sebastian@breakpoint.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations
 already do.
In-Reply-To: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au>
Message-ID: <alpine.LFD.0.999.0708151809420.16414@enigma.security.iitk.ac.in>
References: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Aug 2007, Herbert Xu wrote:

> Andi Kleen <ak@suse.de> wrote:
> >> My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
> >>   text    data     bss     dec     hex filename
> >> 3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
> >> 3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux
> > 
> > What is the difference between atomic_normal and atomic_inlineasm? 
> 
> The inline asm stops certain optimisations from occuring.

Yup, the "__volatile__" after "__asm__" shouldn't be required. The
previous definitions allowed the compiler to optimize certain atomic
ops away, and considering we haven't seen any bugs due to the past
behaviour anyway, changing it like this sounds unnecessary.

The second behavioral change that comes about here is the force-
constraining of v->counter to memory in the extended asm's constraint
sets. But that's required to give "volatility"-like behaviour, which
I suspect is the goal of this patch.

Sebastian, could you look at the kernel images in detail and see why,
how and what in the text expanded by 1158 bytes with these changes?


> I'm still unconvinced why we need this because nobody has
> brought up any examples of kernel code that legitimately
> need this.

Me too, but I do find these more palatable than the variants using
"volatile", I admit.


Satyam
