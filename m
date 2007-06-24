Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbXFXWMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbXFXWMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFXWMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:12:35 -0400
Received: from barikada.upol.cz ([158.194.242.200]:32846 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbXFXWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:12:35 -0400
Date: Mon, 25 Jun 2007 00:25:18 +0200
To: rae l <crquan@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization
Message-ID: <20070624222518.GA10398@flower.upol.cz>
References: <467cac85.081b600a.5b88.457f@mx.google.com> <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 08:58:10PM +0800, rae l wrote:
> On 6/23/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> >Why not just show actual objdump output on code (maybe with different
> >oxygen atoms used in gcc), rather than *talking* about optimization and
> >standards, hm?
> here is the objdump output of the two object files:
> As you could see, the older one used 0x38 bytes stack space while the
> new one used 0x28 bytes,
> and the object code is two bytes less,

Actually more: $((0x3d9 - 0x3ce))

> I think all these benefits are the gcc's __builtin_memset optimization
> than the explicit call to memset.

... or from complex memset() implementation (some chips even didn't do
`rep' fast enough somehow). Maybe code like below will be acceptable for
both optimizers and maintainers?

|-*-
        unsigned long max_zone_pfns[MAX_NR_ZONES] = {
                [ZONE_DMA] = MAX_DMA_PFN,
                [ZONE_DMA32] = MAX_DMA32_PFN,
                [ZONE_NORMAL] = end_pfn,
                [ZONE_MOVABLE] = 0UL
        };
|-*-

> $ objdump -d /tmp/init.orig.o|grep -A23 -nw '<paging_init>'
[]
> 547- 3d9:       c3                      retq
[]
> 545- 3ce:       c3                      retq
[]
> >
> >I bet, that will be a key for success. And if you are interested in such
> >optimizations, why not to grep whole source tree for this kind of
> >things? I'm not sure one function in arch/x86_64 is only such 
> >``unoptimized''.
> >And after doing that maybe you will see, that "{}" initializer can be
> >applied not only to integer values (you did init with of *long int*,
> >with *int*, btw), but to structs and others.
> with '{}' initializer, gcc will fill its memory with zeros.
> 
> to other potential points to be optimized, I only see this trivial as
> the first point, I wonder how people gives comments on this; and if
> this optimization can be tested correctly, this can be done as an
> optimization example and I'll try others.

Yes, comments and discussion is most important thing. But with such
propositions you will be better in the kernel-janitors list.

> >
> >Ahh, one more thing about _optimizing_ your time, i.e. not wasting one.
> >
> >Add to CC list people, who already did reply on you patch. Otherwise
> >you are showing your disrespect for them and hiding from further
> >discussion.
> Thank you, I know it and I've already subscribed the linux kernel
> mailing list(linux-kernel@vger.kernel.org) so that I won't miss any
> further discussion about it.

OK, but news<=>e-mail service, like Gmane is much nicer.

> >
> >I think you do not, but Linux development not have an automatic system
> >for patch tracking, so you are on your own with your text editor and
> >e-mail client on this. Please take care for your time.
> What about that?
> Do you mean something such as git by "an automatic system"?

That was a side note.
____
