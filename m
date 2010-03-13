Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935531Ab0CMUfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 15:35:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36342
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759237Ab0CMUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 15:35:43 -0500
Date: Sat, 13 Mar 2010 12:36:03 -0800 (PST)
Message-Id: <20100313.123603.245113830.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2DKaAmE026059


1) bfin_can build fix from Barry Song.

2) gianfar TX ring SMP race fix from Anton Vorontsov

3) Add support for smc91x on Qualcomm MSM boards, from David Brown.

4) Hot plug removal crash fix in cxgb3 from Divy Le Ray.

5) It's possible to bombard a socket sufficiently such that
   socket backlog accumulates forever.  Put in a limit point at
   which we'll simply start dropping frames.  From Zhu Yi and
   Eric Dumazet.

6) Barrier fixes in r8169 and typhoon from David Dillow.

7) MAINTAINER tweaks for CAN protocol and bridge.

8) Fix excessive route cache rebuilds, from Eric Dumazet.

9) Fix TCP synack packet sizing, also from Eric.

10) CPMAC bug fixes for VLAN receive, and PHY chip fallbacks,
    from Florian Fainelli.

11) Fix RCU handling in bridging code, from Herbert Xu.

12) Fix ipsec flow ID handling, also from Herbert.

13) Fix address length check regression in AF_PACKET, from Jiri Pirko.

14) %pI4 conversion in sunrpc from Joe Perches.  Joe sent this two
    months ago and the NFS folks didn't integrate, Trond told me
    I could take this in via net-2.6 if I like so that's what I've
    done.

15) TIPC oops and RX filtering fixes from Neil Horman.

16) QLCNIC bug fixes from Sucheta Chakraborty.  ETHTOOL get
    TX csum status was horked, add some missing driver stats,
    multicast addr handling fix, and better firmware image
    validation.

17) GRE tunnel header destination address checking fix from Timo Ter√§s.

18) Missing change to remove obsoleted bnx2x firmware, from
    Vladislav Zolotarov.

19) IPV6 addrconf timer bug fixes from Stephen Hemminger.

20) Fix for packet corruption and TX hang over NFSv2 in
    e1000e, from Jesse Brandeburg.

21) Pegasus USB ID addition, from Petko Manolov.

22) Various use-after-free, leak, et al. fixes from Dan Carpenter.

23) 4K buffer on kernel stack regression fix in Bluetooth from Marcel
    Holtmann.

24) When Ingo added the sync wakeup hints to the networking
    socket handling, he missed tcp_prequeue().  From Mike Galbraith.

25) And the usual assortment of wireless fixes and cures from
    John Linville and the crew.

26) Fix TCP hang, can't test TTL on timewait socket, from Eric
    Dumazet.

27) qeth bug fixes (unsafe checksumming settings, etc.)
    via Ursula Braun.

28) ->poll_controller() passes wrong device pointer to tg3_interrupt(),
    fix from Louis Rilling

29) Fix a regression added to dev_mc_add() (could return with
    lock held), from Eric Dumazet.

30) Couple reverts in wireless to fix bugs.  Fix missing unlock
    in mac80211 STA code, etc. all via John Linville and the
    wireless crew.

31) sky2 resume can unlock without holding lock.  Fix from
    Mike McCormack.

32) DHCP has no way to see that DAD failure on an address it
    selected, so send a proper notification from ipv6.  From
    Herbert Xu.

33) tg3 driver checks flag bit on wrong word.  Fix from Julia Lawall.

34) Tulip probe message regression fix from Joe Perches.

35) Bridge multicast code forgets to drop lock in error path, fix
    from YOSHIFUJI Hideaki.

Please pull, thanks a lot!

The following changes since commit daf9fe2ee9a203c4fc555cfe5c5f3d9f660e743c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../sameo/mfd-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Ajit Khaparde (2):
      be2net: remove usage of be_pci_func
      be2net: remove unused code in be_load_fw

Amit Kumar Salecha (2):
      qlcnic: fix bios version check
      qlcnic: remove extra space from board names

Anton Vorontsov (1):
      gianfar: Fix TX ring processing on SMP machines

Barry Song (1):
      can: fix bfin_can build error after alloc_candev() change

Breno Leitao (1):
      s2io: Fixing debug message

Bruno Randolf (4):
      ath5k: use fixed antenna for tx descriptors
      ath5k: fix TSF reset
      ath5k: fix I/Q calibration (for real)
      ath5k: read eeprom IQ calibration values correctly for G mode

Bryan Polk (1):
      rt2x00: Add USB ID for CEIVA adapter to rt73usb

