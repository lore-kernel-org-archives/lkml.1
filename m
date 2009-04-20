Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZDTR1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZDTR1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 13:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZDTR11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 13:27:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:22470 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZDTR11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 13:27:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,218,1239001200"; 
   d="scan'208";a="449581091"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>
CC: "'Ingo Molnar'" <mingo@elte.hu>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "Han, Weidong" <weidong.han@intel.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'IOMMU'" <iommu@lists.linux-foundation.org>
Date: Mon, 20 Apr 2009 10:27:24 -0700
Subject: RE: [PATCH] Intel IOMMU Pass Through Support
Thread-Topic: [PATCH] Intel IOMMU Pass Through Support
Thread-Index: AcnA1laT4am+5hpUTROkP4ZkJWZ9jgBBXsRA
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
References: <20090327212241.234500000@intel.com> >
	 <20090327212321.070229000@intel.com>
	 <20090416001957.GA1527@linux-os.sc.intel.com>
 <1240135508.3589.75.camel@macbook.infradead.org>
In-Reply-To: <1240135508.3589.75.camel@macbook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Wed, 2009-04-15 at 17:19 -0700, Fenghua Yu wrote:
>> +       if (iommu_pass_through)
>> +               if (!pass_through) {
>> +                       printk(KERN_INFO
>> +                               "Pass Through is not supported by
>hardware.\n");
>> +                       iommu_pass_through = 0;
>> +               }
>
>So if we ask for pass-through and the hardware doesn't support it, we
>end up in full-translation mode? Wouldn't it be better to set up 1:1
>mappings for each device instead?
>
>(We probably want to fix up the code which sets up 1:1 mappings to
>actually share page tables where appropriate, and to use superpages).
>
>Also, did we already have a discussion about whether this should be an
>intel_iommu= parameter, or a generic iommu= one?

For this patch, I would just fall back to "normal" translation if without hardware pass-through support.

I'm doing 1:1 mapping now to speed up mapping and unmapping. When the 1:1 mapping is implemented, the fall back from pass-through will go to 1:1 mapping which will be "normal" translation.

BTW, I think most of (or newer) VT-d hardware supports pass through feature now. So it won't fail anyway if pass through is wanted.

So at this point, this should be fine.

>
>>                 ret = domain_context_mapping_one(domain,
>> -                                                pci_domain_nr(parent-
>>bus),
>> -                                                parent->bus->number,
>> -                                                parent->devfn);
>> +                                               pci_domain_nr(parent-
>>bus),
>> +                                               parent->bus->number,
>> +                                               parent->devfn,
>translation);
>
>Whitespace damage here -- you're modifying continuation lines which used
>to be right underneath the 'domain' parameter, and you're making them
>not line up properly.
>
>You have the same problem elsewhere for newly-added code too, in fact:
>
>> +               ret = domain_context_mapping(domain, pdev,
>> +                                               CONTEXT_TT_PASS_THROUGH);
>

OK. I'll change this to align to the upper parameter.

Thanks.

-Fenghuas
