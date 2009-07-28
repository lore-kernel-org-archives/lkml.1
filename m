Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZG1Vji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZG1Vji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZG1Vjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:39:36 -0400
Received: from kroah.org ([198.145.64.141]:44373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbZG1Vje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:39:34 -0400
Date: Tue, 28 Jul 2009 14:38:19 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING fixes for 2.6.31-rc4-git tree
Message-ID: <20090728213819.GB13090@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few patches for the drivers/staging/ section of the kernel,
for your git tree.

The big thing is the removal of a whole driver, as it turned out that
the device this driver was for, was already supported by an existing
driver in the drivers/usb/serial/ tree.  All that was needed was to add
the device id to the existing driver, which a patch that went through my
USB tree did.

Other than that, the patches do:
	- build fix for Android lowmemdriver
	- build fix
	- tty driver fixes needed due to changes in the tty layer.

All of these are contained within the drivers/staging tree, and have
been in the linux-next and -mm trees for a while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                   |    2 -
 drivers/staging/Makefile                  |    1 -
 drivers/staging/android/lowmemorykiller.c |    8 +-
 drivers/staging/serqt_usb2/serqt_usb2.c   |   20 +-
 drivers/staging/uc2322/Kconfig            |   10 -
 drivers/staging/uc2322/Makefile           |    1 -
 drivers/staging/uc2322/TODO               |    7 -
 drivers/staging/uc2322/aten2011.c         | 2430 -----------------------------
 drivers/staging/udlfb/udlfb.c             |    1 +
 9 files changed, 20 insertions(+), 2460 deletions(-)
 delete mode 100644 drivers/staging/uc2322/Kconfig
 delete mode 100644 drivers/staging/uc2322/Makefile
 delete mode 100644 drivers/staging/uc2322/TODO
 delete mode 100644 drivers/staging/uc2322/aten2011.c

---------------

Amit Kucheria (1):
      staging: udlfb: Add vmalloc.h include

Bill Pemberton (1):
      Staging: serqt_usb2: add missing calls to tty_kref_put()

David Rientjes (1):
      Staging: android: lowmemorykiller.c: fix it for "oom: move oom_adj value from task_struct to mm_struct"

Greg Kroah-Hartman (1):
      staging: remove aten2011 driver

Oliver Neukum (1):
      Staging: serqt_usb2: fix memory leak in error case

