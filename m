Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbXFKUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbXFKUKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbXFKUKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:10:11 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55713 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXFKUKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:10:10 -0400
Date: Mon, 11 Jun 2007 13:09:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.20.14
Message-ID: <20070611200950.GY3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.14 kernel.
This has a variety of important fixes, see below for the summary.
This is likely to be the last one in the 2.6.20-stable stream.

I'll also be replying to this message with a copy of the patch between
2.6.20.13 and 2.6.20.14

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git;a=summary

thanks,
-chris

---------

 Makefile                                              |    2 
 arch/arm/mach-iop13xx/pci.c                           |    8 -
 arch/sparc64/kernel/head.S                            |   29 +++-
 arch/sparc64/kernel/itlb_miss.S                       |    4 
 arch/sparc64/kernel/pci_sun4v.c                       |   36 +----
 arch/sparc64/mm/init.c                                |    7 
 arch/x86_64/mm/pageattr.c                             |    2 
 crypto/api.c                                          |    4 
 drivers/acpi/thermal.c                                |    3 
 drivers/ata/sata_via.c                                |    8 +
 drivers/base/core.c                                   |    7 
 drivers/input/serio/i8042.c                           |   35 ++++
 drivers/media/dvb/ttpci/budget-ci.c                   |    2 
 drivers/net/smc911x.c                                 |    2 
 drivers/serial/suncore.c                              |    6 
 fs/fuse/dir.c                                         |    2 
 fs/jfs/jfs_logmgr.c                                   |    3 
 fs/ntfs/inode.c                                       |    2 
 include/asm-arm/arch-iop13xx/iop13xx.h                |   22 +--
 include/asm-s390/checksum.h                           |   59 ++------
 include/asm-sparc64/tsb.h                             |    2 
 include/linux/mii.h                                   |    4 
 include/linux/netfilter/nf_conntrack_proto_gre.h      |   18 --
 include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h |   19 --
 include/net/af_unix.h                                 |    8 -
 mm/oom_kill.c                                         |    2 
 mm/rmap.c                                             |    4 
 net/core/dev.c                                        |   10 -
 net/core/net-sysfs.c                                  |    8 -
 net/core/sock.c                                       |   14 +
 net/core/utils.c                                      |    6 
 net/ipv4/Kconfig                                      |    6 
 net/ipv4/icmp.c                                       |   12 +
 net/ipv4/inet_connection_sock.c                       |    4 
 net/ipv4/netfilter/ip_nat_proto_gre.c                 |   20 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c                 |   20 +-
 net/ipv4/tcp.c                                        |    3 
 net/ipv4/xfrm4_input.c                                |    6 
 net/ipv4/xfrm4_mode_tunnel.c                          |    2 
 net/ipv6/addrconf.c                                   |    6 
 net/ipv6/ip6_fib.c                                    |    8 -
 net/ipv6/proc.c                                       |    1 
 net/ipv6/xfrm6_input.c                                |    6 
 net/ipv6/xfrm6_mode_tunnel.c                          |    1 
 net/unix/af_unix.c                                    |  127 +++++++++++-------
 scripts/basic/fixdep.c                                |    2 
 sound/usb/usbquirks.h                                 |   23 +++
 47 files changed, 315 insertions(+), 270 deletions(-)

Summary of changes from v2.6.20.13 to v2.6.20.14
================================================

Andi Kleen (1):
      x86-64: Always flush all pages in change_page_attr

Andrew Morton (2):
      acpi-thermal: fix mod_timer() interval
      ntfs_init_locked_inode(): fix array indexing

Andy Green (1):
      kbuild: fixdep segfault on pathological string-o-death

Chris Wright (1):
      Linux 2.6.20.14

Dan Williams (1):
      iop13xx: fix i/o address translation

Daniel Drake (1):
      ALSA: usb-audio: explicitly match Logitech QuickCam

Dave Jones (1):
      IPV4: Correct rp_filter help text.

Dave Kleikamp (1):
      JFS: Fix race waking up jfsIO kernel thread

David Miller (6):
      ICMP: Fix icmp_errors_use_inbound_ifaddr sysctl
      NET: Fix BMSR_100{HALF,FULL}2 defines in linux/mii.h
      SPARC64: Fix two bugs wrt. kernel 4MB TSB.
      SPARC64: Fix _PAGE_EXEC_4U check in sun4u I-TLB miss handler.
      Fix AF_UNIX OOPS
      SPARC64: Don't be picky about virtual-dma values on sun4v.

David Rientjes (1):
      oom: kill all threads that share mm with killed task

Heiko Carstens (1):
      s390: Fix TCP/UDP pseudo header checksum computation.

Herbert Xu (1):
      CRYPTO: api: Read module pointer before freeing algorithm

Jan Engelhardt (1):
      SPARC: Linux always started with 9600 8N1

Jerome Borsboom (1):
      NET: parse ip:port strings correctly in in4_pton

Jorge Boncompte (1):
      {ip, nf}_nat_proto_gre: do not modify/corrupt GREv0 packets through NAT

Kazunori MIYAZAWA (1):
      IPSEC: Fix panic when using inter address familiy IPsec on loopback.

Mark Glines (1):
      TCP: Use default 32768-61000 outgoing port range in all cases.

Martin Schwidefsky (1):
      s390: page_mkclean data corruption.

Miklos Szeredi (1):
      fuse: fix mknod of regular file

Oliver Endriss (1):
      V4L/DVB (5593): Budget-ci: Fix tuning for TDM 1316 (160..200 MHz)

Roland Scheidegger (1):
      Input: i8042 - fix AUX port detection with some chips

Stephen Hemminger (2):
      pv6: track device renames in snmp6
      NET: Fix race condition about network device name allocation.

Tejun Heo (2):
      sata_via: add missing PM hooks
      driver-core: don't free devt_attr till the device is released

Vasily Averin (1):
      NET: "wrong timeout value" in sk_wait_data() v2

Vitaly Wool (1):
      smc911x: fix compilation breakage wjen debug is on

YOSHIFUJI Hideaki (1):
      IPV6 ROUTE: No longer handle ::/0 specially.

