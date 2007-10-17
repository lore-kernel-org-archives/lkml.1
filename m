Return-Path: <linux-kernel-owner+w=401wt.eu-S933971AbXJQLEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbXJQLEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXJQLED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:04:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36251
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933245AbXJQLEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:04:00 -0400
Date: Wed, 17 Oct 2007 04:04:14 -0700 (PDT)
Message-Id: <20071017.040414.55507057.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071017105840.GT5043@kernel.dk>
References: <20071017091629.GK5043@kernel.dk>
	<20071017.035441.74746708.davem@davemloft.net>
	<20071017105840.GT5043@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 17 Oct 2007 12:58:40 +0200

> The problem is that you cannot zero the entire sg entry, because then
> you'd potentially overwrite the chain pointer.
> 
> I'd propose just adding a
> 
>         sg_dma_address(sg) = 0;
>         sg_dma_len(sg) = 0;
> 
> there for now, or provide an arch_clear_sg_entry() helper if we need
> more killed.

The "chain pointer" is indicated by an sg->page with the low
bit set, but we're explicitly initializing it here to a
non-chain page pointer value.

What's the problem?
