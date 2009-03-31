Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbZCaCp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbZCaCp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZCaCpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:45:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52288 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZCaCpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:45:13 -0400
Message-ID: <49D183B0.6060306@jp.fujitsu.com>
Date: Tue, 31 Mar 2009 11:45:04 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <20090328120825.GB14464@elte.hu>
In-Reply-To: <20090328120825.GB14464@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Sorry, could you drop patch 1/3 and 3/3 from your -tip tree?
Andi and I discussed some and agreed disabling CMCI need to be
done in different way (at least parameter name).

Thanks,
H.Seto

Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
>> This patch adds a kernel parameter "mce_threshold=n" to enable us
>> to change the default threshold for CMCI(Corrected Machine Check
>> Interrupt) that recent Intel processor supports.
>>
>> And it also supports CMCI disabling by setting mce_threshold=0.
>> It would be useful if your hardware does something wrong and/or
>> if polling by timer is preferred than the threshold interrupt.
>>
>> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> ---
>>  Documentation/kernel-parameters.txt       |    5 +++
>>  arch/x86/include/asm/msr-index.h          |    1 +
>>  arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   56 +++++++++++++++++++++++++++--
>>  3 files changed, 59 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 1d8af36..7a0d117 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1267,6 +1267,11 @@ and is between 256 and 4096 characters. It is defined in the file
>>  
>>  	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
>>  
>> +	mce_threshold=	[X86-64,intel] Default CMCI threshold
>> +			Should be unsigned integer. Setting 0 disables cmci.
>> +			Format: <integer>
>> +			Default: 1
> 
> Makes sense. CMCI is a new CPU feature so having boot controls to 
> disable it is generally a good idea - while still having old-style 
> MCE support in place.
> 
> Applied to tip:x86/mce2, thanks Hidetoshi!
> 
> 	Ingo
> 
> 

