Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXDMU7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXDMU7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965641AbXDMU7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:59:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35173 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965635AbXDMU7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:59:33 -0400
Date: Fri, 13 Apr 2007 13:56:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.20.7
Message-ID: <20070413205659.GA5935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.7 kernel.
This release has a number of bugfixes and any user of the 2.6.20 kernel
series is encouraged to upgrade.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.20.6 and 2.6.20.7.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h

--------
 Makefile                                    |    2 
 arch/i386/lib/usercopy.c                    |    9 ++
 drivers/ata/ahci.c                          |   21 +++++-
 drivers/ata/libata-core.c                   |   14 +++-
 drivers/ata/libata-eh.c                     |   22 +++---
 drivers/ata/libata-scsi.c                   |    2 
 drivers/hid/hid-core.c                      |    2 
 drivers/ide/ide-io.c                        |   32 ++++++---
 drivers/ide/ide-iops.c                      |    3 
 drivers/md/bitmap.c                         |    4 -
 drivers/media/dvb/frontends/tda10086.c      |    2 
 drivers/media/dvb/pluto2/pluto2.c           |   22 ++++--
 drivers/net/8139too.c                       |   40 +++++------
 drivers/net/ifb.c                           |   35 +++-------
 drivers/net/skge.c                          |    1 
 drivers/net/sky2.c                          |   95 +++++++++++++++++++---------
 drivers/net/sky2.h                          |    1 
 drivers/scsi/scsi_error.c                   |    2 
 fs/binfmt_elf.c                             |    5 +
 fs/binfmt_elf_fdpic.c                       |    2 
 fs/ext3/inode.c                             |   85 ++-----------------------
 fs/ext4/inode.c                             |   85 ++-----------------------
 fs/nfsd/nfs3xdr.c                           |    6 -
 include/linux/ide.h                         |    1 
 include/linux/skbuff.h                      |    5 -
 include/net/pkt_cls.h                       |    7 +-
 net/core/dev.c                              |    8 +-
 net/core/skbuff.c                           |    2 
 net/ieee80211/softmac/ieee80211softmac_wx.c |    6 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c          |    2 
 net/ipv4/tcp_output.c                       |    6 +
 net/ipv6/raw.c                              |    4 -
 net/ipv6/udp.c                              |    2 
 net/sched/act_mirred.c                      |    2 
 net/sched/cls_tcindex.c                     |    4 -
 net/xfrm/xfrm_state.c                       |    3 
 scripts/basic/fixdep.c                      |   10 ++
 37 files changed, 261 insertions(+), 293 deletions(-)

Summary of changes from v2.6.20.6 to v2.6.20.7
==============================================

Adam Kropelin (1):
      HID: Do not discard truncated input reports

Albert Lee (1):
      libata: Clear tf before doing request sense (take 3)

Andreas Oberritter (2):
      DVB: tda10086: fix DiSEqC message length
      DVB: pluto2: fix incorrect TSCR register setting

Andrew Morton (2):
      revert "retries in ext3_prepare_write() violate ordering requirements"
      revert "retries in ext4_prepare_write() violate ordering requirements"

Brian Pomerantz (1):
      fix page leak during core dump

Chuck Ebbert (1):
      Update libata drive blacklist to the latest from 2.6.21

Conke Hu (1):
      ahci.c: walkaround for SB600 SATA internal error issue

David Miller (2):
      Fix scsi sense handling
      Fix TCP slow_start_after_idle sysctl

Francois Romieu (1):
      8139too: RTNL and flush_scheduled_work deadlock

Greg Kroah-Hartman (1):
      Linux 2.6.20.7

Herbert Xu (1):
      Fix IPSEC replay window handling

Jan Beulich (1):
      kbuild: fix dependency generation

John Heffner (1):
      Fix TCP receiver side SWS handling.

John W. Linville (1):
      softmac: avoid assert in ieee80211softmac_wx_get_rate

Mark Lord (2):
      libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK
      fix lba48 bug in libata fill_result_tf()

Neil Brown (2):
      Fix calculation for size of filemap_attr array in md/bitmap.
      knfsd: allow nfsd READDIR to return 64bit cookies

Patrick McHardy (3):
      NETFILTER: ipt_CLUSTERIP: fix oops in checkentry function
      Fix IFB net driver input device crashes
      Fix tcindex classifier ABI borkage...

Stephen Hemminger (5):
      sky2: reliable recovery
      skge: turn carrier off when down
      sky2: turn carrier off when down
      sky2: turn on clocks when doing resume
      sky2: phy workarounds for Yukon EC-U A1

Suleiman Souhlal (1):
      ide: use correct IDE error recovery

Thomas Gleixner (1):
      i386: fix file_read_actor() and pipe_read() for original i386 systems

YOSHIFUJI Hideaki (1):
      Fix length validation in rawv6_sendmsg()

