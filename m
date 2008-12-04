Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYLDIU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYLDIU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYLDIUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:20:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50862 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYLDIUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:20:13 -0500
Date: Thu, 4 Dec 2008 09:19:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Eric Biederman <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 0/3] ftrace: updates for tip
Message-ID: <20081204081927.GD32594@elte.hu>
References: <20081203203656.776893226@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203203656.776893226@goodmis.org>
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

> Ingo,
> 
> This series has three patches.
> 
> The first patch adds a new feature that I've been wanting to have for some
> time and Arjan even requested. That is to pick a function and only
> trace that function and its children. Dynamic ftrace and function
> graph needs to be enabled for this.
> 
> To do the above, I added a "trace" flags field in the task structure.
> The second patch uses this for the ftrace pid code. It searches for
> the task based on the pid and sets the trace flag, then in the
> ftrace function caller it only needs to check this flag.
> 
> This means we can now trace more than one pid without any more overhead.
> It also means that we should be able to use the name space code that
> the container guys want us to. But since I'm not very up on the
> namespace code, I'm still using just the normal 'pid'. I've Cc'd the
> container folks so perhaps they could write up a patch for me ;-)
> 
> Note: When writing to the set_ftrace_pid two things happen.
>  - The task with the matching pid gets the trace flag set.
>  - Any other task has its trace flag cleared.
>  #2 needs to be addressed when converting to pid name spaces.
>  Just because it is not enough to simply find the matching task.
>  It may be good enough to just clear all tasks and then find the
>  one that matches.
> 
> The last patch makes the function graph tracer honor the set_ftrace_pid.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (3):
>       ftrace: graph of a single function
>       ftrace: use task struct trace flag to filter on pid
>       ftrace: trace single pid for function graph tracer
> 
> ----
>  include/linux/ftrace.h |   46 +++++++++
>  include/linux/sched.h  |    4 +
>  kernel/trace/ftrace.c  |  257 +++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/trace/trace.c   |   11 ++
>  kernel/trace/trace.h   |   40 +++++++-
>  5 files changed, 353 insertions(+), 5 deletions(-)
> -- 

pulled, thanks Steve!

These are some very nice changes!

	Ingo
