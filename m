Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbYDBVyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbYDBVyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbYDBVwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:52:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36026 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762160AbYDBVwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:52:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 2 Apr 2008 23:52:04 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git?
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.2c2b24ae6675e749@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, nothing big.  First of all, what's _not_ in linux1394-2.6.git:  DV
reception is still broken in drivers/firewire/ on OHCI 1.0 variants of
VIA VT630x.  IP over 1394 is still not ported from drivers/ieee1394/ to
drivers/firewire/.  Both issues are held up by of lack of manpower.

These and a bunch of other miscellaneous issues with drivers/firewire/
still keep them labeled EXPERIMENTAL for the time to come, even though
we made some good progress with what went in for 2.6.25. Before
distributors consider to switch from the ieee1394 subsystem to the
firewire subsystem, they should have a good look at the ToDo and
migration pages at wiki.linux1394.org.

Now, what do we actually have for 2.6.26:

  - raw1394, video1394, dv1394:  [improvement]  These drivers are no
    longer bound to unit directory devices. This has always been
    unnecessary and got in the way of more specialized out-of-tree
    drivers.
  - firewire-core:  [fix]  Recognize changes in the configuration ROM of
    devices while they are plugged in.
  - firewire-ohci:  [feature]  Logging of various events can be enabled
    at runtime by a module parameter.  This helps debugging the drivers
    as well as devices.
  - firewire-ohci:  [feature]  Unfiltered remote DMA can be enabled at
    compile time via a new option in the kernel hacking menu.  This
    enables remote debugging as with ohci1394.
  - all:  A bunch of bug fixes which seemed to fit into .26 better than
    into .25.  Small cleanups.

Almost all patches have been seen on LKML (and all on linux1394-devel),
hence I don't repost them this time.  They have all been exposed to -mm
and to -next.  In the latter, linux1394-2.6.git is still involved in a
trivial merge conflict due to the kernel hacking menu entry.

Still pending work:  My firewire-core reference counting changes had two
comments from Kristian which I will address in an incremental update;
perhaps I manage to do this in time for the merge.  Also, Pieter
Palmer's iso transmit patch for the ieee1394 stack may perhaps be ready
then.

Shortlog and diffstat:

Adrian Bunk (1):
      firewire: cleanups

Harvey Harrison (1):
      ieee1394: replace remaining __FUNCTION__ occurrences

Jarod Wilson (3):
      firewire: fw-sbp2: set dual-phase cycle_limit
      firewire: replace more hex values with defined csr constants
      firewire: use bitwise and to get reg in handle_registers

Marcin Slusarz (1):
      ieee1394: be*_add_cpu conversion

Robert P. J. Day (2):
      ieee1394: Use shorter list_splice_init() for brevity.
      ieee1394: Remove superfluous calls to kobject_set_name().

Stefan Richter (30):
      ieee1394: sbp2: relax SCSI DMA alignment
      ieee1394: prevent device binding of raw1394, video1394, dv1394
      ieee1394: ohci1394: switch on bus power after resume on PPC PMac
      ieee1394: ohci1394: refactor probe, remove, suspend, resume
      ieee1394: ohci1394: unroll a macro with return
      ieee1394: ohci1394: refactor some printk format strings
      ieee1394: ohci1394: missing PPC PMac feature calls in failure path
      firewire: fw-sbp2: relax SCSI DMA alignment
      firewire: remove superfluous reference counting
      firewire: fw-sbp2: fix reference counting
      firewire: refactor fw_unit reference counting
      firewire: fw-sbp2: remove usages of fw_memcpy_to_be32
      firewire: fw-sbp2: simplify some macros
      firewire: fw-sbp2: remove unnecessary memset
      firewire: fw-sbp2: reduce log noise
      firewire: fw-ohci: add option for remote debugging
      firewire: fw-ohci: switch on bus power after resume on PPC PMac
      firewire: fw-ohci: refactor probe, remove, suspend, resume
      firewire: replace static ROM cache by allocated cache
      firewire: reread config ROM when device reset the bus
      firewire: remove unused struct member
      firewire: insist on successive self ID complete events
      firewire: fw-ohci: add self ID error check
      firewire: fw-ohci: catch self_id_count == 0
      firewire: debug interrupt events
      firewire: fw-ohci: untangle a mixed unsigned/signed expression
      firewire: wait until PHY configuration packet was transmitted (fix bus reset loop)
      firewire: fw-ohci: missing PPC PMac feature calls in failure path
      firewire: unnecessary BM delay after generation rollover
      firewire: fix synchronization of gap counts

 Documentation/debugging-via-ohci1394.txt |   13 +-
 drivers/firewire/Kconfig                 |    5 +
 drivers/firewire/fw-card.c               |   52 +---
 drivers/firewire/fw-cdev.c               |   13 +-
 drivers/firewire/fw-device.c             |  263 +++++++++++++++----
 drivers/firewire/fw-device.h             |   38 ++-
 drivers/firewire/fw-iso.c                |    5 -
 drivers/firewire/fw-ohci.c               |  321 +++++++++++++++++-----
 drivers/firewire/fw-ohci.h               |    1 +
 drivers/firewire/fw-sbp2.c               |  150 +++++------
 drivers/firewire/fw-topology.c           |   22 ++-
 drivers/firewire/fw-topology.h           |   11 +-
 drivers/firewire/fw-transaction.c        |   75 +++---
 drivers/firewire/fw-transaction.h        |   17 +-
 drivers/ieee1394/csr.c                   |    6 +-
 drivers/ieee1394/dv1394.c                |    4 +-
 drivers/ieee1394/highlevel.c             |    6 +-
 drivers/ieee1394/ieee1394_core.c         |    2 +-
 drivers/ieee1394/nodemgr.c               |    6 +-
 drivers/ieee1394/ohci1394.c              |  229 ++++++++--------
 drivers/ieee1394/pcilynx.c               |   15 +-
 drivers/ieee1394/raw1394.c               |    2 -
 drivers/ieee1394/sbp2.c                  |   11 +-
 drivers/ieee1394/video1394.c             |    4 +-
 lib/Kconfig.debug                        |   10 +
 25 files changed, 820 insertions(+), 461 deletions(-)

-- 
Stefan Richter
-=====-==--- -=-- ---=-
http://arcgraph.de/sr/

