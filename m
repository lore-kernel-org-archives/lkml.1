Return-Path: <linux-kernel-owner+w=401wt.eu-S1764422AbYAaOmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764422AbYAaOmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758295AbYAaOlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:41:49 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:33288 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453AbYAaOls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:41:48 -0500
Message-ID: <47A1DE37.9060202@web.de>
Date: Thu, 31 Jan 2008 15:41:59 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: george@wildturkeyranch.net
CC: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       kgdb-bugreport@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Kgdb-bugreport] [PATCH 1/5] KGDB: improve early init
References: <479FBA3B.5050209@web.de> <47A10355.9090707@web.de> <47A1D9AE.4090206@wildturkeyranch.net>
In-Reply-To: <47A1D9AE.4090206@wildturkeyranch.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V01U2FsdGVkX1/41diZwy99zqVB8bJONV+jPJqSivh3+u1myhFJ
	NUhhnmSV4kk7tiCBWmQMoCy1oGwMdXVDLFPEasMSe+JkfKFG5i
	x0CsPSu2s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Anzinger wrote:
> On 01/31/2008 01:36 AM,  Jan Kiszka was caught saying:
>> Jan Kiszka wrote:
>>> George Anzinger wrote:
>>>> On 01/30/2008 04:08 PM,  Jan Kiszka was caught saying:
>>>>> [Here comes a rebased version against latest x86/mm]
>>>>>
>>>>> In case "kgdbwait" is passed as kernel parameter, KGDB tries to set up
>>>>> and connect to the front-end already during early_param evaluation.
>>>>> This
>>>>> fails on x86 as the exception stack is not yet initialized,
> effectively
>>>>> delaying kgdbwait until late-init.
>>>>
>>>> I wonder how much work it would take to just set up the exception
>>>> stack and proceed.  After all the kgbdwait is there to help debug
>>>> very early kernel code...
>>>
>>> In principle a valid question, but I'm not the one to answer it. I
>>> would not feel very well if I had to reorder this critical setup code.
>>> Look, we would have to move trap_init in start_kernel before
>>> parse_early_param, and that would affect _every_ arch...
> 
> I can not speak to other archs, but for x86 I called trap_init from the
> code that caught the kgdbwait.  At that time (since I retired, I have
> not looked at the actual kernel code) it could be called again later by
> the kernel code.  I.e. I did not try to reorder the kernel bring up
> code, but just added an additional call to trap_init and then only in
> the case of finding a kgdbwait.
> 
> As such, this would need to be arch specific...
> 
>>>
>>
>> BTW, do you know if EXCEPTION_STACK_READY fails for other archs in
>> parse_early_param as well? It should, because my under standing of
>> trap_init is that it's the functions to arm things like... exception
>> handlers? And that raises the question of the deeper purpose of this
>> check (and the invocation of kgdb_early_init from the argument parsing
>> function). Sigh, KGDB is still a quite improvable piece of code.
> 
> Likely.  Once you get it in the main line kernel, one would hope that
> other arch code would be forth coming as many more "eyes" will be in play.

Meanwhile I realized that there is early_trap_init - for x86-32 only! I
assume now we are only lacking the same for x86-64 to get kgdb running
there already during early_param-parsing.

Jan
