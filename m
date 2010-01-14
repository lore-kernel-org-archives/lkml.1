Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259Ab0ANQYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0ANQYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 11:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242Ab0ANQYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 11:24:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab0ANQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 11:24:35 -0500
Message-ID: <4B4F4507.2000108@redhat.com>
Date: Thu, 14 Jan 2010 11:23:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <20100114153908.GA3487@Krystal>
In-Reply-To: <20100114153908.GA3487@Krystal>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
>> On Tue, 2010-01-12 at 11:26 -0500, Jason Baron wrote:
>>
>>> +/**
>>> + * text_poke_fixup() -- cross-modifying kernel text with fixup address.
>>> + * @addr:	Modifying address.
>>> + * @opcode:	New instruction.
>>> + * @len:	length of modifying bytes.
>>> + * @fixup:	Fixup address.
>>> + *
>>> + * Note: You must backup replaced instructions before calling this,
>>> + * if you need to recover it.
>>> + * Note: Must be called under text_mutex.
>>> + */
>>> +void *__kprobes text_poke_fixup(void *addr, const void *opcode, size_t len,
>>> +				void *fixup)
>>> +{
>>> +	static const unsigned char int3_insn = BREAKPOINT_INSTRUCTION;
>>> +	static const int int3_size = sizeof(int3_insn);
>>> +
>>> +	/* Replacing 1 byte can be done atomically. */
>>> +	if (unlikely(len <= 1))
>>> +		return text_poke(addr, opcode, len);
>>
>> This part bothers me. The text_poke just writes over the text directly
>> (using a separate mapping). But if that memory is in the pipeline of
>> another CPU, I think this could cause a GPF.
> 
> It looks like we are thinking along the same lines.
> 
> I'm under the impression that I pointed out this exact same issue in the
> previous round of review a few weeks ago. Does this submission reflect
> the up-to-date state of this patch ?

No, the latest patch just skips step 3 if len == 1.
(Jason, could you update your repository?)
I thought I sent it the end of the last year ... :)

http://lkml.org/lkml/2009/12/18/312

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

