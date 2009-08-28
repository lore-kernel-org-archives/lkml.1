Return-Path: <linux-kernel-owner+w=401wt.eu-S1751230AbZH1BYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbZH1BYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 21:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZH1BYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 21:24:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbZH1BYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 21:24:12 -0400
Date: Thu, 27 Aug 2009 18:24:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.31-rc8
Message-ID: <alpine.LFD.2.01.0908271805210.3218@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This should be the last -rc, and it's really been quieting down. There's 
131 commits there, and it's all pretty trivial. For example, in the 
dirstat below, most of the arch/x86 changes are due to some vmlinux.lds.S 
changes to fix problems with older binutils, not actual code changes. And 
on powerpc, it's all the ps3 defconfig update.

   8.7% arch/powerpc/configs/
   8.7% arch/powerpc/
   2.6% arch/sparc/configs/
   5.3% arch/sparc/kernel/
   2.8% arch/sparc/mm/
  11.2% arch/sparc/
   5.9% arch/x86/kernel/
   7.0% arch/x86/
  28.3% arch/
   2.6% drivers/acpi/
   3.5% drivers/input/
   7.6% drivers/net/
  13.5% drivers/scsi/mpt2sas/
  30.3% drivers/
   7.7% fs/9p/
   3.4% fs/ext3/
   8.6% fs/notify/inotify/
  21.4% fs/
   3.5% kernel/
   4.0% lib/
   3.0% net/9p/
   5.8% net/
   2.2% sound/core/
   3.2% sound/

So apart from the trivial but somewhat bulky stuff like that, there's a 
sparc TLB loading upddate, there's a mpt2sas driver update, and there's 
the plan9 filesystem update. And there's a few fs/notify cleanups and 
fixes that will hopefully put the inotify problems behind us for good. 
Knock wood.

The rest is pretty much one-liners with a couple of "few-liners".

I'll be gone for the next week, but it should be quiet. But pester the 
usual suspects (aka "maintainers") about any bugs you see, and they'll fix 
it while I'm diving. And then we'll have a final release for labor day.

			Linus

---
Abhishek Kulkarni (10):
      9p: Check for error in return value of v9fs_fid_add
      9p: Fix possible inode leak in v9fs_get_inode.
      9p: minor comment fixes
      9p: Fix possible memleak in v9fs_inode_from fid.
      9p: Fix v9fs show_options
      9p: Fix possible regressions when ->get_sb fails.
      9p: Remove redundant inode uid/gid assignment
      9p: Add missing cast for the error return value in v9fs_get_inode
      net/9p: insulate the client against an invalid error code sent by a 9p server
      9p: remove unnecessary v9fses->options which duplicates the mount string

Alek Du (1):
      PCI: check saved state before restore

Alexander Beregalov (2):
      irda/au1k_ir: fix broken netdev_ops conversion
      irda/sa1100_ir: fix broken netdev_ops conversion

Alexey Dobriyan (2):
      smc91x: fix compilation on SMP
      m68k: Fix redefinition of pgprot_noncached

Amerigo Wang (2):
      timers: Drop write permission on /proc/timer_list
      x86: Fix an incorrect argument of reserve_bootmem()

Andreas Mohr (1):
      net: Fix Micrel KSZ8842 Kconfig description

Andrew Morton (1):
      arch/m68k/include/asm/motorola_pgalloc.h: fix kunmap arg

Bartlomiej Zolnierkiewicz (1):
      ALSA: ali5451: fix timeout handling in snd_ali_{codecs,timer}_ready()

Ben Nizette (1):
      favr32: improve touchscreen response

Benjamin Herrenschmidt (1):
      lmb: Remove __init from lmb_end_of_DRAM()

Bruno Prémont (1):
      ipv6: Fix commit 63d9950b08184e6531adceb65f64b429909cc101 (ipv6: Make v4-mapped bindings consistent with IPv4)

Clemens Ladisch (2):
      sound: vx222: fix input level control range check
      sound: pcm_lib: fix unsorted list constraint handling

Costantino Leandro (1):
      wmi: fix kernel panic when stack protection enabled.

