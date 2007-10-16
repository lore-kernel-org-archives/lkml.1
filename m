Return-Path: <linux-kernel-owner+w=401wt.eu-S935791AbXJPWjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935791AbXJPWjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759748AbXJPWjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:39:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44230 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067AbXJPWjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:39:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 17 Oct 2007 00:39:10 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates post 2.6.23
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.762cf4d84dd2db77@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.  It's
almost all just bugfixes, and had I anticipated that 2.6.23 was going to
grow an -rc9 I would have sent most of the material for the new firewire
stack already during the rc phase.

Most patches went into -mm during mid July...mid September; some simple
patches are from the past two weeks.  Combined diff follows in a reply.
Stat and shortlog:

 drivers/firewire/fw-cdev.c        |   52 ++-
 drivers/firewire/fw-device.h      |    5 -
 drivers/firewire/fw-ohci.c        |   41 ++-
 drivers/firewire/fw-ohci.h        |    2 +
 drivers/firewire/fw-sbp2.c        |  647 +++++++++++++++++------------
 drivers/firewire/fw-topology.c    |   10 +-
 drivers/firewire/fw-topology.h    |    6 -
 drivers/firewire/fw-transaction.c |   12 +-
 drivers/ieee1394/csr1212.c        |   57 ++--
 drivers/ieee1394/csr1212.h        |    6 +-
 drivers/ieee1394/eth1394.c        |   16 +-
 drivers/ieee1394/ieee1394_core.c  |    2 +-
 drivers/ieee1394/nodemgr.c        |   22 +-
 drivers/ieee1394/pcilynx.c        |   29 +-
 drivers/ieee1394/sbp2.c           |   15 +
 include/linux/firewire-cdev.h     |   15 +
 16 files changed, 560 insertions(+), 377 deletions(-)

Jay Fenlason (1):
      firewire: fw-cdev: reorder wakeup vs. spinlock

Jean Delvare (1):
      ieee1394: pcilynx: I2C cleanups

Matthias Kaehlcke (1):
      ieee1394: ieee1394_core.c: use DEFINE_SPINLOCK for spinlock definition

Satyam Sharma (1):
      ieee1394: Fix kthread stopping in nodemgr_host_thread

Stefan Richter (20):
      ieee1394: eth1394: superfluous local variable
      ieee1394: eth1394: fix lock imbalance
      ieee1394: pcilynx: superfluous local variables
      ieee1394: sbp2: fix unsafe iteration over list of devices
      ieee1394: nodemgr: fix leak of struct csr1212_keyval
      ieee1394: csr1212: proper refcounting
      firewire: optimize fw_core_add_address_handler
      firewire: fw-core: local variable shadows a global one
      firewire: fw-sbp2: always enable IRQs before calling command ORB callback
      firewire: fw-sbp2: add support for multiple logical units per target
      firewire: fw-sbp2: expose module parameter for workarounds
      firewire: fw-sbp2: use an own workqueue (fix system responsiveness)
      firewire: fw-ohci: enforce read order for selfID generation
      firewire: fw-ohci: fix includes
      firewire: fw-ohci: reorder includes
      firewire: fw-ohci: log posted write errors
      firewire: fw-ohci: missing dma_unmap_single
      firewire: fw-ohci: check for misconfigured bus (phyID == 63)
      firewire: adopt read cycle timer ABI from raw1394
      firewire: a header cleanup

Yann Dirson (1):
      firewire: in-code doc updates.

-- 
Stefan Richter
-=====-=-=== =-=- =---=
http://arcgraph.de/sr/

