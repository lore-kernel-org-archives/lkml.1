Return-Path: <linux-kernel-owner+w=401wt.eu-S1758011AbYESNQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011AbYESNQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYESNQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:16:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57941 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904AbYESNQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:16:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/57] watchdog: Giant scrub
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:04:40 +0100
Message-ID: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Out damn'd lock, out I say...

The gnomes have been having a spring clean. This tidy up brings all of the
watchdog drivers into coding style (except where it doesn't make sense). I've
also systematically

- Checked and if need be fixed the locking
- Removed the use of semaphores for open/close handling
- Switched them to unlocked_ioctl
- Checked there are no misc_register races for BKL dropping later

I've also eliminated an escaped use of inb/outb_p on a PCI device

These cover so many architectures I've not been able to build test the
lot so there may be the old follow up needed on the build front.

Alan

---

Alan Cox (57):
      wdt501/pci: Clean up, coding style and switch to unlocked_ioctl
      wdt977: clean up, coding style and switch to unlocked_ioctl
      wdt285: switch to unlocked_ioctl and tidy up oddments of coding style
      wdrtas: clean up, coding style, switch to unlocked_ioctl
      wafer5823wdt: Clean up, coding style, switch to unlocked_ioctl
      w83977f_wdt: clean up, coding style and switch to unlocked_ioctl
      w83877f_wdt: clean up code, coding style, switch to unlocked_ioctl
      w83697hf_wdt: cleanup, coding style and switch to unlocked_ioctl
      w83627hf: coding style, clean up and switch to unlocked_ioctl
      txx9: Fix locking, switch to unlocked_ioctl
      softdog: clean up, coding style and switch to unlocked_ioctl
      smsc37b787_wdt: coding style, switch to unlocked_ioctl
      shwdt: coding style, cleanup, switch to unlocked_ioctl
      scx200_wdt: clean up and switch to unlocked_ioctl
      sc520_wdt: Clean up and switch to unlocked_ioctl
      sc1200_wdt: clean up, fix locking and use unlocked_ioctl
      sb_wdog: Clean up and switch to unlocked_ioctl
      sbc_epx_c3_wdt: switch to unlocked_ioctl
      sbc8360: clean up
      stg7240_wdt: unlocked_ioctl
      sbc60xxwdt: clean up and switch to unlocked_ioctl
      sa1100_wdt: Switch to unlocked_ioctl
      s3c2410: watchdog cleanup and switch to unlocked_ioctl
      rm9k_wdt: clean up
      pnx4008_wdt: unlocked_ioctl setup
      pcwd: clean up, unlocked_ioctl usage
      pc87413_wdt: clean up, coding style, unlocked_ioctl
      omap_wdt: locking, unlocked_ioctl, tidy
      mv64x60_wdt: clean up and locking checks
      mtx-1_wdt: clean up, coding style, unlocked ioctl
      mpcore watchdog: unlocked_ioctl and BKl work
      mpc watchdog: clean up and locking
      mixcomwd: coding style locking, unlocked_ioctl
      machzwd: clean up, coding style, unlocked_ioctl
      ks8695_wdt: clean up, coding style, unlocked_ioctl
      ixp4xx_wdt: unlocked_ioctl
      ixp2000_wdt: clean up and unlocked_ioctl
      booke watchdog: clean up and unlocked_ioctl
      bfin: watchdog cleanup and unlocked_ioctl
      iTCO: unlocked_ioctl, coding style and cleanup
      it8712f: unlocked_ioctl
      iop: watchdog switch to unlocked_ioctl
      indydog: Clean up and tidy
      ibmasr: coding style, locking verify
      i6300esb: Style, unlocked_ioctl, cleanup
      ib700wdt: clean up and switch to unlocked_ioctl
      hpwdt: couple of include cleanups
      eurotechwdt: unlocked_ioctl, code lock check and tidy
      ep93xx_wdt: unlocked_ioctl
      davinci_wdt: unlocked_ioctl and check locking
      cpu5_wdt: switch to unlocked_ioctl
      at91: watchdog to unlocked_ioctl
      atp watchdog
      AR7 watchdog
      ali: watchdog locking and style
      clean up and check advantech watchdog
      Clean acquirewdt and check for BKL dependancies


 drivers/char/ip2/Makefile              |    4 
 drivers/char/ip2/ip2main.c             |   23 --
 drivers/watchdog/acquirewdt.c          |  119 ++++-----
 drivers/watchdog/advantechwdt.c        |  133 ++++------
 drivers/watchdog/alim1535_wdt.c        |  186 +++++++------
 drivers/watchdog/alim7101_wdt.c        |  224 +++++++++-------
 drivers/watchdog/ar7_wdt.c             |   29 +-
 drivers/watchdog/at32ap700x_wdt.c      |    7 -
 drivers/watchdog/at91rm9200_wdt.c      |  108 ++++----
 drivers/watchdog/bfin_wdt.c            |  147 +++++------
 drivers/watchdog/booke_wdt.c           |   57 ++--
 drivers/watchdog/cpu5wdt.c             |  144 +++++-----
 drivers/watchdog/davinci_wdt.c         |   11 -
 drivers/watchdog/ep93xx_wdt.c          |   17 +
 drivers/watchdog/eurotechwdt.c         |   57 +++-
 drivers/watchdog/hpwdt.c               |    4 
 drivers/watchdog/i6300esb.c            |  342 ++++++++++++-------------
 drivers/watchdog/iTCO_vendor.h         |   15 +
 drivers/watchdog/iTCO_vendor_support.c |   53 ++--
 drivers/watchdog/iTCO_wdt.c            |  294 ++++++++++-----------
 drivers/watchdog/ib700wdt.c            |  103 ++++---
 drivers/watchdog/ibmasr.c              |  149 ++++++-----
 drivers/watchdog/indydog.c             |  114 ++++----
 drivers/watchdog/iop_wdt.c             |   46 ++-
 drivers/watchdog/it8712f_wdt.c         |   77 ++----
 drivers/watchdog/ixp2000_wdt.c         |   50 ++--
 drivers/watchdog/ixp4xx_wdt.c          |   41 +--
 drivers/watchdog/ks8695_wdt.c          |  119 ++++-----
 drivers/watchdog/machzwd.c             |  108 +++-----
 drivers/watchdog/mixcomwd.c            |  133 +++++-----
 drivers/watchdog/mpc5200_wdt.c         |   20 +
 drivers/watchdog/mpc83xx_wdt.c         |   19 +
 drivers/watchdog/mpc8xx_wdt.c          |   37 +--
 drivers/watchdog/mpcore_wdt.c          |   53 ++--
 drivers/watchdog/mtx-1_wdt.c           |  107 ++++----
 drivers/watchdog/mv64x60_wdt.c         |   20 +
 drivers/watchdog/omap_wdt.c            |   35 ++-
 drivers/watchdog/pc87413_wdt.c         |  211 ++++++---------
 drivers/watchdog/pcwd.c                |  179 +++++++------
 drivers/watchdog/pnx4008_wdt.c         |   18 +
 drivers/watchdog/rm9k_wdt.c            |   21 +-
 drivers/watchdog/s3c2410_wdt.c         |  148 ++++++-----
 drivers/watchdog/sa1100_wdt.c          |   32 +-
 drivers/watchdog/sb_wdog.c             |   78 +++---
 drivers/watchdog/sbc60xxwdt.c          |  223 ++++++++--------
 drivers/watchdog/sbc7240_wdt.c         |   16 +
 drivers/watchdog/sbc8360.c             |   30 +-
 drivers/watchdog/sbc_epx_c3.c          |   12 -
 drivers/watchdog/sc1200wdt.c           |  203 ++++++++-------
 drivers/watchdog/sc520_wdt.c           |  163 ++++++------
 drivers/watchdog/scx200_wdt.c          |   59 ++--
 drivers/watchdog/shwdt.c               |  139 ++++++----
 drivers/watchdog/smsc37b787_wdt.c      |  442 ++++++++++++++++----------------
 drivers/watchdog/softdog.c             |   87 +++---
 drivers/watchdog/txx9wdt.c             |   31 +-
 drivers/watchdog/w83627hf_wdt.c        |  175 ++++++-------
 drivers/watchdog/w83697hf_wdt.c        |  141 +++++-----
 drivers/watchdog/w83877f_wdt.c         |  199 +++++++-------
 drivers/watchdog/w83977f_wdt.c         |  225 ++++++++--------
 drivers/watchdog/wafer5823wdt.c        |   80 +++---
 drivers/watchdog/wdrtas.c              |  103 +++----
 drivers/watchdog/wdt.c                 |  176 +++++++------
 drivers/watchdog/wdt285.c              |   31 +-
 drivers/watchdog/wdt977.c              |  148 +++++------
 drivers/watchdog/wdt_pci.c             |  300 ++++++++++++----------
 65 files changed, 3479 insertions(+), 3396 deletions(-)
 create mode 100644 drivers/watchdog/iTCO_vendor.h

-- 
       "Also I poked a hole in the projector screen when pointing my
        replica Roman sword at the site of the Battle of Lake Regillus
        and am in Big Trouble."
                        -- Matthew Peacock

