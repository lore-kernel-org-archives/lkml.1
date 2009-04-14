Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbZDNSgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbZDNSgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbZDNSga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:36:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35234 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759301AbZDNSg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:36:29 -0400
Date: Tue, 14 Apr 2009 20:35:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
Message-ID: <20090414183521.GA11214@elte.hu>
References: <20090414172337.280621613@goodmis.org> <20090414182100.GB19814@elte.hu> <alpine.DEB.2.00.0904141431530.31421@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904141431530.31421@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 14 Apr 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > >  include/trace/define_trace.h        |   79 ++++++
> > >  include/trace/ftrace.h              |  493 +++++++++++++++++++++++++++++++++++
> > >  include/trace/irq.h                 |   56 ++++-
> > >  include/trace/irq_event_types.h     |   55 ----
> > >  include/trace/kmem.h                |  189 +++++++++++++-
> > >  include/trace/lockdep.h             |   55 ++++-
> > >  include/trace/lockdep_event_types.h |   57 ----
> > >  include/trace/sched.h               |  336 +++++++++++++++++++++++-
> > >  include/trace/sched_event_types.h   |  337 ------------------------
> > >  include/trace/skb.h                 |   39 +++-
> > >  include/trace/skb_event_types.h     |   38 ---
> > >  include/trace/trace_event_types.h   |    7 -
> > >  include/trace/trace_events.h        |    7 -
> > 
> > Detail: we still have include/trace/kmem_event_types.h around - is 
> > that intentional? It isnt actually used by anything so we can git-rm 
> > it.
> 
> I rebased it several times, doing minor tweaks and such. I think I may 
> have missed a git-rm. That file is suppose to be deleted.
> 
> > 
> > Also, we mix tracepoint definition headers with other misc headers 
> > such as syscall.h or boot.h.
> > 
> > I think it would be cleaner and better sructured to have these 
> > centrally enumerated tracepoint definitions separated in 
> > include/trace/events/.
> > 
> > That sub-directory would _only_ include the TRACE_EVENT() 
> > definitions - nothing else. Hence it would also be a nice in-situ 
> > template collection for anyone adding new tracepoints. The existence 
> > of other headers really distracts from that.
> > 
> > What do you think?
> 
> I'm fine with that. As long as people are fine with doing:
> 
> #include <trace/events/sched.h>
> 
> and such.

Yes, i think it's very clear that way: trace/events/*.h bits are for 
tracepoint definitions.

	Ingo
