Return-Path: <linux-kernel-owner+w=401wt.eu-S935169AbYCDXWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169AbYCDXWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934894AbYCDXPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:15:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:48856 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934865AbYCDXPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:15:44 -0500
Date: Tue, 4 Mar 2008 15:15:19 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes against 2.6.25-rc3 git
Message-ID: <20080304231519.GC3073@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few driver core fixes against your current git tree that fix some
more problems that have cropped up:
	- suspend/resume bugfixes
	- ksets were not getting properly initialized
	- CONFIG_SYSFS_DEPRECATED was catching people with old userspace
	  versions of LVM now that the block core is changed to use
	  struct device.
	- other driver core bugs on error paths.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/core.c       |   14 +-----
 drivers/base/power/main.c |  108 +++++++--------------------------------------
 drivers/usb/core/usb.c    |    2 +-
 fs/debugfs/inode.c        |    4 --
 include/linux/debugfs.h   |    5 ++
 init/Kconfig              |   11 +++-
 lib/kobject.c             |   11 ++---
 7 files changed, 39 insertions(+), 116 deletions(-)

---------------

Alan Stern (1):
      PM: fix new mutex-locking bug in the PM core

Cornelia Huck (1):
      Driver core: Fix cleanup when failing device_add().

Greg Kroah-Hartman (2):
      driver core: fix up Kconfig text for CONFIG_SYSFS_DEPRECATED
      kobject: properly initialize ksets

Harvey Harrison (1):
      debugfs: fix sparse warnings

Ingo Molnar (1):
      sysfs: CONFIG_SYSFS_DEPRECATED fix

Rafael J. Wysocki (2):
      PM: Do not acquire device semaphores upfront during suspend
      driver core: Remove dpm_sysfs_remove() from error path of device_add()

