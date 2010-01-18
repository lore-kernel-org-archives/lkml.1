Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984Ab0ARVWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab0ARVWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574Ab0ARVWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:22:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50118 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab0ARVW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:22:29 -0500
Message-ID: <4B54D01C.1070505@zytor.com>
Date: Mon, 18 Jan 2010 13:18:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Arjan van de Ven <arjan@infradead.org>, rostedt@goodmis.org,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <4B4F3A1A.2030906@zytor.com> <20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org> <4B548562.6030008@redhat.com> <4B548B09.7040309@zytor.com> <20100118165231.GA29764@Krystal> <4B54AD7C.9000505@zytor.com> <4B54CA2F.1050604@redhat.com>
In-Reply-To: <4B54CA2F.1050604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:53 PM, Masami Hiramatsu wrote:
>>
>> This is utter and complete nonsense.   You seem to think that everything
>> is guaranteed to hit the breakpoint, which is obviously false.
>> Furthermore, until you have done the serialization, you're not
>> guaranteed the *breakpoint* is seen, so you have the same condition.
> 
> In that time frame, I guess that the processor sees non-modified
> instruction and executes it. Since we'll wait until serializing on
> each processor, I think it is OK for int3-bypass method.
> 
> (Of course, this can depend on chip, it is possible that there is a chip
>  which causes a fault when it has a cache-discarding signal on current-
>  instruction decoding slot. That's also why we are asking this method
>  is OK for x86 processors.)
> 

Yes, it is possible, however, if that was the case, then int3 wouldn't
work either.  As I said, to the best of our knowledge, at least Intel
processors are okay for a single-byte update (I will wait to try to
state the full general rule until it has been officially approved or
killed.)

	-hpa

