Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZFNKqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZFNKqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbZFNKqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:46:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60697 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZFNKqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:46:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Jun 2009 12:46:25 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git?
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.70eb865eb2fae29b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two batches in the FireWire/ IEEE 1394 repo, one to be merged
soon, and another one which I'm not entirely sure of yet.  Both batches
deal with the newer firewire drivers only, the older ieee1394 stack is
left untouched this time.

As usual, the updates can be fetched from
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
or browsed at
    http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git

I will send a pull request for the 1st batch in the next few days.

Batch 1: origin..for-linus
==========================

This contains (1.) a few small fixes, (2.) a small addition to
firewire-core's sysfs ABI in order to considerably simplify udev rules
to set /dev/fw* ownership and ACLs, and (3.) preparations to add more
drivers. Of these preparations, the bigger functional enhancements were
actually already merged in 2.6.30-rc1; the remaining ones are small
functional additions and a total reorganization of files, as you can see
in the diffstat.

After the udev related change went into mainline, I will send the
respective udev rules update to linux-hotplug for inclusion into
mainline udev.

Stefan Richter (14):
      firewire: core: improve check for local node
      firewire: core: check for missing struct update at build time, not run time
      firewire: core: add sysfs attribute for easier udev rules
      firewire: share device ID table type with ieee1394
      firewire: also use vendor ID in root directory for driver matches
      firewire: ohci: access bus_seconds atomically
      firewire: clean up includes
      firewire: reorganize header files
      firewire: rename source files
      firewire: add parent-of-unit accessor
      firewire: core: include linux/uaccess.h instead of asm/uaccess.h
      firewire: core: prepare for non-core children of card devices
      firewire: core: don't update Broadcast_Channel if RFC 2734 conditions aren't met
      firewire: core: use more outbound tlabels

 drivers/firewire/Makefile                          |    8 +-
 drivers/firewire/{fw-card.c => core-card.c}        |   25 +-
 drivers/firewire/{fw-cdev.c => core-cdev.c}        |   13 +-
 drivers/firewire/{fw-device.c => core-device.c}    |  154 ++++-
 drivers/firewire/{fw-iso.c => core-iso.c}          |    6 +-
 .../firewire/{fw-topology.c => core-topology.c}    |   24 +-
 .../{fw-transaction.c => core-transaction.c}       |   36 +-
 drivers/firewire/core.h                            |  293 ++++++++
 drivers/firewire/fw-device.h                       |  202 -----
 drivers/firewire/fw-topology.h                     |   77 --
 drivers/firewire/fw-transaction.h                  |  446 ------------
 drivers/firewire/{fw-ohci.c => ohci.c}             |   19 +-
 drivers/firewire/{fw-ohci.h => ohci.h}             |    6 +-
 drivers/firewire/{fw-sbp2.c => sbp2.c}             |   58 +-
 include/linux/firewire.h                           |  357 +++++++++
 15 files changed, 898 insertions(+), 826 deletions(-)
 rename drivers/firewire/{fw-card.c => core-card.c} (97%)
 rename drivers/firewire/{fw-cdev.c => core-cdev.c} (99%)
 rename drivers/firewire/{fw-device.c => core-device.c} (88%)
 rename drivers/firewire/{fw-iso.c => core-iso.c} (99%)
 rename drivers/firewire/{fw-topology.c => core-topology.c} (97%)
 rename drivers/firewire/{fw-transaction.c => core-transaction.c} (98%)
 create mode 100644 drivers/firewire/core.h
 delete mode 100644 drivers/firewire/fw-device.h
 delete mode 100644 drivers/firewire/fw-topology.h
 delete mode 100644 drivers/firewire/fw-transaction.h
 rename drivers/firewire/{fw-ohci.c => ohci.c} (99%)
 rename drivers/firewire/{fw-ohci.h => ohci.h} (98%)
 rename drivers/firewire/{fw-sbp2.c => sbp2.c} (97%)
 create mode 100644 include/linux/firewire.h


Batch 2: for-linus..for-next
============================

This contains Jay Fenlason's IPv4-over-1394 driver, which is one of the
last two or so bigger steps to make drivers/firewire/ a functional superset
of drivers/ieee1394/.  Alas, the code in here has not been seen on LKML
yet, and I recently encountered some stability issues in stress tests of
the driver.

Jay Fenlason (1):
      firewire: add IPv4 support

Stefan Richter (5):
      firewire: net: add Kconfig item, rename driver
      firewire: net: style changes
      firewire: net: allow for unordered unit discovery
      firewire: net: remove unused code
      firewire: net: adjust net_device ops

 drivers/firewire/Kconfig     |   12 +
 drivers/firewire/Makefile    |    4 +-
 drivers/firewire/core-card.c |    2 +
 drivers/firewire/core-iso.c  |    7 +
 drivers/firewire/core.h      |   87 --
 drivers/firewire/net.c       | 1655 ++++++++++++++++++++++++++++++++++
 drivers/ieee1394/Kconfig     |    2 +-
 include/linux/firewire.h     |   87 ++
 8 files changed, 1767 insertions(+), 89 deletions(-)
 create mode 100644 drivers/firewire/net.c

-- 
Stefan Richter
-=====-==--= -==- -===-
http://arcgraph.de/sr/

