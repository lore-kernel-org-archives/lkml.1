Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbZCWTk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbZCWTk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbZCWTks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:40:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44693 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbZCWTkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:40:47 -0400
Date: Mon, 23 Mar 2009 20:40:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 0/2 v2] Syscalls tracing
Message-ID: <20090323194020.GA29478@elte.hu>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <20090313151632.GB9867@nowhere> <20090313164743.GC3354@Krystal> <20090315160132.GD5105@nowhere> <20090323163235.GA22501@Krystal> <20090323192712.GC5988@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323192712.GC5988@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> And actually I don't think two copy_from_user will really change a 
> lot the tracing throughput.

Correct. It's already in the CPU cache so it is a performance 
non-issue and essentially for free. Copy avoidance is only an issue 
when touchig cache-cold data.

( Yes, a few cycles could be shaven off but the beauty of 
  all-encompassing non-source-code-invasive syscall tracing covering 
  hundreds of syscalls straight away trumps those concerns. )

> The idea would be now to join the syscalls metadata with such 
> quick handlers. We will have to think about how to join these in a 
> proper way.

We could allow per syscall tracepoints via the attribute table. The 
call signature could be a standard:

   long sys_call(unsinged long arg1, unsigned long arg2,
		 unsigned long arg3, unsigned long arg4,
		 unsigned long arg5, unsigned long arg6);

This would allow interested plugins/tools to install a system call 
specific callback. (we might allow two tracepoints - one before and 
one after the syscall)

The registration API could be driven by the name or by the syscall 
index - NR_sys_open or so.

	Ingo
