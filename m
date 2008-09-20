Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYITXSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYITXSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYITXSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:18:47 -0400
Received: from ptb-relay02.plus.net ([212.159.14.146]:40418 "EHLO
	ptb-relay02.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYITXSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:18:47 -0400
Message-ID: <48D584D4.7070002@yahoo.com>
Date: Sun, 21 Sep 2008 00:18:44 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       astarikovskiy@suse.de
Subject: Re: Reading EeePC900 battery info causes stalls
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <alpine.DEB.1.10.0809200955360.12824@gandalf.stny.rr.com> <48D50498.5050608@yahoo.com> <alpine.DEB.1.10.0809201037070.13540@gandalf.stny.rr.com> <48D52FE3.6060803@yahoo.com> <alpine.DEB.1.10.0809201739170.18130@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809201739170.18130@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: a0bb44002c052f1e0f0563c87c2974d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Sat, 20 Sep 2008, Sitsofe Wheeler wrote:
> 
>> Thanks - this made the wakeup tracer appear a you said. I have put two wakeup
>> traces up:
>>
>> http://sucs.org/~sits/test/eeepc-debug/20080920/latency_trace.txt.gz
>> http://sucs.org/~sits/test/eeepc-debug/20080920/trace.txt.gz
>> (each file is around 6Mbytes uncompressed)
>>
>> Here's a small extract of latency_trace.txt:
>>
>>> # tracer: wakeup
>>> #
>>> wakeup latency trace v1.1.5 on 2.6.27-rc6skw-dirty
>>> --------------------------------------------------------------------
>>>  latency: 3232905 us, #65620/6180619, CPU#0 | (M:desktop VP:0, KP:0, SP:0
> 
> Peter, these times are crazy, mainly due to the cpu_clock. He probably 
> wants to use the sched_clock. Below is a patch to use it instead.
> 
> Sitsofe, I notice that the trace states "desktop". This means that you
> are running with CONFIG_PREEMPT_VOLUNTARY. You want 
> CONFIG_PREEMPT.

Dagnabit I keep confusing people. This was actually intentional because 
I wanted to know whether the latency I was seeing should have been 
present in a non-preempt (but voluntary) kernel. You can see the subject 
at that start of this thread: http://tinyurl.com/4akxa5 (How how latent 
should non-preemptive scheduling be?). I'm not running a sound studio 
where I need the lowest possible latency at all costs. Further my 
current understanding is that the desktop distros don't tend to ship 
"regular desktop kernels" with preemption (I know Ubuntu 8.04 and Fedora 
9 didn't).

Basically I have the following queries: Do you have to have preemption 
on if you are listening to music (without noticeable skips) and playing 
the odd game (without noticeable pauses) on a desktop? What's the 
allowed highest latency going to be over a few minutes in such kernels? 
Is it simply the case that if it's a non-preemptive kernel latency no 
longer matters?

Just for the record I just tested a preempt kernel I had lying around 
and the speakter-test -b75000 while looking at battery did not stall. 
However latencytop still reported a "waiting for cpu" value of 75ms.

> [...]
>> Is it intentional that the last event has a time earlier closer to that of the
>> first event?
>>
> 
> Change the config, and see what you get with this patch:

I'll see if I can test the patch tomorrow. Does the config change also 
have to be made or the timestamps to be "narrower"?

-- 
Sitsofe | http://sucs.org/~sits/
