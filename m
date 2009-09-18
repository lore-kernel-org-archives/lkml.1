Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZIRT0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZIRT0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbZIRT0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:26:16 -0400
Received: from www.tglx.de ([62.245.132.106]:43054 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369AbZIRT0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:26:16 -0400
Date: Fri, 18 Sep 2009 21:25:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
Subject: [GIT pull] x86 platform support for 2.6.32
Message-ID: <alpine.LFD.2.00.0909182106170.2889@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-platform-for-linus

x86 platform support was started to provide a clean base for the
upcoming Moorestown support.

It converts the existing maze of x86 quirks and paravirt magic into a
straight forward set of platform function pointers which have a
default implementation and can be overridden by the platform init
code. Paravirt becomes a platform as well which makes the boot code
easier to read and more grep friendly.

Thanks,

	tglx

------------------>
Feng Tang (1):
      x86: Move get/set_wallclock to x86_platform_ops

Pan, Jacob jun (1):
      x86: Add hardware_subarch ID for Moorestown

Thomas Gleixner (36):
      x86: Add x86_init infrastructure
      x86: Add probe_roms to x86_init
      x86: Add request_standard_resources to x86_init
      x86: Add reserve_ebda_region to x86_init_ops
      x86: Move memory_setup to x86_init_ops
      x86: Sanitize smp_record and move it to x86_init_ops
      x86: Move ioapic_ids_setup to x86_init_ops
      x86: Move mpc_apic_id to x86_init_ops
      x86: Move smp_read_mpc_oem to x86_init_ops.
      x86: Move mpc_oem_pci_bus to x86_init_ops
      x86: Move oem_bus_info to x86_init_ops
      x86: Move get/find_smp_config to x86_init_ops
      x86: Move pre_intr_init to x86_init_ops
      x86: Move irq_init to x86_init_ops
      x86: Move traps_init to x86_init_ops
      x86: Replace ARCH_SETUP by a proper x86_init_ops
      x86: Move paravirt banner printout to x86_init_ops
      x86: Move paravirt pagetable_setup to x86_init_ops
      x86: Move xen_post_allocator_init into xen_pagetable_setup_done
      x86: Move percpu clockevents setup to x86_init_ops
      x86: Add timer_init to x86_init_ops
      x86: Remove do_timer hook
      x86: Prepare unification of time_32/64.c
      x86: Simplify timer_ack magic in time_32.c
      x86: Remove mca bus ifdef from timer interrupt
      x86: Make timer setup and global variables the same in time_32/64.c
      x86: Move calibrate_cpu to tsc.c
      x86: time_32/64.c unify profile_pc
      x86: Replace the now identical time_32/64.c by time.c
      x86: Move tsc_calibration to x86_init_ops
      x86: Move tsc_init to late_time_init
      x86: Add early platform detection
      x86: Add Moorestown early detection
      x86: Distangle ioapic and i8259
      x86: apic namespace cleanup
      x86: platform: Fix section annotations


 Documentation/x86/boot.txt            |    1 +
 arch/x86/Kconfig                      |   13 +++
 arch/x86/include/asm/apic.h           |   19 ++---
 arch/x86/include/asm/bootparam.h      |   10 +++
 arch/x86/include/asm/do_timer.h       |   16 ----
 arch/x86/include/asm/e820.h           |    2 -
 arch/x86/include/asm/hypervisor.h     |    2 +-
 arch/x86/include/asm/io_apic.h        |    6 +-
 arch/x86/include/asm/irq.h            |    3 +-
 arch/x86/include/asm/mpspec.h         |   47 ++++++++++--
 arch/x86/include/asm/paravirt.h       |   51 +-----------
 arch/x86/include/asm/paravirt_types.h |   28 -------
 arch/x86/include/asm/pgtable.h        |   10 ---
 arch/x86/include/asm/pgtable_types.h  |    4 +-
 arch/x86/include/asm/setup.h          |   49 ++----------
 arch/x86/include/asm/time.h           |   53 -------------
 arch/x86/include/asm/timer.h          |   14 +--
 arch/x86/include/asm/tsc.h            |    3 +-
 arch/x86/include/asm/vmware.h         |    2 +-
 arch/x86/include/asm/x86_init.h       |  133 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile              |    5 +-
 arch/x86/kernel/apic/apic.c           |    3 +-
 arch/x86/kernel/apic/bigsmp_32.c      |    2 +-
 arch/x86/kernel/apic/io_apic.c        |   52 ++++++++-----
 arch/x86/kernel/apic/numaq_32.c       |   57 ++++++--------
 arch/x86/kernel/apic/summit_32.c      |    2 +-
 arch/x86/kernel/cpu/hypervisor.c      |   14 ++--
 arch/x86/kernel/cpu/vmware.c          |   21 +++--
 arch/x86/kernel/e820.c                |   19 +-----
 arch/x86/kernel/efi.c                 |    4 +
 arch/x86/kernel/head32.c              |   26 ++++++-
 arch/x86/kernel/head64.c              |    2 +-
 arch/x86/kernel/head_32.S             |    1 +
 arch/x86/kernel/irqinit.c             |   36 ++-------
 arch/x86/kernel/kvmclock.c            |   11 ++-
 arch/x86/kernel/mpparse.c             |   75 ++++++------------
 arch/x86/kernel/mrst.c                |   24 ++++++
 arch/x86/kernel/paravirt.c            |   36 +---------
 arch/x86/kernel/rtc.c                 |   12 +--
 arch/x86/kernel/setup.c               |  115 +++++-----------------------
 arch/x86/kernel/smpboot.c             |    4 +-
 arch/x86/kernel/time.c                |  121 +++++++++++++++++++++++++++++
 arch/x86/kernel/time_32.c             |  137 ---------------------------------
 arch/x86/kernel/time_64.c             |  135 --------------------------------
 arch/x86/kernel/traps.c               |    5 +-
 arch/x86/kernel/tsc.c                 |   72 +++++++++++++++---
 arch/x86/kernel/visws_quirks.c        |   54 ++++---------
 arch/x86/kernel/vmi_32.c              |   12 ++--
 arch/x86/kernel/vmiclock_32.c         |    2 +-
 arch/x86/kernel/x86_init.c            |   75 ++++++++++++++++++
 arch/x86/lguest/boot.c                |   11 +--
 arch/x86/xen/enlighten.c              |   26 +++---
 arch/x86/xen/irq.c                    |    5 +-
 arch/x86/xen/mmu.c                    |   16 +++-
 arch/x86/xen/mmu.h                    |    2 +-
 arch/x86/xen/xen-ops.h                |    2 -
 56 files changed, 754 insertions(+), 908 deletions(-)
 delete mode 100644 arch/x86/include/asm/do_timer.h
 create mode 100644 arch/x86/include/asm/x86_init.h
 create mode 100644 arch/x86/kernel/mrst.c
 create mode 100644 arch/x86/kernel/time.c
 delete mode 100644 arch/x86/kernel/time_32.c
 delete mode 100644 arch/x86/kernel/time_64.c
 create mode 100644 arch/x86/kernel/x86_init.c

