Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZLCVbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZLCVbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZLCVbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:31:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57216 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbZLCVbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:31:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: What's in suspend-2.6.git
Date: Thu, 3 Dec 2009 22:31:56 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912032231.57072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a summary of the changes queued on the #linux-next branch
of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git

They are going to be pushed to Linus in the next couple of days.

PM developers, please speak up if there's anything obviously wrong or missing.


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

---------------

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

Thanks,
Rafael
