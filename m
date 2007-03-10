Return-Path: <linux-kernel-owner+w=401wt.eu-S965834AbXCJEFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965834AbXCJEFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767768AbXCJEFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:05:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:36757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965834AbXCJEFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:05:43 -0500
Date: Fri, 9 Mar 2007 20:04:05 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 2.6.21-rc3
Message-ID: <20070310040405.GC30638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core fixes for 2.6.21-rc3.

They fix the following thing:
  - fix reference counting bug when removing any driver module from the
    system by reverting a previous "fix".
  - allow older versions of HAL to find network devices even if
    CONFIG_SYSFS_DEPRECATED is disabled.
  - fix an oops when moving kobjects to the same destination location as
    they currently are caused by the bluetooth layer.
  - export a symbol to allow the wireless core to be built as a module -
    remove the devfs entry in the MAINTAINERS file.

All of these have been in the -mm tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 MAINTAINERS         |    3 ---
 drivers/base/core.c |   23 ++++++++++++++---------
 kernel/module.c     |    6 ------
 lib/kobject.c       |    2 ++
 4 files changed, 16 insertions(+), 18 deletions(-)

---------------

Dmitriy Monakhov (1):
      kobject: new_device->kref wasn't putted after error in kobject_move()

Greg Kroah-Hartman (2):
      Revert "driver core: refcounting fix"
      Driver core: add device symlink back to sysfs

Johannes Berg (1):
      driver core: export device_rename

Jörn Engel (1):
      Remove devfs from MAINTAINERS

