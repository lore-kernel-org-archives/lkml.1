Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZJXDHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZJXDHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 23:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZJXDHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 23:07:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:39621 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbZJXDHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 23:07:52 -0400
Date: Sat, 24 Oct 2009 12:06:56 +0900
To: chrisw@sous-sol.org
Cc: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init
	failures
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091023163923.GA12883@sequoia.sous-sol.org>
References: <20091023012158.177308035@sequoia.sous-sol.org>
	<20091023145054P.fujita.tomonori@lab.ntt.co.jp>
	<20091023163923.GA12883@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091024120633Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 24 Oct 2009 12:06:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Oct 2009 09:39:23 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> > The concept sounds fine but the third patch doesn't look correct.
> > 
> > Seems that the third patch doesn't take into account enabling both hw
> > iommu and swiotlb (Calgary does and I guess VT-d and AMD need that
> > too).
> 
> VT-d isn't using swiotlb.  Nor is AMD, although I think it will pick up
> no_iommu on passthrough (seems like it would benefit from swiotlb in
> that case).

I think that they need swiotlb for the same reason why Calgray needs
it. IIRC, someone in VT-d camp said so.


> >  Also (iommu_detected && !dma_ops) trick doesn't work for
> > Calgary, IIRC.
> 
> Yes, I think you are right.  I had stared at the calgary code and thought
> it would DTRT due to calgary's use of no_iommu as fallback, but instead
> it will never pick up swiotlb_dma_ops.

Note that Calgary comment 'falling back to no_iommu' is misleading. It
actually falls back to swiotlb or nommu properly.

Calgary doesn't set to dma_ops to calgary_dma_ops so it doesn't need
to pick up swiotlb_dma_ops.


> The calgary shouldn't even need to be manually setting up
> nommu_dma_ops.

Yeah, but it needs because of how the dma startup code works.
