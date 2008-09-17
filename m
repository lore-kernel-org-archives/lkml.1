Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYIQTVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYIQTVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYIQTUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:20:47 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:33803 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741AbYIQTUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:20:46 -0400
Date: Thu, 18 Sep 2008 04:20:14 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about
 virtual mappings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080917002404.GG25711@one.firstfloor.org>
References: <20080916175824.GF25711@one.firstfloor.org>
	<20080917085335F.fujita.tomonori@lab.ntt.co.jp>
	<20080917002404.GG25711@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080918035726F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 02:24:04 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, Sep 17, 2008 at 08:53:42AM +0900, FUJITA Tomonori wrote:
> > On Tue, 16 Sep 2008 19:58:24 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > > Those always are handled elsewhere in the block layer (using the bounce_pfn
> > > > > mechanism)
> > > > 
> > > > I don't think that the bounce guarantees that dma_alloc_coherent()
> > > > returns an address that a device can access to.
> > > 
> > > dma_alloc_coherent() is not used for block IO data. And dma_alloc_coherent()
> > > does handle masks > 24bit < 32bits just fine.
> > 
> > What do you mean? For example, some aacraid cards have 31bit dma
> > mask. What guarantees that IOMMUs's dma_alloc_coherent don't return a
> > virtual address > 31bit < 32bit?
> 
> At least the old IOMMU implementations (GART, non GART) handled this
> by falling back to GFP_DMA. I haven't checked if that didn't get broken
> in the recent reorganization, but if it got it should be fixed of course.
> But hopefully it still works.

The falling back mechanism was moved to pci-nommu from the common code
since it doesn't work for other IOMMUs that always need virtual
mappings. Calgary needs this dma_mask trick too but I guess that it's
unlikely that the IBM servers with Calgary have weird hardware.
