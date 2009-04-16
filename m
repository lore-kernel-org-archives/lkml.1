Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbZDPC5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbZDPC5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZDPC46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:56:58 -0400
Received: from gw.goop.org ([64.81.55.164]:55330 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZDPC45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:56:57 -0400
Message-ID: <49E69E76.9030608@goop.org>
Date: Wed, 15 Apr 2009 19:56:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
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
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal>
In-Reply-To: <20090416023456.GC22378@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Is your only problem the fact that tracepoints include rcupdate.h ?

No.  That was the first roadblock, which caused massive cyclic 
dependencies between includes and consequent failure to define 
everything required.  I solved that by pushing __DO_TRACE out of line.  
Everything since then is a separate issue.

>  This
> can easily be solved by moving rcu_read_(un)lock_sched_notrace to a
> rcu-update-<insert meaningful name here> and include this header in
> rcupdate.h and tracepoint.h.
>   
I suppose, but I think pushing __do_trace_##name out of line is cleaner 
anyway.  And I think it's very important that tracepoint.h have a 
*absolutely minimal* #include set, so that it can be safely included in 
as many contexts as possible.  asm/paravirt.h is complex enough as it 
is, and I really don't want tracepoint bringing in any extra headers at 
all.  linux/types.h is about the only acceptable one.

> If by doing these modifications we succeed in keeping the "void"
> parameters working _and_ make your stuff to compile, I think we would
> have done something great. :-)
>   

The void issue is irritating, but relatively minor compared to the 
rest.  If everything else gets solved except for the need to pass a 
dummy param to no-arg tracepoints, then I think it'll be a generally 
useful facility.

    J
