Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbXKTHEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbXKTHEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbXKTHEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:04:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42432 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbXKTHEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:04:35 -0500
Date: Tue, 20 Nov 2007 08:04:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 1/6] actual sys_indirect code
Message-ID: <20071120070414.GA543@elte.hu>
References: <200711200653.lAK6rEVB025878@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711200653.lAK6rEVB025878@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


cool patchset. Small nit, the series is not bisectable:

> +#include <asm/indirect.h>

> --- kernel/Makefile
> +++ kernel/Makefile
> @@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
>  	    rcupdate.o extable.o params.o posix-timers.o \
>  	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>  	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
> -	    utsname.o notifier.o
> +	    utsname.o notifier.o indirect.o

indirect.o is built unconditionally, but it wont build at this stage 
because asm/indirect.h is only introduced in later patches. I suspect a 
CONFIG_ARCH_SUPPORTS_INDIRECT_SYSCALLS Kconfig flag, and its use in the 
Makefile ought to do the trick. (it also reduces object size on 
architectures that have no support for indirect syscalls (yet))

	Ingo
