Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZAZW51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZAZW51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZAZW5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:57:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38109
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbZAZW5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:57:08 -0500
Date: Mon, 26 Jan 2009 14:57:04 -0800 (PST)
Message-Id: <20090126.145704.137971029.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0QMvhwM014635


1) E1000E TX lockup fix from Jesse Brandeburg.

2) GRO fixes from Herbert Xu

3) Revert attempt to fix IPSEC 32/64 bit compat issue, it breaks
   more than it fixes.

4) CTNETLINK 'sched while atomic' fix from Patrick McHardy.

5) korina driver bug fixes from Phil Sutter.

6) Explicitly initialize encap_oa to zero in AF_PFKEY messages,
   fix from Timo Teras.  Since we basically ignore this bit, leaving
   it unitialized is problematic.

7) SCTP bug fixes from Vlad Yasevich

8) bnx2x bug fixes from Vladislav Zolotarov and Eilon Greenstein.

9) Various wireless fixes via John Linville.

10) phylib suspend/resume OOPS fix from Anton Vorontsov.

11) VLAN symbols unintentionally exported GPL only, fix from
    Ben Greear.

Please pull, thanks a lot!

The following changes since commit f3b8436ad9a8ad36b3c9fa1fe030c7f38e5d3d0b:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Abbas, Mohamed (1):
      iwlwifi: fix rs_get_rate WARN_ON()

Alex Williamson (1):
      virtio_net: Fix MAX_PACKET_LEN to support 802.1Q VLANs

Andrey Borzenkov (1):
      orinoco: move kmalloc(..., GFP_KERNEL) outside spinlock in orinoco_ioctl_set_genie

Andrey Yurovsky (1):
      libertas: Fix alignment issues in libertas core

Anton Vorontsov (2):
      phylib: Fix oops in suspend/resume paths
      gianfar: Revive VLAN support

Artur Skawina (1):
      p54: set_tim must be atomic.

Ben Greear (1):
      vlan: Export symbols as non GPL symbols.

Brian Cavagnolo (1):
      mac80211: decrement ref count to netdev after launching mesh discovery

Brice Goglin (1):
      myri10ge: don't forget pci_disable_device()

Chr (1):
      p54: add missing break in eeprom parser

Christian Eggers (1):
      usb/mcs7830: Don't use buffers from stack for USB transfers

Christian Lamparter (6):
      p54: fix oops caused by bad eeproms
      p54: fix p54_set_key's return code
      mac80211: fix slot time debug message
      p54: more cryptographic accelerator fixes
      p54usb: fix nasty use after free
      p54usb: fix packet loss with first generation devices

Daniele Venzano (1):
      isdn: Fix missing ifdef in isdn_ppp

David S. Miller (3):
      Revert "xfrm: For 32/64 compatability wrt. xfrm_usersa_info"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

Dhananjay Phadke (2):
      netxen: fix vlan tso/checksum offload
      netxen: reduce memory footprint

Divy Le Ray (1):
      cxgb3: Fix LRO misalignment

Don Skidmore (2):
      ixgbe: fix dca issue with relaxed ordering turned on
      ixgbe: fix tag stripping for VLAN ID 0

Eilon Greenstein (22):
      bnx2x: Free IRQ
      bnx2x: Handling probe failures
      bnx2x: Potential race after iSCSI boot
      bnx2x: Wrong HDR offset in CAM
      bnx2x: Read chip ID
      bnx2x: Block nvram access when the device is inactive
      bnx2x: Overstepping array bounds
      bnx2x: 1G-10G toggling race
      bnx2x: Prevent self test loopback failures
      bnx2x: Legacy speeds autoneg failures
      bnx2x: Handling PHY FW load failure
      bnx2x: Driver description update
      bnx2x: Barriers for the compiler
      bnx2x: Version update
      bnx2x: Reset HW before use
      bnx2x: Disable napi
      bnx2x: Handling load failures
      bnx2x: Carrier off first call
      bnx2x: Calling napi_del
      bnx2x: Missing rmb when waiting for FW response
      bnx2x: loopback test failure
      bnx2x: Version

