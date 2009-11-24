Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbZKXKON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbZKXKON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932617AbZKXKOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:14:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbZKXKOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:14:08 -0500
Date: Tue, 24 Nov 2009 11:13:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v6] hw-breakpoints: Rewrite on top of perf events v6
Message-ID: <20091124101342.GB5570@elte.hu>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
 <20091124094421.GA3468@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124094421.GA3468@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* K.Prasad <prasad@linux.vnet.ibm.com> wrote:

> On Sun, Nov 08, 2009 at 04:28:54PM +0100, Frederic Weisbecker wrote:
> > Ingo,
> > 
> > Please pull the tracing/hw-breakpoints branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	tracing/hw-breakpoints
> >
> 
> Hi Frederic, Ingo,
> 		Here are a few concerns (roughly in decreasing order of
> priority) about the perf-events integrated hw-breakpoint feature.
> 
> - Freeze the breakpoint interfaces: Owing to the many 
> current/potential users of hw-breakpoint feature it is important to 
> provide a stable interface to the end-user. Changes underneath the 
> interface can be done in due course in a manner that does not affect 
> the end-user's behaviour or function signature. The present breakpoint 
> interface requires parameters that are best embedded in a structure 
> for extensibility.

Well we have PERF_TYPE_BREAKPOINT right now. I agree that it should be 
finalized in some sort of extensible ABI real soon - we dont want (and 
dont need to) add all features that might be possible in the future.

> - Proposed migration of register allocation logic to arch-specific 
> files from kernel/hw_breakpoint.c. This is best done early to help 
> easy porting of code to other architectures (we have an active 
> interest in bringing support for PPC64 and S390). If done later, it 
> will entail additional effort in porting for each architecture.

I think the general direction should be towards librarized common 
frameworks.

If an architecture wants to do something special it should either extend 
the core code, or, if it's too weird to be added to the core, override 
it via its own implementation.

> - Fix ptrace bugs that potentially alter the semantics of ptrace.

Is there a specific list of these bugs?

> - Bring either true system_wide support or atleast workaround the 
> side-effects of iterative per-cpu registration using single atomic 
> enablement of all per-cpu breakpoints. This can avoid stray exceptions 
> which would get delivered to the end-user even for failed breakpoint 
> requests.

That can certainly be done when users of such facilities emerge. Right 
now we have perf and ptrace as the two users - are they affected by 
these problems?

Thanks,

	Ingo
