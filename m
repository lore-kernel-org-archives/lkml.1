Return-Path: <linux-kernel-owner+w=401wt.eu-S1763020AbZFPVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763020AbZFPVWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZFPVWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:22:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52261 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZFPVWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:22:22 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Jun 2009 23:22:04 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.30
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.9282749343d60f9f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates:
  - a few small fixes,
  - a new sysfs attribute for simpler and saner udev rules,
  - preparations to add more drivers to the newer firewire stack
    (mostly just header reorganization and file renames, as obvious in
    the diffstat).

Admittedly, more than half of the commits are from June, but it's not
much and not complex and was successfully exposed to linux-next as long
as possible.

There is one firewire-sbp2 change in Greg's driver core pull request,
but git will merge it correctly regardless of the merge order.

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
 drivers/firewire/{fw-device.c => core-device.c}    |  154 ++++++-
 drivers/firewire/{fw-iso.c => core-iso.c}          |    6 +-
 .../firewire/{fw-topology.c => core-topology.c}    |   24 +-
 .../{fw-transaction.c => core-transaction.c}       |   42 ++-
 drivers/firewire/core.h                            |  293 +++++++++++++
 drivers/firewire/fw-device.h                       |  202 ---------
 drivers/firewire/fw-topology.h                     |   77 ----
 drivers/firewire/fw-transaction.h                  |  446 --------------------
 drivers/firewire/{fw-ohci.c => ohci.c}             |   19 +-
 drivers/firewire/{fw-ohci.h => ohci.h}             |    6 +-
 drivers/firewire/{fw-sbp2.c => sbp2.c}             |   58 ++-
 include/linux/firewire.h                           |  358 ++++++++++++++++
 15 files changed, 902 insertions(+), 829 deletions(-)
 rename drivers/firewire/{fw-card.c => core-card.c} (97%)
 rename drivers/firewire/{fw-cdev.c => core-cdev.c} (99%)
 rename drivers/firewire/{fw-device.c => core-device.c} (88%)
 rename drivers/firewire/{fw-iso.c => core-iso.c} (99%)
 rename drivers/firewire/{fw-topology.c => core-topology.c} (97%)
 rename drivers/firewire/{fw-transaction.c => core-transaction.c} (97%)
 create mode 100644 drivers/firewire/core.h
 delete mode 100644 drivers/firewire/fw-device.h
 delete mode 100644 drivers/firewire/fw-topology.h
 delete mode 100644 drivers/firewire/fw-transaction.h
 rename drivers/firewire/{fw-ohci.c => ohci.c} (99%)
 rename drivers/firewire/{fw-ohci.h => ohci.h} (98%)
 rename drivers/firewire/{fw-sbp2.c => sbp2.c} (97%)
 create mode 100644 include/linux/firewire.h

Thanks,
-- 
Stefan Richter
-=====-==--= -==- =----
http://arcgraph.de/sr/

