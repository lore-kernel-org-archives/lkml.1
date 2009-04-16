Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZDPXoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZDPXoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZDPXoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:44:15 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:54385 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZDPXoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:44:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAFAOJb50lMQW1W/2dsb2JhbACBTr5jkCmDfQY
Date: Thu, 16 Apr 2009 19:44:11 -0400
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
Message-ID: <20090416234410.GA20513@Krystal>
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49E69E76.9030608@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:42:01 up 47 days, 20:08,  3 users,  load average: 0.86, 0.55,
	0.44
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> Is your only problem the fact that tracepoints include rcupdate.h ?
>
> No.  That was the first roadblock, which caused massive cyclic  
> dependencies between includes and consequent failure to define  
> everything required.  I solved that by pushing __DO_TRACE out of line.   
> Everything since then is a separate issue.
>
>>  This
>> can easily be solved by moving rcu_read_(un)lock_sched_notrace to a
>> rcu-update-<insert meaningful name here> and include this header in
>> rcupdate.h and tracepoint.h.
>>   
> I suppose, but I think pushing __do_trace_##name out of line is cleaner  
> anyway.  And I think it's very important that tracepoint.h have a  
> *absolutely minimal* #include set, so that it can be safely included in  
> as many contexts as possible.  asm/paravirt.h is complex enough as it  
> is, and I really don't want tracepoint bringing in any extra headers at  
> all.  linux/types.h is about the only acceptable one.
>
>> If by doing these modifications we succeed in keeping the "void"
>> parameters working _and_ make your stuff to compile, I think we would
>> have done something great. :-)
>>   
>
> The void issue is irritating, but relatively minor compared to the rest.  
> If everything else gets solved except for the need to pass a dummy param 
> to no-arg tracepoints, then I think it'll be a generally useful facility.
>

The other point I dislike about the out-of-line approach is that the
tracer will suffer from a pointless supplementary function call at each
event. Given how slow function calls are, at least on x86, I'd prefer
leaving the handler call chain inline, unless there is a very strong
reason not to do so.

I'll come up with a patch that leaves the tracepoint inline, but fixes
the header dependency.

Mathieu

>    J
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
