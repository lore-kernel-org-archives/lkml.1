Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYI2Jcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYI2Jcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYI2JcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:32:22 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:36308 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYI2JcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:32:21 -0400
Date: Mon, 29 Sep 2008 12:30:44 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Amit Shah <amit.shah@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080929093044.GB6931@il.ibm.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <200809261326.19261.amit.shah@redhat.com> <20080926085924.GC27928@amd.com> <200809261619.51637.amit.shah@redhat.com> <20080926123243.GE27928@amd.com> <20080927001321.GI9118@il.ibm.com> <20080928191333.GC26563@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928191333.GC26563@8bytes.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 09:13:33PM +0200, Joerg Roedel wrote:

> I think we should try to build a paravirtualized IOMMU for KVM
> guests.  It should work this way: We reserve a configurable amount
> of contiguous guest physical memory and map it dma contiguous using
> some kind of hardware IOMMU. This is possible with all hardare
> IOMMUs we have in the field by now, also Calgary and GART. The guest
> does dma_coherent allocations from this memory directly and is done.
> For map_single and map_sg 
> the guest can do bounce buffering. We avoid nearly all pvdma hypercalls
> with this approach, keep guest swapping working and solve also the
> problems with device dma_masks and guest memory that is not contigous on
> the host side.

I'm not sure I follow, but if I understand correctly with this
approach the guest could only DMA into buffers that fall within the
range you allocated for DMA and mapped. Isn't that a pretty nasty
limitation?  The guest would need to bounce-bufer every frame that
happened to not fall inside that range, with the resulting loss of
performance.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                      xxx
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
