Return-Path: <linux-kernel-owner+w=401wt.eu-S1751319AbZIXV6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbZIXV6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZIXV6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:58:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZIXV6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:58:12 -0400
Message-ID: <4ABBEBBF.9080400@redhat.com>
Date: Thu, 24 Sep 2009 14:59:27 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <peterz@infradead.org>, anil.s.keshavamurthy@intel.com,
       Jason Yeh <jason.yeh@amd.com>, Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC patch] Immediate Values - x86 Optimization NMI and MCE support
References: <20090924132626.485545323@polymtl.ca> <20090924133400.830759403@polymtl.ca> <1253803872.18939.28.camel@laptop> <20090924150333.GA26389@Krystal> <1253804779.18939.38.camel@laptop> <20090924160118.GA28846@Krystal>
In-Reply-To: <20090924160118.GA28846@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> [Ingo: this patch is for RFC only. Do not merge.]
> 
> * Peter Zijlstra (peterz@infradead.org) wrote:
>> On Thu, 2009-09-24 at 11:03 -0400, Mathieu Desnoyers wrote:
>>> * Peter Zijlstra (peterz@infradead.org) wrote:
>>>> On Thu, 2009-09-24 at 09:26 -0400, Mathieu Desnoyers wrote:
>>>>> plain text document attachment (tracepoints-immediate-values.patch)
>>>>> Use immediate values in tracepoints.
>>>>
>>>> I might have missed it, but did both the Intel and AMD cpu folks clear
>>>> the SMP code rewrite bits?
>>>>
>>>
>>> SMP handling is performed with stop_machine() in this patchset. Nothing
>>> fancy here.
>>>
>>> I've got other patches, not included in this patchset, which implements
>>> nmi-safe code modification, based on a scheme using breakpoints and
>>> IPIs, inspired from djprobes. That one might be worth clearing with
>>> intel/amd devs before merging.
>>>
>>> However, doing code patching within stop_machine() is pretty safe, given
>>> all other CPUs are busy-looping with interrupts off while this happens.
>>> Ftrace already does this.
>>
>> Agreed, I missed this relied on stopmachine. No problem then.
>>
>> It would be good to reduce reliance on stopmachine, so it would be good
>> to get some CPU folks looking at your alternative implementation.
>>
>> Thanks!
>>
> 
> Sure, here is the patch applying on top of the immediate values
> patchset. It implements the breakpoint-based instruction patching
> scheme. I just provide this one for review. There is a following patch
> which makes the immediate values infrastructure use this arch-specific
> file, which I'll leave out for now.

Mathieu, could you check my previous patch?
http://lkml.org/lkml/2009/9/14/551

I think we can share some code and ideas about generic XMC:-).
But since it seems that the imv requires a dedicated method,
I don't think we can share the code entirely. :-)

> +#include <asm/cacheflush.h>
> +
> +#define BREAKPOINT_INSTRUCTION  0xcc
> +#define BREAKPOINT_INS_LEN	1
> +#define NR_NOPS			10

Why don't you reuse macros in asm/include/kprobes.h? :)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

