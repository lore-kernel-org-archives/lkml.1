Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbXGIWln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbXGIWln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbXGIWle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:41:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60806 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbXGIWld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:41:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Jul 2007 00:41:12 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.7fe06ab3e2c7f0c3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates.  They have been in -mm for a while,
except for one or another smaller patch and the legacy ABI removal.

What's in there:
  - smaller fixes in the new firewire drivers
  - raw1394 now almost entirely fit for 32bit userland on 64bit kernel
  - removal of ABI parts of raw1394 that have been obsolete for years
  - ieee1394 converted away from class_device
  - a cleanup of ieee1394's nodemgr locks which was held back a little by
    driver core related changes in the last rounds
  - small cleanups

Diffstat and shortlog:

 .../ABI/removed/raw1394_legacy_isochronous         |   16 +
 Documentation/feature-removal-schedule.txt         |   10 -
 drivers/firewire/fw-card.c                         |    7 +-
 drivers/firewire/fw-cdev.c                         |    2 +-
 drivers/firewire/fw-device.c                       |   38 ++-
 drivers/firewire/fw-device.h                       |    1 +
 drivers/firewire/fw-ohci.c                         |    6 +-
 drivers/firewire/fw-sbp2.c                         |  117 ++--
 drivers/firewire/fw-topology.c                     |   66 +--
 drivers/firewire/fw-topology.h                     |   25 +-
 drivers/firewire/fw-transaction.h                  |    3 +-
 drivers/ieee1394/dv1394.c                          |    8 +-
 drivers/ieee1394/eth1394.c                         |    4 +-
 drivers/ieee1394/highlevel.c                       |   45 --
 drivers/ieee1394/highlevel.h                       |   16 +-
 drivers/ieee1394/hosts.c                           |   11 +-
 drivers/ieee1394/hosts.h                           |   10 +-
 drivers/ieee1394/ieee1394_core.c                   |    8 -
 drivers/ieee1394/ieee1394_core.h                   |   15 +-
 drivers/ieee1394/ieee1394_transactions.c           |   30 -
 drivers/ieee1394/ieee1394_transactions.h           |    2 -
 drivers/ieee1394/nodemgr.c                         |  185 ++++---
 drivers/ieee1394/nodemgr.h                         |    4 +-
 drivers/ieee1394/ohci1394.c                        |  272 +--------
 drivers/ieee1394/ohci1394.h                        |   14 -
 drivers/ieee1394/pcilynx.c                         |   16 +-
 drivers/ieee1394/raw1394-private.h                 |    5 -
 drivers/ieee1394/raw1394.c                         |  364 +++++-------
 drivers/ieee1394/raw1394.h                         |    4 +-
 drivers/ieee1394/sbp2.c                            |   15 +-
 drivers/ieee1394/sbp2.h                            |    2 +-
 drivers/ieee1394/video1394.c                       |   10 +-
 include/linux/firewire-cdev.h                      |  297 ++++++++-
 33 files changed, 745 insertions(+), 883 deletions(-)
 create mode 100644 Documentation/ABI/removed/raw1394_legacy_isochronous


Jay Fenlason (1):
      firewire: fw-sbp2: correctly dereference by container_of

Kay Sievers (1):
      ieee1394: convert ieee1394 from "struct class_device" to "struct device"

Kristian Høgsberg (1):
      firewire: Document userspace ioctl interface.

Petr Vandrovec (3):
      ieee1394: raw1394: Fix read() for 32bit userland on 64bit kernel
      ieee1394: raw1394: Fix write() for 32bit userland on 64bit kernel
      ieee1394: raw1394: Add ioctl() for 32bit userland on 64bit kernel

Stefan Richter (25):
      ieee1394: ohci1394: remove dead CONFIG variable
      ieee1394: add comments in struct hpsb_packet
      ieee1394: raw1394: Add ioctl() for 32bit userland on 64bit kernel, amendment
      ieee1394: raw1394: fix a 32/64-bits compat fix
      ieee1394: nodemgr: parallelize between several hosts
      ieee1394: eth1394: revert parent device to that in 2.6.20
      ieee1394: first minimal NUMA awareness
      ieee1394: sbp2: change some module parameters from int to bool
      ieee1394: remove old isochronous ABI
      firewire: fw-sbp2: remove unused struct member
      firewire: missing newline in printk
      firewire: remove unused macro
      firewire: optimize gap count with 1394b leaf nodes
      firewire: support S100B...S400B and link slower than PHY
      firewire: simplify a struct type
      firewire: fw-sbp2: implement max sectors limit for some old bridges
      firewire: fw-sbp2: let SCSI shutdown commands through before logout
      firewire: fw-sbp2: implement nonexclusive login
      firewire: fw-sbp2: use correct speed in sbp2_agent_reset
      firewire: fw-sbp2: memset wants string.h
      firewire: fw-sbp2: correctly align page tables
      firewire: fw-sbp2: add a boundary check
      firewire: fw-sbp2: fix DMA mapping of S/G tables
      firewire: fw-sbp2: fix DMA mapping of command ORBs
      firewire: fw-sbp2: fix DMA mapping of management ORBs
-- 
Stefan Richter
-=====-=-=== -=== -=-=-
http://arcgraph.de/sr/

