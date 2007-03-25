Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbXCYNFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbXCYNFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 09:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbXCYNFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 09:05:30 -0400
Received: from comtv.ru ([217.10.32.17]:42627 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbXCYNFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 09:05:30 -0400
X-UCL: actv
Date: Sun, 25 Mar 2007 17:05:00 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Con Kolivas <kernel@kolivas.org>
cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <200703252202.48022.kernel@kolivas.org>
Message-ID: <Pine.LNX.4.64.0703251701210.7018@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org>
 <Pine.LNX.4.64.0703251521270.11555@linmac.oyster.ru> <200703252146.45721.kernel@kolivas.org>
 <200703252202.48022.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007, Con Kolivas wrote:

> On Sunday 25 March 2007 21:46, Con Kolivas wrote:
>> On Sunday 25 March 2007 21:34, malc wrote:
>>> On Sun, 25 Mar 2007, Ingo Molnar wrote:
>>>> * Con Kolivas <kernel@kolivas.org> wrote:
>>>>> For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
>>>>
>>>> we want to do this - and we should do this to the vanilla scheduler
>>>> first and check the results. I've back-merged the patch to before RSDL
>>>> and have tested it - find the patch below. Vale, could you try this
>>>> patch against a 2.6.21-rc4-ish kernel and re-test your testcase?
>>>
>>> [..snip..]
>>>
>>> Compilation failed with:
>>> kernel/built-in.o(.sched.text+0x564): more undefined references to
>>> `__udivdi3' follow
>>>
>>> $ gcc --version | head -1
>>> gcc (GCC) 3.4.6
>>>
>>> $ cat /proc/cpuinfo | grep cpu
>>> cpu             : 7447A, altivec supported
>>>
>>> Can't say i really understand why 64bit arithmetics suddenly became an
>>> issue here.
>>
>> Probably due to use of:
>>
>> #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
>> #define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
>>
>> Excuse our 64bit world while we strive to correct our 32bit blindness and
>> fix this bug.
>
> Please try this (akpm please don't include till we confirm it builds on ppc,
> sorry). For 2.6.21-rc4
>

Works. Accuracy is on par (most of the time with fraction of the
percent) with ad hoc method my kernel module employs. However there's
something strange happening w.r.t. iowait, it looks as if it doesn't
affect the idle field any more, nothing big but a digression from the
previous behavior. Thank you very much for this.

-- 
vale
