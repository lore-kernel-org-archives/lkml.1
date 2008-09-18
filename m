Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYIRQjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYIRQjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYIRQj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:39:27 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:42278 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYIRQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:39:26 -0400
X-BigFish: VPS-42(zz146fK1418M1432R98dR1805M179dR936fQ873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K7EGX7-04-BGG-01
Date: Thu, 18 Sep 2008 18:39:11 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 18/23] AMD IOMMU: simplify dma_mask_to_pages
Message-ID: <20080918163911.GG24392@amd.com>
References: <1221670377-19295-19-git-send-email-joerg.roedel@amd.com> <20080918041717S.fujita.tomonori@lab.ntt.co.jp> <20080918073232.GB24392@amd.com> <20080919005651C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080919005651C.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 18 Sep 2008 16:39:11.0897 (UTC) FILETIME=[14650090:01C919AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 12:57:36AM +0900, FUJITA Tomonori wrote:
> On Thu, 18 Sep 2008 09:32:32 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Thu, Sep 18, 2008 at 04:20:20AM +0900, FUJITA Tomonori wrote:
> > > On Wed, 17 Sep 2008 18:52:52 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > The current calculation is very complicated. This patch replaces it with
> > > > a much simpler version.
> > > > 
> > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > ---
> > > >  arch/x86/kernel/amd_iommu.c |    3 +--
> > > >  1 files changed, 1 insertions(+), 2 deletions(-)
> > > 
> > > I think that you can use iommu_device_max_index() for what
> > > dma_mask_to_pages does.
> > 
> > Hmm, in theory yes. But iommu_device_max_index() returns a size in bytes
> > and not in pages.
> 
> It doesn't return a size in bytes. You could use like:
> 
> limit = iommu_device_max_index(dom->aperture_size >> PAGE_SHIFT, 0,
> 				dma_get_mask(dev) >> PAGE_SHIFT);

Hmm, ok, makes sense if we remove this line too:

	limit = limit < size ? limit : size;

This is the logic in iommu_device_max_index().

> Anyway, it's not urgent at all. I'll send a patch for this after your
> patchset is merged.

Ok, fine.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

