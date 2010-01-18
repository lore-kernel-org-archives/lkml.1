Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688Ab0ARQ1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0ARQ1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052Ab0ARQ1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:27:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0ARQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:27:40 -0500
Message-ID: <4B548B09.7040309@zytor.com>
Date: Mon, 18 Jan 2010 08:23:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, rostedt@goodmis.org,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com>	<a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com>	<1263483139.28171.3857.camel@gandalf.stny.rr.com>	<4B4F3A1A.2030906@zytor.com>	<20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org> <4B548562.6030008@redhat.com>
In-Reply-To: <4B548562.6030008@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 07:59 AM, Masami Hiramatsu wrote:
>>>>>
>>>>> This part bothers me. The text_poke just writes over the text
>>>>> directly (using a separate mapping). But if that memory is in the
>>>>> pipeline of another CPU, I think this could cause a GPF.
>>>>>
>>>>
>>>> Could you clarify why you think that?
>>>
>>> Basically, what Steven and I were concerned about in this particular
>>> patch version is the fact that this code took a "shortcut" for
>>> single-byte text modification, thus bypassing the int3-bypass scheme
>>> altogether.
>>
>> single byte instruction updates are likely 100x safer than any scheme
>> of multi-byte instruction scheme that I have seen, other than a full
>> stop_machine().
>>
>> That does not mean it is safe, it just means it's an order of
>> complexity less to analyze ;-)
> 
> Yeah, so in the latest patch, I updated it to use int3 even if
> len == 1. :-)
> 

This really doesn't make much sense to me.  The whole basis for the int3
scheme itself is that single-byte updates are atomic, so if single-byte
updates can't work -- and as I stated, we at Intel OTC currently believe
it safe -- then int3 can't work either.

The one thing to watch out for is that unless you force an IPI/IRET
cycle afterwards, you can't know when any particular remote processor
will see the update.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

