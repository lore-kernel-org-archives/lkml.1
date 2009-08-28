Return-Path: <linux-kernel-owner+w=401wt.eu-S1751199AbZH1VSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbZH1VSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZH1VSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:18:48 -0400
Received: from emulex.emulex.com ([138.239.112.1]:42258 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZH1VSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:18:48 -0400
From: Chetan.Loke@Emulex.Com
To: <akataria@vmware.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <dtor@vmware.com>, <James.Bottomley@HansenPartnership.com>,
       <robert.w.love@intel.com>, <randy.dunlap@oracle.com>,
       <michaelc@cs.wisc.edu>
Date: Fri, 28 Aug 2009 14:18:29 -0700
Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA.
Thread-Topic: [PATCH] SCSI driver for VMware's virtual HBA.
Thread-Index: AconbL8RjLdvUsy+RH2ladF9YMEUvwAtwWHw
Message-ID: <412A05BA40734D4887DBC67661F433080FF71D16@EXMAIL.ad.emulex.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
In-Reply-To: <1251415060.16297.58.camel@ank32.eng.vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Aug 2009 21:18:31.0422 (UTC) FILETIME=[17F391E0:01CA2825]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok,


> +static int __devinit pvscsi_allocate_rings(struct pvscsi_adapter
> *adapter)
> +{
> +	adapter->rings_state = pci_alloc_consistent(adapter->dev, PAGE_SIZE,
> +						    &adapter->ringStatePA);
> +	if (!adapter->rings_state)
> +		return -ENOMEM;
> +
> +	adapter->req_pages = min(PVSCSI_MAX_NUM_PAGES_REQ_RING,
> +				 pvscsi_ring_pages);
> +	adapter->req_depth = adapter->req_pages
> +					* PVSCSI_MAX_NUM_REQ_ENTRIES_PER_PAGE;
> +	adapter->req_ring = pci_alloc_consistent(adapter->dev,
> +						 adapter->req_pages * PAGE_SIZE,
> +						 &adapter->reqRingPA);
> +	if (!adapter->req_ring)
> +		return -ENOMEM;
> +
> +	adapter->cmp_pages = min(PVSCSI_MAX_NUM_PAGES_CMP_RING,
> +				 pvscsi_ring_pages);
> +	adapter->cmp_ring = pci_alloc_consistent(adapter->dev,
> +						 adapter->cmp_pages * PAGE_SIZE,
> +						 &adapter->cmpRingPA);
> +	if (!adapter->cmp_ring)
> +		return -ENOMEM;
> +
> +	BUG_ON(adapter->ringStatePA & ~PAGE_MASK);
> +	BUG_ON(adapter->reqRingPA   & ~PAGE_MASK);
> +	BUG_ON(adapter->cmpRingPA   & ~PAGE_MASK);
> +
> +	if (!adapter->use_msg)
> +		return 0;
> +
> +	adapter->msg_pages = min(PVSCSI_MAX_NUM_PAGES_MSG_RING,
> +				 pvscsi_msg_ring_pages);
> +	adapter->msg_ring = pci_alloc_consistent(adapter->dev,
> +						 adapter->msg_pages * PAGE_SIZE,
> +						 &adapter->msgRingPA);
> +	if (!adapter->msg_ring)
> +		return -ENOMEM;
> +	BUG_ON(adapter->msgRingPA & ~PAGE_MASK);
> +
> +	return 0;
> +}
> +

I understand the emulation etc. But I see that this function isn't allocating multiple rings right? Didn't see any performance benefits?



Chetan




