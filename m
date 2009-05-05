Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZEEFqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZEEFqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 01:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZEEFqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 01:46:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44194
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975AbZEEFqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 01:46:34 -0400
Date: Mon, 04 May 2009 22:46:28 -0700 (PDT)
Message-Id: <20090504.224628.160654802.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n455lGqu029578


1) virtio_net fixes:

   Garbage in on-stack scatterlist entries.
   Missing include breaks some builds.

2) Unloading network device driver can hang because netconsole doesn't
   properly listen for unregister events.

3) skb_tx_hash()'s hash distribution regressed in 2.6.30 hurting performance
   for forwarding workloads.

4) EHEA oops fixes.

5) splice() skb->sk oops fix, regression from 2.6.29.

6) ALB mode locking in bonding driver is busted.

7) Netfilter's xt_socket has broken Kconfig deps, causing build bustage.

8) ne2k-pci registers devices too early, before it sets the MAC
   address in the netdevice structure.

9) New CDC EEM USB network driver.

10) New smsc95xx device IDs and unbolix LEDs.

11) Packet classifier filter stores priorities wrongly such that deletion
    of entries becomes impossible.

12) TCP uses wrong RTO (constant TCP_RTO_MIN, instead of what the stack
    has computed over time) in tcp_prequeue().

13) Several wireless (modprobe deadlock in mac80211, ath5k debugging code
    buffer overrun) and bluetooth (sysfs synchronization problems wrt.
    workqueues) fixes.

14) br2684 ATM driver is busted due to error in netdev_ops conversion.

Please pull, thanks a lot!

The following changes since commit b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alan Jenkins (1):
      mac80211: fix modprobe deadlock by not calling wep_init under rtnl_lock

Alex Williamson (2):
      virtio_net: Cleanup command queue scatterlist usage
      virtio_net: Fix function name typo

Bob Copeland (1):
      ath5k: fix buffer overrun in rate debug code

Bruno Pr√©mont (1):
      netconsole: take care of NETDEV_UNREGISTER event

David S. Miller (2):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../holtmann/bluetooth-2.6

Eric Dumazet (3):
      net: Fix skb_tx_hash() for forwarding workloads.
      netfilter: use likely() in xt_info_rdlock_bh()
      bonding: bond_slave_info_query() fix

Grant Likely (1):
      virtio: add missing include to virtio_net.h

Hannes Hering (1):
      ehea: fix invalid pointer access

Jarek Poplawski (1):
      net: Fix oops when splicing skbs from a frag_list.

Jay Vosburgh (1):
      bonding: fix alb mode locking regression

Jesse Brandeburg (1):
      e1000: fix virtualization bug

Jiri Pirko (1):
      bonding: correct the cleanup in bond_create()

Johannes Berg (2):
      iwlwifi: notify on scan completion even when shutting down
      mac80211: default to automatic power control

Jussi Kivilinna (1):
      rndis_wlan: fix initialization order for workqueue&workers

Laszlo Attila Toth (1):
      xt_socket: checks for the state of nf_conntrack

Lennert Buytenhek (2):
      mv643xx_eth: OOM handling fixes
      mv643xx_eth: 64bit mib counter read fix

Lubomir Rintel (1):
      ne2k-pci: Do not register device until initialized.

Marcel Holtmann (1):
      Bluetooth: Fix issue with sysfs handling for connections

Omar Laazimani (1):
      usbnet: CDC EEM support (v5)

Rabin Vincent (1):
      Subject: [PATCH] br2684: restore net_dev initialization

Robert Love (1):
      net: Only store high 16 bits of kernel generated filter priorities

Satoru SATOH (1):
      tcp: Fix tcp_prequeue() to get correct rto_min value

Sergey Senozhatsky (1):
      cxgb3: fixing gcc 4.4 compiler warning: suggest parentheses around operand of ‚Äò!‚Äô

Stephen Rothwell (1):
      wireless: remove unneeded EXPORT_SYMBOL the tickles a powerpc compiler bug

Steve Glendinning (2):
      smsc95xx: configure LED outputs
      smsc95xx: add support for LAN9512 and LAN9514

 drivers/net/bonding/bond_alb.c              |   12 +-
 drivers/net/bonding/bond_main.c             |   36 +--
 drivers/net/cxgb3/t3_hw.c                   |    2 +-
 drivers/net/e1000/e1000_main.c              |    2 +-
 drivers/net/ehea/ehea.h                     |    2 +-
 drivers/net/ehea/ehea_main.c                |   31 ++-
 drivers/net/mv643xx_eth.c                   |   24 +-
 drivers/net/ne2k-pci.c                      |    7 +-
 drivers/net/netconsole.c                    |   11 +-
 drivers/net/usb/Kconfig                     |   14 +
 drivers/net/usb/Makefile                    |    1 +
 drivers/net/usb/cdc_eem.c                   |  381 +++++++++++++++++++++++++++
 drivers/net/usb/smsc95xx.c                  |   15 +
 drivers/net/usb/smsc95xx.h                  |    3 +
 drivers/net/virtio_net.c                    |   24 +-
 drivers/net/wireless/ath5k/debug.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 drivers/net/wireless/rndis_wlan.c           |   14 +-
 include/linux/netfilter/x_tables.h          |    4 +-
 include/linux/usb/cdc.h                     |    3 +
 include/linux/virtio_net.h                  |    1 +
 include/net/bluetooth/hci_core.h            |    1 +
 include/net/tcp.h                           |   14 +-
 net/atm/br2684.c                            |    1 +
 net/bluetooth/hci_conn.c                    |    2 +
 net/bluetooth/hci_sysfs.c                   |   74 +++---
 net/core/dev.c                              |    9 +-
 net/core/skbuff.c                           |   27 +-
 net/ipv4/tcp_input.c                        |   10 -
 net/mac80211/main.c                         |   20 +-
 net/netfilter/Kconfig                       |    1 +
 net/sched/cls_api.c                         |    2 +-
 33 files changed, 598 insertions(+), 157 deletions(-)
 create mode 100644 drivers/net/usb/cdc_eem.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
