Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169Ab0AaIUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0AaIUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328Ab0AaIUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:20:11 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41897 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0AaIUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:20:10 -0500
Message-ID: <4B653D32.1040703@linux.vnet.ibm.com>
Date: Sun, 31 Jan 2010 13:50:02 +0530
From: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Mahesh Salgaonkar <mahesh@linux.vnet.in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin <schwidefsky@de.ibm.com>
Subject: Re: [patch] HWBKPT: Make bp_len type to u64 generic across the arch
References: <20100130045424.625452081@mars.in.ibm.com> <20100130045518.GA20776@in.ibm.com> <20100130183835.GA5675@nowhere>
In-Reply-To: <20100130183835.GA5675@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2010 12:08 AM, Frederic Weisbecker wrote:
> On Sat, Jan 30, 2010 at 10:25:18AM +0530, Mahesh Salgaonkar wrote:
>>
>> Change 'bp_len' type to __u64 to make it work across the arch.
>> The s390 architecture watch point length can be upto 2^64.
>>
>> reference:
>> 	http://lkml.org/lkml/2010/1/25/212
>>
>> Based on commit 6aa41f8b01301199af6c9febb24f3c1f5a0bc9d5
>>
>> Signed-off-by: Mahesh Salgaonkar<mahesh@linux.vnet.ibm.com>
>> ---
>>
>>   include/linux/hw_breakpoint.h |    2 +-
>>   include/linux/perf_event.h    |    6 ++----
>>   kernel/hw_breakpoint.c        |    2 +-
>>   kernel/perf_event.c           |    2 +-
>>   4 files changed, 5 insertions(+), 7 deletions(-)
>>
>>
>> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
>> index 41235c9..76e7427 100644
>> --- a/include/linux/hw_breakpoint.h
>> +++ b/include/linux/hw_breakpoint.h
>> @@ -44,7 +44,7 @@ static inline int hw_breakpoint_type(struct perf_event *bp)
>>   	return bp->attr.bp_type;
>>   }
>>
>> -static inline int hw_breakpoint_len(struct perf_event *bp)
>> +static inline unsigned long hw_breakpoint_len(struct perf_event *bp)
>>   {
>>   	return bp->attr.bp_len;
>>   }
>
>
>
> This should return a u64, or gcc will warn us about loosing
> informations in 32 bits arch?
>
Yup, I even thought so, but then I figured out the function 
'hw_breakpoint_addr()' also has same return type for returning 
'attr.bp_addr' and kept the same type to be consistent. We may have to 
fix that also. What do you think?

>
>
>>
>
>
> Acked-by: Frederic Weisbecker<fweisbec@gmail.com>
>

Thanks for reviewing.
