Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYLAO1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYLAO1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYLAO13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:27:29 -0500
Received: from 8bytes.org ([88.198.83.132]:34542 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbYLAO12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:27:28 -0500
Date: Mon, 1 Dec 2008 15:27:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: muli@il.ibm.com, kvm@vger.kernel.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, avi@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081201142727.GL29705@8bytes.org>
References: <20081201173830B.fujita.tomonori@lab.ntt.co.jp> <20081201120026.GF17719@amd.com> <20081201130209.GA21615@il.ibm.com> <20081201231852P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201231852P.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 11:18:39PM +0900, FUJITA Tomonori wrote:
> On Mon, 1 Dec 2008 15:02:09 +0200
> Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> 
> > On Mon, Dec 01, 2008 at 01:00:26PM +0100, Joerg Roedel wrote:
> > 
> > > > > > The majority of the names (include/linux/iommu.h, iommu.c,
> > > > > > iommu_ops, etc) looks too generic? We already have lots of
> > > > > > similar things (e.g. arch/{x86,ia64}/asm/iommu.h, several
> > > > > > archs' iommu.c, etc). Such names are expected to be used by
> > > > > > all the IOMMUs.
> > > > > 
> > > > > The API is already useful for more than KVM. I also plan to
> > > > > extend it to support more types of IOMMUs than VT-d and AMD
> > > > > IOMMU in the future. But these changes are more intrusive than
> > > > > this patchset and need more discussion. I prefer to do small
> > > > > steps into this direction.
> > > > 
> > > > Can you be more specific? What IOMMU could use this? For example,
> > > > how GART can use this? I think that people expect the name 'struct
> > > > iommu_ops' to be an abstract for all the IOMMUs (or the majority
> > > > at least). If this works like that, the name is a good choice, I
> > > > think.
> > > 
> > > GART can't use exactly this. But with some extensions we can make it
> > > useful for GART and GART-like IOMMUs too. For example we can emulate
> > > domains in GART by partitioning the GART aperture space.
> > 
> > That would only work with a pvdma API, since GART doesn't support
> > multiple address spaces, and you don't get the isolation properties of
> > a real IOMMU, so... why would you want to do that?
> 
> If this works for only IOMMUs that support kinda domain concept, then
> I think that a name like iommu_domain_ops is more appropriate.

Hmm, is there any hardware IOMMU with which we can't emulate domains by
partitioning the IO address space? This concept works for GART and
Calgary.

Joerg

