Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZGGJFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZGGJFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 05:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZGGJFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 05:05:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:39444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbZGGJFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 05:05:24 -0400
Subject: Re: IOMMU and graphics cards
From: David Woodhouse <dwmw2@infradead.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Joerg Roedel <joro@8bytes.org>,
       Zhenyu Wang <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       mingo@redhat.com, David Miller <davem@davemloft.net>, eric@anholt.net
In-Reply-To: <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
	 <20090507100114.GF4059@amd.com>
	 <1241691721.3531.73.camel@macbook.infradead.org>
	 <20090507.113632.210373283.davem@davemloft.net>
	 <20090508093526.GB13708@8bytes.org>
	 <1246883177.2615.33.camel@macbook.infradead.org>
	 <20090706131156.GL5380@amd.com>
	 <1246889932.2615.81.camel@macbook.infradead.org>
	 <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jul 2009 10:05:14 +0100
Message-Id: <1246957514.2615.223.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 22:35 +0100, Dave Airlie wrote:
> 
> On Mon, 6 Jul 2009, David Woodhouse wrote:
> 
> > On Mon, 2009-07-06 at 15:11 +0200, Joerg Roedel wrote:
> > > Ok, cool, that sounds good. Which in-kernel DRM drivers break with IOMMU
> > > for you? I'll may probably add a similar temporary workaround for AMD
> > > IOMMU too...
> > 
> > The Intel one definitely broke -- I don't know about the others. There
> > are some old patches at http://people.freedesktop.org/~zhen/agp-mm-*
> > which make it look like _all_ AGP drivers are broken.
> > 
> > I wouldn't bother adding the workaround -- as I said, I'm planning to
> > rip it out of 2.6.32 (and in linux-next as soon as it's reasonable to do
> > so). Let's just let them fix it.
> 
> cc'ing Eric,
> 
> My memory of this is graphics becomes totally useless and can be 10x-50x 
> slower. I think ripping this out without the person doing the ripping 
> taking responsiblity for doing speed regression testing is totally insane.

If the IOMMU is absent, disabled or in pass-through mode, then the
performance impact should be virtually zero.

It's the case where the IOMMU is in use that matters -- and the choice
there is between "slow" and "broken". I'll take "slow", please.

Having said that, I've done a bunch of performance work recently and
especially multi-page mappings are a _lot_ faster than they used to be.
I'll see if I can do more once I can test it with your actual usage
patterns.

We currently have an evil hack which uses a shitload of memory to set up
a full set of page tables to map all of physical memory, for every
graphics device at boot time whether we need it or not. The AMD folks
have so far resisted doing that, partly because of the amount of RAM it
would take. I'm getting poked from all sides to _remove_ our hack.

> I personally have no IOMMU hw from Intel or AMD and nobody has seen it fit 
> to supply me with any at any point in time, I'm not on the correct gravy 
> train. So I suspect the people with the hw will have to do the work and 
> the regression testing.

Anything with Cantiga chipset would suffice. Lenovo x200s, T400, etc...

> Could you also enumerate any limitations of the IOMMUs on the amount  
> of memory they can remap per device if any.

The Intel one basically has no relevant limit -- it's 54 bits of virtual
address space or something like that.

I think I saw something about the AMD one perhaps being limited to 4GiB
per device -- which makes 1:1 mapping of all memory a lot less feasible,
but I'll let Jörg answer that question definitively.

Not sure about other platforms off-hand.

-- 
dwmw2

