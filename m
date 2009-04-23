Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZDWIEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZDWIEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbZDWHjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:39:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40609 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbZDWHjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:39:45 -0400
Date: Thu, 23 Apr 2009 09:43:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: New x86 warning
Message-ID: <20090423074320.GI13896@one.firstfloor.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain> <20090422211501.GD13896@one.firstfloor.org> <alpine.LFD.2.00.0904221417110.3101@localhost.localdomain> <20090422220428.GE13896@one.firstfloor.org> <20090423063053.GA9833@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423063053.GA9833@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:30:53AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > > Quick test here:
> > > 
> > > How about you just compile the kernel with gcc-3.2 and compare 
> > > the number of calls to memcpy before-and-after instead? That's 
> > > the real test.
> > 
> > I waited over 10 minutes for the full vmlinux objdumps to finish. 
> > sorry lost patience. If someone has a fast disassembler we can try 
> > it. I'll leave them running over night, maybe there are exact 
> > numbers tomorrow.
> 
> Uhm, the test Linus requested is very simple, it doesnt need 'full' 
> objdumps, just a plain defconfig [*] - an objdump takes less than 10 
> seconds here even on an old box i tried it on.
> 
> I just did this - it all took less than 5 minutes to do the whole 
> test with gcc34:
> 
>   vmlinux.gcc34.vanilla:       679 calls to memcpy
>   vmlinux.gcc34.gcc-memcpy:   1393 calls to memcpy
> 
> So your patch more than doubles the number of calls to out-of-line 
> memcpy on older GCC. That's not really acceptable 

How do you determine it's not acceptable?

It seems not nice to me, but not a fatal problem. I think
Linus was more interested in dramatic growth, but factor 2 over
a very large code base doesn't seem to be dramatic to me, especially
since it's very likely most of the are slow path code.

> Next time you send such patches please test with older GCCs straight 
> away - it's a basic act of testing when doing a patch that 'lets GCC 

I tested with 3.2.3, but not with 3.4.

3.2.3 doesn't do that. AFAIK 3.2 was a pretty common compiler; at least
several SUSE releases shipped with it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
