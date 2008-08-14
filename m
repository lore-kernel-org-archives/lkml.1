Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbYHNL4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbYHNL4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYHNL4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:56:13 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:51822 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753889AbYHNL4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:56:12 -0400
X-BigFish: VPS-38(z78cM34a4lz1432R98dR4015M1805M936fQzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K5LAH7-02-EF9-01
Message-ID: <48A41D4A.9060204@amd.com>
Date: Thu, 14 Aug 2008 13:55:54 +0200
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [patch 2/2] [PATCH 2/2] x86: Fixed NULL function pointer dereference
 in AMD microcode patch loader.
References: <20080801104644.788786464@amd.com>	<20080801104754.604840263@amd.com> <20080813190557.d22fee8c.akpm@linux-foundation.org>
In-Reply-To: <20080813190557.d22fee8c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2008 11:55:54.0473 (UTC) FILETIME=[B4AEAD90:01C8FE04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

that patch is only relevant in combination with the AMD microcode patch loader.

Thanks,
Peter

Andrew Morton schrieb:
> On Fri, 1 Aug 2008 12:46:46 +0200 Peter Oruba <peter.oruba@amd.com> wrote:
> 
>> Dereference took place in code part responsible for manual installation
>> of microcode patches through /dev/cpu/microcode.
>>
> 
> That's a bit too terse.
> 
>> ---
>>  arch/x86/kernel/microcode.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
>> index 39961bb..ad136ad 100644
>> --- a/arch/x86/kernel/microcode.c
>> +++ b/arch/x86/kernel/microcode.c
>> @@ -127,7 +127,8 @@ static int do_microcode_update(void)
>>  	old = current->cpus_allowed;
>>  
>>  	while ((cursor = microcode_ops->get_next_ucode(&new_mc, cursor)) > 0) {
>> -		error = microcode_ops->microcode_sanity_check(new_mc);
>> +		if (microcode_ops->microcode_sanity_check != NULL)
>> +			error = microcode_ops->microcode_sanity_check(new_mc);
>>  		if (error)
>>  			goto out;
>>  		/*
> 
> The patch is no longer applicable to current sources.
> 
> If the bug is sufficiently serious to warrant fixing in 2.6.25.x and in
> 2.6.26.x then please prepare patches against those kernels, including
> sufficient description to enable the -stable maintainers to understand
> why they need to merge it.  Cc those patches to stable@kernel.org.
> 
> Thanks.
> 
> 
> 

-- 
            |           AMD Saxony Limited Liability Company & Co. KG
  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
  System    |                  Register Court Dresden: HRA 4896
  Research  |              General Partner authorized to represent:
  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

