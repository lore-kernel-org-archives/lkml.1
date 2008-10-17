Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYJQFA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYJQFA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYJQFAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:00:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:50654 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYJQFAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:00:50 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>
	 <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
	 <20081016.210404.151891223.davem@davemloft.net>
	 <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 16:00:27 +1100
Message-Id: <1224219627.7654.80.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-16 at 21:18 -0700, Linus Torvalds wrote:
> 
> Sure, but I don't think we agree on what it would be. And quite frankly, 
> it might depend on the resource.
> 
> For example, in traditional PCI, PIO resources would easily want to use 
> %04x, which MMIO would use %08x. Sure, Linux _allows_ for bigger resources 
> (ie you can have even PIO resources with the full 64-bit data), but it's 
> not what you'd expect for any traditional stuff, and so it makes sense to 
> make PIO resources show as %04x to get the old-fashioned resources shown 
> in an expected manner.

Well, I was proposing that in the patch comments I think :-) We can do
some more specific formatting details in there based on the resource
flags, though we might also need some arch ifdef's in there.

It's better I think than having callers get it wrong in hundreds of
different ways.

> We can do it inside the %pR code itself (just look at IORESOURCE_IO vs 
> IORESOURCE_MEM), and maybe that's even the right approach. Maybe we want 
> to even add flag bits, and show things like "IORESOURCE_PREFETCH" as a 
> small marking automatically. But maybe people want to make it explicit.

I've been going on/off about the flags and decided to leave them alone
for now unless somebody comes up with a nice way to handle them. But
that doesn't mean we can't -use- the flags as you suggested to adjust
the format of the output.

The only little nit here is that the amount of digits needed for PIO is
fairly arch specific. So I might just stick an few ifdef's for the 4
possible cases (4, 8 and 16 digits) and let arch maintainers fix them up
(I'll default to 16 for everybody except x86 -> 4 and ppc -> 8).

As for the 36 bits trick of sparc32, I'll let DaveM do another arch hack
in there for now until he sorts it out.

I'll do a patch in a minute...

Cheers,
Ben.


