Return-Path: <linux-kernel-owner+w=401wt.eu-S1422957AbXBHHkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422957AbXBHHkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422961AbXBHHkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:40:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:41261 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422957AbXBHHka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:40:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gPdtwzthJtANxnnMzkYCkNRvesYOayx0IvXlAXWPgJyZHPPO+aEIkrzj7j4kQzYjUyWXJiWjPixkprK+S4tcLN5v1wK8ZFuUfqJ/K/O5nT1hRirPJiN4SJgfbzwYo8FkalupjeYZY2CR66pYG3Z1/NU8ZuMk8Uce9L+waUmwERY=
Message-ID: <8bd0f97a0702072340w699ba70bre9d0828ae11c56b7@mail.gmail.com>
Date: Thu, 8 Feb 2007 02:40:28 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: search-a-little-harder-for-mkimage.patch
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Roman Zippel" <zippel@linux-m68k.org>, sam@ravnborg.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kai Germaschewski" <kai@germaschewski.name>
In-Reply-To: <20070208074213.GR22699@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
	 <Pine.LNX.4.64.0702071846180.14457@scrub.home>
	 <20070207220435.GC22699@flower.upol.cz>
	 <Pine.LNX.4.64.0702080029030.14457@scrub.home>
	 <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
	 <20070207203047.51a95ad0.akpm@linux-foundation.org>
	 <20070208052439.GL22699@flower.upol.cz>
	 <8bd0f97a0702072156q640d49b8of5f81a60b380ef81@mail.gmail.com>
	 <20070208074213.GR22699@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> On Thu, Feb 08, 2007 at 12:56:17AM -0500, Mike Frysinger wrote:
> > On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> > >> Check to see if `${CROSS_COMPILE}mkimage` exists and if not, fall back to
> > >> the standard `mkimage`
> > >
> > >Why this can't be done by
> > >
> > >  PATH=$CROSS_COMPILE:$PATH
> > >
> > >in your environment?
> >
> > because it wouldnt matter ?  the tool is called
> > "$CROSS_COMPILE-mkimage", it isnt $CROSS_COMPILE_PATH/mkimage
>
> Well, i mean search for your `mkimage'.
>
> Let's see how all this used in Makefiles (avr32, ppc, sh are same)
>
> ../arch/arm/boot/Makefile:
>
>    MKIMAGE         := $(srctree)/scripts/mkuboot.sh
>    ...
>    quiet_cmd_uimage = UIMAGE  $@
>          cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A arm -O linux -T kernel \
>                    -C none -a $(ZRELADDR) -e $(ZRELADDR) \
>                    -n 'Linux-$(KERNELRELEASE)' -d $< $@
>
> type, which with bash or whatever, doesn't matter. All they need *your*
> toolchain in $PATH, why not just to put "$CROSS_COMPILE-mkimage" instead
> of $(CONFIG_SHELL) $(MKIMAGE) here? mkuboot.sh just searches $PATH for
> mkimage and run it. Double overkill, no?

by this argument, why does mkuboot.sh exist at all then ?  let's
simply delete mkuboot.sh and change all arch Makefile's like so:
-    $(CONFIG_SHELL) $(MKIMAGE) ...
+    -mkimage ...

i of course prefer the existing solution: call the mkuboot.sh script
which checks for a few variations of the `mkimage` binary and if it
does not exist, output a friendly message
-mike
