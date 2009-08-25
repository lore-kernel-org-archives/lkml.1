Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZHYVoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZHYVoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZHYVoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:44:07 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45903 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbZHYVoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q9r5QfBcW7HrwtHZqJ8dXu4Z1dxCzpJr+JqfoWwDufkRP6JfZuQpWNfwQkIpzbpa4y
         vByOVABA7/xPDn3o4Y3oqeXFGqhztjQbrKcRvqOV/twuWAXZiw5GHhfexy7X4qqh26b1
         nkJBVCc7pCNKnJGvmgpzHVtA6WoQQVM70NKsY=
Date: Tue, 25 Aug 2009 23:44:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v4 0/4] tracing: tweaks for generic syscall events
Message-ID: <20090825214402.GH8215@nowhere>
References: <1250917125-6174-1-git-send-email-jistone@redhat.com> <1251150194-1713-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251150194-1713-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 02:43:10PM -0700, Josh Stone wrote:
> This patch series moves the callbacks for the syscall tracepoints to the
> definition site, and adds generic TRACE_EVENTs which capture all syscall
> arguments.
> 
> New in v3:
> - Give the thread flag a more generic name: TIF_SYSCALL_TRACEPOINT.
> - Move the regfuncs to arch-specific files, per Jason's suggestion.
> - Change _WITH_CALLBACK to just _FN, per Ingo's suggestion.
> 
> New in v4:
> - Give the config flag a more generic name: HAVE_SYSCALL_TRACEPOINTS.
> - Undo the arch reorg of the regfuncs, but conditionalize on above.
> 
> 
> Sample trace output:
>         sendmail-974   [000] 55665.464492: sys_enter: NR 14 (1, 7fff60f3af40, 7fff60f3aec0, 8, 0, 7fb1b6a05161)
> 
>         sendmail-974   [000] 55665.464496: sys_exit: NR 14 = 0
> 
>         sendmail-974   [000] 55665.464507: sys_enter: NR 23 (5, 7fff60f3b0d0, 0, 0, 7fff60f3b150, 7fff60f3ef01)
> 
>             sshd-978   [000] 55667.845359: sys_exit: NR 23 = 1
> 
>             sshd-978   [000] 55667.845373: sys_enter: NR 14 (0, 7fffc645ce90, 7fffc645cf10, 8, 0, 101010101010101)
> 
>             sshd-978   [000] 55667.845381: sys_exit: NR 14 = 0
> 
>             sshd-978   [000] 55667.845383: sys_enter: NR 14 (2, 7fffc645cf10, 0, 8, 0, 101010101010101)
> 
>             sshd-978   [000] 55667.845386: sys_exit: NR 14 = 0
> 
>             sshd-978   [000] 55667.845395: sys_enter: NR 0 (3, 7fffc6458f80, 4000, 1, 0, 0)
> 
>             sshd-978   [000] 55667.845478: sys_exit: NR 0 = 48
> 
> 
> Signed-off-by: Josh Stone <jistone@redhat.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Jiaying Zhang <jiayingz@google.com>
> Cc: Martin Bligh <mbligh@google.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Paul Mundt <lethal@linux-sh.org>


Queued for .32, thanks!


> ---
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
> 

