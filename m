Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZBTKk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZBTKk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZBTKkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:40:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZBTKkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:40:18 -0500
Date: Fri, 20 Feb 2009 11:40:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/function-graph-tracer: make set_graph_function
	file support ftrace regex
Message-ID: <20090220104004.GC28581@elte.hu>
References: <499dc97d.257d420a.0f93.1be5@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499dc97d.257d420a.0f93.1be5@mx.google.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: trace only functions matching a pattern
> 
> The set_graph_function file let one to trace only one or several
> chosen functions and follow all their code flow.
> 
> Currently, only a constant function name is allowed so this patch
> allows the ftrace_regex functions:
> 
> _ matches all functions that end with "name":
>   echo *name > set_graph_function
> 
> _ matches all functions that begin with "name":
>   echo name* > set_graph_function
> 
> _ matches all functions that contains "name":
>   echo *name* > set_graph_function
> 
> Example:
> 
> echo mutex* > set_graph_function
> 
>  0)               |  mutex_lock_nested() {
>  0)   0.563 us    |    __might_sleep();
>  0)   2.072 us    |  }
>  0)               |  mutex_unlock() {
>  0)   1.036 us    |    __mutex_unlock_slowpath();
>  0)   2.433 us    |  }
>  0)               |  mutex_unlock() {
>  0)   0.691 us    |    __mutex_unlock_slowpath();
>  0)   1.787 us    |  }
>  0)               |  mutex_lock_interruptible_nested() {
>  0)   0.548 us    |    __might_sleep();
>  0)   1.945 us    |  }
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/ftrace.c |   56 +++++++++++++++++++++++++++++++++---------------
>  1 files changed, 38 insertions(+), 18 deletions(-)

Applied, thanks Frederic!

I'm wondering about the following: the whole set_graph_function 
method is limited (to FTRACE_GRAPH_MAX_FUNCS, 32 entries), is 
not scalable (we walk the array of functions at every function 
trace point), has a separate API, etc.

Wouldnt we off better with a good, generic function attributes 
hash, and an extension to the generic regexp parser to enable 
the setting of those attributes? One such attribute could be the 
'expand child function'

	Ingo
