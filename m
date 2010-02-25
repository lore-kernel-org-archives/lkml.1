Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab0BYVMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:12:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59764 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab0BYVMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:12:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 25 Feb 2010 22:12:37 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git?
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.2cce8c26bac5aa03@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

if there are no objections, I will see to get the following pulled into
the mainline early next week:

  - three cycle timer related enhancements (hence mostly audio related):
    hardware quirk fix for reliable cycle timer register access,
    "quirks" module parameter for firewire-ohci, choice of clock for
    local time in the read-cycle-timer ioctl,

  - a few fixes (minor ones as far as I can tell),

  - some refactoring like the config ROM text leaf accessor and dead
    code removal.

Clemens Ladisch (2):
      firewire: add fw_csr_string() helper function
      firewire: ohci: work around cycle timer bugs on VIA controllers

Németh Márton (1):
      firewire: make PCI device id constant

Stefan Richter (21):
      firewire: core: fw_csr_string addendum
      firewire: qualify config ROM cache pointers as const pointers
      firewire: ohci: enable cycle timer fix on ALi and NEC controllers
      firewire: get_cycle_timer optimization and cleanup
      firewire: remove incomplete Bus_Time CSR support
      Merge tag 'v2.6.33' for its firewire changes since last branch point
      firewire: core: fix "giving up on config rom" with Panasonic AG-DV2500
      firewire: core: don't fail device creation in case of too large config ROM blocks
      firewire: core: increase stack size of config ROM reader
      firewire: core: fix an information leak
      firewire: core: rename an internal function
      firewire: cdev: add more flexible cycle timer ioctl
      firewire: cdev: increment ABI version number
      firewire: core: change type of a data buffer
      firewire: core: combine a bit of repeated code
      firewire: ohci: remove unused dualbuffer IR code
      firewire: ohci: reorder struct fw_ohci for better cache efficiency
      firewire: ohci: use an ID table for quirks detection
      firewire: ohci: add module parameter to activate quirk fixes
      firewire: ohci: fix IR/IT context mask mixup
      firewire: ohci: extend initialization log message

 drivers/firewire/core-cdev.c            |  368 +++++++++++++++----------------
 drivers/firewire/core-device.c          |  198 +++++++++++------
 drivers/firewire/core-transaction.c     |   17 +-
 drivers/firewire/core.h                 |    2 +-
 drivers/firewire/ohci.c                 |  364 ++++++++++--------------------
 drivers/firewire/sbp2.c                 |    5 +-
 drivers/media/dvb/firewire/firedtv-fw.c |   39 +---
 include/linux/firewire-cdev.h           |   40 +++-
 include/linux/firewire.h                |   11 +-
 include/linux/pci_ids.h                 |    1 -
 10 files changed, 493 insertions(+), 552 deletions(-)

-- 
Stefan Richter
-=====-==-=- --=- ==--=
http://arcgraph.de/sr/

