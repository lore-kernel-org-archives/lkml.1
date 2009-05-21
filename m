Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZEULDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZEULDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZEULD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:03:27 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:19496 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635AbZEULD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:03:26 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "jeremy@goop.org" <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "beckyb@kernel.crashing.org" <beckyb@kernel.crashing.org>,
       "okir@suse.de" <okir@suse.de>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "gregkh@suse.de" <gregkh@suse.de>
In-Reply-To: <20090521193910W.fujita.tomonori@lab.ntt.co.jp>
References: <20090521175436L.fujita.tomonori@lab.ntt.co.jp>
	 <1242901630.22654.135.camel@zakaz.uk.xensource.com>
	 <1242901733.22654.138.camel@zakaz.uk.xensource.com>
	 <20090521193910W.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 21 May 2009 12:03:05 +0100
Message-Id: <1242903785.22654.157.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: Where do we stand with the Xen patches?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=ez88a1iWV38A:10 a=-82-ppXOAuYA:10 a=AZfGcq7nAAAA:8 a=cuQgqGksOJk2yNEa9-gA:9 a=M_f3wmcH1XOIuJToxZ0A:7 a=31XbGD-HMVtwKlunzjn8GFCReJ8A:4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 06:39 -0400, FUJITA Tomonori wrote:
> On Thu, 21 May 2009 11:28:53 +0100
> Ian Campbell <ijc@hellion.org.uk> wrote:
>  
> > +#ifdef CONFIG_PCI_XEN
> > +extern int xen_range_needs_mapping(phys_addr_t paddr, size_t size);
> > +#else
> > +static inline int xen_range_needs_mapping(phys_addr_t paddr, size_t size) { return 0; }
> > +#endif
> 
> I know Xen can do something like this but you think that this is
> clean?

Well, defining a static inline function when a CONFIG option is disabled
is fairly idiomatic in the kernel and in general hiding these sorts of
things in the headers in this way is preferred to having them in .c
files. See e.g. the handling of CONFIG_PRINTK in include/linux/kernel.h
or CONFIG_HIGHMEM in include/linux/highmem.h for just two examples out
of many.

> In addition, you also the similar hack in
> arch/ia64/include/asm/dma-mapping.h for ia64's dom0 support, I think.
> 
> IMO, your patch just moves the ugly hacks from lib/swiotlb.c to
> arch/{x86|ia64}/include/asm/dma-mapping.h.

I nearly suggested that for this hook it might actually be preferable to
put the one line Xen hook directly into swiotlb.c. I didn't think this
suggestion would go down very well though.

In any case something along these lines needs to go somewhere. I think
you are slightly mischaracterising this as an "ugly hack" -- it is a
necessary interface to enable a particular use-case, and it actually has
a very small cross section (it's basically five or six lines of code).

If there was a cleaner way to achieve the same result we would of course
go with that. I don't think duplicating swiotlb.c, as has been suggested
as the alternative, just for that one hook point makes sense.

Ian.

-- 
Ian Campbell
Current Noise: Isis - Altered Course

"For a male and female to live continuously together is...  biologically
speaking, an extremely unnatural condition."
		-- Robert Briffault