Gabriel Paubert (1):
      mv643xx_eth: prevent interrupt storm on ifconfig down

Heiko Carstens (1):
      lcs: fix compilation for !CONFIG_IP_MULTICAST

Herbert Xu (4):
      net: Add debug info to track down GSO checksum bug
      gro: Fix handling of complete checksums in IPv6
      gro: Fix error handling on extremely short frags
      gro: Fix merging of paged packets

Hin-Tak Leung (1):
      zd1211rw: adding Sitecom WL-603 (0df6:0036) to the USB id list

Inaky Perez-Gonzalez (1):
      wimax/i2400m: error paths that need to free an skb should use kfree_skb()

Ivo van Doorn (1):
      rt2x00: Fix TX rate short preamble detection

Jarek Poplawski (1):
      net: Fix data corruption when splicing from sockets.

Jesse Barnes (1):
      networking: document "nc" in addition to "netcat" in netconsole.txt

Jesse Brandeburg (1):
      e1000e: workaround hw errata

Jiri Slaby (1):
      NET: net_namespace, fix lock imbalance

Jouni Malinen (2):
      ath9k: Fix an operator typo in phy rate validation
      ath9k: Fix an operator typo in REG_DOMAIN_2GHZ_MASK

Krzysztof HaÅ‚asa (1):
      net: Fix linux/if_frad.h's suitability for userspace.

Larry Finger (1):
      rtl8187: Add termination packet to prevent stall

Lennert Buytenhek (2):
      Revert "mv643xx_eth: use longer DMA bursts".
      mv643xx_eth: fix multicast filter programming

Luis R. Rodriguez (3):
      cfg80211: make handle_band() and handle_channel() wiphy specific
      cfg80211: Fix regression with 11d on bands
      cfg80211: Fix parsed country IE info for 5 GHz

Matt Carlson (1):
      tg3: Fix firmware loading

Matt Helsley (1):
      net: Move config NET_NS to from net/Kconfig to init/Kconfig

Patrick McHardy (1):
      netfilter: ctnetlink: fix scheduling while atomic

Pavel Roskin (1):
      orinoco: use KERN_DEBUG for link status messages

Peter P Waskiewicz Jr (1):
      ixgbe: Fix usage of netif_*_all_queues() with netif_carrier_{off|on}()

Phil Sutter (3):
      korina: fix loop back of receive descriptors
      korina: adjust headroom for new skb's also
      korina: drop leftover assignment

Rami Rosen (1):
      rt2x00: fix a wrong parameter for __test_and_clear_bit() in rt2x00rfkill_free().

Randy Dunlap (1):
      mac80211: more kernel-doc fixes

Reinette Chatre (1):
      iwlwifi: return NETDEV_TX_OK from _tx ops

Richard RÃ¶jfors (1):
      macb: avoid lockup when TGO during underrun

Roel Kluin (1):
      net/9p: fid->fid is used uninitialized

Steve Glendinning (2):
      usbnet: allow type check of devdbg arguments in non-debug build
      phy: Add suspend/resume support to SMSC PHYs

Timo Teras (1):
      af_key: initialize xfrm encap_oa

Vlad Yasevich (4):
      sctp: Fix crc32c calculations on big-endian arhes.
      sctp: Correctly start rtx timer on new packet transmissions.
      sctp: Properly timestamp outgoing data chunks for rtx purposes
      sctp: Fix another socket race during accept/peeloff

Vladislav Zolotarov (1):
      bnx2x: tx_has_work should not wait for FW

Zhu Yi (1):
      iwlwifi: remove CMD_WANT_SKB flag if send_cmd_sync failure

