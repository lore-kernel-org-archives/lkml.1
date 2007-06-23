Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXFWK1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXFWK1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXFWK1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:27:40 -0400
Received: from barikada.upol.cz ([158.194.242.200]:52872 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXFWK1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:27:39 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706221312520.18841@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com> <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com> <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org> <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com> <Pine.LNX.4.64.0706221143190.17958@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706221955360.9081@blonde.wat.veritas.com> <Pine.LNX.4.64.0706221312520.18841@schroedinger.engr.sgi.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: jed
X-Mailer: slrn (x86_64-pc-linux-glibc-debian)
Date: Sat, 23 Jun 2007 12:40:20 +0200
Message-Id: <E1I232S-0006OQ-B0@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: Christoph Lameter
* Newsgroups: linux.kernel,linux.ports.arm.kernel
* Date: Fri, 22 Jun 2007 13:15:19 -0700 (PDT)
>
> Here is the corresponding PA-RISC piece. Its as straightforward as 
> the other one since the only way to make this work properly in the past 
> was if the sizes passed to the dma alloc functions are page size based.
[]
> --- linux-2.6.orig/arch/parisc/kernel/pci-dma.c	2007-06-22 13:02:32.000000000 -0700
> +++ linux-2.6/arch/parisc/kernel/pci-dma.c	2007-06-22 13:06:39.000000000 -0700
> @@ -572,7 +572,7 @@ static void *pa11_dma_alloc_noncoherent(
>  	void *addr = NULL;
>  
>  	/* rely on kmalloc to be cacheline aligned */
> -	addr = kmalloc(size, flag);
> +	addr = (void *)__get_free_pages(flag, get_order(size));

Seems like comment must be removed.
____
