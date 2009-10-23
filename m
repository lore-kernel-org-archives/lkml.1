Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZJWGUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZJWGUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 02:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZJWGUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 02:20:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZJWGUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 02:20:16 -0400
Date: Fri, 23 Oct 2009 08:20:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 1/1] perf tools: Unify debug messages mechanisms
Message-ID: <20091023062000.GB1389@elte.hu>
References: <1256153646-10097-1-git-send-email-acme@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256153646-10097-1-git-send-email-acme@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> We were using eprintf in some places, that looks at a global 'verbose' 
> level, and at other places passing a 'v' parameter to specify the 
> verbosity level, unify it by introducing pr_{err,warning,debug,etc}, 
> just like in the kernel.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-annotate.c          |    3 +-
>  tools/perf/builtin-probe.c             |   20 +++---
>  tools/perf/builtin-record.c            |    2 +-
>  tools/perf/builtin-report.c            |    9 +-
>  tools/perf/builtin-sched.c             |    4 +-
>  tools/perf/builtin-timechart.c         |   13 ++--
>  tools/perf/builtin-top.c               |    2 +-
>  tools/perf/builtin-trace.c             |    4 +-
>  tools/perf/util/callchain.c            |    2 +-
>  tools/perf/util/debug.c                |    4 +-
>  tools/perf/util/debug.h                |    3 +-
>  tools/perf/util/event.h                |    3 +-
>  tools/perf/util/header.c               |    2 +-
>  tools/perf/util/include/linux/kernel.h |   17 ++++
>  tools/perf/util/map.c                  |   17 ++--
>  tools/perf/util/probe-finder.c         |   12 ++--
>  tools/perf/util/symbol.c               |  134 ++++++++++++++------------------
>  tools/perf/util/symbol.h               |    5 +-
>  tools/perf/util/thread.c               |    6 +-
>  19 files changed, 130 insertions(+), 132 deletions(-)
> 
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 99bac6a..6d63c2e 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -203,8 +203,7 @@ static int
>  process_mmap_event(event_t *event, unsigned long offset, unsigned long head)
>  {
>  	struct map *map = map__new(&event->mmap, NULL, 0,
> -				   sizeof(struct sym_priv), symbol_filter,
> -				   verbose);
> +				   sizeof(struct sym_priv), symbol_filter);
>  	struct thread *thread = threads__findnew(event->mmap.pid);
>  
>  	dump_printf("%p [%p]: PERF_RECORD_MMAP %d: [%p(%p) @ %p]: %s\n",
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index b5ad86a..dcb406c 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -78,7 +78,7 @@ static int parse_probepoint(const struct option *opt __used,
>  	if (!str)	/* The end of probe points */
>  		return 0;
>  
> -	eprintf("probe-definition(%d): %s\n", session.nr_probe, str);
> +	pr_debug("probe-definition(%d): %s\n", session.nr_probe, str);

Very nice! That verbose global/local overlap has always bothered me, 
thanks for fixing it!

	Ingo
