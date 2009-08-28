Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbZH1Waz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbZH1Waz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbZH1Way
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:30:54 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:37686 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbZH1Wax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:30:53 -0400
Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@vmware.com>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "robert.w.love@intel.com" <robert.w.love@intel.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
In-Reply-To: <412A05BA40734D4887DBC67661F433080FF71D16@EXMAIL.ad.emulex.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <412A05BA40734D4887DBC67661F433080FF71D16@EXMAIL.ad.emulex.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 28 Aug 2009 15:30:56 -0700
Message-Id: <1251498656.25584.7.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chetan,

On Fri, 2009-08-28 at 14:18 -0700, Chetan.Loke@Emulex.Com wrote:
> Alok,
> 
> 
> > +static int __devinit pvscsi_allocate_rings(struct pvscsi_adapter
> > *adapter)
> > +{
> > +	adapter->rings_state = pci_alloc_consistent(adapter->dev, PAGE_SIZE,
> > +						    &adapter->ringStatePA);
> > +	if (!adapter->rings_state)
> > +		return -ENOMEM;
> > +
> > +	adapter->req_pages = min(PVSCSI_MAX_NUM_PAGES_REQ_RING,
> > +				 pvscsi_ring_pages);
> > +	adapter->req_depth = adapter->req_pages
> > +					* PVSCSI_MAX_NUM_REQ_ENTRIES_PER_PAGE;
> > +	adapter->req_ring = pci_alloc_consistent(adapter->dev,
> > +						 adapter->req_pages * PAGE_SIZE,
> > +						 &adapter->reqRingPA);
> > +	if (!adapter->req_ring)
> > +		return -ENOMEM;
> > +
> > +	adapter->cmp_pages = min(PVSCSI_MAX_NUM_PAGES_CMP_RING,
> > +				 pvscsi_ring_pages);
> > +	adapter->cmp_ring = pci_alloc_consistent(adapter->dev,
> > +						 adapter->cmp_pages * PAGE_SIZE,
> > +						 &adapter->cmpRingPA);
> > +	if (!adapter->cmp_ring)
> > +		return -ENOMEM;
> > +
> > +	BUG_ON(adapter->ringStatePA & ~PAGE_MASK);
> > +	BUG_ON(adapter->reqRingPA   & ~PAGE_MASK);
> > +	BUG_ON(adapter->cmpRingPA   & ~PAGE_MASK);
> > +
> > +	if (!adapter->use_msg)
> > +		return 0;
> > +
> > +	adapter->msg_pages = min(PVSCSI_MAX_NUM_PAGES_MSG_RING,
> > +				 pvscsi_msg_ring_pages);
> > +	adapter->msg_ring = pci_alloc_consistent(adapter->dev,
> > +						 adapter->msg_pages * PAGE_SIZE,
> > +						 &adapter->msgRingPA);
> > +	if (!adapter->msg_ring)
> > +		return -ENOMEM;
> > +	BUG_ON(adapter->msgRingPA & ~PAGE_MASK);
> > +
> > +	return 0;
> > +}
> > +
> 
> I understand the emulation etc. But I see that this function isn't
> allocating multiple rings right? Didn't see any performance benefits?
> 

The function is allocating multiple rings, actually 2 of them for the
IO path, request and completion rings (req_ring, cmp_ring). 

Let me know if you were asking something else.

Thanks,
Alok

> 
> 
> Chetan
> 
> 
> 
> 

