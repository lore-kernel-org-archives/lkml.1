Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYJQQXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYJQQXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYJQQXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:23:43 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:58726 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754446AbYJQQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:23:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAERW+EhMQWq+/2dsb2JhbACBcr8Fg2w
Date: Fri, 17 Oct 2008 12:23:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC patch 07/15] LTTng timestamp
Message-ID: <20081017162339.GC5696@Krystal>
References: <20081016232729.699004293@polymtl.ca> <20081016234656.542407833@polymtl.ca> <20081017171212.E230.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081017171212.E230.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:23:06 up 134 days, 21:03,  9 users,  load average: 0.97, 0.80,
	1.24
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> 
> more nit.
> 
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/delay.h>
> > +#include <linux/timer.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/cpu.h>
> > +#include <linux/timex.h>
> > +#include <linux/bitops.h>
> > +#include <linux/ltt.h>
> 
> ltt.h is created by 08/15. then following build error happend.
> 
> make[1]: `include/asm-ia64/nr-irqs.h' is up to date.
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   GZIP    kernel/config_data.gz
>   IKCFG   kernel/config_data.h
>   CC      kernel/configs.o
>   LD      kernel/built-in.o
>   CC      ltt/ltt-timestamp.o
> ltt/ltt-timestamp.c:23:23: error: linux/ltt.h: No such file or directory
> ltt/ltt-timestamp.c: In function 'ltt_update_synthetic_tsc':
> ltt/ltt-timestamp.c:75: error: implicit declaration of function 'ltt_get_timestamp32'
> ltt/ltt-timestamp.c: In function 'precalc_stsc_interval':
> ltt/ltt-timestamp.c:157: error: implicit declaration of function 'ltt_frequency'
> ltt/ltt-timestamp.c:157: error: implicit declaration of function 'ltt_freq_scale'
> make[1]: *** [ltt/ltt-timestamp.o] Error 1
> make: *** [ltt] Error 2
> 

Thanks for pointing this out. Will fix in the next release with the
following patchset order :

get-cycles-kconfig-have-get-cycles.patch
get-cycles-x86-have-get-cycles.patch
get-cycles-sparc64-have-get-cycles.patch
get-cycles-powerpc-have-get-cycles.patch
get-cycles-mips-have-get-cycles.patch

#LTTng timestamping
#
lttng-timestamp-core.patch
lttng-timestamp-generic.patch
lttng-build-instrumentation-menu.patch
lttng-build-instrumentation-menu-timestamp.patch
lttng-mips-export-hpt-frequency.patch
lttng-timestamp-mips.patch
lttng-timestamp-powerpc.patch
lttng-timestamp-sparc64.patch
lttng-timestamp-sh.patch
lttng-test-tsc.patch
lttng-timestamp-x86.patch

Mathieu

> 
> > +#include <linux/smp.h>
> > +#include <linux/sched.h> /* FIX for m68k local_irq_enable in on_each_cpu */
> 
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
