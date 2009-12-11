Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbZLKV1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbZLKV1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbZLKV13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:27:29 -0500
Received: from kroah.org ([198.145.64.141]:35909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669AbZLKV13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:27:29 -0500
Date: Fri, 11 Dec 2009 13:26:42 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.33-git
Message-ID: <20091211212642.GA6624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big driver core merge for the 2.6.33-git tree.

Nothing major here:
	- sysfs reworks to make things nicer and fix minor problems
	- firmware api changes
	- devtmpfs tweaks to resolve minor issues reported by users.
	- platform devices early buffer changes
	- debugfs bugfix

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------


 drivers/base/core.c                         |   14 +-
 drivers/base/devtmpfs.c                     |  100 ++++----
 drivers/base/firmware_class.c               |   14 +-
 drivers/base/platform.c                     |   29 ++-
 drivers/firmware/dell_rbu.c                 |    9 +-
 drivers/misc/hpilo.h                        |   13 +-
 drivers/serial/ucc_uart.c                   |    8 +-
 drivers/staging/comedi/drivers/usbdux.c     |    5 +-
 drivers/staging/comedi/drivers/usbduxfast.c |    5 +-
 drivers/usb/atm/ueagle-atm.c                |    7 +-
 fs/debugfs/inode.c                          |   55 +++--
 fs/namei.c                                  |   22 --
 fs/sysfs/dir.c                              |  388 +++++++++------------------
 fs/sysfs/file.c                             |   41 +---
 fs/sysfs/inode.c                            |  176 ++++++++-----
 fs/sysfs/symlink.c                          |   11 +-
 fs/sysfs/sysfs.h                            |    9 +-
 include/linux/device.h                      |    2 +-
 include/linux/firmware.h                    |    5 +-
 include/linux/namei.h                       |    1 -
 include/linux/platform_device.h             |   20 +-
 21 files changed, 428 insertions(+), 506 deletions(-)

---------------

Alan Stern (1):
      Driver core: fix race in dev_driver_string

David Altobelli (1):
      hpilo: add locking comment

Eric W. Biederman (15):
      Driver core: Don't remove kobjects in device_shutdown.
      sysfs: Update sysfs_setxattr so it updates secdata under the sysfs_mutex
      sysfs: Rename sysfs_d_iput to sysfs_dentry_iput
      sysfs: Use dentry_ops instead of directly playing with the dcache
      sysfs: Simplify sysfs_chmod_file semantics
      sysfs: Simplify iattr time assignments
      sysfs: Fix locking and factor out sysfs_sd_setattr
      sysfs: Update s_iattr on link and unlink.
      sysfs: Nicely indent sysfs_symlink_inode_operations
      sysfs: Implement sysfs_getattr & sysfs_permission
      sysfs: In sysfs_chmod_file lazily propagate the mode change.
      sysfs: Gut sysfs_addrm_start and sysfs_addrm_finish
      sysfs: Propagate renames to the vfs on demand
      sysfs: Factor out sysfs_rename from sysfs_rename_dir and sysfs_move_dir
      sysfs: sysfs_setattr remove unnecessary permission check.

Johannes Berg (1):
      firmware_class: make request_firmware_nowait more useful

Kay Sievers (6):
      Driver Core: devtmpfs: ignore umask while setting file mode
      Driver core: devtmpfs: prevent concurrent subdirectory creation and removal
      Driver Core: devtmpfs: use sys_mount()
      Driver Core: devtmpfs: do not remove non-kernel-created directories
      Driver Core: devtmpfs: cleanup node on device creation error
      Driver-Core: devtmpfs - set root directory mode to 0755

Magnus Damm (1):
      Driver Core: Early platform driver buffer

Mathieu Desnoyers (1):
      debugfs: fix create mutex racy fops and private data

Stefan Richter (1):
      sysfs: mark a locally-only used function static

