Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZHXLBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZHXLBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZHXLBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:01:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42850 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZHXLA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:00:59 -0400
Date: Mon, 24 Aug 2009 13:00:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824110040.GA4050@elte.hu>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org> <20090824084101.GE2424@elte.hu> <20090824085944.GA15330@linux-sh.org> <20090824095652.GC25267@elte.hu> <20090824103251.GA18106@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824103251.GA18106@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mundt <lethal@linux-sh.org> wrote:

> On Mon, Aug 24, 2009 at 11:56:52AM +0200, Ingo Molnar wrote:
> > * Paul Mundt <lethal@linux-sh.org> wrote:
> > > I think this is the source of confusion, given that I expected the 
> > > interface would remain reasonable stable until all of the existing 
> > > users had had a chance to catch up. [...]
> > 
> > All existing upstream users of APIs were fixed up. Which was x86 and 
> > s390. (and yes, we initially missed s390)
> > 
> > Stable APIs are not how upstream Linux kernel development works - it 
> > would be way too inflexible.
> > 
> > Instead facility trees (such as the tracing tree) are either 
> > expected to convert all upstream API uses (which we did), or are 
> > supposed to provide different versions of APIs, if an API is so 
> > widespread (used by hundreds of callsites, etc.) that it's not 
> > reasonable to convert it in one go.
> 
> No Ingo, this is not what you did, this is what you did after the 
> breakage was pointed out to you. [...]

As i explained it to you back then the s390 support was 1) a few 
weeks old 2) got masked due to an unrelated thing. In any case the 
bug was real and it was fixed very quickly within an hour or so of 
the report in the usual workflow and without any argument about it, 
and in total agreement with the s390 folks.

And the thing is, s390 was always a pleasure to deal with. I cannot 
say the same about anything SH. SH always was a huge PITA to deal 
with (to me at least), mainly because you seem to have a false sense 
of entitlement: you think everyone else must be perfect and must not 
affect you while you can sit on your own little island not worrying 
about the rest of the world - who develops and tests core kernel 
facilities for you. It doesnt work like that.

> [...] And before that, you had:
> 
> commit 60d970c254b95ec7a0fc4c590b510253987b64a0
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Aug 13 23:37:26 2009 +0200
> 
>     tracing: Fix syscall tracing on !HAVE_FTRACE_SYSCALLS architectures
> 
>     The new syscall_regfunc()/unregfunc() functions rely on
>     the existence of TIF_SYSCALL_FTRACE - but that TIF flag
>     is only offered by HAVE_FTRACE_SYSCALLS.
> 
>     Cc: Frederic Weisbecker <fweisbec@gmail.com>
>     Cc: Jason Baron <jbaron@redhat.com>
>     Cc: Steven Rostedt <rostedt@goodmis.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     LKML-Reference: <new-submission>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Which you at least managed to catch before it went in to -next.

See that LKML-Reference tag? That patch too went out to lkml. Had 
you chosen to participate instead of just complaining you could 
have.

Then you intentionally chose the wrong workflow and now you are 
complaining 1) about an easily fixed bug that got addressed within 
an hour of it reported 2) about a workflow situation you yourself 
created. [and to which i suggested several alternatives how to fix 
it.]

You are not being constructive at all.

	Ingo
