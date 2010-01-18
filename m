Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815Ab0ARSVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab0ARSVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933Ab0ARSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:21:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab0ARSVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:21:35 -0500
Message-ID: <4B54A68E.4050409@redhat.com>
Date: Mon, 18 Jan 2010 13:21:02 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       rostedt@goodmis.org, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <4B4F3A1A.2030906@zytor.com> <20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org> <4B548562.6030008@redhat.com> <20100118083129.675edb83@infradead.org> <20100118165443.GB29764@Krystal>
In-Reply-To: <20100118165443.GB29764@Krystal>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Arjan van de Ven (arjan@infradead.org) wrote:
>> On Mon, 18 Jan 2010 10:59:30 -0500
>> Masami Hiramatsu <mhiramat@redhat.com> wrote:
>>
>>> Yeah, so in the latest patch, I updated it to use int3 even if
>>> len == 1. :-)
>>>
>>
>>
>> int3 is not making a difference for your case; there is no guarantee
>> that the other processor even sees the "int3 inbetween state" at all;
>> if it's not safe without int3 then it won't be safe with int3 either.
> 
> What Masami means is that he updated his patch to use the int3+IPI
> broadcast scheme.

Right.

> 
> Therefore, the CPUs not seeing the int3 inbetween state will be forced
> to issue a serializing instruction while the int3 is in place anyway.

By the way, in kprobes, we just use a text_poke() to put int3.
I assume that we'd better send IPI afterward, wouldn't it?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

