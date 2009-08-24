Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZHXJ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZHXJ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZHXJ5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:57:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35796 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZHXJ5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:57:20 -0400
Date: Mon, 24 Aug 2009 11:56:52 +0200
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
Message-ID: <20090824095652.GC25267@elte.hu>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org> <20090824084101.GE2424@elte.hu> <20090824085944.GA15330@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824085944.GA15330@linux-sh.org>
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

> On Mon, Aug 24, 2009 at 10:41:01AM +0200, Ingo Molnar wrote:
> > * Paul Mundt <lethal@linux-sh.org> wrote:
> > > On Sun, Aug 23, 2009 at 11:14:24PM +0200, Frederic Weisbecker wrote:
> > > > On Fri, Aug 21, 2009 at 09:58:43PM -0700, Josh Stone wrote:
> > > > > The bodies of syscall_regfunc and syscall_unregfunc need the
> > > > > arch-specific flag TIF_SYSCALL_TRACEPOINT, which only exists
> > > > > on x86 and s390, so they should live in arch-specific files.
> > > > 
> > > > Sh also does, but currently in a seperate development branch. 
> > > > (Adding Paul Mundt in Cc to prevent from further linux-next 
> > > > breakage).
> > > 
> > > Thanks, I'll take care of this as well as the other ftrace 
> > > syscalls breakage during the merge window. At the moment I don't 
> > > have any good ideas on how to fix the workflow issues, and -tip 
> > > likewise doesn't care about -next impact, so there's somewhat of 
> > > an impasse.
> > 
> > Where did you take the nonsense from that '-tip likewise doesn't 
> > care about -next impact'? It's a false statement on several levels.
> > 
> > The thing is, there is just a single 'breakage' here (SH does 
> > not build if the tracing tree is mixed with the SH tree), and 
> > you inflicted it upon yourself: you mixed ftrace development 
> > into the SH tree (thinking that the syscall-tracing facility was 
> > a stable API - where did _that_ nonsense come from?), while the 
> > tracing tree did development of ftrace too (surprise), so when 
> > the two versions were mixed in linux-next it broke.
> 
> I think this is the source of confusion, given that I expected the 
> interface would remain reasonable stable until all of the existing 
> users had had a chance to catch up. [...]

All existing upstream users of APIs were fixed up. Which was x86 and 
s390. (and yes, we initially missed s390)

Stable APIs are not how upstream Linux kernel development works - it 
would be way too inflexible.

Instead facility trees (such as the tracing tree) are either 
expected to convert all upstream API uses (which we did), or are 
supposed to provide different versions of APIs, if an API is so 
widespread (used by hundreds of callsites, etc.) that it's not 
reasonable to convert it in one go.

> [...] As it is now it is impossible to make any changes to things 
> that are taken over by -tip given that the first sign of there 
> being any changes are failures introduced through -next, which 
> would have been avoided if folks eagerly merging things in to -tip 
> considered the implications for -next.

Paul, what you say is not making any sense to me. All those ftrace 
patches were sent to lkml multiple times (as all ftrace patches), so 
if you wanted you could have known about them.

If there's someone who failed to notify it was _you_. You might as 
well have Cc:-ed the guys who wrote the code you started using in 
SH.

> Pointing fingers however is rather pointless at this stage, and is 
> not what I am trying to do. [...]

( Hey what was the purpose of the previous 3 paragraphs then? ;-)

> [...] I've lost count of the number of times -tip has broken 
> things in -next that were easily avoidable, [...]

Do you realize that 1) what you say is false 2) we push thousands of 
commits so even if it was true it would be natural relative to the 
number of kernel developers who work on the various -tip based 
trees?

I know it as i always cross-build SH (too) before i push out to 
linux-next. I dont remember a _single_ SH breakage in the past few 
months, and we push thousands of commits. In fact the last time the 
ftrace tree broke linux-next was 8 months ago:

  Date: Wed, 7 Jan 2009 10:55:05 +0100
  From: Ingo Molnar <mingo@elte.hu>
  To: Stephen Rothwell <sfr@canb.auug.org.au>
  Subject: Re: linux-next: ftrace tree build failure

and that too was a breakage already fixed by the time it got 
reported.

So i'd really like you to back up your claims with facts. Your mail 
is basically unsubstantiated FUD right now and i'll just ignore you 
if you continue this pattern of unsubstantiated attacks and 
unconstructive behavior.

( Also, could you please fix your mailer so that it does not damage 
  threads? It generates such bogus headers:

    Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
        Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       	Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jiaying Zhang <jiayingz@google.com>,
        Martin Bligh <mbligh@google.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>

  which messes up replies. )

Thanks,

	Ingo
