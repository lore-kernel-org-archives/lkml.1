Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbYAQVIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbYAQVIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYAQVIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:08:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47015 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYAQVID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:08:03 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 17 Jan 2008 22:07:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git?
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.99a95666fea52a5e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not much, and all of it is meant to be merged post 2.6.24.  The most
notable updates are fixes to firewire-ohci which fundamentally improve
isochronous reception via libdc1394 v2.

After these fixes, the most notable remaining issues with
drivers/firewire are:
  - difficulties to detect SBP-2 (storage) devices on some hosts
    (need to collect debug data for this ASAP),
  - DV reception broken on OHCI 1.0 variants of VIA VT630x,
  - IP over 1394 still not implemented/ ported.

So, distributors of kernel packages, be advised that the firewire
drivers are still not as functional as the classic ieee1394 driver
stack.  As always, more details on this are captured at
wiki.linux1394.org.

I will follow up to this post with two combo patches, reflecting the
merge queue for drivers/ieee1394 and drivers/firewire respectively,
because several of the patches have not been seen on lkml yet, only on
linux1394-devel.  All of the patches have been in -mm though (except for
a refresh of two small patches which happened after -rc8-mm1).

Shortlog and diffstat:

David Moore (3):
      firewire: fw-ohci: Fix for dualbuffer three-or-more buffers
      firewire: fw-ohci: Bug fixes for packet-per-buffer support
      firewire: fw-ohci: Dynamically allocate buffers for DMA descriptors

Jay Fenlason (1):
      firewire: fw-sbp2: quiet logout errors on device removal

Joe Perches (1):
      ieee1394: Add missing "space"

Nick Piggin (1):
      ieee1394: nopage

Rabin Vincent (1):
      firewire: Fix extraction of source node id

Stefan Richter (11):
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


 MAINTAINERS                              |    4 +-
 drivers/firewire/fw-ohci.c               |  390 +++++++++++++---------
 drivers/firewire/fw-sbp2.c               |   84 +++--
 drivers/firewire/fw-transaction.c        |    2 +-
 drivers/ieee1394/dma.c                   |   39 +--
 drivers/ieee1394/ieee1394_transactions.c |   68 ----
 drivers/ieee1394/ohci1394.c              |   12 +-
 drivers/ieee1394/raw1394.c               |    4 +-
 drivers/ieee1394/sbp2.c                  |   52 ++--
 drivers/ieee1394/sbp2.h                  |    1 -
 10 files changed, 340 insertions(+), 316 deletions(-)

-- 
Stefan Richter
-=====-==--- ---= =---=
http://arcgraph.de/sr/

