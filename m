Return-Path: <linux-kernel-owner+w=401wt.eu-S1761830AbYCXTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830AbYCXTQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbYCXTQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:16:11 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36883 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583AbYCXTQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:16:10 -0400
Date: Mon, 24 Mar 2008 12:15:46 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.24.4
Message-ID: <20080324191546.GK23462@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.24.4
kernel.

It fixes a large number of different bugs and all users of the 2.6.24 series
are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.24.3 and 2.6.24.4

The updated 2.6.24.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary

thanks,
-chris

--------

 Makefile                             |    2 
 arch/arm/mach-pxa/clock.c            |   23 ++-
 arch/mips/kernel/i8259.c             |    4 
 arch/mips/kernel/irq.c               |    5 
 arch/s390/lib/uaccess_pt.c           |    2 
 arch/sparc/kernel/Makefile           |    5 
 arch/sparc/kernel/una_asm.S          |  153 +++++++++++++++++++++
 arch/sparc/kernel/unaligned.c        |  252 ++++++-----------------------------
 arch/sparc64/mm/fault.c              |   14 -
 arch/x86/ia32/ia32_signal.c          |    4 
 arch/x86/kernel/apic_32.c            |    2 
 arch/x86/kernel/apic_64.c            |    2 
 arch/x86/kernel/io_apic_32.c         |    4 
 arch/x86/kernel/io_apic_64.c         |    6 
 arch/x86/kernel/process_64.c         |    3 
 arch/x86/kernel/signal_32.c          |    4 
 arch/x86/kernel/signal_64.c          |    2 
 arch/x86/kernel/smpboot_32.c         |    2 
 arch/x86/kernel/smpboot_64.c         |    2 
 arch/x86/pci/mmconfig-shared.c       |   35 ----
 arch/x86/pci/mmconfig_32.c           |   22 +--
 arch/x86/pci/mmconfig_64.c           |   22 +--
 arch/x86/pci/pci.h                   |    7 
 crypto/async_tx/async_xor.c          |    2 
 crypto/xcbc.c                        |    6 
 crypto/xts.c                         |   13 -
 drivers/acorn/char/defkeymap-l7200.c |   68 ++++-----
 drivers/ata/pata_hpt366.c            |    6 
 drivers/ata/pata_hpt37x.c            |    6 
 drivers/ata/pata_serverworks.c       |    2 
 drivers/base/platform.c              |    2 
 drivers/block/ub.c                   |    2 
 drivers/char/defkeymap.c_shipped     |   68 ++++-----
 drivers/char/vt.c                    |    1 
 drivers/dma/ioat_dma.c               |    2 
 drivers/message/fusion/mptsas.c      |    5 
 drivers/net/e1000e/netdev.c          |    6 
 drivers/net/macb.c                   |    2 
 drivers/net/niu.c                    |   20 +-
 drivers/net/niu.h                    |    2 
 drivers/net/wireless/b43/dma.c       |   32 +++-
 drivers/net/wireless/b43/main.c      |    3 
 drivers/s390/char/defkeymap.c        |    4 
 drivers/scsi/advansys.c              |   15 +-
 drivers/scsi/aic94xx/aic94xx_scb.c   |   14 +
 drivers/scsi/arcmsr/arcmsr_hba.c     |   20 +-
 drivers/scsi/gdth.c                  |  112 +++++----------
 drivers/scsi/gdth.h                  |    1 
 drivers/scsi/gdth_proc.c             |    6 
 drivers/scsi/ips.c                   |   20 +-
 drivers/scsi/scsi_lib.c              |    1 
 drivers/spi/atmel_spi.c              |   10 +
 drivers/spi/pxa2xx_spi.c             |   41 +++--
 drivers/usb/host/ehci-q.c            |    2 
 drivers/usb/serial/ftdi_sio.c        |   25 +++
 drivers/usb/serial/ftdi_sio.h        |    7 
 drivers/usb/storage/protocol.c       |    5 
 fs/aio.c                             |    8 +
 fs/ecryptfs/mmap.c                   |  102 ++++++++++----
 fs/fuse/dir.c                        |    2 
 fs/isofs/compress.c                  |   11 +
 fs/jbd/recovery.c                    |    2 
 fs/jbd2/recovery.c                   |    2 
 fs/nfsd/nfsfh.c                      |    4 
 fs/ufs/util.h                        |    2 
 include/asm-arm/arch-pxa/pxa-regs.h  |    1 
 include/asm-x86/apic_32.h            |    2 
 include/asm-x86/futex_32.h           |    6 
 include/asm-x86/futex_64.h           |    6 
 include/asm-x86/io_apic_64.h         |    2 
 include/asm-x86/processor_32.h       |    5 
 include/linux/Kbuild                 |    1 
 include/linux/futex.h                |    1 
 include/linux/irq.h                  |    3 
 include/linux/moduleparam.h          |   12 +
 include/net/inet_sock.h              |    3 
 kernel/futex.c                       |   50 +++++-
 kernel/futex_compat.c                |    9 +
 kernel/irq/chip.c                    |   36 +++++
 kernel/relay.c                       |    5 
 kernel/sched.c                       |   36 ++---
 kernel/sysctl.c                      |    2 
 mm/filemap.c                         |   22 +--
 mm/hugetlb.c                         |    2 
 mm/slab.c                            |    5 
 net/bluetooth/hci_sysfs.c            |    8 -
 net/bridge/netfilter/ebt_dnat.c      |    4 
 net/bridge/netfilter/ebt_redirect.c  |    4 
 net/bridge/netfilter/ebt_snat.c      |    4 
 net/core/dev.c                       |    6 
 net/ipv4/ip_sockglue.c               |    5 
 net/ipv4/ipcomp.c                    |    5 
 net/ipv4/ipconfig.c                  |    4 
 net/ipv4/netfilter/arpt_mangle.c     |    2 
 net/ipv4/netfilter/ip_queue.c        |   12 -
 net/ipv6/ip6_output.c                |    6 
 net/ipv6/ip6_tunnel.c                |    1 
 net/ipv6/ipcomp6.c                   |    2 
 net/ipv6/netfilter/ip6_queue.c       |   10 -
 net/ipv6/xfrm6_output.c              |    2 
 net/netfilter/nfnetlink_log.c        |    2 
 net/netfilter/nfnetlink_queue.c      |   12 -
 net/netfilter/xt_time.c              |    7 
 security/commoncap.c                 |    2 
 104 files changed, 877 insertions(+), 671 deletions(-)

