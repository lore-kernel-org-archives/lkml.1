Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbYI3To5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbYI3To5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYI3Toq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:44:46 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:55837 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYI3Top (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:44:45 -0400
Date: Tue, 30 Sep 2008 22:44:01 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       amit.shah@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, mingo@redhat.com
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080930194401.GC20341@il.ibm.com>
References: <20080928191333.GC26563@8bytes.org> <20080929093044.GB6931@il.ibm.com> <20080929093652.GQ27426@8bytes.org> <20080929221640X.fujita.tomonori@lab.ntt.co.jp> <20080929133311.GK27928@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929133311.GK27928@amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 03:33:11PM +0200, Joerg Roedel wrote:

> > Nobody cares about the performance of dma_alloc_coherent. Only the
> > performance of map_single/map_sg matters.
> >
> > I'm not sure how expensive the hypercalls are, but they are more
> > expensive than bounce buffering coping lots of data for every
> > I/Os?
> 
> I don't think that we can avoid bounce buffering into the guests at
> all (with and without my idea of a paravirtualized IOMMU) when we
> want to handle dma_masks and requests that cross guest physical
> pages properly.

It might be possible to have a per-device slow or fast path, where the
fast path is for devices which have no DMA limitations (high-end
devices generally don't) and the slow path is for devices which do.

> With mapping/unmapping through hypercalls we add the world-switch
> overhead to the copy-overhead. We can't avoid this when we have no
> hardware support at all. But already with older IOMMUs like Calgary
> and GART we can at least avoid the world-switch. And since, for
> example, every 64 bit capable AMD processor has a GART we can make
> use of it.

It should be possible to reduce the number and overhead of hypercalls
to the point where their cost is immaterial. I think that's
fundamentally a better approach.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                      xxx
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