David Howells (1):
      AFS: Stop readlink() on AFS crashing due to NULL 'file' ptr

David Rientjes (4):
      flex_array: fix get function for elements in base starting at non-zero
      flex_array: fix flex_array_free_parts comment
      flex_array: declare parts member to have incomplete type
      flex_array: convert element_nr formals to unsigned

David S. Miller (10):
      sparc: Fix cleanup crash in bbc_envctrl_cleanup()
      sparc64: Sign extend length arg to truncate syscalls when compat.
      sparc: Use page_fault_out_of_memory() for VM_FAULT_OOM.
      sparc32: Kill trap table freeing code.
      sparc32: Update defconfig.
      sparc64: Update defconfig.
      pkt_sched: Convert qdisc_watchdog to tasklet_hrtimer
      pkt_sched: Convert CBQ to tasklet_hrtimer.
      pkt_sched: Fix bogon in tasklet_hrtimer changes.
      sparc64: Validate linear D-TLB misses.

Dmitry Torokhov (1):
      Input: wacom - don't use on-stack memory for report buffers

Dongdong Deng (3):
      netpoll: warning for ndo_start_xmit returns with interrupts enabled
      drivers/net: fixed drivers that support netpoll use ndo_start_xmit()
      smc91x: let smc91x work well under netpoll

Eric Paris (4):
      IMA: iint put in ima_counts_get and put
      inotify: seperate new watch creation updating existing watches
      inotify: do not BUG on idr entries at inotify destruction
      inotify: fix locking around inotify watching in the idr

Eric Van Hensbergen (1):
      9p: update documentation pointers

Eric W. Biederman (1):
      inotify: Ensure we alwasy write the terminating NULL.

Florian Fainelli (1):
      [WATCHDOG] ar7_wdt: fix path to ar7-specific headers

Frans Pop (2):
      ACPI processor: force throttling state when BIOS returns incorrect value
      acpi processor: remove superfluous warning message

Geert Uytterhoeven (2):
      m68k,m68knommu: Wire up rt_tgsigqueueinfo and perf_counter_open
      powerpc/ps3: Add missing check for PS3 to rtc-ps3 platform device registration

Geoff Levand (1):
      powerpc/ps3: Update ps3_defconfig

Goldwyn Rodrigues (1):
      ocfs2/dlm: Wait on lockres instead of erroring cancel requests

Hendrik Brueckner (1):
      [S390] set preferred console based on conmode

Herton Ronaldo Krzesinski (1):
      rtl8187: always set MSR_LINK_ENEDCA flag with RTL8187B

Hugh Dickins (1):
      mm: fix hugetlb bug due to user_shm_unlock call

Ingo Molnar (1):
      tracing: Fix too large stack usage in do_one_initcall()

James Bottomley (1):
      module: workaround duplicate section names

Jan Beulich (3):
      i386: Fix section mismatches for init code with !HOTPLUG_CPU
      x86: add vmlinux.lds to targets in arch/x86/boot/compressed/Makefile
      x86: Fix build with older binutils and consolidate linker script

Jan Kara (4):
      ocfs2: Handle quota file corruption more gracefully
      ocfs2: Don't oops in ocfs2_kill_sb on a failed mount
      ocfs2: Add missing lock name
      ext3: Improve error message that changing journaling mode on remount is not possible

Jeremy Fitzhardinge (3):
      x86: make sure load_percpu_segment has no stackprotector
      xen: rearrange things to fix stackprotector
      xenfb: connect to backend before registering fb

Jiri Kosina (1):
      Input: iforce - support new revision of ACT LABS Force RS

Jiri Olsa (1):
      tracing: handle broken names in ftrace filter

Jiri Slaby (1):
      NET: llc, zero sockaddr_llc struct

Johannes Berg (1):
      mac80211: fix todo lock

John Holland (1):
      [ARM] Kirkwood: enable eSATA on QNAP TS-219P

John W. Linville (1):
      orinoco: correct key bounds check in orinoco_hw_get_tkip_iv

Joonwoo Park (1):
      pps: fix incorrect verdict check

Julia Lawall (1):
      [S390] drivers/s390: put NULL test before dereference

