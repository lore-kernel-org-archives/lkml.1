Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbXE3LT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbXE3LT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXE3LTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:19:48 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:58256 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXE3LTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:19:47 -0400
Date: Wed, 30 May 2007 13:19:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joerg Dorchain <joerg@dorchain.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
In-Reply-To: <20070530082035.GA8200@Redstar.dorchain.net>
Message-ID: <Pine.LNX.4.64.0705301318560.6389@anakin>
References: <20070528191630.377693320@mail.of.borg> <20070528191715.352919509@mail.of.borg>
 <20070529173818.fd94ae81.akpm@linux-foundation.org> <465D1020.3030605@cosmosbay.com>
 <Pine.LNX.4.64.0705300903030.31930@anakin> <20070530082035.GA8200@Redstar.dorchain.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Joerg Dorchain wrote:
> On Wed, May 30, 2007 at 09:06:08AM +0200, Geert Uytterhoeven wrote:
> [...]
> > > > 
> > > > I think it could be tightened up even if it happens not to warn?
> > > 
> > > 
> > > struct a {
> > > 	struct not_yet_defined *start, *end;
> > > };
> > > 
> > > struct not_yet_defined {
> > > 	void *foo;
> > > };
> > > 
> > > Is a valid and gives no warnings.
> > 
> > I was puzzled by this as well, as there were no compiler warnings...
> 
> Pointers are (at least on m68k) of known size, so the compiler knows how
> much space the struct occupies.
> 
> Type checking is by definition futile with void * pointer, but for all
> other cases the compiler has all types and sizes it needs at this point.
> 
> The actual dereferencing of the symbol table is done by the linker,
> which also knows all locations and sizes it needs.

True.

> Actually, this is the only way to define circular referencing
> structures.

No, you have forward declarations for that. These are missing here.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
