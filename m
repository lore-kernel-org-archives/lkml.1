Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZCWI0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZCWI0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZCWI0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:26:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbZCWI0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:26:11 -0400
Date: Mon, 23 Mar 2009 09:25:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] tracing/events: make the filter files writable
Message-ID: <20090323082556.GB18837@elte.hu>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
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

> We need the filter files to be writable, the current
> filter file permissions make are only set readable.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace_events.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 594d78a..19f61dd 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -706,7 +706,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  
>  	system->preds = NULL;
>  
> -	entry = debugfs_create_file("filter", 0444, system->entry, system,
> +	entry = debugfs_create_file("filter", 0644, system->entry, system,
>  				    &ftrace_subsystem_filter_fops);
>  	if (!entry)
>  		pr_warning("Could not create debugfs "
> @@ -769,7 +769,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
>  		}
>  	}
>  
> -	entry = debugfs_create_file("filter", 0444, call->dir, call,
> +	entry = debugfs_create_file("filter", 0644, call->dir, call,

Interesting. Yesterday i tried the filter files and they worked - i 
was able to create a 'comm == bash' filter for example. Does debugfs 
ignore permissions perhaps?

	Ingo
