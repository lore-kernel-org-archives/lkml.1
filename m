Return-Path: <linux-kernel-owner+w=401wt.eu-S1765492AbZANRkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765492AbZANRkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765389AbZANRkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:40:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756955AbZANRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:40:40 -0500
Date: Wed, 14 Jan 2009 09:39:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/16] dma-debug: add hash functions for
 dma_debug_entries
Message-Id: <20090114093918.e7b0ae46.akpm@linux-foundation.org>
In-Reply-To: <20090114114347.GG8625@elte.hu>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
	<1231517970-20288-4-git-send-email-joerg.roedel@amd.com>
	<20090113005118.82f5037b.akpm@linux-foundation.org>
	<20090114114347.GG8625@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 12:43:47 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 9 Jan 2009 17:19:17 +0100 Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > +struct hash_bucket {
> > > +	struct list_head list;
> > > +	spinlock_t lock;
> > > +} ____cacheline_aligned;
> > 
> > __cacheline_aligned_in_smp.
> > 
> > This all looks like an exotically large amount of code for a debug 
> > thingy?
> 
> this code checks the DMA usage of ~1 million lines of kernel code - all 
> the DMA using drivers. I think Joerg's feature is hugely relevant as DMA 
> scribbles are one of the hardest to debug kernel bugs: they can end up in 
> permanent data corruption or other hard to find bugs. In fact i think his 
> patchset is rather simple and even having 10 times as much debug code 
> would pay for its existence in the long run.
> 

Have we previously found bugs by other means which this facility would
have detected?  I don't recall any...

