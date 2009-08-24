Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZHXIla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZHXIla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZHXIl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:41:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41790 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZHXIl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:41:27 -0400
Date: Mon, 24 Aug 2009 10:41:01 +0200
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
Message-ID: <20090824084101.GE2424@elte.hu>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824014025.GA12653@linux-sh.org>
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

> On Sun, Aug 23, 2009 at 11:14:24PM +0200, Frederic Weisbecker wrote:
> > On Fri, Aug 21, 2009 at 09:58:43PM -0700, Josh Stone wrote:
> > > The bodies of syscall_regfunc and syscall_unregfunc need the
> > > arch-specific flag TIF_SYSCALL_TRACEPOINT, which only exists
> > > on x86 and s390, so they should live in arch-specific files.
> > 
> > Sh also does, but currently in a seperate development branch. 
> > (Adding Paul Mundt in Cc to prevent from further linux-next 
> > breakage).
> 
> Thanks, I'll take care of this as well as the other ftrace 
> syscalls breakage during the merge window. At the moment I don't 
> have any good ideas on how to fix the workflow issues, and -tip 
> likewise doesn't care about -next impact, so there's somewhat of 
> an impasse.

Where did you take the nonsense from that '-tip likewise doesn't 
care about -next impact'? It's a false statement on several levels.

The thing is, there is just a single 'breakage' here (SH does not 
build if the tracing tree is mixed with the SH tree), and you 
inflicted it upon yourself: you mixed ftrace development into the SH 
tree (thinking that the syscall-tracing facility was a stable API - 
where did _that_ nonsense come from?), while the tracing tree did 
development of ftrace too (surprise), so when the two versions were 
mixed in linux-next it broke.

There's numerous ways to resolve this and i'm willing to help out 
with any of the solutions your chose (or with some other variant if 
it makes sense):

 - Easiest: you can turn off the old-API based ftrace bits in the SH 
   tree, in your for-next branch. This is the easiest, but keeps new 
   SH ftrace bits untested in linux-next.

 - Most conservative route: you wait with your new bits until the 
   new tracing facilities hit upstream in the merge window. The
   disadvantage is that this delays your code and there's no 
   guarantee that it cannot collide with new changes.

 - The proper workflow: you can actually help out the development of 
   tracing facilities by doing tracing development in the tracing 
   tree. We merged a number of architecture ftrace improvements via 
   the tracing tree already, as long as it's acked by the maintainer 
   (which is a given here - you maintain SH) and as long as it does 
   not touch non-ftrace bits of the architecture unreasonably.

   This is the most natural workflow and the fastest one as well. 
   The ftrace bits are well separated (or should be well separated). 
   We didnt do ftrace development via the x86 tree either.

I'd favor the third one as it's the most intelligent variant and we 
used that in a number of other cases - but it's up to you.

	Ingo
