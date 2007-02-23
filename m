Return-Path: <linux-kernel-owner+w=401wt.eu-S933256AbXBWXPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbXBWXPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933258AbXBWXPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:15:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:54292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933256AbXBWXPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:15:54 -0500
Date: Fri, 23 Feb 2007 15:14:26 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 2.6.21-rc1
Message-ID: <20070223231426.GA20498@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core fixes for 2.6.21-rc1.

It fixes up some problems due to the pcmcia changes I did in the last
round of driver core changes, removes an unused function, and backs out
the kmod changes as there was a nasty loop for people who use networking
as a module.  There's some other bugfixes here, and some powermanagement
documentation updates and clarifications (from -mm).

All of these have been in the -mm tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

 drivers/base/class.c          |   42 --------------
 drivers/base/core.c           |   31 ++++++++++-
 drivers/pcmcia/hd64465_ss.c   |    2 +-
 drivers/pcmcia/m32r_cfc.c     |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c  |    2 +-
 drivers/pcmcia/omap_cf.c      |    2 +-
 drivers/pcmcia/rsrc_mgr.c     |    2 +-
 drivers/pcmcia/vrc4171_card.c |    2 +-
 fs/sysfs/sysfs.h              |   11 ++++
 include/linux/device.h        |    2 -
 include/linux/kmod.h          |    2 -
 include/linux/pm.h            |   37 ++++++++++++-
 include/linux/sysfs.h         |   13 +----
 kernel/kmod.c                 |  120 -----------------------------------------
 kernel/module.c               |   32 ++++++------
 kernel/params.c               |    1 -
 kernel/power/main.c           |    5 ++-
 17 files changed, 103 insertions(+), 205 deletions(-)

---------------

Adam J. Richter (1):
      sysfs: move struct sysfs_dirent to private header

Adrian Bunk (1):
      make kernel/kmod.c:kmod_mk static

Greg Kroah-Hartman (2):
      Driver core: remove class_device_rename
      Revert "Driver core: let request_module() send a /sys/modules/kmod/-uevent"

James Simmons (1):
      Driver core: fix error by cleanup up symlinks properly

Johannes Berg (2):
      power management: no valid states w/o pm_ops
      power management: fix struct layout and docs

Manuel Lauss (1):
      Driver core: more fallout from class_device changes for pcmcia

Mike Galbraith (1):
      driver core: refcounting fix