Dan Carpenter (8):
      zd1211rw: fix potential array underflow
      cpmac: use after free
      cassini: fix off by one
      davinci_emac: off by one
      bridge: cleanup: remove unneed check
      ems_usb: cleanup: remove uneeded check
      sock.c: potential null dereference
      irda-usb: add error handling and fix leak

David Brown (1):
      net: smc91x: Support Qualcomm MSM development boards.

David Dillow (2):
      r8169: use correct barrier between cacheable and non-cacheable memory
      typhoon: fix incorrect use of smp_wmb()

David S. Miller (4):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      MAINTAINERS: Add netdev to bridge entry.
      ipconfig: Handle devices which take some time to come up.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

Divy Le Ray (1):
      cxgb3: fix hot plug removal crash

Eric Dumazet (8):
      tcp: Add SNMP counters for backlog and min_ttl drops
      net: fix route cache rebuilds
      tcp: Fix tcp_make_synack()
      ethtool: Use noinline_for_stack
      tcp: Fix tcp_v4_rcv()
      net: Annotates neigh_invalidate()
      net: Fix dev_mc_add()
      mac80211: Fix memory leak in ieee80211_if_write()

Figo.zhang (1):
      fix a race in ks8695_poll

Florian Fainelli (3):
      cpmac: fix the receiving of 802.1q frames
      cpmac: fallback to switch mode if no PHY chip found
      cpmac: bump version to 0.5.2

Frank Blaschka (2):
      qeth: l3 send dhcp in non pass thru mode
      qeth: change checksumming default for HiperSockets

Greg Ungerer (1):
      net: add ColdFire support to the smc91x driver

Helmut Schaa (3):
      rt2x00: fix rt2800pci compilation with SoC
      rt2x00: Export rt2x00soc_probe from rt2x00soc
      rt2x00: remove KSEG1ADDR define from rt2x00soc.h

Herbert Xu (4):
      ipsec: Fix bogus bundle flowi
      bridge: Use RCU list primitive in __br_mdb_ip_get
      bridge: Fix RCU race in br_multicast_stop
      ipv6: Send netlink notification when DAD fails

Jeff Garzik (2):
      ethtool: Add direct access to ops->get_sset_count
      ethtool: Add direct access to ops->get_sset_count

Jesse Brandeburg (1):
      e1000e: fix packet corruption and tx hang during NFSv2

Jiri Pirko (2):
      af_packet: move strict addr_len check right before dev_[mc/unicast]_[add/del]
      rndis_wlan: correct multicast_list handling V3

Joe Perches (3):
      net/sunrpc: Remove uses of NIPQUAD, use %pI4
      net/sunrpc: Convert (void)snprintf to snprintf
      drivers/net/tulip/eeprom.c: fix bogus "(null)" in tulip init messages

Johannes Berg (2):
      ar9170: load firmware asynchronously
      iwlwifi: load firmware asynchronously before mac80211 registration

John W. Linville (1):
      Merge branch 'wireless-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6

Jouni Malinen (2):
      mac80211: Fix reassociation processing (within ESS roaming)
      mac80211: Fix sta_mtx unlocking on insert STA failure path

Julia Lawall (1):
      drivers/net/tg3.c: change the field used with the TG3_FLAG_10_100_ONLY constant

Jussi Kivilinna (1):
      asix: fix setting mac address for AX88772

Juuso Oikarinen (1):
      mac80211: Fix (dynamic) power save entry

Louis Rilling (1):
      tg3: Fix tg3_poll_controller() passing wrong pointer to tg3_interrupt()

Marcel Holtmann (1):
      Bluetooth: Use single_open() for inquiry cache within debugfs

Matthew Garrett (1):
      rfkill: Add support for KEY_RFKILL

Mike Galbraith (1):
      net: add scheduler sync hint to tcp_prequeue().

Mike McCormack (1):
      sky2: Avoid rtnl_unlock without rtnl_lock

Ming Lei (1):
      ath9k: fix lockdep warning when unloading module

Neil Horman (3):
      tipc: Fix oops on send prior to entering networked mode (v3)
      tipc: fix endianness on tipc subscriber messages
      tipc: filter out messages not intended for this host

Oliver Hartkopp (1):
      MAINTAINER: Correct CAN Maintainer responsibilities and paths

Petko Manolov (1):
      another pegasus usb net device

Randy Dunlap (1):
      bridge: depends on INET

Reinette Chatre (2):
      iwl3945: fix memory corruption
      Revert "iwlwifi: Send broadcast probe request only when asked to"

