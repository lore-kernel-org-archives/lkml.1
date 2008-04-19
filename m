Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYDSEvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYDSEvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 00:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYDSEvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 00:51:03 -0400
Received: from sous-sol.org ([216.99.217.87]:34522 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYDSEu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 00:50:59 -0400
Date: Fri, 18 Apr 2008 21:49:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.24.5
Message-ID: <20080419044952.GA11207@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.24.5 kernel.

It fixes a large number of different bugs and all users of the 2.6.24 series
are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.24.4 and 2.6.24.5

The updated 2.6.24.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary

thanks,
-chris

--------

 Makefile                                  |    4 -
 arch/parisc/kernel/firmware.c             |   27 +++++++----
 arch/parisc/kernel/pdc_cons.c             |   19 +++++++-
 arch/parisc/kernel/signal.c               |    3 -
 arch/sparc64/kernel/ptrace.c              |    4 +
 arch/sparc64/kernel/signal.c              |    2 
 arch/sparc64/mm/tlb.c                     |    3 -
 arch/x86/kernel/machine_kexec_64.c        |    1 
 arch/x86/xen/enlighten.c                  |   42 ++++++++++--------
 arch/x86/xen/xen-asm.S                    |    9 +++
 crypto/xcbc.c                             |   17 +++----
 drivers/acpi/bus.c                        |    7 +--
 drivers/acpi/processor_core.c             |    2 
 drivers/ata/libata-core.c                 |   38 ++++++++++------
 drivers/firmware/dmi_scan.c               |    2 
 drivers/hwmon/w83781d.c                   |   21 ++++++---
 drivers/macintosh/via-pmu.c               |    2 
 drivers/md/md.c                           |   12 -----
 drivers/md/raid5.c                        |   51 ++++++++++++----------
 drivers/media/dvb/dvb-usb/ttusb2.c        |    1 
 drivers/media/dvb/frontends/tda10086.c    |   28 +++++++++---
 drivers/media/dvb/frontends/tda10086.h    |    3 +
 drivers/media/dvb/ttpci/budget.c          |    1 
 drivers/media/video/ivtv/ivtv-driver.c    |    3 +
 drivers/media/video/saa7134/saa7134-dvb.c |    1 
 drivers/mtd/chips/cfi_cmdset_0001.c       |   10 ++--
 drivers/mtd/devices/block2mtd.c           |    1 
 drivers/net/macb.c                        |    2 
 drivers/net/plip.c                        |    7 +--
 drivers/net/pppol2tp.c                    |   69 ++++++++++++++++--------------
 drivers/net/sis190.c                      |   15 ++++--
 drivers/net/sungem.c                      |    2 
 drivers/pci/quirks.c                      |   11 ++--
 drivers/pnp/pnpacpi/rsparser.c            |    8 +--
 drivers/uio/uio.c                         |    2 
 drivers/usb/core/message.c                |    5 +-
 drivers/usb/core/quirks.c                 |    3 +
 drivers/usb/serial/keyspan.h              |    4 +
 drivers/usb/serial/ti_usb_3410_5052.c     |    4 -
 drivers/usb/serial/visor.c                |    2 
 drivers/usb/storage/transport.c           |    3 -
 drivers/usb/storage/unusual_devs.h        |   11 ++++
 drivers/video/fbmem.c                     |    1 
 fs/buffer.c                               |   13 ++---
 fs/dcache.c                               |    3 -
 fs/hfsplus/dir.c                          |   23 ++++++----
 fs/inotify.c                              |   30 ++++++-------
 fs/locks.c                                |   48 ++++++++++++--------
 fs/signalfd.c                             |    7 ++-
 include/asm-parisc/futex.h                |   10 +++-
 include/asm-parisc/pdc.h                  |    3 -
 include/asm-sparc64/backoff.h             |    3 -
 include/linux/ethtool.h                   |    1 
 include/linux/percpu.h                    |    2 
 include/linux/sched.h                     |    6 ++
 include/linux/security.h                  |    3 -
 include/linux/time.h                      |    4 +
 include/linux/usb/quirks.h                |    3 +
 include/linux/usb_usual.h                 |    4 +
 kernel/sched.c                            |   43 ++++++++++++++++++
 kernel/timer.c                            |   10 +++-
 mm/allocpercpu.c                          |   15 ++++++
 mm/slab.c                                 |    4 -
 net/8021q/vlan.c                          |    2 
 net/ax25/ax25_out.c                       |   13 ++++-
 net/bluetooth/hci_core.c                  |    4 -
 net/core/dev.c                            |    4 -
 net/core/netpoll.c                        |    6 +-
 net/ipv4/tcp.c                            |    4 -
 net/ipv4/tcp_output.c                     |    2 
 net/ipv6/netfilter/nf_conntrack_reasm.c   |    2 
 net/llc/af_llc.c                          |    3 +
 net/sched/sch_generic.c                   |   18 ++++++-
 net/sched/sch_htb.c                       |   13 +++--
 net/sctp/bind_addr.c                      |    4 +
 net/sctp/ipv6.c                           |    4 +
 net/sctp/protocol.c                       |    4 +
 scripts/Makefile.modpost                  |    6 ++
 scripts/mod/file2alias.c                  |    4 +
 scripts/mod/modpost.c                     |    5 +-
 scripts/mod/modpost.h                     |    1 
 security/capability.c                     |    1 
 security/commoncap.c                      |   39 ----------------
 83 files changed, 533 insertions(+), 304 deletions(-)

Summary of changes from v2.6.24.4 to v2.6.24.5
==============================================

Alan Stern (1):
      USB: new quirk flag to avoid Set-Interface

Alexey Dobriyan (1):
      fbdev: fix /proc/fb oops after module removal

Alexey Korolev (1):
      mtd: fix broken state in CFI driver caused by FL_SHUTDOWN

Alok Kataria (1):
      acpi: fix "buggy BIOS check" when CPUs are hot removed

Atsushi Nemoto (1):
      macb: Call phy_disconnect on removing

Brad Sawatzky (1):
      USB: serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24

Carol Hebert (1):
      ipmi: change device node ordering to reflect probe order

Chidambar 'ilLogict' Zinnoury (1):
      SCTP: Fix local_addr deletions during list traversals.

Chris Wright (1):
      Linux 2.6.24.5

Chuck Ebbert (1):
      acpi: bus: check once more for an empty list after locking it

Clark Rawlins (1):
      USB: Allow initialization of broken keyspan serial adapters.

Constantin Baranov (1):
      USB: add support for Motorola ROKR Z6 cellphone in mass storage mode

Dan Williams (1):
      md: close a livelock window in handle_parity_checks5

Daniel Yeisley (1):
      slab: fix cache_cache bootstrap in kmem_cache_init()

Dave Young (1):
      bluetooth: hci_core: defer hci_unregister_sysfs()

David S. Miller (6):
      SUNGEM: Fix NAPI assertion failure.
      INET: inet_frag_evictor() must run with BH disabled
      SPARC64: Fix atomic backoff limit.
      SPARC64: Fix __get_cpu_var in preemption-enabled area.
      SPARC64: flush_ptrace_access() needs preemption disable.
      SPARC64: Fix FPU saving in 64-bit signal handling.

Davide Libenzi (1):
      signalfd: fix for incorrect SI_QUEUE user data reporting

Dmitri Monakhov (1):
      vfs: fix data leak in nobh_write_end()

Eric Dumazet (2):
      PERCPU : __percpu_alloc_mask() can dynamically size percpu_data storage
      alloc_percpu() fails to allocate percpu data

Francois Romieu (1):
      sis190: read the mac address from the eeprom first

Guido Guenther (1):
      POWERPC: Fix build of modular drivers/macintosh/apm_emu.c

Hartmut Hackmann (1):
      DVB: tda10086: make the 22kHz tone for DISEQC a config option

Herbert Xu (2):
      NET: Add preemption point in qdisc_run
      TCP: Let skbs grow over a page on fast peers

Ian Armstrong (1):
      V4L: ivtv: Add missing sg_init_table()

Ingo van Lil (1):
      mtd: memory corruption in block2mtd.c

J. Bruce Fields (1):
      locks: fix possible infinite loop in fcntl(F_SETLKW) over nfs

James Chapman (2):
      PPPOL2TP: Make locking calls softirq-safe
      PPPOL2TP: Fix SMP issues in skb reorder queue handling

Jarek Poplawski (2):
      AX25 ax25_out: check skb for NULL in ax25_kick()
      netpoll: zap_completion_queue: adjust skb->users counter

Jean Delvare (2):
      pci: revert SMBus unhide on HP Compaq nx6110
      hwmon: (w83781d) Fix I/O resource conflict with PNP

Jean-Samuel Chenard (1):
      UIO: add pgprot_noncached() to UIO mmap code

Jeremy Fitzhardinge (3):
      xen: fix RMW when unmasking events
      xen: mask out SEP from CPUID
      xen: fix UP setup of shared_info

Joy Latten (1):
      CRYPTO xcbc: Fix crash when ipsec uses xcbc-mac with big data chunk

Ken'ichi Ohmichi (1):
      vmcoreinfo: add the symbol "phys_base"

Kirill A. Shutemov (1):
      NET: include <linux/types.h> into linux/ethtool.h for __u* typedef

Kyle McMartin (3):
      PARISC futex: special case cmpxchg NULL in kernel space
      PARISC pdc_console: fix bizarre panic on boot
      PARISC fix signal trampoline cache flushing

Len Brown (1):
      pnpacpi: reduce printk severity for "pnpacpi: exceeded the max number of ..."

Martin Devera (1):
      sch_htb: fix "too many events" situation

Mikulas Patocka (1):
      plip: replace spin_lock_irq with spin_lock_irqsave in irq context

NeilBrown (1):
      md: remove the 'super' sysfs attribute from devices in an 'md' array

Nick Piggin (2):
      inotify: fix race
      inotify: remove debug code

Patrick McHardy (4):
      LLC: Restrict LLC sockets to root
      NET: Fix multicast device ioctl checks
      TCP: Fix shrinking windows with window scaling
      VLAN: Don't copy ALLMULTI/PROMISC flags from underlying device

Robert Spanton (1):
      USB: serial: ti_usb_3410_5052: Correct TUSB3410 endpoint requirements.

Roman Zippel (1):
      HFS+: fix unlink of links

Sam Ravnborg (1):
      kbuild: soften modpost checks when doing cross builds

Segher Boessenkool (1):
      time: prevent the loop in timespec_add_ns() from being optimised away

Serge Hallyn (1):
      file capabilities: remove cap_task_kill()

Tejun Heo (1):
      libata: assume no device is attached if both IDENTIFYs are aborted

Thomas Gleixner (1):
      NOHZ: reevaluate idle sleep length after add_timer_on()
