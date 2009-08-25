Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZHYK3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZHYK3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbZHYK3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:29:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZHYK3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:29:18 -0400
Date: Tue, 25 Aug 2009 12:28:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v4 0/4] tracing: tweaks for generic syscall events
Message-ID: <20090825102858.GB19941@elte.hu>
References: <1250917125-6174-1-git-send-email-jistone@redhat.com> <1251150194-1713-1-git-send-email-jistone@redhat.com> <20090824230509.GB5124@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824230509.GB5124@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Aug 24, 2009 at 02:43:10PM -0700, Josh Stone wrote:
> > This patch series moves the callbacks for the syscall tracepoints to the
> > definition site, and adds generic TRACE_EVENTs which capture all syscall
> > arguments.
> > 
> > New in v3:
> > - Give the thread flag a more generic name: TIF_SYSCALL_TRACEPOINT.
> > - Move the regfuncs to arch-specific files, per Jason's suggestion.
> > - Change _WITH_CALLBACK to just _FN, per Ingo's suggestion.
> > 
> > New in v4:
> > - Give the config flag a more generic name: HAVE_SYSCALL_TRACEPOINTS.
> > - Undo the arch reorg of the regfuncs, but conditionalize on above.
> > 
> > 
> > Sample trace output:
> >         sendmail-974   [000] 55665.464492: sys_enter: NR 14 (1, 7fff60f3af40, 7fff60f3aec0, 8, 0, 7fb1b6a05161)
> > 
> >         sendmail-974   [000] 55665.464496: sys_exit: NR 14 = 0
> > 
> >         sendmail-974   [000] 55665.464507: sys_enter: NR 23 (5, 7fff60f3b0d0, 0, 0, 7fff60f3b150, 7fff60f3ef01)
> > 
> >             sshd-978   [000] 55667.845359: sys_exit: NR 23 = 1
> > 
> >             sshd-978   [000] 55667.845373: sys_enter: NR 14 (0, 7fffc645ce90, 7fffc645cf10, 8, 0, 101010101010101)
> > 
> >             sshd-978   [000] 55667.845381: sys_exit: NR 14 = 0
> > 
> >             sshd-978   [000] 55667.845383: sys_enter: NR 14 (2, 7fffc645cf10, 0, 8, 0, 101010101010101)
> > 
> >             sshd-978   [000] 55667.845386: sys_exit: NR 14 = 0
> > 
> >             sshd-978   [000] 55667.845395: sys_enter: NR 0 (3, 7fffc6458f80, 4000, 1, 0, 0)
> > 
> >             sshd-978   [000] 55667.845478: sys_exit: NR 0 = 48
> > 
> > 
> > Signed-off-by: Josh Stone <jistone@redhat.com>
> > Cc: Jason Baron <jbaron@redhat.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Cc: Jiaying Zhang <jiayingz@google.com>
> > Cc: Martin Bligh <mbligh@google.com>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> 
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

How about compat syscalls? If we touch this code we better cover 
them as well.

	Ingo
