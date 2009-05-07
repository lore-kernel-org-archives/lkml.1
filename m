Return-Path: <linux-kernel-owner+w=401wt.eu-S1761696AbZEGKYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761696AbZEGKYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZEGKYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:24:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:38375 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbZEGKYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:24:45 -0400
Date: Thu, 7 May 2009 19:23:33 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090507100114.GF4059@amd.com>
References: <20090428160448.GA17438@amd.com>
	<20090507164742V.fujita.tomonori@lab.ntt.co.jp>
	<20090507100114.GF4059@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090507191724N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 19:23:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 12:01:14 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> > Do you meant that AMD IOMMU code use the bitmap each device to manage
> > address space so enlarging the DMA address space wastes memory?
> 
> Its not only the bitmap. There are also the page tables that would waste
> memory if the aperture in the AMD IOMMU driver is enlarged to, say, 4GB.
> Most devices don't need such a large amount of DMA address space. As I
> found out VT-d does not have this problem because they implemented
> another allocator which can cover all possible memory.
> For the AMD IOMMU I currently implement a kind of a dynamically growing
> bitmap allocator to fix this problem.

Yeah, I know the deference. Well, I like the AMD IOMMU driver's
property that dma mapping doesn't fail in OOM but I understand why you
want such daynamically growing.


> > >  But unless this problem isn't solved the
> > > drivers won't be fixed, I guess.
> > > I guess the DRM code in the kernel may have the same problem with IOMMU
> > > enabled?
> > 
> > Looks like the DRM code uses the DMA API.
> 
> The proprietary drivers make problems so far. For the ATI one I am in
> contact with the developers to try to fix it. But I can't do anything
> about the other proprietary driver I am aware of :-(

I don't know anything about the graphic drivers but are there any
other proprietary drivers except for ATI and AMD? Fixing only two
drivers to make the majority happy?
