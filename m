Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab0CATj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:39:27 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:38642 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0CATj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:39:26 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8C1867.7040201@cam.ac.uk>
Date: Mon, 01 Mar 2010 19:41:27 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [GIT PULL] Ambient Light Sensors subsystem
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus,

Please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/jic23/als.git for-linus

to get the Ambient Light Sensors subsystem.
A large part of the following consists of moving two drivers from
elsewhere in the kernel to als now it is available.

acpi-als will merge later through the acpi tree as it sits entirely
within their directories. Both moves have been confirmed with the
respective maintainers and all known users of the drivers.

All changes as per linux-next branch where they have been for some weeks.

Thanks,

Jonathan

Amit Kucheria (1):
      als: add unique device-ids to the als device class

Jonathan Cameron (5):
      ALS: Add jic23 and als git tree to MAINTAINERS
      tsl2550: Move form i2c/chips to als and update interfaces. Remove i2c/chips in this commit to avoid build failure that results from separating that step out.
      als: tsl2550: Remove spurious check against a maximum lux value.
      Merge remote branch 'linus/master' into for-next
      isl29003: Move from misc to als now it is available with minimal changes

Zhang Rui (1):
      introduce ALS sysfs class


 Documentation/ABI/testing/sysfs-class-als |   18 +++++
 MAINTAINERS                               |    8 ++
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/als/Kconfig                       |   34 +++++++++
 drivers/als/Makefile                      |    9 ++
 drivers/als/als_sys.c                     |  116 +++++++++++++++++++++++++++++
 drivers/{misc => als}/isl29003.c          |   46 ++++++++----
 drivers/{i2c/chips => als}/tsl2550.c      |   96 +++++++++++++++---------
 drivers/i2c/Kconfig                       |    1 -
 drivers/i2c/Makefile                      |    2 +-
 drivers/i2c/chips/Kconfig                 |   19 -----
 drivers/i2c/chips/Makefile                |   18 -----
 drivers/misc/Kconfig                      |   10 ---
 drivers/misc/Makefile                     |    1 -
 include/linux/als_sys.h                   |   35 +++++++++
 16 files changed, 314 insertions(+), 102 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-als
 create mode 100644 drivers/als/Kconfig
 create mode 100644 drivers/als/Makefile
 create mode 100644 drivers/als/als_sys.c
 rename drivers/{misc => als}/isl29003.c (90%)
 rename drivers/{i2c/chips => als}/tsl2550.c (82%)
 delete mode 100644 drivers/i2c/chips/Kconfig
 delete mode 100644 drivers/i2c/chips/Makefile
 create mode 100644 include/linux/als_sys.h
