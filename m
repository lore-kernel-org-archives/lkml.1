Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZHMJAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZHMJAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZHMJAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:00:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:37240 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbZHMJAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:00:46 -0400
Date: Thu, 13 Aug 2009 18:00:31 +0900
To: dwmw2@infradead.org
Cc: luming.yu@gmail.com, fujita.tomonori@lab.ntt.co.jp, fenghua.yu@intel.com,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
 failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1250153373.29180.225.camel@macbook.infradead.org>
References: <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
	<3877989d0908130111m1a7d8625ha84ed1732a7eae81@mail.gmail.com>
	<1250153373.29180.225.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813175921J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 18:00:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 09:49:33 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Thu, 2009-08-13 at 16:11 +0800, Luming Yu wrote:
> > I treat this as -32 or -33 stuff, because I don't see a real system is blocking
> > on the problem. I found this problem when I was trying to disable some drhd
> > for debugging a real iommu issue...that one has priority.
> 
> (The real bug you were chasing is fixed, isn't it? Or worked around, at
> least, since the BIOS in question is still closed source and broken.)
> 
> But by talking about disabling _some_ drhd units, you've just reminded
> me that the problem is far more interesting -- we can have the IOMMU
> active for _some_ devices but not others.

It's very common. X86, POWER, IA64 can handle it (I might overlook
some).

About X86, Calgary IOMMU uses both archdata.dma_ops and the global
dma_ops.


> I was toying with the idea of putting the intel_dma_ops into
> dev->archdata for each pci device at boot or hotplug time, and leaving
> the global variable alone. We can calculate the dev->iommu mapping at
> that point too. And we can stop being quite so broken w.r.t. PCI
> hotplug...
> 
> -- 
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
