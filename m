Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbYFITuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbYFITuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYFITub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:50:31 -0400
Received: from sous-sol.org ([216.99.217.87]:46659 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbYFITua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:50:30 -0400
Date: Mon, 9 Jun 2008 12:49:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.6
Message-ID: <20080609194924.GL30402@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.6 kernel.

It contains a number of assorted bugfixes all over the tree.  Users are
encouraged to update.

I'll also be replying to this message with a copy of the patch between
2.6.25.5 and 2.6.25.6

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,
-chris
--------

 Makefile                                       |    2 
 arch/powerpc/kernel/smp.c                      |    2 
 arch/powerpc/mm/slb.c                          |   21 ++--
 arch/x86/kernel/apic_64.c                      |    2 
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c     |   10 ++
 arch/x86/kernel/irq_32.c                       |    2 
 arch/x86/kernel/process_32.c                   |    5 -
 arch/x86/kernel/process_64.c                   |    5 -
 arch/x86/kernel/ptrace.c                       |    7 +
 arch/x86/kernel/tsc_32.c                       |   38 ++++----
 arch/x86/kernel/tsc_64.c                       |    5 -
 arch/x86/mm/init_64.c                          |    2 
 arch/x86/pci/common.c                          |   17 ---
 drivers/ata/libata-core.c                      |   12 ++
 drivers/cpufreq/cpufreq.c                      |    4 
 drivers/hid/hid-input.c                        |    5 -
 drivers/hid/usbhid/hid-quirks.c                |   38 ++++----
 drivers/i2c/busses/i2c-nforce2.c               |   28 +++++-
 drivers/i2c/chips/max6875.c                    |    3 
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 +
 drivers/md/md.c                                |    2 
 drivers/md/raid5.c                             |   10 ++
 drivers/net/atl1/atl1_main.c                   |    1 
 drivers/net/ps3_gelic_wireless.c               |    2 
 drivers/usb/class/cdc-acm.c                    |    3 
 drivers/usb/host/ohci-omap.c                   |    3 
 drivers/usb/host/ohci-sm501.c                  |    3 
 drivers/usb/misc/ldusb.c                       |    4 
 drivers/usb/serial/ftdi_sio.c                  |    1 
 drivers/usb/serial/ftdi_sio.h                  |    6 +
 drivers/usb/serial/option.c                    |    9 +-
 drivers/usb/serial/pl2303.c                    |    1 
 drivers/usb/serial/pl2303.h                    |    1 
 drivers/usb/storage/unusual_devs.h             |   10 ++
 fs/cifs/inode.c                                |   15 ++-
 fs/ecryptfs/ecryptfs_kernel.h                  |    2 
 fs/ecryptfs/read_write.c                       |   22 ----
 fs/ext3/xattr.c                                |    5 +
 fs/ext4/xattr.c                                |    5 +
 fs/proc/array.c                                |    2 
 fs/proc/base.c                                 |   33 +++++--
 fs/proc/task_mmu.c                             |   28 ++----
 fs/xfs/linux-2.6/xfs_buf.c                     |   24 ++++-
 fs/xfs/linux-2.6/xfs_buf.h                     |   19 ++++
 include/asm-x86/tlbflush.h                     |   13 ++
 include/linux/capability.h                     |   29 ++++--
 include/linux/hid.h                            |    1 
 include/linux/types.h                          |    4 
 kernel/capability.c                            |  111 ++++++++++++++++---------
 kernel/cgroup.c                                |    2 
 mm/memory_hotplug.c                            |   78 ++++++++---------
 mm/mmap.c                                      |    8 +
 mm/page_alloc.c                                |    3 
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    8 +
 net/netfilter/nf_conntrack_expect.c            |    4 
 net/netfilter/xt_connlimit.c                   |    3 
 net/netfilter/xt_iprange.c                     |    2 
 security/smack/smack_lsm.c                     |   12 ++
 58 files changed, 449 insertions(+), 254 deletions(-)

Alexey Dobriyan (1):
      atl1: fix 4G memory corruption bug

Andrew G. Morgan (1):
      capabilities: remain source compatible with 32-bit raw legacy capability support.

Atsushi Nemoto (1):
      usb-serial: Use ftdi_sio driver for RATOC REX-USB60F

CHIKAMA masaki (1):
      cpufreq: fix null object access on Transmeta CPU

Casey Schaufler (1):
      Smack: fuse mount hang fix

Cedric Le Goater (1):
      cgroups: remove node_ prefix_from ns subsystem

Chris Wright (1):
      Linux 2.6.25.6

Christoph Hellwig (1):
      XFS: Fix memory corruption with small buffer reads

Chuck Ebbert (1):
      x86: don't read maxlvt before checking if APIC is mapped

Dan Williams (4):
      USB: option: add new Dell 5520 HSDPA variant
      md: do not compute parity unless it is on a failed drive
      md: fix uninitialized use of mddev->recovery_wait
      md: fix prexor vs sync_request race

Diego 'Flameeyes' Petteno (1):
      HID: split Numlock emulation quirk from HID_QUIRK_APPLE_HAS_FN.

Eugeniy Meshcheryakov (1):
      USB: do not handle device 1410:5010 in 'option' driver

Filip Aben (1):
      USB: unusual_devs: Add support for GI 0401 SD-Card interface

Greg Kroah-Hartman (3):
      USB: add Telstra NextG CDMA id to option driver
      USB: fix build errors in ohci-omap.c and ohci-sm501.c
      USB: add TELIT HDSPA UC864-E modem to option driver

Heiko Carstens (1):
      memory_hotplug: always initialize pageblock bitmap

Hugh Dickins (1):
      x86: fix bad pmd ffff810000207xxx(9090909090909090)

Iain McFarlane (1):
      USB: add Zoom Telephonics Model 3095F V.92 USB Mini External modem to cdc-acm

Ingo Molnar (1):
      x86: prevent PGE flush from interruption/preemption

Jack Morgenstein (1):
      IPoIB: Test for NULL broadcast object in ipiob_mcast_join_finish()

Jan Beulich (1):
      i386: fix asm constraint in do_IRQ()

Jean Delvare (2):
      i2c-nforce2: Disable the second SMBus channel on the DFI Lanparty NF4 Expert
      i2c/max6875: Really prevent 24RF08 corruption

Jiri Kosina (1):
      brk: make sys_brk() honor COMPAT_BRK when computing lower bound

Linus Torvalds (1):
      Revert "PCI: remove default PCI expansion ROM memory allocation"

Masakazu Mokuno (1):
      PS3: gelic: fix memory leak

Michael Halcrow (1):
      eCryptfs: remove unnecessary page decrypt call

Patrick McHardy (3):
      netfilter: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()
      netfilter: xt_connlimit: fix accouning when receive RST packet in ESTABLISHED state
      netfilter: nf_conntrack_ipv6: fix inconsistent lock state in nf_ct_frag6_gather()

Paul Mackerras (1):
      POWERPC Bolt in SLB entry for kernel stack on secondary cpus

Phil Oester (1):
      netfilter: xt_iprange: module aliases for xt_iprange

Roland McGrath (1):
      x86: user_regset_view table fix for ia32 on 64-bit

Rusty Russell (1):
      x86: if we cannot calibrate the TSC, we panic.

Steve French (1):
      CIFS: Fix UNC path prefix on QueryUnixPathInfo to have correct slash

Suresh Siddha (1):
      x86, fpu: fix CONFIG_PREEMPT=y corruption of application's FPU stack

Tejun Heo (1):
      libata: force hardreset if link is in powersave mode

Thomas Gleixner (3):
      x86: fix setup of cyc2ns in tsc_64.c
      x86: distangle user disabled TSC from unstable
      x86: disable TSC for sched_clock() when calibration failed

Thomas Tuttle (1):
      pagemap: fix bug in add_to_pagemap, require aligned-length reads of /proc/pid/pagemap

Tiger Yang (1):
      ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()

Vegard Nossum (1):
      proc: calculate the correct /proc/<pid> link count

Venkatesh Pallipadi (1):
      CPUFREQ: Make acpi-cpufreq more robust against BIOS freq changes behind our back.

Xiaofan Chen (1):
      USB: remove PICDEM FS USB demo (04d8:000c) device from ldusb

maximilian attems (1):
      types.h: don't expose struct ustat to userspace

