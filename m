Return-Path: <linux-kernel-owner+w=401wt.eu-S1766004AbYBNItI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766004AbYBNItI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 03:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYBNIsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 03:48:55 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:34607 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbYBNIsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 03:48:53 -0500
X-Greylist: delayed 90595 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2008 03:48:53 EST
Date: Thu, 14 Feb 2008 09:48:42 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       greg@kroah.com, torvalds@linux-foundation.org, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: distributed module configuration [Was: Announce: Linux-next (Or
 Andrew's dream :-))]
In-Reply-To: <200802140156.15325.zippel@linux-m68k.org>
Message-ID: <Pine.LNX.4.64.0802140944100.15629@anakin>
References: <20080212174824.GA1919@kroah.com> <20080212.164149.209357519.davem@davemloft.net>
 <20080213084541.GA8091@uranus.ravnborg.org> <200802140156.15325.zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Roman Zippel wrote:
> On Wednesday 13. February 2008, Sam Ravnborg wrote:
> > config foo
> > 	tristate "do you want foo?"
> > 	depends on USB && BAR
> > 	module
> > 	  obj-$(CONFIG_FOO) += foo.o
> > 	  foo-y := file1.o file2.o
> > 	help
> > 	  foo will allow you to explode your PC
> 
> I'm more thinking about something like this:
> 
> module foo [FOO]
> 	tristate "do you want foo?"
> 	depends on USB && BAR
> 	source file1.c
> 	source file2.c if BAZ

And we can finally distinguish between

    config bar
    bool "do you want bar?"
    
for boolean options and

    module baz
    bool "do you want baz?"

for modules that cannot be modular?

And we can make `depends on' do the right thing for dependencies on modules
that are modular (cfr. e.g. commit e11a6c236b3070ed05b079f91a9b3defa48b54d3,
[VIDEO]: XVR500 and XVR2500 require FB=y)?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
