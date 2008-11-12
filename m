Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbYKLXyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbYKLXyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYKLXyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:54:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:24123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYKLXya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:54:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="638548737"
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
Date: Wed, 12 Nov 2008 15:54:21 -0800
Subject: RE: [patch 3/8] x86 PAT: Add follow_pfnmp_pte routine to help
 tracking pfnmap pages
Thread-Topic: [patch 3/8] x86 PAT: Add follow_pfnmp_pte routine to help
 tracking pfnmap pages
Thread-Index: AclFHjgJJrwUPCHJQomFMIjCUiwCoAAA3ZpQ
Message-ID: <7E82351C108FA840AB1866AC776AEC46426F307E@orsmsx505.amr.corp.intel.com>
References: <20081112212647.259698000@intel.com>
 <20081112212900.291460000@intel.com> <20081112232706.GC29363@wotan.suse.de>
In-Reply-To: <20081112232706.GC29363@wotan.suse.de>
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
>Sent: Wednesday, November 12, 2008 3:27 PM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Thomas Gleixner; H.Peter Anvin; Hugh Dickins; 
>Roland Dreier; Jesse Barnes; Jeremy Fitzhardinge; Arjan van de 
>Ven; linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 3/8] x86 PAT: Add follow_pfnmp_pte routine 
>to help tracking pfnmap pages
>
>On Wed, Nov 12, 2008 at 01:26:50PM -0800, Venkatesh Pallipadi wrote:
>> 
>> Add a generic interface to follow pfn in a pfnmap vma range. 
>This is used by
>> one of the subsequent x86 PAT related patch to keep track of 
>memory types
>> for vma regions across vma copy and free.
>> 
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>> 
>> ---
>>  include/linux/mm.h |    3 +++
>>  mm/memory.c        |   43 
>+++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 46 insertions(+)
>> 
>> Index: tip/include/linux/mm.h
>> ===================================================================
>> --- tip.orig/include/linux/mm.h	2008-11-06 
>15:41:43.000000000 -0800
>> +++ tip/include/linux/mm.h	2008-11-10 09:44:45.000000000 -0800
>> @@ -1223,6 +1223,9 @@ struct page *follow_page(struct vm_area_
>>  #define FOLL_GET	0x04	/* do get_page on page */
>>  #define FOLL_ANON	0x08	/* give ZERO_PAGE if no pgtable */
>>  
>> +unsigned long follow_pfnmap_pte(struct vm_area_struct *vma,
>> +				unsigned long address, pte_t *ret_ptep);
>> +
>>  typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, 
>unsigned long addr,
>>  			void *data);
>>  extern int apply_to_page_range(struct mm_struct *mm, 
>unsigned long address,
>> Index: tip/mm/memory.c
>> ===================================================================
>> --- tip.orig/mm/memory.c	2008-11-06 15:41:43.000000000 -0800
>> +++ tip/mm/memory.c	2008-11-10 09:44:45.000000000 -0800
>> @@ -1111,6 +1111,49 @@ no_page_table:
>>  	return page;
>>  }
>>  
>> +unsigned long follow_pfnmap_pte(struct vm_area_struct *vma,
>> +			unsigned long address, pte_t *ret_ptep)
>> +{
>
>I think we'd typically return an int for functions like this. It
>probably wouldn't hurt to return more descriptive errors either.
>-EINVAL, perhaps, seems to fit best with what existing code there
>is doing.
>

Yes. Will change the return type to int with more appropriate
return values and update the patch.

Thanks,
Venki