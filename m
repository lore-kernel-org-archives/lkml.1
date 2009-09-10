Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZIJKKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZIJKKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZIJKKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:10:04 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:38965 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbZIJKKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:10:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19112.53364.51476.9036@cargo.ozlabs.ibm.com>
Date: Thu, 10 Sep 2009 20:09:56 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC GIT PULL] hw-breakpoints: Rewrite on top of perf counters
In-Reply-To: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> This is a rewrite of the hardware breakpoints on top of perf counters.

On powerpc, it doesn't build.  I get:

  CC      kernel/perf_counter.o
kernel/perf_counter.c:31:31: error: asm/hw_breakpoint.h: No such file or directory
kernel/perf_counter.c: In function 'bp_perf_counter_init':
kernel/perf_counter.c:3964: error: implicit declaration of function 'register_perf_hw_breakpoint'
kernel/perf_counter.c:3966: error: implicit declaration of function '__register_perf_hw_breakpoint'
kernel/perf_counter.c:3968: error: 'perf_ops_bp' undeclared (first use in this function)
kernel/perf_counter.c:3968: error: (Each undeclared identifier is reported only once
kernel/perf_counter.c:3968: error: for each function it appears in.)
make[2]: *** [kernel/perf_counter.o] Error 1
make[1]: *** [kernel] Error 2
make: *** [sub-make] Error 2

Seems like every architecture now needs an asm/hw_breakpoint.h.  What
is the minimum required in that file?  Looks like we would require a
perf_ops_bp, at least.

Could you please either arrange things so that architectures that
don't have hardware breakpoints hooked up to perf_counters don't need
an asm/hw_breakpoint.h, or add minimal versions of that file for every
architecture, so as not to break bisection unnecessarily?

Paul.
