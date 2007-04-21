Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXDUXhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXDUXhc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbXDUXhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:37:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbXDUXhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:37:21 -0400
Date: Sat, 21 Apr 2007 16:35:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@gmail.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
In-Reply-To: <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0704211634130.9964@woody.linux-foundation.org>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu>
  <20070421154614.GA26169@elte.hu> <20070421161818.GC7840@1wt.eu> 
 <alpine.LFD.0.98.0704210931370.9964@woody.linux-foundation.org> 
 <20070421164241.GF2986@holomorphy.com>  <E1192E83-5E64-4782-8F92-DDCA09CA2F55@mac.com>
 <a36005b50704211249pb771b79k227914515b5f9906@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Apr 2007, Ulrich Drepper wrote:
> 
> If you do this, and it has been requested many a times, then please
> generalize it.  We have the same issue with futexes.  If a FUTEX_WAIT
> call is issues the remaining time in the slot should be given to the
> thread currently owning the futex.

And how the hell do you imagine you'd even *know* what thread holds the 
futex?

The whole point of the "f" part of the mutex is that it's fast, and we 
never see the non-contended case in the kernel. 

So we know who *blocks*, but we don't know who actually didn't block.

		Linus
