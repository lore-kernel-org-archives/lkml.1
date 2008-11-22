Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYKVJi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYKVJi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 04:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYKVJiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 04:38:17 -0500
Received: from 8bytes.org ([88.198.83.132]:42408 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYKVJiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 04:38:16 -0500
Date: Sat, 22 Nov 2008 10:38:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, netdev@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 07/10] x86: add checks for alloc/free_coherent code
Message-ID: <20081122093815.GH29705@8bytes.org>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-8-git-send-email-joerg.roedel@amd.com> <20081122120902Y.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081122120902Y.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 12:27:42PM +0900, FUJITA Tomonori wrote:
> On Fri, 21 Nov 2008 17:26:07 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > +void debug_alloc_coherent(struct device *dev, size_t size,
> > +			  dma_addr_t dma_addr, void *virt)
> > +{
> > +	unsigned long flags;
> > +	struct dma_debug_entry *entry;
> > +
> > +	if (dma_addr == bad_dma_address)
> > +		return;
> > +
> > +	entry = dma_entry_alloc();
> > +	if (!entry)
> > +		return;
> > +
> > +	entry->type      = DMA_DEBUG_COHERENT;
> > +	entry->dev       = dev;
> > +	entry->cpu_addr  = virt;
> > +	entry->size      = size;
> > +	entry->dev_addr  = dma_addr;
> > +	entry->direction = DMA_BIDIRECTIONAL;
> > +
> > +	spin_lock_irqsave(&dma_lock, flags);
> > +	add_dma_entry(entry);
> > +	spin_unlock_irqrestore(&dma_lock, flags);
> > +}
> > +EXPORT_SYMBOL(debug_alloc_coherent);
> 
> Can you clean up the duplication in debug_map_single, debug_map_sg,
> and debug_alloc_coherent? The higher-level helper functions might
> help.

Hmm, lets see. For me it makes only sense if it won't result in helper
functions with tons of parameters. This is worse than little code
duplication. But lets see.

Joerg

