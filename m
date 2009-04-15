Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbZDOIbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbZDOIbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758636AbZDOIah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:30:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758508AbZDOIaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:30:30 -0400
Date: Wed, 15 Apr 2009 10:29:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
Message-ID: <20090415082931.GF18192@elte.hu>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu> <49E504C1.9010401@goop.org> <alpine.DEB.2.00.0904141753500.31421@gandalf.stny.rr.com> <49E50F2F.5070507@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E50F2F.5070507@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Steven Rostedt wrote:
>> On Tue, 14 Apr 2009, Jeremy Fitzhardinge wrote:
>>
>>   
>>> Theodore Tso wrote:
>>>     
>>>> Any chance you could support something like this?
>>>>
>>>>         
>>> I think that's already there.  I'm defining
>>> arch/x86/include/asm/paravirt-trace.h with:
>>>
>>> #ifndef _ASM_X86_PARAVIRT_TRACE_H
>>> #define _ASM_X86_PARAVIRT_TRACE_H
>>>
>>> #include <linux/tracepoint.h>
>>> #include <asm/paravirt_types.h>
>>>
>>> #undef TRACE_SYSTEM
>>> #define TRACE_SYSTEM pvops
>>>
>>> #define TRACE_INCLUDE_FILE	paravirt-trace
>>> #define TRACE_INCLUDE_PATH	asm
>>> [...]
>>>
>>>
>>> Which ends up including <asm/paravirt-trace.h>
>>>     
>>
>> Not quite. It ends up looking like
>>
>> #include "asm/paravirt-trace.h"
>>
>> As long as there is no "asm" directory in the include/trace directory, 
>> I think that is fine.
>
> OK.
>
> I'm having a bit of trouble with paravirt-trace.h when I actually 
> include it in paravirt.h.  asm/paravirt.h is itself included in 
> lots of places, and so its fairly easy to end up with cyclic 
> include dependencies which are fairly painful.  In this case I'm 
> seeing asm/paravirt.h -> linux/tracepoint.h -> linux/rcupate.h -> 
> {lots of stuff}, which gives errors like:

tracepoint.h should not include any complex headers like rcupdate.h.

> I'm wondering if there's much downside in making the code 
> __DO_TRACE() out of line so that we can make tracepoint.h have 
> absolutely minimal include dependencies?

yeah.

And besides, the rcu_read_lock_sched_notrace() there should probably 
be a preempt_disable_notrace() / preempt_enable_notrace() variant. 
(it's sligtly faster that way and we better be atomic and 
self-sufficient in tracepoints anyway)

	Ingo
