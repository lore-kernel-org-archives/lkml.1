Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZDPCk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZDPCk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZDPCkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:40:12 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:49786 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZDPCkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:40:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMFAJA05klMQW1W/2dsb2JhbACBUc84g30G
Date: Wed, 15 Apr 2009 22:34:56 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
Message-ID: <20090416023456.GC22378@Krystal>
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49E6065B.7080409@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:31:00 up 46 days, 22:57,  1 user,  load average: 0.93, 0.64,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>>> -#define __DO_TRACE(tp, proto, args)					\
>>> -	do {								\
>>> +#define DEFINE_DO_TRACE(name, proto, args)				\
>>> +	void __do_trace_##name(struct tracepoint *tp, TP_PROTO(proto))	\
>>>     
>>
>> I fear that won't work with "void" prototype. If we need this kind of
>> flexibility, we will need to create a special case for empty prototype.
>>   
>
> Yes, that has been a bit awkward.  I couldn't find a way to create a  
> no-param tracepoint, and so ended up passing a dummy arg.  Stupid C 
> syntax.
>
> On the other hand, I can get something that actually compiles this way...
>
>    J

Is your only problem the fact that tracepoints include rcupdate.h ? This
can easily be solved by moving rcu_read_(un)lock_sched_notrace to a
rcu-update-<insert meaningful name here> and include this header in
rcupdate.h and tracepoint.h.

We could keep the indirection layer you proposed for synchronize_sched()
though, even if it adds an unnecessary function call. It's a slow path
anyway.

If by doing these modifications we succeed in keeping the "void"
parameters working _and_ make your stuff to compile, I think we would
have done something great. :-)

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
