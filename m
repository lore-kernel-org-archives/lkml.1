Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbXEaHRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbXEaHRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 03:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXEaHRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 03:17:42 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:36371 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXEaHRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 03:17:41 -0400
Date: Thu, 31 May 2007 09:17:30 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tero Roponen <teanropo@jyu.fi>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Linux-fbdev-devel] tty-related oops in latest kernel(s)?
In-Reply-To: <1180566886.4570.14.camel@daplas>
Message-ID: <Pine.LNX.4.64.0705310916240.17047@anakin>
References: <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
 <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com>
 <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
 <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
 <Pine.LNX.4.64.0705301458400.4634@jalava.cc.jyu.fi>
 <20070530083953.9909bcef.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705301857370.29485@jalava.cc.jyu.fi>
 <20070530090945.ab9d51d9.akpm@linux-foundation.org>
 <20070530180428.GA5731@martell.zuzino.mipt.ru> <1180566886.4570.14.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Antonino A. Daplas wrote:
> On Wed, 2007-05-30 at 22:04 +0400, Alexey Dobriyan wrote:
> > 2) palette in neofb_par is "u32 palette[16];" which is 4x16 = 64 bytes.
> >    struct fb_info::pseudo_palette is assigned to it in neo_alloc_fb_info().
> >    Yet, we check at the beginning of neofb_setcolreg() for color map
> >    length which neofb advertises as 256 which seems too many.
> > 
> 
> Yes, 256 is too many. the pseudo_palette is used for the 16-color
> console only.
> 
> I'm impressed that this bug has escaped notice for this long. That bug
> is present since the 2.5.x era.
> 
> Probably, the best thing to do is hide the pseudo_palette from the
> drivers and move it to the console layer where it belongs to spare
> future driver writers from palette usage confusion. That will be a
> thankless job.

The console layer doesn't know how to fill in the pseudo palette in all
cases, that's why the driver have to do it.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
