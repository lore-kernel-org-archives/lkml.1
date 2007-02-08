Return-Path: <linux-kernel-owner+w=401wt.eu-S1423304AbXBHURM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423304AbXBHURM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423303AbXBHURM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:17:12 -0500
Received: from raven.upol.cz ([158.194.120.4]:59876 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423304AbXBHURL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:17:11 -0500
Date: Thu, 8 Feb 2007 21:25:35 +0100
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: akpm@linux-foundation.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: + search-a-little-harder-for-mkimage.patch added to -mm tree
Message-ID: <20070208202535.GX22699@flower.upol.cz>
References: <200702080607.l1867c0D006861@shell0.pdx.osdl.net> <E1HF9zs-0006Ei-2k@flower> <8bd0f97a0702080628u5038191dm74139a7dd7bff909@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0702080628u5038191dm74139a7dd7bff909@mail.gmail.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 09:28:03AM -0500, Mike Frysinger wrote:
> On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> >proposition is to substitute:
> >     "$(CONFIG_SHELL) $(MKIMAGE)"
> >with
> >     "mkimage"
> 
> this isnt a one-to-one change ... let's look at the typical
> mkimage-missing scenario ...

You are interested in presents of `mkimage', but yet we discussing its
missing, or "Error -> Don't care" behavior.

uImage, as i can compare with other *final* targets, like bzImage on PC,
must be made in case of `make uImage', or if default rule depends on
it. Thus, if it fails it, must be error. It doesn't matter what cause
it, and what message was printed:

> with mkuboot.sh you'd get output like:
> ...
>  UIMAGE  arch/blackfin/boot/vmImage
> "mkimage" command not found - U-Boot images will not be built
>  Building modules, stage 2.
> ...
> 
> with mkimage you'd get output like:
> ...
>  UIMAGE  arch/blackfin/boot/vmImage
> /bin/sh: mkimage: command not found
> make[1]: *** [arch/blackfin/boot/vmImage] Error 127
> make: *** [vmImage] Error 2

In this example `uImage' is required by final target, e.g.

,-*-
|all: prepare uImage modules_install
|	while things; do them; done
`-*-

> so while you could change all the Makefile's to insert - to ignore
> *all* failures, without the script, you loose the ability to only
> ignore "binary missing" errors

So, are we ignoring our primary (default) goal?

OK, as you wish. As for me it's a plain bloat, but i have neither one
for-embedded setup to propose non-bloating change for _you_ (:.

> -mike
____
