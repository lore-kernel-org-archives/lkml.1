Return-Path: <linux-kernel-owner+w=401wt.eu-S1762745AbZD1Qsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbZD1Qsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZD1QsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:48:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51314 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbZD1QsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:48:22 -0400
Date: Tue, 28 Apr 2009 18:43:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       zhaolei@cn.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
       rostedt@goodmis.org, tzanussi@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
	worklet lifecycle tracing
Message-ID: <20090428164342.GA27584@redhat.com>
References: <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org> <20090425003702.GC6658@nowhere> <20090424182821.8263f445.akpm@linux-foundation.org> <20090426104747.GA5983@elte.hu> <20090426224450.8ea9f724.akpm@linux-foundation.org> <20090427150241.GA23700@redhat.com> <20090428134209.GA5978@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428134209.GA5978@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Frederic Weisbecker wrote:
>
> On Mon, Apr 27, 2009 at 05:02:41PM +0200, Oleg Nesterov wrote:
> >
> > I must admit, I don't really understand why trace_workqueue.c uses
> > cwq->thread as a "primary key". I have the feeling we can simplify
> > this code if we pass "struct workqueue_struct *" instead, but I am
> > not sure.
>
> Indeed, I wanted to use it as the identifier first. The problem
> is that this structure is privately defined inside kernel/workqueue.c

Perhaps we have to export some bits or add some simple helpers to
workqueue.c. But I am not sure trace/trace_workqueue.c actually needs
any additional info. Again, we can use "struct workqueue_struct *" as
a "void *", and probe_workqueue_creation() can use alloc_percpu() to
record the events per-cpu. (_Perhaps_, we can also add some fields
to workqueue_struct or cpu_workqueue_struct under #ifdef and eliminate
the list search code in trace_workqueue.c).

> But actually it's not really a 1:1 matching in CONFIG_HOTPLUG_CPU
> case, because the thread can destroyed and the cpu_workqueue assigned
> with a new one later.

Indeed, I also thought about this. This is subjective, but perhaps it
is better to keep the history. If not, we can clear it on CPU_DEAD.



But let me repeat, I am not very sure these changes are really good,
and I didn't try to really think about them. Even _if_ I am right
we can do this later.


> I'm currently gathering Zhaolei patches and I will push them all in
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
>  tracing/workqueue

Thanks! Will try to look when I have the chance. Not that I think
I can really help though ;)

Oleg.

