Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYFPUor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYFPUor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbYFPUoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:44:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:39600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbYFPUog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:44:36 -0400
Date: Mon, 16 Jun 2008 13:43:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.7
Message-ID: <20080616204307.GA8924@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.7 kernel.

It contains a number of assorted bugfixes all over the tree.  Users are
encouraged to update.

I'll also be replying to this message with a copy of the patch between
2.6.25.6 and 2.6.25.7

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

--------

 Documentation/cciss.txt                   |    5 +
 Makefile                                  |    2 
 arch/x86/Kconfig                          |   23 +----
 drivers/block/brd.c                       |    1 
 drivers/block/cciss.c                     |   21 +++--
 drivers/char/pcmcia/ipwireless/hardware.c |   20 ++--
 drivers/cpufreq/cpufreq.c                 |    2 
 drivers/infiniband/core/umem.c            |    2 
 drivers/media/video/bt8xx/bttv-driver.c   |    2 
 drivers/media/video/videobuf-core.c       |    3 
 drivers/mmc/host/wbsd.c                   |   21 ++---
 drivers/net/cassini.c                     |   11 +-
 drivers/net/forcedeth.c                   |   20 ++++
 drivers/net/pppol2tp.c                    |  124 +++++++++++++++++++++++-------
 drivers/net/wireless/b43/main.c           |   12 ++
 drivers/serial/serial_core.c              |    5 -
 drivers/serial/sunhv.c                    |    1 
 drivers/ssb/driver_pcicore.c              |    4 
 drivers/video/hgafb.c                     |   26 +++---
 drivers/video/modedb.c                    |    1 
 fs/cifs/cifsfs.c                          |   21 ++---
 fs/ecryptfs/crypto.c                      |    2 
 fs/ecryptfs/file.c                        |    2 
 fs/ecryptfs/inode.c                       |   15 +--
 fs/pipe.c                                 |    3 
 include/asm-m68k/bitops.h                 |   46 ++++++++++-
 include/linux/pci_ids.h                   |    1 
 include/media/videobuf-core.h             |    3 
 include/net/netlink.h                     |   11 +-
 init/Kconfig                              |    1 
 net/8021q/vlan.c                          |    4 
 net/ax25/ax25_subr.c                      |   11 --
 net/bluetooth/rfcomm/core.c               |    2 
 net/bluetooth/rfcomm/tty.c                |   13 ++-
 net/can/raw.c                             |   21 ++---
 net/core/dev.c                            |    2 
 net/ipv4/route.c                          |    2 
 net/ipv4/tcp_cong.c                       |   12 +-
 net/ipv4/tcp_input.c                      |   65 ++++++++++-----
 net/ipv4/tcp_output.c                     |   10 +-
 net/ipv6/route.c                          |    2 
 net/key/af_key.c                          |    2 
 net/mac80211/ieee80211_sta.c              |    5 +
 net/sched/cls_api.c                       |    2 
 sound/pci/emu10k1/emu10k1_main.c          |   15 +--
 sound/pci/hda/patch_realtek.c             |    1 
 46 files changed, 387 insertions(+), 193 deletions(-)


Al Viro (1):
      double-free of inode on alloc_file() failure exit in create_write_pipe()

Aneesh Kumar K.V (1):
      m68k: Add ext2_find_{first,next}_bit() for ext4

Arjan van de Ven (3):
      bluetooth: fix locking bug in the rfcomm socket cleanup handling
      serial: fix enable_irq_wake/disable_irq_wake imbalance in serial_core.c
      bttv: Fix a deadlock in the bttv driver

Ayaz Abdulla (1):
      forcedeth: msi interrupts

Chris Wright (1):
      CPUFREQ: Fix format string bug.

Chuck Ebbert (1):
      mmc: wbsd: initialize tasklets before requesting interrupt

Cyrill Gorcunov (1):
      ecryptfs: fix missed mutex_unlock

Dan Williams (1):
      mac80211: send association event on IBSS create

Dave Young (1):
      bluetooth: rfcomm_dev_state_change deadlock fix

David S. Miller (2):
      sunhv: Fix locking in non-paged I/O case.
      cassini: Only use chip checksum for ipv4 packets.

David Sterba (1):
      ipwireless: Fix blocked sending

David Woodhouse (1):
      net: Fix call to ->change_rx_flags(dev, IFF_MULTICAST) in dev_change_flags()

Geoff Levand (1):
      fbdev: export symbol fb_mode_option

Greg Kroah-Hartman (1):
      Linux 2.6.25.7

Herbert Xu (1):
      ipsec: Use the correct ip_local_out function

Ilpo Järvinen (5):
      tcp: fix skb vs fack_count out-of-sync condition
      tcp FRTO: Fix fallback to conventional recovery
      tcp FRTO: SACK variant is errorneously used with NewReno
      tcp FRTO: work-around inorder receivers
      tcp: Fix inconsistency source (CA_Open only when !tcp_left_out(tp))

James Chapman (3):
      l2tp: avoid skb truesize bug if headroom is increased
      l2tp: Fix possible WARN_ON from socket code when UDP socket is closed
      l2tp: Fix possible oops if transmitting or receiving when tunnel goes down

Jarek Poplawski (1):
      ax25: Fix NULL pointer dereference and lockup.

Jaroslav Franek (1):
      sound: emu10k1 - fix system hang with Audigy2 ZS Notebook PCMCIA card

John Heffner (2):
      tcp: Allow send-limited cwnd to grow up to max_burst when gso disabled
      tcp: Limit cwnd growth when deferring for GSO

Kazunori MIYAZAWA (1):
      af_key: Fix selector family initialization.

Krzysztof Helt (1):
      hgafb: resource management fix

Marcin Slusarz (1):
      cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled

Michael Buesch (2):
      b43: Fix controller restart crash
      ssb: Fix context assertion in ssb_pcicore_dev_irqvecs_enable

Michael Halcrow (1):
      eCryptfs: protect crypt_stat->flags in ecryptfs_open()

Mike Miller (1):
      cciss: add new hardware support

Miklos Szeredi (2):
      ecryptfs: add missing lock around notify_change
      ecryptfs: clean up (un)lock_parent

Nick Piggin (1):
      Add 'rd' alias to new brd ramdisk driver

Patrick McHardy (2):
      net_sched: cls_api: fix return value for non-existant classifiers
      vlan: Correctly handle device notifications for layered VLAN devices

Roland Dreier (1):
      IB/umem: Avoid sign problems when demoting npages to integer

Roman Zippel (1):
      x86: fix recursive dependencies

Sam Ravnborg (2):
      can: Fix copy_from_user() results interpretation
      Kconfig: introduce ARCH_DEFCONFIG to DEFCONFIG_LIST

Sridhar Samudrala (1):
      tcp: TCP connection times out if ICMP frag needed is delayed

Takashi Iwai (1):
      ALSA: hda - Fix resume of auto-config mode with Realtek codecs

Thomas Graf (1):
      netlink: Fix nla_parse_nested_compat() to call nla_parse() directly

