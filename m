Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYIDICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYIDICe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYIDICS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:02:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54317 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYIDICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:02:17 -0400
Date: Thu, 4 Sep 2008 10:05:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, joerg.roedel@amd.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       tony.luck@intel.com
Subject: Re: [PATCH] swiotlb: fix dma_alloc_coherent allocation failures with swiotlb
Message-ID: <20080904080528.GZ18288@one.firstfloor.org>
References: <877i9sx4nk.fsf@basil.nowhere.org> <20080904131130E.fujita.tomonori@lab.ntt.co.jp> <20080904074441.GY18288@one.firstfloor.org> <20080904165852I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904165852I.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 04:58:37PM +0900, FUJITA Tomonori wrote:
> On Thu, 4 Sep 2008 09:44:41 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Thu, Sep 04, 2008 at 01:11:47PM +0900, FUJITA Tomonori wrote:
> > > On Thu, 04 Sep 2008 00:09:51 +0200
> > > Andi Kleen <andi@firstfloor.org> wrote:
> > > 
> > > > Joerg Roedel <joerg.roedel@amd.com> writes:
> > > > 
> > > > > The SWIOTLB version of dma_alloc_coherent allocates all memory with
> > > > > GFP_DMA unconditionally. This leads sometimes unnecessary to allocation
> > > > > failures. This patch makes the allocation strategy to use the DMA32 zone
> > > > > first if this is possible. The changes are boot tested on AMD64 and
> > > > > compile tested for i386 and IA64.
> > > > 
> > > > The high level dma_alloc_coherent() does that anyways.
> > > 
> > > The high level dma_alloc_coherent means the tricks in
> > > arch/x86/pci-dma.c? If so, all the tricks has gone in tip/master.
> > 
> > Seems wrong -- that is something that is needed by multiple
> > IOMMUs. Pretty much all which work with real memory instead
> > of virtual mappings.
> 
> Not all the IOMMUs need the old tricks used in arch/x86/pci-dma.c.

That is what I meant with "with real memory"

But actually even for real IOMMus it can make sense to maintain
some memory for bypass.

Also there's usually the problem that not all busses are translated,
e.g. Calgary used to do that so for e.g. dev == NULL allocations you had
to use  these fallback algorithms anyways.

Clearly copying the fallback logic into lots of low level IOMMUs instead
of having it in one place is a big step backwards.

-Andi

-- 
ak@linux.intel.com
