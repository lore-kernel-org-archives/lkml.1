Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbZIEXyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbZIEXyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 19:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZIEXy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 19:54:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbZIEXy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 19:54:28 -0400
Date: Sat, 5 Sep 2009 16:54:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.31-rc9
Message-ID: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I know I said I'd just release the final 2.6.31 when I was done diving, 
but there were more pull requests while I was away than I'm comfortable 
with at this stage. So I'm doing an -rc9 to let it simmer for a couple of 
days and get some last-minute testing before doing the final release.

In particular, inotify was still broken in -rc8, and while several people 
have verified that the -git trees fixed it, doing an -rc9 to get wider 
checking is a good idea. We've also hopefully _finally_ fixed that last 
annoying pty buffering bug, with Mikael Pettersson confirming that the 
problems he saw are fixed.

There are also some (too big at this stage, oh well) updates to DM and a 
couple of media drivers, and some Intel KMS fixes.

And then a random smattering of one-liners.

Go wild, and please give this a final round of testing.

			Linus

---
Anton Vorontsov (1):
      mtd: m25p80: fix null pointer dereference bug

Bartlomiej Zolnierkiewicz (1):
      ata_piix: parallel scanning on PATA needs an extra locking

Benjamin Herrenschmidt (1):
      lmb: Also remove __init from lmb_end_of_RAM() declaration in lmb.h

Brian Rogers (1):
      inotify: do not send a block of zeros when no pathname is available

Bruno Prémont (1):
      drm/i915: Check if BIOS enabled dual-channel LVDS on 8xx, not only on 9xx

Chris Wright (1):
      PCI SR-IOV: correct broken resource alignment calculations

Christoph Hellwig (1):
      xfs: actually enable the swapext compat handler

Clemens Ladisch (2):
      sound: oxygen: fix MCLK rate for 192 kHz playback
      sound: oxygen: handle cards with missing EEPROM

Dave Andrews (1):
      Input: atkbd - add Compaq Presario R4000-series repeat quirk

David Howells (1):
      nommu: fix error handling in do_mmap_pgoff()

David Müller (ELSOFT AG) (1):
      drm/i915: Improve CRTDDC mapping by using VBT info

David S. Miller (3):
      pkt_sched: Revert tasklet_hrtimer changes.
      sparc64: Kill spurious NMI watchdog triggers by increasing limit to 30 seconds.
      sparc64: Fix bootup with mcount in some configs.

Dimitri Gorokhovik (2):
      mtd: nftl: write support is broken
      mtd: nftl: fix offset alignments

Dmitry Torokhov (1):
      Input: i8042 - add Acer Aspire 5536 to the nomux list

Dominik Brodowski (1):
      [CPUFREQ] Re-enable cpufreq suspend and resume code

Eric Anholt (1):
      drm/i915: Fix CPU-spinning hangs related to fence usage by using an LRU.

Eric Dumazet (2):
      tc: Fix unitialized kernel memory leak
      slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU

Eric Paris (2):
      inotify: fix length reporting and size checking
      inotify: update the group mask on mark addition

Grant Grundler (1):
      parisc: fix warning in traps.c

H. Peter Anvin (1):
      x86, xen: Initialize cx to suppress warning

Herbert Xu (1):
      crypto: skcipher - Fix skcipher_dequeue_givcrypt NULL test

Ian Kent (1):
      autofs4 - fix missed case when changing to use struct path

Ingo Molnar (2):
      perf_counters: Increase paranoia level
      modules: Fix build error in the !CONFIG_KALLSYMS case

Jarek Poplawski (1):
      net: sk_free() should be allowed right after sk_alloc()

Jeremy Fitzhardinge (1):
      x86, xen: Suppress WP test on Xen

Jiri Bohac (1):
      [IA64] fix csum_ipv6_magic()

Jiri Slaby (1):
      toshiba_acpi: return on a fail path

Joe Perches (1):
      V4L/DVB (12564a): MAINTAINERS: Update gspca sn9c20x name style

Jonathan Brassow (4):
      dm log: fix userspace status output
      dm log: remove incorrect field from userspace table output
      dm raid1: do not allow log_failure variable to unset after being set
      dm log: userspace add luid to distinguish between concurrent log instances

