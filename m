Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbZFLDQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbZFLDQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbZFLDQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:16:06 -0400
Received: from kroah.org ([198.145.64.141]:33139 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbZFLDQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:16:05 -0400
Date: Thu, 11 Jun 2009 20:10:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.27.25
Message-ID: <20090612031022.GA18057@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.25 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.27.24 and 2.6.27.25

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/ext4.txt    |    5 +
 Makefile                              |    2 
 arch/sparc/include/asm/pil.h          |    1 
 arch/sparc/include/asm/tlb_64.h       |    4 -
 arch/sparc/kernel/of_device.c         |   21 ++++++
 arch/sparc64/kernel/irq.c             |   29 ++++++---
 arch/sparc64/kernel/kgdb.c            |    2 
 arch/sparc64/kernel/of_device.c       |   21 ++++++
 arch/sparc64/kernel/pci_common.c      |    2 
 arch/sparc64/kernel/smp.c             |    8 +-
 arch/sparc64/kernel/ttable.S          |    8 ++
 arch/sparc64/mm/ultra.S               |   24 -------
 arch/x86/kernel/setup.c               |    5 -
 arch/x86/mm/hugetlbpage.c             |    6 +
 arch/x86/mm/pageattr.c                |   11 +++
 arch/x86/pci/mmconfig-shared.c        |    6 -
 drivers/acpi/processor_idle.c         |    8 ++
 drivers/char/random.c                 |   19 +++---
 drivers/char/tpm/tpm_bios.c           |    3 
 drivers/hwmon/lm78.c                  |    2 
 drivers/media/video/cx88/cx88-input.c |   25 ++------
 drivers/net/bnx2.c                    |    2 
 drivers/net/bonding/bond_alb.c        |    8 --
 drivers/net/e1000/e1000_main.c        |    5 -
 drivers/net/igb/igb_ethtool.c         |    4 +
 drivers/net/macvlan.c                 |    3 
 drivers/net/myri10ge/myri10ge.c       |    1 
 drivers/scsi/3w-xxxx.c                |    5 -
 drivers/scsi/3w-xxxx.h                |    2 
 drivers/serial/icom.c                 |    2 
 drivers/serial/mpc52xx_uart.c         |    2 
 drivers/usb/host/isp1760-hcd.c        |   24 +++++++
 fs/ext4/ext4.h                        |   28 +++++++++
 fs/ext4/extents.c                     |   25 +++++---
 fs/ext4/file.c                        |    7 +-
 fs/ext4/ialloc.c                      |   31 +++++-----
 fs/ext4/inode.c                       |  105 ++++++++++++++++++++++++++++++++--
 fs/ext4/ioctl.c                       |   17 ++++-
 fs/ext4/mballoc.c                     |   17 +++--
 fs/ext4/namei.c                       |   17 ++++-
 fs/jbd2/revoke.c                      |   24 ++++++-
 fs/nfs/dir.c                          |    3 
 mm/hugetlb.c                          |   26 ++++----
 net/core/pktgen.c                     |    2 
 net/core/skbuff.c                     |    2 
 net/ipv4/tcp_input.c                  |    3 
 net/mac80211/rc80211_pid_algo.c       |   71 ++++++++++++----------
 security/selinux/hooks.c              |    2 
 sound/usb/usbaudio.c                  |    2 
 sound/usb/usbaudio.h                  |    2 
 sound/usb/usbmidi.c                   |   12 +++
 sound/usb/usbquirks.h                 |    2 
 52 files changed, 474 insertions(+), 194 deletions(-)

Adam Radford (1):
      3w-xxxx: scsi_dma_unmap fix

Aneesh Kumar K.V (4):
      ext4: Fix discard of inode prealloc space with delayed allocation.
      ext4: Fix sub-block zeroing for writes into preallocated extents
      ext4: Use a fake block number for delayed new buffer_head
      ext4: Clear the unwritten buffer_head flag after the extent is initialized

Breno Leitao (1):
      icom: fix rmmod crash

Brian Maly (1):
      x86: fix DMI on EFI

Bryan Donlan (1):
      ext4: return -EIO not -ESTALE on directory traversal through deleted inode

Chuck Ebbert (1):
      ext4: really print the find_group_flex fallback warning only once

Clemens Ladisch (1):
      sound: usb-audio: make the MotU Fastlane work again

Dan Carpenter (1):
      ext4: fix typo which causes a memory leak on error path

David S. Miller (6):
      sparc64: Fix smp_callin() locking.
      sparc: Fix bus type probing for ESP and LE devices.
      sparc64: Fix MM refcount check in smp_flush_tlb_pending().
      sparc64: Flush TLB before releasing pages.
      sparc64: Fix lost interrupts on sun4u.
      sparc64: Reschedule KGDB capture to a software interrupt.

Duane Griffin (2):
      ext4: don't inherit inappropriate inode flags from parent
      ext4: tighten restrictions on inode flags

Eric Paris (2):
      TPM: get_event_name stack corruption
      SELinux: BUG in SELinux compat_net code

Eric Sandeen (4):
      ext4: fix ext4_free_inode() vs. ext4_claim_inode() race
      ext4: fix header check in ext4_ext_search_right() for deep extent trees.
      ext4: fix bogus BUG_ONs in in mballoc code
      ext4: fix bb_prealloc_list corruption due to wrong group locking

Florian Westphal (1):
      pktgen: do not access flows[] beyond its length

Frank Filz (1):
      nfs: Fix NFS v4 client handling of MAY_EXEC in nfs_permission.

Greg Kroah-Hartman (1):
      Linux 2.6.27.25

Ilpo Järvinen (1):
      tcp: fix >2 iw selection

Ingo Molnar (1):
      x86: work around Fedora-11 x86-32 kernel failures on Intel Atom CPUs

Jan Kara (1):
      jbd2: Update locking coments

Jay Vosburgh (1):
      bonding: fix alb mode locking regression

Jean Delvare (1):
      V4L/DVB (10943): cx88: Prevent general protection fault on rmmod

Jeff Kirsher (1):
      igb: fix LRO warning

Jiri Slaby (1):
      mac80211: pid, fix memory corruption

Linus Torvalds (2):
      random: make get_random_int() more random
      Avoid ICE in get_random_int() with gcc-3.4.5

Mel Gorman (2):
      mm: account for MAP_SHARED mappings using VM_MAYSHARE and not VM_SHARED in hugetlbfs
      x86: ignore VM_LOCKED when determining if hugetlb-backed page tables can be shared or not

Michael Chan (1):
      bnx2: Fix panic in bnx2_poll_work().

Mike Frysinger (1):
      hwmon: (lm78) Add missing __devexit_p()

Mikulas Patocka (1):
      sparc64: Fix crash with /proc/iomem

Neil Horman (1):
      e1000: add missing length check to e1000 receive routine

Patrick McHardy (1):
      vlan/macvlan: fix NULL pointer dereferences in ethtool handlers

Roel Kluin (1):
      drivers/serial/mpc52xx_uart.c: fix array overindexing check

Shaohua Li (2):
      cpuidle: fix AMD C1E suspend hang
      cpuidle: make AMC C1E work in processor_idle

Stanislaw Gruszka (1):
      myr10ge: again fix lro_gen_skb() alignment

Theodore Ts'o (10):
      ext4: Print the find_group_flex() warning only once
      ext4: Add fine print for the 32000 subdirectory limit
      ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
      ext4: Automatically allocate delay allocated blocks on close
      ext4: Automatically allocate delay allocated blocks on rename
      ext4: Check for an valid i_mode when reading the inode from disk
      ext4: fix locking typo in mballoc which could cause soft lockup hangs
      ext4: Fix softlockup caused by illegal i_file_acl value in on-disk inode
      ext4: Ignore i_file_acl_high unless EXT4_FEATURE_INCOMPAT_64BIT is present
      ext4: Fix race in ext4_inode_info.i_cached_extent

Thomas Chenault (1):
      net: fix skb_seq_read returning wrong offset/length for page frag data

Warren Free (1):
      USB: isp1760: urb_dequeue doesn't always find the urbs

Yinghai Lu (1):
      x86/pci: fix mmconfig detection with 32bit near 4g

