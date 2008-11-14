Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYKNVkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYKNVkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbYKNVf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:35:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:9079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbYKNVfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:35:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,605,1220252400"; 
   d="scan'208";a="639301370"
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
Date: Fri, 14 Nov 2008 13:35:38 -0800
Subject: RE: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Thread-Topic: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Thread-Index: AclF/Ynx95pejh+XTCKOsjJxt8651QAoj8Bg
Message-ID: <7E82351C108FA840AB1866AC776AEC46427EC16C@orsmsx505.amr.corp.intel.com>
References: <20081112212647.259698000@intel.com>
 <20081112212900.151113000@intel.com> <20081112232312.GB29363@wotan.suse.de>
 <7E82351C108FA840AB1866AC776AEC46426F30E5@orsmsx505.amr.corp.intel.com>
 <20081113034425.GA23434@wotan.suse.de>
 <7E82351C108FA840AB1866AC776AEC4642775AF2@orsmsx505.amr.corp.intel.com>
 <20081114020547.GA24414@wotan.suse.de>
In-Reply-To: <20081114020547.GA24414@wotan.suse.de>
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
>Sent: Thursday, November 13, 2008 6:06 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Thomas Gleixner; H Peter Anvin; Hugh Dickins;
>Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; Arjan van de
>Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
>
>On Thu, Nov 13, 2008 at 10:47:23AM -0800, Pallipadi, Venkatesh wrote:
>>
>> Yes. It does. But, it calls a lower level insert_pfn()
>function. The lower
>> level insert_pfn() does not have any bug checks. But the higher level
>> vm_insert_pfn() checks for PFNMAP or MIXEDMAP.
>
>Yes, but is there anything extra you need to check for cache aliases in
>MIXEDMAP mappings?
>

Yes. We need additional things to track MIXEDMAP and we are looking at that.
But, that is slightly more trickier than the general PFNMAP case. And
only in-tree user of MIXEDMAP is xip and that too it only uses it for
regular WB mapping. So, we thought we should fix the more common case
first here.

With MIXEDMAP there is no way whether to distinguish whether insert_pfn
Or insert_page was used while looking at VMA. We can probably use PFNMAP
in addition to MIXEDMAP to indicate that, which will make things easier.
But, we are still looking at that and trying to understand the change
implication.

Thanks,
Venki
