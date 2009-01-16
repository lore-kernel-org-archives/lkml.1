Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbZAPACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbZAPACX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZAPACA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:02:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51047
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbZAPAB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:01:58 -0500
Date: Thu, 15 Jan 2009 16:01:59 -0800 (PST)
Message-Id: <20090115.160159.262623707.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0G02SwM001876


1) The wireless folks have come out from christmas hibernation to give
   us some bug fixes, as well as some device ID additions for a few
   drivers.

2) netxen driver fixes from Dhananjay Phadke

3) HSO driver endianness fix from Denis Joseph Barrow

4) IPSEC userland 32-bit compatability fix from your's truly.

5) Fix from Daniele Venzano for sis900 do that we try to use a
   randomized MAC address if we can't probe one from the hardware.

6) bnx2x driver fixes from Eilon Greenstein

7) Netfilter bug fixes via Patrick McHardy.

8) GRO bug fixes from Herbert Xu.

9) HTB packet scheduler fixes from Jarek Poplawski.

10) net_device_ops fallout cures from Magnus Damm, and Krzysztof Ha≈Çasa.

11) korina driver bug fixes from Phil Sutter

12) TCP splice performance turd fix from Willy Tarreau, as it was
    splice reading for TCP would only process one SKB at a time
    which totally stinks for performance.

In the same area as #12 we have a TCP splice corruption bug, we have
a fix but it needs some more work.  This bug has been around basically
forever.  I'll get that to you as soon as it's ready.

Please pull, thanks a lot!

The following changes since commit 37a76bd4f1b716949fc38a6842e89f0ccb8384d0:
  Arjan van de Ven (1):
        async: fix __lowest_in_progress()

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Andrew Price (1):
      rt2x00: Fix radio LED type check

Andrey Yurovsky (1):
      libertas_tf: return NETDEV_TX_OK in TX op

Anton Vorontsov (2):
      gianfar: Fix soft lockup with multi-interrupt TSECs
      phylib: Fix Freescale TBI PHY detection

Benjamin Herrenschmidt (1):
      net: Add init_dummy_netdev() and fix EMAC driver using it

Bob Copeland (1):
      ath5k: fix return values from ath5k_tx

Christian Lamparter (5):
      p54: crypto offload fixes
      p54usb: fix random traffic stalls (LM87)
      minstrel: fix warning if lowest supported rate index is not 0
      p54: fix WARN_ON at line 2247 of net/mac80211/rx.c
      mac80211: initialize RC data for all mesh links upon allocation

Cyrill Gorcunov (1):
      net: ppp_generic - fix regressions caused by IDR conversion

Daniel Wu (1):
      iwlwifi: Fix typo in iwl-commands.h for CCK rate bit range.

Daniele Venzano (1):
      sis900: generate fake MAC address if the hardware doesn't have one

David Kilroy (1):
      orinoco: take the driver lock in the rx tasklet

David S. Miller (3):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      ARM etherh: Fix build failure.
      xfrm: For 32/64 compatability wrt. xfrm_usersa_info

Denis Joseph Barrow (1):
      hso: driver fix for big endian machines.

Dhananjay Phadke (7):
      netxen: fix endianness in firmware commands
      netxen: fix ipv6 offload and tx cleanup
      netxen: fix link speed reporting for some boards
      netxen: firmware init fix
      netxen: cleanup mac list on driver unload
      netxen: hold tx lock while sending firmware commands
      netxen: handle dma mapping failures

Eilon Greenstein (13):
      bnx2x: Using singlethread work queue
      bnx2x: Missing memory barriers
      bnx2x: Using system page size for SGE
      bnx2x: Missing mask when calculating flow control
      bnx2x: Flow control updated before reporting the link
      bnx2x: Protecting the link change indication
      bnx2x: VLAN tagged packets without VLAN offload
      bnx2x: Endianness issues
      bnx2x: Fixing the doorbell size
      bnx2x: Missing brackets
      bnx2x: Indirection table initialization index
      bnx2x: MTU Filter
      bnx2x: First slow path interrupt race

Eric Dumazet (1):
      b44: GFP_DMA skb should not escape from driver

Erik Ekman (1):
      Wireless: Fix Kconfig fact error

