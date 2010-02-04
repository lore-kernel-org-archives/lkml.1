Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab0BDDbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:31:41 -0500
Received: from sh.osrg.net ([192.16.179.4]:55084 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab0BDDbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:31:39 -0500
Date: Thu, 4 Feb 2010 12:31:23 +0900
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, James.Bottomley@suse.de
Subject: Re: [PATCH -mm 1/4] DMA-API.txt: add dma_sync_single/sg API
 description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100203.192123.112190123.davem@davemloft.net>
References: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100203.192123.112190123.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100204123056Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Feb 2010 12:31:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Feb 2010 19:21:23 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Thu,  4 Feb 2010 12:13:22 +0900
> 
> > This adds the description of the following eight function:
> > 
> > dma_sync_single_for_cpu
> > pci_dma_sync_single_for_cpuvoid
>                              ^^^^
> 
> That "void" is probably some cut and paste error :-)

Oops.


> > dma_sync_single_for_device
> > pci_dma_sync_single_for_device
> > dma_sync_sg_for_cpu
> > pci_dma_sync_sg_for_cpu
> > dma_sync_sg_for_device
> > pci_dma_sync_sg_for_device
> > 
> > It was unclear that the API permits a partial sync (some network
> > drivers already do though). I made it clear that the sync_single API
> > can do a partial sync but the sync_sg API can't.
> > 
> > We could do a partial sync with the sync_sg too, however, it's
> > difficult for driver writers to correctly use the sync_sg API for a
> > partial sync since the scatterlists passed in to the mapping API can
> > be modified. It's unlikely that driver writers want to do a partial
> > sync with the sync_sg API (because the sync_sg API are usually used
> > for block drivers). So I think that it's better to forbid a partial
> > sync with the sync_sg API.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks,

I found other two typos in the commit log so here's the update.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -mm 1/4] DMA-API.txt: add dma_sync_single/sg API description

This adds the description of the following eight function:

dma_sync_single_for_cpu
pci_dma_sync_single_for_cpu
dma_sync_single_for_device
pci_dma_sync_single_for_device
dma_sync_sg_for_cpu
pci_dma_sync_sg_for_cpu
dma_sync_sg_for_device
pci_dma_sync_sg_for_device

It was unclear that the API permits a partial sync (some network
drivers already do though). I made it clear that the sync_single API
can do a partial sync but the sync_sg API can't.

We could do a partial sync with the sync_sg API too, however, it's
difficult for driver writers to correctly use the sync_sg API for a
partial sync since the scatterlists passed in to the mapping API can't
be modified. It's unlikely that driver writers want to do a partial
sync with the sync_sg API (because the sync_sg API are usually used
for block drivers). So I think that it's better to forbid a partial
sync with the sync_sg API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@suse.de>
