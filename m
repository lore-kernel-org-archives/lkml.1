Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZHZGfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZHZGfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZHZGfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:35:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52562 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZHZGfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:35:01 -0400
Date: Wed, 26 Aug 2009 08:34:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] tracing/syscall for 2.6.32
Message-ID: <20090826063436.GB13577@elte.hu>
References: <1251250742-6458-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251250742-6458-1-git-send-email-fweisbec@gmail.com>
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

> Hi Ingo,
> 
> Please pull the latest syscall tracing patches from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> 	tracing/core
> 
> The tree gathers fixes, renamings and adds a new pair of tracepoints
> for generic sysenter/sysexit tracing.
> 
> Some other patches are pending, beeing discussed. So there are probably
> more to come soon.
> 
> Josh Stone (4):
>       tracing: Rename FTRACE_SYSCALLS for tracepoints
>       tracing: Make syscall tracepoints conditional
>       tracing: Move tracepoint callbacks from declaration to definition
>       tracing: Create generic syscall TRACE_EVENTs
> 
>  arch/s390/Kconfig                   |    2 +-
>  arch/s390/defconfig                 |    2 +-
>  arch/s390/include/asm/thread_info.h |    4 +-
>  arch/s390/kernel/entry.S            |    2 +-
>  arch/s390/kernel/entry64.S          |    2 +-
>  arch/s390/kernel/ptrace.c           |   12 +++---
>  arch/x86/Kconfig                    |    2 +-
>  arch/x86/configs/i386_defconfig     |    2 +-
>  arch/x86/configs/x86_64_defconfig   |    2 +-
>  arch/x86/include/asm/thread_info.h  |   13 +++---
>  arch/x86/kernel/ptrace.c            |   16 +++----
>  include/linux/tracepoint.h          |   46 +++++++++--------------
>  include/trace/define_trace.h        |    5 ++
>  include/trace/events/syscalls.h     |   70 +++++++++++++++++++++++++++++++++++
>  include/trace/ftrace.h              |    9 ++++
>  include/trace/syscall.h             |   17 --------
>  kernel/trace/Kconfig                |    4 +-
>  kernel/trace/trace_syscalls.c       |   17 ++++----
>  kernel/tracepoint.c                 |   20 ++++++----
>  19 files changed, 154 insertions(+), 93 deletions(-)
>  create mode 100644 include/trace/events/syscalls.h

Pulled, thanks!

Heiko, Martin, do the S390 bits look good to you? I have build 
tested the S390 defconfig - it built fine beyond to pre-existing 
warnings:

/home/mingo/tip/net/sched/sch_api.c: In function 'qdisc_watchdog':
/home/mingo/tip/net/sched/sch_api.c:460: warning: initialization from incompatible pointer type
/home/mingo/tip/fs/ext2/namei.c: In function 'ext2_lookup':
/home/mingo/tip/fs/ext2/namei.c:73: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'

	Ingo
