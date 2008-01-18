Return-Path: <linux-kernel-owner+w=401wt.eu-S1763621AbYARVYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763621AbYARVYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbYARVYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:24:40 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33297 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778AbYARVYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:24:39 -0500
Date: Fri, 18 Jan 2008 23:23:27 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080118212327.GA14803@does.not.exist>
References: <20080117214301.GA28233@does.not.exist> <20080118104401.GA8785@elte.hu> <20080118170037.GA23297@elte.hu> <20080118172630.GD28233@does.not.exist> <20080118210633.GD10717@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080118210633.GD10717@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 10:06:33PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > > > thx, i've added this to x86.git.
> > > 
> > > this broke "make ARCH=i386 randconfig" from working when there's a 
> > > 64-bit .config present. (it will not properly generate a 32-bit 
> > > config, but still a 64-bit config)
> > 
> > Does it always generate a 64bit .config or randomly a 32bit or 64bit 
> > .config?
> > 
> > As far as I see it's the latter.
> 
> it inherits the existing .config's arch setting - and that's what people 
> expect. I use a tree either in 64-bit mode or in 32-bit mode, fully 
> driven via the .config alone. The Kbuild magic picks up the right arch 
> variant and it all just works fine.

If you think anything was "fully driven via the .config alone" you 
seem to neither understand how it works without my patch nor how it 
works with my patch.

What drives your build without my patch is _not_ the .config but your 
ARCH=i386.

When understand this, you might start understanding why I bang my head 
against the wall each time a "make" fails on a 64bit .config when I try 
to reproduce some compile or section mismatch problem someone reported 
and kconfig automatically forces CONFIG_64BIT=n since I'm on a 32bit 
computer.

Can we please get my patch into 2.6.24 so that we'll get _one_ 
architecture in kconfig and not the current mess with three different 
situations in kconfig based on the ARCH setting (and the 32/64bit of 
your userspace forcing a CONFIG_64BIT setting you have to override with 
ARCH= on the command line)?

> 	Ingo

cu
Adrian

BTW: The correct way to drive your randconfigs (that is not limited to
     to 32/64bit) is to use KCONFIG_ALLCONFIG.


-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

