Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbZBXRt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbZBXRt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZBXRtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:49:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46919 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBXRtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:49:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 24 Feb 2009 18:48:35 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] DVB + ieee1394: firedtv driver
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>
Message-ID: <tkrat.847a062a8a488f0d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

if you don't mind receiving yet another new driver this late in the
game, then please pull from the firedtv-merge branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv-merge

to receive the following IEEE 1394 + DVB updates.  More information
after the shortlog and diffstat...

Beat Michel Liechti (1):
      firedtv: dvb_frontend_info for FireDTV S2, fix "frequency limits undefined" error

Ben Backx (2):
      firesat: fix DVB-S2 device recognition
      firesat: add DVB-S support for DVB-S2 devices

Greg Kroah-Hartman (1):
      DVB: add firesat driver

Henrik Kurelid (5):
      firesat: update isochronous interface, add CI support
      firesat: avc resend
      firedtv: fix returned struct for ca_info
      firedtv: use length_field() of PMT as length
      firedtv: fix registration - adapter number could only be zero

Julia Lawall (1):
      firedtv: Use DEFINE_SPINLOCK

Rambaldi (1):
      firedtv: rename files, variables, functions from firesat to firedtv

Stefan Richter (7):
      firesat: copyrights, rename to firedtv, API conversions, fix remote control input
      ieee1394: use correct barrier types between accesses of nodeid and generation
      ieee1394: add hpsb_node_read() and hpsb_node_lock()
      ieee1394: inherit ud vendor_id from node vendor_id
      ieee1394: remove superfluous assertions
      firedtv: cleanups and minor fixes
      firedtv: massive refactoring

 drivers/ieee1394/dma.h                    |    1 +
 drivers/ieee1394/ieee1394_core.c          |    1 +
 drivers/ieee1394/ieee1394_transactions.c  |   31 +-
 drivers/ieee1394/ieee1394_transactions.h  |    2 +
 drivers/ieee1394/iso.h                    |    1 +
 drivers/ieee1394/nodemgr.c                |   10 +-
 drivers/ieee1394/nodemgr.h                |   18 +
 drivers/media/dvb/Kconfig                 |    4 +
 drivers/media/dvb/Makefile                |    2 +
 drivers/media/dvb/firewire/Kconfig        |   22 +
 drivers/media/dvb/firewire/Makefile       |    8 +
 drivers/media/dvb/firewire/firedtv-1394.c |  285 +++++++
 drivers/media/dvb/firewire/firedtv-avc.c  | 1315 +++++++++++++++++++++++++++++
 drivers/media/dvb/firewire/firedtv-ci.c   |  260 ++++++
 drivers/media/dvb/firewire/firedtv-dvb.c  |  364 ++++++++
 drivers/media/dvb/firewire/firedtv-fe.c   |  247 ++++++
 drivers/media/dvb/firewire/firedtv-rc.c   |  190 +++++
 drivers/media/dvb/firewire/firedtv.h      |  182 ++++
 18 files changed, 2936 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/dvb/firewire/Kconfig
 create mode 100644 drivers/media/dvb/firewire/Makefile
 create mode 100644 drivers/media/dvb/firewire/firedtv-1394.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-avc.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-ci.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-dvb.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-fe.c
 create mode 100644 drivers/media/dvb/firewire/firedtv-rc.c
 create mode 100644 drivers/media/dvb/firewire/firedtv.h

Some background:

firedtv is a driver for a series of DVB boxes and cards which are
attached through FireWire.  The driver has already been in use by
enthusiasts during the last ~half year and has been exposed in
linux-next for several months.

The ieee1394 core changes which accompany the driver are rather
peripheral and have been in successful testing for months too.  For
these changes, this DVB driver was taken through the linux1394-2.6.git
tree rather than the DVB tree.

The final review posting of the driver a week ago at
http://lkml.org/lkml/2009/2/16/270 has been
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Still to do:
  - Make it also work with firewire-core alternatively to the older
    ieee1394 core.  (50% done)
  - Support the new DVB S2API.
  - Broader exposure to users will surely bring up one or the other
    issue although it works fine here. :-)

Changes since last week's review:
  - msecs_to_jiffies fixlet suggested by Mauro,
  - reenable verbose logging option (recommended to me by Henrik)
  - small Kconfig fix for CONFIG-INPUT=m, folded into the history for
    100% bisectability,
  - FireDTV S2 frontend info fixlet,
  - collapsed more than 50 baby-step cleanup commits written by me into
    fewer commits.  The old history is still available in
    linux1394-2.6.git's firedtv branch.

Thanks,
-- 
Stefan Richter
-=====-==--= --=- ==---
http://arcgraph.de/sr/

