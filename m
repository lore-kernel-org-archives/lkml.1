Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZIIWtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZIIWtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 18:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZIIWtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 18:49:16 -0400
Received: from emulex.emulex.com ([138.239.112.1]:52337 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZIIWtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 18:49:15 -0400
From: Chetan.Loke@Emulex.Com
To: <akataria@vmware.com>
CC: <brking@linux.vnet.ibm.com>, <James.Bottomley@suse.de>,
       <eike-kernel@sf-tec.de>, <matthew@wil.cx>, <rdreier@cisco.com>,
       <bvanassche@acm.org>, <robert.w.love@intel.com>,
       <randy.dunlap@oracle.com>, <michaelc@cs.wisc.edu>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <pv-drivers@vmware.com>
Date: Wed, 9 Sep 2009 15:48:38 -0700
Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA - V3.
Thread-Topic: [PATCH] SCSI driver for VMware's virtual HBA - V3.
Thread-Index: Acow6fLRT41oDWMjT+e69A7rLm4InwAsy7Kw
Message-ID: <412A05BA40734D4887DBC67661F433080FF72C2B@EXMAIL.ad.emulex.com>
References: <1252006675.18725.20.camel@ank32.eng.vmware.com>
	 <4AA03A9F.2040500@linux.vnet.ibm.com>
	 <412A05BA40734D4887DBC67661F433080FF72585@EXMAIL.ad.emulex.com>
 <1252458467.24914.66.camel@ank32.eng.vmware.com>
In-Reply-To: <1252458467.24914.66.camel@ank32.eng.vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Sep 2009 22:48:39.0864 (UTC) FILETIME=[AC975380:01CA319F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alok Kataria [mailto:akataria@vmware.com]
> Sent: Tuesday, September 08, 2009 9:08 PM
> To: Loke,Chetan
> Cc: brking@linux.vnet.ibm.com; James.Bottomley@suse.de; eike-kernel@sf-
> tec.de; matthew@wil.cx; rdreier@cisco.com; bvanassche@acm.org;
> robert.w.love@intel.com; randy.dunlap@oracle.com; michaelc@cs.wisc.edu;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; akpm@linux-
> foundation.org; pv-drivers@vmware.com
> Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA - V3.
> 
> Hi Chetan,
> 
> > Alok,
> >
> > (This is just a optimization.You don't need it in order to get your
> > code merged upstream.You can always patch it later on)In fact hw_lock
> > should be split into two locks -
> >
> > req_path_lock(aka tx_lock) and
> > cmpl_path_lock(aka rx_lock).
> >
> > You can then have a full-duplex channel.
> >
> > Revised-code -
> > 	::pvscsi_acquire_context->spin_lock_irqsave(tx_lock)
> > 	::pvscsi_isr->spin_lock_irqsave(rx_lock)
> > 	::some_future_napi_style_pvrx_poll_func->spin_lock_irqsave(rx_lock)
> >
> > 	::for aborts synchronize on the rx_lock so that you know what's
> > completed and what's not.
> >
> 



> I agree about the optimization. Though IMO this will be more attractive
> once we have a device which supports multiple queue pairs.

lpfc driver has native multi-ring support. It won't create hundred's of ring-pairs but the stuff that's present is good enough to start with(at least for this generation).


> Anyways, let me keep this on my plate, I will check how much of an
> benefit this gets us and will decide if this should be done, but as you
> suggested this is for later.
> 

I keep forgetting that this is a pv-driver.So, to reap the benefits of the multi-ring arch, the plumbing should be present in your hypervisor/kernel and NOT in the guest-world.


> Thanks for taking a look.
No worries.


> 
> --Alok


Chetan
