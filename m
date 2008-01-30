Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbYA3Wyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbYA3Wyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYA3Wyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:54:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58182 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYA3Wyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:54:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 30 Jan 2008 23:53:34 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates post 2.6.24
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.  Once
again it is almost all about bug fixes.  Most notable are David Moore's
fixes for isochronous reception which greatly enhance the new firewire
stack's usability in the IIDC domain (uncompressed video from industrial
cameras and webcams).  The storage driver firewire-sbp2 received some
attention too, prompted by user reports, but that's an ongoing story.

I let self-discipline slide this time and added 9 patches which have not
yet been in -mm and were not listed in the "What's in linux1394-2.6.git?"
report from January 17.  Half of those are bug fixes from November which
have been laying around waiting for last touch-up until we noticed in
January that they indeed address a good number of bug reports.  The other
new additions are bug fixes too.  Everything has been intensively tested
with affected and unaffected hardware.

Updated status of the new (still EXPERIMENTAL) drivers/firewire
subsystem:
  - integration with userspace libraries still with rough edges,
  - DV reception broken on OHCI 1.0 variants of VIA VT630x,
  - IP over 1394 still not implemented/ ported,
  - SBP-2 (storage) fragile during hotplugging on some setups.

Before distributors of kernel packages consider to enable the new
firewire drivers in parallel or instead of the classic ieee1394 drivers,
we ask that they first read up about all the caveats of the new drivers
at wiki.linux1394.org which we regularly update.

I will re-post the newly added patches in a reply.  Stat and shortlog of
the entire queue:

 MAINTAINERS                              |    4 +-
 drivers/firewire/fw-cdev.c               |    3 +-
 drivers/firewire/fw-device.c             |   38 ++-
 drivers/firewire/fw-device.h             |   12 +
 drivers/firewire/fw-ohci.c               |  390 +++++++++++++---------
 drivers/firewire/fw-sbp2.c               |  127 +++++---
 drivers/firewire/fw-topology.c           |    6 +
 drivers/firewire/fw-transaction.c        |    4 +-
 drivers/ieee1394/dma.c                   |   39 +--
 drivers/ieee1394/ieee1394_transactions.c |   68 ----
 drivers/ieee1394/ohci1394.c              |   12 +-
 drivers/ieee1394/raw1394.c               |    4 +-
 drivers/ieee1394/sbp2.c                  |   52 ++--
 drivers/ieee1394/sbp2.h                  |    1 -
 14 files changed, 424 insertions(+), 336 deletions(-)

David Moore (3):
      firewire: fw-ohci: Fix for dualbuffer three-or-more buffers
      firewire: fw-ohci: Bug fixes for packet-per-buffer support
      firewire: fw-ohci: Dynamically allocate buffers for DMA descriptors

Jarod Wilson (3):
      firewire: replace subtraction with bitwise and
      firewire: fw-sbp2: increase login orb reply timeout, fix "failed to login"
      firewire: fw-sbp2: Use sbp2 device-provided mgt orb timeout for logins

Joe Perches (1):
      ieee1394: Add missing "space"

Nick Piggin (1):
      ieee1394: nopage

Rabin Vincent (1):
      firewire: Fix extraction of source node id

Stefan Richter (17):
      ieee1394: sbp2: prepare for s/g chaining
      ieee1394: sbp2: s/g list access cosmetics
      ieee1394: small cleanup after "nopage"
      ieee1394: remove unused code
      ieee1394: sbp2: raise default transfer size limit
      ieee1394: ohci1394: don't schedule IT tasklets on IR events
      firewire: fw-sbp2: refactor workq and kref handling
      firewire: fw-sbp2: prepare for s/g chaining
      firewire: fw-sbp2: remove unused misleading macro
      firewire: fw-ohci: CycleTooLong interrupt management
      firewire vs. ieee1394: clarify MAINTAINERS
      firewire: fw-sbp2: skip unnecessary logout
      firewire: fw-sbp2: try to increase reconnect_hold (speed up reconnection)
      firewire: fw-sbp2: use device generation, not card generation
      firewire: fw-cdev: use device generation, not card generation
      firewire: enforce access order between generation and node ID, fix "giving up on config rom"
      firewire: fw-core: react on bus resets while the config ROM is being fetched

-- 
Stefan Richter
-=====-==--- ---= ====-
http://arcgraph.de/sr/

