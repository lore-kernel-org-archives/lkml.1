Return-Path: <linux-kernel-owner+w=401wt.eu-S1759136AbYHZSma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbYHZSma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbYHZSmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:42:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbYHZSmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:42:19 -0400
Date: Tue, 26 Aug 2008 11:40:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <20080826183051.GB10925@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0808261134530.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
 <20080826183051.GB10925@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Adrian Bunk wrote:
> 
> A debugging option (for better traces) to disallow gcc some inlining 
> might make sense (and might even make sense for distributions to 
> enable in their kernels), but when you go to use cases that require
> really small kernels the cost is too high.

You ignore the fact that it's really not just about debugging.

Inlining really isn't the great tool some people think it is. Especially 
not since gcc stack allocation is so horrid that it won't re-use stack 
slots etc (which I don't disagree with per se - it's _hard_ to re-use 
stack slots while still allowing code scheduling).

NOTE! I also would never claim that _our_ choices of "inline" are all that 
great, and we've often inlined too much or not inlined things that really 
could be inlined. But at least when a developer says "inline" (or forgets 
to say it), we have somebody to blame. When the compiler does insane 
things that doesn't suit us, we're just screwed.

> But if you don't trust gcc's inlining you should revert
> commit 3f9b5cc018566ad9562df0648395649aebdbc5e0 that increases gcc's 
> freedom regarding what to inline in 2.6.27

Actually, that just allows gcc to _not_ inline. Which is probably ok.

(Well, it would be ok if gcc did it well enough, it obviously has some 
problems at times).

			Linus
