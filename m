Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757886AbYLPXJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYLPXJ7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYLPXJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:09:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbYLPXJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:09:49 -0500
Date: Wed, 17 Dec 2008 00:09:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt
	triggering on output
Message-ID: <20081216230936.GR14787@elte.hu>
References: <493EF64D.50804@gmail.com> <493EF797.7090603@gmail.com> <20081212101448.GE18152@elte.hu> <c62985530812120327l369abf7eud17e2a06c7d2bd12@mail.gmail.com> <20081213074930.GA4205@elte.hu> <c62985530812130722u5a4fbfcayd8c61dadbc5b1792@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812130722u5a4fbfcayd8c61dadbc5b1792@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/12/13 Ingo Molnar <mingo@elte.hu>:
> > Another thing, i just noticed that ftrace_print() is broken in certain
> > situations, for example a plain newline:
> >
> >        ftrace_printk("\n");
> >
> > printed via trace_pipe will print some weirdly concatenated line:
> >
> >           <...>-2994  [007]   406.498986: debug_show:          <...>-2994  [007]   406.498986:            <...>-2994  [007]   406.498986: debug_show:
> >
> > not via a separate, standalone, empty line.
> 
> I just tested with latest -tip and I don't any problem with it.
> With a single ftrace_printk("\n") on might_sleep() I get:
> 
>            <...>-2739  [000]   145.692153: __might_sleep:
>            <...>-2739  [000]   145.692155: __might_sleep:
>            <...>-2739  [000]   145.692157: __might_sleep:
>            <...>-2739  [000]   145.692158: __might_sleep:
> 
> with trace or trace_iter file.
> Does it always occur or in rare situations?

it seemed to occur all the time. Will investigate it if i see it again.

	Ingo
