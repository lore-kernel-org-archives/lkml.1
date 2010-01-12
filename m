Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379Ab0ALDYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0ALDYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172Ab0ALDYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:24:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:43437 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0ALDYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:24:33 -0500
Date: Tue, 12 Jan 2010 04:24:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 00/26] Convert locks that can't sleep in -rt to
	raw_spinlock
Message-ID: <20100112032428.GE5243@nowhere>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 10:26:30PM +0100, John Kacur wrote:
> Thomas:
> 
> Now that your changes that free up the raw_spinlock name are upstream.
> (described below for other readers)
> 
> http://lwn.net/Articles/365863/
> http://lwn.net/Articles/366608/
> 
> I wanted to forward port the preempt-rt patches that convert locks to
> atomic_spinlocks (rt tree only) to the new scheme.
> 
> The patches below are a result of that effort.
> Please queue these up for 2.6.34 upstream, and please pull for preempt-rt
> 
> You can pull them from
> git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git
> jk/v2.6.33-rc3-raw-spinlocks
> 
> Thanks
> 
> John Kacur (25):
>   xtime_lock: Convert atomic_seqlock to raw_seqlock, fix up all users
>   x86: Convert tlbstate_lock to raw_spinlock
>   sched: Convert thread_group_cputimer lock to raw_spinlock
>   x86: Convert ioapic_lock and vector_lock to raw_spinlocks
>   x86: Convert i8259A_lock to raw_spinlock
>   x86: Convert pci_config_lock to raw_spinlock
>   i8253: Convert i8253_lock to raw_spinlock
>   x86: Convert set_atomicity_lock to raw_spinlock
>   ACPI: Convert c3_lock to raw_spinlock
>   rtmutex: Convert wait_lock and pi_lock to raw_spinlock
>   printk: Convert lock to raw_spinlock
>   genirq: Convert locks to raw_spinlocks
>   trace: Convert various locks to raw_spinlock
>   clocksource: Convert watchdog_lock to raw_spinlock
>   timer_stats: Convert to raw_spinlocks
>   x86: kvm: Convert i8254/i8259 locks to raw_spinlock
>   x86 - nmi: Convert nmi_lock to raw_spinlock
>   cgroups: Convert cgroups release_list_lock to raw_spinlock
>   proportions: Convert spinlocks to raw_spinlocks.
>   percpu_counter: Convert to raw_spinlock
>   oprofile: Convert to raw_spinlock
>   vgacon: Convert vga console lock to raw_spinlock
>   pci-access: Convert pci_lock to raw_spinlock
>   kprobes: Convert to raw_spinlocks
>   softlockup: Convert to raw_spinlocks
> 
> Thomas Gleixner (1):
>   seqlock: Create raw_seqlock
> 
>  arch/alpha/kernel/time.c            |    4 +-
>  arch/arm/kernel/time.c              |   12 ++--
>  arch/arm/oprofile/common.c          |    4 +-
>  arch/arm/oprofile/op_model_mpcore.c |    4 +-
>  arch/blackfin/kernel/time.c         |    4 +-
>  arch/cris/kernel/time.c             |    4 +-
>  arch/frv/kernel/time.c              |    4 +-
>  arch/h8300/kernel/time.c            |    4 +-
>  arch/ia64/kernel/time.c             |    4 +-
>  arch/ia64/xen/time.c                |    4 +-
>  arch/m32r/kernel/time.c             |    4 +-
>  arch/m68knommu/kernel/time.c        |    4 +-
>  arch/mips/include/asm/i8253.h       |    2 +-
>  arch/mips/kernel/i8253.c            |   14 ++--
>  arch/mn10300/kernel/time.c          |    4 +-
>  arch/parisc/kernel/time.c           |    8 +-
>  arch/powerpc/kernel/time.c          |    4 +-
>  arch/sparc/kernel/pcic.c            |    8 +-
>  arch/sparc/kernel/time_32.c         |   12 ++--
>  arch/x86/include/asm/i8253.h        |    2 +-
>  arch/x86/include/asm/i8259.h        |    2 +-
>  arch/x86/include/asm/pci_x86.h      |    2 +-
>  arch/x86/kernel/apic/io_apic.c      |  106 +++++++++++++++++-----------------
>  arch/x86/kernel/apic/nmi.c          |    6 +-
>  arch/x86/kernel/apm_32.c            |    4 +-
>  arch/x86/kernel/cpu/mtrr/generic.c  |    6 +-
>  arch/x86/kernel/i8253.c             |   14 ++--
>  arch/x86/kernel/i8259.c             |   30 +++++-----
>  arch/x86/kernel/time.c              |    4 +-
>  arch/x86/kernel/visws_quirks.c      |    6 +-
>  arch/x86/kvm/i8254.c                |   10 ++--
>  arch/x86/kvm/i8254.h                |    2 +-
>  arch/x86/kvm/i8259.c                |   30 +++++-----
>  arch/x86/kvm/irq.h                  |    2 +-
>  arch/x86/kvm/x86.c                  |    8 +-
>  arch/x86/mm/tlb.c                   |    8 +-
>  arch/x86/oprofile/nmi_int.c         |    4 +-
>  arch/x86/pci/common.c               |    2 +-
>  arch/x86/pci/direct.c               |   16 +++---
>  arch/x86/pci/mmconfig_32.c          |    8 +-
>  arch/x86/pci/numaq_32.c             |    8 +-
>  arch/x86/pci/pcbios.c               |    8 +-
>  arch/xtensa/kernel/time.c           |    4 +-
>  drivers/acpi/processor_idle.c       |   10 ++--
>  drivers/block/hd.c                  |    4 +-
>  drivers/input/gameport/gameport.c   |    4 +-
>  drivers/input/joystick/analog.c     |    4 +-
>  drivers/input/misc/pcspkr.c         |    6 +-
>  drivers/oprofile/event_buffer.c     |    4 +-
>  drivers/oprofile/oprofilefs.c       |    6 +-
>  drivers/pci/access.c                |   34 ++++++------
>  drivers/video/console/vgacon.c      |   42 +++++++-------
>  include/linux/init_task.h           |    2 +-
>  include/linux/kprobes.h             |    2 +-
>  include/linux/oprofile.h            |    2 +-
>  include/linux/percpu_counter.h      |    2 +-
>  include/linux/proportions.h         |    6 +-
>  include/linux/ratelimit.h           |    4 +-
>  include/linux/rtmutex.h             |    2 +-
>  include/linux/sched.h               |    4 +-
>  include/linux/seqlock.h             |   86 +++++++++++++++++++++++++++-
>  include/linux/time.h                |    2 +-
>  kernel/cgroup.c                     |   18 +++---
>  kernel/hrtimer.c                    |    8 +-
>  kernel/kprobes.c                    |   34 ++++++------
>  kernel/posix-cpu-timers.c           |    8 +-
>  kernel/printk.c                     |   42 +++++++-------
>  kernel/sched_stats.h                |   12 ++--
>  kernel/softlockup.c                 |    6 +-
>  kernel/time.c                       |    8 +-
>  kernel/time/clocksource.c           |   26 ++++----
>  kernel/time/ntp.c                   |    8 +-
>  kernel/time/tick-common.c           |    8 +-
>  kernel/time/tick-sched.c            |   12 ++--
>  kernel/time/timekeeping.c           |   50 ++++++++--------
>  kernel/time/timer_stats.c           |    6 +-
>  kernel/trace/ring_buffer.c          |   52 +++++++++---------
>  kernel/trace/trace.c                |   10 ++--
>  kernel/trace/trace_irqsoff.c        |    6 +-
>  lib/percpu_counter.c                |   18 +++---
>  lib/proportions.c                   |   12 ++--
>  lib/ratelimit.c                     |    4 +-
>  sound/drivers/pcsp/pcsp.h           |    2 +-
>  sound/drivers/pcsp/pcsp_input.c     |    4 +-
>  sound/drivers/pcsp/pcsp_lib.c       |   12 ++--
>  85 files changed, 535 insertions(+), 457 deletions(-)



Looking at this whole patchset. I have the feeling the
changelogs don't tell us much about why we do that.

I mean, I understand the general purpose of this patchset,
but taken invidually, some of them make me stuck into
existential questions.

Could you just at least put a one liner detailed and
individual clue in the changelogs that tells us why a
pointed spinlock can not sleep in preempt_rt? And may
be a comment in the code? There are places where it
is pretty obvious, such as the rq lock. But some
others...

Or may be I'm just too ignorant and these sleeping
in rt places are just simply damn too obvious to deserve
any individual words... :-)

Thanks.