Summary of changes from v2.6.24.3 to v2.6.24.4
==============================================

Alan Cox (1):
      pata_hpt*, pata_serverworks: fix UDMA masking

Alan Stern (1):
      usb-storage: don't access beyond the end of the sg buffer

Andy Whitcroft (1):
      hugetlb: ensure we do not reference a surplus page after handing it to buddy

Atsushi Nemoto (2):
      atmel_spi: fix clock polarity
      macb: Fix speed setting

Auke Kok (1):
      e1000e: Fix CRC stripping in hardware context bug

Aurelien Jarno (1):
      x86: Clear DF before calling signal handler

Boaz Harrosh (2):
      SCSI: gdth: bugfix for the at-exit problems
      SCSI: gdth: fix to internal commands execution

Chris Wright (1):
      Linux 2.6.24.4

Dan Williams (2):
      ioat: fix 'ack' handling, driver must ensure that 'ack' is zero
      async_tx: avoid the async xor_zero_sum path when src_cnt > device->max_xor

Dave Young (2):
      zisofs: fix readpage() outside i_size
      BLUETOOTH: Fix bugs in previous conn add/del workqueue changes.

David S. Miller (5):
      SPARC64: Loosen checks in exception table handling.
      SPARC: Fix link errors with gcc-4.3
      TCP: Improve ipv4 established hash function.
      NIU: Bump driver version and release date.
      IPV4: Remove IP_TOS setting privilege checks.

Denis V. Lunev (1):
      IPV6: dst_entry leak in ip4ip6_err.

Duane Griffin (2):
      jbd2: correctly unescape journal data blocks
      jbd: correctly unescape journal data blocks

Eric Leblond (2):
      NETFILTER: nfnetlink_queue: fix computation of allocated size for netlink skb
      NETFILTER: nfnetlink_log: fix computation of netlink skb size

FUJITA Tomonori (2):
      SCSI ips: fix data buffer accessors conversion bug
      SCSI advansys: fix overrun_buf aligned bug

