Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYKBHwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYKBHwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 02:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYKBHwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 02:52:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38223
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbYKBHwI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 02:52:08 -0500
Date: Sun, 02 Nov 2008 00:51:43 -0700 (PDT)
Message-Id: <20081102.005143.162603957.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


More fixes, as usual it's mostly in the drivers, but there
are a few network stack and netfilter cures in here.

Highlights:

1) UDP multicast socket lookup doesn't handle namespaces
   correctly.  From Eric Dumazet.

2) AF_UNIX namespace instantiation always returns zero
   instead of proper error codes.  Fix from Jianjun Kong.

3) IPSEC can leak ESRCH into userspace socket calls, in situations
   where that is not appropriate.  From fernando@oss.ntt.co

4) bonding OOPS'er fix from Andy Gospodarek.

5) IPSEC policy setting regression fix from Alexey Dobriyan.

Please pull, thanks a lot!

The following changes since commit 721d5dfe7e516954c501d5e9d0dfab379cf4241a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://neil.brown.name/md

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alexander Beregalov (1):
      IRDA: remove double inclusion of module.h

Alexey Dobriyan (3):
      netns: add register_pernet_gen_subsys/unregister_pernet_gen_subsys
      netfilter: nf_conntrack_proto_gre: switch to register_pernet_gen_subsys()
      key: fix setkey(8) policy set breakage

Andy Gospodarek (1):
      bonding: fix panic when taking bond interface down before removing module

Bob Copeland (3):
      ath5k: correct misspelling in debug help
      ath5k: honor FIF_BCN_PRBRESP_PROMISC in STA mode
      ath5k: add self to MAINTAINERS

Brice Goglin (1):
      myri10ge: fix stop/go mmio ordering

Chunbo Luo (1):
      amd8111e: fix dma_free_coherent context

David Brownell (1):
      at91_ether: request/free GPIO for PHY interrupt

David S. Miller (5):
      pppoe: Fix socket leak.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'davem-fixes' of master.kernel.org:/.../jgarzik/netdev-2.6
      Merge branch 'master' of git://git.infradead.org/users/pcmoore/lblnet-2.6
      net: Really remove all of LOOPBACK_TSO code.

Elias Oltmanns (1):
      ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular

Eric Dumazet (1):
      udp: multicast packets need to check namespace

Holger Schurig (1):
      libertas: remove two libertas sparse warning

Ilpo Järvinen (1):
      bpa10x: free sk_buff with kfree_skb

Ivo van Doorn (1):
      rt2x00: Fix build error when mac80211=M rt2x00=Y

Jay Cliburn (1):
      atl1: fix vlan tag regression

Jay Vosburgh (2):
      bonding: fix miimon failure counter
      bonding: Clean up resource leaks

Jianjun Kong (1):
      af_unix: netns: fix problem of return value

Johannes Berg (1):
      libertas: fix buffer overrun

Manish Katiyar (1):
      netlabel: Fix compilation warnings in net/netlabel/netlabel_addrlist.c

Mike Frysinger (1):
      SMC91x: delete unused local variable "lp"

Paul Moore (1):
      netlabel: Fix compiler warnings in netlabel_mgmt.c

Randy Dunlap (1):
      net: delete excess kernel-doc notation

Stephen Hemminger (1):
      net: add documentation for skb recycling

Tomas Winkler (1):
      iwlwifi: fix suspend to RAM in iwlwifi

Trent Piepho (2):
      gianfar: Fix race in TBI/SerDes configuration
      gianfar: Don't reset TBI<->SerDes link if it's already up

fernando@oss.ntt.co (1):
      xfrm: do not leak ESRCH to user space

roel kluin (1):
      cipso: unsigned buf_len cannot be negative

 MAINTAINERS                            |    2 +
 arch/powerpc/sysdev/fsl_soc.c          |   26 ++++++++++++++++
 drivers/bluetooth/bpa10x.c             |    4 +-
 drivers/net/amd8111e.c                 |    9 ++---
 drivers/net/arm/at91_ether.c           |    6 +++-
 drivers/net/atlx/atl1.c                |    7 ++--
 drivers/net/atlx/atl1.h                |    2 +-
 drivers/net/bonding/bond_alb.c         |   13 +++++---
 drivers/net/bonding/bond_main.c        |   52 +++++++++++++++++++++-----------
 drivers/net/gianfar.c                  |   16 ++++++++++
 drivers/net/gianfar_mii.c              |   21 +++++++++++++
 drivers/net/gianfar_mii.h              |    3 ++
 drivers/net/irda/ks959-sir.c           |    1 -
 drivers/net/irda/ksdazzle-sir.c        |    1 -
 drivers/net/loopback.c                 |    9 -----
 drivers/net/myri10ge/myri10ge.c        |    4 ++-
 drivers/net/pppoe.c                    |    6 ++--
 drivers/net/smc91x.c                   |    2 -
 drivers/net/wan/z85230.c               |    1 -
 drivers/net/wireless/ath5k/base.c      |    4 +--
 drivers/net/wireless/ath5k/debug.c     |    2 +-
 drivers/net/wireless/ath5k/initvals.c  |    2 +
 drivers/net/wireless/ath5k/reset.c     |   22 ++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 drivers/net/wireless/libertas/cmd.c    |    4 +-
 drivers/net/wireless/libertas/scan.c   |    4 +-
 drivers/net/wireless/rt2x00/Kconfig    |    2 +-
 include/linux/fsl_devices.h            |    3 +-
 include/linux/netdevice.h              |    1 -
 include/net/net_namespace.h            |    2 +
 include/net/sock.h                     |    1 -
 net/core/net_namespace.c               |   32 +++++++++++++++++++
 net/core/skbuff.c                      |   12 +++++++
 net/ipv4/cipso_ipv4.c                  |    7 ++--
 net/ipv4/udp.c                         |   12 ++++---
 net/ipv6/udp.c                         |    8 ++--
 net/key/af_key.c                       |    1 -
 net/netfilter/nf_conntrack_proto_gre.c |    4 +-
 net/netlabel/netlabel_addrlist.c       |    2 +
 net/netlabel/netlabel_addrlist.h       |   22 +++++++++++++
 net/netlabel/netlabel_mgmt.c           |    2 +-
 net/unix/af_unix.c                     |    2 +-
 net/xfrm/xfrm_policy.c                 |    2 +
 43 files changed, 242 insertions(+), 98 deletions(-)
