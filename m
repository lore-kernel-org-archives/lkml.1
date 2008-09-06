Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224AbYIFEDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbYIFEDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 00:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYIFEDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 00:03:09 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:10698 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYIFEDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 00:03:09 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=TXxKV5oLlJ-9x5WtdRsA:9 a=aE13rV4XSj_BEJifw0kkvFJ78asA:4 a=CY6gl2JlH4YA:10 a=QuTCihfHmrUA:10 a=Xzxz76dmvMUA:10
Message-ID: <48C200F8.90705@shaw.ca>
Date: Fri, 05 Sep 2008 22:03:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes (NOPL issue)
References: <fa.HDZlnwhQIaOU7WkvenWvWDveLiI@ifi.uio.no> <fa.uHa5kqSRJ8gj0H3r9BmGsTqRvFI@ifi.uio.no>
In-Reply-To: <fa.uHa5kqSRJ8gj0H3r9BmGsTqRvFI@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Sep 5, 2008 at 7:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Hi Linus,
>>
>> Please pull:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus-2
>>
>> H. Peter Anvin (4):
>>      x86: boot: stub out unimplemented CPU feature words
>  diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index 80ab20d..0785b3c 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -13,6 +13,7 @@
>>  #include <asm/mtrr.h>
>>  #include <asm/mce.h>
>>  #include <asm/pat.h>
>> +#include <asm/asm.h>
>>  #ifdef CONFIG_X86_LOCAL_APIC
>>  #include <asm/mpspec.h>
>>  #include <asm/apic.h>
>> @@ -341,6 +342,35 @@ static void __init early_cpu_detect(void)
>>        early_get_cap(c);
>>  }
>>
>> +/*
>> + * The NOPL instruction is supposed to exist on all CPUs with
>> + * family >= 6, unfortunately, that's not true in practice because
>> + * of early VIA chips and (more importantly) broken virtualizers that
>> + * are not easy to detect.  Hence, probe for it based on first
>> + * principles.
>> + */
> 
> if so, should only test on VIA chips.

The virtual CPUs are more of a problem. They can't be distinguished from 
the real CPU models they are emulating other than by actually testing.
