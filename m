Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbZHXGSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbZHXGSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZHXGSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:18:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38050
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522AbZHXGSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:18:41 -0400
Date: Sun, 23 Aug 2009 23:18:53 -0700 (PDT)
Message-Id: <20090823.231853.202608464.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n7O6Iv16000574


1) Improper error return in allocation failure case in xt_quota
   netfilter module results in NULL deref, from Patrick McHardy.

2) Use the tasklet_hrtimer facility added by Peter Z. in order to
   fix hrtimers in networking that can't actually safely run from
   HW interrupt context.

3) LLC protocol leaks some bytes to userspace via ->getname().
   Fix from Jiri Slaby.

4) Fix an ipv6 commit that broke bind() error reporting to userspace.
   From Bruno PrÃ©mont.

5) Fix bonding with ibm_newemac, from Petri Gynther.

6) pxaficp-ir netdev_ops conversion was buggy, fix from Marek Vasut.

7) ks8851 build fix from Randy Dunlap

8) Orinoco and RTL8187 wireless fixes from John Linville and
   Herton Ronaldo Krzesinski respectively.

9) netpoll transmit locking fixes from Dongdong Deng, and he also
   added a check so that we can quickly discover any drivers that
   are still buggy in this regard.

Please pull, thanks a lot!

The following changes since commit 3edf2fb9d80a46d6c32ba12547a42419845b4b76:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Andreas Mohr (1):
      net: Fix Micrel KSZ8842 Kconfig description

Bruno PrÃ©mont (1):
      ipv6: Fix commit 63d9950b08184e6531adceb65f64b429909cc101 (ipv6: Make v4-mapped bindings consistent with IPv4)

David S. Miller (4):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      pkt_sched: Convert qdisc_watchdog to tasklet_hrtimer
      pkt_sched: Convert CBQ to tasklet_hrtimer.

Dongdong Deng (3):
      netpoll: warning for ndo_start_xmit returns with interrupts enabled
      drivers/net: fixed drivers that support netpoll use ndo_start_xmit()
      smc91x: let smc91x work well under netpoll

Herton Ronaldo Krzesinski (1):
      rtl8187: always set MSR_LINK_ENEDCA flag with RTL8187B

Jiri Slaby (1):
      NET: llc, zero sockaddr_llc struct

Johannes Berg (1):
      mac80211: fix todo lock

John W. Linville (1):
      orinoco: correct key bounds check in orinoco_hw_get_tkip_iv

Krzysztof HaÅ‚asa (1):
      E100: fix interaction with swiotlb on X86.

Marek Vasut (1):
      pxaficp-ir: remove incorrect net_device_ops

Patrick McHardy (1):
      netfilter: xt_quota: fix wrong return value (error case)

Petri Gynther (1):
      ibm_newemac: emac_close() needs to call netif_carrier_off()

Randy Dunlap (1):
      net: fix ks8851 build errors

Roel Kluin (1):
      yellowfin: Fix buffer underrun after dev_alloc_skb() failure

Wan ZongShun (1):
      net: Rename MAC platform driver for w90p910 platform

 drivers/net/Kconfig                        |    4 ++-
 drivers/net/arm/w90p910_ether.c            |    4 +-
 drivers/net/e100.c                         |    2 +-
 drivers/net/fec_mpc52xx.c                  |    5 ++-
 drivers/net/ibm_newemac/core.c             |    2 +
 drivers/net/irda/pxaficp_ir.c              |    4 +--
 drivers/net/ixp2000/ixpdev.c               |    5 ++-
 drivers/net/macb.c                         |    7 +++--
 drivers/net/mlx4/en_tx.c                   |    5 ++-
 drivers/net/smc91x.c                       |   40 +++++++++++++++------------
 drivers/net/wireless/orinoco/hw.c          |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   14 +++++++---
 drivers/net/yellowfin.c                    |   28 ++++++++++++-------
 include/net/pkt_sched.h                    |    4 +-
 net/core/netpoll.c                         |    5 +++
 net/ipv6/af_inet6.c                        |    4 ++-
 net/llc/af_llc.c                           |    1 +
 net/mac80211/key.c                         |   28 ++++++++++---------
 net/netfilter/xt_quota.c                   |    2 +-
 net/sched/sch_api.c                        |    8 +++---
 net/sched/sch_cbq.c                        |   23 +++++++++-------
 21 files changed, 117 insertions(+), 80 deletions(-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
