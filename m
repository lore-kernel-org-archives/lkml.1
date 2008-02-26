Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbYBZBBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbYBZBBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 20:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYBZBBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 20:01:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:47400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYBZBBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 20:01:34 -0500
Date: Mon, 25 Feb 2008 17:00:24 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.24.3
Message-ID: <20080226010024.GA26889@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.24.3
kernel.

It fixes a number of different bugs and all users of the 2.6.24 series
are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.24.2 and 2.6.24.3

The updated 2.6.24.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                                  |    2 
 arch/powerpc/platforms/chrp/pci.c         |    4 -
 arch/powerpc/platforms/powermac/feature.c |   11 +++
 arch/s390/lib/uaccess_std.c               |    8 +-
 arch/sparc/lib/rwsem.S                    |    2 
 arch/sparc64/lib/rwsem.S                  |    2 
 arch/x86/mm/pageattr_64.c                 |    2 
 drivers/macintosh/smu.c                   |   25 +++++++
 drivers/net/bonding/bond_main.c           |   16 ++--
 drivers/net/dl2k.h                        |    4 -
 drivers/net/pcmcia/smc91c92_cs.c          |   12 +++
 drivers/scsi/gdth.c                       |    9 ++
 drivers/scsi/sd.c                         |   34 ++++------
 drivers/usb/class/usblp.c                 |    1 
 fs/inotify_user.c                         |    2 
 fs/nfs/write.c                            |   20 +++++-
 fs/xfs/linux-2.6/xfs_file.c               |    3 
 include/asm-powerpc/pmac_feature.h        |    8 ++
 include/linux/Kbuild                      |    1 
 include/linux/hrtimer.h                   |    2 
 include/linux/hugetlb.h                   |    1 
 include/linux/ktime.h                     |    2 
 kernel/audit.c                            |   10 ++-
 kernel/compat.c                           |   44 ++++++++++++-
 kernel/futex.c                            |    2 
 kernel/futex_compat.c                     |    2 
 kernel/hrtimer.c                          |  100 +++++++++++++++++-------------
 kernel/irq/chip.c                         |   20 +++++-
 kernel/posix-timers.c                     |   25 ++-----
 kernel/sysctl.c                           |    2 
 mm/hugetlb.c                              |   10 +++
 mm/memory.c                               |    2 
 mm/slub.c                                 |    3 
 net/bluetooth/hci_sysfs.c                 |   48 +++++++++++---
 net/ipv4/fib_hash.c                       |   47 +++++++++-----
 net/ipv4/fib_trie.c                       |   57 ++++++++++-------
 net/ipv4/inet_diag.c                      |   11 +--
 net/ipv4/ip_output.c                      |    4 -
 net/ipv4/ipcomp.c                         |    5 +
 net/ipv4/sysctl_net_ipv4.c                |    2 
 net/ipv4/xfrm4_tunnel.c                   |    2 
 net/ipv6/ip6_output.c                     |    4 -
 net/ipv6/ipcomp6.c                        |    5 +
 net/netfilter/nf_conntrack_proto_tcp.c    |   35 ++++++++--
 net/sched/em_meta.c                       |   10 +--
 net/sched/ematch.c                        |    5 -
 security/selinux/ss/services.c            |    1 
 47 files changed, 434 insertions(+), 193 deletions(-)

Summary of changes from v2.6.24.2 to v2.6.24.3
==============================================

Al Viro (1):
      Fix dl2k constants

Arnaldo Carvalho de Melo (1):
      INET_DIAG: Fix inet_diag_lock_handler error path.

Benjamin Herrenschmidt (1):
      Disable G5 NAP mode during SMU commands on U3

Boaz Harrosh (1):
      SCSI: gdth: scan for scsi devices

Christoph Lameter (1):
      SLUB: Deal with annoying gcc warning on kfree()

Chuck Ebbert (1):
      PCMCIA: Fix station address detection in smc

Dave Young (1):
      BLUETOOTH: Add conn add/del workqueues to avoid connection fail.

David Chinner (1):
      XFS: Fix oops in xfs_file_readdir()

David Miller (1):
      SPARC/SPARC64: Fix usage of .section .sched.text in assembler code.

Greg Kroah-Hartman (1):
      Linux 2.6.24.3

Heiko Carstens (1):
      S390: Fix futex_atomic_cmpxchg_std inline assembly.

Herbert Xu (4):
      IPCOMP: Fix reception of incompressible packets
      IPCOMP: Fetch nexthdr before ipch is destroyed
      INET: Prevent out-of-sync truesize on ip_fragment slow path
      AUDIT: Increase skb->truesize in audit_expand

Ingo Molnar (1):
      x86_64: CPA, fix cache attribute inconsistency bug

James Bottomley (1):
      SCSI: sd: handle bad lba in sense information

Jay Vosburgh (1):
      bonding: fix NULL pointer deref in startup processing

Jonathan Corbet (1):
      Be more robust about bad arguments in get_user_pages()

Jozsef Kadlecsik (1):
      NETFILTER: nf_conntrack_tcp: conntrack reopening fix

Julian Anastasov (2):
      IPV4: fib_trie: apply fixes from fib_hash
      IPV4: fib: fix route replacement, fib_info is shared

Nishanth Aravamudan (1):
      hugetlb: add locking for overcommit sysctl

Olaf Hering (1):
      POWERPC: Revert chrp_pci_fixup_vt8231_ata devinit to fix libata on pegasos

Oleg Nesterov (2):
      hrtimer: fix *rmtp handling in hrtimer_nanosleep()
      hrtimer: fix *rmtp/restarts handling in compat_sys_nanosleep()

Oliver Neukum (1):
      USB: fix pm counter leak in usblp

Paul Moore (1):
      SELinux: Fix double free in selinux_netlbl_sock_setsid()

Shan Wei (1):
      TCP: Fix a bug in strategy_allowed_congestion_control

Stephen Hemminger (3):
      TC: oops in em_meta
      PKT_SCHED: ematch: oops from uninitialized variable (resend)
      NET: Add if_addrlabel.h to sanitized headers.

Thomas Gleixner (3):
      hrtimer: check relative timeouts for overflow
      hrtimer: catch expired CLOCK_REALTIME timers early
      genirq: do not leave interupts enabled on free_irq

Trond Myklebust (1):
      NFS: Fix a potential file corruption issue when writing

Ulisses Furquim (1):
      inotify: fix check for one-shot watches before destroying them

