Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268Ab0ARUxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0ARUxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120Ab0ARUxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:53:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0ARUxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:53:48 -0500
Message-ID: <4B54CA2F.1050604@redhat.com>
Date: Mon, 18 Jan 2010 15:53:03 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Arjan van de Ven <arjan@infradead.org>, rostedt@goodmis.org,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <4B4F3A1A.2030906@zytor.com> <20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org> <4B548562.6030008@redhat.com> <4B548B09.7040309@zytor.com> <20100118165231.GA29764@Krystal> <4B54AD7C.9000505@zytor.com>
In-Reply-To: <4B54AD7C.9000505@zytor.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 01/18/2010 08:52 AM, Mathieu Desnoyers wrote:
>>>
>>> This really doesn't make much sense to me.  The whole basis for the int3
>>> scheme itself is that single-byte updates are atomic, so if single-byte
>>> updates can't work -- and as I stated, we at Intel OTC currently believe
>>> it safe -- then int3 can't work either.
>>
>> The additional characteristic of the int3 instruction (compared to the
>> general case of a single-byte instruction) is that, when executed, it
>> will trigger a trap, run a trap handler and return to the original code,
>> typically with iret. This therefore implies that a serializing
>> instruction is executed before returning to the instructions following
>> the modification site when the breakpoint is hit.
>>
>> So I hand out to Intel's expertise the question of whether single-byte
>> instruction modification is safe or not in the general case. I'm just
>> pointing out that I can very well imagine an aggressive superscalar
>> architecture for which pipeline structure would support single-byte int3
>> patching without any problem due to the implied serialization, but would
>> not support the general-case single-byte modification due to its lack of
>> serialization.
>>
> 
> This is utter and complete nonsense.   You seem to think that everything
> is guaranteed to hit the breakpoint, which is obviously false.
> Furthermore, until you have done the serialization, you're not
> guaranteed the *breakpoint* is seen, so you have the same condition.

In that time frame, I guess that the processor sees non-modified
instruction and executes it. Since we'll wait until serializing on
each processor, I think it is OK for int3-bypass method.

(Of course, this can depend on chip, it is possible that there is a chip
 which causes a fault when it has a cache-discarding signal on current-
 instruction decoding slot. That's also why we are asking this method
 is OK for x86 processors.)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

