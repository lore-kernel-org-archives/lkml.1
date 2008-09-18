Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYIRP54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYIRP54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYIRP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:57:48 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59283 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbYIRP5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:57:47 -0400
Date: Fri, 19 Sep 2008 00:57:36 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 18/23] AMD IOMMU: simplify dma_mask_to_pages
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080918073232.GB24392@amd.com>
References: <1221670377-19295-19-git-send-email-joerg.roedel@amd.com>
	<20080918041717S.fujita.tomonori@lab.ntt.co.jp>
	<20080918073232.GB24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919005651C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 09:32:32 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, Sep 18, 2008 at 04:20:20AM +0900, FUJITA Tomonori wrote:
> > On Wed, 17 Sep 2008 18:52:52 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > The current calculation is very complicated. This patch replaces it with
> > > a much simpler version.
> > > 
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > ---
> > >  arch/x86/kernel/amd_iommu.c |    3 +--
> > >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > I think that you can use iommu_device_max_index() for what
> > dma_mask_to_pages does.
> 
> Hmm, in theory yes. But iommu_device_max_index() returns a size in bytes
> and not in pages.

It doesn't return a size in bytes. You could use like:

limit = iommu_device_max_index(dom->aperture_size >> PAGE_SHIFT, 0,
				dma_get_mask(dev) >> PAGE_SHIFT);


Anyway, it's not urgent at all. I'll send a patch for this after your
patchset is merged.
