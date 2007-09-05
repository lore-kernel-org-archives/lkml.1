Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbXIEUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbXIEUKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbXIEUKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:10:32 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43327 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbXIEUKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:10:31 -0400
Date: Wed, 5 Sep 2007 22:11:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: building a specific in-tree module is currently a bit broken
Message-ID: <20070905201153.GB30812@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain> <6bffcb0e0709050237m7d948782iffec36253c6fccb2@mail.gmail.com> <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709051142080.5419@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 11:43:15AM +0200, Jan Engelhardt wrote:
> 
> On Sep 5 2007 11:37, Michal Piotrowski wrote:
> >
> >Hi,
> >
> >[Adding K{build,config} wizards to CC]
> >
> >On 05/09/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> >>
> >> $ make distclean
> >> $ make defconfig
> >> $ make menuconfig      (select visor.ko to be built a module)
> >> $ make drivers/usb/serial/visor.ko
> 
> Beep. Need 'make scripts prepare' between menuconfig and visor.
Nope - kbuild does this for you.
See following lines from top-level Makefile:

%.ko: prepare scripts FORCE
        $(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1)   \
        $(build)=$(build-dir) $(@:.ko=.o)
        $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost

But as pointed out it fails to create MODVERDIR.
I had one take on it some time ago and do not recall why I failed
to fix it. Should be trivial.

But this is a small issue that has been there for a long time
and is not -rc material. I will try to have it fixed for
next merge window.

	Sam
