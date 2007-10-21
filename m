Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbXJUSVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbXJUSVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 14:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbXJUSVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 14:21:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60535 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXJUSVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 14:21:14 -0400
Date: Sun, 21 Oct 2007 20:22:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] m68k: Use cc-cross-prefix (was: Re: [GI:wqT PULL] kbuild updates - second round)
Message-ID: <20071021182245.GA5840@uranus.ravnborg.org>
References: <20071019204415.GA623@uranus.ravnborg.org> <Pine.LNX.4.64.0710211956280.6155@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710211956280.6155@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 07:57:39PM +0200, Geert Uytterhoeven wrote:
> On Fri, 19 Oct 2007, Sam Ravnborg wrote:
> > The cc-cross-prefix is new and developed on request from Geert Uytterhoeven.
> > With cc-cross-prefix it is now much easier to have a few default
> > cross compile prefixes and defaulting to none - if none of them were present.
> > ARCH maintainers are expected to pick up this feature soon.
> 
> Thanks, seems to work fine!
> 
> m68k: Use cc-cross-prefix
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/Makefile |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> --- a/arch/m68k/Makefile
> +++ b/arch/m68k/Makefile
> @@ -13,16 +13,14 @@
>  # Copyright (C) 1994 by Hamish Macdonald
>  #
>  
> -# test for cross compiling
> -COMPILE_ARCH = $(shell uname -m)
> -
>  # override top level makefile
>  AS += -m68020
>  LDFLAGS := -m m68kelf
>  LDFLAGS_MODULE += -T $(srctree)/arch/m68k/kernel/module.lds
>  ifneq ($(COMPILE_ARCH),$(ARCH))
> -	# prefix for cross-compiling binaries
> -	CROSS_COMPILE = m68k-linux-gnu-
> +	ifeq ($(CROSS_COMPILE),)
> +	       CROSS_COMPILE := $(call cc-cross-prefix, m68k-linux-gnu- m68k-linux-)
> +	endif
>  endif
Patch seems bogus.
You kill the assignment to COMPILE_ARCH yet you
refer to it in the line:
ifneq ($(COMPILE_ARCH),...

Did you mean to use $(SUBARCH) here?

	Sam
