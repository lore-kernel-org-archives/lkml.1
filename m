Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbXBEQwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbXBEQwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbXBEQwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:52:39 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55620 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbXBEQwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:52:36 -0500
Date: Mon, 5 Feb 2007 08:59:12 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.19.3
Message-ID: <20070205165912.GO10475@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.19.3 kernel.
This one has a long list of assorted fixes.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.19.2 and 2.6.19.3, as it is small enough to do so.
                                                                                
The updated 2.6.19.y git tree can be found at:                                  
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.19.y.git 
and can be browsed at the normal kernel.org git web browser:                    
        www.kernel.org/git/                                                     

thanks,
-chris

--------

 Makefile                                     |    2 -
 arch/i386/kernel/vmlinux.lds.S               |    1 
 arch/sparc64/kernel/sun4v_tlb_miss.S         |    4 +-
 arch/um/Kconfig.i386                         |   34 +++++++++----------
 arch/um/sys-i386/signal.c                    |    3 +
 arch/um/sys-x86_64/signal.c                  |    5 +-
 arch/x86_64/kernel/vmlinux.lds.S             |    1 
 block/elevator.c                             |   11 +++---
 drivers/acpi/processor_perflib.c             |    4 --
 drivers/ata/libata-scsi.c                    |    4 +-
 drivers/char/hw_random/amd-rng.c             |    2 -
 drivers/char/hw_random/geode-rng.c           |    2 -
 drivers/char/hw_random/intel-rng.c           |    2 -
 drivers/char/hw_random/ixp4xx-rng.c          |    2 -
 drivers/char/hw_random/via-rng.c             |    2 -
 drivers/char/mem.c                           |    4 +-
 drivers/i2c/busses/i2c-mv64xxx.c             |    4 +-
 drivers/i2c/chips/m41t00.c                   |    1 
 drivers/ide/pci/jmicron.c                    |   17 +++++----
 drivers/ieee1394/sbp2.c                      |    2 +
 drivers/infiniband/hw/mthca/mthca_memfree.c  |    2 -
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    4 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   26 +++++++--------
 drivers/md/md.c                              |   45 ++++++++++++++++++++++----
 drivers/md/raid1.c                           |   21 +++++++++---
 drivers/md/raid10.c                          |   11 ++++--
 drivers/md/raid5.c                           |    3 +
 drivers/net/bonding/bonding.h                |    7 ++--
 drivers/net/sis190.c                         |    2 -
 drivers/pci/search.c                         |   18 ++++++++++
 drivers/rtc/rtc-sysfs.c                      |    2 -
 fs/cifs/file.c                               |   26 +++++++++++++--
 fs/nfsd/export.c                             |   12 +++++--
 fs/nfsd/nfs3xdr.c                            |    9 ++---
 fs/nfsd/nfs4xdr.c                            |    5 +-
 fs/nfsd/nfssvc.c                             |    8 ++--
 fs/nfsd/nfsxdr.c                             |    5 +-
 fs/nfsd/vfs.c                                |    7 ++--
 include/asm-sparc/checksum.h                 |    2 -
 include/linux/netfilter/nf_conntrack_tcp.h   |    2 -
 include/linux/netfilter_arp/arp_tables.h     |    1 
 include/linux/netfilter_ipv4/ip_tables.h     |    2 -
 include/linux/nfsd/nfsd.h                    |    4 --
 include/linux/nfsd/xdr.h                     |    4 +-
 include/linux/nfsd/xdr3.h                    |    8 ++--
 include/linux/raid/md.h                      |    2 -
 include/linux/sunrpc/clnt.h                  |    1 
 include/linux/sunrpc/svc.h                   |    5 ++
 init/main.c                                  |    5 ++
 kernel/exit.c                                |   29 ++++++++++-------
 kernel/sched.c                               |   35 +++++++++++---------
 mm/mmap.c                                    |    7 ++++
 mm/page_alloc.c                              |    3 +
 net/decnet/dn_dev.c                          |   11 +++++-
 net/ipv4/fib_trie.c                          |   34 +++++++++++++------
 net/ipv4/netfilter.c                         |    7 ++--
 net/ipv4/netfilter/ip_conntrack_netlink.c    |   10 +++--
 net/ipv4/tcp_input.c                         |   15 +++++---
 net/ipv4/tcp_output.c                        |    3 +
 net/ipv6/addrconf.c                          |    6 +++
 net/ipv6/mcast.c                             |    6 ---
 net/ipv6/netfilter/nf_conntrack_reasm.c      |    2 +
 net/netfilter/nf_conntrack_netlink.c         |   10 +++--
 net/netfilter/xt_connbytes.c                 |   29 +++++++----------
 net/packet/af_packet.c                       |   46 +++++++++++++--------------
 net/sunrpc/clnt.c                            |   26 ++++++++-------
 net/sunrpc/svc.c                             |    3 +
 net/sunrpc/svcsock.c                         |    2 +
 net/xfrm/xfrm_policy.c                       |   16 ++-------
 security/selinux/ss/mls.c                    |   12 ++++---
 sound/pci/hda/hda_generic.c                  |    5 +-
 sound/usb/usx2y/usbusx2yaudio.c              |    2 -
 sound/usb/usx2y/usx2yhwdeppcm.c              |    2 -
 73 files changed, 422 insertions(+), 255 deletions(-)

