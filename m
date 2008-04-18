Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbYDRRl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbYDRRl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 13:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYDRRlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 13:41:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45325 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbYDRRlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 13:41:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 18 Apr 2008 19:40:50 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates post 2.6.25
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.32e9d211f9a96358@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.

In the queue, as reported on April 2:

  - raw1394, video1394, dv1394: [improvement] These drivers are no
    longer bound to unit directory devices. This has always been
    unnecessary and got in the way of more specialized out-of-tree
    drivers.
  - firewire-core: [fix] Recognize changes in the configuration ROM of
    devices while they are plugged in.  This is for example necessary to
    correctly deal with power state changes in storage devices with
    Initio chipset.
  - firewire-ohci: [feature] Logging of various events can be enabled
    at runtime by a module parameter.  This helps debugging the drivers
    as well as devices.
  - firewire-ohci: [feature] Unfiltered remote DMA can be enabled at
    compile time via a new option in the kernel hacking menu.  This
    enables remote debugging as with ohci1394.
  - all:  A bunch of bug fixes which seemed to fit into .26 better than
    into .25.  Small cleanups.

New in the queue:

  - ieee1394: [fix] A wrong transmission speed could be calculated for
    mixed 1394a/b setups.
  - firewire-ohci: [fix] Work around chip quirks of Texas Instruments
    controllers (they were sometimes unable to complete AV/C transactions
    and the likes), work around quirks of some versions of JMicron
    controllers (they crashed the drivers or were unable to transmit).

Almost all patches have been seen on LKML (and all on linux1394-devel).
All but two or three recent small fixes have been exposed to -mm and
-next, usually since soon after patches were posted.  Everything
including those recent fixes received a fair amount of testing, notably
by bug reporters in the Fedora community.

linux1394-2.6.git touches lib/Kconfig.debug but applied fine a minute
ago.


Shortlog and diffstat:

Adrian Bunk (1):
      firewire: cleanups

Harvey Harrison (1):
      ieee1394: replace remaining __FUNCTION__ occurrences

Jarod Wilson (6):
      firewire: fw-sbp2: set dual-phase cycle_limit
      firewire: fw-ohci: make sure HCControl register LPS bit is set
      firewire: fw-ohci: log regAccessFail events
      firewire: fw-ohci: don't append to AT context when it's not active
      firewire: replace more hex values with defined csr constants
      firewire: use bitwise and to get reg in handle_registers

Marcin Slusarz (1):
      ieee1394: be*_add_cpu conversion

Philippe De Muyter (1):
      ieee1394: limit early node speed to host interface speed

Robert P. J. Day (2):
      ieee1394: Use shorter list_splice_init() for brevity.
      ieee1394: Remove superfluous calls to kobject_set_name().

Stefan Richter (31):
      ieee1394: sbp2: relax SCSI DMA alignment
      ieee1394: prevent device binding of raw1394, video1394, dv1394
      ieee1394: ohci1394: switch on bus power after resume on PPC PMac
      ieee1394: ohci1394: refactor probe, remove, suspend, resume
      ieee1394: ohci1394: unroll a macro with return
      ieee1394: ohci1394: refactor some printk format strings
      ieee1394: ohci1394: missing PPC PMac feature calls in failure path
      firewire: remove superfluous reference counting
      firewire: fw-sbp2: fix reference counting
      firewire: refactor fw_unit reference counting
      firewire: fw-sbp2: relax SCSI DMA alignment
      firewire: fw-sbp2: remove usages of fw_memcpy_to_be32
      firewire: fw-sbp2: simplify some macros
      firewire: fw-sbp2: remove unnecessary memset
      firewire: fw-sbp2: reduce log noise
      firewire: fw-ohci: add option for remote debugging
      firewire: fw-ohci: switch on bus power after resume on PPC PMac
      firewire: fw-ohci: refactor probe, remove, suspend, resume
      firewire: fw-ohci: add self ID error check
      firewire: fw-ohci: catch self_id_count == 0
      firewire: debug interrupt events
      firewire: fw-ohci: untangle a mixed unsigned/signed expression
      firewire: fw-ohci: missing PPC PMac feature calls in failure path
      firewire: fw-ohci: conditionally log busReset interrupts
      firewire: fw-ohci: extend logging of bus generations and node ID
      firewire: fw-ohci: work around generation bug in TI controllers (fix AV/C and more)
      firewire: replace static ROM cache by allocated cache
      firewire: reread config ROM when device reset the bus
      firewire: remove unused struct member
      firewire: wait until PHY configuration packet was transmitted (fix bus reset loop)
      firewire: fix synchronization of gap counts

 Documentation/debugging-via-ohci1394.txt |   16 +-
 drivers/firewire/Kconfig                 |    5 +
 drivers/firewire/fw-card.c               |   50 +---
 drivers/firewire/fw-cdev.c               |   13 +-
 drivers/firewire/fw-device.c             |  263 ++++++++++++---
 drivers/firewire/fw-device.h             |   38 ++-
 drivers/firewire/fw-iso.c                |    5 -
 drivers/firewire/fw-ohci.c               |  402 ++++++++++++++++++----
 drivers/firewire/fw-ohci.h               |    2 +
 drivers/firewire/fw-sbp2.c               |  150 ++++-----
 drivers/firewire/fw-topology.c           |   10 +-
 drivers/firewire/fw-topology.h           |   11 +-
 drivers/firewire/fw-transaction.c        |   75 ++--
 drivers/firewire/fw-transaction.h        |   10 -
 drivers/ieee1394/csr.c                   |    6 +-
 drivers/ieee1394/dv1394.c                |    4 +-
 drivers/ieee1394/highlevel.c             |    6 +-
 drivers/ieee1394/ieee1394_core.c         |    4 +-
 drivers/ieee1394/nodemgr.c               |    6 +-
 drivers/ieee1394/ohci1394.c              |  229 +++++++------
 drivers/ieee1394/pcilynx.c               |   15 +-
 drivers/ieee1394/raw1394.c               |    2 -
 drivers/ieee1394/sbp2.c                  |   11 +-
 drivers/ieee1394/video1394.c             |    4 +-
 lib/Kconfig.debug                        |   13 +-
 25 files changed, 877 insertions(+), 473 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==--- -=-- =--=-
http://arcgraph.de/sr/