roel kluin (1):
      via-velocity: fix hot spin

 Documentation/networking/netconsole.txt     |    3 +-
 drivers/isdn/i4l/isdn_ppp.c                 |    2 +
 drivers/net/bnx2x.h                         |   11 +-
 drivers/net/bnx2x_link.c                    |   64 ++++--
 drivers/net/bnx2x_main.c                    |  302 ++++++++++++++++-----------
 drivers/net/bnx2x_reg.h                     |    2 +-
 drivers/net/cxgb3/sge.c                     |    1 +
 drivers/net/e1000e/82571.c                  |    6 +-
 drivers/net/e1000e/hw.h                     |    1 +
 drivers/net/gianfar.c                       |    6 +-
 drivers/net/ixgbe/ixgbe_main.c              |   62 +++---
 drivers/net/ixgbe/ixgbe_type.h              |    3 +
 drivers/net/korina.c                        |   15 +-
 drivers/net/macb.c                          |    8 +
 drivers/net/mv643xx_eth.c                   |   17 +-
 drivers/net/myri10ge/myri10ge.c             |   15 +-
 drivers/net/netxen/netxen_nic.h             |   12 +-
 drivers/net/netxen/netxen_nic_ethtool.c     |    5 +-
 drivers/net/netxen/netxen_nic_main.c        |   31 ++-
 drivers/net/phy/mdio_bus.c                  |    8 +-
 drivers/net/phy/smsc.c                      |   12 +
 drivers/net/tg3.c                           |   81 +++++---
 drivers/net/tg3.h                           |    1 +
 drivers/net/usb/mcs7830.c                   |   20 ++-
 drivers/net/via-velocity.c                  |    2 +-
 drivers/net/virtio_net.c                    |    3 +-
 drivers/net/wimax/i2400m/control.c          |    2 +-
 drivers/net/wimax/i2400m/usb-rx.c           |    9 +-
 drivers/net/wireless/ath9k/rc.c             |    2 +-
 drivers/net/wireless/ath9k/regd_common.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +-
 drivers/net/wireless/libertas/hostcmd.h     |   91 ++++----
 drivers/net/wireless/orinoco/orinoco.c      |   32 ++--
 drivers/net/wireless/p54/p54common.c        |   30 ++-
 drivers/net/wireless/p54/p54usb.c           |   41 ++--
 drivers/net/wireless/rndis_wlan.c           |    2 -
 drivers/net/wireless/rt2x00/rt2x00queue.c   |    3 +-
 drivers/net/wireless/rt2x00/rt2x00rfkill.c  |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    1 +
 drivers/net/wireless/zd1211rw/zd_usb.c      |    1 +
 drivers/s390/net/lcs.c                      |    8 +-
 include/linux/if_frad.h                     |   10 +-
 include/linux/usb/usbnet.h                  |    4 +-
 include/net/mac80211.h                      |    1 -
 include/net/sctp/checksum.h                 |    2 +-
 init/Kconfig                                |    8 +
 net/8021q/vlan_core.c                       |    4 +-
 net/9p/client.c                             |    2 +-
 net/Kconfig                                 |    8 -
 net/core/dev.c                              |   15 ++-
 net/core/net_namespace.c                    |    2 +-
 net/core/skbuff.c                           |   70 +++----
 net/ipv6/af_inet6.c                         |    7 +
 net/key/af_key.c                            |    1 +
 net/mac80211/mlme.c                         |    4 +-
 net/mac80211/sta_info.h                     |    1 -
 net/mac80211/tx.c                           |    6 +-
 net/netfilter/nf_conntrack_netlink.c        |    3 +
 net/sctp/input.c                            |   13 ++
 net/sctp/output.c                           |    7 +-
 net/sctp/outqueue.c                         |    3 +-
 net/wireless/reg.c                          |  128 +++++++++++-
 net/xfrm/xfrm_user.c                        |   11 +-
 67 files changed, 801 insertions(+), 464 deletions(-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
