Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0BELB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 06:01:58 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:37113 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0BELB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 06:01:56 -0500
X-SpamScore: -6
X-BigFish: VPS-6(z1857rz146fK1432R98dNzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXD7YX-02-3PH-02
X-M-MSG: 
Date: Fri, 5 Feb 2010 12:01:45 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Joerg Roedel <joro@8bytes.org>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large
 pages
Message-ID: <20100205110145.GZ16236@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
 <1264678682-30655-7-git-send-email-joerg.roedel@amd.com>
 <20100128222455.GA26274@amt.cnet>
 <20100129093233.GU17809@8bytes.org>
 <20100201141804.GD16236@amd.com>
 <20100201193017.GA27065@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100201193017.GA27065@amt.cnet>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Feb 2010 11:01:46.0122 (UTC) FILETIME=[9B94A6A0:01CAA652]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo, Avi,

On Mon, Feb 01, 2010 at 05:30:17PM -0200, Marcelo Tosatti wrote:
> On Mon, Feb 01, 2010 at 03:18:04PM +0100, Joerg Roedel wrote:
> > On Fri, Jan 29, 2010 at 10:32:33AM +0100, Joerg Roedel wrote:
> > > On Thu, Jan 28, 2010 at 08:24:55PM -0200, Marcelo Tosatti wrote:
> > > > On Thu, Jan 28, 2010 at 12:37:57PM +0100, Joerg Roedel wrote:
> > > > > +static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > > +			   gfn_t gfn, unsigned long size)
> > > > > +{
> > > > > +	gfn_t end_gfn;
> > > > > +	pfn_t pfn;
> > > > > +
> > > > > +	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
> > > > 
> > > > If gfn_to_pfn_memslot returns pfn of bad_page, you might create a
> > > > large iommu translation for it?
> > > 
> > > Right. But that was broken even before this patch. Anyway, I will fix
> > > it.
> > > 
> > > > > +		/* Map into IO address space */
> > > > > +		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
> > > > > +			      get_order(page_size), flags);
> > > > > +
> > > > > +		gfn += page_size >> PAGE_SHIFT;
> > > > 
> > > > Should increase gfn after checking for failure, otherwise wrong
> > > > npages is passed to kvm_iommu_put_pages.
> > > 
> > > True. Will fix that too.
> > 
> > Here is the updated patch (also updated in the iommu/largepage branch of
> > my tree). Does it look ok?
> 
> Yes, addresses the concern.

Are there any further objections against this patchset? If not it would
be cool if you could give me some acks for the kvm specific parts of
this patchset.

	Joerg


