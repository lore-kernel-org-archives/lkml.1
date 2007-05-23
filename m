Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbXEWWOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbXEWWOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbXEWWNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:13:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36892 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756540AbXEWWNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:13:53 -0400
Date: Wed, 23 May 2007 15:12:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.21.2
Message-ID: <20070523221224.GU3429@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.21.2 kernel.
This release has a large number of bugfixes in many areas.

I'll also be replying to this message with a copy of the patch between
2.6.21.1 and 2.6.21.2

The updated 2.6.21.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=summary

thanks,
-chris

--------

 Makefile                                              |    2 
 arch/arm/kernel/traps.c                               |    5 
 arch/arm/mach-iop13xx/pci.c                           |    8 
 arch/arm/plat-iop/time.c                              |    8 
 arch/i386/kernel/cpu/cpufreq/powernow-k7.c            |   36 ++-
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c            |    2 
 arch/i386/kernel/cpu/cpufreq/powernow-k8.h            |    4 
 arch/sparc64/kernel/of_device.c                       |    7 
 arch/sparc64/kernel/prom.c                            |   19 +
 arch/sparc64/kernel/smp.c                             |    3 
 arch/x86_64/kernel/vsyscall.c                         |    2 
 crypto/api.c                                          |    4 
 drivers/acpi/tables/tbfadt.c                          |   14 +
 drivers/ata/libata-sff.c                              |   35 ++-
 drivers/ata/sata_via.c                                |    8 
 drivers/base/core.c                                   |    7 
 drivers/char/ipmi/ipmi_si_intf.c                      |    4 
 drivers/md/raid1.c                                    |   33 +-
 drivers/message/fusion/mptspi.c                       |    8 
 drivers/net/Kconfig                                   |    5 
 drivers/net/bnx2.c                                    |   15 -
 drivers/net/sis900.c                                  |    9 
 drivers/net/skge.c                                    |   22 +
 drivers/net/sky2.c                                    |   15 -
 drivers/net/smc911x.c                                 |    2 
 drivers/net/tg3.c                                     |   48 ++--
 drivers/pci/quirks.c                                  |   16 -
 drivers/serial/sunhv.c                                |    4 
 drivers/usb/atm/cxacru.c                              |   40 +++
 drivers/usb/input/hiddev.c                            |   14 +
 fs/fat/dir.c                                          |  199 +++++++++---------
 fs/jfs/jfs_logmgr.c                                   |    3 
 fs/nfsd/export.c                                      |   14 -
 fs/reiserfs/xattr.c                                   |    2 
 fs/udf/namei.c                                        |    2 
 include/asm-arm/arch-iop13xx/iop13xx.h                |   22 +
 include/asm-sparc64/openprom.h                        |    2 
 include/linux/clocksource.h                           |    3 
 include/linux/netdevice.h                             |    8 
 include/linux/netfilter/nf_conntrack_proto_gre.h      |   18 -
 include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h |   19 -
 kernel/time/clocksource.c                             |   45 ++++
 kernel/time/tick-common.c                             |    8 
 kernel/time/tick-internal.h                           |    1 
 kernel/time/tick-sched.c                              |   42 +++
 kernel/timer.c                                        |    2 
 lib/zlib_inflate/inflate.c                            |    8 
 mm/hugetlb.c                                          |    2 
 mm/oom_kill.c                                         |   10 
 mm/slob.c                                             |   15 -
 net/ipv4/netfilter/ip_conntrack_core.c                |   10 
 net/ipv4/netfilter/ip_nat_proto_gre.c                 |   20 -
 net/ipv4/netfilter/nf_nat_proto_gre.c                 |   20 -
 net/ipv4/tcp.c                                        |    3 
 net/ipv6/addrconf.c                                   |   10 
 net/ipv6/exthdrs.c                                    |   16 +
 net/ipv6/ip6_input.c                                  |    2 
 net/ipv6/ip6_output.c                                 |   13 -
 net/ipv6/proc.c                                       |    1 
 net/ipv6/xfrm6_tunnel.c                               |    2 
 net/netfilter/nf_conntrack_core.c                     |    8 
 net/sched/sch_prio.c                                  |    2 
 net/sctp/socket.c                                     |  111 ++++++----
 net/sunrpc/auth_gss/svcauth_gss.c                     |    8 
 net/xfrm/xfrm_policy.c                                |    4 
 scripts/basic/fixdep.c                                |    2 
 sound/pci/hda/patch_sigmatel.c                        |    1 
 67 files changed, 661 insertions(+), 396 deletions(-)

Summary of changes from v2.6.21.1 to v2.6.21.2
============================================

Akinobu Mita (1):
      slob: fix page order calculation on not 4KB page

Alan Cox (1):
      libata-sff: Undo bug introduced with pci_iomap changes

Andy Green (1):
      kbuild: fixdep segfault on pathological string-o-death

Chris Wright (1):
      Linux 2.6.21.2