Summary of changes from v2.6.19.2 to v2.6.19.3
============================================

Adam Litke (1):
      Don't allow the stack to grow into hugetlb reserved regions

Andi Kleen (1):
      x86: Work around gcc 4.2 over aggressive optimizer

Andy Gospodarek (1):
      bonding: ARP monitoring broken on x86_64

Ard van Breemen (2):
      start_kernel: test if irq's got enabled early, barf, and disable them again
      PCI: prevent down_read when pci_devices is empty

Baruch Even (1):
      TCP: Fix sorting of SACK blocks.

Bob Breuer (1):
      SPARC32: Fix over-optimization by GCC near ip_fast_csum.

Chris Wright (1):
      Linux 2.6.19.3

Christoph Lameter (1):
      Check for populated zone in __drain_pages

David S. Miller (3):
      SPARC64: Set g4/g5 properly in sun4v dtlb-prot handling.
      AF_PACKET: Fix BPF handling.
      AF_PACKET: Check device down state before hard header callbacks.

Erez Zilber (1):
      IB/iser: return error code when PDUs may not be sent

Eric W. Biederman (3):
      Fix reparenting to the same thread group. (take 2)
      DECNET: Handle a failure in neigh_parms_alloc (take 2)
      IPV4: Fix the fib trie iterator to work with a single entry routing tables

ethanhsiao@jmicron.com (1):
      jmicron: 40/80pin primary detection

Francois Romieu (1):
      sis190: failure to set the MAC address from EEPROM

Herbert Xu (1):
      IPSEC: Policy list disorder

Ingo Molnar (2):
      ACPI: fix cpufreq regression
      sched: fix cond_resched_softirq() offset

Jarek Poplawski (1):
      TCP: rare bad TCP checksum with 2.6.19

Jeff Dike (2):
      Fix UML on non-standard VM split hosts
      uml: fix signal frame alignment

Jeff Garzik (1):
      libata: use kmap_atomic(KM_IRQ0) in SCSI simulator

Karsten Wiese (1):
      Repair snd-usb-usx2y over OHCI

Kirill Korotaev (1):
      move_task_off_dead_cpu() should be called with disabled ints

Lars Ellenberg (1):
      md: pass down BIO_RW_SYNC in raid{1,10}

Linas Vepstas (1):
      elevator: move clearing of unplug flag earlier

Linus Torvalds (2):
      Fix up CIFS for "test_clear_page_dirty()" removal
      Revert "Fix up mmap_kmem"

Masayuki Nakagawa (1):
      TCP: skb is unexpectedly freed.

Maxime Bizon (1):
      i2c-mv64xxx: Fix random oops at boot

Michael Buesch (1):
      Fix HWRNG built-in initcalls priority

Michael S. Tsirkin (1):
      IB/mthca: Fix off-by-one in FMR handling on memfree

Mike Frysinger (1):
      remove __devinit markings from rtc_sysfs_add_device()

Nathan Lynch (1):
      sched: tasks cannot run on cpus onlined after boot

NeilBrown (8):
      knfsd: fix setting of ACL server versions.
      knfsd: fix an NFSD bug with full sized, non-page-aligned reads.
      knfsd: fix type mismatch with filldir_t used by nfsd.
      knfsd: fix up some bit-rot in exp_export
      md: assorted md and raid1 one-liners
      md: make 'repair' actually work for raid1.
      md: fix a few problems with the interface (sysfs and ioctl) to md.
      md: fix potential memalloc deadlock in md

Pablo Neira Ayuso (1):
      NETFILTER: ctnetlink: check for status attribute existence on conntrack creation

Patrick McHardy (7):
      NETFILTER: Fix routing of REJECT target generated packets in output chain
      NETFILTER: nf_conntrack_ipv6: fix crash when handling fragments
      NETFILTER: tcp conntrack: fix IP_CT_TCP_FLAG_CLOSE_INIT value
      NETFILTER: arp_tables: fix userspace compilation
      NETFILTER: ctnetlink: fix leak in ctnetlink_create_conntrack error path
      NETFILTER: Fix iptables ABI breakage on (at least) CRIS
      NETFILTER: xt_connbytes: fix division by zero

Paul Moore (1):
      SELinux: fix an oops with NetLabel and non-MLS SELinux policy

Philippe De Muyter (1):
      i2c/m41t00: Do not forget to write year

Robert Olsson (1):
      IPV4: Fix single-entry /proc/net/fib_trie output.

Stefan Richter (1):
      ieee1394: sbp2: fix probing of some DVD-ROM/RWs

Takashi Iwai (1):
      ALSA hda-codec - Fix NULL dereference in generic hda code

Trond Myklebust (1):
      SUNRPC: Give cloned RPC clients their own rpc_pipefs directory

YOSHIFUJI Hideaki (1):
      IPV6 MCAST: Fix joining all-node multicast group on device initialization.