Herbert Xu (6):
      netfilter 02/09: bridge: Fix handling of non-IP packets in FORWARD/POST_ROUTING
      netfilter 03/09: bridge: Disable PPPOE/VLAN processing by default
      ipv6: Fix fib6_dump_table walker leak
      gro: Check for GSO packets and packets with frag_list
      gro: Fix page ref count for skbs freed normally
      gso: Ensure that the packet is long enough

Ivo van Doorn (4):
      rt2x00: Fix TX short preamble detection
      rt2x00: Fix segementation fault
      Fix rt2500usb HW crypto: TKIP
      rt2x00: Fix rt2500usb HW crypto: WEP 128 & AES

Jan Engelhardt (2):
      netfilter 05/09: ebtables: fix inversion in match code
      netfilter 08/09: xt_time: print timezone for user information

Jarek Poplawski (2):
      pkt_sched: sch_htb: Consider used jiffies in htb_do_events()
      pkt_sched: sch_htb: Break all htb_do_events() after 2 jiffies

Johannes Berg (1):
      rtl8187: Fix module so that rmmod/insmod does not error

John W. Linville (5):
      mac80211: fix "‚Äòret‚Äô may be used uninitialized" warning
      b43: fix "‚Äògmode‚Äô may be used uninitialized" warning
      b43legacy: fix "‚Äòup_dev‚Äô may be used uninitialized" warning
      iwl3945: fix "‚Äòpower_idx‚Äô may be used uninitialized" warning
      p54: fix "‚Äòret‚Äô may be used uninitialized" warning

Jos-Vicente Gilabert (1):
      drivers/net/irda/irda-usb.c: fix buffer overflow

Jouni Malinen (2):
      ath9k: Enforce module build if rfkill is a module
      ath9k: Revert fix to TX status reporting for retries and MCS index

Julia Lawall (1):
      netfilter 07/09: simplify nf_conntrack_alloc() error handling

Krzysztof Ha≈Çasa (2):
      WAN: Fix NAPI interface in IXP4xx HSS driver.
      net: Fix a comment in include/linux/netdevice.h.

Larry Finger (2):
      p54usb: Fix to prevent SKB memory allocation errors with 4K page size
      rtl8180: Fix to add STA mode

Magnus Damm (1):
      ax88796: start_xmit fix using net_device_ops

Michiel (1):
      p54usb: Add USB ID for Thomson Speedtouch 121g

Mike Ditto (1):
      powerpc/fs_enet: Add missing irq free in error path.

Oliver Hartkopp (1):
      can: fix slowpath issue in hrtimer callback function

Patrick McHardy (3):
      netfilter 01/09: remove "happy cracking" message
      netfilter 04/09: x_tables: fix match/target revision lookup
      netfilter 06/09: nf_conntrack: fix ICMP/ICMPv6 timeout sysctls on big-endian

Paul Bolle (2):
      i4l: do not print a warning when shutting down an i4l ppp interface
      i4l: minor cleanups

Pavel Roskin (2):
      orinoco_cs: add ID for ARtem Onair Comcard 11
      mac80211: allow mode change if IBSS is not allowed

Phil Sutter (9):
      korina: fix usage of driver_data
      korina: reset resource buffer size to 1536
      korina: disable napi on close and restart
      korina: rework korina_rx() for use with napi
      korina: do schedule napi after testing for it
      korina: do tx at the right position
      korina: fix handling tx_chain_tail
      korina: do not stop queue here
      korina: do not use IRQF_SHARED with IRQF_DISABLED

Richard Kennedy (1):
      netfilter 09/09: remove padding from struct xt_match on 64bit builds

Samuel Ortiz (1):
      iwlwifi: Fix get_cmd_string() for REPLY_3945_RX

Senthil Balasubramanian (1):
      ath9k: Fix incorrect sequence numbering for unaggregated QoS Frame.

Stefan Lippers-Hollmann (1):
      rt2x00: add USB ID for the Linksys WUSB200.

Steve Brown (1):
      ath5k: Correct usage of AR5K_CFG_ADHOC

Sujith (1):
      ath9k: Fix chainmask handling bug

