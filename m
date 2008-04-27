Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbYD0XCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbYD0XCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764750AbYD0XC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:02:26 -0400
Received: from www.tglx.de ([62.245.132.106]:48931 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764728AbYD0XCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:02:25 -0400
Date: Mon, 28 Apr 2008 01:01:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Garzik <jeff@garzik.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
In-Reply-To: <4815009C.2010809@garzik.org>
Message-ID: <alpine.LFD.1.10.0804280046100.3261@apollo.tec.linutronix.de>
References: <1209329485.3801.46.camel@localhost.localdomain>  <20080427214837.GA11631@elte.hu> <1209335660.3801.79.camel@localhost.localdomain> <4815009C.2010809@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008, Jeff Garzik wrote:
> 
> Isn't there Yet More Breakage in lib/iomap.c, given these new semantics?
> 
>         if (flags & IORESOURCE_MEM) {
>                 if (flags & IORESOURCE_CACHEABLE)
>                         return ioremap(start, len);
>                 return ioremap_nocache(start, len);
>         }

That's broken anyway as we are inconsistent across
architectures. ioremap defaults to uncached at least on:

POWERPC, ARM, MIPS, SH, FRV, PARISC, H8300, M68K, BLACKFIN, M68KNOMMU

So changing the above to ioremap_cache() would provide the desired
results across architectures.

Thanks,

	tglx
