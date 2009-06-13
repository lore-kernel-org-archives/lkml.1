Return-Path: <linux-kernel-owner+w=401wt.eu-S1751530AbZFMLCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbZFMLCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZFMLCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:02:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56896 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbZFMLCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:02:35 -0400
Date: Sat, 13 Jun 2009 13:02:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perfcounters: print a sorted summary of annotated
	overhead lines
Message-ID: <20090613110229.GB18924@elte.hu>
References: <1244844682-12928-1-git-send-email-fweisbec@gmail.com> <1244844682-12928-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244844682-12928-2-git-send-email-fweisbec@gmail.com>
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

> It's can be very annoying to scroll down perf annotated output
> until we find relevant overhead.
> 
> Using the -l option, you can now have a small summary sorted per
> overhead in the beginning of the output.
> 
> Example:
> 
> ./perf annotate -l -k ../../vmlinux -s __lock_acquire
> 
> Sorted summary for file ../../vmlinux
> ----------------------------------------------
> 
>    12.04 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1653
>     4.61 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1740
>     3.77 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1775
>     3.56 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1653
>     2.93 /home/fweisbec/linux/linux-2.6-tip/arch/x86/include/asm/irqflags.h:15
>     2.83 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2545
>     2.30 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2594
>     2.20 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2388
>     2.20 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:730
>     2.09 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:730
>     2.09 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:138
>     1.88 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2548
>     1.47 /home/fweisbec/linux/linux-2.6-tip/arch/x86/include/asm/irqflags.h:15
>     1.36 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:2594
>     1.36 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:730
>     1.26 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1654
>     1.26 /home/fweisbec/linux/linux-2.6-tip/kernel/lockdep.c:1653

Nice!

I'm wondering how hard it would be to add wildcard support to the 
symbol matching, say:

  perf annotate "sys_*"               # Annotate all syscalls
  perf annotate "sched*"              # All scheduler functions
  perf annotate "*"                   # All symbols we know about

It would be slower, obviously - but pretty useful as well.

Also, perhaps an 'annotate top 10 overhead functions':

  perf annotate --top 10

Would be popular too ...

	Ingo
