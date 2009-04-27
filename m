Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZD0PoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZD0PoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZD0PoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:44:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469AbZD0PoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:44:08 -0400
Date: Mon, 27 Apr 2009 17:43:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, zhaolei@cn.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
	worklet lifecycle tracing
Message-ID: <20090427154327.GA29921@elte.hu>
References: <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org> <20090425003702.GC6658@nowhere> <20090424182821.8263f445.akpm@linux-foundation.org> <20090426104747.GA5983@elte.hu> <20090426224450.8ea9f724.akpm@linux-foundation.org> <20090427150241.GA23700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427150241.GA23700@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/26, Andrew Morton wrote:
> >
> > Most workqueue work lately has come from Oleg.  I'm unaware that 
> > he has expressed an interest in this feature?  Oleg, would it 
> > have been useful in any of the work you've done?
> 
> Well. Probably not. But I don't think this matters. Other people 
> (and not only kernel developers) can find this useful.
> 
> I _think_ that if you are going to hack workqueue.c itself, it is 
> more easy to just add some printks, may be I am wrong. But, 
> probably tracepoints can help to write/debug, say, device drivers. 
> Or admins can use debugfs to see whats going on, or to provide 
> more info for the bugreports.
> 
> I try to avoid "do we need this feauture" discussions as much as 
> possible. Because I never know. My usage of kernel is very, very 
> limited, I never do something "interesting" on my machine. This 
> reminds me the discussion about the ability to trace /sbin/init. 
> Some developers were unhappy with the trivial patch I sent. They 
> said it is trivial to change your kernel if you need this. But no, 
> it was not trivial to me when I was admin. So, I just can't judge.
> 
> > > And the thing is, the workqueue code has been pretty 
> > > problematic lately - with lockups and other regressions.
> 
> Hmm. Perhaps I missed some bug-reports... But I don't remember any 
> recent problems with workueues except the "usual" bugs like "flush 
> shares the lock with work->func".

Sorry - i mean lockups while _using_ workqueues. The workqueue code 
has been pretty OK - sans that thing with work_on_cpu() which was 
quite a pain with 4-5 regressions IIRC. So generally workqueue usage 
isnt particularly well developed - and having some basic 
instrumentation increases mindshare. IMHO.

> As for the patches, I can't review them now. They are on top of 
> some other changes which I didn't see (or perhaps I lost the 
> patches I was cc'ed? sorry in this case).

it's against the tracing tree - which has new/changed facilities 
which these patches are against. I think Frederic can send you an 
URI to a branch in his tree with these bits properly added in, for 
review. (a full patch in that case would be useful too i guess)

> But at least the change in workqueue.c looks very simple, and do 
> not complicate the code for readers. And, if we add any tracing to 
> workqueues, then it is very natural to add entry/exit handlers.

thanks!

> I must admit, I don't really understand why trace_workqueue.c uses 
> cwq->thread as a "primary key". I have the feeling we can simplify 
> this code if we pass "struct workqueue_struct *" instead, but I am 
> not sure.
> 
> In particular, trace_workqueue_flush(cwq->thread) looks a bit 
> strange to me. I can't imagine how it can be useful per-thread and 
> without trace_workqueue_flush_end() or something. I mean, if we 
> need to trace flushes, then imho it makes much more sense to add 
> flush_start/flush_end handlers into flush_workqueue().

If this is fixed (and no other problem surfaces), would you mind to 
ack these bits?

And if you can think of any way to make it even simpler / less 
intrusive, please let us know ...

	Ingo
