Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbYD3X52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbYD3X52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbYD3X5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:57:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:44412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbYD3X5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:57:19 -0400
Date: Wed, 30 Apr 2008 16:57:01 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches against 2.6.25-git
Message-ID: <20080430235701.GA20981@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few remaining patches against your 2.6.25-git tree.

They provide a few apis that Tejun needs for other trees, and the
biggest of all is the removal of 'struct class_device' now that it is
purged from your tree through all of the different subsytem merges.

There's also a build fix in there from Randy and a few other minor
things that people have posted problems with.

All of these patches have been in -next for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/base.h           |   11 -
 drivers/base/class.c          |  638 +----------------------------------------
 drivers/base/driver.c         |   10 +
 drivers/pcmcia/cs.c           |   13 +-
 drivers/pcmcia/cs_internal.h  |    3 +-
 drivers/pcmcia/socket_sysfs.c |   52 ++--
 fs/debugfs/file.c             |    2 +-
 fs/sysfs/inode.c              |    2 +
 include/linux/device.h        |   97 -------
 include/linux/io.h            |    4 +-
 include/linux/klist.h         |   40 ++-
 include/linux/sysfs.h         |    6 +
 lib/devres.c                  |    4 +-
 lib/klist.c                   |  235 ++++++++--------
 lib/kobject.c                 |   28 +--
 15 files changed, 201 insertions(+), 944 deletions(-)

---------------

Ben Hutchings (1):
      sysfs: Disallow truncation of files in sysfs

David Brownell (1):
      pcmcia: remove pccard_sysfs_interface warnings

Greg Kroah-Hartman (1):
      klist: fix coding style errors in klist.h and klist.c

Kay Sievers (2):
      kobject: do not copy vargs, just pass them around
      driver core: remove no longer used "struct class_device"

Kumar Gala (1):
      devres: support addresses greater than an unsigned long via dev_ioremap

Randy Dunlap (1):
      sysfs: sysfs_update_group stub for CONFIG_SYSFS=n

Robert P. J. Day (1):
      DEBUGFS: Correct location of debugfs API documentation.

Stas Sergeev (1):
      driver core: warn about duplicate driver names on the same bus

Tejun Heo (2):
      klist: implement KLIST_INIT() and DEFINE_KLIST()
      klist: implement klist_add_{after|before}()

