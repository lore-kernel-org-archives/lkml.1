Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbXFAQmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbXFAQmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbXFAQmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:42:12 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:41749 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbXFAQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:42:09 -0400
Date: Fri, 1 Jun 2007 17:42:04 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: 2.6.22-rc3-mm1: IA64 make allnoconfig broken
Message-ID: <20070601164204.GA25049@skynet.ie>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (30/05/07 23:58), Andrew Morton didst pronounce:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
> 
> - Merged the convert-cpusets-to-container-infrastructure patches.  These
>   will probably be dropped and redone.
> 

Came across this while automating allnoconfig, allmodconfig
and defconfig build tests. I haven't checked to make 100% sure but
rework-ptep_set_access_flags-and-fix-sun4c.patch is the most likely candidate
based on the error - patch author cc'd.

Test result
===========
Machine name: elm3b10
Architecture: ia64
Build args:   kernel 2.6.22-rc3-mm1 
Result:       Failed

Standard build:          Completed successfully
make allnoconfig build:  Failed and terminated the run
06/01/07-08:10:54 building kernel - make -j4 vmlinux.gz
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-ia64
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  CC      arch/ia64/kernel/asm-offsets.s
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  GEN     include/asm-ia64/asm-offsets.h
  CALL    scripts/checksyscalls.sh
