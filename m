Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbZDQTql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbZDQTql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZDQTqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:46:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbZDQTqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:46:31 -0400
Date: Fri, 17 Apr 2009 21:46:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
Message-ID: <20090417194613.GA30544@elte.hu>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu> <49E8D91F.1060005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E8D91F.1060005@goop.org>
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

> Taking __do_trace_sched_switch out of lines inserts this into the 
> hot path (6 instructions, 31 bytes):
>
>        cmpl    $0, __tracepoint_sched_switch+8(%rip)   #, __tracepoint_sched_switch.state
>        je      .L1748  #,
>        movq    -136(%rbp), %rdx        # next,
>        movq    -144(%rbp), %rsi        # prev,
>        movq    %rbx, %rdi      # rq,
>        call    __do_trace_sched_switch #
> .L1748:

Hm, why isnt this off-line in the function? It's marked unlikely(), 
isnt it?

also, did you investigate the effect on the _instrumented_ function 
itself? (i.e. the non-tracing related bits) A function call clobbers 
various registers and creates pressure on gcc to shuffle registers 
around.

	Ingo
