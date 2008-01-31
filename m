Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYAaP5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYAaP5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYAaP5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:57:06 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46904 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYAaP5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:57:03 -0500
Date: Thu, 31 Jan 2008 17:57:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080131155739.GA19700@cs181133002.pp.htv.fi>
References: <20080130011550.GA31853@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080130011550.GA31853@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 02:15:50AM +0100, Ingo Molnar wrote:
> 
> Linus, please pull the latest x86 git tree from:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> Find the shortlog attached below.
> 
> Most of the changes we have described here:
> 
>     http://lkml.org/lkml/2008/1/21/230
> 
> It's not a small merge, it consists of 908 commits from 96 individual 
> arch/x86 developers (!):
> 
>     671 files changed, 42791 insertions(+), 38967 deletions(-)
> 
> so here are a few highlevel comments as well, in addition to the 
> shortlog:
>...
> the x86.git queue has been built and booted on 32-bit and 64-bit x86, 
> allnoconfig and allyesconfig [the new CONFIG_SIS190 gigabit driver in 
> -git has been disabled because it has build failures], including a real 
> legacy i386 DX 33 MHz system which successfully booted x86.git today.
> 
> In the past few weeks tens of thousands of random x86.git bzImages were 
> successfully built and booted on a number of (commodity) 32-bit and 
> 64-bit testsystems - and there has been a fair amount of test exposure 
> on -mm as well. We expect the x86.git changes to be pretty robust - if 
> any problems there are they should be under more specialized conditions. 
> (or due to very recent changes that we kept at the tail of the commit 
> list) Famous last words? :)
>...

You tested x86 but broke more than half a dozen other archtectures, 
with at least 3 different commits breaking other architectures.

It now takes a few days until this mess is completely sorted out, and I 
hope there won't be too many poor souls having to bisect 2.6.25-rc1 
regresions on !x86 since this can now become the pure horror.

And if people give up trying to bisect 2.6.25 might ship with more 
regressions.

I already said in the past that the x86 tree contains not architecture 
specific stuff that doesn't belong there, and looking at the following 
parts of the diffstat, most of it does simply not belong into an
"x86 arch update":

