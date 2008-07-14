Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYGNW0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYGNW0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbYGNW0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:26:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14856 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbYGNW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:26:32 -0400
Message-ID: <487BD297.4070802@ct.jp.nec.com>
Date: Mon, 14 Jul 2008 15:26:31 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: ia32_signal.c: use macro instead of immediate
References: <487BC1B9.1090400@ct.jp.nec.com> <487BCD9C.4030003@zytor.com> <487BD10F.2060408@ct.jp.nec.com> <487BD1DD.9040008@zytor.com>
In-Reply-To: <487BD1DD.9040008@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hiroshi Shimamoto wrote:
>> H. Peter Anvin wrote:
>>> Hiroshi Shimamoto wrote:
>>>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>>>
>>>> Make and use macro FIX_EFLAGS, instead of immediate value 0x40DD5 in
>>>> ia32_restore_sigcontext().
>>>>
>>>> +
>>>> +#ifdef CONFIG_X86_32
>>>> +# define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
>>>> +#else
>>>> +# define FIX_EFLAGS	__FIX_EFLAGS
>>>> +#endif
>>>> +
>>> Where did this come from?  First of all, this is in a 64-bit-only file, 
>>> so CONFIG_X86_32 will never be set; second of all, it seems a bit fishy 
>>> that these should be different.
>> It came from arch/x86/kernel/signal_64.c. (And signal_32.c has the same one.)
>> And yes, CONFIG_X86_32 is not set, I compiled and compare the results,
>> the macro was replaced by 0x40dd5, no RF.
>> I guess, someone made it same on signal_32.c and signal_64.c.
>>
> 
> Yes, it's working toward unification (and ia32signal.c is obviously also 
> a candidate for unification.)  However, please make that a separate patch.

OK. Will do.

Thanks,
Hiroshi Shimamoto