Julien TINNES (1):
      ipv4: make ip_append_data() handle NULL routing table

Kashyap, Desai (9):
      [SCSI] mpt2sas: Introduced check for enclosure_handle to avoid crash
      [SCSI] mpt2sas: Expander fix oops saying "Already part of another port"
      [SCSI] mpt2sas: Raid 10 Value is showing as Raid 1E in /va/log/messages
      [SCSI] mpt2sas: Excessive log info causes sas iounit page time out
      [SCSI] mpt2sas: fix infinite loop inside config request
      [SCSI] mpt2sas: fix crash due to Watchdog is active while OS in standby mode
      [SCSI] mpt2sas: fix oops because drv data points to NULL on resume from hibernate
      [SCSI] mpt2sas: Bump driver version 01.100.04.00
      [SCSI] mpt2sas: fix config request and diag reset deadlock

Krzysztof Ha³asa (1):
      E100: fix interaction with swiotlb on X86.

Kyle McMartin (1):
      dma-debug: Fix check_unmap null pointer dereference

Linus Torvalds (2):
      tty: make sure to flush any pending work when halting the ldisc
      Linux 2.6.31-rc8

Marek Vasut (2):
      Input: ucb1400_ts - enable ADC Filter
      pxaficp-ir: remove incorrect net_device_ops

Martin Michlmayr (1):
      [ARM] Kirkwood: __init requires linux/init.h

Mathieu Desnoyers (1):
      sparc: sys32.S incorrect compat-layer splice() system call

Michael Brunner (1):
      thermal_sys: check get_temp return value

Michel Dänzer (1):
      drm/radeon/kms: Fix radeon_gem_busy_ioctl harder.

Mimi Zohar (2):
      kernel_read: redefine offset type
      ima: hashing large files bug fix

Minchan Kim (1):
      mm: fix for infinite churning of mlocked pages

Oleg Nesterov (1):
      clone(): fix race between copy_process() and de_thread()

Patrick McHardy (1):
      netfilter: xt_quota: fix wrong return value (error case)

Pavel Revak (1):
      Input: ucb1400_ts - enable interrupt unconditionally

Peter Zijlstra (2):
      perf tools: Check perf.data owner
      perf_counter: Fix typo in read() output generation

Petri Gynther (1):
      ibm_newemac: emac_close() needs to call netif_carrier_off()

Randy Dunlap (1):
      net: fix ks8851 build errors

Roel Kluin (3):
      yellowfin: Fix buffer underrun after dev_alloc_skb() failure
      m68k: count can reach 51, not 50
      m68k: cnt reaches -1, not 0

Rusty Russell (2):
      virtio: net refill on out-of-memory
      module: fix BUG_ON() for powerpc (and other function descriptor archs)

Sebastian Andrzej Siewior (2):
      avr32/lib: fix unaligned memcpy()
      avr32/lib: fix unaligned memcpy where len < 4

Sebastian Ott (1):
      [S390] cio: fix double free after failed device initialization

Simon Kagstrom (1):
      [ARM] Orion NAND: Make asm volatile avoid GCC pushing ldrd out of the loop

Stephen Kitt (1):
      Input: joydev - decouple axis and button map ioctls from input constants

Suresh Siddha (2):
      x86, pat: Allow ISA memory range uncacheable mapping requests
      clockevent: Prevent dead lock on clockevents_lock

Tao Ma (1):
      ocfs2: release the buffer head in ocfs2_do_truncate.

Thadeu Lima de Souza Cascardo (2):
      leds: fix multiple requests and releases of IRQ for GPIO LED Trigger
      leds: after setting inverted attribute, we must update the LED

Theodore Ts'o (1):
      ext3: Update Kconfig description of EXT3_DEFAULTS_TO_ORDERED

Trond Myklebust (1):
      NFSv4: Fix an infinite looping problem with the nfs4_state_manager

Wan ZongShun (1):
      net: Rename MAC platform driver for w90p910 platform

Yinghai Lu (1):
      acpi: don't call acpi_processor_init if acpi is disabled

Zhaolei (1):
      ftrace: Unify effect of writing to trace_options and option/*
