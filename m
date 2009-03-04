Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZCDDYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZCDDYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZCDDYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:24:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55748 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZCDDYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:24:00 -0500
Date: Tue, 3 Mar 2009 22:23:57 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: Re: [PATCH 0/5] [RFC] binary reading of ftrace ring buffers
In-Reply-To: <alpine.DEB.2.00.0903032200260.5939@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903032222160.6862@gandalf.stny.rr.com>
References: <20090304024921.153061228@goodmis.org> <alpine.DEB.2.00.0903032200260.5939@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 3 Mar 2009, Steven Rostedt wrote:

> 
> On Tue, 3 Mar 2009, Steven Rostedt wrote:
> 
> > Yes you can run multiple instances of this on different buffers.
> > 
> >  # ./rb-read.pl /tmp/buf-0
> > 
> > produces:
> > 
> >         0  [000]  7071.936459: (irq_handler_entry) irq 48
> >         0  [000]  7071.936462: (irq_handler_exit) irq 48 ret 1
> >         0  [000]  7071.988801: (sched_signal_send) sig: 14  task 0
> >         0  [000]  7071.988813: (sched_wakeup) task 0 success=1
> >         0  [000]  7071.988823: (sched_switch) prev 0:140 ==> next ntpd:6582272:0
> >      3303  [000]  7071.988916: (sched_switch) prev 0:120 ==> next swap:7497072:0
> >         0  [000]  7072.020370: (sched_wakeup) task 0 success=1
> >         0  [000]  7072.020407: (sched_switch) prev 0:140 ==> next even:808416116:0
> 
> My perl script is still a bit buggy, but you get the idea ;-)

Uploaded a fix:

         0  [000]  7071.936459: (irq_handler_entry) irq 48
         0  [000]  7071.936462: (irq_handler_exit) irq 48 ret 1
         0  [000]  7071.988801: (sched_signal_send) sig: 14  task 3303
         0  [000]  7071.988813: (sched_wakeup) task 3303 success=1
         0  [000]  7071.988823: (sched_switch) prev 0:140 ==> next ntpdpd:3303:120
      3303  [000]  7071.988916: (sched_switch) prev 3303:120 ==> next swapper:0:140
         0  [000]  7072.020370: (sched_wakeup) task 16 success=1
         0  [000]  7072.020407: (sched_switch) prev 0:140 ==> next events/0:16:115
        16  [000]  7071.936157: (sched_switch) prev 16:115 ==> next swapper:0:140

Much better.

I just used the same binary image. The bug was in the perl script.

-- Steve

