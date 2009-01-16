Return-Path: <linux-kernel-owner+w=401wt.eu-S933171AbZAPLYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbZAPLYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbZAPLYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:24:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60265 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZAPLYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:24:02 -0500
Date: Fri, 16 Jan 2009 12:23:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090116112345.GC20082@elte.hu>
References: <20090116004050.273665842@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116004050.273665842@goodmis.org>
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
> The first patch is critical, and needs to stay with trace_output.c Not 
> that critical since trace_output.c is not in mainline yet.
> 
> The second patch gives the ability to stack trace functions. I've been 
> leery about adding this and still keep it a separate option from the 
> "stacktrace" that already exists. This is because when enabled with no 
> filtering, the lag between typing and seeing what is typed can be up to 
> 10 seconds or more.

Btw., is this true even if frame pointers are enabled? When frame pointers 
are disabled we scan the full kernel stack => that can be quite slow if 
every kernel function is traced ;-)

> I made the function stack trace an option attached to the function 
> tracer, so it must be enabled after the function tracer has been set. 
> This still needs to be updated in ftrace.txt.

maybe we could drive this via the filter API? Something like:

   echo "*btrfs*:stacktrace" >> set_filter_functions

Would automatically mean that those functions will all generate 
stacktraces too. Note how safe this API is by default: the filter is used 
for a narrow scope of functions anwyay. To get it for all kernel functions 
one would have to do:

   echo "*:stacktrace" >> set_filter_functions

Which one cannot do accidentally.

What do you think?

> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Lai Jiangshan (1):
>       ftrace: fix trace_output
> 
> Steven Rostedt (1):
>       ftrace: add stack trace to function tracer
> 
> ----
>  kernel/trace/trace.c           |   26 ++++++++----
>  kernel/trace/trace.h           |    7 +++
>  kernel/trace/trace_functions.c |   84 ++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_output.c    |   65 +++++++++++++++----------------
>  kernel/trace/trace_output.h    |    4 +-
>  5 files changed, 141 insertions(+), 45 deletions(-)

Pulled into tip/tracing/ftrace, thanks Steve!

	Ingo
