Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYL2VpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYL2VpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYL2VpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:45:09 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:59537 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYL2VpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:45:08 -0500
Date: Mon, 29 Dec 2008 22:46:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Mike Frysinger <vapier@gentoo.org>, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] sh: maple: add support for the Maple mouse on the SEGA Dreamcast
Message-ID: <20081229214634.GA27064@uranus.ravnborg.org>
References: <1230578246.6496.25.camel@localhost.localdomain> <200812291602.18572.vapier@gentoo.org> <1230586215.6496.28.camel@localhost.localdomain> <200812291636.36303.vapier@gentoo.org> <1230586714.6496.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230586714.6496.29.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 09:38:34PM +0000, Adrian McMenamin wrote:
> On Mon, 2008-12-29 at 16:36 -0500, Mike Frysinger wrote:
> > On Monday 29 December 2008 16:30:14 Adrian McMenamin wrote:
> > > +static int __devexit remove_maple_mouse(struct device *dev)
> > > +static struct maple_driver dc_mouse_driver = {
> > > +	.drv = {
> > > +		.remove = remove_maple_mouse,
> > 
> > does that really build warning free ?  usually you need __devexit_p() in the 
> > .remove assignment ...
> > -mike
> 
> Yep
> 
> adrian@bossclass:~/linux-2.6$ make ARCH=sh
> CROSS_COMPILE=/home/adrian/dreamy-linux/buildroot/build_sh4/staging_dir/bin/sh4-linux- zImage modules -j4
> scripts/kconfig/conf -s arch/sh/Kconfig
>   CHK     include/linux/version.h
>   SYMLINK include/asm -> include/asm-sh
> make[1]: `include/asm-sh/machtypes.h' is up to date.
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      init/version.o
>   CC      kernel/module.o
>   LD      init/built-in.o
>   CC [M]  drivers/input/mouse/maplemouse.o
>   LD      kernel/built-in.o

Look for an increase in section mismatch warning or try to
build with:
make CONFIG_DEBUG_SECTION_MISMATCH=y

	Sam
