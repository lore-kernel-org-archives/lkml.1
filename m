Return-Path: <linux-kernel-owner+w=401wt.eu-S1754938AbZLJHIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbZLJHIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZLJHIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:08:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40772 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbZLJHIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:08:12 -0500
Date: Thu, 10 Dec 2009 08:08:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Bird <tim.bird@am.sony.com>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210070800.GB16874@elte.hu>
References: <4B202778.4030801@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B202778.4030801@am.sony.com>
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


* Tim Bird <tim.bird@am.sony.com> wrote:

> Add function duration tracer.
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  kernel/trace/Kconfig          |    8
>  kernel/trace/Makefile         |    1
>  kernel/trace/trace.c          |   32 ++
>  kernel/trace/trace_duration.c |  527 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 568 insertions(+)

Please do it in a cleaner an more generic fashion: add a "function 
event" that perf can see and process, so all the output embellishment 
can be done outside of the kernel, in tools/perf/.

We want to wind down the current maze of ftrace plugins, not extend 
them. We already obsoleted the following ftrace plugins: scheduler, 
sysprof, blktrace, kmem, scheduler, etc. There's more work ongoing and 
broad agreement between folks developing it that this is the way 
forward.

The function tracer / function graph tracer is a holdout due to its 
complexity - but that by no means weakens the argument and the necessity 
to migrate it.

ftrace plugins were a nice idea originally and a clear improvement over 
existing alternatives, but now that we've got a technicaly superior, 
unified event framework that can do what the old plugins did and much 
more, we want to improve that and not look back ...

Thanks,

	ingo
