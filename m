Return-Path: <linux-kernel-owner+w=401wt.eu-S1762366AbXJYQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762366AbXJYQvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbXJYQvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:51:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:1863 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbXJYQvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,329,1188802800"; 
   d="scan'208";a="255538040"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6 patch] unexport tick_nohz_get_sleep_length
Date: Thu, 25 Oct 2007 09:51:03 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5018EBEF1@scsmsx415.amr.corp.intel.com>
In-Reply-To: <alpine.LFD.0.9999.0710251126430.3186@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] unexport tick_nohz_get_sleep_length
Thread-Index: AcgW6V2pxQ7LcSWbSEuECf3+k5L5SQAPZ74A
References: <20071024162422.GH30533@stusta.de> <alpine.LFD.0.9999.0710251126430.3186@localhost.localdomain>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Adrian Bunk" <bunk@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>, "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Oct 2007 16:51:04.0811 (UTC) FILETIME=[3B6B4BB0:01C81727]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de] 
>Sent: Thursday, October 25, 2007 2:28 AM
>To: Adrian Bunk
>Cc: Brown, Len; LKML; Pallipadi, Venkatesh
>Subject: Re: [2.6 patch] unexport tick_nohz_get_sleep_length
>
>On Wed, 24 Oct 2007, Adrian Bunk wrote:
>
>> This patch removes the unused 
>> EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length).
>> 
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>> 
>> ---
>> f7c83dfe117f4fd072b2506ae090e4145abda362 
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index 10a1347..5997456 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -320,8 +320,6 @@ ktime_t tick_nohz_get_sleep_length(void)
>>  	return ts->sleep_length;
>>  }
>>  
>> -EXPORT_SYMBOL_GPL(tick_nohz_get_sleep_length);
>> -
>
>Hmm, this was added to allow the cpuidle governers modular
>build. Seems this was changed to compiled in only.
>
>Len, Venki, is this the final decision ?
>

Yes. This was done recently for proper fallback to old ACPI policy in
case CPUIDLE is not selected. With that being module, falling back to
ACPI policy at run time makes things ugly.

Thanks,
Venki
