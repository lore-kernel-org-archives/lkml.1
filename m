Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbXDBF3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbXDBF3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXDBF3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:29:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbXDBF3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:29:11 -0400
To: "Dave Airlie" <airlied@gmail.com>
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: drm + 4GB RAM + swiotlb = drm craps out
References: <21d7e9970704011644n3adbef2brc6bfeb288f5d0866@mail.gmail.com>
	<20070401.201134.82699692.davem@davemloft.net>
	<21d7e9970704012108m5fd9797bk45c4b39892c8d36f@mail.gmail.com>
	<20070401.220841.89389711.davem@davemloft.net>
	<21d7e9970704012215n67487549vbc7592a4f181e288@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Apr 2007 08:27:40 +0200
In-Reply-To: <21d7e9970704012215n67487549vbc7592a4f181e288@mail.gmail.com>
Message-ID: <p731wj31ear.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Dave Airlie" <airlied@gmail.com> writes:
> 
> On a 64-bit machine GFP_KERNEL can give me any memory... it all works
> fine on 32-bit highmem kernel as I don't get highmem... I really need
> __GFP_DMA32 memory but we don't have a generic allocator that gives
> this out that I can see..

__get_free_pages(..., __GFP_DMA32) on 64bit or __GFP_KERNEL or i386
(only gives you ~900MB) 
 
> > Are you expecting to be able to virtually remap these pages in
> > PCI space as one huge 8MB chunk too and that's how swiotlb gets
> > involved?  That won't work, sorry...
> 
> Well I feed the bus address for each page into a GART table in the GPU
> and it does the linear stuff internally in the GPU memory
> controller...
> 
> I suppose I want __GFP_I_D_RATHER_DIE_THAN_BOUNCE.

Not sure what you mean? __alloc_pages never bounces by itself.
The nearest you can get is __GFP_DMA/__GFP_DMA32, but these have
their own 16MB/4GB zones and don't use the swiotlb pools. And of course it
only gives you plain memory, but doesn't remap or copy anything.

I have some plans to unify this with swiotlb, but they're not done.

-Andi
