Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbXGVKU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbXGVKU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 06:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXGVKUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 06:20:13 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:36848 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbXGVKUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 06:20:11 -0400
Date: Sun, 22 Jul 2007 12:20:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/7] console: fix section mismatch warning in vgacon.c
In-Reply-To: <1184974649.4538.4.camel@daplas>
Message-ID: <Pine.LNX.4.64.0707221218130.18493@anakin>
References: <20070720212743.GB25064@uranus.ravnborg.org> <1184974649.4538.4.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Antonino A. Daplas wrote:
> On Fri, 2007-07-20 at 23:27 +0200, Sam Ravnborg wrote:
> > Fix following section mismatch warning:
> > WARNING: vmlinux.o(.text+0x121e62): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')
> > 
> > Browsing the code it seems that vgacon_scrollback_startup() is only
> > called during the init phase so the reference to the .init.text
> > section is OK.
> > Teach modpost not to warn using ___init_refok.
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Acked-by: Antonino Daplas <adaplas@gmail.com>

I assume the check for `vga_init_done' in vgacon_startup() is sufficient to
prevent vgacon_scrollback_startup() from being called later due to
(un)bind_con_driver()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
