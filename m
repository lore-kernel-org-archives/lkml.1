Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZCSLFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZCSLFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZCSLE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:04:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:51777 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZCSLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:04:58 -0400
Message-ID: <49C226D1.2070903@monstr.eu>
Date: Thu, 19 Mar 2009 12:04:49 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Microblaze linux support
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <20090319072256.GA5069@elte.hu> <49C213A2.4040609@monstr.eu> <20090319102142.GA2579@elte.hu> <49C21DF0.10808@monstr.eu> <20090319105001.GC2579@elte.hu> <49C22401.60007@monstr.eu> <20090319110056.GA11077@elte.hu>
In-Reply-To: <20090319110056.GA11077@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Michal Simek <monstr@monstr.eu> wrote:
> 
>> Ingo Molnar wrote:
>>> * Michal Simek <monstr@monstr.eu> wrote:
>>>
>>>> Hi Ingo,
>>>>> * Michal Simek <monstr@monstr.eu> wrote:
>>>>>
>>>>>> WARNING: externs should be avoided in .c files
>>>>>> #110: FILE: arch/microblaze/kernel/microblaze_ksyms.c:45:
>>>>>> +extern void __umodsi3(void);
>>>>>>
>>>>>> WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
>>>>>> #111: FILE: arch/microblaze/kernel/microblaze_ksyms.c:46:
>>>>>> +EXPORT_SYMBOL(__umodsi3);
>>>>> externs should be in header files.
>>>>>
>>>>> The rest indeed looks like false positives. Thanks for addressing 
>>>>> these things so quickly!
>>>> you are welcome - I can quickly test and add all changes to git.
>>>>
>>>> Is it good style separate extern definition and EXPORT_SYMBOL?
>>>>
>>>> I have three choices?
>>>> 1. keep extern + EXPORT_SYMBOL below  - current style
>>>> 2. move only extern to header file
>>>> 3. move extern and EXPORT_SYMBOL to header.
>>>>
>>>> What is preferable way?
>>> Where are the symbols defined - by gcc's library?
>> yes.
> 
> i suspect it's borderline in that case, and your solution is fine. 
> The other solution would be to stuff the externs into a header and 
> have a continuous block of exports with a comment that says:
> 
>  /*
>   * GCC library functions:
>   */
>  EXPORT_SYMBOL(...);
>  EXPORT_SYMBOL(...);
>  EXPORT_SYMBOL(...);

Ok. I keep it in current style. Everything is one file and there is comment
about.

Thanks,
Michal

> 	Ingo

