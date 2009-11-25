Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbZKYIDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbZKYIDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758398AbZKYIDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:03:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33709 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758391AbZKYIDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:03:40 -0500
Date: Wed, 25 Nov 2009 13:33:42 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091125080342.GD2660@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20091124200127.GA5751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091124200127.GA5751@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:01:27PM +0100, Oleg Nesterov wrote:
> Hello.
> 
> This is the new iteration of Roland's utrace patch, this time
> with "rewrite-ptrace-via-utrace" + cleanups in utrace core.
> 
> 1-7 are already in -mm tree, I am sending them to simplify the
> review.
> 
> 8-12 don not change the behaviour, simple preparations.
> 
> 13-14 add utrace-ptrace and utrace

Oleg,

I ran the ptrace-tests testsuite [1] on powerpc on the vanilla ptrace
and then with ptrace/utrace. The results for ptrace/utrace look better
:-)

All tests are 'make check xcheck'.

Ananth

[1] cvs -d :pserver:anoncvs:anoncvs@sources.redhat.com:/cvs/systemtap co ptrace-tests

---------
Vanilla ptrace:

PASS: ptrace-on-job-control-stopped
PASS: attach-wait-on-stopped
PASS: detach-can-signal
PASS: attach-into-signal
PASS: attach-sigcont-wait
PASS: sa-resethand-on-cont-signal
PASS: ptrace_cont-defeats-sigblock
PASS: ptrace-cont-sigstop-detach
PASS: ptrace_event_clone
PASS: tif-syscall-trace-after-detach
PASS: event-exit-proc-maps
PASS: event-exit-proc-environ
SKIP: x86_64-ia32-gs
SKIP: x86_64-gsbase
PASS: powerpc-altivec
PASS: peekpokeusr
PASS: watchpoint
PASS: block-step
PASS: step-jump-cont
SKIP: step-jump-cont-strict
PASS: ppc-dabr-race
PASS: signal-loss
PASS: step-into-handler
SKIP: user-area-access
PASS: user-regs-peekpoke
PASS: erestartsys
SKIP: erestart-debugger
SKIP: step-to-breakpoint
errno 14 (Bad address)
syscall-reset: syscall-reset.c:95: main: Assertion `(*__errno_location ()) == 38' failed.
unexpected child status 67f
FAIL: syscall-reset
PASS: reparent-zombie
PASS: step-simple
SKIP: step-through-sigret
PASS: stop-attach-then-wait
FAIL: detach-stopped
PASS: detach-stopped-rhel5
PASS: clone-multi-ptrace
PASS: clone-ptrace
PASS: o_tracevfork
PASS: o_tracevforkdone
PASS: detach-parting-signal
PASS: detach-sigkill-race
PASS: waitpid-double-report
PASS: o_tracevfork-parent
PASS: stopped-detach-sleeping
FAIL: stopped-attach-transparency
SKIP: erestartsys-trap
SKIP: highmem-debugger
PASS: sigint-before-syscall-exit
SKIP: syscall-from-clone
step-from-clone: step-from-clone.c:195: main: Assertion `(status >> 8) == 5' failed.
step-from-clone: step-from-clone.c:119: handler_fail: Assertion `0' failed.
/bin/sh: line 5: 19825 Aborted                 ${dir}$tst
FAIL: step-from-clone
step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
/bin/sh: line 5: 19832 Aborted                 ${dir}$tst
FAIL: step-fork
========================================
5 of 41 tests failed
(10 tests were not run)
Please report to utrace-devel@redhat.com
========================================
make[3]: *** [check-TESTS] Error 1
make[3]: Leaving directory `/home/ananth/ptrace-tests/tests'
make[2]: *** [check-am] Error 2
make[2]: Leaving directory `/home/ananth/ptrace-tests/tests'
make[1]: *** [check] Error 2
make[1]: Leaving directory `/home/ananth/ptrace-tests/tests'
make: *** [check-recursive] Error 1

---------
ptrace over utrace:

PASS: ptrace-on-job-control-stopped
PASS: attach-wait-on-stopped
PASS: detach-can-signal
PASS: attach-into-signal
PASS: attach-sigcont-wait
PASS: sa-resethand-on-cont-signal
PASS: ptrace_cont-defeats-sigblock
PASS: ptrace-cont-sigstop-detach
PASS: ptrace_event_clone
PASS: tif-syscall-trace-after-detach
PASS: event-exit-proc-maps
PASS: event-exit-proc-environ
SKIP: x86_64-ia32-gs
SKIP: x86_64-gsbase
PASS: powerpc-altivec
PASS: peekpokeusr
PASS: watchpoint
PASS: block-step
PASS: step-jump-cont
SKIP: step-jump-cont-strict
PASS: ppc-dabr-race
PASS: signal-loss
PASS: step-into-handler
SKIP: user-area-access
PASS: user-regs-peekpoke
PASS: erestartsys
SKIP: erestart-debugger
SKIP: step-to-breakpoint
errno 14 (Bad address)
syscall-reset: syscall-reset.c:95: main: Assertion `(*__errno_location ()) == 38' failed.
unexpected child status 67f
FAIL: syscall-reset
PASS: reparent-zombie
PASS: step-simple
SKIP: step-through-sigret
PASS: stop-attach-then-wait
PASS: detach-stopped
PASS: detach-stopped-rhel5
PASS: clone-multi-ptrace
PASS: clone-ptrace
PASS: o_tracevfork
PASS: o_tracevforkdone
PASS: detach-parting-signal
PASS: detach-sigkill-race
PASS: waitpid-double-report
PASS: o_tracevfork-parent
PASS: stopped-detach-sleeping
PASS: stopped-attach-transparency
SKIP: erestartsys-trap
SKIP: highmem-debugger
PASS: sigint-before-syscall-exit
SKIP: syscall-from-clone
SKIP: step-from-clone
step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
/bin/sh: line 5: 24803 Aborted                 ${dir}$tst
FAIL: step-fork
========================================
2 of 40 tests failed
(11 tests were not run)
Please report to utrace-devel@redhat.com
========================================
make[3]: *** [check-TESTS] Error 1
make[3]: Leaving directory `/home/ananth/ptrace-tests/tests'
make[2]: *** [check-am] Error 2
make[2]: Leaving directory `/home/ananth/ptrace-tests/tests'
make[1]: *** [check] Error 2
make[1]: Leaving directory `/home/ananth/ptrace-tests/tests'
make: *** [check-recursive] Error 1

