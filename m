Return-Path: <linux-kernel-owner+w=401wt.eu-S1763925AbXJPAWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763925AbXJPAWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbXJPAWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:22:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:40233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547AbXJPAWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:22:31 -0400
Date: Tue, 16 Oct 2007 02:22:29 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
Message-ID: <20071016002229.GA5851@wotan.suse.de>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz> <20071015143732.01d99af8@laptopd505.fenrus.org> <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 12:08:01AM +0200, Mikulas Patocka wrote:
> > On Mon, 15 Oct 2007 22:47:42 +0200 (CEST)
> > Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:
> > 
> > > > According to latest memory ordering specification documents from
> > > > Intel and AMD, both manufacturers are committed to in-order loads
> > > > from cacheable memory for the x86 architecture. Hence, smp_rmb()
> > > > may be a simple barrier.
> > > >
> > > > http://developer.intel.com/products/processor/manuals/318147.pdf 
> > > > http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf
> > > 
> > > Hi
> > > 
> > > I'm just wondering about one thing --- what is LFENCE instruction
> > > good for?
> > > 
> > > SFENCE is for enforcing ordering in write-combining buffers (it
> > > doesn't have sense in write-back cache mode).
> > > MFENCE is for preventing of moving stores past loads.
> > > 
> > > But what is LFENCE for? I read the above documents and they already
> > > say that CPUs have ordered loads.
> > > 
> > 
> > The cpus also have an explicit set of instructions that deliberately do 
> > unordered stores/loads, and s/lfence etc are mostly designed for those.
> 
> I know about unordered stores (movnti & similar) --- they basically use 
> write-combining method on memory that is normally write-back --- and they 
> need sfence. But which one instruction does unordered load and needs 
> lefence?

Also, for non-wb memory. I don't think the Intel document referenced
says anything about this, but the AMD document says that loads can pass
loads (page 8, rule b).

This is why our rmb() is still an lfence.

