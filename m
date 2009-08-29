Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbZH2MFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbZH2MFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 08:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZH2MFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 08:05:20 -0400
Received: from emulex.emulex.com ([138.239.112.1]:63617 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZH2MFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 08:05:20 -0400
From: Chetan.Loke@Emulex.Com
To: <akataria@vmware.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <dtor@vmware.com>, <James.Bottomley@HansenPartnership.com>,
       <robert.w.love@intel.com>, <randy.dunlap@oracle.com>,
       <michaelc@cs.wisc.edu>
Date: Sat, 29 Aug 2009 05:04:58 -0700
Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA.
Thread-Topic: [PATCH] SCSI driver for VMware's virtual HBA.
Thread-Index: AcooLzZufbp7jZl4TveUr9IJZUvQ+QAbSWmw
Message-ID: <412A05BA40734D4887DBC67661F433080FF71D90@EXMAIL.ad.emulex.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <412A05BA40734D4887DBC67661F433080FF71D16@EXMAIL.ad.emulex.com>
 <1251498656.25584.7.camel@ank32.eng.vmware.com>
In-Reply-To: <1251498656.25584.7.camel@ank32.eng.vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Aug 2009 12:05:01.0493 (UTC) FILETIME=[EFB44E50:01CA28A0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alok Kataria [mailto:akataria@vmware.com]
> Sent: Friday, August 28, 2009 6:31 PM
> To: Loke,Chetan
> Cc: linux-kernel@vger.kernel.org; akpm@linux-foundation.org; Dmitry
> Torokhov; James.Bottomley@HansenPartnership.com; robert.w.love@intel.com;
> randy.dunlap@oracle.com; michaelc@cs.wisc.edu
> Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA.
> 
> Hi Chetan,

Hi

> 
> On Fri, 2009-08-28 at 14:18 -0700, Chetan.Loke@Emulex.Com wrote:
> > Alok,
> >
> >
> > > +static int __devinit pvscsi_allocate_rings(struct pvscsi_adapter
> > > *adapter)
> > > +{
> > > +	adapter->rings_state = pci_alloc_consistent(adapter->dev, PAGE_SIZE,
> > > +						    &adapter->ringStatePA);
> > > +	adapter->req_ring = pci_alloc_consistent(adapter->dev,
> > > +						 adapter->req_pages * PAGE_SIZE,
> > > +						 &adapter->reqRingPA);
> > > +	adapter->cmp_ring = pci_alloc_consistent(adapter->dev,
> > > +						 adapter->cmp_pages * PAGE_SIZE,
> > > +						 &adapter->cmpRingPA);


> >
> > I understand the emulation etc. But I see that this function isn't
> > allocating multiple rings right? Didn't see any performance benefits?
> >
> 
> The function is allocating multiple rings, actually 2 of them for the
> IO path, request and completion rings (req_ring, cmp_ring).
> 
> Let me know if you were asking something else.
> 

I was using 'Ring' loosely.
So, Ring == [req_path,cmpl_path]
Example - R0[req-path,cmpl-path]

But the code doesn't allocate R0,R1,...,RN.

Existing code - 

      --------
	Ring-0
	--------
	  Req 
	   +
	   |
 	   +
        Cmpl     


Why not multiple rings as shown below - 

      --------	--------
	Ring-0	Ring-M
	--------	--------
	  Req 	  Req
	   +		   +
	   |		   |
 	   +		   +
        Cmpl     	  Cmpl



Creating multiple rings @ the guest level buys nothing in terms of performance? This is also related to how the hypervisor will schedule the world-interrupts. If 'a' pv-driver has multiple interrupt lines enabled then will the interrupts/ISR's get routed on different PCPU's for a vmworld? Or is there a limitation?


Chetan