Greg Kroah-Hartman (1):
      Revert "NET: Add if_addrlabel.h to sanitized headers."

H. Peter Anvin (1):
      x86: don't use P6_NOPs if compiling with CONFIG_X86_GENERIC

Heiko Carstens (1):
      S390 futex: let futex_atomic_cmpxchg_pt survive early functional tests.

Herbert Xu (2):
      IPV6: Fix IPsec datagram fragmentation
      IPCOMP: Disable BH on output when using shared tfm

Hiroshi Shimamoto (2):
      x86: move out tick_nohz_stop_sched_tick() call from the loop
      sched: fix race in schedule()

Ivan Kokshaysky (2):
      moduleparam: fix alpha, ia64 and ppc64 compile failures
      PCI x86: always use conf1 to access config space below 256 bytes

J. Bruce Fields (1):
      nfsd: fix oops on access from high-numbered ports

James Bottomley (3):
      drivers: fix dma_get_required_mask
      SCSI gdth: don't call pci_free_consistent under spinlock
      SCSI aic94xx: fix REQ_TASK_ABORT and REQ_DEVICE_RESET

Jan Beulich (1):
      x86: adjust enable_NMI_through_LVT0()

Jan Engelhardt (1):
      NETFILTER: xt_time: fix failure to match on Sundays

Jeff Garzik (1):
      SCSI ips: handle scsi_add_host() failure, and other err cleanups

Jens Axboe (1):
      relay: fix subbuf_splice_actor() adding too many pages

Joe Korty (1):
      slab: NUMA slab allocator migration bugfix

Jorge Boncompte [DTI2] (1):
      NET: Messed multicast lists after dev_mc_sync/unsync

Joy Latten (1):
      CRYPTO xcbc: Fix crash with IPsec

Kevin Vance (1):
      USB: ftdi_sio: Workaround for broken Matrix Orbital serial port

Krzysztof Oledzki (1):
      SCSI: mpt fusion: don't oops if NumPhys==0

Matheos Worku (2):
      NIU: More BMAC alt MAC address fixes.
      NIU: Fix BMAC alternate MAC address indexing.

Matthew Wilcox (1):
      SCSI advansys: Fix bug in AdvLoadMicrocode

Matti Linnanvuori (1):
      NET: Fix race in dev_close(). (Bug 9750)

Michael Buesch (1):
      b43: Backport bcm4311 fix

Michael Halcrow (1):
      eCryptfs: make ecryptfs_prepare_write decrypt the page

Michal Schmidt (1):
      sched_nr_migrate wrong mode bits

Mike Pagano (1):
      arcmsr: fix IRQs disabled warning spew

Miklos Szeredi (1):
      fuse: fix permission checking

Misha Zhilin (1):
      USB: ehci: handle large bulk URBs correctly (again)

Ned Forrester (1):
      spi: pxa2xx_spi clock polarity fix

Nick Piggin (1):
      iov_iter_advance() fix

Patrick McHardy (3):
      NETFILTER: nfnetlink_queue: fix SKB_LINEAR_ASSERT when mangling packet data
      NETFILTER: Fix incorrect use of skb_make_writable
      NETFILTER: fix ebtable targets return

Pete Zaitcev (1):
      ub: fix up the conversion to sg_init_table()

Quentin Barnes (1):
      aio: bad AIO race in aio_complete() leads to process hang

Ralf Baechle (2):
      IRQ_NOPROBE helper functions
      MIPS: Mark all but i8259 interrupts as no-probe.

Roel Kluin (1):
      ufs: fix parenthesisation in ufs_set_fs_state()

Russell King (1):
      ARM pxa: fix clock lookup to find specific device clocks

Samuel Thibault (2):
      VT notifier fix for VT switch
      Fix default compose table initialization

Sebastian Siewior (1):
      CRYPTO xts: Use proper alignment

Serge E. Hallyn (1):
      file capabilities: simplify signal check

Stephen Hemminger (1):
      IPCONFIG: The kernel gets no IP from some DHCP servers

Sven Andersen (1):
      USB: ftdi_sio - really enable EM1010PC

Thomas Gleixner (3):
      x86: replace LOCK_PREFIX in futex.h
      futex: fix init order
      futex: runtime enable pi and robust functionality

Tony Battersby (1):
      SCSI: fix BUG when sum(scatterlist) > bufflen
