Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYDTIJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYDTIJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYDTIJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:09:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60901 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbYDTIJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:09:24 -0400
Date: Sun, 20 Apr 2008 11:09:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420080901.GF1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080419145948.GA4528@lintop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 09:59:48AM -0500, Shawn Bohrer wrote:
> On Sat, Apr 19, 2008 at 04:23:29PM +0200, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > >  config 4KSTACKS
> > > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > > -	depends on DEBUG_KERNEL
> > > >  	depends on X86_32
> > > > +	default y
> > > 
> > > This patch will cause kernels to crash.
> > 
> > what mainline kernels crash and how will they crash? Fedora and other 
> > distros have had 4K stacks enabled for years:
> 
> If by other distros you mean RHEL then yes.  However, openSUSE,
> Ubuntu, and Mandriva all still have 8K stacks.  I know of no other
> distributions that default to 4K.

MontaVista offers 4k stacks for arm (currently an external patch) and 
markets that as a feature to customers, so many of them might use it.

In-kernel the sh and m68knommu ports also offer 4k stacks (for both 
archs there's also a defconfig using it), and the mn10300 port contains 
an #ifdef but no config option.

The stack problems in the kernel tend to not be in arch code, and if 
we don't get i386 to always run with 4k stacks there's no chance that 
it will ever work reliably on other architectures.

> Shawn

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

