Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYIQKny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYIQKny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 06:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYIQKnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 06:43:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbYIQKnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 06:43:46 -0400
Date: Wed, 17 Sep 2008 12:43:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about
	virtual mappings
Message-ID: <20080917104327.GD18764@elte.hu>
References: <20080916134335.GC25711@one.firstfloor.org> <20080917021319O.fujita.tomonori@lab.ntt.co.jp> <20080916175824.GF25711@one.firstfloor.org> <20080917085335F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917085335F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 16 Sep 2008 19:58:24 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > > Those always are handled elsewhere in the block layer (using the bounce_pfn
> > > > mechanism)
> > > 
> > > I don't think that the bounce guarantees that dma_alloc_coherent()
> > > returns an address that a device can access to.
> > 
> > dma_alloc_coherent() is not used for block IO data. And dma_alloc_coherent()
> > does handle masks > 24bit < 32bits just fine.
> 
> What do you mean? For example, some aacraid cards have 31bit dma
> mask. What guarantees that IOMMUs's dma_alloc_coherent don't return a
> virtual address > 31bit < 32bit?
> 
> 
> > > I'm not familiar with what the networking does, for example, seems
> > > that b44 sets dev->dma_mask to DMA_30BIT_MASK and b44_start_xmit()
> > > does:
> > > 
> > 
> > b44 (and related designs like the bcm wireless chipset) 
> > has its own bouncing scheme. IT doesn't need any hacks in map_sg
> >  
> > > IOMMUs can try to return an address that the NIC can access to.
> > 
> > It's not worth to handle this strange case. The drivers do anyways. 
> > These are very cheap devices which are only rarely used in systems 
> > with >2GB and for those cases the existing bouncing setup works 
> > fine.
> 
> I think that the patch is a pretty straightforward, it just the same 
> thing that IOMMUs with > 32bits virtual address space do. We can do 
> better with the simple patch. But I'm ok with dropping the patch for 
> GART since we can live without the patch, as you said.

no - any extra layer of robustness is good in such a critical piece of 
code. Perhaps also emit a one-time printk if you really consider the use 
as a potential sign of bugs, but dont remove robustness.

	Ingo
