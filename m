Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869Ab0A2Jcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0A2Jcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884Ab0A2Jcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:32:36 -0500
Received: from 8bytes.org ([88.198.83.132]:49606 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab0A2Jce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:32:34 -0500
Date: Fri, 29 Jan 2010 10:32:33 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large
	pages
Message-ID: <20100129093233.GU17809@8bytes.org>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-7-git-send-email-joerg.roedel@amd.com> <20100128222455.GA26274@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128222455.GA26274@amt.cnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 08:24:55PM -0200, Marcelo Tosatti wrote:
> On Thu, Jan 28, 2010 at 12:37:57PM +0100, Joerg Roedel wrote:
> > +static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +			   gfn_t gfn, unsigned long size)
> > +{
> > +	gfn_t end_gfn;
> > +	pfn_t pfn;
> > +
> > +	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
> 
> If gfn_to_pfn_memslot returns pfn of bad_page, you might create a
> large iommu translation for it?

Right. But that was broken even before this patch. Anyway, I will fix
it.

> > +		/* Map into IO address space */
> > +		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
> > +			      get_order(page_size), flags);
> > +
> > +		gfn += page_size >> PAGE_SHIFT;
> 
> Should increase gfn after checking for failure, otherwise wrong
> npages is passed to kvm_iommu_put_pages.

True. Will fix that too.

Thanks,

	Joerg
