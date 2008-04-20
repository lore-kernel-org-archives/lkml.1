Return-Path: <linux-kernel-owner+w=401wt.eu-S1763898AbYDTKxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763898AbYDTKxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762955AbYDTKpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:45:09 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39118 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761579AbYDTKpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:45:08 -0400
Date: Sun, 20 Apr 2008 13:44:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420104444.GI1595@cs181133002.pp.htv.fi>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080420103611.2c0d3519@the-village.bc.nu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 10:36:11AM +0100, Alan Cox wrote:
> On Sun, 20 Apr 2008 11:51:04 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Sun, Apr 20, 2008 at 09:06:23AM +0100, Alan Cox wrote:
> > > > The stack problems in the kernel tend to not be in arch code, and if 
> > > > we don't get i386 to always run with 4k stacks there's no chance that 
> > > > it will ever work reliably on other architectures.
> > > 
> > > Not really the case - embedded tends not to use deep stacks of drivers.
> > 
> > Something like nfsd-over-xfs-over-raid is (or was) the most common 
> > problem - and this or similar stackings might be used in NAS devices.
> 
> Specific cases yes, but such NAS devices have big processors and are not
> little emdedded CPUs. On an embedded box you know at build time what it
> will be doing.

The code in the kernel that gets the fewest coverage at all are our 
error paths, and some vendor might try 4k stacks, validate it works in 
all use cases - and then it will blow up in some error condition he 
didn't test.

6k is known to work, and there aren't many problems known with 4k.

And from a QA point of view the only way of getting 4k thoroughly tested 
by users, and well also tested in -rc kernels for catching regressions 
before they get into stable kernels, is if we get 4k stacks enabled 
unconditionally on i386.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

