Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966062Ab0BZUaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:30:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966031Ab0BZUaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:30:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM updates for 2.6.34
Date: Fri, 26 Feb 2010 21:30:43 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rjw; KDE/4.3.5; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Jiri Slaby <jslaby@suse.cz>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <gregkh@suse.de>, Frans Pop <elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002262130.43405.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 2.6.34 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Hibernate regression fix (quite urgent).

* Introduction of a sysfs switch for controlling runtime PM of devices.

* sysfs device power attributes documentation update.

* Asynchronous suspend and resume patchset.  Reworked and hopefully not so
  controversial any more, speeds up suspend and, more importantly, resume
  quite significantly in general.

* Hibernate cleanups from Jiri Slaby and Frans Pop.


 Documentation/ABI/testing/sysfs-devices-power |   79 ++++++++++++++
 Documentation/ABI/testing/sysfs-power         |   13 +++
 Documentation/feature-removal-schedule.txt    |   11 ++
 drivers/base/power/main.c                     |  143 +++++++++++++++++++++++--
 drivers/base/power/power.h                    |    6 +-
 drivers/base/power/runtime.c                  |   45 ++++++++
 drivers/base/power/sysfs.c                    |  100 +++++++++++++++++
 drivers/pci/pci.c                             |    1 +
 drivers/pci/pcie/portdrv_core.c               |    1 +
 drivers/pci/probe.c                           |    1 +
 drivers/scsi/hosts.c                          |    4 +
 drivers/scsi/scsi_sysfs.c                     |    4 +
 drivers/usb/core/driver.c                     |    8 ++
 drivers/usb/core/endpoint.c                   |    1 +
 drivers/usb/core/hcd-pci.c                    |  127 ++++++++++++++++++++++-
 drivers/usb/core/hub.c                        |    1 +
 drivers/usb/core/message.c                    |    1 +
 include/linux/device.h                        |   17 +++
 include/linux/pm.h                            |    6 +
 include/linux/pm_runtime.h                    |    4 +
 include/linux/resume-trace.h                  |    7 ++
 include/linux/usb.h                           |    1 +
 kernel/power/Kconfig                          |   14 +++
 kernel/power/main.c                           |   31 +++++-
 kernel/power/snapshot.c                       |    4 +-
 kernel/power/swap.c                           |    4 -
 kernel/power/swsusp.c                         |   58 ----------
 kernel/power/user.c                           |   23 ++++-
 28 files changed, 631 insertions(+), 84 deletions(-)

---------------

Alan Stern (1):
      USB: implement non-tree resume ordering constraints for PCI host controllers

Frans Pop (1):
      PM / Hibernate: Remove trailing space in message

Jiri Slaby (3):
      PM / Hibernate: Really deprecate deprecated user ioctls
      PM / Hibernate: Swap, remove useless check from swsusp_read()
      PM / Hibernate: Remove swsusp.c finally

Rafael J. Wysocki (12):
      PM / Runtime: Add sysfs switch for disabling device run-time PM
      PM: Document device power attributes in sysfs
      PM: Add parent information to timing messages
      PM: Asynchronous suspend and resume of devices
      PM: Add a switch for disabling/enabling asynchronous suspend/resume
      PM: Add facility for advanced testing of async suspend/resume
      PM: Start asynchronous resume threads upfront
      PM: Allow device drivers to use dpm_wait()
      PM: Allow PCI devices to suspend/resume asynchronously
      PM: Allow USB devices to suspend/resume asynchronously
      PM: Allow SCSI devices to suspend/resume asynchronously
      PM / Hibernate: Fix preallocating of memory

