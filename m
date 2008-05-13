Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbYEMPrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbYEMPrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYEMPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:47:06 -0400
Received: from ns2.protei.ru ([195.239.28.26]:43730 "EHLO mail.protei.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYEMPrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:47:05 -0400
Message-ID: <4829B7B3.2010300@protei.ru>
Date: Tue, 13 May 2008 19:45:55 +0400
From: Nickolay Vinogradov <nickolay@protei.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/bitops/fls64.h
References: <481E076A.8060302@protei.ru>	<20080512144507.8d770723.akpm@linux-foundation.org>	<482970DF.8020206@protei.ru> <20080513083101.96c92bd6.akpm@linux-foundation.org>
In-Reply-To: <20080513083101.96c92bd6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton пишет:
> On Tue, 13 May 2008 14:43:43 +0400 Nickolay Vinogradov <nickolay@protei.ru> wrote:
> 
>> Andrew Morton __________:
>>> On Sun, 04 May 2008 22:58:50 +0400
>>> ____________________ ______________ ____________________ <nickolay@protei.ru> wrote:
>>>
>>>> bugfix in fls64 on a big endian systems(against 2.6.25).
>>>>
>>>> Signed-off-by: Nickolay Vinogradov <nickolay@protei.ru>
>>>>
>>>> --
>>>>
>>>> diff --git a/include/asm-generic/bitops/fls64.h 
>>>> b/include/asm-generic/bitops/fls64.h
>>>> index 1b6b17c..2eedb6f 100644
>>>> --- a/include/asm-generic/bitops/fls64.h
>>>> +++ b/include/asm-generic/bitops/fls64.h
>>>> @@ -8,7 +8,7 @@ static inline int fls64(__u64 x)
>>>>          __u32 h = x >> 32;
>>>>          if (h)
>>>>                  return fls(h) + 32;
>>>> -       return fls(x);
>>>> +       return fls((__u32)x);
>>>>   }
>>>>
>>>>   #endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */
>>> Please describe the bug which you are fixing?
>>>
>>> Perhaps a more robust fix to <whatever the bug is> would be to
>>> repair fls() so that it works correctly when passed a u64.  Perhaps.
>> Repair fls64() so that it works correctly when passed a u64.
>>
> 
> Yes, but what's wrong with it now?
> 
> The fls() in include/asm-generic/bitops/fls.h takes an int.
> 
> The fls() in include/asm-x86/bitops.h takes an int.
> 
> So both of these will already trucate the incoming argument to 32-bits.
> 
> It seems that you are using a version of fls() which doesn't do this. 
> Why?  Which architecture are you using?  Would it not be more robust to
> fix fls()?

include/asm-arm/bitops.h
fls() defined here as a macro, not as a function with 32-bit argument.
Therefore, there are two choices:
1. explicit cast to u32 before calling.
2. rewrite fls macro as an inline function.

-- 
Nickolay Vinogradov
Protei Research and Development Center
St.Petersburg, 194044, Russia
Tel.: +7 812 449 47 27
