Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0BATb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:31:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab0BATb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:31:58 -0500
Date: Mon, 1 Feb 2010 17:30:17 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Joerg Roedel <joro@8bytes.org>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large pages
Message-ID: <20100201193017.GA27065@amt.cnet>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
 <1264678682-30655-7-git-send-email-joerg.roedel@amd.com>
 <20100128222455.GA26274@amt.cnet>
 <20100129093233.GU17809@8bytes.org>
 <20100201141804.GD16236@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201141804.GD16236@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 03:18:04PM +0100, Joerg Roedel wrote:
> On Fri, Jan 29, 2010 at 10:32:33AM +0100, Joerg Roedel wrote:
> > On Thu, Jan 28, 2010 at 08:24:55PM -0200, Marcelo Tosatti wrote:
> > > On Thu, Jan 28, 2010 at 12:37:57PM +0100, Joerg Roedel wrote:
> > > > +static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > +			   gfn_t gfn, unsigned long size)
> > > > +{
> > > > +	gfn_t end_gfn;
> > > > +	pfn_t pfn;
> > > > +
> > > > +	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
> > > 
> > > If gfn_to_pfn_memslot returns pfn of bad_page, you might create a
> > > large iommu translation for it?
> > 
> > Right. But that was broken even before this patch. Anyway, I will fix
> > it.
> > 
> > > > +		/* Map into IO address space */
> > > > +		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
> > > > +			      get_order(page_size), flags);
> > > > +
> > > > +		gfn += page_size >> PAGE_SHIFT;
> > > 
> > > Should increase gfn after checking for failure, otherwise wrong
> > > npages is passed to kvm_iommu_put_pages.
> > 
> > True. Will fix that too.
> 
> Here is the updated patch (also updated in the iommu/largepage branch of
> my tree). Does it look ok?

Yes, addresses the concern.