Keith Packard (1):
      ACPI: don't free non-existent backlight in acpi video module

Kiyoshi Ueda (1):
      dm multipath: fix oops when request based io fails when no paths

Lin Ming (1):
      ACPICA: Windows compatibility fix: same buffer/string store

Linus Torvalds (3):
      n_tty: do O_ONLCR translation as a single write
      pty: don't limit the writes to 'pty_space()' inside 'pty_write()'
      Linux 2.6.31-rc9

Ma Ling (2):
      drm/i915: Always use SDVO_B detect bit for SDVO output detection.
      drm/i915: Set crtc/clone mask in different output devices

Massimo Cirillo (1):
      JFFS2: add missing verify buffer allocation/deallocation

Mauro Carvalho Chehab (1):
      V4L/DVB (12449): adds webcam for Micron device MT9M111 0x143A to em28xx

Mel Gorman (1):
      page-allocator: always change pageblock ownership when anti-fragmentation is disabled

Michael Krufky (1):
      V4L/DVB (12446): sms1xxx: restore GPIO functionality for all Hauppauge devices

Mike Snitzer (3):
      dm snapshot: implement iterate devices
      dm table: add more context to terse warning messages
      dm stripe: expose correct io hints

Mikulas Patocka (5):
      dm table: fix queue_limit checking device iterator
      dm snapshot: refactor zero_disk_area to use chunk_io
      dm snapshot: fix header corruption race on invalidation
      dm exception store: split set_chunk_size
      dm snapshot: fix on disk chunk size validation

Nicolas Pitre (1):
      ext2: fix unbalanced kmap()/kunmap()

Nikanth Karthikesan (1):
      block: Allow changing max_sectors_kb above the default 512

Oleg Nesterov (2):
      workqueues: introduce __cancel_delayed_work()
      exec: do not sleep in TASK_TRACED under ->cred_guard_mutex

Paul Mackerras (1):
      perf_counter/powerpc: Fix cache event codes for POWER7

Peter Zijlstra (1):
      perf_counter: Fix /0 bug in swcounters

Randy Dunlap (1):
      V4L/DVB (12502): gspca - sn9c20x: Fix gscpa sn9c20x build errors.

Roderick Colenbrander (1):
      powerpc: Fix i8259 interrupt driver kernel crash on ML510

Roel Kluin (2):
      drm/i915: Fix typo that broke SVID1 in intel_sdvo_multifunc_encoder()
      V4L/DVB (12457): zr364: wrong indexes

Ryusuke Konishi (1):
      nilfs2: fix preempt count underflow in nilfs_btnode_prepare_change_key

Sean Young (1):
      drm/i915: Set the multiplier for SDVO on G33 platform

Shine Liu (1):
      V4L/DVB (12495): em28xx: Don't call em28xx_ir_init when disable_ir is true

Stefan Richter (4):
      firewire: core: fix crash in iso resource management
      firewire: ohci: fix Agere FW643 and multiple cameras
      firewire: ohci: fix Ricoh R5C832, video reception
      firewire: sbp2: fix freeing of unallocated memory

Sunil Mushran (1):
      ocfs2: ocfs2_write_begin_nolock() should handle len=0

Takashi Iwai (2):
      ALSA: hda - Add missing mux check for VT1708
      ALSA: hda - Fix MacBookPro 3,1/4,1 quirk with ALC889A

Tao Ma (1):
      ocfs2: invalidate dentry if its dentry_lock isn't initialized.

Tejun Heo (1):
      percpu: don't assume existence of cpu0

Tony Luck (1):
      [IA64] Fix warning in dma-mapping.c

Toru UCHIYAMA (1):
      gianfar: gfar_remove needs to call unregister_netdev()

Trond Myklebust (1):
      SUNRPC: Fix rpc_task_force_reencode

Udi Atar (2):
      V4L/DVB (12450): Siano: Fixed SDIO compilation bugs
      V4L/DVB (12451): Update KConfig File to enable SDIO and USB interfaces

Yinghai Lu (1):
      x86: Fix vSMP boot crash

Zhu Yi (1):
      ipw2200: firmware DMA loading rework
