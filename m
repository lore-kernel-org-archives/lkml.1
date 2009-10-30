Return-Path: <linux-kernel-owner+w=401wt.eu-S932946AbZJ3WJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbZJ3WJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 18:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbZJ3WJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 18:09:52 -0400
Received: from kroah.org ([198.145.64.141]:48362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540AbZJ3WJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 18:09:52 -0400
Date: Fri, 30 Oct 2009 15:09:30 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.32-git
Message-ID: <20091030220930.GA11297@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 2 bugfixes for the driver core code for your .32 git tree, and
7 documentation updates.

They do:
	- prevent platform devices from being able to be unbound/bound
	  from userspace.  This solves an issue that some people were
	  having with keyboards.
	- pass the proper error value back to userspace when a driver is
	  already bound to a device.
	- cpu sysfs file documentation updates.


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 .../ABI/testing/sysfs-devices-cache_disable        |   18 ---
 Documentation/ABI/testing/sysfs-devices-system-cpu |  156 ++++++++++++++++++++
 Documentation/cputopology.txt                      |   47 ++++--
 drivers/base/bus.c                                 |   17 ++-
 drivers/base/driver.c                              |    2 +-
 drivers/base/platform.c                            |    6 +-
 include/linux/device.h                             |    4 +-
 7 files changed, 206 insertions(+), 44 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-devices-cache_disable
 create mode 100644 Documentation/ABI/testing/sysfs-devices-system-cpu

---------------

Alex Chiang (7):
      Documentation: ABI: rename sysfs-devices-cache_disable properly
      Documentation: ABI: document /sys/devices/system/cpu/
      Documentation: ABI: /sys/devices/system/cpu/ topology files
      Documentation: ABI: /sys/devices/system/cpu/cpu#/ topology files
      Documentation: ABI: /sys/devices/system/cpu/sched_[mc|smt]_power_savings
      Documentation: ABI: /sys/devices/system/cpu/cpuidle/
      Documentation: ABI: /sys/devices/system/cpu/cpu#/node

Dmitry Torokhov (1):
      Driver core: allow certain drivers prohibit bind/unbind via sysfs

Stas Sergeev (1):
      Driver core: fix driver_register() return value

