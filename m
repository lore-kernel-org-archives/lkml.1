Return-Path: <linux-kernel-owner+w=401wt.eu-S933836AbZJMKIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbZJMKIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbZJMKIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:08:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53225 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756729AbZJMKIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:08:09 -0400
Date: Tue, 13 Oct 2009 12:07:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tracing/profile: Add filter support
Message-ID: <20091013100708.GD26846@elte.hu>
References: <4AD3E34C.1020301@cn.fujitsu.com> <4AD3E3B5.70502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD3E3B5.70502@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> +#ifdef CONFIG_EVENT_PROFILE
> +struct perf_event;
> +extern int ftrace_profile_enable(int event_id);
> +extern void ftrace_profile_disable(int event_id);
> +extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
> +				     char *filter_str);
> +extern void ftrace_profile_free_filter(struct perf_event *event);
> +#endif

This reminds me - i think we should eliminate CONFIG_EVENT_PROFILE - 
it's an unnecessary Kconfig complication. If both PERF_EVENTS and 
EVENT_TRACING is enabled we should expose generic tracepoints.

Nor is it limited to event 'profiling', so it has become a misnomer as 
well.

	Ingo
