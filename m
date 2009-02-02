Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZBBS1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZBBS1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZBBS0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:26:48 -0500
Received: from kroah.org ([198.145.64.141]:48063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752945AbZBBS0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:26:47 -0500
Date: Mon, 2 Feb 2009 10:24:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.28.3
Message-ID: <20090202182439.GB7097@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.28.3
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.28.2 and 2.6.28.3

The updated 2.6.28.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 
 arch/alpha/kernel/irq_srm.c            |    2 
 arch/x86/include/asm/pgalloc.h         |    1 
 arch/x86/mm/pageattr.c                 |   49 ++++++++---
 arch/x86/mm/pat.c                      |   43 +++++++---
 crypto/async_tx/async_tx.c             |    2 
 crypto/authenc.c                       |   24 +++--
 crypto/ccm.c                           |    2 
 drivers/ata/pata_via.c                 |   22 ++++-
 drivers/gpio/gpiolib.c                 |    1 
 drivers/gpu/drm/drm_agpsupport.c       |    3 
 drivers/ide/it821x.c                   |   12 ++
 drivers/misc/sgi-xp/xpc_sn2.c          |   19 ++--
 drivers/misc/sgi-xp/xpc_uv.c           |    2 
 drivers/net/bnx2x_main.c               |    3 
 drivers/net/wireless/ath5k/base.c      |   10 +-
 drivers/net/wireless/rtl8187_dev.c     |    1 
 drivers/net/wireless/rtl8187_rtl8225.c |   10 +-
 drivers/pci/hotplug/pciehp_core.c      |    4 
 drivers/serial/8250_pci.c              |    3 
 drivers/usb/core/devio.c               |   20 ++--
 drivers/usb/core/driver.c              |    2 
 drivers/usb/core/hub.c                 |    4 
 drivers/usb/core/inode.c               |    1 
 drivers/usb/core/message.c             |   40 +++++----
 drivers/usb/core/usb.h                 |    6 -
 drivers/usb/mon/mon_bin.c              |  105 ++++++++++++++++---------
 drivers/usb/storage/unusual_devs.h     |    6 +
 fs/eventpoll.c                         |   22 -----
 fs/ext3/namei.c                        |   20 +++-
 fs/fuse/dev.c                          |    3 
 fs/fuse/file.c                         |    2 
 fs/fuse/inode.c                        |   10 +-
 fs/inotify_user.c                      |  135 ++++++++++++++++++---------------
 fs/sysfs/bin.c                         |    6 +
 include/linux/Kbuild                   |    1 
 include/linux/klist.h                  |    2 
 include/linux/pci_ids.h                |    6 +
 include/linux/sched.h                  |    1 
 kernel/relay.c                         |    4 
 kernel/resource.c                      |    9 ++
 mm/mmap.c                              |    9 +-
 mm/vmalloc.c                           |   11 ++
 net/core/net_namespace.c               |    2 
 net/mac80211/tx.c                      |    6 -
 sound/pci/hda/patch_conexant.c         |    1 
 sound/pci/hda/patch_realtek.c          |    1 
 sound/pci/hda/patch_sigmatel.c         |    2 
 sound/pci/oxygen/virtuoso.c            |    1 
 49 files changed, 427 insertions(+), 226 deletions(-)

Alan Stern (2):
      USB: fix toggle mismatch in disable_endpoint paths
      USB: fix char-device disconnect handling

Andrew Morton (1):
      Fix OOPS in mmap_region() when merging adjacent VM_LOCKED file segments

Andrey Yurovsky (1):
      ath5k: fix mesh point operation

Arjan van de Ven (1):
      resources: skip sanity check of busy resources

Boaz Harrosh (1):
      include/linux: Add bsg.h to the Kernel exported headers

Brandon Philips (1):
      it821x: Add ultra_mask quirk for Vortex86SX

Brian Cavagnolo (1):
      mac80211: decrement ref count to netdev after launching mesh discovery

Clemens Ladisch (1):
      sound: virtuoso: enable UART on Xonar HDAV1.3

Dan Carpenter (1):
      fuse: fix NULL deref in fuse_file_alloc()

Davide Libenzi (1):
      epoll: drop max_user_instances and rely only on max_user_watches

Eilon Greenstein (1):
      bnx2x: Block nvram access when the device is inactive

Eric Anholt (1):
      drm: stash AGP include under the do-we-have-AGP ifdef

Flavio Leitner (1):
      serial_8250: support for Sealevel Systems Model 7803 COMM+8

Greg Kroah-Hartman (2):
      sysfs: fix problems with binary files
      Linux 2.6.28.3

Herbert Xu (1):
      crypto: authenc - Fix zero-length IV crash

Ivan Kokshaysky (2):
      alpha: nautilus - fix compile failure with gcc-4.3
      alpha: fix vmalloc breakage

Jarod Wilson (1):
      crypto: ccm - Fix handling of null assoc data

Jesper Nilsson (1):
      klist.c: bit 0 in pointer can't be used as flag

Jiri Slaby (3):
      PCI hotplug: fix lock imbalance in pciehp
      NET: net_namespace, fix lock imbalance
      relay: fix lock imbalance in relay_late_setup_files

Joerg Schirottke (1):
      ALSA: hda - Add quirk for HP DV6700 laptop

JosephChan@via.com.tw (1):
      libata: pata_via: support VX855, future chips whose IDE controller use 0x0571

Larry Finger (2):
      rtl8187: Add termination packet to prevent stall
      rtl8187: Fix error in setting OFDM power settings for RTL8187L

Luke Yelavich (1):
      ALSA: hda - add another MacBook Pro 4, 1 subsystem ID

Magnus Damm (1):
      gpiolib: fix request related issue

Miklos Szeredi (2):
      fuse: destroy bdi on umount
      fuse: fix missing fput on error

Oliver Neukum (1):
      USB: storage: add unusual devs entry

Pete Zaitcev (1):
      USB: usbmon: Implement compat_ioctl

Peter Zijlstra (1):
      x86, mm: fix pte_free()

Robin Holt (2):
      sgi-xpc: Remove NULL pointer dereference.
      sgi-xpc: ensure flags are updated before bte_copy

Suresh Siddha (3):
      x86: fix page attribute corruption with cpa()
      x86, pat: fix reserve_memtype() for legacy 1MB range
      x86, pat: fix PTE corruption issue while mapping RAM using /dev/mem

Takashi Iwai (1):
      ALSA: hda - Fix PCM reference NID for STAC/IDT analog outputs

Theodore Ts'o (1):
      ext3: Add sanity check to make_indexed_dir

Vegard Nossum (1):
      inotify: clean up inotify_read and fix locking problems

Yuri Tikhonov (1):
      dmaengine: fix dependency chaining

