Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYL2L5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYL2L5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYL2L46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:56:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56543 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYL2L45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:56:57 -0500
Date: Mon, 29 Dec 2008 12:56:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 1/2] tracing/ftrace: provide the base infrastructure
	for stat tracing
Message-ID: <20081229115645.GB22727@elte.hu>
References: <4956aff1.0405560a.0eb9.ffffd126@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4956aff1.0405560a.0eb9.ffffd126@mx.google.com>
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

> Impact: enhance the tracing API to provide statistical tracing
> 
> The goal of this patch is to normalize and make more easy the 
> implementation of statistical (histogram) tracing.
> 
> It implements a trace_stat file into the /debugfs/tracing directory 
> where one can print a one-shot output of statistics/histogram entries.
> 
> A tracer has to provide two basic iterator callbacks:
> 
> stat_start() => the first entry
> stat_next(prev, idx) => the next one.
> 
> Note that it is adapted for arrays or hash tables or lists.... since
> it provides a pointer to the previous entry and the current index of the
> iterator.
> 
> These two callbacks are called to get a snapshot of the statistics at 
> each opening of the trace_stat file because. The values are so updated 
> between two "cat trace_stat". And the tracer is free to lock its datas 
> during the iteration to keep consistent values.
> 
> Since it is almost always interesting to sort statisticals values to 
> address the problems by priority, this infrastructure provides a 
> "sorting" of the stat entries too if desired. A tracer has just to 
> provide a stat_cmp callback to compare two entries and the stat tracing 
> infrastructure will build a sorted list of the given entries.
> 
> A last callback, called stat_headers, can be implemented by a tracer to 
> output headers on its trace.
> 
> If one of these callbacks is changed on runtime, it just have to signal 
> it to the stat tracing API by calling the init_tracer_stat() helper.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/Makefile     |    1 +
>  kernel/trace/trace.c      |    3 +-
>  kernel/trace/trace.h      |   17 +++
>  kernel/trace/trace_stat.c |  250 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 270 insertions(+), 1 deletions(-)

nice! I've put this into tip/tracing/ftrace (as it depends on Steve's 
event hash rework) - and lets see how this works out with the branch 
tracer in practice.

	Ingo
