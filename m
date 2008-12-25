Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbYLYH3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbYLYH3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 02:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYLYH3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 02:29:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52848 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLYH3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 02:29:12 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] Performance Counters for Linux, v5
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20081223124058.GA11525@elte.hu>
References: <20081223124058.GA11525@elte.hu>
Message-Id: <20081225162242.50E8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Dec 2008 16:29:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Currently, -tip tree can't build on my ia64 box.
because..

>  create mode 100644 Documentation/perf-counters.txt
>  delete mode 100644 arch/x86/include/asm/intel_arch_perfmon.h
>  create mode 100644 arch/x86/include/asm/perf_counter.h
>  create mode 100644 arch/x86/kernel/cpu/perf_counter.c
>  rename arch/x86/kernel/{signal_32.c => signal.c} (74%)
>  delete mode 100644 arch/x86/kernel/signal_64.c
>  create mode 100644 include/linux/perf_counter.h
>  create mode 100644 kernel/perf_counter.c


Only x86 has <asm/perf_counter.h>.



> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> new file mode 100644
> index 0000000..ec77d16
> --- /dev/null
> +++ b/include/linux/perf_counter.h
> @@ -0,0 +1,254 @@
> +/*
> + *  Performance counters:
> + *
> + *   Copyright(C) 2008, Thomas Gleixner <tglx@linutronix.de>
> + *   Copyright(C) 2008, Red Hat, Inc., Ingo Molnar
> + *
> + *  Data type definitions, declarations, prototypes.
> + *
> + *  Started by: Thomas Gleixner and Ingo Molnar
> + *
> + *  For licencing details see kernel-base/COPYING
> + */
> +#ifndef _LINUX_PERF_COUNTER_H
> +#define _LINUX_PERF_COUNTER_H
> +
> +#include <asm/atomic.h>
> +#include <asm/perf_counter.h>
> +

<linux/perf_counter.h> depend on <asm/perf_counter.h>.


> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 55e30d1..2e15be8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -71,6 +71,7 @@ struct sched_param {
>  #include <linux/fs_struct.h>
>  #include <linux/compiler.h>
>  #include <linux/completion.h>
> +#include <linux/perf_counter.h>
>  #include <linux/pid.h>
>  #include <linux/percpu.h>
>  #include <linux/topology.h>

<linux/sched.h> depend on <linux/perf_counter.h>

Oops, sched.h depend on <asm/perf_counter.h>, but non x86 doesn't have it.



