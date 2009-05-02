Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbZEBUGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbZEBUGp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761724AbZEBUFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:05:40 -0400
Received: from kroah.org ([198.145.64.141]:49710 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759243AbZEBUFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:05:35 -0400
Date: Sat, 2 May 2009 13:04:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.28.10
Message-ID: <20090502200413.GA7287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.28.10 kernel.

It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
series are strongly encouraged to upgrade.  Especially due to the CVE
issues that are fixed here.

NOTE, this is the LAST update of the 2.6.28 kernel series, so all users
are very strongly encouraged to upgrade to the 2.6.29 series at this
point in time!

I'll also be replying to this message with a copy of the patch between
2.6.28.9 and 2.6.28.10

The updated 2.6.28.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 
 arch/powerpc/include/asm/futex.h       |   12 
 arch/powerpc/include/asm/processor.h   |   19 +
 arch/powerpc/kernel/signal.c           |    4 
 arch/powerpc/kernel/signal.h           |    2 
 arch/powerpc/kernel/signal_32.c        |    4 
 arch/powerpc/kernel/signal_64.c        |    2 
 arch/x86/boot/memory.c                 |    7 
 arch/x86/include/asm/kvm_host.h        |   10 
 arch/x86/kernel/cpu/mtrr/generic.c     |   51 ++-
 arch/x86/kvm/i8254.c                   |    2 
 arch/x86/kvm/irq.c                     |    7 
 arch/x86/kvm/irq.h                     |    1 
 arch/x86/kvm/lapic.c                   |   66 +---
 arch/x86/kvm/lapic.h                   |    2 
 arch/x86/kvm/mmu.c                     |   24 +
 arch/x86/kvm/paging_tmpl.h             |    8 
 arch/x86/kvm/svm.c                     |   17 +
 arch/x86/kvm/vmx.c                     |    7 
 arch/x86/kvm/vmx.h                     |    5 
 arch/x86/kvm/x86.c                     |   14 
 arch/x86/kvm/x86_emulate.c             |    2 
 arch/x86/pci/i386.c                    |    3 
 block/genhd.c                          |   12 
 drivers/acpi/dock.c                    |    3 
 drivers/ata/pata_hpt37x.c              |   22 -
 drivers/char/agp/generic.c             |    4 
 drivers/char/raw.c                     |    1 
 drivers/crypto/ixp4xx_crypto.c         |  182 ++++--------
 drivers/ide/hpt366.c                   |    4 
 drivers/input/gameport/gameport.c      |   14 
 drivers/isdn/gigaset/bas-gigaset.c     |   16 -
 drivers/md/md.c                        |   27 +
 drivers/misc/thinkpad_acpi.c           |   41 +-
 drivers/net/b44.c                      |    2 
 drivers/net/bonding/bond_main.c        |   25 +
 drivers/net/bonding/bonding.h          |    6 
 drivers/net/r8169.c                    |    5 
 drivers/net/wireless/ath9k/ath9k.h     |    4 
 drivers/net/wireless/ath9k/core.c      |    1 
 drivers/net/wireless/ath9k/core.h      |   33 ++
 drivers/net/wireless/ath9k/hw.c        |   22 +
 drivers/net/wireless/b43/xmit.c        |    2 
 drivers/scsi/libiscsi.c                |    9 
 drivers/scsi/sg.c                      |  466 +++++++++++++++------------------
 drivers/spi/spi.c                      |   22 -
 drivers/usb/class/cdc-wdm.c            |    2 
 drivers/usb/core/message.c             |    3 
 drivers/usb/core/quirks.c              |    4 
 drivers/usb/core/sysfs.c               |    4 
 drivers/usb/gadget/f_rndis.c           |    2 
 drivers/usb/gadget/u_ether.c           |    8 
 drivers/usb/host/ehci-q.c              |   32 ++
 drivers/usb/host/ehci.h                |    3 
 drivers/usb/serial/ftdi_sio.c          |    1 
 drivers/usb/serial/ftdi_sio.h          |    7 
 drivers/usb/storage/cypress_atacb.c    |   15 -
 drivers/usb/storage/scsiglue.c         |    6 
 drivers/usb/storage/unusual_devs.h     |    6 
 fs/anon_inodes.c                       |    7 
 fs/buffer.c                            |    2 
 fs/cifs/CHANGES                        |    3 
 fs/cifs/cifssmb.c                      |    6 
 fs/cifs/connect.c                      |    2 
 fs/compat.c                            |   12 
 fs/dquot.c                             |    2 
 fs/drop_caches.c                       |    2 
 fs/exec.c                              |    4 
 fs/fs-writeback.c                      |    3 
 fs/hugetlbfs/inode.c                   |    3 
 fs/ocfs2/file.c                        |    8 
 fs/proc/base.c                         |   50 +--
 fs/splice.c                            |   25 +
 include/linux/capability.h             |   23 +
 include/linux/genhd.h                  |    1 
 include/linux/kvm.h                    |    2 
 include/linux/pagemap.h                |   12 
 include/linux/pci_regs.h               |    2 
 include/linux/raid/md_k.h              |    2 
 include/linux/sched.h                  |    3 
 include/linux/usb/quirks.h             |    3 
 kernel/exit.c                          |    3 
 kernel/kprobes.c                       |    4 
 kernel/posix-cpu-timers.c              |    7 
 kernel/sched.c                         |   65 ++++
 kernel/signal.c                        |    8 
 mm/filemap_xip.c                       |    4 
 mm/mmap.c                              |    2 
 net/bridge/br_if.c                     |    1 
 net/ipv4/netfilter/arp_tables.c        |    4 
 net/ipv4/netfilter/ip_tables.c         |    4 
 net/ipv6/inet6_hashtables.c            |    4 
 net/ipv6/ip6_input.c                   |    4 
 net/ipv6/netfilter/ip6_tables.c        |    4 
 net/netfilter/nf_conntrack_proto_tcp.c |    3 
 net/netrom/af_netrom.c                 |    8 
 net/rose/af_rose.c                     |    4 
 net/sctp/endpointola.c                 |    3 
 net/x25/af_x25.c                       |    6 
 net/xfrm/xfrm_state.c                  |    2 
 security/selinux/hooks.c               |    1 
 security/smack/smack_lsm.c             |    4 
 sound/pci/hda/patch_analog.c           |    2 
 virt/kvm/kvm_main.c                    |   41 ++
 virt/kvm/kvm_trace.c                   |    1 
 105 files changed, 952 insertions(+), 701 deletions(-)

Akinobu Mita (2):
      ALSA: hda - add missing comma in ad1884_slave_vols
      hugetlbfs: return negative error code for bad mount option

Al Viro (1):
      net: fix sctp breakage

Alan Cox (1):
      af_rose/x25: Sanity check the maximum user frame size

Alan Stern (4):
      USB: EHCI: add software retry for transaction errors
      USB: usb-storage: increase max_sectors for tape drives
      USB: add quirk to avoid config and interface strings
      USB: usb-storage: augment unusual_devs entry for Simple Tech/Datafab

Amit Shah (3):
      KVM: SVM: Set the 'g' bit of the cs selector for cross-vendor migration
      KVM: SVM: Set the 'busy' flag of the TR selector
      KVM: x86 emulator: Fix handling of VMMCALL instruction

Ananth N Mavinakayanahalli (1):
      kprobes: Fix locking imbalance in kretprobes

Andreas Herrmann (1):
      x86: mtrr: don't modify RdDram/WrDram bits of fixed MTRRs

Avi Kivity (2):
      KVM: Advertise the bug in memory region destruction as fixed
      KVM: VMX: Flush volatile msrs before emulating rdmsr

Boaz Harrosh (1):
      USB: fix USB_STORAGE_CYPRESS_ATACB

Christian Borntraeger (2):
      anon_inodes: use fops->owner for module refcount
      KVM: set owner of cpu and vm file operations

Christian Hohnstaedt (1):
      crypto: ixp4xx - Fix handling of chained sg buffers

Chuck Ebbert (1):
      xfrm: spin_lock() should be spin_unlock() in xfrm_state.c

Dan Carpenter (2):
      Add a missing unlock_kernel() in raw_open()
      dock: fix dereference after kfree()

Dan Williams (1):
      md: fix deadlock when stopping arrays

David Brownell (2):
      USB: gadget: fix rndis regression
      spi: spi_write_then_read() bugfixes

Dmitry Torokhov (1):
      Input: gameport - fix attach driver code

Etienne Basset (1):
      security/smack: fix oops when setting a size 0 SMACK64 xattr

Eugene Teo (1):
      unreached code in selinux_ip_postroute_iptables_compat() (CVE-2009-1184)

FUJITA Tomonori (1):
      SCSI: sg: avoid blk_put_request/blk_rq_unmap_user in interrupt

Francois Romieu (1):
      r8169: Reset IntrStatus after chip reset

Glauber Costa (1):
      KVM: Really remove a slot when a user ask us so

Gleb Natapov (1):
      KVM: call kvm_arch_vcpu_reset() instead of the kvm_x86_ops callback

Greg Kroah-Hartman (1):
      Linux 2.6.28.10

Henrique de Moraes Holschuh (1):
      thinkpad-acpi: fix LED blinking through timer trigger

Hidetoshi Seto (1):
      posixtimers, sched: Fix posix clock monotonicity

Hugh Dickins (2):
      mm: pass correct mm when growing stack
      fs core fixes

Izik Eidus (1):
      KVM: MMU: Fix aliased gfns treated as unaliased

Jan Kiszka (1):
      KVM: x86: Reset pending/inject NMI state on CPU reset

Jay Vosburgh (1):
      bonding: Fix updating of speed/duplex changes

Jean Delvare (3):
      net/netrom: Fix socket locking
      SCSI: libiscsi: fix iscsi pool error path
      SCSI: libiscsi: fix iscsi pool error path again

Jeff Layton (1):
      cifs: fix buffer format byte on NT Rename/hardlink

Jens Axboe (1):
      block: revert part of 18ce3751ccd488c78d3827e9f6bf54e6322676fb

Jesper Nilsson (1):
      ipv6: Plug sk_buff leak in ipv6_rcv (net/ipv6/ip6_input.c)

Jonathan McDowell (1):
      usb gadget: fix ethernet link reports to ethtool

Josh Boyer (1):
      powerpc: Sanitize stack pointer in signal handling code

Lee Schermerhorn (1):
      mm: define a UNIQUE value for AS_UNEVICTABLE flag

Lorenzo Nava (1):
      b43: fix b43_plcp_get_bitrate_idx_ofdm return type

Luis R. Rodriguez (2):
      ath9k: implement IO serialization
      ath9k: AR9280 PCI devices must serialize IO as well

Marcelo Tosatti (6):
      KVM: MMU: check for present pdptr shadow page in walk_shadow
      KVM: MMU: handle large host sptes on invlpg/resync
      KVM: mmu_notifiers release method
      KVM: PIT: fix i8254 pending count read
      KVM: x86: disable kvmclock on non constant TSC hosts
      KVM: x86: fix LAPIC pending count calculation

Mark H. Weaver (1):
      netfilter: nf_conntrack_tcp: fix unaligned memory access in tcp_sack

Martin Schwidefsky (1):
      mm: do_xip_mapping_read: fix length calculation

Michael Buesch (1):
      b44: Use kernel DMA addresses for the kernel DMA API

Michael K. Johnson (1):
      x86, setup: mark %esi as clobbered in E820 BIOS call

Miklos Szeredi (2):
      splice: fix deadlock in splicing to file
      fix ptrace slowness

Nathan Lynch (1):
      sched: do not count frozen tasks toward load

Nitin A Kamble (2):
      KVM: Fix cpuid leaf 0xb loop termination
      KVM: Fix cpuid iteration on multiple leaves per eac

Oleg Nesterov (1):
      exit_notify: kill the wrong capable(CAP_KILL) check (CVE-2009-1337)

Oliver Neukum (1):
      USB: fix oops in cdc-wdm in case of malformed descriptors

Patrick McHardy (1):
      netfilter: {ip, ip6, arp}_tables: fix incorrect loop detection

Paul Mackerras (1):
      powerpc: Fix data-corrupting bug in __futex_atomic_op

Pavel Emelyanov (1):
      ipv6: don't use tw net when accounting for recycled tw

Peter Korsgaard (1):
      USB: ftdi_sio: add vendor/project id for JETI specbos 1201 spectrometer

Serge E. Hallyn (1):
      add some long-missing capabilities to fs_mask

Sergei Shtylyov (2):
      hpt366: fix HPT370 DMA timeouts
      pata_hpt37x: fix HPT370 DMA timeouts

Shaohua Li (1):
      agp: zero pages before sending to userspace

Sheng Yang (2):
      KVM: MMU: Extend kvm_mmu_page->slot_bitmap size
      KVM: VMX: Move private memory slot position

Stephen Hemminger (1):
      bridge: bad error handling when adding invalid ether address

Steve French (1):
      CIFS: Fix memory overwrite when saving nativeFileSystem field during mount

Tejun Heo (1):
      block: include empty disks in /proc/diskstats

Tilman Schmidt (1):
      bas_gigaset: correctly allocate USB interrupt transfer buffer

Tony Battersby (2):
      SCSI: sg: fix races during device removal
      SCSI: sg: fix races with ioctl(SG_IO)

Venkatesh Pallipadi (1):
      x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot

Wu Fengguang (2):
      vfs: skip I_CLEAR state inodes
      KVM: Prevent trace call into unloaded module text

Yu Zhao (1):
      PCI: fix incorrect mask of PM No_Soft_Reset bit

