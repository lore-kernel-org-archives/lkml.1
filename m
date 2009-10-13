Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbZJMGXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbZJMGXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbZJMGXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:23:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33495 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbZJMGXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:23:23 -0400
Date: Tue, 13 Oct 2009 08:22:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch . Eigler" <fche@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Syntax updates, introduce perf
	probe
Message-ID: <20091013062227.GA8051@elte.hu>
References: <1255386309-4992-1-git-send-email-fweisbec@gmail.com> <20091013061323.GE3215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013061323.GE3215@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> >  tools/perf/Makefile                 |   10 +
> >  tools/perf/builtin-probe.c          |  386 +++++++++++++++++++
> >  tools/perf/builtin.h                |    1 +
> >  tools/perf/perf.c                   |    1 +
> >  tools/perf/util/probe-finder.c      |  690 +++++++++++++++++++++++++++++++++++
> >  tools/perf/util/probe-finder.h      |   70 ++++
> >  8 files changed, 1271 insertions(+), 74 deletions(-)
> >  create mode 100644 tools/perf/builtin-probe.c
> >  create mode 100644 tools/perf/util/probe-finder.c
> >  create mode 100644 tools/perf/util/probe-finder.h
> 
> Hm, there's no x86 decoder change here - does this lot fixes the 
> instruction decoder bug i reported some time ago? That is which keeps 
> tracing/kprobes out of tip:master.

See my previous report below.

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Sat, 3 Oct 2009 12:49:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] tracing/kprobes: kprobes fixes
Cc: LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Li Zefan <lizf@cn.fujitsu.com>


ok, -tip testing found this new failure:

  TEST    posttest
Error: ffffffff8106ac00:        66 0f 73 fd 04          pslldq $0x4,%xmm5
Error: objdump says 5 bytes, but insn_get_length() says 4 (attr:8000)
make[1]: *** [posttest] Error 2
make: *** [bzImage] Error 2

	Ingo

----- End forwarded message -----