Sarveshwar Bandi (1):
      be2net: download NCSI section during firmware update

Stanislaw Gruszka (1):
      airo: return from set_wep_key() when key length is zero

Sucheta Chakraborty (4):
      qlcnic: fix tx csum status
      qlcnic: additional driver statistics.
      qlcnic: fix multicast handling
      qlcnic: validate unified fw image

Sujith (1):
      mac80211: Fix HT rate control configuration

Timo Ter√§s (1):
      gre: fix hard header destination address checking

Ursula Braun (3):
      qeth: enable kmsg hash processing in qeth_core_sys.c
      qeth: set promisc off after trace disabling failure
      qeth: no recovery after layer mismatch (z/VM NICs)

Vladislav Zolotarov (1):
      bnx2x: Removed FW 5.2.7

Wolfgang Grandegger (1):
      MAINTAINERS: add netdev to CAN network layer and drivers entries

YOSHIFUJI Hideaki (1):
      bridge: ensure to unlock in error path in br_multicast_query().

YOSHIFUJI Hideaki / ÂêâËó§Ëã±Êòé (2):
      ipv6: Optmize translation between IPV6_PREFER_SRC_xxx and RT6_LOOKUP_F_xxx.
      ipv6 ip6_tunnel: eliminate unused recursion field from ip6_tnl{}.

Zhu Yi (11):
      net: add limit for socket backlog
      tcp: use limited socket backlog
      udp: use limited socket backlog
      llc: use limited socket backlog
      sctp: use limited socket backlog
      tipc: use limited socket backlog
      x25: use limited socket backlog
      net: backlog functions rename
      net: add __must_check to sk_add_backlog
      libipw: split ieee->networks into small pieces
      ipw2200: use kmalloc for large local variables

