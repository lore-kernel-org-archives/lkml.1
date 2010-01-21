Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223Ab0AUFmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0AUFmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 00:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726Ab0AUFmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 00:42:05 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34194 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0AUFmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 00:42:02 -0500
Message-ID: <4B57E905.1060900@linux.vnet.ibm.com>
Date: Thu, 21 Jan 2010 11:11:25 +0530
From: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, ffweisbec@gmail.com
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, schwidefsky@de.ibm.com,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: Re: [patch 3/3] S390-HWBKPT v3: Modify ptrace to use Hardware Breakpoint
 interfaces.
References: <20100114061701.485284442@mars.in.ibm.com> <20100114062859.GD1753@in.ibm.com> <20100120110805.GD7619@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100120110805.GD7619@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Thu, Jan 14, 2010 at 11:58:59AM +0530, Mahesh Salgaonkar wrote:
>> Modify the ptrace code to use the hardware breakpoint interfaces for
>> user-space
> 
> I didn't look too deep into this one. So actually only one trivial comment:
> 
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index 9a1d276..cb74f24 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -215,7 +215,11 @@ struct perf_event_attr {
>>
>>  	__u64			bp_addr;
>>  	__u32			bp_type;
>> +#ifdef __s390x__
>> +	__u64			bp_len;
>> +#else
>>  	__u32			bp_len;
>> +#endif
>>  };
>>
>>  /*
>>
> 
> Any chance to change common code to change that to an __u64 (unconditional)
> or at least an unsigned long?
> I'd hate to see an ifdef __s390x__ in common code.

Can we have the above common code to change the type of 'bp_len' to 
__u64? In s390x arch watch point length can be upto 2^64.
