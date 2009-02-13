Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbZBMBRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbZBMBRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 20:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbZBMBRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 20:17:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40816
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbZBMBRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 20:17:23 -0500
Date: Thu, 12 Feb 2009 17:17:18 -0800 (PST)
Message-Id: <20090212.171718.267960145.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha id n1D1HiwM027432


Pushing this quickly to get the SO_BSDCOMPAT leak fix in there.
The bnx2 update looks huge, but that's due to a memory corruptor
requiring a firmware fix.

1) Can't use plain "u32" in user exported headers, fix from	
   Chuck Ebbert.

2) Wireless fixes via John Linville.

3) BNX2 memory corruption fixes from Michael Chan.

4) ATM fore200 driver OOPS fix on firmware load failure, from
   Meelis Roos.

5) Two phonet fixes, including a double free fix, from
   RÃ©mi Denis-Courmont.

6) Several off-by-one bug fixes from Roel Kluin.

7) SO_BSDCOMPATE getsockopt doesn't initialize the buffer it
   returns to userspace, fix from ClÃ©ment Lecigne.

8) QLGE driver bug fixes from Ron Mercer.

Please pull, thanks a lot!

The following changes since commit b578f3fcca1e78624dfb5f358776e63711d7fda2:
  Linus Torvalds (1):
        Merge git://git.infradead.org/users/cbou/battery-2.6.29

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Andrew Morton (2):
      net: don't use in_atomic() in gfp_any()
      Documentation/connector/cn_test.c: don't use gfp_any()

Bob Copeland (1):
      ath5k: fix bf->skb==NULL panic in ath5k_tasklet_rx

Chuck Ebbert (1):
      pkt_sched: type should be __u32 in header

ClÃ©ment Lecigne (1):
      net: 4 bytes kernel memory disclosure in SO_BSDCOMPAT gsopt try #2

Dhananjay Phadke (1):
      netxen: remove pcie workaround

Hin-Tak Leung (2):
      zd1211rw: adding 0ace:0xa211 as a ZD1211 device
      zd1211rw: treat MAXIM_NEW_RF(0x08) as UW2453_RF(0x09) for TP-Link WN322/422G

Inaky Perez-Gonzalez (1):
      wimax: fix oops in wimax_dev_get_by_genl_info() when looking up non-wimax iface

Johannes Berg (1):
      mac80211: restrict to AP in outgoing interface heuristic

Meelis Roos (2):
      fore200: fix oops on failed firmware load
      sunhme: Fix Quattro HME irq registration on proble failures

Michael Chan (4):
      bnx2: Update 5706/5708 firmware.
      bnx2: Update 5709 firmware.
      bnx2: Fix jumbo frames error handling.
      bnx2: Update version to 1.9.2 and copyright.

Paulius Zaleckas (1):
      mdio-gpio: Add mdc pin direction initialization

Reinette Chatre (1):
      iwlwifi: fix suspend/resume and its usage of pci saved state

Roel Kluin (4):
      TG3: limit reaches -1
      sun3: print when lance_open() fails
      IRDA: cnt is off by 1
      3c505: do not set pcb->data.raw beyond its size

Ron Mercer (7):
      qlge: bugfix: Use netif_receive_skb() and vlan_hwaccel_receive_skb().
      qlge: bugfix: Fix fatal error recovery hang.
      qlge: bugfix: Add missing put_page() call.
      qlge: bugfix: Add missing dev_kfree_skb_any() call.
      qlge: bugfix: Fix TSO breakage.
      qlge: bugfix: Fix RX scaling values.
      qlge: bugfix: Add missing rx buf clean index on early exit.

RÃ©mi Denis-Courmont (2):
      Phonet: fix double free in GPRS outbound packet error path
      Phonet: do not compute unused value

Yang Hongyang (1):
      netxen: fix compile waring "label â€˜set_32_bit_maskâ€™ defined but not used" on IA64 platform

 Documentation/connector/cn_test.c           |    6 +-
 drivers/atm/fore200e.c                      |    4 +-
 drivers/net/3c505.c                         |   26 +-
 drivers/net/bnx2.c                          |   36 +-
 drivers/net/bnx2.h                          |    2 +-
 drivers/net/bnx2_fw.h                       | 8515 +++++++++++++-------------
 drivers/net/bnx2_fw2.h                      | 8795 +++++++++++++--------------
 drivers/net/irda/mcs7780.c                  |    2 +-
 drivers/net/netxen/netxen_nic_main.c        |   66 +-
 drivers/net/phy/mdio-gpio.c                 |    2 +
 drivers/net/qlge/qlge_main.c                |   37 +-
 drivers/net/sun3lance.c                     |    2 +-
 drivers/net/sunhme.c                        |   34 +-
 drivers/net/tg3.c                           |    4 +-
 drivers/net/wireless/ath5k/base.c           |   85 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   15 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +-
 drivers/net/wireless/zd1211rw/zd_rf.c       |    1 +
 drivers/net/wireless/zd1211rw/zd_usb.c      |    1 +
 include/linux/pkt_sched.h                   |    2 +-
 include/net/sock.h                          |    2 +-
 net/core/sock.c                             |    2 +
 net/mac80211/tx.c                           |    2 +
 net/phonet/pep-gprs.c                       |    1 -
 net/phonet/pep.c                            |    2 +-
 net/wimax/id-table.c                        |    9 +-
 26 files changed, 8767 insertions(+), 8901 deletions(-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
