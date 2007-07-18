Return-Path: <linux-kernel-owner+w=401wt.eu-S936171AbXGRX0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936171AbXGRX0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935578AbXGRXYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:24:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34756 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935426AbXGRXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:24:52 -0400
Date: Wed, 18 Jul 2007 16:24:00 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] more sysfs and driver core patches for 2.6.22
Message-ID: <20070718232400.GC4620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more driver core and sysfs patches against your 2.6.22 git
tree.

They fix some bugs in the last big sysfs merge (thanks to Tejun for
finding and fixing them so quickly) and some other minor stuff all over
the place.

Some of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

 Documentation/CodingStyle                  |   20 +++-
 Documentation/HOWTO                        |    3 +
 Documentation/driver-model/devres.txt      |    2 +-
 Documentation/feature-removal-schedule.txt |    4 +-
 drivers/base/core.c                        |  168 +++++++++++++++++++++-------
 drivers/base/power/Makefile                |    2 +-
 drivers/base/power/power.h                 |    5 -
 drivers/base/power/runtime.c               |   85 --------------
 drivers/base/power/sysfs.c                 |   66 -----------
 drivers/pcmcia/ds.c                        |   40 ++++++-
 drivers/usb/core/driver.c                  |    7 -
 fs/debugfs/inode.c                         |    5 -
 fs/sysfs/dir.c                             |   25 +++--
 fs/sysfs/file.c                            |    9 +-
 fs/sysfs/inode.c                           |    2 +-
 fs/sysfs/mount.c                           |   10 +-
 fs/sysfs/symlink.c                         |   12 ++-
 fs/sysfs/sysfs.h                           |    1 -
 include/linux/device.h                     |   10 ++
 include/linux/kobject.h                    |   25 +++--
 include/linux/pm.h                         |   11 --
 kernel/power/Kconfig                       |   12 --
 lib/kobject_uevent.c                       |   30 ++----
 23 files changed, 253 insertions(+), 301 deletions(-)
 delete mode 100644 drivers/base/power/runtime.c

---------------

Akinobu Mita (1):
      sysfs: avoid kmem_cache_free(NULL)

Alan Stern (2):
      PM: Remove deprecated sysfs files
      PM: remove deprecated dpm_runtime_* routines

Brandon Philips (1):
      Documentation fix devres.txt: lib/iomap.c -> lib/devres.c

Cornelia Huck (1):
      Driver core: check return code of sysfs_create_link()

David Brownell (2):
      dev_vdbg(), available with -DVERBOSE_DEBUG
      dev_vdbg() documentation

Jens Axboe (1):
      debugfs: remove rmdir() non-empty complaint

Kay Sievers (1):
      Driver core: accept all valid action-strings in uevent-trigger

Paolo Ciarrocchi (1):
      HOWTO: Add the knwon_regression URI to the documentation

Tejun Heo (4):
      sysfs: fix sysfs root inode nlink accounting
      sysfs: make sysfs_init_inode() static
      sysfs: kill an extra put in sysfs_create_link() failure path
      sysfs: cosmetic clean up on node creation failure paths

