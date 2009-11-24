Return-Path: <linux-kernel-owner+w=401wt.eu-S933280AbZKXUtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbZKXUtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932770AbZKXUtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:49:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbZKXUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:49:11 -0500
Subject: Re: [PATCH] perf: Fix bad software/trace event recursion counting
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Arjan van de Ven <arjan@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1259091502-5171-1-git-send-email-fweisbec@gmail.com>
References: <20091124100724.GA5570@elte.hu>
	 <1259091502-5171-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 21:48:50 +0100
Message-ID: <1259095730.4531.1791.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 20:38 +0100, Frederic Weisbecker wrote:

> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index accfd7b..35df94e 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -3914,7 +3914,7 @@ void perf_swevent_put_recursion_context(int rctx)
>  {
>  	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
>  	barrier();
> -	cpuctx->recursion[rctx]++;
> +	cpuctx->recursion[rctx]--;
>  	put_cpu_var(perf_cpu_context);
>  }

D'0h!