<stdin>:1380:2: warning: #warning syscall revokeat not implemented
<stdin>:1384:2: warning: #warning syscall frevoke not implemented
<stdin>:1392:2: warning: #warning syscall sched_yield_to not implemented
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/mod/sumversion.o
  HOSTCC  scripts/conmakehash
  HOSTLD  scripts/mod/modpost
  CC      init/main.o
  LD      usr/built-in.o
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      arch/ia64/kernel/acpi.o
  CC      init/do_mounts.o
  AS      arch/ia64/kernel/entry.o
  CC      arch/ia64/kernel/efi.o
  CC      init/noinitramfs.o
  CC      init/calibrate.o
  CC      init/version.o
  LD      init/mounts.o
  LD      init/built-in.o
  AS      arch/ia64/kernel/efi_stub.o
  CC      arch/ia64/mm/init.o
  LDS     arch/ia64/kernel/gate.lds
  AS      arch/ia64/kernel/gate.o
  AS      arch/ia64/kernel/fsys.o
  CC      arch/ia64/kernel/ia64_ksyms.o
  CC      arch/ia64/kernel/irq.o
  CC      arch/ia64/mm/fault.o
  CC      arch/ia64/kernel/irq_ia64.o
  CC      arch/ia64/mm/tlb.o
  CC      arch/ia64/kernel/irq_lsapic.o
  CC      arch/ia64/mm/extable.o
  AS      arch/ia64/kernel/ivt.o
  CC      arch/ia64/kernel/machvec.o
  CC      arch/ia64/mm/ioremap.o
  AS      arch/ia64/kernel/pal.o
  CC      arch/ia64/kernel/patch.o
  CC      arch/ia64/kernel/process.o
  CC      arch/ia64/mm/numa.o
  CC      arch/ia64/mm/discontig.o
  CC      arch/ia64/kernel/perfmon.o
  LD      arch/ia64/mm/built-in.o
  CC      arch/ia64/kernel/ptrace.o
  CC      arch/ia64/dig/setup.o
  CC      arch/ia64/dig/machvec.o
  LD      arch/ia64/dig/built-in.o
  CC      arch/ia64/kernel/sal.o
  CC      kernel/sched.o
  CC      arch/ia64/kernel/salinfo.o
  CC      arch/ia64/kernel/semaphore.o
  CC      arch/ia64/kernel/setup.o
  CC      arch/ia64/kernel/signal.o
{standard input}: Assembler messages:
{standard input}:12494: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12494: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12494: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12494: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12494: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12494: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12494: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12494: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12494: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12494: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12495: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12495: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12493: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12494: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12495: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12495: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12495: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12495: Warning: This is the location of the conflicting usage
{standard input}:12496: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:12496: Warning: Only the first path encountering the conflict is reported
{standard input}:12495: Warning: This is the location of the conflicting usage
  CC      kernel/fork.o
  CC      arch/ia64/kernel/sys_ia64.o
  CC      arch/ia64/kernel/time.o
  CC      arch/ia64/kernel/traps.o
{standard input}: Assembler messages:
{standard input}:3480: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3480: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3480: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3480: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3480: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3480: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3480: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3480: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3480: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3480: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3481: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3481: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3479: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3480: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3481: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3481: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3481: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3481: Warning: This is the location of the conflicting usage
{standard input}:3482: Warning: Use of 'mov' may violate WAW dependency 'RR#' (impliedf)
{standard input}:3482: Warning: Only the first path encountering the conflict is reported
{standard input}:3481: Warning: This is the location of the conflicting usage
  CC      kernel/exec_domain.o
  CC      kernel/panic.o
  CC      arch/ia64/kernel/unaligned.o
  CC      kernel/printk.o
  CC      arch/ia64/kernel/unwind.o
  CC      kernel/profile.o
  CC      kernel/exit.o
  CC      arch/ia64/kernel/mca.o
  CC      kernel/itimer.o
  CC      kernel/time.o
  CC      kernel/softirq.o
  AS      arch/ia64/kernel/mca_asm.o
  CC      arch/ia64/kernel/topology.o
  CC      kernel/resource.o
  CC      arch/ia64/kernel/brl_emu.o
  CC      kernel/sysctl.o
  CC      arch/ia64/kernel/acpi-ext.o
  CC      arch/ia64/kernel/iosapic.o
  CC      arch/ia64/kernel/numa.o
  CC      kernel/capability.o
  GATE arch/ia64/kernel/gate-syms.o
  AS      arch/ia64/kernel/head.o
  CC      arch/ia64/kernel/init_task.o
  CC      kernel/ptrace.o
  LDS     arch/ia64/kernel/vmlinux.lds
  GATE arch/ia64/kernel/gate.so
  AS      arch/ia64/kernel/gate-data.o
  LD      arch/ia64/kernel/built-in.o
  CC      kernel/timer.o
  CC      mm/bootmem.o
  CC      kernel/user.o
  CC      mm/filemap.o
  CC      kernel/signal.o
  CC      mm/mempool.o
  CC      kernel/sys.o
  CC      mm/oom_kill.o
  CC      mm/fadvise.o
  CC      mm/page_alloc.o
  CC      kernel/kmod.o
  CC      kernel/workqueue.o
  CC      kernel/pid.o
  CC      kernel/rcupdate.o
  CC      kernel/extable.o
  CC      mm/page-writeback.o
  CC      kernel/params.o
  CC      kernel/posix-timers.o
  CC      mm/pdflush.o
  CC      mm/readahead.o
  CC      kernel/kthread.o
  CC      mm/swap.o
  CC      kernel/wait.o
  CC      kernel/kfifo.o
  CC      mm/truncate.o
  CC      kernel/sys_ni.o
  CC      kernel/posix-cpu-timers.o
  CC      mm/vmscan.o
  CC      kernel/mutex.o
  CC      kernel/hrtimer.o
{standard input}: Assembler messages:
{standard input}:2603: Warning: Use of 'mov' may violate WAW dependency 'GR%, % in 1 - 127' (impliedf), specific resource number is 14
{standard input}:2603: Warning: Only the first path encountering the conflict is reported
{standard input}:2602: Warning: This is the location of the conflicting usage
  CC      mm/prio_tree.o
  CC      mm/util.o
  CC      kernel/rwsem.o
  CC      kernel/latency.o
  CC      mm/mmzone.o
  CC      kernel/nsproxy.o
  CC      mm/vmstat.o
  CC      kernel/srcu.o
  CC      mm/backing-dev.o
  CC      kernel/die_notifier.o
  CC      mm/fremap.o
  CC      kernel/irq/handle.o
  CC      mm/highmem.o
  CC      kernel/irq/manage.o
  CC      mm/madvise.o
  CC      kernel/irq/spurious.o
  CC      mm/memory.o
  CC      kernel/irq/resend.o
