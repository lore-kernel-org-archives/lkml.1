Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYJQES1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYJQES1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYJQESS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:18:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbYJQESS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:18:18 -0400
Date: Thu, 16 Oct 2008 21:18:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: benh@kernel.crashing.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
In-Reply-To: <20081016.210404.151891223.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop> <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org> <20081016.210404.151891223.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, David Miller wrote:
> 
> These modifiers are interesting, but wouldn't it be even nicer to just
> pick one output style and use it consistently in kernel messages for
> resources?

Sure, but I don't think we agree on what it would be. And quite frankly, 
it might depend on the resource.

For example, in traditional PCI, PIO resources would easily want to use 
%04x, which MMIO would use %08x. Sure, Linux _allows_ for bigger resources 
(ie you can have even PIO resources with the full 64-bit data), but it's 
not what you'd expect for any traditional stuff, and so it makes sense to 
make PIO resources show as %04x to get the old-fashioned resources shown 
in an expected manner.

We can do it inside the %pR code itself (just look at IORESOURCE_IO vs 
IORESOURCE_MEM), and maybe that's even the right approach. Maybe we want 
to even add flag bits, and show things like "IORESOURCE_PREFETCH" as a 
small marking automatically. But maybe people want to make it explicit.

I dunno. I'd certainly be perfectly happy with having the flags and 
field_width be specified by the resource flags. eg

	flags = ZEROPAD | SMALL;
	fieldwidth = (res->flags & IORESOURCE_IO) ? 4 : 8;

or something like that. But would it be acceptable to everybody?

			Linus
