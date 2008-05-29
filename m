Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYE2TjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYE2TjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYE2TjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:39:00 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:49361 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYE2Ti7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:38:59 -0400
Date: Thu, 29 May 2008 21:38:55 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Ingo Molnar <mingo@elte.hu>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
In-Reply-To: <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0805292137530.13388@anakin>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
 <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008, Jiri Kosina wrote:
> On Mon, 26 May 2008, Geert Uytterhoeven wrote:
> 
> > Recently I noticed a regression when running an old libc5 binary
> > (amiga-lilo) on m68k. It fails with the error message:
> 
> Hmm, libc5 is known to make broken assumptions about brk location, that's 
> why we introduced CONFIG_COMPAT_BRK, do you have that option turned on?
> 
> > So I bisected it to:
> > commit 4cc6028d4040f95cdb590a87db478b42b8be0508
> > Author: Jiri Kosina <jkosina@suse.cz>
> > Date:   Wed Feb 6 22:39:44 2008 +0100
> >     brk: check the lower bound properly
> 
> Indeed, this should take CONFIG_COMPAT_BRK into account. Does the patch 
> below fix it? (assuming that you have CONFIG_COMPAT_BRK=y):

Yes, both libc5 amiga-lilo and the libc5 emergency ramdisk work again
after applying this patch.

> From: Jiri Kosina <jkosina@suse.cz>
> 
> brk: check lower bound properly
> 
> The check in sys_brk() on minimum value the brk might have must take 
> CONFIG_COMPAT_BRK setting into account. When this option is turned on 
> (i.e. we support ancient legacy binaries, e.g. libc5-linked stuff), the 
> lower bound on brk value is mm->end_code, otherwise the brk start is 
> allowed to be arbitrarily shifted.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
