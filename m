Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbZIJRYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbZIJRYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 13:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZIJRYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 13:24:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43038 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZIJRYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 13:24:09 -0400
Date: Thu, 10 Sep 2009 19:23:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC GIT PULL] hw-breakpoints: Rewrite on top of perf counters
Message-ID: <20090910172343.GA25044@elte.hu>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <19112.53364.51476.9036@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19112.53364.51476.9036@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> Frederic Weisbecker writes:
> 
> > This is a rewrite of the hardware breakpoints on top of perf counters.
> 
> On powerpc, it doesn't build.  I get:
> 
>   CC      kernel/perf_counter.o
> kernel/perf_counter.c:31:31: error: asm/hw_breakpoint.h: No such file or directory
> kernel/perf_counter.c: In function 'bp_perf_counter_init':
> kernel/perf_counter.c:3964: error: implicit declaration of function 'register_perf_hw_breakpoint'
> kernel/perf_counter.c:3966: error: implicit declaration of function '__register_perf_hw_breakpoint'
> kernel/perf_counter.c:3968: error: 'perf_ops_bp' undeclared (first use in this function)
> kernel/perf_counter.c:3968: error: (Each undeclared identifier is reported only once
> kernel/perf_counter.c:3968: error: for each function it appears in.)
> make[2]: *** [kernel/perf_counter.o] Error 1
> make[1]: *** [kernel] Error 2
> make: *** [sub-make] Error 2
> 
> Seems like every architecture now needs an asm/hw_breakpoint.h.  
> What is the minimum required in that file?  Looks like we would 
> require a perf_ops_bp, at least.
> 
> Could you please either arrange things so that architectures that 
> don't have hardware breakpoints hooked up to perf_counters don't 
> need an asm/hw_breakpoint.h, or add minimal versions of that file 
> for every architecture, so as not to break bisection 
> unnecessarily?

I'd prefer the former - i.e. dont touch architectures that dont 
support it yet.

	Ingo
