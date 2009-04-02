Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbZDBXQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbZDBXQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbZDBXQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:16:26 -0400
Received: from sous-sol.org ([216.99.217.87]:47618 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755168AbZDBXQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:16:25 -0400
Date: Thu, 2 Apr 2009 16:13:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.29.1
Message-ID: <20090402231335.GI18394@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.29.1 kernel.

There's many bugfixes all over the tree, but this should specifically
fix the networking issues people had w/ 2.6.29.  As usual, you're
encouraged to upgrade.  For details see the changelog and diffstat
below.

I'll be replying to this message with a copy of the patch between
2.6.29 and 2.6.29.1.

The updated 2.6.26.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.29.y.git
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=summary

thanks,
-chris

---------

 Makefile                                 |    2 -
 arch/arm/include/asm/elf.h               |    1 
 arch/arm/kernel/module.c                 |    9 +++++
 arch/arm/mach-iop13xx/pci.c              |    5 ++-
 arch/arm/mach-omap2/mmc-twl4030.c        |    1 
 arch/arm/mm/mmu.c                        |    2 -
 arch/sparc/include/asm/tlb_64.h          |    4 +-
 arch/sparc/kernel/nmi.c                  |   23 +++++++++++++
 arch/sparc/kernel/smp_64.c               |    4 +-
 arch/x86/kernel/check.c                  |    6 +--
 arch/x86/kernel/cpu/mtrr/generic.c       |   51 ++++++++++++++++++-------------
 arch/x86/kernel/ptrace.c                 |    3 -
 arch/x86/kernel/tlb_uv.c                 |    3 +
 arch/x86/kvm/paging_tmpl.h               |    2 -
 arch/x86/kvm/svm.c                       |   41 +++++++++++++++++-------
 arch/x86/kvm/vmx.c                       |    2 -
 arch/x86/lguest/boot.c                   |   10 +++++-
 arch/x86/mm/pat.c                        |    5 +--
 arch/x86/pci/i386.c                      |    3 +
 drivers/char/raw.c                       |    1 
 drivers/lguest/page_tables.c             |    4 +-
 drivers/media/dvb/firewire/firedtv-avc.c |    6 +++
 drivers/media/video/v4l2-common.c        |    8 ++--
 drivers/net/dnet.c                       |    1 
 drivers/net/wireless/ath5k/base.c        |   22 +++++++++----
 drivers/net/wireless/ath5k/base.h        |    2 -
 drivers/net/wireless/ath9k/recv.c        |    7 +++-
 drivers/net/wireless/ath9k/xmit.c        |    2 -
 drivers/net/wireless/b43/xmit.c          |    2 -
 drivers/scsi/arm/cumana_2.c              |    2 -
 drivers/usb/core/message.c               |    3 +
 drivers/usb/core/quirks.c                |    4 ++
 drivers/usb/core/sysfs.c                 |    4 +-
 drivers/usb/gadget/f_rndis.c             |    2 -
 drivers/usb/host/ehci-q.c                |   32 +++++++++++++++++++
 drivers/usb/host/ehci.h                  |    3 +
 drivers/usb/storage/cypress_atacb.c      |   15 ++++-----
 drivers/usb/storage/scsiglue.c           |    6 +++
 drivers/video/pxafb.c                    |   14 ++++++++
 fs/cifs/CHANGES                          |    3 +
 fs/cifs/cifssmb.c                        |    6 ++-
 fs/cifs/connect.c                        |    2 -
 fs/fuse/file.c                           |    3 +
 include/linux/mm.h                       |   15 +++++++--
 include/linux/usb/quirks.h               |    3 +
 mm/memory.c                              |    6 ++-
 net/bridge/br_if.c                       |    1 
 net/core/dev.c                           |    9 +----
 net/ipv4/udp.c                           |    6 +++
 net/ipv6/ip6_input.c                     |    4 --
 net/netfilter/nf_conntrack_proto_tcp.c   |    3 +
 net/wireless/reg.c                       |   23 ++++++++++---
 net/xfrm/xfrm_state.c                    |    2 -
 53 files changed, 296 insertions(+), 107 deletions(-)

Alan Cox (3):
      ARM: cumana: Fix a long standing bogon
      ARM: fix leak in iop13xx/pci
      ARM: twl4030 - leak fix

Alan Stern (3):
      USB: EHCI: add software retry for transaction errors
      USB: usb-storage: increase max_sectors for tape drives
      USB: add quirk to avoid config and interface strings

Andre Przywara (1):
      KVM: SVM: set accessed bit for VMCB segment selectors

Andreas Herrmann (1):
      x86: mtrr: don't modify RdDram/WrDram bits of fixed MTRRs

Avi Kivity (1):
      KVM: VMX: Don't allow uninhibited access to EFER on i386

Beat Michel Liechti (1):
      DVB: firedtv: FireDTV S2 problems with tuning solved

Boaz Harrosh (1):
      USB: fix USB_STORAGE_CYPRESS_ATACB

Bob Copeland (3):
      ath5k: use spin_lock_irqsave for beacon lock
      ath5k: disable MIB interrupts
      ath5k: warn and correct rate for unknown hw rate indexes

Chris Wright (1):
      Linux 2.6.29.1

Chuck Ebbert (1):
      xfrm: spin_lock() should be spin_unlock() in xfrm_state.c

Dan Carpenter (2):
      fuse: fix fuse_file_lseek returning with lock held
      Add a missing unlock_kernel() in raw_open()

Daniel Silverstone (1):
      ARM: 5428/1: Module relocation update for R_ARM_V4BX

David Brownell (1):
      USB: gadget: fix rndis regression

David S. Miller (3):
      sparc64: Fix MM refcount check in smp_flush_tlb_pending().
      sparc64: Flush TLB before releasing pages.
      sparc64: Fix reset hangs on Niagara systems.

Eric Miao (1):
      ARM: pxa: fix overlay being un-necessarily initialized on pxa25x

Geert Uytterhoeven (1):
      dnet: drivers/net/dnet.c needs <linux/io.h>

Hans Verkuil (1):
      V4L: v4l2-common: remove incorrect MODULE test

Herbert Xu (1):
      GRO: Disable GRO on legacy netif_rx path

Jeff Layton (1):
      cifs: fix buffer format byte on NT Rename/hardlink

Jesper Nilsson (1):
      ipv6: Plug sk_buff leak in ipv6_rcv (net/ipv6/ip6_input.c)

Joerg Roedel (1):
      KVM: MMU: Fix another largepage memory leak

Lorenzo Nava (1):
      b43: fix b43_plcp_get_bitrate_idx_ofdm return type

Luis R. Rodriguez (4):
      ath9k: downgrade xmit queue full message to xmit debug
      ath9k: fix dma mapping leak of rx buffer upon rmmod
      cfg80211: force last_request to be set for OLD_REG if regdom is EU
      cfg80211: fix incorrect assumption on last_request for 11d

Mark H. Weaver (1):
      netfilter: nf_conntrack_tcp: fix unaligned memory access in tcp_sack

Mikael Pettersson (1):
      ARM: 5435/1: fix compile warning in sanity_check_meminfo()

Pallipadi, Venkatesh (2):
      x86, PAT, PCI: Change vma prot in pci_mmap to reflect inherited prot
      VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff

Rusty Russell (3):
      x86, uv: fix cpumask iterator in uv_bau_init()
      lguest: wire up pte_update/pte_update_defer
      lguest: fix spurious BUG_ON() on invalid guest stack.

Stephen Hemminger (1):
      bridge: bad error handling when adding invalid ether address

Steve French (1):
      CIFS: Fix memory overwrite when saving nativeFileSystem field during mount

Vitaly Mayatskikh (1):
      udp: Wrong locking code in udp seq_file infrastructure

Yinghai Lu (1):
      x86: fix 64k corruption-check

xiyou.wangcong@gmail.com (1):
      x86: ptrace, bts: fix an unreachable statement

