Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbXLSEuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbXLSEuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 23:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXLSEuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 23:50:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXLSEuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 23:50:06 -0500
Message-ID: <4768A18F.4040406@redhat.com>
Date: Tue, 18 Dec 2007 23:43:59 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] x86: add kprobe-booster to X86_64
References: <1197930464.23402.112.camel@brick> 	 <20071218112936.GE9002@elte.hu> <1197978160.7734.31.camel@brick> 	 <4767D02C.6030704@redhat.com> <1198031400.7734.41.camel@brick>
In-Reply-To: <1198031400.7734.41.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Tue, 2007-12-18 at 08:50 -0500, Masami Hiramatsu wrote:
>> Hi Harvey,
>>
>> Thank you for cleaning this up.
>>
>> Harvey Harrison wrote:
>>> Subject: [PATCH] x86: kprobes leftover cleanups
>>>
>>> Eliminate __always_inline, all of these static functions are
>>> only called once.  Minor whitespace cleanup.  Eliminate one
>>> supefluous return at end of void function.  Reverse sense of
>>> #ifndef to be #ifdef to show the case only affects X86_32.
>> Unfortunately, to prevent kprobe recursive call, all functions which
>> is called from kprobes must be inlined or have __kprobes.
>> If __always_inline macro still work, I prefer to use it. If not,
>> it must have a __kprobe attribute like as below.
> 
> I thought all static functions that were only called once were
> automatically inlined these days?  Otherwise __always_inline and
> inline are exactly the same in the kernel.

Yes, it will be (not obviously) inlined, currently.
However, IMHO, it is not fail-safe coding.

I think we might better take care of someone who will modify the code
in the future. If they call those functions from other place,
it will not be inlined, and may be placed out of .kprobes.text.
In that case, we can not prevent inserting kprobes in those functions.

Thus, I recommend you to add __kprobes on those functions.
That indicates which functions will be used by kprobes and gives
hints how to write functions which will be called from kprobes.
(And also, it simplifies coding rule.)

Thank you,

> 
> Harvey
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

