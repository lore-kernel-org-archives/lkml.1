Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYBQUj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYBQUj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYBQUjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:39:05 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:50948 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYBQUjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:39:03 -0500
Date: Sun, 17 Feb 2008 21:38:55 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: setup_usemap() must be __meminit
In-Reply-To: <20080217194320.GL14588@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802172138010.6172@anakin>
References: <Pine.LNX.4.64.0802171317230.10451@anakin>
 <Pine.LNX.4.64.0802171329400.6172@anakin> <20080217194320.GL14588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Sam Ravnborg wrote:
> On Sun, Feb 17, 2008 at 01:31:14PM +0100, Geert Uytterhoeven wrote:
> > On Sun, 17 Feb 2008, Geert Uytterhoeven wrote:
> > > On m68k (CONFIG_SPARSEMEM is not set), I get:
> > > 
> > >     WARNING: vmlinux.o(.meminit.text+0x36c): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
> > >     The function __meminit free_area_init_core() references
> > >     a function __init setup_usemap().
> > >     If free_area_init_core is only used by setup_usemap then
> > >     annotate free_area_init_core with a matching annotation.
> > > 
> > > If CONFIG_SPARSEMEM is set, the problem is  not noticed because setup_usemap()
> > > is always inlined.
> > > 
> > > Properly annotating setup_usemap() and usemap_size() fixes it.
> > 
> > Woops, hit the send button too soon.
> > 
> > setup_usemap() calls alloc_bootmem_node(), causing a whole new
> > avalanche of warnings to be fixed up :-(
> 
> Something you like me to help with?

Yes, that would be nice.

> I would need a config where the mismatch triggers for one
> of the more popular architectures (as in where I have a toolchain).

That was with plain m68k defconfig.

> I could not reproduce it with x86 64bit - not even with -fno-inline-functions

If it helps, my cross-compiler is gcc version 4.1.2 20061115 (prerelease)
(Debian 4.1.1-21).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
