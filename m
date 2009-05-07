Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbZEGMAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbZEGMAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZEGMAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:00:19 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:24118
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752474AbZEGMAS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:00:18 -0400
X-BigFish: VPS-18(zz1432R98dR1805M936fJzz1202hzzz32i6bh15fn43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KJ9W07-04-FZ9-01
Date: Thu, 7 May 2009 14:00:08 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
Message-ID: <20090507120007.GG4059@amd.com>
References: <20090428160448.GA17438@amd.com> <20090507164742V.fujita.tomonori@lab.ntt.co.jp> <20090507100114.GF4059@amd.com> <20090507191724N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090507191724N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 May 2009 12:00:08.0547 (UTC) FILETIME=[5E00CB30:01C9CF0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 07:23:33PM +0900, FUJITA Tomonori wrote:
> On Thu, 7 May 2009 12:01:14 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > > Do you meant that AMD IOMMU code use the bitmap each device to manage
> > > address space so enlarging the DMA address space wastes memory?
> > 
> > Its not only the bitmap. There are also the page tables that would waste
> > memory if the aperture in the AMD IOMMU driver is enlarged to, say, 4GB.
> > Most devices don't need such a large amount of DMA address space. As I
> > found out VT-d does not have this problem because they implemented
> > another allocator which can cover all possible memory.
> > For the AMD IOMMU I currently implement a kind of a dynamically growing
> > bitmap allocator to fix this problem.
> 
> Yeah, I know the deference. Well, I like the AMD IOMMU driver's
> property that dma mapping doesn't fail in OOM but I understand why you
> want such daynamically growing.

Well, I will try to minimize the impact. Current plan is to preallocate
bitmap and page tables for 128MB of DMA address space. Everything beyond
that will be allocated on demand.

> > > >  But unless this problem isn't solved the
> > > > drivers won't be fixed, I guess.
> > > > I guess the DRM code in the kernel may have the same problem with IOMMU
> > > > enabled?
> > > 
> > > Looks like the DRM code uses the DMA API.
> > 
> > The proprietary drivers make problems so far. For the ATI one I am in
> > contact with the developers to try to fix it. But I can't do anything
> > about the other proprietary driver I am aware of :-(
> 
> I don't know anything about the graphic drivers but are there any
> other proprietary drivers except for ATI and AMD? Fixing only two
> drivers to make the majority happy?

At least Nvidia comes to my mind. Not sure about other graphic card
vendors...

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

