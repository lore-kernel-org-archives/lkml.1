Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbYBQTnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbYBQTnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYBQTnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:43:13 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:32931 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbYBQTnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:43:11 -0500
Date: Sun, 17 Feb 2008 20:43:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: setup_usemap() must be __meminit
Message-ID: <20080217194320.GL14588@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0802171317230.10451@anakin> <Pine.LNX.4.64.0802171329400.6172@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802171329400.6172@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 01:31:14PM +0100, Geert Uytterhoeven wrote:
> On Sun, 17 Feb 2008, Geert Uytterhoeven wrote:
> > On m68k (CONFIG_SPARSEMEM is not set), I get:
> > 
> >     WARNING: vmlinux.o(.meminit.text+0x36c): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
> >     The function __meminit free_area_init_core() references
> >     a function __init setup_usemap().
> >     If free_area_init_core is only used by setup_usemap then
> >     annotate free_area_init_core with a matching annotation.
> > 
> > If CONFIG_SPARSEMEM is set, the problem is  not noticed because setup_usemap()
> > is always inlined.
> > 
> > Properly annotating setup_usemap() and usemap_size() fixes it.
> 
> Woops, hit the send button too soon.
> 
> setup_usemap() calls alloc_bootmem_node(), causing a whole new
> avalanche of warnings to be fixed up :-(

Something you like me to help with?
I would need a config where the mismatch triggers for one
of the more popular architectures (as in where I have a toolchain).

I could not reproduce it with x86 64bit - not even with -fno-inline-functions

	Sam
