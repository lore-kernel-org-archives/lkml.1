Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYDAHnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYDAHnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbYDAHnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:43:17 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43425 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbYDAHnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:43:14 -0400
Date: Tue, 1 Apr 2008 10:43:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dave Jones <davej@codemonkey.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       rusty@rustcorp.com.au, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: wish: build time warning for missing MODULE_LICENSE
Message-ID: <20080401074311.GE23259@cs181133002.pp.htv.fi>
References: <20080330180119.GC1575@cs181133002.pp.htv.fi> <20080330190430.GD19733@uranus.ravnborg.org> <20080330203417.GA7607@cs181133002.pp.htv.fi> <20080401022247.GA8383@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080401022247.GA8383@codemonkey.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 10:22:48PM -0400, Dave Jones wrote:
> On Sun, Mar 30, 2008 at 11:34:17PM +0300, Adrian Bunk wrote:
>  > On Sun, Mar 30, 2008 at 09:04:30PM +0200, Sam Ravnborg wrote:
>  > > On Sun, Mar 30, 2008 at 09:01:19PM +0300, Adrian Bunk wrote:
>  > > > I just fixed a bug where I had accidentally removed a MODULE_LICENSE() 
>  > > > from a file.
>  > > > 
>  > > > The problem is that such bugs are currently not discovered until someone 
>  > > > actually runs a kernel with this module loaded.
>  > > > 
>  > > > Could we get a build time warning/error for a missing MODULE_LICENSE?
>  > > 
>  > > Is it something as simple as this you are after?
>  > > [My dev box is dead atm so I have not done a kernel build
>  > > with this, only a single module].
>  > 
>  > Thanks, it seems to work - and I'm currently working on fixing the bugs 
>  > it catches.
>  > 
>  > Considering that these are trivial to fix I'd even suggest a fatal() 
>  > instead of the warn() for making them obvious for everyone doing build 
>  > testing.
>  
> In the Fedora kernel specfile, we have something to catch this at build time.
> Relevant pieces are (munged a bit for clarity) ..
> 
>     find . -name "*.ko" -type f >modnames
> 
>     while read i
>     do
>       echo -n "$i " >> modinfo
>       /sbin/modinfo -l $i >> modinfo
>     done < modnames
> 
>     egrep -v \
>           'GPL( v2)?$|Dual BSD/GPL$|Dual MPL/GPL$|GPL and additional rights$' \
>           modinfo && exit 1

I'd say the price for the most elegant solution goes to Sam.  ;)

> This hasn't been triggering though, so either it stopped working at some point,
> or we don't build the module you mention.  Which was it out of curiosity ?
> Or was your slip-up an -mm only thing?

My slip-up was the OSS ac97_codec in 2.6.25-rc.

The other ones I found until now are:
arch/x86/video/fbdev.c
drivers/ide/ide-pnp.c (bug introduced in 2.6.25-rc)
drivers/ide/pci/cmd640.c (bug introduced in 2.6.25-rc)
drivers/ide/ppc/mpc8xx.c (bug introduced in 2.6.25-rc)
drivers/ide/ppc/pmac.c (bug introduced in 2.6.25-rc)
drivers/ide/arm/ide_arm.c (bug introduced in 2.6.25-rc)
drivers/ide/cris/ide-cris.c (bug introduced in 2.6.25-rc)
drivers/ide/h8300/ide-h8300.c (bug introduced in 2.6.25-rc)
drivers/ide/legacy/gayle.c (bug introduced in 2.6.25-rc)
drivers/ide/legacy/buddha.c (bug introduced in 2.6.25-rc)
drivers/ide/legacy/falconide.c (bug introduced in 2.6.25-rc)
drivers/ide/legacy/macide.c (bug introduced in 2.6.25-rc)
drivers/ide/legacy/q40ide.c (bug introduced in 2.6.25-rc)
drivers/media/video/v4l2-int-device.c (bug introduced in 2.6.25-rc)
arch/arm/kernel/arthur.c

Most likely none of them is modular in the Fedora kernel and/or 
available on the architectures Fedora supports.

> 	Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

