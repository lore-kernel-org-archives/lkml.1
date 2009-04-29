Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbZD2GD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbZD2GD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZD2GDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:03:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37196 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZD2GDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:03:44 -0400
Date: Wed, 29 Apr 2009 08:03:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIT PULL] tracing/splice/ringbuffer: updates for
	tip
Message-ID: <20090429060326.GC6148@elte.hu>
References: <20090429044814.138790038@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429044814.138790038@goodmis.org>
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
> I was doing a bit of tracing that was stressing the splice code 
> and I found lots of badness. Mostly, the second patch is the 
> killer, and should most likely go upstream ASAP. The ref counting 
> on the splice page is wrong and is never freed!

ah, this probably explains what i reported some time ago: the 
ftrace-analyzer OOM hang. I've cherry-picked this into 
tracing/urgent as well.

> The rest are fixes to the read side. While debugging the memory 
> leak I pulled out my old logdev and used it to monitor what was 
> happening inside of ftrace (tracing the tracer). I did not like 
> the amount of copying that was happening in splice. This was 
> mainly because splice was faster than the writer (and this was 
> with function tracer running!). I added some enhancements to make 
> the splice code perform a little nicer.
> 
> Here's the logdev patch I was using to trace. As well as adding my 
> lfcnprint statements (similar to trace_printk).
> 
>   http://rostedt.homelinux.com/logdev/logdev-0.6.0-2.6.30-rc1.patch
> 
> Please pull the latest tip/tracing/ftrace-1 tree, which can be 
> found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-1
> 
> 
> Steven Rostedt (5):
>       tracing: convert ftrace_dump spinlocks to raw
>       tracing: fix ref count in splice pages
>       tracing: only add splice page if entries exist
>       tracing: have splice only copy full pages
>       ring-buffer: fix printk output
> 
> ----
>  kernel/trace/ring_buffer.c |    2 +-
>  kernel/trace/trace.c       |   20 ++++++++++++++------
>  2 files changed, 15 insertions(+), 7 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
