Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZJTFys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZJTFys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZJTFyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:54:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbZJTFyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:54:46 -0400
Date: Tue, 20 Oct 2009 07:54:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf tools: Shut up compiler warning
Message-ID: <20091020055439.GA29531@elte.hu>
References: <y> <1255971369-11368-1-git-send-email-acme@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1255971369-11368-1-git-send-email-acme@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> cc1: warnings being treated as errors
> util/trace-event-parse.c: In function ‘parse_ftrace_printk’:
> util/trace-event-parse.c:289: warning: ‘fmt’ may be used uninitialized in this function
> 
> Cc: Steven Rostedt <srostedt@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/trace-event-parse.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 4b61b49..0b8a01b 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -286,7 +286,7 @@ void parse_ftrace_printk(char *file, unsigned int size __unused)
>  	char *line;
>  	char *next = NULL;
>  	char *addr_str;
> -	char *fmt;
> +	char *fmt = NULL;
>  	int i;
>  
>  	line = strtok_r(file, "\n", &next);

Actually, this might be a real bug that GCC pointed out: what makes sure 
that strtok_r() does not return a NULL (no more tokens) and hence fmt 
remains NULL (crashing the rest of the parser)?

	Ingo
