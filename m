Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbZDQTFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbZDQTFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZDQTEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:04:43 -0400
Received: from kroah.org ([198.145.64.141]:34574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755446AbZDQTEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:04:41 -0400
Date: Fri, 17 Apr 2009 12:01:48 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6.31-rc2 tree
Message-ID: <20090417190148.GC3548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some patches for your 2.6.31-rc2 git tree.

It contains:
	- more netdev_ops fixes
	- pohmelfs update to work properly now.
	- android binder driver fixes as found by Al Viro
	- other bugfixes and build fixes.

All of these are contained within the drivers/staging tree, and have
been in the linux-next and -mm trees for a while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

thanks,

greg k-h

--------------

 .../filesystems/pohmelfs/design_notes.txt          |    5 +-
 Documentation/filesystems/pohmelfs/info.txt        |   21 ++-
 drivers/staging/android/binder.c                   |  201 +++++++++++++++-----
 drivers/staging/at76_usb/at76_usb.c                |   20 ++-
 drivers/staging/epl/VirtualEthernetLinux.c         |   17 ++-
 drivers/staging/et131x/et131x_netdev.c             |   23 ++-
 drivers/staging/go7007/go7007-driver.c             |   15 --
 drivers/staging/go7007/wis-sony-tuner.c            |    2 +
 drivers/staging/line6/audio.c                      |    9 +-
 drivers/staging/otus/usbdrv.c                      |   47 +++--
 drivers/staging/otus/zdusb.c                       |    3 +-
 drivers/staging/otus/zdusb.h                       |    4 +
 drivers/staging/pohmelfs/config.c                  |   61 ++++++-
 drivers/staging/pohmelfs/dir.c                     |   24 ++--
 drivers/staging/pohmelfs/inode.c                   |  137 ++++++++++---
 drivers/staging/pohmelfs/lock.c                    |    3 +-
 drivers/staging/pohmelfs/net.c                     |   72 ++------
 drivers/staging/pohmelfs/netfs.h                   |   21 +-
 drivers/staging/pohmelfs/trans.c                   |   33 +--
 drivers/staging/rt2860/rt_main_dev.c               |   25 ++-
 drivers/staging/rt2870/rt2870.h                    |    1 +
 drivers/staging/rt2870/rt_main_dev.c               |   28 ++--
 drivers/staging/rt3070/rt_main_dev.c               |   29 ++--
 drivers/staging/slicoss/README                     |   31 +++-
 drivers/staging/slicoss/slicoss.c                  |   25 ++-
 drivers/staging/stlc45xx/Kconfig                   |    2 +-
 drivers/staging/sxg/sxg.c                          |  127 ++++++++----
 drivers/staging/uc2322/aten2011.c                  |   28 +---
 drivers/staging/wlan-ng/p80211netdev.c             |   20 ++-
 29 files changed, 663 insertions(+), 371 deletions(-)

---------------

Alan Cox (1):
      Staging: aten2011: Clean up some tty bits

Alexander Beregalov (11):
      Staging: at76: convert to netdev_ops
      Staging: epl: convert to netdev_ops
      Staging: et131x: convert to netdev_ops
      Staging: otus: convert to netdev_ops
      Staging: rt2860: convert to netdev_ops
      Staging: rt2870: convert to netdev_ops
      Staging: rt3070: convert to netdev_ops
      Staging: slicoss: convert to netdev_ops
      Staging: sxg: convert to netdev_ops
      Staging: wlan-ng: convert to netdev_ops
      Staging: line6: convert to snd_card_create()

Arve Hjønnevåg (8):
      Staging: binder: Remove VM_EXEC check.
      Staging: binder: Don't create two proc entries with the same name if the driver is opened twice in one process.
      Staging: binder: mmap fixes.
      Staging: binder: Add more offset validation.
      Staging: binder: Keep a reference to the files_struct while the driver is mmapped
      Staging: binder: Cast to uintptr_t instead of size_t when aligning pointers
      Staging: binder: Prevent the wrong thread from adding a transaction to the stack.
      Staging: binder: Defer flush and release operations to avoid deadlocks.

Daniele Napolitano (2):
      Staging: rt2870: add ID for Sitecom WL-315
      otus/zdusb.c: additional USB idnetifier

Evgeniy Polyakov (13):
      Staging: pohmelfs: Populate dentry cache when receiving the new readdir entry.
      Staging: Pohmelfs: Move parent lock to the place where we really have to send a lookup request to the server.
      Staging: Pohmelfs: Disable read lock in pohmelfs_getattr().
      Staging: Pohmelfs: Added 'need_lock' variable into debug print.
      Staging: Pohmelfs: Set NETFS_INODE_REMOTE_SYNCED and clear NETFS_INODE_OWNED bits in the root inode.
      Staging: Pohmelfs: Extend remount option.
      Staging: Pohmelfs: Sync fs before killing it, since dentry cache is shrunk before writeback is invoked via generic_shutdown_super()
      Staging: Pohmelfs: Reduce debugging noise about non-existing objects.
      Staging: Pohmelfs: Use wait_on_page_timeout when waiting for remote directory sync instead of hardcoded 25 seconds.
      Staging: Pohmelfs: Drop ftrans debugging code.
      Staging: Pohmelfs: Added ->show_stats() callback.
      Staging: Pohmelfs: Added IO permissions and priorities.
      Staging: Pohmelfs: Add load balancing between network states with the same priority.

Geert Uytterhoeven (1):
      Staging: STLC45XX should depend on GENERIC_HARDIRQS

Greg Kroah-Hartman (1):
      Staging: go7007: fix build issues

Lior Dotan (1):
      Revert Staging: SLICOSS: use gfp_kernel where possible

Mithlesh Thukral (4):
      Staging: sxg: Fire watchdog timer at end of open routine to change the link
      Staging: sxg: Use correct queue_id for transmitting non-TCP packets
      Staging: sxg: Fix sleep in atomic context warning while loading driver
      Staging: sxg: Fix leaks and checksum errors in transmit code path

Stephen Hemminger (1):
      staging: slicoss: update README

