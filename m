Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbZFRSxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbZFRSxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZFRSxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:53:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54062 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZFRSxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:53:05 -0400
Date: Thu, 18 Jun 2009 11:51:15 -0700
From: Chris Wright <chrisw@redhat.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Chris Wright <chrisw@redhat.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>, "Kay, Allen M" <allen.m.kay@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 1/2] IOMMU Identity Mapping Support:
	iommu_identity_mapping definition
Message-ID: <20090618185115.GC2500@x200.localdomain>
References: <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090513231351.GA22386@linux-os.sc.intel.com> <1242314271.3393.11.camel@macbook.infradead.org> <20090514175944.GA5168@linux-os.sc.intel.com> <20090618180514.GA24082@linux-os.sc.intel.com> <20090618180835.GB6838@il.ibm.com> <A6AD88C3F2289247BE726C37303E1EB8B0044EC0@orsmsx505.amr.corp.intel.com> <20090618182545.GC6838@il.ibm.com> <20090618183121.GB2500@x200.localdomain> <20090618184101.GE6838@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618184101.GE6838@il.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Muli Ben-Yehuda (muli@il.ibm.com) wrote:
> On Thu, Jun 18, 2009 at 11:31:21AM -0700, Chris Wright wrote:
> 
> > The 1-1 mapping is for all the host devices _not_ assigned to
> > guests.  To eliminate the i/o overhead imposed on all guests not
> > using an assigned device or from i/o from host.
> >
> > It's just the same as VT-d PassThrough mode for hardware that
> > doesn't support it.
> 
> Ok, that makes sense. Thanks, Chris. However, that doesn't appear to
> be what the patch does---unless I'm misreading, if
> iommu_identity_mapping is set, *all* devices get identity

Correct (and same as pt mode).  Of course, a subsequent device assignement
will set that mapping to gpa<->hpa, so you'll get proper isolation for
the assigned device.  Essentially it's saying the only reason you cared
about the IOMMU was for device assignment.

> mapping. Instead of a global command line option, we need to provide a
> way to enable/disable pt or identity mapping (I agree that the user
> shouldn't know or care which is used, the kernel should pick the best
> one automatically) on a per BDF basis.

Yeah, that's a possible enhancement.  Although once you've disabled one
device's isolation you've created a hole...

thanks,
-chris
