Return-Path: <linux-kernel-owner+w=401wt.eu-S1422966AbXDYXLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422966AbXDYXLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXDYXLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:11:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509AbXDYXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:11:28 -0400
Date: Wed, 25 Apr 2007 16:10:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425224928.GJ17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704251601020.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425224928.GJ17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Pavel Machek wrote:
> >
> > I don't understand how you can even *claim* something like that.
> 
> BTW most problems are in thaw/resume functions.

And do you realize that the thaw/resume functions are totally different 
too?

Or rather, they *would* be, if you allowed them to.

For example, for "snapshot + thaw", the _sane_ thing is to actually make 
the snapshot just throw away all the DMA tables etc, and let the thawing 
just do a full initialization (as it did on boot). It basically needs to 
do that anyway, and it simplifies the whole thing (ie you don't even 
*want* to save things like the DMA command queues etc - the ones that will 
quite often be stepped on by the final "write snapshot to disk" stuff 
anyway).

For suspend to ram, in contrast, since you *know* that nobody will be 
touching the hardware, and since the timings are very different anyway 
(you'd hope that you can resume in a second or two), you'd generally want 
to keep the DMA engine tables right where they are, and just literally 
suspend the PCI chip itself.

See? Again, *nothing* in common.

You think they have things in common just because your whole (incorrect) 
mindset has _forced_ them to have things in common, becasue your setup 
stupidly thinks that "resume" is the same as "thaw", the same way you 
think "freeze" is the same as "suspend".

NEITHER is true. You've _made_ them true in your mind, but there's 
absolutely zero reason that they *should* be true.

			Linus
