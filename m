Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbXJMSi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbXJMSi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbXJMSis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:38:48 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:41609 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbXJMSiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:38:46 -0400
Date: Sat, 13 Oct 2007 20:38:43 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Larry Finger <larry.finger@lwfinger.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [patch 7/8] b43 wireless needs <linux/io.h>
In-Reply-To: <4710E2C6.5090302@lwfinger.net>
Message-ID: <Pine.LNX.4.64.0710132027410.15951@anakin>
References: <20071013123123.085686856@mail.of.borg> <20071013123414.160200918@mail.of.borg>
 <4710E2C6.5090302@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, Larry Finger wrote:
> Geert Uytterhoeven wrote:
> > linux/drivers/net/wireless/b43/pio.h: In function 'b43_pio_write':
> > linux/drivers/net/wireless/b43/pio.h:89: error: implicit declaration of function 'mmiowb'
> >
> > linux/drivers/net/wireless/b43/phy.c: In function 'b43_phy_write':
> > linux/drivers/net/wireless/b43/phy.c:301: error: implicit declaration of function 'mmiowb'
> >
> > linuxdrivers/net/wireless/b43/sysfs.c: In function 'b43_attr_interfmode_store':
> > linuxdrivers/net/wireless/b43/sysfs.c:147: error: implicit declaration of function 'mmiowb'
> 
> From the distribution list for this E-mail, I presume this error occurred for m68k. Is this correct?

That's correct.

> If so, I will probably need to prepare a similar patch for b43legacy.

I had no problems compiling b43legacy on m68k, though. Probably
<linux/io.h> was included through some other include file.
Of course it's safer to always #include <linux/io.h> when using I/O.

During linking, I did get a bunch of `undefined reference to `dma_*''
errors, with both b43 and b43legacy (and a few other drivers). Probably
they need to depend on HAS_DMA.
I'll post separate patches for those after I've sorted them out.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
