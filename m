Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbYAPSR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbYAPSR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbYAPSRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:17:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:64992 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbYAPSRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:17:18 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 2/4] x86: PAT followup - Remove KERNPG_TABLE from pte entry
Date: Wed, 16 Jan 2008 10:17:56 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5E8AB4@orsmsx423.amr.corp.intel.com>
In-Reply-To: <478DBCC8.10404@kolumbus.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 2/4] x86: PAT followup - Remove KERNPG_TABLE from pte entry
Thread-Index: AchYF781KLNkonEVQKijHUPREYvZigAVBFtQ
References: <20080116023955.597433000@intel.com> <20080116024111.825025000@intel.com> <478DBCC8.10404@kolumbus.fi>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: =?iso-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>
Cc: <ak@muc.de>, <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <hpa@zytor.com>, <akpm@linux-foundation.org>, <arjan@infradead.org>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, <davem@davemloft.net>,
       <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 16 Jan 2008 18:17:00.0344 (UTC) FILETIME=[FCA47380:01C8586B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Mika Penttilä [mailto:mika.penttila@kolumbus.fi] 
>Sent: Wednesday, January 16, 2008 12:14 AM
>To: Pallipadi, Venkatesh
>Cc: ak@muc.de; ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
>tglx@linutronix.de; hpa@zytor.com; akpm@linux-foundation.org; 
>arjan@infradead.org; Barnes, Jesse; davem@davemloft.net; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 2/4] x86: PAT followup - Remove 
>KERNPG_TABLE from pte entry
>
>venkatesh.pallipadi@intel.com kirjoitti:
>> KERNPG_TABLE was a bug in earlier patch. Remove it from pte.
>> pte_val() check is redundant as this routine is called 
>immediately after a
>> ptepage is allocated afresh.
>>
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>>
>> Index: linux-2.6.git/arch/x86/mm/init_64.c
>> ===================================================================
>> --- linux-2.6.git.orig/arch/x86/mm/init_64.c	2008-01-15 
>11:02:23.000000000 -0800
>> +++ linux-2.6.git/arch/x86/mm/init_64.c	2008-01-15 
>11:06:37.000000000 -0800
>> @@ -541,9 +541,6 @@
>>  		if (address >= end)
>>  			break;
>>  
>> -		if (pte_val(*pte))
>> -			continue;
>> -
>>  		/* Nothing to map. Map the null page */
>>  		if (!(address & (~PAGE_MASK)) &&
>>  		    (address + PAGE_SIZE <= end) &&
>> @@ -561,9 +558,9 @@
>>  		}
>>  
>>  		if (exec)
>> -			entry = 
>_PAGE_NX|_KERNPG_TABLE|_PAGE_GLOBAL|address;
>> +			entry = _PAGE_NX|_PAGE_GLOBAL|address;
>>  		else
>> -			entry = _KERNPG_TABLE|_PAGE_GLOBAL|address;
>> +			entry = _PAGE_GLOBAL|address;
>>  		entry &= __supported_pte_mask;
>>  		set_pte(pte, __pte(entry));
>>  	}
>>
>>   
>
>Hmm then what's the point of mapping not present 4k pages for 
>valid mem 
>here?
>

My bad... Thanks for the catch.
I had to replace KERNPG_TABLE by PAGE_KERNEL here.

Thanks,
Venki
