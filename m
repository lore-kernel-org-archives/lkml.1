Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYJOVpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYJOVpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYJOVp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:45:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47350 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYJOVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:45:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 15 Oct 2008 23:44:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.27
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.6559742adfdec1ce@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.
We have got little fixes, the last small bit of BKL removal in the old
stack, and further improved connection stability in the old stack.  Some
work on the new stack has been going on too, but too slow to make it for
this merge.

Jay Fenlason (2):
      firewire: fw_send_request_sync()
      firewire: Add more documentation to firewire-cdev.h

Julia Lawall (1):
      ieee1394: Use DIV_ROUND_UP

Stefan Richter (13):
      ieee1394: sbp2: stricter dma_sync
      ieee1394: sbp2: check for DMA mapping failures
      ieee1394: sbp2: enforce s/g segment size limit
      ieee1394: raw1394: replace BKL by local mutex, make ioctl() and mmap() thread-safe
      ieee1394: raw1394: narrow down the state_mutex protected region
      ieee1394: raw1394: make write() thread-safe
      ieee1394: dv1394, video1394: remove unnecessary expressions
      ieee1394: nodemgr clean up class iterators
      ieee1394: survive a few seconds connection loss
      firewire: fw-sbp2: enforce s/g segment size limit
      firewire: fw-sbp2: fix another small generation access bug
      firewire: fix setting tag and sy in iso transmission
      firewire: fix ioctl() return code

 drivers/firewire/fw-card.c         |   56 ++----
 drivers/firewire/fw-cdev.c         |    6 +-
 drivers/firewire/fw-device.c       |   37 +---
 drivers/firewire/fw-sbp2.c         |  116 +++++-------
 drivers/firewire/fw-transaction.c  |   48 +++++-
 drivers/firewire/fw-transaction.h  |    9 +-
 drivers/ieee1394/csr1212.c         |    2 +-
 drivers/ieee1394/dv1394.c          |    2 +-
 drivers/ieee1394/eth1394.c         |    2 +-
 drivers/ieee1394/nodemgr.c         |  279 +++++++++++-----------------
 drivers/ieee1394/nodemgr.h         |    2 +-
 drivers/ieee1394/raw1394-private.h |    1 +
 drivers/ieee1394/raw1394.c         |  230 +++++++++++++----------
 drivers/ieee1394/sbp2.c            |  218 +++++++++-------------
 drivers/ieee1394/sbp2.h            |   33 +---
 drivers/ieee1394/video1394.c       |    8 +-
 include/linux/firewire-cdev.h      |    9 +-
 17 files changed, 470 insertions(+), 588 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--- =-=- -====
http://arcgraph.de/sr/

