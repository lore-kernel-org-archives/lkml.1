Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZJ1GyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZJ1GyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbZJ1GyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:54:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:54076 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462AbZJ1GyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:20 -0400
Date: Wed, 28 Oct 2009 15:53:53 +0900
To: chrisw@sous-sol.org
Cc: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init
	failures
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091024065712.GC14926@sequoia.sous-sol.org>
References: <20091023163923.GA12883@sequoia.sous-sol.org>
	<20091024120633Z.fujita.tomonori@lab.ntt.co.jp>
	<20091024065712.GC14926@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091028155251C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Oct 2009 23:57:12 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> > Note that Calgary comment 'falling back to no_iommu' is misleading. It
> > actually falls back to swiotlb or nommu properly.
> > 
> > Calgary doesn't set to dma_ops to calgary_dma_ops so it doesn't need
> > to pick up swiotlb_dma_ops.
> 
> It does need swiotlb_dma_ops even when calgary init succeeds for the devices
> that aren't behind Calgary to deal w/ the case of those devices having
> dma mask smaller than physical memory (i.e those that don't get device
> specific dma_ops set to calgary_dma_ops).

I know since I wrote that code.


> > > The calgary shouldn't even need to be manually setting up
> > > nommu_dma_ops.
> > 
> > Yeah, but it needs because of how the dma startup code works.
> 
> Be much better to have the core handle all of this. Basically register
> ops and then put the top one on the stack to actual use.  So the
> fallback would be automatic, just pick the top of the stack and go.
> Were you thinking of something along those lines?

I don't know what 'register ops and then put the top one on the stack'
means but it sounds overdoing.

I think that we can handle this issue more simply. I've just posted
the patchset.
