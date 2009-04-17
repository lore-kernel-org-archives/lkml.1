Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZDQPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZDQPrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZDQPrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:47:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZDQPrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:47:07 -0400
Date: Fri, 17 Apr 2009 17:46:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mathieu.desnoyers@polymtl.ca, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
Message-ID: <20090417154640.GB8253@elte.hu>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239950139-1119-2-git-send-email-jeremy@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Mainly simplify linux/tracepoint.h's include dependencies (removes 
> rcupdate.h), but it can't help with icache locality, since it 
> definitely moves the code out of line, rather than relying on gcc 
> to do it.

> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -15,7 +15,6 @@
>   */
>  
>  #include <linux/types.h>
> -#include <linux/rcupdate.h>

nice!

> +#define DEFINE_DO_TRACE(name, proto, args)				\
> +	void __do_trace_##name(struct tracepoint *tp, TP_PROTO(proto))	\
> +	{								\

that needs to be marked notrace, otherwise the function tracer 
becomes noisy. (or even lockupy.)

	Ingo
