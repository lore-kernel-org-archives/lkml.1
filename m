Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYFQKZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYFQKZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 06:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYFQKZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 06:25:40 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36010 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbYFQKZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 06:25:39 -0400
Date: Tue, 17 Jun 2008 13:24:15 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
Message-ID: <20080617102415.GA30239@cs181133002.pp.htv.fi>
References: <1213565555.26255.522.camel@pmac.infradead.org> <1213604973-7073-1-git-send-email-jacmet@sunsite.dk> <1213617663.26255.708.camel@pmac.infradead.org> <20080616121727.GB10854@cs181133002.pp.htv.fi> <1213619214.26255.721.camel@pmac.infradead.org> <20080617084235.GA20169@cs181133002.pp.htv.fi> <1213696004.26255.960.camel@pmac.infradead.org> <20080617101112.GE20169@cs181133002.pp.htv.fi> <1213697925.26255.969.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1213697925.26255.969.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 11:18:45AM +0100, David Woodhouse wrote:
> On Tue, 2008-06-17 at 13:11 +0300, Adrian Bunk wrote:
> > On Tue, Jun 17, 2008 at 10:46:44AM +0100, David Woodhouse wrote:
> > > On Tue, 2008-06-17 at 11:42 +0300, Adrian Bunk wrote:
> > > > 
> > > > > Why _are_ there architectures which define ARCH_SUPPORTS_AOUT and have
> > > > > <asm/a.out.h> but don't support binfmt_aout, anyway? How does that make
> > > > > sense?
> > > > 
> > > > My guess would be that binfmt_aout isn't actually used there.
> > > > 
> > > > The affected architectures are:
> > > > - h8300
> > > > - m32r
> > > > - parisc
> > > > - sh
> > > > - v850
> > > > 
> > > > v850 is broken beyond repair, and I hope my patch to remove the 
> > > > architecture will make it into 2.6.27.
> > > > 
> > > > For the other 4 architectures I have Cc'ed the architecture maintainers.
> > > 
> > > There's another set of architectures which have <asm/a.out.h> but don't
> > > define ARCH_SUPPORTS_AOUT. Including PowerPC.
> > > 
> > > I think we can probably get away with removing <asm/a.out.h> from every
> > > architecture other than Alpha, ARM, m68k and x86, and killing
> > > ARCH_SUPPORTS_AOUT completely.
> > 
> > include/linux/a.out.h contains an #include <asm/a.out.h> and is exported 
> > to userspace...
> 
> Actually, it isn't -- but it _should_ be. But we can do it conditionally.
> See http://git.infradead.org/users/dwmw2/aout-2.6.git?a=commitdiff;h=5939c6a41
>...

It's already in Linus' tree.

Sorry, you are right, I missed that it takes care of exporting 
linux/a.out.h only when asm/a.out.h exists.

> dwmw2

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

