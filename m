Return-Path: <linux-kernel-owner+w=401wt.eu-S932391AbXHUSag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbXHUSag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbXHUSa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:30:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56273 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932158AbXHUSa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:30:26 -0400
Date: Tue, 21 Aug 2007 20:29:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070821182932.GD30705@stusta.de>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821175453.GB19819@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070821175453.GB19819@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 06:54:53PM +0100, Russell King wrote:
> On Tue, Aug 21, 2007 at 07:35:50PM +0200, Adrian Bunk wrote:
> > On Tue, Aug 21, 2007 at 09:31:03AM -0700, Randy Dunlap wrote:
> > > On Tue, 21 Aug 2007 15:20:38 +0200 Jarek Poplawski wrote:
> > > 
> > > > Here are some more of, probably well-known, warnings with attached
> > > > testing-only .config.
> > > >...
> > > > drivers/pci/msi.c:686: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
> > > > drivers/pci/msi.c:698: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
> > > > drivers/pci/msi.c:718: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior
> > > >...
> > > 
> > > What gcc version?  I don't get the arch_ warnings in drivers/pci/msi.c.
> > 
> > Obviously a gcc <= 3.4 [1], and therefore no unit-at-a-time.
> > 
> > You can reproduce it with a more recent gcc when adding 
> > -fno-unit-at-a-time to the CFLAGS.
> > 
> > And it's becoming a real maintainance problem that not only this problem 
> > but also other problems like some section mismatches [2] are only 
> > present without unit-at-a-time.
> > 
> > Currently we support 6 different stable gcc release series, and it might 
> > be the right time to consider dropping support for the older ones.
> > 
> > Are there any architectures still requiring a gcc < 4.0 ?
> 
> I want to keep support for gcc 3.4.3 for ARM for the forseeable future.
> >From my point of view, gcc 4 compilers have been something of a development
> thing as far as the ARM architecture goes.
>...

It is an option to say "gcc >= 4.0 on i386 and >= 3.4 on all other 
architectures is required".

> Russell King

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

