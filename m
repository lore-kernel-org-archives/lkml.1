Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZBBRP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZBBRP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZBBRPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:15:20 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:55793 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbZBBRPS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:15:18 -0500
From: Bhavesh Davda <bhavesh@vmware.com>
To: "kyle@infradead.org" <kyle@infradead.org>
CC: "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 2 Feb 2009 09:15:15 -0800
Subject: RE: [PATCH] intel-iommu: intel_iommu_domain_alloc should check
	'dmar_disabled'
Thread-Topic: [PATCH] intel-iommu: intel_iommu_domain_alloc should check
	'dmar_disabled'
Thread-Index: AcmDXq2yqQAnHW71QqiQMvoTe2JeWQB+ABww
Message-ID: <AF9CD7A487028E428749836D21102612201D46C5F2@PA-EXMBX02.vmware.com>
References: <AF9CD7A487028E428749836D21102612201D323DBB@PA-EXMBX02.vmware.com>
 <20090131044454.GA5184@bombadil.infradead.org>
In-Reply-To: <20090131044454.GA5184@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least with 2.6.28, you could trigger the Oops as follows:

1. Boot with intel_iommu=off
2. Call the exported symbol intel_iommu_domain_alloc() from a module which knows nothing about the fact that dmar_disabled is true

Looks like intel_iommu_domain_alloc is not exported any more at git head, and I see a bunch of commits to git head from Joerg Roedel on Jan 3, 2009, that happened sometime between 2.6.28 and 2.6.29-rc1, so I guess we're good.

Thanks

- Bhavesh
 
Bhavesh P. Davda

> -----Original Message-----
> From: Kyle McMartin [mailto:kyle@infradead.org] On Behalf Of Kyle
> McMartin
> Sent: Friday, January 30, 2009 8:45 PM
> To: Bhavesh Davda
> Cc: David.Woodhouse@intel.com; mingo@elte.hu; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] intel-iommu: intel_iommu_domain_alloc should check
> 'dmar_disabled'
> 
> On Fri, Jan 16, 2009 at 03:54:12PM -0800, Bhavesh Davda wrote:
> >
> > intel_iommu_domain_alloc() will try and iommu_alloc_domain(iommu),
> > which calls alloc_domain_mem() to allocate out of
> 'iommu_domain_cache'.
> > Unfortunately iommu_domain_cache will not be created if booted with
> > "intel_iommu=off", i.e. dmar_disabled = 1.
> >
> 
> Hi Bhavesh,
> 
> What's the callchain that can result in intel_iommu_domain_alloc
> being called? It looks like most possible callsites are checking
> intel_iommu_found, which will be 0 since we check dmar_disabled before
> calling init_dmars to enumerate the iommus.
> 
> (I'm looking at 2.6.28.y right now, is there an interim between when
> you
>  stumbled upon this two weeks ago and git head where it's no longer an
>  issue? I guess it probably got missed due to folks travelling for
> LCA.)
> 
> regards, Kyle
