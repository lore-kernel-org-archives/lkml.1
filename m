Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881Ab0AYUlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0AYUlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865Ab0AYUk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:40:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:53571 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0AYUk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:40:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JDL2I8emWb/NSBMKAbzsdHQIRH5+5hMcmhzD78w3O5Aqu2hk5H4Ul6qCDbbhQ1u6qH
         fvMfEzYDaBLx0tDcf0DUo0oyNk9HM8JVInNf1W53NbnDeMIDn6wsMKRkRKctS3abZN+k
         DH9E6w31epZe4BmKU+2mP5ZUmJUrmUErBXqMM=
Date: Mon, 25 Jan 2010 21:40:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, schwidefsky@de.ibm.com,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: Re: [patch 3/3] S390-HWBKPT v3: Modify ptrace to use Hardware
	Breakpoint interfaces.
Message-ID: <20100125204049.GA5087@nowhere>
References: <20100114061701.485284442@mars.in.ibm.com> <20100114062859.GD1753@in.ibm.com> <20100120110805.GD7619@osiris.boeblingen.de.ibm.com> <4B57FB1F.5000305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B57FB1F.5000305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 12:28:39PM +0530, Mahesh Jagannath Salgaonkar wrote:
> Heiko Carstens wrote:
>> On Thu, Jan 14, 2010 at 11:58:59AM +0530, Mahesh Salgaonkar wrote:
>>> Modify the ptrace code to use the hardware breakpoint interfaces for
>>> user-space
>>
>> I didn't look too deep into this one. So actually only one trivial comment:
>>
>>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>>> index 9a1d276..cb74f24 100644
>>> --- a/include/linux/perf_event.h
>>> +++ b/include/linux/perf_event.h
>>> @@ -215,7 +215,11 @@ struct perf_event_attr {
>>>
>>>  	__u64			bp_addr;
>>>  	__u32			bp_type;
>>> +#ifdef __s390x__
>>> +	__u64			bp_len;
>>> +#else
>>>  	__u32			bp_len;
>>> +#endif
>>>  };
>>>
>>>  /*
>>>
>>
>> Any chance to change common code to change that to an __u64 (unconditional)
>> or at least an unsigned long?
>> I'd hate to see an ifdef __s390x__ in common code.
>
> Can we have the above common code to change the type of 'bp_len' to  
> __u64? In s390x arch watch point length can be upto 2^64.



Yep, please send a patch to make it a generic u64 if an arch needs it.
We really need a fixed cross arch size for this structure.

Thanks!

