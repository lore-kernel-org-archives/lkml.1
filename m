Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYICULt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYICULt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYICULl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:11:41 -0400
Received: from 8bytes.org ([88.198.83.132]:34108 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbYICULk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:11:40 -0400
Date: Wed, 3 Sep 2008 22:11:39 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH] swiotlb: fix dma_alloc_coherent allocation failures with swiotlb
Message-ID: <20080903201139.GE16706@8bytes.org>
References: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com> <20080904024842J.fujita.tomonori@lab.ntt.co.jp> <20080903195414.GB16706@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903195414.GB16706@8bytes.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 09:54:15PM +0200, Joerg Roedel wrote:
> On Thu, Sep 04, 2008 at 03:05:21AM +0900, FUJITA Tomonori wrote:
> > On Wed, 3 Sep 2008 17:03:44 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > The SWIOTLB version of dma_alloc_coherent allocates all memory with
> > > GFP_DMA unconditionally. This leads sometimes unnecessary to allocation
> > > failures. This patch makes the allocation strategy to use the DMA32 zone
> > > first if this is possible. The changes are boot tested on AMD64 and
> > > compile tested for i386 and IA64.
> > > 
> > > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > Cc: tony.luck@intel.com
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > ---
> > >  lib/swiotlb.c |   23 +++++++++++++++++------
> > >  1 files changed, 17 insertions(+), 6 deletions(-)
> > 
> > This doesn't look correct since IA64 doesn't need this flag hack.
> 
> Thats why the patch checks the DMA mask against ISA_DMA_THRESHOLD. This
> is defined as the border of the ZONE_DMA (16MB on x86 and 4G on IA64).
> So is correct for x86 and ia64.
> 
> > Another problem about this patch is that swiotlb doesn't use GFP_DMA
> > for the fallback_dev.
> 
> Thats not true, it does. ISA_DMA_THRESHOLD is defined to be the same as
> DMA_24BIT_MASK, which is the DMA mask of the fallback_dev.

(on x86, which defines the fallback_dev)

> 
> Joerg
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu
