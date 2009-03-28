Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZC1AMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZC1AMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZC1AMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:12:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40016 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZC1AMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:12:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 28 Mar 2009 01:11:20 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.29
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <tkrat.09e279b9fad0fd3c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.
Most of it are feature additions to firewire-core for userspace drivers
(via libdc1394 and libraw1394), some also for in-kernel drivers.  Much
of it has been written already last year and went into -next early this
year, slightly too late for 2.6.29. Userspace code which uses the
features went over the respective mailinglists and should appear in
libdc1394 and libraw1394 soon.  Also included:  Two recent dvb/firewire
fixes; Mauro has been informed.

Beat Michel Liechti (1):
      DVB: firedtv: FireDTV S2 problems with tuning solved

David Moore (1):
      firewire: Include iso timestamp in headers when header_size > 4

Jay Fenlason (4):
      firewire: add a client_list_lock
      firewire: cdev: use an idr rather than a linked list for resources
      firewire: implement asynchronous stream transmission
      firewire: broadcast channel support

Jay Fenlason, Stefan Richter (2):
      firewire: cdev: add ioctls for isochronous resource management
      firewire: cdev: add ioctl for broadcast write requests

Stefan Richter (44):
      firewire: convert client_list_lock to mutex
      firewire: cdev: documentation fixlet
      firewire: cdev: tcodes input validation
      firewire: cdev: fix race of fw_device_op_release with bus reset
      firewire: cdev: address handler input validation
      firewire: core: remove outdated comment
      firewire: core: remove obsolete assertions
      firewire: standardize a variable name
      firewire: remove line breaks before function names
      firewire: core: remove unused definitions
      firewire: cdev: use list_first_entry
      firewire: prevent creation of multiple IR DMA contexts for the same channel
      firewire: cdev: fix documentation of FW_CDEV_IOC_GET_INFO
      firewire: cdev: reference-count client instances
      firewire: cdev: unify names of struct types and of their instances
      firewire: cdev: sort includes
      firewire: core: topology header fix
      firewire: cdev: add ioctls for manual iso resource management
      firewire: cdev: add ioctl to query maximum transmission speed
      firewire: cdev: restrict broadcast write requests to Units Space
      firewire: cdev: extend transaction payload size check
      firewire: cdev: replace some spin_lock_irqsave by spin_lock_irq
      firewire: cdev: shut down iso context before freeing the buffer
      firewire: cdev: increment fw_cdev_version, update documentation
      firewire: cdev: add ioctls for iso resource management, amendment
      firewire: cdev: simplify a schedule_delayed_work wrapper
      firewire: core: clean up includes
      firewire: core: move some functions
      firewire: core: remove condition which is always false
      firewire: normalize a variable name
      firewire: core: normalize a function argument name
      firewire: cdev: amendment to "add ioctl to query maximum transmission speed"
      firewire: cdev: secure add_descriptor ioctl
      firewire: cdev: fix race of ioctl_send_request with bus reset
      firewire: cdev: simplify FW_CDEV_IOC_SEND_REQUEST return value
      firewire: cdev: add closure to async stream ioctl
      firewire: core: drop unused call parameters of close_transaction
      firewire: core: increase bus manager grace period
      firewire: core: simplify broadcast channel allocation
      firewire: core: optimize propagation of BROADCAST_CHANNEL
      ieee1394: sbp2: follow up on "ieee1394: inherit ud vendor_id from node vendor_id"
      ieee1394: raw1394: add sparse annotations to raw1394_compat_write
      ieee1394: constify device ID tables
      DVB: firedtv: fix printk format mismatch

Tobias Klauser (1):
      ieee1394: Storage class should be before const qualifier

 drivers/firewire/fw-card.c               |  149 +++--
 drivers/firewire/fw-cdev.c               | 1044 +++++++++++++++++++++---------
 drivers/firewire/fw-device.c             |  203 ++++---
 drivers/firewire/fw-device.h             |   23 +-
 drivers/firewire/fw-iso.c                |  227 ++++++-
 drivers/firewire/fw-ohci.c               |  260 ++++----
 drivers/firewire/fw-sbp2.c               |   57 +-
 drivers/firewire/fw-topology.c           |   29 +-
 drivers/firewire/fw-topology.h           |   19 +-
 drivers/firewire/fw-transaction.c        |  185 +++---
 drivers/firewire/fw-transaction.h        |  138 ++---
 drivers/ieee1394/csr.c                   |    8 +-
 drivers/ieee1394/dv1394.c                |    2 +-
 drivers/ieee1394/eth1394.c               |    4 +-
 drivers/ieee1394/highlevel.c             |    2 +-
 drivers/ieee1394/nodemgr.c               |    4 +-
 drivers/ieee1394/nodemgr.h               |    2 +-
 drivers/ieee1394/raw1394.c               |   14 +-
 drivers/ieee1394/sbp2.c                  |    9 +-
 drivers/ieee1394/video1394.c             |    2 +-
 drivers/media/dvb/firewire/firedtv-avc.c |   10 +-
 include/linux/firewire-cdev.h            |  218 ++++++-
 22 files changed, 1684 insertions(+), 925 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--= --== ===--
http://arcgraph.de/sr/

