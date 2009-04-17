Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbZDQTFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbZDQTFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbZDQTEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:04:41 -0400
Received: from kroah.org ([198.145.64.141]:34572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752767AbZDQTEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:04:40 -0400
Date: Fri, 17 Apr 2009 12:01:44 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.31-rc2
Message-ID: <20090417190144.GB3548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few driver-core patches for your 2.6.31-rc2 tree.

The biggest patch here is the addition of the early platform driver api.
This patch has been in the -mm tree for a few major kernel releases now
(around 5 months), and there are a number of drivers pending in some of
the arch trees that depend on this api being present.  It doesn't affect
any x86 code, so the majority of the world will have no problems with
this, and it all gets thrown away after init starts up, so it has no
affect on memory sizes.

Other than that, it's just a few bugfixes and tweaks.


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/driver-model/platform.txt |   59 ++++++++
 drivers/base/base.h                     |    2 +-
 drivers/base/core.c                     |    3 +
 drivers/base/platform.c                 |  239 +++++++++++++++++++++++++++++++
 drivers/uio/uio_cif.c                   |    1 +
 fs/proc/base.c                          |    4 +-
 fs/sysfs/file.c                         |   16 ++-
 include/linux/dynamic_debug.h           |    2 +-
 include/linux/init.h                    |    1 +
 include/linux/kernel.h                  |    9 ++
 include/linux/platform_device.h         |   42 ++++++
 init/main.c                             |    7 +-
 lib/kobject_uevent.c                    |    2 +-
 13 files changed, 378 insertions(+), 9 deletions(-)

---------------

Alex Chiang (1):
      sysfs: don't use global workqueue in sysfs_schedule_callback()

Greg Kroah-Hartman (1):
      driver core: prevent device_for_each_child from oopsing

Hans J. Koch (1):
      UIO: fix specific device driver missing statement for depmod

Jason Baron (1):
      Driver core: remove pr_fmt() from dynamic_dev_dbg() printk

KOSAKI Motohiro (2):
      sysfs: sysfs poll keep the poll rule of regular file.
      proc: mounts_poll() make consistent to mdstat_poll

Kay Sievers (1):
      driver core: allow non-root users to listen to uevents

Magnus Damm (1):
      Driver Core: early platform driver

Michael Ellerman (1):
      dynamic debug: resurrect old pr_debug() semantics as pr_devel()

Ming Lei (1):
      driver core: fix driver_match_device

