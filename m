Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYLPUHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYLPUHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYLPUHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:07:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:60579 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbYLPUHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:07:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,232,1228118400"; 
   d="scan'208";a="650309357"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>, "npiggin@suse.de" <npiggin@suse.de>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "jeremy@goop.org" <jeremy@goop.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Tue, 16 Dec 2008 12:07:56 -0800
Subject: RE: [patch 4/8] x86 PAT: hooks in generic vm code to help archs to
 track pfnmap regions
Thread-Topic: [patch 4/8] x86 PAT: hooks in generic vm code to help archs to
 track pfnmap regions
Thread-Index: AclfuJO0z8uZvHYBTHys1/+9IfuSAwAAPPGg
Message-ID: <7E82351C108FA840AB1866AC776AEC46433D1762@orsmsx505.amr.corp.intel.com>
References: <20081112212647.259698000@intel.com>
	<20081112212900.436502000@intel.com>
 <20081216115717.9f7082c7.akpm@linux-foundation.org>
In-Reply-To: <20081216115717.9f7082c7.akpm@linux-foundation.org>
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
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>Sent: Tuesday, December 16, 2008 11:57 AM
>To: Pallipadi, Venkatesh
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; 
>npiggin@suse.de; hugh@veritas.com; rdreier@cisco.com; 
>jbarnes@virtuousgeek.org; jeremy@goop.org; 
>arjan@infradead.org; linux-kernel@vger.kernel.org; Pallipadi, 
>Venkatesh; Siddha, Suresh B
>Subject: Re: [patch 4/8] x86 PAT: hooks in generic vm code to 
>help archs to track pfnmap regions
>
>On Wed, 12 Nov 2008 13:26:51 -0800
>Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>
>> --- tip.orig/mm/memory.c	2008-11-11 10:10:11.000000000 -0800
>> +++ tip/mm/memory.c	2008-11-11 12:10:18.000000000 -0800
>> @@ -99,6 +99,28 @@ int randomize_va_space __read_mostly =
>>  					2;
>>  #endif
>>  
>> +#ifndef track_pfn_vma_new
>> +int track_pfn_vma_new(struct vm_area_struct *vma, pgprot_t prot,
>> +			unsigned long pfn, unsigned long size)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> +
>> +#ifndef track_pfn_vma_copy
>> +int track_pfn_vma_copy(struct vm_area_struct *vma)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> +
>> +#ifndef untrack_pfn_vma
>> +void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
>> +			unsigned long size)
>> +{
>> +}
>> +#endif
>
>Using __weak would provide a somewhat neater result here.
>

Thought about that. But, then remembered the issues with gcc versions and __weak, as in here
http://lkml.org/lkml/2008/5/1/368

and decided to take the safer approach.

Thanks,
Venki