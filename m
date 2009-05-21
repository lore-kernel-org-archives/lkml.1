Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZEULVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZEULVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZEULV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:21:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:35326 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbZEULV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:21:26 -0400
Date: Thu, 21 May 2009 20:19:46 +0900
To: ijc@hellion.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org,
       xen-devel@lists.xensource.com, beckyb@kernel.crashing.org, okir@suse.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       gregkh@suse.de
Subject: Re: [Xen-devel] Re: Where do we stand with the Xen patches?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242903785.22654.157.camel@zakaz.uk.xensource.com>
References: <1242901733.22654.138.camel@zakaz.uk.xensource.com>
	<20090521193910W.fujita.tomonori@lab.ntt.co.jp>
	<1242903785.22654.157.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090521201951I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 21 May 2009 20:19:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 12:03:05 +0100
Ian Campbell <ijc@hellion.org.uk> wrote:

> On Thu, 2009-05-21 at 06:39 -0400, FUJITA Tomonori wrote:
> > On Thu, 21 May 2009 11:28:53 +0100
> > Ian Campbell <ijc@hellion.org.uk> wrote:
> >  
> > > +#ifdef CONFIG_PCI_XEN
> > > +extern int xen_range_needs_mapping(phys_addr_t paddr, size_t size);
> > > +#else
> > > +static inline int xen_range_needs_mapping(phys_addr_t paddr, size_t size) { return 0; }
> > > +#endif
> > 
> > I know Xen can do something like this but you think that this is
> > clean?
> 
> Well, defining a static inline function when a CONFIG option is disabled
> is fairly idiomatic in the kernel and in general hiding these sorts of
> things in the headers in this way is preferred to having them in .c
> files. See e.g. the handling of CONFIG_PRINTK in include/linux/kernel.h
> or CONFIG_HIGHMEM in include/linux/highmem.h for just two examples out
> of many.

Well, I know that it's idiomatic, but placing CONFIG_PCI_XEN in
arch/{x86|ia64}/include/asm/ is a wrong abstraction to me.


> > In addition, you also the similar hack in
> > arch/ia64/include/asm/dma-mapping.h for ia64's dom0 support, I think.
> > 
> > IMO, your patch just moves the ugly hacks from lib/swiotlb.c to
> > arch/{x86|ia64}/include/asm/dma-mapping.h.
> 
> I nearly suggested that for this hook it might actually be preferable to
> put the one line Xen hook directly into swiotlb.c. I didn't think this
> suggestion would go down very well though.

Any arch or Xen specific code should not live in swiotlb.c


> In any case something along these lines needs to go somewhere. I think
> you are slightly mischaracterising this as an "ugly hack" -- it is a
> necessary interface to enable a particular use-case, and it actually has
> a very small cross section (it's basically five or six lines of code).

A necessary interface? Sorry, I don't buy it. It's necessary for
only Xen. And it's not fit well for swiotlb and the architecture
abstraction.


> If there was a cleaner way to achieve the same result we would of course
> go with that. I don't think duplicating swiotlb.c, as has been suggested
> as the alternative, just for that one hook point makes sense.

One hook? You need to reread swiotlb.c. There are more. All should go.
