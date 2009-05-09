Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZEIUxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZEIUxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 16:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZEIUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 16:53:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47171
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbZEIUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 16:53:38 -0400
Date: Sat, 09 May 2009 13:53:34 -0700 (PDT)
Message-Id: <20090509.135334.107235922.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n49Kruqu025415


1) iwlwifi accidently exports static symbol, breaking the build for some

2) bluetooth does GFP_KERNEL allocation in atomic context via dev_set_name()

3) Fix IPVS regression added by ipv6 support

4) INET_LRO needs to be a bool rather than tristate in order to avoid
   build failure scenerios

5) skb_recycle_check() fails to initialize timestamp portions of
   SKB completely

6) If bonding fails to initialize we get a crash.

7) Two OOPS fixes in wimax driver.

8) Consumer index can get out of sync resulting in crash in
   bnx2_poll_work().

9) Netfilter cannot match packets ending in NETHDR_NONE properly.

10) IGB driver crashes on shutdown with SR-IOV enabled.

Please pull, thanks a lot!

The following changes since commit 091bf7624d1c90cec9e578a18529f615213ff847:
  Linus Torvalds (1):
        Linux 2.6.30-rc5

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alexander Duyck (1):
      igb: resolve panic on shutdown when SR-IOV is enabled

Andreas Schwab (1):
      iwlwifi: remove EXPORT_SYMBOL for static symbol

Ashish Karkare (1):
      net: remove stale reference to fastroute from Kconfig help text

Christoph Paasch (1):
      netfilter: ip6t_ipv6header: fix match on packets ending with NEXTHDR_NONE

David S. Miller (5):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-2.6
      Merge branch 'linux-2.6.30.y' of git://git.kernel.org/.../inaky/wimax
      ipv4: Make INET_LRO a bool instead of tristate.
      Merge branch 'net-fixes' of git://git.kernel.org/.../chris/linux-2.6

Florian Westphal (1):
      bonding: fix panic if initialization fails

Inaky Perez-Gonzalez (2):
      wimax: fix oops if netlink fails to add attribute
      wimax: oops: wimax_dev_add() is the only one that can initialize the state

Jiri Slaby (2):
      mac80211: minstrel, fix memory corruption
      mac80211: pid, fix memory corruption

Johannes Berg (2):
      mac80211: correct fragmentation threshold check
      cfg80211: fix truncated IEs

Krzysztof Ha≈Çasa (2):
      IXP4xx: use "ENODEV" instead of "ENOSYS" in module initialization. ENOSYS makes modutils complain about missing kernel module support.
      IXP4xx: complete Ethernet netdev setup before calling register_netdev().

Lennert Buytenhek (1):
      net: update skb_recycle_check() for hardware timestamping changes

Luis R. Rodriguez (3):
      cfg80211: fix race condition with wiphy_apply_custom_regulatory()
      cfg80211: fix bug while trying to process beacon hints on init
      cfg80211: fix comment on regulatory hint processing

Marcel Holtmann (1):
      Bluetooth: Move dev_set_name() to a context that can sleep

Michael Chan (1):
      bnx2: Fix panic in bnx2_poll_work().

Pablo Neira Ayuso (2):
      netfilter: xt_cluster: fix use of cluster match with 32 nodes
      netfilter: ctnetlink: fix wrong message type in user updates

Patrick McHardy (2):
      netfilter: add missing linux/types.h include to xt_LED.h
      net-sched: fix bfifo default limit

Reinette Chatre (1):
      iwlwifi: update key flags at time key is set

Simon Horman (1):
      ipvs: Fix IPv4 FWMARK virtual services

 arch/arm/mach-ixp4xx/ixp4xx_npe.c           |    2 +-
 drivers/net/arm/ixp4xx_eth.c                |   31 ++++++------
 drivers/net/bnx2.c                          |    6 ++-
 drivers/net/bonding/bond_main.c             |    8 ---
 drivers/net/igb/igb_main.c                  |   12 ++---
 drivers/net/wan/ixp4xx_hss.c                |    4 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   21 ++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 include/linux/netfilter/xt_LED.h            |    2 +
 include/linux/netfilter/xt_cluster.h        |    2 +
 net/Kconfig                                 |    6 --
 net/bluetooth/hci_sysfs.c                   |    7 +--
 net/core/skbuff.c                           |    2 +
 net/ipv4/Kconfig                            |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c        |    6 +-
 net/mac80211/rc80211_minstrel.c             |    2 +-
 net/mac80211/rc80211_pid_algo.c             |   73 ++++++++++++++------------
 net/mac80211/tx.c                           |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c             |    9 +++-
 net/netfilter/ipvs/ip_vs_core.c             |    4 +-
 net/netfilter/nf_conntrack_netlink.c        |   48 +++++++----------
 net/netfilter/xt_cluster.c                  |    8 +++-
 net/sched/sch_fifo.c                        |    2 +-
 net/wimax/op-msg.c                          |   11 ++--
 net/wimax/stack.c                           |   17 ++++++-
 net/wireless/reg.c                          |   17 ++++++-
 net/wireless/scan.c                         |    1 +
 27 files changed, 167 insertions(+), 139 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
