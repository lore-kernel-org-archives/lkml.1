Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbXGQFzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbXGQFzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 01:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXGQFzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 01:55:43 -0400
Received: from gw.goop.org ([64.81.55.164]:39534 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbXGQFzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 01:55:42 -0400
Message-ID: <469C59A7.4030907@goop.org>
Date: Mon, 16 Jul 2007 22:54:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: please pull ssh://master.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
 xen-upstream
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit a5fcaa210626a79465321e344c91a6a7dc3881fa:
  Linus Torvalds (1):
        Merge branch 'drm-patches' of ssh://master.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-upstream

Thanks,
	J

Jeremy Fitzhardinge (44):
      add kstrndup
      add argv_split()
      usermodehelper: split setup from execution
      Add common orderly_poweroff()
      usermodehelper: Tidy up waiting
      use elfnote.h to generate vsyscall notes.
      paravirt: add an "mm" argument to alloc_pt
      paravirt: add a hook for once the allocator is ready
      paravirt: increase IRQ limit
      paravirt: unstatic leave_mm
      paravirt: unstatic smp_store_cpu_info
      paravirt: make siblingmap functions visible
      paravirt: export __supported_pte_mask
      Allocate and free vmalloc areas
      paravirt: helper to disable all IO space
      Add a sched_clock paravirt_op
      Add nosegneg capability to the vsyscall page notes
      xen: Add Xen interface header files
      xen: Core Xen implementation
      xen: virtual mmu
      xen: event channels
      xen: time implementation
      xen: configuration
      xen: add pinned page flag
      xen: Complete pagetable pinning
      xen: ignore RW mapping of RO pages in pagetable_init
      xen: Account for stolen time
      xen: Implement sched_clock
      xen: SMP guest support
      xen: Add support for preemption
      xen: lazy-mmu operations
      xen: hack to prevent bad segment register reload
      xen: use the hvc console infrastructure for Xen console
      xen: Add grant table support
      xen: add the Xenbus sysfs and virtual device hotplug driver
      xen: add virtual block device driver.
      xen: add virtual network device driver
      xen: machine operations
      xen: handle external requests for shutdown, reboot and sysrq
      xen: Place vcpu_info structure into per-cpu memory
      xen: Attempt to patch inline versions of common operations
      xen: suppress abs symbol warnings for unused reloc pointers
      xen: use iret directly when possible
      xen: disable all non-virtual drivers

 arch/i386/Kconfig                                  |    2 +
 arch/i386/Makefile                                 |    3 +
 arch/i386/boot/compressed/relocs.c                 |    2 +
 arch/i386/kernel/asm-offsets.c                     |    9 +
 arch/i386/kernel/entry.S                           |   85 +
 arch/i386/kernel/head.S                            |    5 +-
 arch/i386/kernel/paravirt.c                        |   37 +-
 arch/i386/kernel/setup.c                           |    2 +
 arch/i386/kernel/smp.c                             |    5 +-
 arch/i386/kernel/smpboot.c                         |    8 +-
 arch/i386/kernel/tsc.c                             |   23 +-
 arch/i386/kernel/vmi.c                             |    4 +-
 arch/i386/kernel/vmiclock.c                        |    6 +-
 arch/i386/kernel/vmlinux.lds.S                     |    1 +
 arch/i386/kernel/vsyscall-note.S                   |   49 +-
 arch/i386/mach-voyager/voyager_thread.c            |    2 +-
 arch/i386/mm/init.c                                |    3 +-
 arch/i386/mm/pageattr.c                            |    2 +-
 arch/i386/xen/Kconfig                              |   11 +
 arch/i386/xen/Makefile                             |    4 +
 arch/i386/xen/enlighten.c                          | 1144 ++++++++++++
 arch/i386/xen/events.c                             |  590 +++++++
 arch/i386/xen/features.c                           |   29 +
 arch/i386/xen/manage.c                             |  143 ++
 arch/i386/xen/mmu.c                                |  564 ++++++
 arch/i386/xen/mmu.h                                |   60 +
 arch/i386/xen/multicalls.c                         |   90 +
 arch/i386/xen/multicalls.h                         |   45 +
 arch/i386/xen/setup.c                              |   96 +
 arch/i386/xen/smp.c                                |  404 +++++
 arch/i386/xen/time.c                               |  590 +++++++
 arch/i386/xen/xen-asm.S                            |  291 +++
 arch/i386/xen/xen-head.S                           |   36 +
 arch/i386/xen/xen-ops.h                            |   71 +
 arch/x86_64/kernel/early_printk.c                  |    5 +
 arch/x86_64/kernel/mce.c                           |    2 +-
 drivers/Makefile                                   |    2 +
 drivers/acpi/thermal.c                             |   24 +-
 drivers/block/Kconfig                              |    9 +
 drivers/block/Makefile                             |    1 +
 drivers/block/xen-blkfront.c                       |  988 +++++++++++
 drivers/char/Kconfig                               |    8 +
 drivers/char/Makefile                              |    1 +
 drivers/char/hvc_xen.c                             |  159 ++
 drivers/macintosh/therm_pm72.c                     |    3 +-
 drivers/macintosh/windfarm_core.c                  |    3 +-
 drivers/net/Kconfig                                |   12 +
 drivers/net/Makefile                               |    2 +
 drivers/net/hamradio/baycom_epp.c                  |    2 +-
 drivers/net/xen-netfront.c                         | 1863 ++++++++++++++++++++
 drivers/pnp/pnpbios/core.c                         |    2 +-
 drivers/sbus/char/bbc_envctrl.c                    |    5 +-
 drivers/sbus/char/envctrl.c                        |    7 +-
 drivers/xen/Makefile                               |    2 +
 drivers/xen/grant-table.c                          |  582 ++++++
 drivers/xen/xenbus/Makefile                        |    7 +
 drivers/xen/xenbus/xenbus_client.c                 |  569 ++++++
 drivers/xen/xenbus/xenbus_comms.c                  |  233 +++
 drivers/xen/xenbus/xenbus_comms.h                  |   46 +
 drivers/xen/xenbus/xenbus_probe.c                  |  935 ++++++++++
 drivers/xen/xenbus/xenbus_probe.h                  |   74 +
 drivers/xen/xenbus/xenbus_xs.c                     |  861 +++++++++
 fs/ocfs2/heartbeat.c                               |    2 +-
 include/asm-i386/irq.h                             |    1 +
 include/asm-i386/mach-default/irq_vectors_limits.h |    2 +-
 include/asm-i386/mmu_context.h                     |    2 +
 include/asm-i386/paravirt.h                        |   22 +-
 include/asm-i386/pgalloc.h                         |    6 +-
 include/asm-i386/setup.h                           |    4 +
 include/asm-i386/smp.h                             |    5 +
 include/asm-i386/timer.h                           |   32 +-
 include/asm-i386/vmi_time.h                        |    2 +-
 include/asm-i386/xen/hypercall.h                   |  413 +++++
 include/asm-i386/xen/hypervisor.h                  |   73 +
 include/asm-i386/xen/interface.h                   |  188 ++
 include/linux/elfnote.h                            |   22 +-
 include/linux/kmod.h                               |   52 +-
 include/linux/major.h                              |    2 +
 include/linux/page-flags.h                         |    5 +
 include/linux/reboot.h                             |    5 +
 include/linux/string.h                             |    4 +
 include/linux/vmalloc.h                            |    4 +
 include/xen/events.h                               |   48 +
 include/xen/features.h                             |   23 +
 include/xen/grant_table.h                          |  107 ++
 include/xen/hvc-console.h                          |    6 +
 include/xen/interface/elfnote.h                    |  133 ++
 include/xen/interface/event_channel.h              |  195 ++
 include/xen/interface/features.h                   |   43 +
 include/xen/interface/grant_table.h                |  375 ++++
 include/xen/interface/io/blkif.h                   |   94 +
 include/xen/interface/io/console.h                 |   23 +
 include/xen/interface/io/netif.h                   |  158 ++
 include/xen/interface/io/ring.h                    |  260 +++
 include/xen/interface/io/xenbus.h                  |   44 +
 include/xen/interface/io/xs_wire.h                 |   87 +
 include/xen/interface/memory.h                     |  145 ++
 include/xen/interface/physdev.h                    |  145 ++
 include/xen/interface/sched.h                      |   77 +
 include/xen/interface/vcpu.h                       |  167 ++
 include/xen/interface/version.h                    |   60 +
 include/xen/interface/xen.h                        |  447 +++++
 include/xen/page.h                                 |  179 ++
 include/xen/xenbus.h                               |  234 +++
 kernel/cpuset.c                                    |    2 +-
 kernel/kmod.c                                      |  216 ++-
 kernel/sys.c                                       |   58 +
 kernel/sysctl.c                                    |   10 +
 lib/Makefile                                       |    2 +-
 lib/argv_split.c                                   |  106 ++
 lib/kobject_uevent.c                               |    2 +-
 mm/util.c                                          |   28 +-
 mm/vmalloc.c                                       |   53 +
 net/bridge/br_stp_if.c                             |    2 +-
 net/irda/irias_object.c                            |   43 +-
 security/keys/request_key.c                        |    3 +-
 116 files changed, 15033 insertions(+), 211 deletions(-)
 create mode 100644 arch/i386/xen/Kconfig
 create mode 100644 arch/i386/xen/Makefile
 create mode 100644 arch/i386/xen/enlighten.c
 create mode 100644 arch/i386/xen/events.c
 create mode 100644 arch/i386/xen/features.c
 create mode 100644 arch/i386/xen/manage.c
 create mode 100644 arch/i386/xen/mmu.c
 create mode 100644 arch/i386/xen/mmu.h
 create mode 100644 arch/i386/xen/multicalls.c
 create mode 100644 arch/i386/xen/multicalls.h
 create mode 100644 arch/i386/xen/setup.c
 create mode 100644 arch/i386/xen/smp.c
 create mode 100644 arch/i386/xen/time.c
 create mode 100644 arch/i386/xen/xen-asm.S
 create mode 100644 arch/i386/xen/xen-head.S
 create mode 100644 arch/i386/xen/xen-ops.h
 create mode 100644 drivers/block/xen-blkfront.c
 create mode 100644 drivers/char/hvc_xen.c
 create mode 100644 drivers/net/xen-netfront.c
 create mode 100644 drivers/xen/Makefile
 create mode 100644 drivers/xen/grant-table.c
 create mode 100644 drivers/xen/xenbus/Makefile
 create mode 100644 drivers/xen/xenbus/xenbus_client.c
 create mode 100644 drivers/xen/xenbus/xenbus_comms.c
 create mode 100644 drivers/xen/xenbus/xenbus_comms.h
 create mode 100644 drivers/xen/xenbus/xenbus_probe.c
 create mode 100644 drivers/xen/xenbus/xenbus_probe.h
 create mode 100644 drivers/xen/xenbus/xenbus_xs.c
 create mode 100644 include/asm-i386/xen/hypercall.h
 create mode 100644 include/asm-i386/xen/hypervisor.h
 create mode 100644 include/asm-i386/xen/interface.h
 create mode 100644 include/xen/events.h
 create mode 100644 include/xen/features.h
 create mode 100644 include/xen/grant_table.h
 create mode 100644 include/xen/hvc-console.h
 create mode 100644 include/xen/interface/elfnote.h
 create mode 100644 include/xen/interface/event_channel.h
 create mode 100644 include/xen/interface/features.h
 create mode 100644 include/xen/interface/grant_table.h
 create mode 100644 include/xen/interface/io/blkif.h
 create mode 100644 include/xen/interface/io/console.h
 create mode 100644 include/xen/interface/io/netif.h
 create mode 100644 include/xen/interface/io/ring.h
 create mode 100644 include/xen/interface/io/xenbus.h
 create mode 100644 include/xen/interface/io/xs_wire.h
 create mode 100644 include/xen/interface/memory.h
 create mode 100644 include/xen/interface/physdev.h
 create mode 100644 include/xen/interface/sched.h
 create mode 100644 include/xen/interface/vcpu.h
 create mode 100644 include/xen/interface/version.h
 create mode 100644 include/xen/interface/xen.h
 create mode 100644 include/xen/page.h
 create mode 100644 include/xen/xenbus.h
 create mode 100644 lib/argv_split.c

