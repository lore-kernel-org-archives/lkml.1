Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYHHGVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYHHGVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYHHGUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:20:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34338
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755818AbYHHGUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:20:30 -0400
Date: Thu, 07 Aug 2008 23:20:31 -0700 (PDT)
Message-Id: <20080807.232031.225155623.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m786Lidq016393


The bulk of the changes in here are wireless and wired driver updates
and fixes.  And finally the ath9k wireless driver seems ready to go.
Other highlights:

1) Andrew Haley noticed we had this code in TCP of the form:

		if (condition)
			foo();

			bar();
			baz();

   ie. with completely wrong indentation for many lines after the
   conditional.

2) Two packet scheduler fixes (more multiqueue fallout) based upon
   bug reports by Stephen Hemminger:

   a) Code was testing for root qdisc ID of "zero" instead of the
      correct TC_H_ROOT

   b) The new code didn't allow modifying qdisc configuration properly
      when the device or link was down.  This was merely cases of using
      dev_queue->qdisc when we should have used dev_queue->qdisc_sleeping

3) Jamal Hadi Salim fixes a reference counting issue in traffic
   classifier actions.

4) Joakim Koskela, with help from Herbert Xu, fixes IPSEC BEET tunnel
   handling.

5) Addition of the ATH9K driver, of course.  Part of this are two
   linux/list.h changes, but those were reviewed on lkml.

Please pull, thanks a lot!

The following changes since commit 0967d61ea0d8e8a7826bd8949cd93dd1e829ac55:
  Linus Torvalds (1):
        Linux 2.6.27-rc2

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Adam Langley (1):
      tcp: (whitespace only) fix confusing indentation

Adrian Bunk (2):
      remove bogus CONFIG_GFAR_NAPI's
      ath9k: work around gcc ICEs

Alexander Duyck (6):
      igb: fix comments
      igb: fix null pointer dereference seen with fiber NICs
      igb: fixes 82576 serdes init to correctly support manual flow control changes
      igb: correct issue of set_mta member of mac.ops not being populated
      igb: remove three redundant functions left in the code
      igb: remove igb_init_managability as it is deprecated

Andrew Morton (1):
      drivers/net/netxen/netxen_nic_hw.c: fix printk warnings

Auke Kok (1):
      e1000e: perform basic 82573 EEPROM checks for known issues

Ayaz Abdulla (4):
      forcedeth: fix rx error policy
      forcedeth: add new tx stat counters
      forcedeth: add jumbo frame support for mcp79
      forcedeth: add tx pause limit

Ben Collins (1):
      pegasus: add blacklist support to fix Belkin bluetooth dongle.

Brandon Philips (1):
      ethtool: Expand ethtool_cmd.speed to 32 bits

Brice Goglin (2):
      myri10ge: update firmware headers
      myri10ge: set 64bits consistent DMA mask

Bruce Allan (1):
      e1000e: remove inapplicable test for ioport

Christian Lamparter (1):
      p54: swap short slot time dcf values

David S. Miller (6):
      ipv4: Fix over-ifdeffing of ip_static_sysctl_init.
      pkt_sched: Fix "parent is root" test in qdisc_create().
      Merge branch 'upstream-davem' of master.kernel.org:/.../jgarzik/netdev-2.6
      Merge branch 'ath9k' of git://git.kernel.org/.../linville/wireless-2.6
      pkt_sched: Fix qdisc config when link is down.
      Merge branch 'master' of git://git.kernel.org/.../holtmann/bluetooth-2.6

Dhananjay Phadke (5):
      netxen: fix link status, link speed
      netxen: add new board types
      netxen: fix legacy interrupts
      netxen: fix cmd ring init
      netxen: fix promisc mode, mtu setting

Eduardo Habkost (1):
      xen-netfront: use netif_start_queue() on xennet_open()

Eugene Teo (1):
      hamradio: add missing sanity check to tty operation

Francois Romieu (2):
      via-velocity: separated struct allow wholesale copy during MTU changes.
      via-velocity: velocity_init_{rd/tx}_ring use kcalloc(..., GFP_KERNEL).

Gui Jianfeng (1):
      tcp: Fix kernel panic when calling tcp_v(4/6)_md5_do_lookup

