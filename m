Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbYHOJY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbYHOJY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYHOJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:24:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYHOJYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:24:47 -0400
Date: Fri, 15 Aug 2008 11:24:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 0/6] ftrace: to kill a daemon (small updates)
Message-ID: <20080815092412.GC22209@elte.hu>
References: <20080814194506.233473381@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814194506.233473381@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [
>   Changes since v1:
> 
>     regex fix in x86_64 recordmcount.pl. Now it can handle all
>       mcount+0x... mcount-0x... and mcount, where as the original
>       only handled mcount+0x...
> 
>     Made mcount on start-up to simply return. The current mcount
>       is set up to be replaced with a call to ftrace_record_ip.
>       This is no longer necessary.
> 
>   Note: This patch series is focusing on how calls to mcount in
>     the kernel are converted to nops. It does not address what
>     kind of nop is used. That is a different topic, and should
>     be in a different patch series.
> 
>   Note 2: I have found that the changes here are more stable than
>     the current daemon method, and these patches should be used.
>     It also solves the resume from suspend to ram bug that was
>     reported:
> 
>       http://lkml.org/lkml/2008/8/12/234
>        and
>       http://lkml.org/lkml/2008/8/12/451
> 
>   Note 3: I have already ported this to PowerPC64, but I am waiting
>     for this to be accepted first before submitting those changes.
> ]
> 
> One of the things that bothered me about the latest ftrace code was 
> this annoying daemon that would wake up once a second to see if it had 
> work to do. If it did not, it would go to sleep, otherwise it would do 
> its work and then go to sleep.

i like this concept alot - i've applied the whole lot to 
tip/tracing/ftrace.

Eventually gcc should be extended to provide a separate section for 
instrumentation patch sites, instead of us having to disassemble the 
object code. That would also make the ftrace build faster. Any gcc folks 
interested in that?

	Ingo
