Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589Ab0AaTcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0AaTcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 14:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216Ab0AaTcu
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 14:32:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:13618 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0AaTcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 14:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N2/dixeBhw2T/LiM3VWECRPpDAZCYeWYxpZPo4LEMj0dcORScvOoKVT69w1w59yT3r
         KgPMpeSEJ9cBaxFivNjrIYXVTnmz0cIJ0LubzgDZ6dAQ+RlplOF8lZ7drlvx3tvzz6sz
         R4H00VaDABxKpKjBnmCHxk2j0TqIhOlNPvr9k=
Date: Sun, 31 Jan 2010 20:32:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin <schwidefsky@de.ibm.com>
Subject: Re: [patch] HWBKPT: Make bp_len type to u64 generic across the arch
Message-ID: <20100131193242.GC5224@nowhere>
References: <20100130045424.625452081@mars.in.ibm.com> <20100130045518.GA20776@in.ibm.com> <20100130183835.GA5675@nowhere> <4B653D32.1040703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B653D32.1040703@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 01:50:02PM +0530, Mahesh Jagannath Salgaonkar wrote:
> On 01/31/2010 12:08 AM, Frederic Weisbecker wrote:
>> On Sat, Jan 30, 2010 at 10:25:18AM +0530, Mahesh Salgaonkar wrote:
>>>
>>> Change 'bp_len' type to __u64 to make it work across the arch.
>>> The s390 architecture watch point length can be upto 2^64.
>>>
>>> reference:
>>> 	http://lkml.org/lkml/2010/1/25/212
>>>
>>> Based on commit 6aa41f8b01301199af6c9febb24f3c1f5a0bc9d5
>>>
>>> Signed-off-by: Mahesh Salgaonkar<mahesh@linux.vnet.ibm.com>
>>> ---
>>>
>>>   include/linux/hw_breakpoint.h |    2 +-
>>>   include/linux/perf_event.h    |    6 ++----
>>>   kernel/hw_breakpoint.c        |    2 +-
>>>   kernel/perf_event.c           |    2 +-
>>>   4 files changed, 5 insertions(+), 7 deletions(-)
>>>
>>>
>>> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
>>> index 41235c9..76e7427 100644
>>> --- a/include/linux/hw_breakpoint.h
>>> +++ b/include/linux/hw_breakpoint.h
>>> @@ -44,7 +44,7 @@ static inline int hw_breakpoint_type(struct perf_event *bp)
>>>   	return bp->attr.bp_type;
>>>   }
>>>
>>> -static inline int hw_breakpoint_len(struct perf_event *bp)
>>> +static inline unsigned long hw_breakpoint_len(struct perf_event *bp)
>>>   {
>>>   	return bp->attr.bp_len;
>>>   }
>>
>>
>>
>> This should return a u64, or gcc will warn us about loosing
>> informations in 32 bits arch?
>>
> Yup, I even thought so, but then I figured out the function  
> 'hw_breakpoint_addr()' also has same return type for returning  
> 'attr.bp_addr' and kept the same type to be consistent. We may have to  
> fix that also. What do you think?


True. I'll fix both then, thanks!

