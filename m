Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbYFYCbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbYFYCbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 22:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYFYCbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 22:31:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbYFYCbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 22:31:12 -0400
Date: Tue, 24 Jun 2008 19:31:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc8
Message-ID: <alpine.LFD.1.10.0806241917490.13106@hp.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It hasn't been a week, I know, and this is a pretty small set of changes 
since -rc7, but I'm going to be mostly incommunicado for the next week or 
so, so I just released what will hopefully be the last -rc.

Or maybe not. 

It depends on how good you all are while I'm not looking.

Anyway, most of the bulk of the changes here are to Xen and to KVM in 
particular, which shows up as a rather unusual dirstat: 65% is in 
arch/x86 (counting the asm-x86 changes too). The rest is mostly random 
stuff, the appended ShortLog gives a reasonable idea. Several bugzilla 
entries are hopefully now closed.

Here's the dirstat (whee - just 5% in drivers - that's a new one):

   2.4% Documentation/DocBook/
   4.3% Documentation/hwmon/
   6.7% Documentation/
  24.2% arch/x86/kernel/
   5.2% arch/x86/kvm/
  25.3% arch/x86/xen/
  54.8% arch/x86/
  55.4% arch/
   3.2% drivers/hwmon/
   5.2% drivers/
   5.2% fs/nfs/
   7.5% fs/
   4.4% include/asm-alpha/
  10.0% include/asm-x86/
  16.5% include/
   3.5% kernel/

and the - this time really fairly short - shortlog is appended.

What you don't see from this (maybe I should add some shortlog mode that 
shows the size of the patches too) is that a lot of them are really just a 
couple of lines (which is also why the KVM changes stand out so much - 
they're bigger).

		Linus
---
Alan Cox (1):
      tty_driver: Update required method documentation

Avi Kivity (3):
      KVM: MMU: Fix oops on guest userspace access to guest pagetable
      KVM: ioapic: fix lost interrupt when changing a device's irq
      KVM: VMX: Fix host msr corruption with preemption enabled

Benjamin Marzinski (1):
      [GFS2] fix gfs2 block allocation (cleaned up)

Bernhard Walle (1):
      Add return value to reserve_bootmem_node()

Bob Peterson (1):
      [GFS2] BUG: unable to handle kernel paging request at ffff81002690e000

Christoph Lameter (1):
      Slab: Fix memory leak in fallback_alloc()

Cliff Wickman (2):
      [IA64] SN2: security hole in sn2_ptc_proc_write
      [IA64] Handle count==0 in sn2_ptc_proc_write()

David Brownell (1):
      hwmon: (lm75) sensor reading bugfix

David S. Miller (1):
      sctp: Make sure N * sizeof(union sctp_addr) does not overflow.

Eli Cohen (1):
      IB/mthca: Clear ICM pages before handing to FW

Eric W. Biederman (1):
      netns: Don't receive new packets in a dead network namespace.

Frederic Bohe (1):
      Ext4: Fix online resize block group descriptor corruption

Gerd Hoffmann (5):
      x86: Add structs and functions for paravirt clocksource
      x86: Make xen use the paravirt clocksource structs and functions
      KVM: Make kvm host use the paravirt clocksource structs
      x86: KVM guest: Use the paravirt clocksource structs and functions
      KVM: Remove now unused structs from kvm_para.h

Gustavo Fernando Padovan (1):
      removed unused var real_tty on n_tty_ioctl()

Hans de Goede (2):
      hwmon: (abituguru3) Identify Abit AW8D board as such
      hwmon: (abituguru3) update driver detection

Isaku Yamahata (1):
      xen: Use wmb instead of rmb in xen_evtchn_do_upcall().

Ivan Kokshaysky (4):
      alpha: fix module load failures on smp (bug #10926)
      alpha: link failure fix
      alpha: fix compile failures with gcc-4.3 (bug #10438)
      alpha: resurrect Cypress IDE quirk

Jason Wessel (2):
      kgdb: documentation update - remove kgdboe
      kgdb: sparse fix

Jean Delvare (3):
      hwmon: (lm85) Fix function RANGE_TO_REG()
      hwmon: (adt7473) Initialize max_duty_at_overheat before use
      hwmon: Update the sysfs interface documentation

Jeremy Fitzhardinge (3):
      xen: mask unwanted pte bits in __supported_pte_mask
      xen: don't drop NX bit
      xen: remove support for non-PAE 32-bit

Jes Sorensen (1):
      [IA64] Fix boot failure on ia64/sn2

Jie Luo (1):
      enable bus mastering on i915 at resume time

Johannes Berg (1):
      mac80211: detect driver tx bugs

Julia Lawall (1):
      [IA64] Eliminate NULL test after alloc_bootmem in iosapic_alloc_rte()

Linus Torvalds (3):
      Fix performance regression on lmbench select benchmark
      Fix ZERO_PAGE breakage with vmware
      Linux 2.6.26-rc8

Marc Hulsman (1):
      hwmon: (w83791d) new maintainer

Marcelo Tosatti (4):
      KVM: Fix race between timer migration and vcpu migration
      KVM: close timer injection race window in __vcpu_run
      KVM: MMU: Fix rmap_write_protect() hugepage iteration bug
      KVM: MMU: large page update_pte issue with non-PAE 32-bit guests (resend)

Nick Piggin (1):
      mm: fix race in COW logic

Oleg Nesterov (1):
      sched: refactor wait_for_completion_timeout()

Peter Zijlstra (1):
      sched: rt: dont stop the period timer when there are tasks wanting to run

Roland Dreier (1):
      sched: fix wait_for_completion_timeout() spurious failure under heavy load

Shan Wei (1):
      ipv6: Remove options header when setsockopt's optlen is 0

Stephen Hemminger (1):
      pppoe: warning fix

Suresh Siddha (1):
      x86: fix NULL pointer deref in __switch_to

Takashi Iwai (2):
      ALSA: aw2 - Fix Oops at initialization
      ALSA: sb - Fix wrong assertions

Thomas Gleixner (1):
      futexes: fix fault handling in futex_lock_pi

Thorsten Kranzkowski (1):
      alpha: fix compile error in arch/alpha/mm/init.c

Trond Myklebust (3):
      NFS: Reduce the NFS mount code stack usage.
      NFS: Fix filehandle size comparisons in the mount code
      NFS: nfs_updatepage(): don't mark page as dirty if an error occurred

Wim Van Sebroeck (1):
      Revert "[WATCHDOG] hpwdt: Add CFLAGS to get driver working"

YOSHIFUJI Hideaki (1):
      ipv6: Drop packets for loopback address from outside of the box.
