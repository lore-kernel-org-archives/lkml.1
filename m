Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268Ab0ARQAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0ARQAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138Ab0ARP77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:59:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab0ARP76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:59:58 -0500
Message-ID: <4B548562.6030008@redhat.com>
Date: Mon, 18 Jan 2010 10:59:30 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, rostedt@goodmis.org,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com>	<a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>	<1263483139.28171.3857.camel@gandalf.stny.rr.com>	<4B4F3A1A.2030906@zytor.com>	<20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org>
In-Reply-To: <20100117111608.35a98ee2@infradead.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 17 Jan 2010 13:55:39 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
>> * H. Peter Anvin (hpa@zytor.com) wrote:
>>> On 01/14/2010 07:32 AM, Steven Rostedt wrote:
>>>>> +
>>>>> +	/* Replacing 1 byte can be done atomically. */
>>>>> +	if (unlikely(len <= 1))
>>>>> +		return text_poke(addr, opcode, len);
>>>>
>>>> This part bothers me. The text_poke just writes over the text
>>>> directly (using a separate mapping). But if that memory is in the
>>>> pipeline of another CPU, I think this could cause a GPF.
>>>>
>>>
>>> Could you clarify why you think that?
>>
>> Basically, what Steven and I were concerned about in this particular
>> patch version is the fact that this code took a "shortcut" for
>> single-byte text modification, thus bypassing the int3-bypass scheme
>> altogether.
> 
> single byte instruction updates are likely 100x safer than any scheme
> of multi-byte instruction scheme that I have seen, other than a full
> stop_machine().
> 
> That does not mean it is safe, it just means it's an order of
> complexity less to analyze ;-)

Yeah, so in the latest patch, I updated it to use int3 even if
len == 1. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

