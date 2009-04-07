Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZDGEoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZDGEoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZDGEn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:43:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46993 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZDGEn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:43:58 -0400
Subject: [GIT *] Remaining firmware patches.
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 06 Apr 2009 21:43:54 -0700
Message-Id: <1239079434.22733.377.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from git://git.infradead.org/~dwmw2/firmware-2.6.git

With some sterling work by Jaswinder, I think we've pushed most of the
driver patches upstream through their respective maintainers, to cleanly
separate driver code from loadable firmware.

What I have left is a few things which have mostly been sitting in
linux-next for a while now without much attention...

There was a suboptimal fix for a problem with running modules_install
from a read-only NFS tree. The bug had been introduced by an accidental
change which slipped in through the DVB tree, and the better fix would
have been to partially revert the offending commit. This tree does that,
and reverts the subsequent 'fix' which is now rendered unnecessary.

It has a couple of driver conversions to use request_firmware() -- one
for an ALSA driver which came from Takashi and never got pushed further
for some reason, and another for av7110 bootstrap code (and we actually
managed to find the source for that blob, too).

Also in the av7110 DVB driver, it removes some obsolete support for
building the runtime firmware into the kernel -- we have a generic way
of doing that now.

With GregKH's approval, it removes the slicoss and sxg firmware images
which slipped in via the staging tree. The intention was never that we
start adding lots of _new_ firmware to the kernel source; we have a
separate linux-firmware.git repository which is now the canonical
location to collect that.

I've added a README.AddingFirmware file to document the situation and
tell people how to submit new firmware to the linux-firmware.git repo.

David Woodhouse (5):
      Revert "fix modules_install via NFS"
      Partially revert "V4L/DVB (9533): cx88: Add support for TurboSight TBS8910
      firmware/WHENCE: Add missing origin information for Ambassador atmsar11.fw
      firmware: Remove newly-added slicoss and sxg firmware images
      Add README.AddingFirmware file. Basically telling people not to.

Jaswinder Singh (2):
      firmware: convert av7110 driver to request_firmware()
      Remove fdump tool for av7110 firmware

Takashi Iwai (1):
      ALSA: wavefront - Always use request_firmware()

 drivers/media/dvb/ttpci/Kconfig            |   23 +-
 drivers/media/dvb/ttpci/Makefile           |    9 -
 drivers/media/dvb/ttpci/av7110.c           |   16 -
 drivers/media/dvb/ttpci/av7110_hw.c        |   35 +-
 drivers/media/dvb/ttpci/av7110_hw.h        |    3 +-
 drivers/media/dvb/ttpci/fdump.c            |   44 -
 firmware/.gitignore                        |    1 +
 firmware/Makefile                          |   30 +-
 firmware/README.AddingFirmware             |   34 +
 firmware/WHENCE                            |   93 +-
 firmware/av7110/Boot.S                     |  109 +
 firmware/av7110/bootcode.bin.ihex          |   15 +
 firmware/ihex2fw.c                         |  268 ++
 firmware/slicoss/gbdownload.sys.ihex       | 6148 ----------------------------
 firmware/slicoss/gbrcvucode.sys.ihex       |  162 -
 firmware/slicoss/oasisdbgdownload.sys.ihex | 5124 -----------------------
 firmware/slicoss/oasisdownload.sys.ihex    | 5124 -----------------------
 firmware/slicoss/oasisrcvucode.sys.ihex    |  162 -
 firmware/sxg/saharadbgdownloadB.sys.ihex   | 3937 ------------------
 firmware/sxg/saharadownloadB.sys.ihex      | 3385 ---------------
 firmware/yamaha/yss225_registers.bin.ihex  |  998 +++++
 scripts/.gitignore                         |    1 -
 scripts/Makefile                           |    3 +-
 scripts/ihex2fw.c                          |  268 --
 sound/isa/Kconfig                          |   10 -
 sound/isa/wavefront/wavefront_fx.c         |   16 -
 sound/isa/wavefront/yss225.c               | 2739 -------------
 27 files changed, 1505 insertions(+), 27252 deletions(-)


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

