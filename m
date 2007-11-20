Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbXKTXWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbXKTXWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXKTXWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:22:45 -0500
Received: from rtr.ca ([76.10.145.34]:1153 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXKTXWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:22:44 -0500
Message-ID: <47436C43.6010200@rtr.ca>
Date: Tue, 20 Nov 2007 18:22:43 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca> <200711201517.16171.nickpiggin@yahoo.com.au> <20071119213727.16d5917b@laptopd505.fenrus.org> <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org> <20071120220110.GF24156@elte.hu>
In-Reply-To: <20071120220110.GF24156@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
>> kernel or kernel source? If there was a good place in the kernel 
>> source I'd not be against moving irqbalance there. [...]
> 
> would this be a good case study to use klibc and start up irqbalanced 
> automatically? I'd love it if we moved more of the 'system support' 
> userspace into the kernel proper, to keep it under control. (and to 
> simplify the compatibility and QA matrix)
..

Perhaps, but this also violates the principle that the kernel
should just *work* with sensible defaults.  I don't use an initrd,
or an initramfs, and have no intention of ever doing so.

I *like* having a single boot image with no unneeded/unwanted complexity.
It's only recently that I've even come round to using some loadable
modules for things like network drivers -- I prefer a single image
for as much as possible (like Linus there).

If putting a C-library and utilities "into the kernel" still leaves
me with a single image file, then.. maybe.  Seems clumsy, though.

Handling interrupts efficiently is a very basic, core function
for any operating system kernel.  With CONFIG_IRQBALANCE=y, Linux is
fine at present.  But that's not available in 64-bit mode,
so we have a deficiency there.

I guess I'll patch it into my kernels soon-ish.

Cheers
