Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYIHOiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYIHOiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbYIHOhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:37:36 -0400
Received: from mail.suse.de ([195.135.220.2]:50252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYIHOhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:37:33 -0400
Date: Mon, 8 Sep 2008 07:36:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.26.4
Message-ID: <20080908143625.GC7311@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.26.4
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.26
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.26.3 and 2.6.26.4

The updated 2.6.26.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 
 arch/sparc64/mm/init.c             |   30 ++++++++---
 arch/x86/kernel/cpu/cyrix.c        |   18 ------
 arch/x86/kernel/cpu/mtrr/generic.c |   20 ++++++-
 arch/x86/kvm/paging_tmpl.h         |    2 
 crypto/authenc.c                   |   10 ++-
 drivers/ata/sata_mv.c              |   34 +++----------
 drivers/char/random.c              |   19 +++----
 drivers/misc/eeepc-laptop.c        |    2 
 drivers/net/atlx/atl1.c            |    1 
 drivers/net/forcedeth.c            |    4 -
 drivers/net/r8169.c                |    2 
 drivers/net/tg3.c                  |   53 ++++++++++++++------
 drivers/net/tg3.h                  |    3 +
 drivers/pci/search.c               |    2 
 drivers/rtc/rtc-lib.c              |    5 +
 drivers/s390/block/dasd_eckd.h     |    2 
 drivers/serial/8250.c              |   16 ++++--
 drivers/serial/8250.h              |    1 
 drivers/usb/class/cdc-acm.c        |    2 
 drivers/video/fb_defio.c           |   19 +++++++
 drivers/video/fbmem.c              |    4 +
 fs/binfmt_misc.c                   |    4 -
 fs/bio.c                           |   48 ++++++++++++------
 fs/cifs/file.c                     |    4 +
 fs/cramfs/inode.c                  |   84 ++++++++++++++------------------
 fs/nfsd/nfs4acl.c                  |    2 
 include/linux/Kbuild               |    1 
 include/linux/fb.h                 |    3 +
 include/linux/mroute.h             |   25 ++++++++-
 include/linux/pim.h                |   45 -----------------
 include/net/addrconf.h             |    3 -
 include/net/ip6_route.h            |    1 
 mm/page_alloc.c                    |    7 ++
 net/ax25/sysctl_net_ax25.c         |   14 +----
 net/ipv4/udp.c                     |    6 +-
 net/ipv6/addrconf.c                |    3 -
 net/ipv6/fib6_rules.c              |    3 -
 net/ipv6/ip6_fib.c                 |    1 
 net/ipv6/ip6_output.c              |    2 
 net/ipv6/ndisc.c                   |    2 
 net/ipv6/route.c                   |   13 +++--
 net/ipv6/udp.c                     |    6 +-
 net/ipv6/xfrm6_policy.c            |    4 +
 net/sched/act_api.c                |    5 -
 net/sched/sch_htb.c                |   20 ++++---
 net/sched/sch_prio.c               |   16 ++++--
 net/sched/sch_tbf.c                |   11 ----
 net/sctp/auth.c                    |    7 ++
 net/sctp/endpointola.c             |    4 -
 net/sctp/ipv6.c                    |    3 -
 net/sctp/socket.c                  |   96 ++++++++++++++++++++++++++++---------
 net/sunrpc/sysctl.c                |   18 +-----
 net/xfrm/xfrm_state.c              |   32 ++++++++----
 sound/pci/oxygen/oxygen_mixer.c    |    5 +
 55 files changed, 438 insertions(+), 311 deletions(-)

Adam Litke (1):
      mm: make setup_zone_migrate_reserve() aware of overlapping nodes

Al Viro (1):
      cramfs: fix named-pipe handling

Alexey Dobriyan (1):
      USB: cdc-acm: don't unlock acm->mutex on error path

Andrew Morton (1):
      drivers/char/random.c: fix a race which can lead to a bogus BUG()

Avi Kivity (1):
      KVM: MMU: Fix torn shadow pte

Ayaz Abdulla (1):
      forcedeth: fix checksum flag

Brian Haley (2):
      ipv6: Fix OOPS, ip -f inet6 route get fec0::1, linux-2.6.26, ip6_route_output, rt6_fill_node+0x175
      netns: Add network namespace argument to rt6_fill_node() and ipv6_dev_get_saddr()

Clemens Ladisch (1):
      ALSA: oxygen: prevent muting of nonexistent AC97 controls

Cyrill Gorcunov (1):
      sunrpc: fix possible overrun on read of /proc/sys/sunrpc/transports

David S. Miller (5):
      pkt_sched: Fix return value corruption in HTB and TBF.
      net: Unbreak userspace which includes linux/mroute.h
      ipsec: Fix deadlock in xfrm_state management.
      sparc64: Fix overshoot in nid_range().
      sparc64: Fix cmdline_memory_size handling bugs.

FUJITA Tomonori (2):
      bio: fix __bio_copy_iov() handling of bio->bv_len
      bio: fix bio_copy_kern() handling of bio->bv_len

Francois Romieu (1):
      r8169: balance pci_map / pci_unmap pair

Greg Kroah-Hartman (2):
      PCI: fix reference leak in pci_get_dev_by_id()
      Linux 2.6.26.4

Herbert Xu (2):
      udp: Drop socket lock for encapsulated packets
      crypto: authenc - Avoid using clobbered request pointer

Ian Campbell (1):
      fbdefio: add set_page_dirty handler to deferred IO FB

Ingo Molnar (1):
      x86: work around MTRR mask setting, v2

J. Bruce Fields (1):
      nfsd: fix buffer overrun decoding NFSv4 acl

Jamal Hadi Salim (1):
      pkt_sched: Fix actions referencing

Jan Altenberg (1):
      rtc_time_to_tm: fix signed/unsigned arithmetic

Jay Cliburn (1):
      atl1: disable TSO by default

Jeff Layton (1):
      cifs: fix O_APPEND on directio mounts

Matt Carlson (1):
      tg3: Fix firmware event timeouts

Matthew Garrett (1):
      eeepc-laptop: fix use after free

Pavel Emelyanov (1):
      binfmt_misc: fix false -ENOEXEC when coupled with other binary handlers

Ralf Baechle (1):
      AX.25: Fix sysctl registration if !CONFIG_AX25_DAMA_SLAVE

Samuel Sieb (1):
      x86: fix "kernel won't boot on a Cyrix MediaGXm (Geode)"

Stefan Weinhuber (1):
      S390 dasd: fix data size for PSF/PRSSD command

Tejun Heo (1):
      sata_mv: don't issue two DMA commands concurrently

Thomas Graf (1):
      sch_prio: Fix nla_parse_nested_compat() regression

Vlad Yasevich (4):
      sctp: fix potential panics in the SCTP-AUTH API.
      sctp: add verification checks to SCTP_AUTH_KEY option
      sctp: correct bounds check in sctp_setsockopt_auth_key
      sctp: fix random memory dereference with SCTP_HMAC_IDENT option.

Will Newton (1):
      8250: improve workaround for UARTs that don't re-assert THRE correctly

Yinghai Lu (1):
      x86: work around MTRR mask setting

