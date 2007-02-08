Return-Path: <linux-kernel-owner+w=401wt.eu-S1423416AbXBHV2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423416AbXBHV2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423397AbXBHV2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:28:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45974 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423416AbXBHV2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:28:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Feb 2007 22:27:42 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 updates post 2.6.20
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.792fbaf365daed11@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive IEEE 1394 subsystem updates as listed further below.
The upshot:

  - another bit to get suspend/resume going (bug 7072)
  - fix video1394 on systems with IO bounce buffers, i.e. typically
    on EMT64 with more than ca. 3GB RAM
  - fix old issues with PCCard ejection while dv1394 is loaded (bug
    7121) and LLD unloading while raw1394 is in use (bug 7701)
  - fix a regression in 2.6.20-rc1 in nodemgr (bug 7942, -stable will
    get their share)
  - remove some fat (people who want to have OUIs translated to
    company names can use the ls1394 script)

The patches have been written in December and January and have been in
-mm soon after they were submitted --- except for the three fixes in
video1394, raw1394, and nodemgr which are fresh from February but are
duly tested.


 Documentation/feature-removal-schedule.txt |   16 -
 drivers/ieee1394/.gitignore                |    1 -
 drivers/ieee1394/Kconfig                   |   21 -
 drivers/ieee1394/Makefile                  |   10 -
 drivers/ieee1394/csr1212.c                 |   15 +-
 drivers/ieee1394/dv1394.c                  |   46 +-
 drivers/ieee1394/hosts.c                   |   13 +-
 drivers/ieee1394/hosts.h                   |    7 +-
 drivers/ieee1394/ieee1394_core.c           |   23 +-
 drivers/ieee1394/nodemgr.c                 |   63 +-
 drivers/ieee1394/nodemgr.h                 |    3 -
 drivers/ieee1394/ohci1394.c                |   17 +-
 drivers/ieee1394/oui.db                    | 7048 ----------------------------
 drivers/ieee1394/oui2c.sh                  |   22 -
 drivers/ieee1394/raw1394.c                 |   48 +-
 drivers/ieee1394/sbp2.c                    |   23 +-
 drivers/ieee1394/video1394.c               |    8 +
 include/linux/pci_ids.h                    |    1 +
 18 files changed, 105 insertions(+), 7280 deletions(-)
 delete mode 100644 drivers/ieee1394/.gitignore
 delete mode 100644 drivers/ieee1394/oui.db
 delete mode 100644 drivers/ieee1394/oui2c.sh


Adrian Bunk (2):
      the scheduled IEEE1394_EXPORT_FULL_API removal
      the scheduled IEEE1394_OUI_DB removal

Andrea Guzzo (1):
      ieee1394: modified csr1212_key_id_type_map to support lisight

David Moore (1):
      ieee1394: video1394: DMA fix

Kristian Høgsberg (1):
      Add PCI class ID for firewire OHCI controllers.

Stefan Richter (11):
      ieee1394: sbp2: use a better wildcard for blacklist
      ieee1394: nodemgr: check info_length in ROM header earlier
      ieee1394: ohci1394: drop pcmcia-cs compatibility code
      ieee1394: restore config ROM when resuming
      ieee1394: save one word in struct hpsb_host
      ieee1394: sbp2: remove bogus "emulated" host flag
      ieee1394: sbp2: lower block queue alignment requirement
      ieee1394: dv1394: fix CardBus card ejection
      ieee1394: dv1394: tidy up card removal
      ieee1394: raw1394: prevent unloading of low-level driver
      ieee1394: fix host device registering when nodemgr disabled

-- 
Stefan Richter
-=====-=-=== --=- -=---
http://arcgraph.de/sr/

