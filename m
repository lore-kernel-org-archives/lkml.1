Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYHUReQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYHUReQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbYHURd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:33:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:47455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbYHURd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:33:57 -0400
Date: Thu, 21 Aug 2008 10:30:36 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches against 2.6.26-rc4
Message-ID: <20080821173036.GB7974@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some fixes and updates for driver core related things against
your 2.6.26-git tree.

The biggest patches here are:
	- ja_JP documentation updates
	- new UIO driver (self contained)

The rest are all bugfixes and build fixes and one adds a new field to
struct device to make the linux-next tree merges a lot happier.

All of these, with the exception of one documentation update, have been
in the -next trees and the -mm releases for a while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/ja_JP/HOWTO           |   67 +++++++++----
 Documentation/ja_JP/SubmitChecklist |  111 +++++++++++++++++++++
 block/genhd.c                       |   36 +++++---
 drivers/base/class.c                |   11 ++
 drivers/base/core.c                 |   31 ++++--
 drivers/base/driver.c               |    3 -
 drivers/base/power/main.c           |   19 +---
 drivers/base/power/power.h          |    9 ++-
 drivers/uio/Kconfig                 |   13 +++
 drivers/uio/Makefile                |    1 +
 drivers/uio/uio_pdrv.c              |    4 +-
 drivers/uio/uio_pdrv_genirq.c       |  188 +++++++++++++++++++++++++++++++++++
 include/linux/device.h              |    5 +-
 lib/kobject.c                       |    3 +-
 scripts/mod/file2alias.c            |   16 ++-
 15 files changed, 445 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/ja_JP/SubmitChecklist
 create mode 100644 drivers/uio/uio_pdrv_genirq.c

---------------

Alan Stern (1):
      PM: don't skip device PM init when CONFIG_PM_SLEEP isn't set and CONFIG_PM is set

David Brownell (1):
      driver model: anti-oopsing medicine

Greg Kroah-Hartman (1):
      driver core: add init_name to struct device

Ingo Oeser (1):
      kobject: Replace ALL occurrences of '/' with '!' instead of only the first one.

Jean Delvare (1):
      dev_printk(): constify the `dev' argument

Joe Perches (1):
      drivers/base/driver.c: remove unused to_dev() macro

Kay Sievers (3):
      block: fix partial read() of /proc/{partitions,diskstats}
      block: drop references taken by class_find_device()
      pnp: fix "add acpi:* modalias entries"

Magnus Damm (1):
      UIO: generic irq handling for some uio platform devices

Rafael J. Wysocki (1):
      PM: Remove WARN_ON from device_pm_add

Takenori Nagano (1):
      Japanese translation of Documentation/SubmitChecklist

Tsugikazu Shibata (1):
      Documentation: HOWTO-ja_JP-sync patch

Uwe Kleine-König (2):
      UIO: uio_pdrv: fix memory leak
      UIO: uio_pdrv: fix license specification

