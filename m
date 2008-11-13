Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYKMSrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYKMSrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYKMSrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:47:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:32972 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbYKMSrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:47:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,598,1220252400"; 
   d="scan'208";a="359787795"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Nick Piggin <npiggin@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Hugh Dickins <hugh@veritas.com>,
       Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Thu, 13 Nov 2008 10:47:23 -0800
Subject: RE: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Thread-Topic: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Thread-Index: AclFQiYG5cf/cXm0TS+d5dwJCCI4dgAfckUA
Message-ID: <7E82351C108FA840AB1866AC776AEC4642775AF2@orsmsx505.amr.corp.intel.com>
References: <20081112212647.259698000@intel.com>
 <20081112212900.151113000@intel.com> <20081112232312.GB29363@wotan.suse.de>
 <7E82351C108FA840AB1866AC776AEC46426F30E5@orsmsx505.amr.corp.intel.com>
 <20081113034425.GA23434@wotan.suse.de>
In-Reply-To: <20081113034425.GA23434@wotan.suse.de>
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
>From: Nick Piggin [mailto:npiggin@suse.de] 
>Sent: Wednesday, November 12, 2008 7:44 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Hugh Dickins; 
>Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; Arjan van de 
>Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
>
>On Wed, Nov 12, 2008 at 04:02:47PM -0800, Pallipadi, Venkatesh wrote:
>>
>>
>> >-----Original Message-----
>> >From: Nick Piggin [mailto:npiggin@suse.de]
>> >Sent: Wednesday, November 12, 2008 3:23 PM
>> >To: Pallipadi, Venkatesh
>> >Cc: Ingo Molnar; Thomas Gleixner; H.Peter Anvin; Hugh Dickins;
>> >Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; Arjan van de
>> >Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
>> >Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in 
>vm_insert_pfn
>> >
>> >You have to be careful of this, because it can be called 
>with mmap_sem
>> >held for read only. Hmm, I guess vm_insert_page is doing the
>> >same thing.
>> >Probably mostly works because all other modifiers of vm_flags
>> >are holding
>> >mmap_sem.
>>
>> Yes. I did the patch looking at vm_insert_page doing similar thing.
>>
>> >
>> >However, in some cases, code can do vm_insert_pfn and vm_insert_page
>> >(actually hmm, no vm_insert_mixed actually should cover 
>most of those
>> >cases).
>> >
>> >Still, I'd be much happier if we could make these into 
>BUG_ON, and then
>> >teach callers to set it in their .mmap routines.
>>
>> Actually, vm_insert_pfn() already has a BUG_ON() at the 
>start for cases
>> where neither (or both) MIXEDMAP and PFNMAP is not set. So, 
>that should
>> cover the case we are worried about it here and we can eliminate this
>> patch altogether. Only part I am not sure about is why we are looking
>> for MIXEDMAP here. Shouldn't they be using vm_insert_mixed instead?
>
>They should, but it will do an inesrt_pfn in some cases, won't it?
>

Yes. It does. But, it calls a lower level insert_pfn() function. The lower
level insert_pfn() does not have any bug checks. But the higher level
vm_insert_pfn() checks for PFNMAP or MIXEDMAP.

Thanks,
Venki
