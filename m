Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZDQGXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZDQGXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZDQGXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:23:36 -0400
Received: from gw.goop.org ([64.81.55.164]:55328 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZDQGXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:23:35 -0400
Message-ID: <49E82065.6010902@goop.org>
Date: Thu, 16 Apr 2009 23:23:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com> <20090417014209.GA24956@Krystal> <20090417014733.GB24956@Krystal>
In-Reply-To: <20090417014733.GB24956@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Hrm, well, the actual question is :
>
> given rcupdate_types.h only defines macros, and given we won't want to
> include all the headers that implement all the content of these macros,
> does it make sense to typically require people to either include
> rcupdate.h directly if they want to have the full includes required to
> expand the macros ?
>   

Well, any user of tracepoint who wants to directly or indirectly use 
DECLARE_TRACE() or DEFINE_TRACE() will need to include it, so it ends up 
getting included everywhere.

> If we do that, then including preempt.h in rcupdate_types.h is not
> necessary. However, tracepoint.h should now include preempt.h, because
> it would be cumbersome to require from every tracepoint.h users to
> include preempt.h.
>
> One way or another, we will have to include preempt.h under
> tracepoint.h, but I don't see it as a roadblock, given that preempt.h is
> quite slim.
>   

Our headers are a tangled mass, and including anything non-trivial tends 
to bring in everything.  Despite the fact that preempt.h doesn't include 
much explicitly, it does include non-trivial headers, and so will pull 
in a broad swath of headers.

For example, here's the list of 64 headers included by cpp from a .c 
file containing a single line: #include <linux/preempt.h>

"/home/jeremy/git/linux/arch/x86/include/asm/alternative.h"
"/home/jeremy/git/linux/arch/x86/include/asm/atomic_64.h"
"/home/jeremy/git/linux/arch/x86/include/asm/bitops.h"
"/home/jeremy/git/linux/arch/x86/include/asm/bug.h"
"/home/jeremy/git/linux/arch/x86/include/asm/cmpxchg_64.h"
"/home/jeremy/git/linux/arch/x86/include/asm/cpufeature.h"
"/home/jeremy/git/linux/arch/x86/include/asm/desc_defs.h"
"/home/jeremy/git/linux/arch/x86/include/asm/ds.h"
"/home/jeremy/git/linux/arch/x86/include/asm/ftrace.h"
"/home/jeremy/git/linux/arch/x86/include/asm/irqflags.h"
"/home/jeremy/git/linux/arch/x86/include/asm/kmap_types.h"
"/home/jeremy/git/linux/arch/x86/include/asm/math_emu.h"
"/home/jeremy/git/linux/arch/x86/include/asm/msr.h"
"/home/jeremy/git/linux/arch/x86/include/asm/page.h"
"/home/jeremy/git/linux/arch/x86/include/asm/page_64_types.h"
"/home/jeremy/git/linux/arch/x86/include/asm/page_types.h"
"/home/jeremy/git/linux/arch/x86/include/asm/paravirt.h"
"/home/jeremy/git/linux/arch/x86/include/asm/paravirt_types.h"
"/home/jeremy/git/linux/arch/x86/include/asm/percpu.h"
"/home/jeremy/git/linux/arch/x86/include/asm/pgtable_64_types.h"
"/home/jeremy/git/linux/arch/x86/include/asm/pgtable_types.h"
"/home/jeremy/git/linux/arch/x86/include/asm/posix_types_64.h"
"/home/jeremy/git/linux/arch/x86/include/asm/processor.h"
"/home/jeremy/git/linux/arch/x86/include/asm/ptrace-abi.h"
"/home/jeremy/git/linux/arch/x86/include/asm/ptrace.h"
"/home/jeremy/git/linux/arch/x86/include/asm/segment.h"
"/home/jeremy/git/linux/arch/x86/include/asm/sigcontext.h"
"/home/jeremy/git/linux/arch/x86/include/asm/string_64.h"
"/home/jeremy/git/linux/arch/x86/include/asm/swab.h"
"/home/jeremy/git/linux/arch/x86/include/asm/system.h"
"/home/jeremy/git/linux/arch/x86/include/asm/thread_info.h"
"/home/jeremy/git/linux/arch/x86/include/asm/types.h"
"/home/jeremy/git/linux/arch/x86/include/asm/vm86.h"
"/home/jeremy/git/linux/include/asm-generic/atomic.h"
"/home/jeremy/git/linux/include/asm-generic/bitops/fls64.h"
"/home/jeremy/git/linux/include/asm-generic/bitops/sched.h"
"/home/jeremy/git/linux/include/asm-generic/bug.h"
"/home/jeremy/git/linux/include/asm-generic/int-ll64.h"
"/home/jeremy/git/linux/include/asm-generic/page.h"
"/home/jeremy/git/linux/include/asm-generic/percpu.h"
"/home/jeremy/git/linux/include/linux/bitmap.h"
"/home/jeremy/git/linux/include/linux/bitops.h"
"/home/jeremy/git/linux/include/linux/byteorder/generic.h"
"/home/jeremy/git/linux/include/linux/byteorder/little_endian.h"
"/home/jeremy/git/linux/include/linux/compiler-gcc.h"
"/home/jeremy/git/linux/include/linux/compiler.h"
"/home/jeremy/git/linux/include/linux/cpumask.h"
"/home/jeremy/git/linux/include/linux/dynamic_debug.h"
"/home/jeremy/git/linux/include/linux/err.h"
"/home/jeremy/git/linux/include/linux/init.h"
"/home/jeremy/git/linux/include/linux/irqflags.h"
"/home/jeremy/git/linux/include/linux/kernel.h"
"/home/jeremy/git/linux/include/linux/list.h"
"/home/jeremy/git/linux/include/linux/log2.h"
"/home/jeremy/git/linux/include/linux/personality.h"
"/home/jeremy/git/linux/include/linux/posix_types.h"
"/home/jeremy/git/linux/include/linux/preempt.h"
"/home/jeremy/git/linux/include/linux/prefetch.h"
"/home/jeremy/git/linux/include/linux/stddef.h"
"/home/jeremy/git/linux/include/linux/string.h"
"/home/jeremy/git/linux/include/linux/swab.h"
"/home/jeremy/git/linux/include/linux/thread_info.h"
"/home/jeremy/git/linux/include/linux/tracepoint.h"
"/home/jeremy/git/linux/include/linux/types.h"
"/home/jeremy/git/linux/include/trace/events/pvops.h"


Using your patch to split out rcupdate_types.h, if I leave my pvops.h 
header as-is, I get:

  CC      arch/x86/kernel/asm-offsets.s
In file included from /home/jeremy/git/linux/arch/x86/include/asm/paravirt.h:18,
                 from /home/jeremy/git/linux/arch/x86/include/asm/irqflags.h:55,
                 from /home/jeremy/git/linux/include/linux/irqflags.h:57,
                 from /home/jeremy/git/linux/arch/x86/include/asm/system.h:11,
                 from /home/jeremy/git/linux/arch/x86/include/asm/processor.h:17,
                 from /home/jeremy/git/linux/include/linux/prefetch.h:14,
                 from /home/jeremy/git/linux/include/linux/list.h:6,
                 from /home/jeremy/git/linux/include/linux/module.h:9,
                 from /home/jeremy/git/linux/include/linux/crypto.h:21,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:7,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets.c:4:
/home/jeremy/git/linux/include/trace/events/pvops.h: In function 'trace_load_sp0':
/home/jeremy/git/linux/include/trace/events/pvops.h:31: error: implicit declaration of function 'preempt_disable_notrace'
/home/jeremy/git/linux/include/trace/events/pvops.h:31: error: implicit declaration of function 'smp_read_barrier_depends'
/home/jeremy/git/linux/include/trace/events/pvops.h:31: error: implicit declaration of function 'preempt_enable_notrace'
make[3]: *** [arch/x86/kernel/asm-offsets.s] Error 1


If I try to fix that by adding <linux/preempt.h> just before 
<linux/tracepoint.h> in pvops.h, I get:

  CC      arch/x86/kernel/asm-offsets.s
In file included from /home/jeremy/git/linux/include/linux/thread_info.h:55,
                 from /home/jeremy/git/linux/include/linux/preempt.h:9,
                 from /home/jeremy/git/linux/include/trace/events/pvops.h:4,
                 from /home/jeremy/git/linux/arch/x86/include/asm/paravirt.h:18,
                 from /home/jeremy/git/linux/arch/x86/include/asm/irqflags.h:55,
                 from /home/jeremy/git/linux/include/linux/irqflags.h:57,
                 from /home/jeremy/git/linux/arch/x86/include/asm/system.h:11,
                 from /home/jeremy/git/linux/arch/x86/include/asm/processor.h:17,
                 from /home/jeremy/git/linux/include/linux/prefetch.h:14,
                 from /home/jeremy/git/linux/include/linux/list.h:6,
                 from /home/jeremy/git/linux/include/linux/module.h:9,
                 from /home/jeremy/git/linux/include/linux/crypto.h:21,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:7,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets.c:4:
/home/jeremy/git/linux/arch/x86/include/asm/thread_info.h:34: error: expected specifier-qualifier-list before 'mm_segment_t'
In file included from /home/jeremy/git/linux/include/trace/events/pvops.h:4,
                 from /home/jeremy/git/linux/arch/x86/include/asm/paravirt.h:18,
                 from /home/jeremy/git/linux/arch/x86/include/asm/irqflags.h:55,
                 from /home/jeremy/git/linux/include/linux/irqflags.h:57,
                 from /home/jeremy/git/linux/arch/x86/include/asm/system.h:11,
                 from /home/jeremy/git/linux/arch/x86/include/asm/processor.h:17,
                 from /home/jeremy/git/linux/include/linux/prefetch.h:14,
                 from /home/jeremy/git/linux/include/linux/list.h:6,
                 from /home/jeremy/git/linux/include/linux/module.h:9,
                 from /home/jeremy/git/linux/include/linux/crypto.h:21,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:7,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets.c:4:
/home/jeremy/git/linux/include/linux/preempt.h:123: error: field 'link' has incomplete type
/home/jeremy/git/linux/include/linux/preempt.h: In function 'preempt_notifier_init':
/home/jeremy/git/linux/include/linux/preempt.h:133: error: implicit declaration of function 'INIT_HLIST_NODE'
In file included from /home/jeremy/git/linux/arch/x86/include/asm/paravirt.h:18,
                 from /home/jeremy/git/linux/arch/x86/include/asm/irqflags.h:55,
                 from /home/jeremy/git/linux/include/linux/irqflags.h:57,
                 from /home/jeremy/git/linux/arch/x86/include/asm/system.h:11,
                 from /home/jeremy/git/linux/arch/x86/include/asm/processor.h:17,
                 from /home/jeremy/git/linux/include/linux/prefetch.h:14,
                 from /home/jeremy/git/linux/include/linux/list.h:6,
                 from /home/jeremy/git/linux/include/linux/module.h:9,
                 from /home/jeremy/git/linux/include/linux/crypto.h:21,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:7,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets.c:4:
/home/jeremy/git/linux/include/trace/events/pvops.h: In function 'trace_load_sp0':
/home/jeremy/git/linux/include/trace/events/pvops.h:31: error: implicit declaration of function 'smp_read_barrier_depends'
In file included from /home/jeremy/git/linux/include/linux/module.h:9,
                 from /home/jeremy/git/linux/include/linux/crypto.h:21,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:7,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets.c:4:
/home/jeremy/git/linux/include/linux/list.h: At top level:
/home/jeremy/git/linux/include/linux/list.h:551: warning: conflicting types for 'INIT_HLIST_NODE'
/home/jeremy/git/linux/include/linux/list.h:551: error: static declaration of 'INIT_HLIST_NODE' follows non-static declaration
/home/jeremy/git/linux/include/linux/preempt.h:133: error: previous implicit declaration of 'INIT_HLIST_NODE' was here
In file included from /home/jeremy/git/linux/arch/x86/include/asm/i387.h:15,
                 from /home/jeremy/git/linux/arch/x86/include/asm/suspend_64.h:10,
                 from /home/jeremy/git/linux/arch/x86/include/asm/suspend.h:4,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:19,
                 from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets.c:4:
/home/jeremy/git/linux/include/linux/regset.h: In function 'copy_regset_to_user':
/home/jeremy/git/linux/include/linux/regset.h:338: error: 'struct thread_info' has no member named 'addr_limit'
/home/jeremy/git/linux/include/linux/regset.h: In function 'copy_regset_from_user':
/home/jeremy/git/linux/include/linux/regset.h:361: error: 'struct thread_info' has no member named 'addr_limit'
In file included from /home/jeremy/git/linux/arch/x86/kernel/asm-offsets.c:4:
/home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c: In function 'main':
/home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:43: error: 'struct thread_info' has no member named 'addr_limit'
/home/jeremy/git/linux/arch/x86/kernel/asm-offsets_64.c:47: error: 'struct thread_info' has no member named 'sysenter_return'
make[3]: *** [arch/x86/kernel/asm-offsets.s] Error 1


    J