Corey Minyard (1):
      IPMI: fix SI address space settings

Corey Mutter (1):
      IPV6: Reverse sense of promisc tests in ip6_mc_input

Dan Williams (3):
      iop: fix iop_getttimeoffset
      iop13xx: fix i/o address translation
      arm: fix handling of svc mode undefined instructions

Daniel Drake (1):
      CPUFREQ: powernow-k7: fix MHz rounding issue with perflib

Dave Jones (2):
      CPUFREQ: Support rev H AMD64s in powernow-k8
      CPUFREQ: Correct revision mask for powernow-k8

Dave Kleikamp (1):
      JFS: Fix race waking up jfsIO kernel thread

David L Stevens (1):
      IPV6: Send ICMPv6 error on scope violations.

David Miller (5):
      SPARC64: Add missing cpus_empty() check in hypervisor xcall handling.
      SPARC64: Fix recursion in PROM tree building.
      SERIAL SUNHV: Add an ID string.
      SPARC64: Bump PROMINTR_MAX to 32.
      SPARC64: Be more resiliant with PCI I/O space regs.

David Rientjes (1):
      oom: fix constraint deadlock

Doug Chapman (1):
      fix for bugzilla 8426: massive slowdown on SCSI CD/DVD drive connected to mptspi driver

Eric Dumazet (1):
      x86_64 : Fix vgettimeofday()

Eric Sesterhenn (1):
      IPV6: Fix slab corruption running ip6sic

Herbert Xu (2):
      IPSEC: Check validity of direction in xfrm_policy_byid
      CRYPTO: api: Read module pointer before freeing algorithm

Jamal Hadi Salim (1):
      NET_SCHED: prio qdisc boundary condition

Jeff Mahoney (1):
      reiserfs: suppress lockdep warning

Jiri Kosina (1):
      USB HID: hiddev - fix race between hiddev_send_event() and hiddev_release()

Jorge Boncompte (1):
      NETFILTER: {ip,nf}_nat_proto_gre: do not modify/corrupt GREv0 packets through NAT

Ken Chen (1):
      fix leaky resv_huge_pages when cpuset is in use

Len Brown (1):
      ACPI: Fix 2.6.21 boot regression on P4/HT

Michael Chan (7):
      TG3: Fix TSO bugs.
      TG3: Remove reset during MAC address changes.
      TG3: Update version and reldate.
      BNX2: Fix TSO problem with small MSS.
      BNX2: Block MII access when ifdown.
      BNX2: Save PCI state during suspend.
      BNX2: Update version and reldate.

Neil Horman (1):
      sis900: Allocate rx replacement buffer before rx operation

NeilBrown (3):
      knfsd: Avoid use of unitialised variables on error path when nfs exports.
      knfsd: rpc: fix server-side wrapping of krb5i replies
      md: Avoid a possibility that a read error can wrongly propagate through md/raid1 to a filesystem.

OGAWA Hirofumi (1):
      fat: fix VFAT compat ioctls on 64-bit systems

Patrick McHardy (1):
      NETFILTER: {ip,nf}_conntrack: fix use-after-free in helper destroy callback invocation

Richard Purdie (1):
      ppp: Fix ppp_deflate issues with recent zlib_inflate changes

Sergei Shtylyov (2):
      NETPOLL: Fix TX queue overflow in trapped mode.
      NETPOLL: Remove CONFIG_NETPOLL_RX

Simon Arlott (1):
      cxacru: Fix infinite loop when trying to cancel polling task

Srinivas Aji (1):
      TCP: zero out rx_opt in tcp_disconnect()

Stephen Hemminger (7):
      ipv6: track device renames in snmp6
      skge: default WOL should be magic only (rev2)
      skge: allow WOL except for known broken chips
      sky2: allow 88E8056
      sky2: 88e8071 support not ready
      skge: crash on shutdown/suspend
      sky2: fix oops on shutdown

Stephen Mollett (1):
      udf: decrement correct link count in udf_rmdir

Takashi Iwai (1):
      ALSA: hda-codec - Fix resume of STAC92xx codecs

Tejun Heo (3):
      sata_via: add missing PM hooks
      driver-core: don't free devt_attr till the device is released
      pci-quirks: disable MSI on RS400-200 and RS480

Thomas Gleixner (2):
      highres/dyntick: prevent xtime lock contention
      clocksource: fix resume logic

Vitaly Wool (1):
      smc911x: fix compilation breakage wjen debug is on

Vlad Yasevich (3):
      SCTP: Fix sctp_getsockopt_local_addrs_old() to use local storage.
      SCTP: Correctly copy addresses in sctp_copy_laddrs
      SCTP: Prevent OOPS if hmac modules didn't load

YOSHIFUJI Hideaki (2):
      IPV6: Do no rely on skb->dst before it is assigned.
      IPV6 ROUTE: Assign rt6i_idev for ip6_{prohibit,blk_hole}_entry.

