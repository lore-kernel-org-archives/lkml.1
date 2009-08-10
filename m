Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbZHJDBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbZHJDBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 23:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZHJDBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 23:01:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42731 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZHJDBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 23:01:08 -0400
Message-ID: <4A7F8DB2.5040501@redhat.com>
Date: Mon, 10 Aug 2009 11:02:10 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Bernhard Walle <bernhard.walle@gmx.de>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 4/7] ia64: implement crashkernel=auto
References: <20090806062125.5578.72123.sendpatchset@localhost.localdomain> <20090806062211.5578.59301.sendpatchset@localhost.localdomain> <4A7C7AEA.7080800@gmx.de>
In-Reply-To: <4A7C7AEA.7080800@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> Amerigo Wang schrieb:
>   
>>  
>> +#ifdef CONFIG_KEXEC_AUTO_RESERVE
>> +#ifdef KEXEC_AUTO_RESERVED_SIZE
>> +#undef KEXEC_AUTO_RESERVED_SIZE
>> +#endif
>> +#define KEXEC_AUTO_RESERVED_SIZE (1ULL<<28) /* 256M */
>> +#include <asm-generic/kexec.h>
>> +#endif
>> +
>>  extern struct kimage *ia64_kimage;
>>     
>
> IMO that's way too small for practial use on IA64 systems.
>
> For SLES11, which is based on Linux 2.6.28 IIRC, we use following memory
> size values in the YaST2 kdump module which configures the crashkernel
> parameter (this is YCP syntax, but I think everybody understands it):
>
>   
>> // bnc #446480 - Fine-tune kdump memory proposal
>> if ((Arch::ia64()) && (total_memory >= 1024))
>> {
>>     integer total_memory_gigabyte = total_memory/1024;
>>     if ((total_memory_gigabyte >= 1) && (total_memory_gigabyte <12))
>>         alocated_memory = "256";
>>     else if ((total_memory_gigabyte >= 12) && (total_memory_gigabyte <128))
>>         alocated_memory = "512";
>>     else if ((total_memory_gigabyte >= 128) && (total_memory_gigabyte <256))
>>         alocated_memory = "768";
>>     else if ((total_memory_gigabyte >= 256) && (total_memory_gigabyte <378))
>>         alocated_memory = "1024";
>>     else if ((total_memory_gigabyte >= 378) && (total_memory_gigabyte <512))
>>         alocated_memory = "1536";
>>     else if ((total_memory_gigabyte >= 512) && (total_memory_gigabyte <768))
>>         alocated_memory = "2048";
>>     else if (total_memory_gigabyte >= 768)
>>         alocated_memory = "3072";
>> }
>>     
>
> I got that assumtions from SGI (and they are known to have large IA64
> systems) and I think the values were tested.
>   

Hmm, thanks for this.

> But IMO it doesn't make sense to put such policy decisions in the
> kernel. I see no advantage for that. The average user doesn't have to
> write crashkernel parameters, they use the values that the distribution
> ships. Or do you think that an average user knows what a UUID of a file
> system is just to specify the correct root partition?
>   
The advantage is that we can provide a clever policy which can't be 
implemented with current mechanism, e.g. 32nd of phy mem, as proposed by 
Eric.


