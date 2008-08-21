Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbYHUOZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbYHUOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYHUOZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:25:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:35960 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYHUOZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:25:15 -0400
Date: Thu, 21 Aug 2008 23:16:50 +0900
To: mingo@elte.hu
Cc: jbarnes@virtuousgeek.org, joerg.roedel@amd.com,
       fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080821120011.GD5615@elte.hu>
References: <20080820094612.GA28492@elte.hu>
	<200808201039.56887.jbarnes@virtuousgeek.org>
	<20080821120011.GD5615@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080821231720S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 14:00:11 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > On Wednesday, August 20, 2008 2:46 am Ingo Molnar wrote:
> > > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > Hi,
> > > >
> > > > this patchset reworks the dma_*_coherent functions in the DMA layer
> > > > for the x86 architecture. The patch series extends the existing DMA
> > > > backends with missing *coherent callbacks and simplifies the generic
> > > > function to basically only call the registered backend. This allows
> > > > future optimizations in hardware specific IOMMU implementations. The
> > > > code ist tested on AMD64 with AMD IOMMU, GART, SWIOTLB and NOMMU as
> > > > well as on my old 486 box. Muli tested the Calgary specific patch.
> > > >
> > > > Joerg
> > > >
> > > > Changes since v1:
> > > >
> > > > - fixed wrong logic in the pci-nommu alloc_coherent code
> > > > - moved dma_*_coherent to include/asm-x86/dma-mapping.h
> > > >
> > > > git diff --stat tip/master.. :
> > > >
> > > >  arch/x86/kernel/amd_iommu.c      |    2 -
> > > >  arch/x86/kernel/pci-calgary_64.c |   14 ++++
> > > >  arch/x86/kernel/pci-dma.c        |  146
> > > > +------------------------------------- arch/x86/kernel/pci-gart_64.c    |
> > > >   35 +++++++++-
> > > >  arch/x86/kernel/pci-nommu.c      |   62 ++++++++++++++++
> > > >  include/asm-x86/dma-mapping.h    |   47 ++++++++++---
> > > >  6 files changed, 149 insertions(+), 157 deletions(-)
> > >
> > > applied to tip/x86/iommu - thanks Joerg!
> > >
> > > Jesse, Fujita-san, do these changes look fine to you?
> > 
> > Yeah, I'll let you push this time. :)
> > 
> > Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> with a v2.6.28 ETA, right?

Surely, this patchset should be for 2.6.28.

Can you send this via the x86 tree instead of pci?

- IOMMU code is arch stuff rather than pci.
- We can avoid a mistake such as the previous one.
