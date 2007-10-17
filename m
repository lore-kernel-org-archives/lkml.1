Return-Path: <linux-kernel-owner+w=401wt.eu-S934221AbXJQLFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221AbXJQLFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760212AbXJQLE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:04:56 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759795AbXJQLEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:04:54 -0400
Date: Wed, 17 Oct 2007 13:04:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Message-ID: <20071017110426.GV5043@kernel.dk>
References: <20071017091629.GK5043@kernel.dk> <20071017.035441.74746708.davem@davemloft.net> <20071017105840.GT5043@kernel.dk> <20071017.040414.55507057.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017.040414.55507057.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, 17 Oct 2007 12:58:40 +0200
> 
> > The problem is that you cannot zero the entire sg entry, because then
> > you'd potentially overwrite the chain pointer.
> > 
> > I'd propose just adding a
> > 
> >         sg_dma_address(sg) = 0;
> >         sg_dma_len(sg) = 0;
> > 
> > there for now, or provide an arch_clear_sg_entry() helper if we need
> > more killed.
> 
> The "chain pointer" is indicated by an sg->page with the low
> bit set, but we're explicitly initializing it here to a
> non-chain page pointer value.
> 
> What's the problem?

See next mail :-)

-- 
Jens Axboe

