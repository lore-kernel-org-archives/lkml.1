Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZBILiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZBILiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZBILiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:38:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZBILiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:38:01 -0500
Date: Mon, 9 Feb 2009 12:37:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: handle the leaf
	functions from trace_pipe
Message-ID: <20090209113748.GD18757@elte.hu>
References: <498c7909.11355e0a.5fc7.4ff2@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498c7909.11355e0a.5fc7.4ff2@mx.google.com>
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

> When one cat on the trace file, the leaf functions are printed without brackets:
> 
> function();
> 
> whereas in the trace_pipe file we'll see the following:
> 
> function() {
> }
> 
> This is because the ring_buffer handling is not the same between those two files.
> On the trace file, when an entry is printed, the iterator advanced and then we can
> check the next entry.
> 
> There is no iterator with trace_pipe, the current entry to print has been peeked
> and not consumed. So checking the next entry will still return the current one while
> we don't consume it.
> 
> This patch introduces a new value for the output callbacks to ask the tracing
> core to not consume the current entry after printing it.
> We need it because we will have to consume the current entry ourself to check the next one.
> 
> Now the trace_pipe is able to handle well the leaf functions.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.c                 |    4 +-
>  kernel/trace/trace.h                 |    7 +++--
>  kernel/trace/trace_functions_graph.c |   48 +++++++++++++++++++++------------
>  3 files changed, 36 insertions(+), 23 deletions(-)

Applied to tip/tracing/ftrace, thanks Frederic!

	Ingo
