Return-Path: <linux-kernel-owner+w=401wt.eu-S1031297AbXDZQDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031297AbXDZQDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbXDZQDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:03:40 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811AbXDZQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:03:38 -0400
Date: Thu, 26 Apr 2007 09:02:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070426141423.20aa88ec@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0704260859400.9964@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425235718.66b71f01@the-village.bc.nu>
 <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
 <20070425235235.GN17387@elf.ucw.cz> <alpine.LFD.0.98.0704251702290.9964@woody.linux-foundation.org>
 <20070426001414.GO17387@elf.ucw.cz> <alpine.LFD.0.98.0704251734320.9964@woody.linux-foundation.org>
 <463008A2.9020301@zytor.com> <alpine.LFD.0.98.0704251915460.9964@woody.linux-foundation.org>
 <20070426141423.20aa88ec@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Alan Cox wrote:
>
> > The PCI spec for controlling DMA is really pretty nasty. You can disable 
> > it in the PCI config word, of course, but that usually just messes up the 
> > device entirely.
> 
> And some devices ignore it. Some of the older Cyrix stuff I have appears
> not to care how the master bit is set.

I'm not surprised. If the choice is between locking up the PCI bus by 
hanging the device in endless retries, or just ignoring the bit, I suspect 
"just ignore it" is actually the better choice.

Of course, in a perfect world you'd happily honor it, raise a PCI error, 
and all is good, but in practice the internal state machine of most 
non-trivial hardware is simply so complicated that the "abort gracefully" 
simply isn't an option.

The hw people have enough problems in getting things to work when 
everything is peachy and well, and a lot of companies end up releasing 
stuff with known errata for even the _normal_ cases, just because they 
expect software to work around them ("Doctor, doctor, it hurts when I do 
the documented access!" "You didn't read errata #317, did you? Don't do 
that, then!")

			Linus
