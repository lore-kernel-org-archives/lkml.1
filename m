Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0CEWdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:33:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab0CEWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:33:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=duQcPVr6eVUgdmzlgkm3v7aPjVfUUcdX4n84dDGLGIFZEcQYfGfoE1HELFGgiX7qg
	gDVYhKRQF9sRIMUXe6xGg==
MIME-Version: 1.0
In-Reply-To: <1267827943.4997.56.camel@laptop>
References: <20100305153926.639506880@chello.nl>
	 <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
	 <1267816553.4942.6.camel@laptop> <1267823134.4997.5.camel@laptop>
	 <bd4cb8901003051322l1722fcaaqacf0c913853d384f@mail.gmail.com>
	 <1267824933.4997.9.camel@laptop>
	 <bd4cb8901003051338p1c12ceacv994bad73e81093a2@mail.gmail.com>
	 <1267825433.4997.14.camel@laptop>
	 <bd4cb8901003051357o357ac7adt7cb56b5deb4089dd@mail.gmail.com>
	 <1267827943.4997.56.camel@laptop>
Date: Fri, 5 Mar 2010 14:33:19 -0800
Message-ID: <bd4cb8901003051433l3ef94874r94efd5b50251766c@mail.gmail.com>
Subject: Re: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 2:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-03-05 at 13:57 -0800, Stephane Eranian wrote:
>
>> When I read AJ68, my understanding is that it's not that you do not
>> get the interrupt. It will be delayed by one event. The buffer will become
>> full. You won't overrun the buffer, you will get the interrupt at the next
>> event. On interrupt, you have to reset the PEBS position pointer anyway.
>> There is already a disconnect between the sampling period and the actual
>> instruction sampled. That's not making the situation that much worse, unless
>> I am missing something.
>
> The current code doesn't use the buffering at all, it uses single-shot
> PEBS by keeping pebs_event_reset 0 and setting a threshold of a single
> entry, so if due to AJ68 we miss a PMI it will never come.
>
What stops PEBS is that it crosses the end of the buffer. The buffer
is one-deep,
threshold = buffer end, you get a single sample. reset has nothing to
do with this.

AJ68 does not say you miss a PMI, it says the PMI comes at the next
event. I suspect they mean the next observed event, and not necessarily
the next recorded event. But I can check on that.


> I guess we can fudge something, but at what point does the whole thing
> stop being useful?

What matters is that you get a valid sample.

>
> It would end up being something with fuzzy period and fuzzy location,
> which is a loss-loss situation if you ask me.
>
The period is already fuzzy to begin with. Recall our discussion a couple
of weeks back.
