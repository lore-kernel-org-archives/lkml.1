Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYLWGsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYLWGsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 01:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYLWGsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 01:48:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45595 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYLWGsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 01:48:16 -0500
Date: Tue, 23 Dec 2008 07:48:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: strip ending newlines
	on comments
Message-ID: <20081223064804.GA24956@elte.hu>
References: <494FD967.2000002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494FD967.2000002@gmail.com>
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

> Impact: trivial output improvement
> 
> Ending newlines are appended automatically on comments by the function graph tracer
> because the newlines needs to be placed after the "*/" characters.
> So if the user puts an ending whitespace, we want to strip it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/function-graph-tracer, thanks Frederic!

> @@ -584,6 +585,11 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
>  				return TRACE_TYPE_PARTIAL_LINE;
>  		}
>  
> +	/* Strip ending newline on the comment */
> +	len = strlen(trace->buf);
> +	if (trace->buf[len - 1] == '\n')
> +		trace->buf[len - 1] = '\0';
> +

Hm, dont we know the length of the buffer already, so that we could avoid 
the strlen() overhead?

	Ingo
