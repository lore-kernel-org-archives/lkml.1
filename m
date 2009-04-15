Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbZDOK1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbZDOK1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZDOK07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:26:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45811 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbZDOK05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:26:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain>
References: <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, tj@kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Date: Wed, 15 Apr 2009 11:24:30 +0100
Message-ID: <2193.1239791070@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Hmm. Why not move it all above the '#include <asm/percpu.h>'?

There are circular dependencies between the x86 arch headers that both use
this and are used to implement this, and it's a bit fragile.

David
---
Compilation started at Wed Apr 15 11:20:49

LANG=C nice -19 make -C //warthog/nfs/linux-2.6-fscache -j3
make: Entering directory `/warthog/nfs/linux-2.6-fscache'
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      arch/x86/kernel/asm-offsets.s
In file included from /warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:5,
                 from /warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:15,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/percpu.h:156: error: expected declaration specifiers or '...' before 'this_cpu_off'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/percpu.h:156: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/percpu.h:156: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
In file included from /warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:15,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:10: error: expected declaration specifiers or '...' before 'current_task'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:10: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:10: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:10: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/percpu.h:156: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h: In function 'get_current':
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:14: error: 'per_cpu__current_task' undeclared (first use in this function)
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:14: error: (Each undeclared identifier is reported only once
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:14: error: for each function it appears in.)
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:14: warning: type defaults to 'int' in declaration of 'ret__'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/current.h:14: warning: return makes pointer from integer without a cast
In file included from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h: At top level:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:141: error: expected declaration specifiers or '...' before 'cpu_info'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:141: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:141: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU_SHARED_ALIGNED'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:273: error: expected declaration specifiers or '...' before 'init_tss'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:273: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:273: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU_SHARED_ALIGNED'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:273: error: conflicting types for 'DECLARE_PER_CPU_SHARED_ALIGNED'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:141: error: previous declaration of 'DECLARE_PER_CPU_SHARED_ALIGNED' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:381: error: expected declaration specifiers or '...' before 'orig_ist'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:381: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:381: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:381: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/percpu.h:156: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:396: error: expected declaration specifiers or '...' before 'irq_stack_union'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:396: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:396: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU_FIRST'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:397: error: implicit declaration of function 'per_cpu_var'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:397: error: 'irq_stack_union' undeclared here (not in a function)
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:399: error: expected declaration specifiers or '...' before 'irq_stack_ptr'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:399: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:399: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:399: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/percpu.h:156: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:400: error: expected declaration specifiers or '...' before 'irq_count'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:400: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:400: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/processor.h:400: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/percpu.h:156: error: previous declaration of 'DECLARE_PER_CPU' was here
In file included from include/linux/thread_info.h:55,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: expected declaration specifiers or '...' before 'kernel_stack'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h: In function 'current_thread_info':
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:214: error: 'per_cpu__kernel_stack' undeclared (first use in this function)
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:214: warning: type defaults to 'int' in declaration of 'ret__'
In file included from /warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:13,
                 from include/linux/smp.h:36,
                 from include/linux/topology.h:33,
                 from include/linux/gfp.h:7,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h: At top level:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:435: error: expected declaration specifiers or '...' before 'x2apic_extra_bits'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:435: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:435: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:435: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: previous declaration of 'DECLARE_PER_CPU' was here
In file included from /warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:13,
                 from include/linux/smp.h:36,
                 from include/linux/topology.h:33,
                 from include/linux/gfp.h:7,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:466: error: expected declaration specifiers or '...' before 'x86_bios_cpu_apicid'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:466: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:466: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:466: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h: In function '__default_cpu_present_to_apicid':
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:545: error: implicit declaration of function 'per_cpu'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/apic.h:545: error: 'x86_bios_cpu_apicid' undeclared (first use in this function)
In file included from include/linux/smp.h:36,
                 from include/linux/topology.h:33,
                 from include/linux/gfp.h:7,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h: At top level:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:24: error: expected declaration specifiers or '...' before 'cpu_sibling_map'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:24: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:24: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:24: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:25: error: expected declaration specifiers or '...' before 'cpu_core_map'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:25: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:25: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:25: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:26: error: expected declaration specifiers or '...' before 'cpu_llc_id'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:26: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:26: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:26: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:27: error: expected declaration specifiers or '...' before 'cpu_number'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:27: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:27: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:27: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h: In function 'cpu_sibling_mask':
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:31: error: 'cpu_sibling_map' undeclared (first use in this function)
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:31: warning: return makes pointer from integer without a cast
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h: In function 'cpu_core_mask':
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:36: error: 'cpu_core_map' undeclared (first use in this function)
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:36: warning: return makes pointer from integer without a cast
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h: At top level:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:39: error: expected declaration specifiers or '...' before 'x86_cpu_to_apicid'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:39: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:39: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:39: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: previous declaration of 'DECLARE_PER_CPU' was here
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:40: error: expected declaration specifiers or '...' before 'x86_bios_cpu_apicid'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:40: warning: data definition has no type or storage class
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:40: warning: type defaults to 'int' in declaration of 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/smp.h:40: error: conflicting types for 'DECLARE_PER_CPU'
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/thread_info.h:209: error: previous declaration of 'DECLARE_PER_CPU' was here
In file included from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/gfp.h: In function 'alloc_pages_node':
include/linux/gfp.h:198: error: 'per_cpu__cpu_number' undeclared (first use in this function)
include/linux/gfp.h:198: warning: type defaults to 'int' in declaration of 'ret__'
In file included from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:7,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/module.h: In function '__module_get':
include/linux/module.h:450: error: 'per_cpu__cpu_number' undeclared (first use in this function)
include/linux/module.h:450: warning: type defaults to 'int' in declaration of 'ret__'
include/linux/module.h: In function 'try_module_get':
include/linux/module.h:460: error: 'per_cpu__cpu_number' undeclared (first use in this function)
include/linux/module.h:460: warning: type defaults to 'int' in declaration of 'ret__'
In file included from include/linux/mm.h:595,
                 from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets_64.c:12,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/vmstat.h: In function '__count_vm_event':
include/linux/vmstat.h:78: error: 'per_cpu__this_cpu_off' undeclared (first use in this function)
include/linux/vmstat.h:78: warning: type defaults to 'int' in declaration of 'ret__'
include/linux/vmstat.h: In function 'count_vm_event':
include/linux/vmstat.h:83: error: 'per_cpu__this_cpu_off' undeclared (first use in this function)
include/linux/vmstat.h:83: warning: type defaults to 'int' in declaration of 'ret__'
include/linux/vmstat.h: In function '__count_vm_events':
include/linux/vmstat.h:89: error: 'per_cpu__this_cpu_off' undeclared (first use in this function)
include/linux/vmstat.h:89: warning: type defaults to 'int' in declaration of 'ret__'
include/linux/vmstat.h: In function 'count_vm_events':
include/linux/vmstat.h:94: error: 'per_cpu__this_cpu_off' undeclared (first use in this function)
include/linux/vmstat.h:94: warning: type defaults to 'int' in declaration of 'ret__'
In file included from /warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/suspend_64.h:9,
                 from /warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/suspend.h:4,
                 from arch/x86/kernel/asm-offsets_64.c:19,
                 from arch/x86/kernel/asm-offsets.c:4:
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/desc.h: In function 'native_set_ldt':
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/desc.h:202: error: 'per_cpu__cpu_number' undeclared (first use in this function)
/warthog/nfs/linux-2.6-fscache/arch/x86/include/asm/desc.h:202: warning: type defaults to 'int' in declaration of 'ret__'
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2
make: Leaving directory `/warthog/nfs/linux-2.6-fscache'

Compilation exited abnormally with code 2 at Wed Apr 15 11:20:49
