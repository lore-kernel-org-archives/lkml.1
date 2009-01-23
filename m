Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbZAWKUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbZAWKUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZAWKT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:19:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41256 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZAWKT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:19:57 -0500
Date: Fri, 23 Jan 2009 11:19:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] tracing/function-graph-tracer: various fixes
	and features
Message-ID: <20090123101949.GD15188@elte.hu>
References: <497917b5.09cc660a.5f4c.ffffc568@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497917b5.09cc660a.5f4c.ffffc568@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4425]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 
> This patch brings various bugfixes:
> 
> _ Drop the first irrelevant task switch on the very beginning of a trace.
> _ Drop the OVERHEAD word from the headers, the DURATION word is sufficient and will not
>   overlap other columns.
> _ Make the headers fit well their respective columns whatever the selected options.

> About features, one can now disable the duration (this will hide the 
> overhead too for convenient reasons and because on doesn't need overhead 
> if it hasn't the duration

very nice! I've applied this to tip/tracing/function-graph-tracer, thanks 
Frederic!

this:

> I guess no one needs the nanosec precision here, the main goal is to 
> find when happened the events on a cpu when the trace switches from one 
> cpu to another.
> 
> ie:
> 
>   274.874760 |   1)   0.676 us    |      _spin_unlock();
>   274.874762 |   1)   0.609 us    |      native_load_sp0();
>   274.874763 |   1)   0.602 us    |      native_load_tls();
>   274.878739 |   0)   0.722 us    |                  }
>   274.878740 |   0)   0.714 us    |                  native_pmd_val();
>   274.878741 |   0)   0.730 us    |                  native_pmd_val();
> 
> Here there is a 4000 usecs difference when we switch the cpu.

Still needs a solution - if we do cross-CPU traces we want to have a 
global trace clock with 'seemless' transition between CPUs.

	Ingo