Gustavo F. Padovan (3):
      drivers/net: Remove 'return' of void function NS8390p_init()
      drivers/net: coding styles fixes to drivers/net/8390p.c
      drivers/net: coding styles fixes to drivers/net/8390.c

Ivo van Doorn (1):
      rt2x00: Block all unsupported modes

Jamal Hadi Salim (1):
      pkt_sched: Fix actions referencing

Jay Cliburn (1):
      atl1: deal with hardware rx checksum bug

Jay Vosburgh (1):
      bonding: refactor mii monitor

Jeff Garzik (2):
      Merge branch 'via-velocity' of git://git.kernel.org/.../romieu/netdev-2.6 into tmp
      Merge branch 'for-jeff' of git://git.kernel.org/.../chris/linux-2.6 into tmp

Jeff Kirsher (1):
      e1000e: convert ndev_ printks to something smaller

Jesse Brandeburg (1):
      e1000e: fix drv load issues

Joakim Koskela (2):
      ipsec: Interfamily IPSec BEET
      ipsec: Interfamily IPSec BEET, ipv4-inner ipv6-outer

Joe Eykholt (3):
      net/core: Uninline skb_bond().
      net/core: Allow certain receives on inactive slave.
      net/core: Allow receive on active slaves.

Krzysztof Halasa (1):
      WAN: remove extra help text from HDLC_PPP config option

Krzysztof Ha≈Çasa (15):
      WAN: cosmetic changes to generic HDLC
      Remove bogus dosyncppp variable from synclink drivers.
      Remove bogus variables from syncppp.[ch]
      Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist
      wanmain.c doesn't need syncppp.h
      WAN: Remove unneeded "#include <net/syncppp.h>"
      WAN: Remove dead code from PC300 driver, part #1
      WAN: Remove dead code from PC300 driver, part #2
      WAN: Convert PC300 driver to use normal u8/u16/u32 types
      WAN: farsync driver no longer uses syncppp.c directly
      WAN: Port COSA driver to generic HDLC.
      WAN: Convert Zilog-based drivers to generic HDLC
      WAN: Port LMC driver to generic HDLC
      WAN: don't mention syncppp in z8530 DocBook.
      WAN: Use u32 type instead of u_int32_t in LMC driver.

Krzysztof Piotr Oledzki (1):
      netfilter: fix two recent sysctl problems

Larry Finger (1):
      p54: Fix for TX sequence number problem

Laurent Pinchart (1):
      dm9000: Support MAC address setting through platform data.

Li Yang (1):
      net/fs_enet: remove redundant messages for performance

Luis Carlos Cobo (2):
      mac80211: fix use of skb->cb for mesh forwarding
      mac80211: keep mesh ifaces in allmulti mode

Luis R. Rodriguez (4):
      list.h: Add list_splice_tail() and list_splice_tail_init()
      list.h: add list_cut_position()
      ath5k: remove Atheros 11n devices from supported list
      ath9k: Add new Atheros IEEE 802.11n driver

Marcel Holtmann (3):
      [Bluetooth] Add parameters to control BNEP header compression
      [Bluetooth] Removal of unnecessary ignore module parameter
      [Bluetooth] Add full quirk implementation for btusb driver

Moni Shoua (1):
      bonding: Don't destroy bonding master when removing slave via sysfs

Rami Rosen (2):
      ipv4: replace dst_metric() with dst_mtu() in net/ipv4/route.c.
      ipv6: replace dst_metric() with dst_mtu() in net/ipv6/route.c.

Randy Dunlap (1):
      bnx2x: fix logical op

Robert Olsson (1):
      pktgen: multiqueue etc.

Ron Mercer (4):
      qla3xxx: fix: Remove unused set_multicast function.
      qla3xxx: fix: Fix IFF_MULTICAST setting.
      qla3xxx: cleanup: Remove some unused defined constants in the header file.
      qla3xxx: cleanup: Remove some unused structure definitions and structure elements.

Stephen Hemminger (2):
      sky2: fix PM related regressions
      3c59x: use netdev_alloc_skb

