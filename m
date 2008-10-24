Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYJXAhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYJXAhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJXAhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:37:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58024
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbYJXAhW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:37:22 -0400
Date: Thu, 23 Oct 2008 17:36:59 -0700 (PDT)
Message-Id: <20081023.173659.163744529.davem@davemloft.net>
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


Several bug fixes, highlights:

1) MAC address tweaks for r8169 from Francois Romieu

2) Netdev feature flag handling bug fix from Herbert Xu.

3) Two TCP bug fixes from Ilpo Järvinen.

   In particular the change of the ordering of TCP options advertised
   broke some communication paths.  That's bogus for an intermediate
   device to choke on that, but it doesn't cost us anything to fix
   this and be interoperable.

4) SCTP rfc conformance fixes from Wei Yongjun.

5) TX corruption fix in IGB from Alexander Duyck.

Please pull, thanks a lot!

The following changes since commit 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4:
  Paul Mundt (1):
        binfmt_elf_fdpic: Update for cputime changes.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alexander Duyck (1):
      igb: fix tx data corruption with transition to L0s on 82575

Andrey Borzenkov (1):
      orinoco: reduce stack usage in firmware download path

Atsushi Nemoto (1):
      net: Make SMC91X selectable on other MIPS boards

Bob Copeland (1):
      ath5k: fix suspend-related oops on rmmod

Brice Goglin (1):
      myri10ge: disable NAPI on failure to setup the interface

Bryan Wu (1):
      netdev: DM9000: remove BLACKFIN hacking in DM9000 netdev driver

Catalin Marinas (3):
      smc911x: Allow Kconfig dependency on ARM
      smc911x: Add IRQ polarity configuration
      smc911x: Make the driver safer on SMP

Christian Lamparter (1):
      p54: enable 2.4/5GHz spectrum by eeprom bits.

David S. Miller (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

Dmitry Baryshkov (1):
      SMC911x: unbreak PXA builds

Francois Romieu (3):
      r8169: verbose mac address init
      r8169: checks against wrong mac addresse init
      sis190: add identifier for Atheros AR8021 PHY

Hannes Hering (1):
      ehea: Fix memory hotplug support

Herbert Xu (1):
      net: Fix disjunct computation of netdev features

Ilpo Järvinen (2):
      tcp: should use number of sack blocks instead of -1
      tcp: Restore ordering of TCP options for the sake of inter-operability

Jeff Kirsher (1):
      igb: add IGB_DCA instead of selecting INTEL_IOATDMA

Jon Smirl (1):
      [netdrvr] fec_mpc52xx: Implement polling, to make netconsole work.

Roland Dreier (1):
      cxgb3: Fix kernel crash caused by uninitialized l2t_entry.arpq

Ron Mercer (1):
      qlge: Fix MSI/legacy single interrupt bug.

Stephen Hemminger (1):
      8139x: reduce message severity on driver overlap

Wei Yongjun (4):
      sctp: Drop ICMP packet too big message with MTU larger than current PMTU
      sctp: Add check for the TSN field of the SHUTDOWN chunk
      sctp: Fix to handle SHUTDOWN in SHUTDOWN-PENDING state
      sctp: Fix to handle SHUTDOWN in SHUTDOWN_RECEIVED state

roel kluin (2):
      gianfar: fix handle errors returned by platform_get_irq*()
      AX88796: ax_probe() fix irq assignment

 drivers/net/8139cp.c                 |    5 +-
 drivers/net/8139too.c                |    5 +-
 drivers/net/Kconfig                  |    9 ++-
 drivers/net/ax88796.c                |    6 +-
 drivers/net/bonding/bond_main.c      |   16 +++-
 drivers/net/cxgb3/l2t.c              |    1 +
 drivers/net/dm9000.c                 |    9 --
 drivers/net/ehea/ehea.h              |    2 +-
 drivers/net/ehea/ehea_main.c         |   25 ++++---
 drivers/net/ehea/ehea_qmr.c          |  131 +++++++++++++++++++++++++--------
 drivers/net/ehea/ehea_qmr.h          |    2 +
 drivers/net/fec_mpc52xx.c            |   18 +++++
 drivers/net/gianfar.c                |   24 ++++--
 drivers/net/igb/igb_main.c           |   60 +++++++++++-----
 drivers/net/myri10ge/myri10ge.c      |    6 +-
 drivers/net/qlge/qlge.h              |    5 +-
 drivers/net/qlge/qlge_main.c         |   89 ++++++++++++-----------
 drivers/net/r8169.c                  |   38 ++++++++--
 drivers/net/sis190.c                 |    1 +
 drivers/net/smc911x.c                |   38 ++++-----
 drivers/net/smc911x.h                |    6 +-
 drivers/net/wireless/ath5k/base.c    |   27 +++++--
 drivers/net/wireless/ath5k/base.h    |    3 +-
 drivers/net/wireless/orinoco.c       |   42 +++++++---
 drivers/net/wireless/p54/p54common.c |   28 +++-----
 include/linux/netdevice.h            |   12 +++-
 include/linux/smc911x.h              |    1 +
 include/net/sctp/sm.h                |    1 +
 net/bridge/br_device.c               |    2 +-
 net/bridge/br_if.c                   |   14 +++-
 net/core/dev.c                       |  135 ++++++++++++++++++----------------
 net/ipv4/tcp_output.c                |   25 +++++--
 net/sctp/input.c                     |    2 +-
 net/sctp/sm_statefuns.c              |   54 ++++++++++++++
 net/sctp/sm_statetable.c             |    4 +-
 35 files changed, 556 insertions(+), 290 deletions(-)