>  b/Makefile                                    |    8 
>  b/arch/arm/Kconfig                            |    5 
>  b/arch/ia64/Kconfig                           |    8 
>  b/arch/ia64/ia32/binfmt_elf32.c               |    3 
>  b/arch/ia64/kernel/module.c                   |    2 
>  b/arch/m32r/Kconfig                           |    5 
>  b/arch/mips/Kconfig                           |    5 
>  b/arch/mips/kernel/i8253.c                    |   12 
>  b/arch/parisc/Kconfig                         |    5 
>  b/arch/powerpc/Kconfig                        |    8 
>  b/arch/powerpc/kernel/ptrace.c                |   52 
>  b/arch/sparc64/Kconfig                        |    8 
>  b/arch/um/kernel/ksyms.c                      |    4 
>  b/arch/um/sys-i386/signal.c                   |   50 
>  b/arch/um/sys-x86_64/signal.c                 |   70 
>...
>  b/drivers/Makefile                            |    2 
>  b/drivers/acpi/processor_idle.c               |   34 
>  b/drivers/char/agp/ali-agp.c                  |    2 
>  b/drivers/char/agp/backend.c                  |    3 
>  b/drivers/char/agp/generic.c                  |    3 
>  b/drivers/char/agp/i460-agp.c                 |    2 
>  b/drivers/char/agp/intel-agp.c                |   11 
>  b/drivers/char/hpet.c                         |  126 -
>  b/drivers/char/keyboard.c                     |    1 
>  b/drivers/char/rtc.c                          |  253 +-
>  b/drivers/cpufreq/cpufreq.c                   |    2 
>  b/drivers/firmware/dmi_scan.c                 |   26 
>  b/drivers/ieee1394/Makefile                   |    1 
>  b/drivers/ieee1394/init_ohci1394_dma.c        |  285 ++
>  b/drivers/input/mouse/pc110pad.c              |    7 
>  b/drivers/kvm/svm.c                           |    2 
>  b/drivers/kvm/vmx.c                           |    8 
>  b/drivers/lguest/x86/core.c                   |    4 
>  b/drivers/pnp/pnpbios/bioscalls.c             |    5 
>  b/drivers/serial/8250.c                       |   52 
>  b/drivers/serial/8250_kgdb.c                  |  558 +++++
>  b/drivers/serial/Kconfig                      |    2 
>  b/drivers/serial/Makefile                     |    1 
>  b/drivers/serial/serial_core.c                |   24 
>  b/drivers/video/vermilion/vermilion.c         |   15 
>  b/fs/Kconfig.binfmt                           |    4 
>  b/fs/Makefile                                 |    1 
>  b/fs/aio.c                                    |    2 
>  b/fs/binfmt_elf.c                             |  677 ++++--
>  b/fs/compat_binfmt_elf.c                      |  131 +
>  b/fs/jbd/checkpoint.c                         |    3 
>  b/fs/jbd/commit.c                             |    2 
>  b/fs/jbd2/checkpoint.c                        |    3 
>  b/fs/jbd2/commit.c                            |    2 
>  b/include/acpi/reboot.h                       |    9 
>  b/include/asm-alpha/agp.h                     |    1 
>  b/include/asm-generic/bug.h                   |   17 
>  b/include/asm-generic/kgdb.h                  |  105 
>  b/include/asm-generic/percpu.h                |   97 
>  b/include/asm-generic/tlb.h                   |    1 
>  b/include/asm-generic/vmlinux.lds.h           |    1 
>  b/include/asm-ia64/acpi.h                     |    2 
>  b/include/asm-ia64/agp.h                      |    1 
>  b/include/asm-ia64/percpu.h                   |   24 
>  b/include/asm-m32r/signal.h                   |    2 
>  b/include/asm-parisc/agp.h                    |    1 
>  b/include/asm-powerpc/agp.h                   |    1 
>  b/include/asm-powerpc/percpu.h                |   17 
>  b/include/asm-powerpc/ptrace.h                |    7 
>  b/include/asm-s390/percpu.h                   |   20 
>  b/include/asm-sparc64/agp.h                   |    1 
>  b/include/asm-sparc64/percpu.h                |   16 
>  b/include/asm-um/asm.h                        |    6 
>  b/include/asm-um/linkage.h                    |    1 
>  b/include/asm-um/nops.h                       |    6 
>...
>  b/include/linux/acpi_pmtmr.h                  |    2 
>  b/include/linux/clocksource.h                 |    4 
>  b/include/linux/compat.h                      |   15 
>  b/include/linux/const.h                       |    5 
>  b/include/linux/cpumask.h                     |    4 
>  b/include/linux/elf.h                         |    1 
>  b/include/linux/hpet.h                        |    5 
>  b/include/linux/init_ohci1394_dma.h           |    4 
>  b/include/linux/ioport.h                      |    2 
>  b/include/linux/kernel.h                      |    3 
>  b/include/linux/kgdb.h                        |  301 ++
>  b/include/linux/kprobes.h                     |   10 
>  b/include/linux/linkage.h                     |    8 
>  b/include/linux/mm.h                          |   15 
>  b/include/linux/module.h                      |   16 
>  b/include/linux/pci_ids.h                     |    7 
>  b/include/linux/percpu.h                      |   24 
>  b/include/linux/pid.h                         |    2 
>  b/include/linux/ptrace.h                      |   75 
>  b/include/linux/regset.h                      |  368 +++
>  b/include/linux/sched.h                       |   21 
>  b/include/linux/serial_8250.h                 |    2 
>  b/include/linux/smp.h                         |    2 
>  b/include/linux/spinlock.h                    |    6 
>  b/include/linux/spinlock_types.h              |    4 
>  b/include/linux/spinlock_up.h                 |    2 
>  b/include/linux/suspend.h                     |    3 
>  b/include/linux/swap.h                        |    1 
>  b/include/linux/thread_info.h                 |   10 
>  b/include/linux/tick.h                        |    6 
>  b/include/linux/timer.h                       |    6 
>  b/include/linux/uaccess.h                     |   30 
>...
>  b/init/main.c                                 |   25 
>  b/kernel/Makefile                             |    3 
>  b/kernel/backtracetest.c                      |   48 
>  b/kernel/irq/manage.c                         |    3 
>  b/kernel/irq/proc.c                           |   21 
>  b/kernel/irq/spurious.c                       |    5 
>  b/kernel/kgdb.c                               | 2306 ++++++++++++++++++++
>  b/kernel/kprobes.c                            |    2 
>  b/kernel/module.c                             |   66 
>  b/kernel/panic.c                              |   29 
>  b/kernel/printk.c                             |    7 
>  b/kernel/ptrace.c                             |  165 +
>  b/kernel/sched.c                              |   20 
>  b/kernel/signal.c                             |    4 
>  b/kernel/softirq.c                            |   11 
>  b/kernel/softlockup.c                         |   11 
>  b/kernel/spinlock.c                           |    3 
>  b/kernel/sysctl.c                             |   11 
>  b/kernel/test_kprobes.c                       |  216 +
>  b/kernel/time/clockevents.c                   |   13 
>  b/kernel/time/clocksource.c                   |   43 
>  b/kernel/time/tick-broadcast.c                |    7 
>  b/kernel/time/tick-internal.h                 |    2 
>  b/kernel/time/tick-sched.c                    |   76 
>  b/kernel/time/timekeeping.c                   |   28 
>  b/kernel/time/timer_stats.c                   |    2 
>  b/kernel/timer.c                              |   82 
>  b/lib/Kconfig.debug                           |   54 
>  b/lib/Kconfig.kgdb                            |   88 
>  b/lib/rwsem.c                                 |    8 
>  b/mm/memory.c                                 |   39 
>  b/mm/mmap.c                                   |    3 
>  b/net/sunrpc/svc.c                            |    1 
>  b/sound/pci/intel8x0.c                        |    8 
>...
