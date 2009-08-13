Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZHMID7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZHMID7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZHMID6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:03:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:33333 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZHMID4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:03:56 -0400
Date: Thu, 13 Aug 2009 17:03:09 +0900
To: luming.yu@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, fenghua.yu@intel.com, dwmw2@infradead.org,
       tony.luck@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
References: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
	<20090813161407A.fujita.tomonori@lab.ntt.co.jp>
	<3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 13 Aug 2009 17:03:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 15:37:54 +0800
Luming Yu <luming.yu@gmail.com> wrote:

> On Thu, Aug 13, 2009 at 3:14 PM, FUJITA
> Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Thu, 13 Aug 2009 15:03:20 +0800
> > Luming Yu <luming.yu@gmail.com> wrote:
> >
> >> Thanks for another workaround, we should be working on deleting wrong
> >> assumption of"iommu_deteced == iommu working", Not just workaround. My
> >> patch could break something.. but it is just a start towards right
> >> goal..
> >
> > As I explained, your patch doesn't go toward the right goal.
> 
> The goal is to decouple dma_ops init and iommu_detect.
> In that sense, my patch is right.

No, your patch is a workaround too.

If you want swiotlb the default dma_ops for IA64, pci_swiotlb_init()
is the wrong place for swiotlb_init() because sba needs swiotlb too
for the same reason. Probably, we should always set platform_dma_init
to swiotlb_dma_init().


You want to fix this problem for 2.6.31? Or you think about 2.6.32 (or
later)?
