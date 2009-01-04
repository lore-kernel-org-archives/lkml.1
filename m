Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbZADMmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbZADMmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZADMmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:42:12 -0500
Received: from sh.osrg.net ([192.16.179.4]:45849 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZADMmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:42:11 -0500
Date: Sun, 4 Jan 2009 21:41:45 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, beckyb@kernel.crashing.org,
       jj@chaosbits.net, weiyi.huang@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: swiotlb: remove duplicated #include
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090104121914.GA30255@elte.hu>
References: <20090104112541.GA25434@elte.hu>
	<20090104210420X.fujita.tomonori@lab.ntt.co.jp>
	<20090104121914.GA30255@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090104214109A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 13:19:14 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Sun, 4 Jan 2009 12:25:43 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Jesper Juhl <jj@chaosbits.net> wrote:
> > > 
> > > > On Sun, 4 Jan 2009, Huang Weiyi wrote:
> > > > 
> > > > > Removed duplicated #include in lib/swiotlb.c.
> > > > > 
> > > > 
> > > > This is identical to a patch I already submitted - 
> > > > http://lkml.org/lkml/2009/1/2/360 - but I don't know if that one has been 
> > > > merged anywhere yet.
> > > 
> > > i've applied yours to tip/core/urgent, thanks Jesper!
> > 
> > The same cleanup is in tip/core/iommu:
> > 
> > http://marc.info/?l=linux-kernel&m=123044446721529&w=2
> 
> yes, correct - as part of Becky and Jeremy's highmem series.
> 
> > My cleanup patches in it are trivial, but I like to see Becky's swiotlb 
> > highmem work, which is still in tip/core/iommu. When do you plan to push 
> > it to mainline?
> 
> In a few days, but wanted to hear back from either Jeremy or Becky first 
> about how well they actually work in their usecases.

Well, you don't need to wait, I think.

All Jeremy and Becky need is adding highmem support to swiotlb. How we
support it doesn't matter. We can choose better one.

We all (including Jeremy) agreed that Becky's physical address scheme
is better (simpler) than Jeremy's struct page and offset
scheme. Surely, Becky's scheme works for Xen and him (Jeremy said that
he tested it lightly).

One remaining issue is how to support map_page/unmap_page. As we
discussed, we can add some workarounds for it but it's better to unify
dma_mapping_ops. I send patches to do it after testing them on an IA64
box tomorrow.
