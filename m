Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbXD2KsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbXD2KsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXD2KsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:48:22 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40030 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbXD2KsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:48:21 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Kasper Sandberg <lkml@metanurb.dk>
To: tglx@linutronix.de
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <1177842654.5791.85.camel@localhost.localdomain>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu>  <20070429071627.GC23638@1wt.eu>
	 <1177842654.5791.85.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 12:48:08 +0200
Message-Id: <1177843688.9756.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 12:30 +0200, Thomas Gleixner wrote:
> Willy,
<snip>
> As a sidenote: I really wonder if anybody noticed yet, that the whole
> CFS / SD comparison is so ridiculous, that it is not even funny anymore.
> CFS modifies the scheduler and nothing else, SD fiddles all over the
> kernel in interesting ways. 
> 

have you looked at diffstat lately? :)

sd:
 Documentation/sched-design.txt  |  241 +++++++
 Documentation/sysctl/kernel.txt |   14
 Makefile                        |    2
 fs/pipe.c                       |    7
 fs/proc/array.c                 |    2
 include/linux/init_task.h       |    4
 include/linux/sched.h           |   32 -
 kernel/sched.c                  | 1279
+++++++++++++++++++---------------------
 kernel/softirq.c                |    2
 kernel/sysctl.c                 |   26
 kernel/workqueue.c              |    2
 11 files changed, 919 insertions(+), 692 deletions(-)

cfs:
 Documentation/kernel-parameters.txt |   43
 Documentation/sched-design-CFS.txt  |  107 +
 Makefile                            |    2
 arch/i386/kernel/smpboot.c          |   13
 arch/i386/kernel/tsc.c              |    8
 arch/ia64/kernel/setup.c            |    6
 arch/mips/kernel/smp.c              |   11
 arch/sparc/kernel/smp.c             |   10
 arch/sparc64/kernel/smp.c           |   36
 fs/proc/array.c                     |   11
 fs/proc/base.c                      |    2
 fs/proc/internal.h                  |    1
 include/asm-i386/unistd.h           |    3
 include/asm-x86_64/unistd.h         |    4
 include/linux/hardirq.h             |   13
 include/linux/sched.h               |   94 +
 init/main.c                         |    2
 kernel/exit.c                       |    3
 kernel/fork.c                       |    4
 kernel/posix-cpu-timers.c           |   34
 kernel/sched.c                      | 2288
+++++++++---------------------------
 kernel/sched_debug.c                |  152 ++
 kernel/sched_fair.c                 |  601 +++++++++
 kernel/sched_rt.c                   |  184 ++
 kernel/sched_stats.h                |  235 +++
 kernel/sysctl.c                     |   32
 26 files changed, 2062 insertions(+), 1837 deletions(-)


> This is worse than apples and oranges, it's more like apples and
> screwdrivers. 
<snip>
> 
> 	tglx
> 
> 
> 

