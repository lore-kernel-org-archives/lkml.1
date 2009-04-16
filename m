Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZDPQlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZDPQlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbZDPQlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:41:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbZDPQlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:41:01 -0400
Date: Thu, 16 Apr 2009 18:40:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] updates for event tester and lockdep
	tracer
Message-ID: <20090416164047.GA19281@elte.hu>
References: <20090416161543.199331330@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416161543.199331330@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I did not add your delay.h fix, since I was not sure if you added 
> it (I saw a commit sha1 in the email).

Forgot to push it out in the big impact-line flamewars^W discussions 
;-)

> I actually wrote the function trace event tester last night. But 
> because it would sometimes lock up the system on bootup I held 
> off.
> 
> But I also found that the lockdep trace points where they are 
> would lock up my system too. If I placed them inside the 
> current->lockdep_recursion, everything ran stable.

Do you think this explains the self-test lockups i reported? The 
lockups happened in the skb test, so i'm unsure. I left the 
workaround (which comments the self-test out) for the time being, 
could you check whether the config i sent works fine for you?

> I ran the lockdep trace points enabled all night with the second 
> patch. Without the second patch, it would lockup within a few 
> minutes.
> 
> Please pull the latest tip/tracing/core-v2 tree, which can be 
> found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core-v2
> 
> 
> Steven Rostedt (2):
>       tracing/events: perform function tracing in event selftests
>       tracing/events/lockdep: move tracepoints within recursive protection
> 
> ----
>  kernel/lockdep.c            |   14 ++++----
>  kernel/trace/trace_events.c |   80 +++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 80 insertions(+), 14 deletions(-)

Pulled (from email - i fixed up the conflict with the workaround and 
i added the new-style impact lines), thanks a lot Steve!

	Ingo
