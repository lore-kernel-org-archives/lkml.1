Return-Path: <linux-kernel-owner+w=401wt.eu-S1767306AbXECCMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767306AbXECCMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767318AbXECCMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:12:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56377 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767306AbXECCMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:12:03 -0400
Date: Wed, 2 May 2007 19:09:24 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] More core patches for 2.6.21
Message-ID: <20070503020924.GB21316@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more driver core patche for 2.6.21.

They contain:
	- fix a problem with blowing up the stack in ugly ways.
	- compile warning fix
	- documentation update
	- remove 'struct subsystem' from the tree as it's pointless.  It
	  only contained one field, a struct kset, and was confusing to
	  everyone who ever had to use it.  This sets the stage for
	  further cleanups to the driver and kobject core to be much
	  saner and easier to understand.

The 'struct subsystem' removal patch has been in -mm for quite some
time, the others are all "obviously correct" :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/driver-model/devres.txt  |    2 +-
 arch/arm/mach-omap1/pm.c               |    6 +-
 arch/powerpc/kernel/vio.c              |    4 +-
 arch/powerpc/platforms/pseries/power.c |    8 ++--
 arch/s390/kernel/ipl.c                 |   32 ++++++------
 block/genhd.c                          |   12 ++--
 drivers/base/base.h                    |    2 +
 drivers/base/bus.c                     |   16 +++---
 drivers/base/class.c                   |   18 +++----
 drivers/base/core.c                    |   29 ++++++----
 drivers/base/firmware.c                |    6 +-
 drivers/base/platform.c                |    8 ++-
 drivers/base/power/shutdown.c          |    4 +-
 drivers/base/sys.c                     |   14 +++---
 drivers/firmware/efivars.c             |   12 ++--
 drivers/input/evdev.c                  |    4 +-
 drivers/input/joydev.c                 |    4 +-
 drivers/input/mousedev.c               |    4 +-
 drivers/input/tsdev.c                  |    4 +-
 drivers/parisc/pdc_stable.c            |   94 ++++++++++++++++----------------
 drivers/pci/hotplug/acpiphp_ibm.c      |    4 +-
 drivers/pci/hotplug/pci_hotplug_core.c |    4 +-
 fs/configfs/mount.c                    |    2 +-
 fs/debugfs/inode.c                     |    2 +-
 fs/dlm/lockspace.c                     |    2 +-
 fs/ecryptfs/main.c                     |   12 ++--
 fs/fuse/inode.c                        |    4 +-
 fs/gfs2/locking/dlm/sysfs.c            |    2 +-
 fs/gfs2/sys.c                          |    2 +-
 fs/ocfs2/cluster/masklog.c             |    4 +-
 fs/ocfs2/cluster/masklog.h             |    2 +-
 fs/ocfs2/cluster/sys.c                 |    7 +--
 fs/partitions/check.c                  |    6 +-
 fs/sysfs/bin.c                         |    2 +-
 fs/sysfs/file.c                        |   11 ++--
 include/acpi/acpi_bus.h                |    2 +-
 include/linux/device.h                 |    8 ++--
 include/linux/fs.h                     |    2 +-
 include/linux/kobject.h                |   58 +++++++++-----------
 include/linux/module.h                 |    2 +-
 include/linux/pci_hotplug.h            |    2 +-
 kernel/ksysfs.c                        |   12 ++--
 kernel/module.c                        |    8 ++-
 kernel/params.c                        |    2 +
 kernel/power/disk.c                    |   14 +++---
 kernel/power/main.c                    |   10 ++--
 kernel/power/power.h                   |    2 +-
 lib/kobject.c                          |   69 +++---------------------
 security/inode.c                       |    2 +-
 49 files changed, 244 insertions(+), 298 deletions(-)

---------------

Greg Kroah-Hartman (2):
      Driver core: fix show_uevent from taking up way too much stack
      remove "struct subsystem" as it is no longer needed

Jean Delvare (1):
      platform: reorder platform_device_del

Randy Dunlap (1):
      sysfs: printk format warning

Rolf Eike Beer (1):
      DOC: Fix wrong identifier name in Documentation/driver-model/devres.txt

