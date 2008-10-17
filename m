Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYJQF3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYJQF3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 01:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYJQF3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 01:29:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50847
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYJQF3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 01:29:42 -0400
Date: Thu, 16 Oct 2008 22:29:19 -0700 (PDT)
Message-Id: <20081016.222919.85169421.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081016.222852.55969909.davem@davemloft.net>
References: <20081016.222852.55969909.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, finger slipped, here is the real content :-)

1) A few networking driver fixes via Jeff Garzik.  The Kconfig
   fixup for myri10ge and ixgbe should fix the powerpc allyesconfig
   et al. build failures.

2) Missing rcu_assign() in ipv4 routing cache, from Eric Dumazet.

3) Getting rid of CONFIG_KMOD under net/, from Johannes Berg and
   Rusty.

I'll get a fix to you for that netfilter build failure BenH reported
soon.

Please pull, thanks a lot.

The following changes since commit 8fa0b315fc0c1a414da1371f1fc39523a657c192:
  David S. Miller (1):
        decnet: Fix compiler warning in dn_dev.c

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alan Cox (2):
      lmc: copy_*_user under spinlock
      [netdrvr] ibmtr: PCMCIA IBMTR is ok on 64bit

Eric Dumazet (1):
      ipv4: Add a missing rcu_assign_pointer() in routing cache.

Isaku Yamahata (1):
      xen-netfront: Avoid unaligned accesses to IP header

Jeff Garzik (1):
      [netdrvr] myri10ge, ixgbe: remove broken select INTEL_IOATDMA

Johannes Berg (1):
      net: Remove CONFIG_KMOD from net/ (towards removing CONFIG_KMOD entirely)

 drivers/net/Kconfig                  |   12 ++++++++++--
 drivers/net/ixgbe/ixgbe.h            |    4 ++--
 drivers/net/ixgbe/ixgbe_main.c       |   32 ++++++++++++++++----------------
 drivers/net/myri10ge/myri10ge.c      |   26 +++++++++++++-------------
 drivers/net/pcmcia/Kconfig           |    2 +-
 drivers/net/wan/lmc/lmc_main.c       |   31 ++++++++++++++++++++++++-------
 drivers/net/xen-netfront.c           |    5 ++++-
 net/bluetooth/af_bluetooth.c         |    8 +-------
 net/bridge/netfilter/ebtables.c      |   15 +++------------
 net/can/af_can.c                     |    4 ++--
 net/core/dev.c                       |    2 --
 net/core/rtnetlink.c                 |    4 ++--
 net/dccp/ccid.c                      |    2 +-
 net/decnet/dn_dev.c                  |    2 --
 net/ipv4/devinet.c                   |    2 --
 net/ipv4/inet_diag.c                 |    2 --
 net/ipv4/route.c                     |    7 ++++++-
 net/ipv4/tcp_cong.c                  |    4 ++--
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 net/netfilter/nfnetlink.c            |    2 +-
 net/netlink/af_netlink.c             |    2 +-
 net/phonet/af_phonet.c               |    3 +--
 net/sched/act_api.c                  |    2 +-
 net/sched/cls_api.c                  |    2 +-
 net/sched/ematch.c                   |    2 +-
 net/sched/sch_api.c                  |    2 +-
 net/socket.c                         |    2 +-
 net/sunrpc/auth.c                    |    2 --
 28 files changed, 96 insertions(+), 89 deletions(-)
