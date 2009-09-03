Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZICVk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZICVk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZICVk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:40:58 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:53401 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172AbZICVk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:40:58 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Thu, 3 Sep 2009 14:41:00 -0700
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8; KDE/4.3.0; x86_64; ; )
Cc: James Bottomley <James.Bottomley@suse.de>,
       Alok Kataria <akataria@vmware.com>, Matthew Wilcox <matthew@wil.cx>,
       Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>,
       Robert Love <robert.w.love@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Maxime Austruy <maustruy@vmware.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <200909031331.03037.dtor@vmware.com> <4AA03370.4080905@gmail.com>
In-Reply-To: <4AA03370.4080905@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909031441.00406.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009 02:21:52 pm Ric Wheeler wrote:
> On 09/03/2009 04:31 PM, Dmitry Torokhov wrote:
> > On Thursday 03 September 2009 01:03:02 pm James Bottomley wrote:
> >    
> >>>> I'm not really asking you to standardise anything (yet).  I was more
> >>>> probing for why you hadn't included any of the SCSI control plane
> >>>> interfaces and what lead you do produce a different design from the
> >>>> current patterns in virtual I/O.  I think what I'm hearing is "Because
> >>>> we didn't look at how modern SCSI drivers are constructed" and "Because
> >>>> we didn't look at how virtual I/O is currently done in Linux".  That's
> >>>> OK (it's depressingly familiar in drivers),
> >>>>          
> >>> I am sorry that's not the case, the reason we have different design as I
> >>> have mentioned above is because we want a generic mechanism which works
> >>> for all/most of the GOS's out their and doesn't need to be specific to
> >>> Linux.
> >>>        
> >> Slightly confused now ... you're saying you did look at the transport
> >> class and virtio?  But you chose not to do a virtio like interface (for
> >> reasons which I'm still not clear on) ...
> >>      
> > Virtio is Linux-specific and is not available on older kernels which
> > our hypervisor/PVSCSI combination does support. Even if we were to use
> > virtio-like schema in the hypervisor code we would have to re-implement
> > much of the virtio code for kernels earlier than those shipped in '07
> > and do the same for other operating systems for no apparent benefit.
> > The PCI device abstraction is self-contained and works well on Windows,
> > Linux and other guest operating systems and so it was chosen.
> >
> >    
> 
> Several arguments have a history of never winning when you try to get a 
> new bit of code in linux.
> 
> Number one in the bad justifications is that your design is good because 
> it avoids being "linux specific" closely followed by needing to backport :-)

That is true when you talking about implementing particular kernel features.
Here however our discussion shifted into the realm of how and why we
implemented the back-end the way we did and in this particular case argument
of being OS- and kernel-agnostic is a valid one.

The device is being presented to the guest operating system as a PCI device
with particular functionality and is being handled as an ordinary device
implemented in silicon. You may argue whether it was the optimal solution or
whether there are better ways to do the same but the device is in the wild
and is to stay.

-- 
Dmitry
