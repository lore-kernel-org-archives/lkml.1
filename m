Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYHUPVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYHUPVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbYHUPVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:21:40 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:59018 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYHUPVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:21:39 -0400
X-BigFish: VPS-42(zz1432R98dR936eQ1805M936fQ9371P10d1I873fnzz10d3izzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K5YINE-04-2JV-01
Date: Thu, 21 Aug 2008 17:20:57 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, jbarnes@virtuousgeek.org, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
Message-ID: <20080821152056.GC3189@amd.com>
References: <20080820094612.GA28492@elte.hu> <200808201039.56887.jbarnes@virtuousgeek.org> <20080821120011.GD5615@elte.hu> <20080821231720S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080821231720S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Aug 2008 15:20:57.0149 (UTC) FILETIME=[828A4ED0:01C903A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 11:16:50PM +0900, FUJITA Tomonori wrote:
> On Thu, 21 Aug 2008 14:00:11 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > On Wednesday, August 20, 2008 2:46 am Ingo Molnar wrote:
> > > > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > > Hi,
> > > > >
> > > > > this patchset reworks the dma_*_coherent functions in the DMA layer
> > > > > for the x86 architecture. The patch series extends the existing DMA
> > > > > backends with missing *coherent callbacks and simplifies the generic
> > > > > function to basically only call the registered backend. This allows
> > > > > future optimizations in hardware specific IOMMU implementations. The
> > > > > code ist tested on AMD64 with AMD IOMMU, GART, SWIOTLB and NOMMU as
> > > > > well as on my old 486 box. Muli tested the Calgary specific patch.
> > > > >
> > > > > Joerg
> > > > >
> > > > > Changes since v1:
> > > > >
> > > > > - fixed wrong logic in the pci-nommu alloc_coherent code
> > > > > - moved dma_*_coherent to include/asm-x86/dma-mapping.h
> > > > >
> > > > > git diff --stat tip/master.. :
> > > > >
> > > > >  arch/x86/kernel/amd_iommu.c      |    2 -
> > > > >  arch/x86/kernel/pci-calgary_64.c |   14 ++++
> > > > >  arch/x86/kernel/pci-dma.c        |  146
> > > > > +------------------------------------- arch/x86/kernel/pci-gart_64.c    |
> > > > >   35 +++++++++-
> > > > >  arch/x86/kernel/pci-nommu.c      |   62 ++++++++++++++++
> > > > >  include/asm-x86/dma-mapping.h    |   47 ++++++++++---
> > > > >  6 files changed, 149 insertions(+), 157 deletions(-)
> > > >
> > > > applied to tip/x86/iommu - thanks Joerg!
> > > >
> > > > Jesse, Fujita-san, do these changes look fine to you?
> > > 
> > > Yeah, I'll let you push this time. :)
> > > 
> > > Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > with a v2.6.28 ETA, right?
> 
> Surely, this patchset should be for 2.6.28.
> 
> Can you send this via the x86 tree instead of pci?
> 
> - IOMMU code is arch stuff rather than pci.
> - We can avoid a mistake such as the previous one.

Yes, this is definitly 2.6.28 stuff.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

