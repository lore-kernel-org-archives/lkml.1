Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXBHHd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXBHHd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030663AbXBHHd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:33:27 -0500
Received: from raven.upol.cz ([158.194.120.4]:50346 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030664AbXBHHd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:33:26 -0500
Date: Thu, 8 Feb 2007 08:42:13 +0100
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: search-a-little-harder-for-mkimage.patch
Message-ID: <20070208074213.GR22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz> <Pine.LNX.4.64.0702080029030.14457@scrub.home> <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org> <20070207203047.51a95ad0.akpm@linux-foundation.org> <20070208052439.GL22699@flower.upol.cz> <8bd0f97a0702072156q640d49b8of5f81a60b380ef81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0702072156q640d49b8of5f81a60b380ef81@mail.gmail.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 12:56:17AM -0500, Mike Frysinger wrote:
> On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> >> Check to see if `${CROSS_COMPILE}mkimage` exists and if not, fall back to
> >> the standard `mkimage`
> >
> >Why this can't be done by
> >
> >  PATH=$CROSS_COMPILE:$PATH
> >
> >in your environment?
> 
> because it wouldnt matter ?  the tool is called
> "$CROSS_COMPILE-mkimage", it isnt $CROSS_COMPILE_PATH/mkimage

Well, i mean search for your `mkimage'.

Let's see how all this used in Makefiles (avr32, ppc, sh are same)

../arch/arm/boot/Makefile:

   MKIMAGE         := $(srctree)/scripts/mkuboot.sh
   ...
   quiet_cmd_uimage = UIMAGE  $@
         cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A arm -O linux -T kernel \
                   -C none -a $(ZRELADDR) -e $(ZRELADDR) \
                   -n 'Linux-$(KERNELRELEASE)' -d $< $@

type, which with bash or whatever, doesn't matter. All they need *your*
toolchain in $PATH, why not just to put "$CROSS_COMPILE-mkimage" instead
of $(CONFIG_SHELL) $(MKIMAGE) here? mkuboot.sh just searches $PATH for
mkimage and run it. Double overkill, no?

> >> The Blackfin toolchain includes mkimage, but we dont want to namespace
> >> collide with any of the user's system setup, so we prefix it with our
> >> toolchain name.
> >
> >If that matter, `type -path' is bashizm (BloAted SHell), and "blackbox"
> >with "dash" (very good `sh' equivalents) will fail. I would recomend to
> >use "which" command (btw, Debian has `sh' version of it), if you
> >concerned about size and performance.
> >
> >Nack + proposition to move from `bash' to `sh'.
> 
> the script already uses "#!/bin/bash" and the patch doesnt change any
> of the existing conventions ... so if you want to rewrite the existing
> code to be POSIX compliant, then do so so i can add back in support
> for $CROSS_COMPILE-mkimage

To run faster, but let me stop here.
____