Willy Tarreau (1):
      tcp: splice as many packets as possible at once

 drivers/isdn/i4l/isdn_net.c                    |    9 +-
 drivers/net/arm/etherh.c                       |    2 +-
 drivers/net/ax88796.c                          |   27 +++-
 drivers/net/b44.c                              |    4 +-
 drivers/net/b44.h                              |    2 +-
 drivers/net/bnx2x.h                            |   19 ++-
 drivers/net/bnx2x_main.c                       |  178 ++++++++++++++-------
 drivers/net/fs_enet/fs_enet-main.c             |    1 +
 drivers/net/gianfar.c                          |    8 +
 drivers/net/ibm_newemac/mal.c                  |    4 +-
 drivers/net/ibm_newemac/mal.h                  |    2 +
 drivers/net/irda/irda-usb.c                    |    2 +-
 drivers/net/korina.c                           |  158 +++++++++---------
 drivers/net/netxen/netxen_nic.h                |  146 ++++++++----------
 drivers/net/netxen/netxen_nic_ctx.c            |   50 +++----
 drivers/net/netxen/netxen_nic_ethtool.c        |   31 +++-
 drivers/net/netxen/netxen_nic_hw.c             |   97 ++++++++----
 drivers/net/netxen/netxen_nic_init.c           |  105 +++++++------
 drivers/net/netxen/netxen_nic_main.c           |  203 +++++++++++++++---------
 drivers/net/phy/phy_device.c                   |    9 -
 drivers/net/ppp_generic.c                      |   43 +++++-
 drivers/net/sis900.c                           |    8 +-
 drivers/net/usb/hso.c                          |    4 +-
 drivers/net/wan/ixp4xx_hss.c                   |    6 +-
 drivers/net/wireless/Kconfig                   |    2 +-
 drivers/net/wireless/ath5k/base.c              |    8 +-
 drivers/net/wireless/ath5k/pcu.c               |    4 +-
 drivers/net/wireless/ath5k/reg.h               |    2 +-
 drivers/net/wireless/ath9k/Kconfig             |    1 +
 drivers/net/wireless/ath9k/main.c              |    4 +-
 drivers/net/wireless/ath9k/xmit.c              |   48 ++----
 drivers/net/wireless/b43/main.c                |    2 +-
 drivers/net/wireless/b43legacy/main.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c        |    1 +
 drivers/net/wireless/libertas_tf/main.c        |    2 +-
 drivers/net/wireless/orinoco/orinoco.c         |   28 +++-
 drivers/net/wireless/orinoco/orinoco_cs.c      |    1 +
 drivers/net/wireless/p54/p54common.c           |   34 ++++-
 drivers/net/wireless/p54/p54usb.c              |    2 +
 drivers/net/wireless/rt2x00/rt2500usb.c        |   23 +--
 drivers/net/wireless/rt2x00/rt2x00dev.c        |    8 +-
 drivers/net/wireless/rt2x00/rt2x00leds.c       |    2 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h        |   11 --
 drivers/net/wireless/rt2x00/rt2x00queue.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c        |    6 +-
 drivers/net/wireless/rt2x00/rt73usb.c          |    1 +
 drivers/net/wireless/rtl818x/rtl8180_dev.c     |    1 +
 drivers/net/wireless/rtl818x/rtl8187_dev.c     |    5 +-
 include/linux/netdevice.h                      |    5 +-
 include/linux/netfilter/x_tables.h             |    2 +-
 net/bridge/br_netfilter.c                      |   18 ++-
 net/bridge/netfilter/ebtables.c                |    2 +-
 net/can/bcm.c                                  |   57 ++++---
 net/core/dev.c                                 |   48 +++++-
 net/core/skbuff.c                              |    6 +
 net/ipv4/netfilter/iptable_filter.c            |    7 +-
 net/ipv4/netfilter/iptable_mangle.c            |    6 +-
 net/ipv4/netfilter/iptable_raw.c               |    6 +-
 net/ipv4/netfilter/iptable_security.c          |    6 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    5 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv4/tcp.c                                 |   24 ++-
 net/ipv6/ip6_fib.c                             |   15 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/mac80211/ht.c                              |    2 +-
 net/mac80211/iface.c                           |    3 +-
 net/mac80211/mesh_plink.c                      |    1 +
 net/mac80211/rc80211_minstrel.c                |   10 +-
 net/netfilter/nf_conntrack_core.c              |    4 +-
 net/netfilter/nf_conntrack_netlink.c           |    2 +-
 net/netfilter/x_tables.c                       |    8 +
 net/netfilter/xt_time.c                        |   11 ++
 net/sched/sch_htb.c                            |   15 +-
 net/xfrm/xfrm_user.c                           |   11 +-
 76 files changed, 942 insertions(+), 658 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
