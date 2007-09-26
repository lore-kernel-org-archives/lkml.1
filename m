Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXIZSRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXIZSRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbXIZSRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:17:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57229 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbXIZSRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:17:30 -0400
Date: Wed, 26 Sep 2007 11:12:00 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.9
Message-ID: <20070926181200.GA3589@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.9 kernel.
It fixes a number of reported bugs, and any user of the 2.6.22 series is
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.8 and 2.6.22.9

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Documentation/dvb/get_dvb_firmware           |   26 ++++-----
 Makefile                                     |    2 
 arch/powerpc/kernel/process.c                |    6 +-
 arch/sparc64/kernel/pci.c                    |   13 ++++
 block/ll_rw_blk.c                            |   13 ++--
 crypto/blkcipher.c                           |   11 ++--
 drivers/acpi/tables/tbutils.c                |   71 ++++++++++++++++++++++++++
 drivers/block/DAC960.c                       |   18 ++++--
 drivers/block/DAC960.h                       |    7 --
 drivers/firewire/fw-ohci.c                   |   10 +--
 drivers/hwmon/lm78.c                         |    2 
 drivers/hwmon/w83781d.c                      |    2 
 drivers/ieee1394/ieee1394_core.c             |    2 
 drivers/ieee1394/ohci1394.c                  |    4 -
 drivers/media/dvb/b2c2/flexcop-i2c.c         |    7 ++
 drivers/media/video/cx88/cx88-mpeg.c         |    2 
 drivers/media/video/ivtv/ivtv-ioctl.c        |    1 
 drivers/media/video/pwc/pwc-if.c             |    2 
 drivers/mtd/Makefile                         |    2 
 drivers/mtd/mtdpart.c                        |    4 -
 drivers/mtd/mtdsuper.c                       |    2 
 drivers/net/forcedeth.c                      |    2 
 drivers/net/wireless/bcm43xx/bcm43xx_main.c  |   28 +++++++---
 drivers/net/wireless/bcm43xx/bcm43xx_main.h  |    2 
 drivers/net/wireless/bcm43xx/bcm43xx_sysfs.c |    2 
 drivers/scsi/3w-9xxx.c                       |   18 ++++--
 drivers/usb/core/driver.c                    |    2 
 fs/afs/mntpt.c                               |    2 
 fs/ext3/namei.c                              |   73 ++++++++++++++++++++++++---
 fs/ext4/namei.c                              |   73 ++++++++++++++++++++++++---
 fs/jffs2/fs.c                                |    2 
 fs/locks.c                                   |    2 
 fs/nfs/super.c                               |    2 
 fs/splice.c                                  |    4 -
 include/linux/Kbuild                         |    1 
 init/Kconfig                                 |    1 
 kernel/futex_compat.c                        |    4 -
 kernel/signal.c                              |   19 +++----
 kernel/sys.c                                 |    3 -
 net/8021q/vlan_dev.c                         |   12 ++++
 net/bridge/br_netfilter.c                    |   12 ++--
 net/core/datagram.c                          |    3 +
 net/core/pktgen.c                            |   10 +++
 net/decnet/dn_dev.c                          |    2 
 net/ipv4/ah4.c                               |    2 
 net/ipv4/devinet.c                           |    2 
 net/ipv4/inet_diag.c                         |    4 +
 net/ipv4/tcp_input.c                         |   21 +++++--
 net/ipv6/addrconf.c                          |    2 
 net/ipv6/ip6_output.c                        |    5 +
 net/ipv6/ndisc.c                             |    2 
 net/ipv6/raw.c                               |    3 -
 net/sunrpc/svcsock.c                         |    6 +-
 scripts/kconfig/conf.c                       |   21 ++++---
 54 files changed, 405 insertions(+), 149 deletions(-)

Summary of changes from v2.6.22.8 to v2.6.22.9
==============================================

Adam Radford (1):
      3w-9xxx: Fix dma mask setting

Adit Ranadive (1):
      Fix pktgen src_mac handling.

Alexey Dobriyan (1):
      nfs: fix oops re sysctls and V4 support

Andreas Arens (1):
      DVB: get_dvb_firmware: update script for new location of tda10046 firmware

Andreas Gruenbacher (1):
      afs: mntput called before dput

Andrew Morton (2):
      disable sys_timerfd()
      Fix "Fix DAC960 driver on machines which don't support 64-bit DMA"

Arnd Bergmann (1):
      futex_compat: fix list traversal bugs

David Howells (1):
      MTD: Initialise s_flags in get_sb_mtd_aux()

David Miller (1):
      Fix sparc64 v100 platform booting.

Denis V. Lunev (1):
      Fix IPV6 DAD handling

Eric Sandeen (2):
      ext34: ensure do_split leaves enough free space in both blocks
      dir_index: error out instead of BUG on corrupt dx dirs

Evgeniy Polyakov (1):
      Fix oops in vlan and bridging code

Greg Kroah-Hartman (1):
      Linux 2.6.22.9

Hans Verkuil (1):
      V4L: ivtv: fix VIDIOC_S_FBUF: new OSD values were never set

Herbert Xu (2):
      crypto: blkcipher_get_spot() handling of buffer at end of page
      Fix datagram recvmsg NULL iov handling regression.

Ilpo Järvinen (2):
      Handle snd_una in tcp_cwnd_down()
      Fix TCP DSACK cwnd handling

Jason Lunz (1):
      JFFS2: fix write deadlock regression

Jean Delvare (2):
      hwmon: End of I/O region off-by-one
      Fix debug regression in video/pwc

Jens Axboe (2):
      splice: fix direct splice error handling
      Fix race with shared tag queue maps

Jiri Kosina (1):
      Fix ipv6 source address handling.

Kumar Gala (1):
      POWERPC: Flush registers to proper task context

Larry Finger (1):
      bcm43xx: Fix cancellation of work queue crashes

Matthew Wilcox (1):
      Fix DAC960 driver on machines which don't support 64-bit DMA

Michael Krufky (1):
      DVB: get_dvb_firmware: update script for new location of sp8870 firmware

Nathael Pajani (1):
      USB: fix linked list insertion bugfix for usb core

Neil Brown (1):
      Correctly close old nfsd/lockd sockets.

Nick Bowler (1):
      Fix IPSEC AH4 options handling

Oleg Nesterov (2):
      setpgid(child) fails if the child was forked by sub-thread
      sigqueue_free: fix the race with collect_signal()

Patrick McHardy (2):
      Fix decnet device address listing.
      Fix inet_diag OOPS.

Pavel Emelyanov (1):
      Leases can be hidden by flocks

Roman Zippel (1):
      kconfig: oldconfig shall not set symbols if it does not need to

Satyam Sharma (1):
      MTD: Makefile fix for mtdsuper

Stefan Richter (2):
      firewire: fw-ohci: ignore failure of pci_set_power_state (fix suspend regression)
      ieee1394: ohci1394: fix initialization if built non-modular

Stephen Hemminger (2):
      Fix device address listing for ipv4.
      Fix tc_ematch kbuild

Steven Toth (1):
      V4L: cx88: Avoid a NULL pointer dereference during mpeg_open()

Trent Piepho (1):
      DVB: b2c2-flexcop: fix Airstar HD5000 tuning regression

Willy Tarreau (1):
      fix realtek phy id in forcedeth

Wolfgang Walter (1):
      rpc: fix garbage in printk in svc_tcp_accept()

YOSHIFUJI Hideaki (2):
      Fix IPV6 append OOPS.
      Fix ipv6 double-sock-release with MSG_CONFIRM

Zhao Yakui (1):
      ACPI: Validate XSDT, use RSDT if XSDT fails

