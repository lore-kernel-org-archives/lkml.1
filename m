Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYHRBVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYHRBVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYHRBVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:21:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:49861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYHRBVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:21:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,224,1217833200"; 
   d="scan'208";a="326913880"
From: "Li, Shaohua" <shaohua.li@intel.com>
To: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>, "airlied@linux.ie" <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 18 Aug 2008 09:21:12 +0800
Subject: RE: [patch 2/2] reduce tlb/cache flush times of agpgart memory
 allocation
Thread-Topic: [patch 2/2] reduce tlb/cache flush times of agpgart memory
 allocation
Thread-Index: Acj+5OWuDDVSsFViRDG2fZI6UWnMLQB6wT+g
Message-ID: <76780B19A496DC4B80439008DAD7076C0CF9E0E1@PDSMSX501.ccr.corp.intel.com>
References: <1217832690.21811.9.camel@sli10-desk.sh.intel.com>
	<20080815143131.GF12954@elte.hu> <20080815074033.4817f876@infradead.org>
In-Reply-To: <20080815074033.4817f876@infradead.org>
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



>-----Original Message-----
>From: Arjan van de Ven [mailto:arjan@infradead.org]
>Sent: Friday, August 15, 2008 10:41 PM
>To: Ingo Molnar
>Cc: Li, Shaohua; lkml; airlied@linux.ie; Andrew Morton; Ingo Molnar; Siddha,
>Suresh B; Pallipadi, Venkatesh; Thomas Gleixner; H. Peter Anvin
>Subject: Re: [patch 2/2] reduce tlb/cache flush times of agpgart memory
>allocation
>
>On Fri, 15 Aug 2008 16:31:31 +0200
>Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Shaohua Li <shaohua.li@intel.com> wrote:
>>
>> > To reduce tlb/cache flush, makes agp memory allocation do one flush
>> > after all pages in a region are changed to uc.
>> >
>> > All agp drivers except agp-sgi uses agp_generic_alloc_page() for
>> > .agp_alloc_page, so the patch should work for them. agp-sgi is only
>> > for ia64, so not a problem too.
>>
>> applied to tip/x86/pat - thanks!
>>
>> I've Cc:-ed more PAT folks - any objections?
>>
>
>it really needs something else instead; it needs airlied's array
>allocator
>otherwise you hit the second wall as well (the pat checks per page)
Somebody should have a measurement. In my test, the real bottleneck is the cache flush. It appears flush cache page is slow if there are a lot of pages, In my patch, I use a wbinvd. This can be optimized to do wbinvd with a threshold. Maybe airlied can change his patch with this way.

Thanks,
Shaohua
