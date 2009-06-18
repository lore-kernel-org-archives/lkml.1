Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZFRSdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZFRSdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZFRSdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:33:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45055 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbZFRSdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:33:00 -0400
Date: Thu, 18 Jun 2009 11:31:21 -0700
From: Chris Wright <chrisw@redhat.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Message-ID: <20090618183121.GB2500@x200.localdomain>
References: <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090513231351.GA22386@linux-os.sc.intel.com> <1242314271.3393.11.camel@macbook.infradead.org> <20090514175944.GA5168@linux-os.sc.intel.com> <20090618180514.GA24082@linux-os.sc.intel.com> <20090618180835.GB6838@il.ibm.com> <A6AD88C3F2289247BE726C37303E1EB8B0044EC0@orsmsx505.amr.corp.intel.com> <20090618182545.GC6838@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618182545.GC6838@il.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Muli Ben-Yehuda (muli@il.ibm.com) wrote:
> On Thu, Jun 18, 2009 at 11:14:51AM -0700, Yu, Fenghua wrote:
> > >
> > >On Thu, Jun 18, 2009 at 11:05:14AM -0700, Fenghua Yu wrote:
> > >
> > >> IOMMU Identity Mapping Support: iommu_identity_mapping definition
> > >>
> > >> Identity mapping for IOMMU defines a single domain to 1:1 map all
> > >> pci devices to all usable memory.
> > >
> > >Why use VT-d at all in this case? Do you have a use-case in mind?
> > 
> > Some users want to use VT-d in KVM but are concerned of DMA
> > remapping performance. They can use identity mapping and still have
> > KVM on VT-d. They can also use pass through patch (sent out before)
> > if hardware supports pass through.
> 
> Sorry, I must be missing something. For the normal device assignment
> case, we want the IOMMU page tables to have gpa->hpa mappings rather
> than the 1-1 identity mapping. How do you envision the 1-1 mapping
> being used in the device assignment case?

The 1-1 mapping is for all the host devices _not_ assigned to guests.
To eliminate the i/o overhead imposed on all guests not using an
assigned device or from i/o from host.

It's just the same as VT-d PassThrough mode for hardware that doesn't
support it.

thanks,
-chris