stephen hemminger (4):
      IPv6: addrconf dad timer unnecessary bh_disable
      IPv6: addrconf timer race
      IPv6: addrconf notify when address is unavailable
      IPv6: fix race between cleanup and add/delete address

 MAINTAINERS                                  |   21 +-
 drivers/net/Kconfig                          |    2 +-
 drivers/net/arm/ks8695net.c                  |    2 +-
 drivers/net/benet/be.h                       |    5 -
 drivers/net/benet/be_cmds.c                  |    6 -
 drivers/net/benet/be_hw.h                    |    5 +-
 drivers/net/benet/be_main.c                  |   25 +-
 drivers/net/can/bfin_can.c                   |    3 +-
 drivers/net/can/usb/ems_usb.c                |    4 +-
 drivers/net/cassini.c                        |    2 +-
 drivers/net/cpmac.c                          |   14 +-
 drivers/net/cxgb3/cxgb3_main.c               |    1 +
 drivers/net/davinci_emac.c                   |    2 +-
 drivers/net/e1000e/defines.h                 |    2 +
 drivers/net/e1000e/ich8lan.c                 |   10 +
 drivers/net/gianfar.c                        |    5 +-
 drivers/net/irda/irda-usb.c                  |    4 +
 drivers/net/qlcnic/qlcnic.h                  |   13 +-
 drivers/net/qlcnic/qlcnic_ethtool.c          |   17 +
 drivers/net/qlcnic/qlcnic_hw.c               |   32 +-
 drivers/net/qlcnic/qlcnic_init.c             |  156 +-
 drivers/net/qlcnic/qlcnic_main.c             |    5 +
 drivers/net/r8169.c                          |    4 +-
 drivers/net/s2io.c                           |    6 +-
 drivers/net/sky2.c                           |    2 +-
 drivers/net/smc91x.h                         |   42 +
 drivers/net/tg3.c                            |    4 +-
 drivers/net/tulip/eeprom.c                   |   54 +-
 drivers/net/typhoon.c                        |    6 +-
 drivers/net/usb/asix.c                       |   30 +-
 drivers/net/usb/pegasus.h                    |    6 +-
 drivers/net/wireless/airo.c                  |    3 +-
 drivers/net/wireless/ath/ar9170/ar9170.h     |    1 +
 drivers/net/wireless/ath/ar9170/main.c       |   10 +-
 drivers/net/wireless/ath/ar9170/usb.c        |  170 +-
 drivers/net/wireless/ath/ath5k/eeprom.c      |    4 +-
 drivers/net/wireless/ath/ath5k/phy.c         |   41 +-
 drivers/net/wireless/ath/ath5k/reg.h         |    1 +
 drivers/net/wireless/ath/ath5k/reset.c       |   22 +-
 drivers/net/wireless/ath/ath9k/rc.c          |    6 +-
 drivers/net/wireless/ath/ath9k/xmit.c        |    4 +-
 drivers/net/wireless/ipw2x00/ipw2200.c       |   19 +-
 drivers/net/wireless/ipw2x00/libipw.h        |    2 +-
 drivers/net/wireless/ipw2x00/libipw_module.c |   37 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  159 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-scan.c      |   49 +-
 drivers/net/wireless/rndis_wlan.c            |   66 +-
 drivers/net/wireless/rt2x00/rt2800pci.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00soc.c      |    1 +
 drivers/net/wireless/rt2x00/rt2x00soc.h      |    2 -
 drivers/net/wireless/rt2x00/rt73usb.c        |    2 +
 drivers/net/wireless/zd1211rw/zd_mac.c       |   10 +-
 drivers/s390/net/qeth_core.h                 |    3 +-
 drivers/s390/net/qeth_core_main.c            |    5 +-
 drivers/s390/net/qeth_core_sys.c             |    3 +
 drivers/s390/net/qeth_l2_main.c              |   16 +-
 drivers/s390/net/qeth_l3_main.c              |   82 +-
 firmware/bnx2x-e1-5.2.7.0.fw.ihex            |10178 --------------------
 firmware/bnx2x-e1h-5.2.7.0.fw.ihex           |12847 --------------------------
 include/linux/ethtool.h                      |   24 +-
 include/linux/rfkill.h                       |    2 +-
 include/linux/snmp.h                         |    2 +
 include/net/ip6_route.h                      |   18 +
 include/net/ip6_tunnel.h                     |    1 -
 include/net/mac80211.h                       |    3 +-
 include/net/sock.h                           |   17 +-
 include/net/tcp.h                            |    2 +-
 include/net/xfrm.h                           |    3 +-
 net/bluetooth/hci_sysfs.c                    |   41 +-
 net/bridge/Kconfig                           |    1 +
 net/bridge/br_multicast.c                    |   19 +-
 net/core/dev_mcast.c                         |    5 +-
 net/core/ethtool.c                           |  103 +-
 net/core/neighbour.c                         |    2 +
 net/core/sock.c                              |   19 +-
 net/dccp/minisocks.c                         |    2 +-
 net/ipv4/ip_gre.c                            |    7 +-
 net/ipv4/ipconfig.c                          |   57 +-
 net/ipv4/proc.c                              |    2 +
 net/ipv4/route.c                             |   50 +-
 net/ipv4/tcp_ipv4.c                          |   15 +-
 net/ipv4/tcp_minisocks.c                     |    2 +-
 net/ipv4/tcp_output.c                        |   18 +-
 net/ipv4/udp.c                               |    6 +-
 net/ipv4/xfrm4_policy.c                      |    5 +-
 net/ipv6/addrconf.c                          |  104 +-
 net/ipv6/fib6_rules.c                        |   11 +-
 net/ipv6/route.c                             |   11 +-
 net/ipv6/tcp_ipv6.c                          |    7 +-
 net/ipv6/udp.c                               |   28 +-
 net/ipv6/xfrm6_policy.c                      |    3 +-
 net/llc/llc_c_ac.c                           |    2 +-
 net/llc/llc_conn.c                           |    3 +-
 net/mac80211/debugfs_netdev.c                |   10 +-
 net/mac80211/mlme.c                          |   32 +-
 net/mac80211/rate.h                          |    5 +-
 net/mac80211/sta_info.c                      |    1 +
 net/packet/af_packet.c                       |    6 +-
 net/rfkill/input.c                           |    8 +
 net/sctp/input.c                             |   42 +-
 net/sctp/socket.c                            |    3 +
 net/sunrpc/xprtrdma/transport.c              |    7 +-
 net/sunrpc/xprtsock.c                        |    9 +-
 net/tipc/bearer.c                            |   37 +-
 net/tipc/bearer.h                            |    2 +-
 net/tipc/link.c                              |    9 +
 net/tipc/net.c                               |   25 +-
 net/tipc/socket.c                            |    6 +-
 net/tipc/subscr.c                            |   57 +-
 net/tipc/subscr.h                            |    2 -
 net/x25/x25_dev.c                            |    2 +-
 net/xfrm/xfrm_policy.c                       |    7 +-
 114 files changed, 1298 insertions(+), 23810 deletions(-)
 delete mode 100644 firmware/bnx2x-e1-5.2.7.0.fw.ihex
 delete mode 100644 firmware/bnx2x-e1h-5.2.7.0.fw.ihex
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
