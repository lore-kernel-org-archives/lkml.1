Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZLEVQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZLEVQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 16:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZLEVP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 16:15:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbZLEVPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 16:15:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM updates for 2.6.33
Date: Sat, 5 Dec 2009 22:16:19 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912052216.19540.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Asynchronous suspend and resume infrastructure.  For now, PCI, ACPI and
  serio devices are enabled to suspend and resume asynchronously.

* Fixes for the runtime PM framework.

* Hibernate cleanups from Nigel and Jiri Slaby.

* Freezer optimisation from Tejun.


 Documentation/power/runtime_pm.txt |   12 +-
 drivers/acpi/glue.c                |    3 +
 drivers/acpi/scan.c                |    1 +
 drivers/base/core.c                |    4 +
 drivers/base/power/Makefile        |    2 +-
 drivers/base/power/common.c        |  283 +++++++++++++++
 drivers/base/power/main.c          |  677 +++++++++++++++++++++++++++++++++---
 drivers/base/power/power.h         |   42 ++-
 drivers/base/power/runtime.c       |   27 +-
 drivers/base/power/sysfs.c         |   47 +++
 drivers/input/serio/serio.c        |    1 +
 drivers/pci/pci.c                  |    1 +
 drivers/pci/pcie/portdrv_core.c    |    1 +
 include/linux/device.h             |   11 +
 include/linux/pm.h                 |   21 +-
 include/linux/pm_link.h            |   30 ++
 include/linux/pm_runtime.h         |   12 +
 include/linux/resume-trace.h       |    7 +
 kernel/power/Kconfig               |   14 +
 kernel/power/Makefile              |    2 +-
 kernel/power/hibernate.c           |   26 ++
 kernel/power/main.c                |   32 ++-
 kernel/power/process.c             |   14 +-
 kernel/power/swap.c                |  107 ++++++-
 kernel/power/swsusp.c              |  188 ----------
 25 files changed, 1281 insertions(+), 284 deletions(-)

---------------

Alan Stern (2):
      PM / Runtime: Export the PM runtime workqueue
      PM / Runtime: Use deferred_resume flag in pm_request_resume

Jaswinder Singh Rajput (1):
      PM: Fix kernel-doc notation

Jiri Slaby (1):
      PM / Hibernate: Swap, use KERN_CONT

Nigel Cunningham (2):
      PM / Hibernate: Move swap functions to kernel/power/swap.c.
      PM / Hibernate: Shift remaining code from swsusp.c to hibernate.c

Rafael J. Wysocki (15):
      PM: Introduce PM links framework
      PM: Asynchronous resume of devices
      PM: Asynchronous suspend of devices
      PM: Allow PCI devices to suspend/resume asynchronously
      PM: Allow ACPI devices to suspend/resume asynchronously
      PM: Add a switch for disabling/enabling asynchronous suspend/resume
      PM: Measure device suspend and resume times
      PM: Add facility for advanced testing of async suspend/resume
      PM: Measure suspend and resume times for individual devices
      PM: Allow serio input devices to suspend/resume asynchronously
      PM / Runtime: Fix lockdep warning in __pm_runtime_set_status()
      PM / Runtime: Ensure timer_expires is nonzero in pm_schedule_suspend()
      PM / Runtime: Make documentation of runtime_idle() agree with the code
      PM / Runtime: Remove unnecessary braces in __pm_runtime_set_status()
      PM: Add flag for devices capable of generating run-time wake-up events

Stephen Rothwell (1):
      PM / Suspend: Using TASK_ macros requires sched.h

Tejun Heo (1):
      PM / freezer: Don't get over-anxious while waiting

