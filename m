Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZGGI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZGGI7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZGGI7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:59:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27304 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbZGGI7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:59:11 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1432R98dN936eM1805Mzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KMEMAH-01-QRV-01
Date: Tue, 7 Jul 2009 10:59:04 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Dave Airlie <airlied@linux.ie>
CC: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
       Zhenyu Wang <zhenyu.z.wang@intel.com>, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org,
       mingo@redhat.com, David Miller <davem@davemloft.net>, eric@anholt.net
Subject: Re: IOMMU and graphics cards
Message-ID: <20090707085904.GP5380@amd.com>
References: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
 <20090507100114.GF4059@amd.com>
 <1241691721.3531.73.camel@macbook.infradead.org>
 <20090507.113632.210373283.davem@davemloft.net>
 <20090508093526.GB13708@8bytes.org>
 <1246883177.2615.33.camel@macbook.infradead.org>
 <20090706131156.GL5380@amd.com>
 <1246889932.2615.81.camel@macbook.infradead.org>
 <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907062232350.5769@skynet.skynet.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Jul 2009 08:59:04.0578 (UTC) FILETIME=[2DC56E20:01C9FEE1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 10:35:59PM +0100, Dave Airlie wrote:
> 
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

Are you sure that using the dma-api has such an performance impact? I've
heard from other people that switching to dma-api with amd iommu had no
significant performance impact.

> I personally have no IOMMU hw from Intel or AMD and nobody has seen it fit 
> to supply me with any at any point in time, I'm not on the correct gravy 
> train. So I suspect the people with the hw will have to do the work and 
> the regression testing.

You just need to switch to dma-api. You don't need an iommu to test.
Most bugs in such code can also be found and eliminated using the
dma-api debugging interface.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

