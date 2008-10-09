Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYJIDnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYJIDnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 23:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYJIDm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 23:42:59 -0400
Received: from kroah.org ([198.145.64.141]:60127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754987AbYJIDm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 23:42:58 -0400
Date: Wed, 8 Oct 2008 20:40:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.26.6
Message-ID: <20081009034030.GA1799@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.26.6
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.26
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.26.5 and 2.6.26.6

The updated 2.6.26.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/s390/kernel/compat_ptrace.h                |    1 
 arch/s390/kernel/ptrace.c                       |   28 +++++
 arch/sparc64/kernel/of_device.c                 |    9 -
 arch/sparc64/kernel/pci.c                       |    2 
 arch/sparc64/kernel/pci_psycho.c                |   14 +-
 arch/sparc64/kernel/prom.c                      |  104 +--------------------
 arch/x86/kernel/alternative.c                   |   18 +--
 arch/x86/kernel/apic_32.c                       |   30 +++++-
 arch/x86/kernel/apic_64.c                       |    3 
 arch/x86/kernel/cpu/bugs.c                      |    6 +
 arch/x86/kernel/e820_32.c                       |    2 
 arch/x86/kernel/e820_64.c                       |    2 
 arch/x86/kernel/genapic_64.c                    |    2 
 arch/x86/kernel/head64.c                        |    1 
 arch/x86/kernel/hpet.c                          |   19 ++-
 arch/x86/kernel/io_delay.c                      |    8 +
 arch/x86/kernel/mpparse.c                       |    5 +
 arch/x86/kernel/setup.c                         |    1 
 arch/x86/kernel/setup_32.c                      |   11 +-
 arch/x86/kernel/signal_64.c                     |   62 ++++++++++++
 arch/x86/kernel/traps_64.c                      |    9 +
 arch/x86/kernel/vmi_32.c                        |    2 
 arch/x86/kernel/vsmp_64.c                       |    2 
 arch/x86/kvm/svm.c                              |   14 ++
 arch/x86/mach-generic/bigsmp.c                  |    2 
 arch/x86/mm/pageattr.c                          |    6 -
 arch/x86/oprofile/nmi_int.c                     |   39 +++++++-
 crypto/async_tx/async_tx.c                      |    3 
 drivers/accessibility/braille/braille_console.c |   13 --
 drivers/acpi/ec.c                               |    2 
 drivers/acpi/processor_perflib.c                |    2 
 drivers/i2c/i2c-dev.c                           |    4 
 drivers/mmc/card/block.c                        |    4 
 drivers/net/ixgbe/ixgbe_main.c                  |    6 +
 drivers/net/niu.c                               |   56 +++++++++++
 drivers/net/wireless/rt2x00/rt2x00.h            |    4 
 drivers/net/wireless/rt2x00/rt2x00dev.c         |   17 ---
 drivers/net/wireless/rt2x00/rt2x00mac.c         |    4 
 drivers/pcmcia/ds.c                             |   23 ++--
 drivers/rtc/rtc-dev.c                           |   15 +--
 drivers/scsi/qla2xxx/qla_isr.c                  |    1 
 drivers/scsi/qla2xxx/qla_os.c                   |    2 
 drivers/spi/pxa2xx_spi.c                        |  116 ++++++++++++++++++------
 drivers/usb/core/hcd.c                          |    3 
 drivers/video/console/fbcon.h                   |    2 
 fs/buffer.c                                     |   13 +-
 fs/exec.c                                       |    2 
 fs/ocfs2/stackglue.c                            |    7 -
 fs/proc/array.c                                 |   59 ------------
 include/asm-generic/rtc.h                       |   12 --
 include/asm-x86/i387.h                          |   56 -----------
 include/asm-x86/mpspec.h                        |    1 
 include/asm-x86/pgtable_64.h                    |    2 
 include/linux/clockchips.h                      |    2 
 include/linux/mmzone.h                          |   12 +-
 include/linux/rmap.h                            |    2 
 include/linux/sched.h                           |    4 
 include/linux/smb.h                             |    2 
 include/net/netlink.h                           |    2 
 kernel/cgroup.c                                 |    5 -
 kernel/exit.c                                   |   18 ++-
 kernel/sched.c                                  |   59 ++++++++++++
 kernel/time/clockevents.c                       |    3 
 kernel/time/ntp.c                               |    2 
 kernel/time/tick-broadcast.c                    |   78 ++++++++++++----
 kernel/time/tick-common.c                       |    1 
 kernel/time/tick-internal.h                     |    2 
 kernel/time/tick-oneshot.c                      |   44 +++++++--
 lib/scatterlist.c                               |    5 -
 mm/filemap_xip.c                                |    2 
 mm/memcontrol.c                                 |   13 ++
 mm/mmzone.c                                     |    2 
 mm/rmap.c                                       |   14 +-
 net/ipv4/udp.c                                  |   59 ++++++------
 net/ipv6/ip6_output.c                           |   64 ++++++-------
 net/ipv6/route.c                                |    2 
 net/key/af_key.c                                |   30 +++---
 net/sctp/associola.c                            |    9 +
 net/sctp/sm_make_chunk.c                        |   15 +--
 net/xfrm/xfrm_output.c                          |   12 +-
 sound/core/pcm.c                                |    4 
 sound/core/pcm_native.c                         |   13 --
 sound/core/rawmidi.c                            |    4 
 sound/pci/hda/patch_sigmatel.c                  |    2 
 sound/pci/oxygen/hifier.c                       |    4 
 sound/pci/oxygen/oxygen.c                       |    4 
 sound/ppc/awacs.c                               |   50 +++++++---
 88 files changed, 862 insertions(+), 515 deletions(-)


Alan Cox (1):
      pcmcia: Fix broken abuse of dev->driver_data

Andi Kleen (1):
      x86: fix oprofile + hibernation badness

Andrew Morton (1):
      drivers/mmc/card/block.c: fix refcount leak in mmc_block_open()

Andrew Vasquez (1):
      SCSI: qla2xxx: Defer enablement of RISC interrupts until ISP initialization completes.

Andy Gospodarek (1):
      ixgbe: initialize interrupt throttle rate

Arnaud Ebalard (1):
      XFRM,IPv6: initialize ip6_dst_blackhole_ops.kmem_cachep

Balbir Singh (2):
      sched: fix process time monotonicity
      mm owner: fix race between swapoff and exit

Chuck Ebbert (2):
      x86-32: AMD c1e force timer broadcast late
      x86: add io delay quirk for Presario F700

Clemens Ladisch (1):
      ALSA: oxygen: fix distorted output on AK4396-based cards

David S. Miller (5):
      sparc64: Fix PCI error interrupt registry on PSYCHO.
      sparc64: Fix interrupt register calculations on Psycho and Sabre.
      sparc64: Fix OOPS in psycho_pcierr_intr_other().
      sparc64: Fix disappearing PCI devices on e3500.
      sparc64: Fix missing devices due to PCI bridge test in of_create_pci_dev().

David Winn (1):
      fbcon: fix monochrome color value calculation

FUJITA Tomonori (1):
      sg: disable interrupts inside sg_copy_buffer

Geoff Levand (1):
      USB: fix hcd interrupt disabling

Greg Kroah-Hartman (1):
      Linux 2.6.26.6

Herbert Xu (2):
      ipsec: Fix pskb_expand_head corruption in xfrm_state_check_space
      udp: Fix rcv socket locking

Ingo Molnar (1):
      rtc: fix deadlock

Ivo van Doorn (1):
      rt2x00: Use ieee80211_hw->workqueue again

Jan Beulich (1):
      x86-64: fix overlap of modules and fixmap areas

Jarod Wilson (1):
      S390: CVE-2008-1514: prevent ptrace padding area read/write in 31-bit mode

Jens Axboe (1):
      block: submit_bh() inadvertently discards barrier flag on a sync write

Joel Becker (1):
      ocfs2: Increment the reference count of an already-active stack.

Joerg Roedel (2):
      KVM: SVM: fix random segfaults with NPT enabled
      KVM: SVM: fix guest global tlb flushes with NPT

Kirill A. Shutemov (1):
      smb.h: do not include linux/time.h in userspace

Krzysztof Helt (1):
      x86: fdiv bug detection fix

Linus Torvalds (1):
      x86-64: Clean up save/restore_i387() usage

Maciej W. Rozycki (1):
      ntp: fix calculation of the next jiffie to trigger RTC sync

Marcin Slusarz (1):
      rtc: fix kernel panic on second use of SIGIO nofitication

Mel Gorman (1):
      mm: mark the correct zone as full when scanning zonelists

Mike Rapoport (1):
      pxa2xx_spi: fix build breakage

Milan Broz (1):
      ACPI: Fix thermal shutdowns

Ned Forrester (2):
      pxa2xx_spi: dma bugfixes
      pxa2xx_spi: chipselect bugfixes

Neil Horman (1):
      ipv6: Fix OOPS in ip6_dst_lookup_tail().

Nick Piggin (1):
      mm: dirty page tracking race fix

Pascal Terjan (1):
      braille_console: only register notifiers when the braille console is used

Pekka Paalanen (1):
      x86: fix SMP alternatives: use mutex instead of spinlock, text_poke is sleepable

Prarit Bhargava (1):
      x86: fix memmap=exactmap boot argument

Ravikiran Thirumalai (1):
      x86: Fix 27-rc crash on vsmp due to paravirt during module load

Risto Suominen (2):
      ALSA: snd-powermac: mixers for PowerMac G4 AGP
      ALSA: snd-powermac: HP detection for 1st iMac G3 SL

Santwona Behera (1):
      niu: panic on reset

Suresh Siddha (1):
      x64, fpu: fix possible FPU leakage in error conditions

Sven Wegener (1):
      i2c-dev: Return correct error code on class_create() failure

Takashi Iwai (3):
      ALSA: hda - Fix model for Dell Inspiron 1525
      ALSA: fix locking in snd_pcm_open*() and snd_rawmidi_open*()
      ALSA: remove unneeded power_mutex lock in snd_pcm_drop

Thomas Gleixner (9):
      clockevents: prevent endless loop in periodic broadcast handler
      clockevents: enforce reprogram in oneshot setup
      clockevents: prevent multiple init/shutdown
      clockevents: prevent endless loop lockup
      HPET: make minimum reprogramming delta useful
      clockevents: broadcast fixup possible waiters
      x86: HPET fix moronic 32/64bit thinko
      x86: HPET: read back compare register before reading counter
      clockevents: remove WARN_ON which was used to gather information

Timo Teras (1):
      af_key: Free dumping state on socket close

Vegard Nossum (1):
      netlink: fix overrun in attribute iteration

Venkatesh Pallipadi (2):
      x86: PAT proper tracking of set_memory_uc and friends
      clockevents: prevent clockevent event_handler ending up handler_noop

Vlad Yasevich (2):
      sctp: do not enable peer features if we can't do them.
      sctp: Fix oops when INIT-ACK indicates that peer doesn't support AUTH

Yinghai Lu (1):
      APIC routing fix

Yuri Tikhonov (1):
      async_tx: fix the bug in async_tx_run_dependencies

Zachary Amsden (1):
      x86: Fix broken LDT access in VMI

Zhao Yakui (1):
      ACPI: Avoid bogus EC timeout when EC is in Polling mode