Sujith (6):
      ath9k: Cleanup data structures related to HW capabilities
      ath9k: Remove redundant data structure ath9k_txq_info
      ath9k: Use mac80211's band macros and remove enum hal_freq_band
      ath9k: Remove a few unused macros and fix indentation
      ath9k: More unused macros
      ath9k: Revamp wireless mode usage

Thomas Bogendoerfer (1):
      METH: fix MAC address setup

Tomas Winkler (1):
      iwlwifi: cleanup iwl_tx_skb

Wang Chen (1):
      [netdrvr] Drivers should not set IFF_* flag themselves

Yoshinori Sato (1):
      [netdrvr] sh_eth: Add SH7619 support

root (1):
      qla3xxx: driver version change.

 Documentation/DocBook/z8530book.tmpl           |   38 +-
 MAINTAINERS                                    |    9 +
 arch/sh/include/asm/sh_eth.h                   |   11 +
 drivers/bluetooth/bcm203x.c                    |    9 +-
 drivers/bluetooth/bfusb.c                      |   10 +-
 drivers/bluetooth/bpa10x.c                     |   10 +-
 drivers/bluetooth/btusb.c                      |  163 +-
 drivers/bluetooth/hci_usb.c                    |    8 +-
 drivers/char/pcmcia/synclink_cs.c              |    4 -
 drivers/char/synclink.c                        |    4 -
 drivers/char/synclink_gt.c                     |    5 -
 drivers/char/synclinkmp.c                      |    4 -
 drivers/dma/ioat_dma.c                         |    2 +-
 drivers/net/3c523.c                            |    4 +-
 drivers/net/3c527.c                            |    9 +-
 drivers/net/3c59x.c                            |   14 +-
 drivers/net/8390.c                             |   13 +-
 drivers/net/8390p.c                            |   19 +-
 drivers/net/Kconfig                            |    5 +-
 drivers/net/atlx/atl1.c                        |   19 +-
 drivers/net/atp.c                              |    9 +-
 drivers/net/bnx2x_main.c                       |    2 +-
 drivers/net/bonding/bond_3ad.c                 |    1 +
 drivers/net/bonding/bond_main.c                |  398 +-
 drivers/net/bonding/bond_sysfs.c               |    3 -
 drivers/net/de620.c                            |    7 -
 drivers/net/dm9000.c                           |    5 +
 drivers/net/e1000e/e1000.h                     |   31 +-
 drivers/net/e1000e/ethtool.c                   |   44 +-
 drivers/net/e1000e/netdev.c                    |  246 +-
 drivers/net/e1000e/param.c                     |   31 +-
 drivers/net/eepro.c                            |    8 -
 drivers/net/eth16i.c                           |    1 -
 drivers/net/forcedeth.c                        |  110 +-
 drivers/net/fs_enet/mac-fcc.c                  |    2 +-
 drivers/net/gianfar.c                          |    4 -
 drivers/net/hamradio/mkiss.c                   |    2 +-
 drivers/net/igb/e1000_82575.c                  |   72 +-
 drivers/net/igb/e1000_82575.h                  |    1 -
 drivers/net/igb/e1000_defines.h                |    1 +
 drivers/net/igb/e1000_hw.h                     |    1 -
 drivers/net/igb/e1000_mac.c                    |   84 +-
 drivers/net/igb/e1000_mac.h                    |    5 +-
 drivers/net/igb/e1000_regs.h                   |    3 -
 drivers/net/igb/igb_main.c                     |   30 +-
 drivers/net/lp486e.c                           |    2 -
 drivers/net/meth.c                             |    2 +-
 drivers/net/myri10ge/myri10ge.c                |    1 +
 drivers/net/myri10ge/myri10ge_mcp.h            |   52 +-
 drivers/net/myri10ge/myri10ge_mcp_gen_header.h |    2 +-
 drivers/net/netxen/netxen_nic.h                |   41 +-
 drivers/net/netxen/netxen_nic_ctx.c            |    9 +-
 drivers/net/netxen/netxen_nic_ethtool.c        |   35 +-
 drivers/net/netxen/netxen_nic_hdr.h            |   10 +
 drivers/net/netxen/netxen_nic_hw.c             |  103 +-
 drivers/net/netxen/netxen_nic_hw.h             |   13 +-
 drivers/net/netxen/netxen_nic_init.c           |    5 +
 drivers/net/netxen/netxen_nic_main.c           |   99 +-
 drivers/net/netxen/netxen_nic_niu.c            |   16 +-
 drivers/net/netxen/netxen_nic_phan_reg.h       |    4 +-
 drivers/net/ni5010.c                           |    1 -
 drivers/net/ni52.c                             |    2 +-
 drivers/net/qla3xxx.c                          |   23 +-
 drivers/net/qla3xxx.h                          |  105 -
 drivers/net/sh_eth.c                           |   69 +-
 drivers/net/sh_eth.h                           |   22 +-
 drivers/net/sky2.c                             |  103 +-
 drivers/net/sky2.h                             |    2 -
 drivers/net/sun3_82586.c                       |    7 +-
 drivers/net/usb/pegasus.c                      |   21 +
 drivers/net/via-velocity.c                     |  301 +-
 drivers/net/via-velocity.h                     |   50 +-
 drivers/net/wan/Kconfig                        |   15 +-
 drivers/net/wan/Makefile                       |   11 +-
 drivers/net/wan/cosa.c                         |  293 +-
 drivers/net/wan/dscc4.c                        |    1 -
 drivers/net/wan/farsync.c                      |    5 +-
 drivers/net/wan/farsync.h                      |    6 -
 drivers/net/wan/hdlc.c                         |   25 +-
 drivers/net/wan/hdlc_cisco.c                   |   29 +-
 drivers/net/wan/hdlc_fr.c                      |   19 +-
 drivers/net/wan/hdlc_ppp.c                     |   15 +-
 drivers/net/wan/hdlc_raw.c                     |   15 +-
 drivers/net/wan/hdlc_raw_eth.c                 |   17 +-
 drivers/net/wan/hdlc_x25.c                     |   17 +-
 drivers/net/wan/hostess_sv11.c                 |  382 +-
 drivers/net/wan/lmc/lmc.h                      |   11 +-
 drivers/net/wan/lmc/lmc_debug.c                |    7 +-
 drivers/net/wan/lmc/lmc_debug.h                |    6 +-
 drivers/net/wan/lmc/lmc_ioctl.h                |    2 +-
 drivers/net/wan/lmc/lmc_main.c                 |  672 +--
 drivers/net/wan/lmc/lmc_media.c                |   66 +-
 drivers/net/wan/lmc/lmc_proto.c                |  146 +-
 drivers/net/wan/lmc/lmc_proto.h                |   14 +-
 drivers/net/wan/lmc/lmc_var.h                  |  360 +-
 drivers/net/wan/pc300.h                        |  228 +-
 drivers/net/wan/pc300_drv.c                    |  146 +-
 drivers/net/wan/sealevel.c                     |  361 +-
 drivers/net/wan/syncppp.c                      |    9 -
 drivers/net/wan/z85230.c                       |  193 +-
 drivers/net/wan/z85230.h                       |   10 +-
 drivers/net/wireless/Kconfig                   |    1 +
 drivers/net/wireless/Makefile                  |    1 +
 drivers/net/wireless/ath5k/base.c              |    2 -
 drivers/net/wireless/ath9k/Kconfig             |    8 +
 drivers/net/wireless/ath9k/Makefile            |   11 +
 drivers/net/wireless/ath9k/ath9k.h             | 1021 +++
 drivers/net/wireless/ath9k/beacon.c            |  979 +++
 drivers/net/wireless/ath9k/core.c              | 1923 ++++++
 drivers/net/wireless/ath9k/core.h              | 1072 +++
 drivers/net/wireless/ath9k/hw.c                | 8571 ++++++++++++++++++++++++
 drivers/net/wireless/ath9k/hw.h                |  969 +++
 drivers/net/wireless/ath9k/initvals.h          | 3146 +++++++++
 drivers/net/wireless/ath9k/main.c              | 1470 ++++
 drivers/net/wireless/ath9k/phy.c               |  436 ++
 drivers/net/wireless/ath9k/phy.h               |  543 ++
 drivers/net/wireless/ath9k/rc.c                | 2126 ++++++
 drivers/net/wireless/ath9k/rc.h                |  316 +
 drivers/net/wireless/ath9k/recv.c              | 1318 ++++
 drivers/net/wireless/ath9k/reg.h               | 1385 ++++
 drivers/net/wireless/ath9k/regd.c              | 1026 +++
 drivers/net/wireless/ath9k/regd.h              |  412 ++
 drivers/net/wireless/ath9k/regd_common.h       | 1915 ++++++
 drivers/net/wireless/ath9k/xmit.c              | 2871 ++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c          |   40 +-
 drivers/net/wireless/orinoco.c                 |    7 -
 drivers/net/wireless/p54/p54.h                 |    1 +
 drivers/net/wireless/p54/p54common.c           |   18 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c        |   54 +-
 drivers/net/wireless/wavelan.c                 |    3 -
 drivers/net/wireless/wavelan_cs.c              |    6 -
 drivers/net/xen-netfront.c                     |    2 +-
 drivers/usb/host/ehci-q.c                      |    2 +-
 include/linux/dm9000.h                         |    1 +
 include/linux/ethtool.h                        |   17 +-
 include/linux/list.h                           |   87 +-
 include/net/request_sock.h                     |    2 +-
 include/net/syncppp.h                          |    2 -
 net/bluetooth/bnep/core.c                      |   15 +-
 net/core/dev.c                                 |   35 +-
 net/core/pktgen.c                              |   37 +-
 net/dccp/dccp.h                                |    3 +-
 net/dccp/minisocks.c                           |    3 +-
 net/ipv4/esp4.c                                |    2 +-
 net/ipv4/route.c                               |   12 +-
 net/ipv4/tcp_ipv4.c                            |    4 +-
 net/ipv4/tcp_minisocks.c                       |  140 +-
 net/ipv4/xfrm4_mode_beet.c                     |    6 +-
 net/ipv6/esp6.c                                |    4 +
 net/ipv6/route.c                               |    2 +-
 net/ipv6/tcp_ipv6.c                            |    8 +-
 net/ipv6/xfrm6_mode_beet.c                     |   27 +-
 net/mac80211/main.c                            |    8 +-
 net/mac80211/mesh.h                            |    5 +-
 net/mac80211/mesh_hwmp.c                       |   19 +-
 net/mac80211/mesh_pathtbl.c                    |   11 +-
 net/mac80211/rx.c                              |  116 +-
 net/mac80211/tx.c                              |   45 +-
 net/netfilter/nf_conntrack_core.c              |    6 +-
 net/netfilter/nf_conntrack_standalone.c        |   28 +-
 net/sched/act_api.c                            |    5 +-
 net/sched/sch_api.c                            |   10 +-
 net/wanrouter/wanmain.c                        |   27 -
 165 files changed, 34487 insertions(+), 3504 deletions(-)
 create mode 100644 arch/sh/include/asm/sh_eth.h
 create mode 100644 drivers/net/wireless/ath9k/Kconfig
 create mode 100644 drivers/net/wireless/ath9k/Makefile
 create mode 100644 drivers/net/wireless/ath9k/ath9k.h
 create mode 100644 drivers/net/wireless/ath9k/beacon.c
 create mode 100644 drivers/net/wireless/ath9k/core.c
 create mode 100644 drivers/net/wireless/ath9k/core.h
 create mode 100644 drivers/net/wireless/ath9k/hw.c
 create mode 100644 drivers/net/wireless/ath9k/hw.h
 create mode 100644 drivers/net/wireless/ath9k/initvals.h
 create mode 100644 drivers/net/wireless/ath9k/main.c
 create mode 100644 drivers/net/wireless/ath9k/phy.c
 create mode 100644 drivers/net/wireless/ath9k/phy.h
 create mode 100644 drivers/net/wireless/ath9k/rc.c
 create mode 100644 drivers/net/wireless/ath9k/rc.h
 create mode 100644 drivers/net/wireless/ath9k/recv.c
 create mode 100644 drivers/net/wireless/ath9k/reg.h
 create mode 100644 drivers/net/wireless/ath9k/regd.c
 create mode 100644 drivers/net/wireless/ath9k/regd.h
 create mode 100644 drivers/net/wireless/ath9k/regd_common.h
 create mode 100644 drivers/net/wireless/ath9k/xmit.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
