Return-Path: <linux-kernel-owner+w=401wt.eu-S1761218AbYBRU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218AbYBRU6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYBRU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:58:11 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33061 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYBRU6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:58:10 -0500
Date: Mon, 18 Feb 2008 21:58:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: setup_usemap() must be __meminit
Message-ID: <20080218205818.GA24528@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0802171317230.10451@anakin> <Pine.LNX.4.64.0802171329400.6172@anakin> <20080217194320.GL14588@uranus.ravnborg.org> <Pine.LNX.4.64.0802172138010.6172@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802172138010.6172@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 09:38:55PM +0100, Geert Uytterhoeven wrote:
> On Sun, 17 Feb 2008, Sam Ravnborg wrote:
> > On Sun, Feb 17, 2008 at 01:31:14PM +0100, Geert Uytterhoeven wrote:
> > > On Sun, 17 Feb 2008, Geert Uytterhoeven wrote:
> > > > On m68k (CONFIG_SPARSEMEM is not set), I get:
> > > > 
> > > >     WARNING: vmlinux.o(.meminit.text+0x36c): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
> > > >     The function __meminit free_area_init_core() references
> > > >     a function __init setup_usemap().
> > > >     If free_area_init_core is only used by setup_usemap then
> > > >     annotate free_area_init_core with a matching annotation.
> > > > 
> > > > If CONFIG_SPARSEMEM is set, the problem is  not noticed because setup_usemap()
> > > > is always inlined.
> > > > 
> > > > Properly annotating setup_usemap() and usemap_size() fixes it.
> > > 
> > > Woops, hit the send button too soon.
> > > 
> > > setup_usemap() calls alloc_bootmem_node(), causing a whole new
> > > avalanche of warnings to be fixed up :-(
> > 
> > Something you like me to help with?
> 
> Yes, that would be nice.

I tried the patch posted by Alexander previously.
After reviewing it for some time I convinced myself the
patch is correct (has stayed in my to-be-looked-at queue for a while).

See:
http://lkml.org/lkml/2008/2/3/129

I will ask Andrew to take it.

	Sam