mm/memory.c: In function `do_wp_page':
mm/memory.c:1700: error: parse error before "__changed"
mm/memory.c:1700: error: parse error before ')' token
mm/memory.c:1704: error: parse error before "ret"
mm/memory.c:1639: warning: unused variable `new_page'
mm/memory.c:1641: warning: unused variable `ret'
mm/memory.c:1689: error: label `unlock' used but not defined
mm/memory.c:1677: error: label `unwritable_page' used but not defined
mm/memory.c:1646: error: label `gotten' used but not defined
mm/memory.c: At top level:
mm/memory.c:1713: error: parse error before "while"
mm/memory.c:1725: warning: type defaults to `int' in declaration of `cow_user_page'
mm/memory.c:1725: warning: parameter names (without types) in function declaration
mm/memory.c:1725: error: conflicting types for `cow_user_page'
mm/memory.c:1590: error: previous declaration of `cow_user_page'
mm/memory.c:1725: warning: data definition has no type or storage class
mm/memory.c:1726: error: parse error before '}' token
mm/memory.c:1731: warning: type defaults to `int' in declaration of `page_table'
mm/memory.c:1731: error: braced-group within expression allowed only inside a function
mm/memory.c:1731: error: `pmd' undeclared here (not in a function)
mm/memory.c:1731: warning: data definition has no type or storage class
mm/memory.c:1731: error: parse error before '&' token
mm/memory.c:1731: error: braced-group within expression allowed only inside a function
mm/memory.c:1731: error: `pmd' undeclared here (not in a function)
mm/memory.c:1731: error: parse error before ';' token
mm/memory.c:1731: error: `address' undeclared here (not in a function)
mm/memory.c:1731: error: parse error before ')' token
mm/memory.c:1731: error: parse error before '&' token
mm/memory.c:1731: warning: type defaults to `int' in declaration of `__pte'
mm/memory.c:1731: error: conflicting types for `__pte'
mm/memory.c:1731: error: previous declaration of `__pte'
mm/memory.c:1731: warning: data definition has no type or storage class
mm/memory.c:1731: error: parse error before '}' token
mm/memory.c:1737: error: parse error before '->' token
mm/memory.c:1742: warning: type defaults to `int' in declaration of `entry'
mm/memory.c:1742: error: braced-group within expression allowed only inside a function
mm/memory.c:1742: error: parse error before ')' token
mm/memory.c:1742: error: `__pg' undeclared here (not in a function)
mm/memory.c:1742: error: initializer element is not constant
mm/memory.c:1742: error: parse error before "unsigned"
mm/memory.c:1742: warning: type defaults to `int' in declaration of `__pte'
mm/memory.c:1742: warning: data definition has no type or storage class
mm/memory.c:1742: error: parse error before '}' token
mm/memory.c:1743: warning: type defaults to `int' in declaration of `entry'
mm/memory.c:1743: error: redefinition of `entry'
mm/memory.c:1742: error: `entry' previously defined here
mm/memory.c:1743: error: request for member `pte' in something not a structure or union
mm/memory.c:1743: error: `vma' undeclared here (not in a function)
mm/memory.c:1743: error: incompatible types in initialization
mm/memory.c:1743: error: initializer element is not constant
mm/memory.c:1743: warning: data definition has no type or storage class
mm/memory.c:1744: warning: type defaults to `int' in declaration of `lazy_mmu_prot_update'
mm/memory.c:1744: warning: parameter names (without types) in function declaration
mm/memory.c:1744: error: conflicting types for `lazy_mmu_prot_update'
include/asm/pgtable.h:510: error: previous declaration of `lazy_mmu_prot_update'
mm/memory.c:1744: warning: data definition has no type or storage class
mm/memory.c:1751: error: parse error before '{' token
mm/memory.c:1751: warning: type defaults to `int' in declaration of `__pte'
mm/memory.c:1751: error: `vma' undeclared here (not in a function)
mm/memory.c:1751: error: `address' undeclared here (not in a function)
mm/memory.c:1751: warning: passing arg 3 of `ptep_get_and_clear' makes pointer from integer without a cast
mm/memory.c:1751: error: incompatible types in initialization
mm/memory.c:1751: error: initializer element is not constant
mm/memory.c:1751: warning: data definition has no type or storage class
mm/memory.c:1751: warning: type defaults to `int' in declaration of `flush_tlb_page'
mm/memory.c:1751: warning: parameter names (without types) in function declaration
mm/memory.c:1751: error: conflicting types for `flush_tlb_page'
include/asm/tlbflush.h:75: error: previous declaration of `flush_tlb_page'
mm/memory.c:1751: warning: data definition has no type or storage class
mm/memory.c:1751: warning: type defaults to `int' in declaration of `__pte'
mm/memory.c:1751: warning: data definition has no type or storage class
mm/memory.c:1751: error: parse error before '}' token
mm/memory.c:1752: error: parse error before '=' token
mm/memory.c:1754: warning: type defaults to `int' in declaration of `lru_cache_add_active'
mm/memory.c:1754: warning: parameter names (without types) in function declaration
mm/memory.c:1754: error: conflicting types for `lru_cache_add_active'
include/linux/swap.h:182: error: previous declaration of `lru_cache_add_active'
mm/memory.c:1754: warning: data definition has no type or storage class
mm/memory.c:1755: warning: type defaults to `int' in declaration of `page_add_new_anon_rmap'
mm/memory.c:1755: warning: parameter names (without types) in function declaration
mm/memory.c:1755: error: conflicting types for `page_add_new_anon_rmap'
include/linux/rmap.h:73: error: previous declaration of `page_add_new_anon_rmap'
mm/memory.c:1755: warning: data definition has no type or storage class
mm/memory.c:1758: warning: type defaults to `int' in declaration of `new_page'
mm/memory.c:1758: error: `old_page' undeclared here (not in a function)
mm/memory.c:1758: warning: data definition has no type or storage class
mm/memory.c:1759: error: parse error before '|=' token
mm/memory.c:1777: warning: type defaults to `int' in declaration of `set_page_dirty_balance'
mm/memory.c:1777: warning: parameter names (without types) in function declaration
mm/memory.c:1777: error: conflicting types for `set_page_dirty_balance'
include/linux/writeback.h:130: error: previous declaration of `set_page_dirty_balance'
mm/memory.c:1777: warning: data definition has no type or storage class
mm/memory.c:1778: warning: type defaults to `int' in declaration of `put_page'
mm/memory.c:1778: warning: parameter names (without types) in function declaration
mm/memory.c:1778: error: conflicting types for `put_page'
include/linux/mm.h:334: error: previous declaration of `put_page'
mm/memory.c:1778: warning: data definition has no type or storage class
mm/memory.c:1779: error: parse error before '}' token
mm/memory.c: In function `handle_pte_fault':
mm/memory.c:2544: error: parse error before "__changed"
mm/memory.c:2544: error: parse error before ')' token
mm/memory.c:2547: error: parse error before "else"
mm/memory.c:2536: error: label `unlock' used but not defined
mm/memory.c: At top level:
mm/memory.c:2557: error: parse error before ':' token
{standard input}: Assembler messages:
{standard input}:88: Error: symbol `entry' is already defined
make[1]: *** [mm/memory.o] Error 1
make: *** [mm] Error 2
make: *** Waiting for unfinished jobs....
  CC      kernel/power/main.o
  CC      kernel/irq/chip.o
  CC      kernel/power/process.o
  CC      kernel/irq/devres.o
  CC      kernel/power/console.o
  CC      kernel/irq/autoprobe.o
  LD      kernel/power/built-in.o
  CC      kernel/irq/proc.o
  CC      kernel/time/timekeeping.o
  LD      kernel/irq/built-in.o
  CC      kernel/time/ntp.o
  CC      kernel/futex.o
  CC      kernel/time/clocksource.o
  CC      kernel/time/jiffies.o
  CC      kernel/time/timer_list.o
  LD      kernel/time/built-in.o
  CC      kernel/rtmutex.o
  CC      kernel/kallsyms.o
  CC      kernel/ksysfs.o
  CC      kernel/utsname_sysctl.o
  LD      kernel/built-in.o
06/01/07-08:11:46 Build the kernel. Failed rc = 2
06/01/07-08:11:46 apack-bench-build_configs: Building kernel... Failed rc = 1
Failed and terminated the run
06/01/07-08:11:46 command complete: (1) rc=126 (TEST ABORT)
 Fatal error, aborting autorun

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
