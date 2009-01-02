Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZABNbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZABNbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 08:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZABNbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 08:31:00 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:33546 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZABNa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:30:59 -0500
Message-ID: <495E167A.40300@csr.com>
Date: Fri, 02 Jan 2009 13:28:26 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] UWB, WUSB, and WLP subsystems for 2.6.29
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jan 2009 13:28:26.0588 (UTC) FILETIME=[FE3EF1C0:01C96CDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull various updates for the UWB, WUSB and WLP subsystems from

git://git.kernel.org/pub/scm/linux/kernel/git/dvrabel/uwb.git for-upstream

David Vrabel (27):
      uwb: target reservations shouldn't get streams
      wusb: release mutex in the error path of whci-hcd's whc_do_gencmd()
      uwb: reference count reservations
      wusb: disable verification of the key generation algorithms
      wusb: do a proper channel stop
      uwb: order IEs by element ID
      wusb: reset WUSB devices with SetAddress(0)
      uwb: don't unbind the radio controller driver when resetting
      uwb: fix races between events and neh timers
      uwb: add pal parameter to new reservation callback
      uwb: add basic radio manager
      wlp: start/stop radio on network interface up/down
      uwb: remove unused beacon group join/leave events
      wusb: whci-hcd shouldn't do ASL/PZL updates while channel is inactive
      uwb: clean up whci_wait_for() timeout error message
      uwb: fix oops in debug PAL's reservation callback
      wusb: add debug files for ASL, PZL and DI to the whci-hcd driver
      uwb: fix oops when terminating an already terminated reservation
      wusb: fix oops when terminating a non-existant reservation
      uwb: fix memory leak in uwb_rc_notif()
      uwb: use dev_dbg() for debug messages
      uwb: use print_hex_dump()
      uwb: remove unused include/linux/uwb/debug.h

Huang Weiyi (2):
      uwb: remove unused #include <version.h>
      wusb: remove unused #include <version.h>

Kay Sievers (1):
      uwb: struct device - replace bus_id with dev_name(), dev_set_name()

Stefano Panella (5):
      uwb: infrastructure for handling Relinquish Request IEs
      uwb: add commands to add/remove IEs to the debug interface
      uwb: per-radio controller event thread and beacon cache
      uwb: improved MAS allocator and reservation conflict handling
      uwb: remove beacon cache entry after calling uwb_notify()

 Documentation/ABI/testing/sysfs-class-uwb_rc |   14 +-
 Documentation/usb/wusb-cbaf                  |    9 -
 drivers/usb/host/hwa-hc.c                    |  159 ++----
 drivers/usb/host/whci/Kbuild                 |    1 +
 drivers/usb/host/whci/asl.c                  |   46 +-
 drivers/usb/host/whci/debug.c                |  189 +++++++
 drivers/usb/host/whci/hcd.c                  |    6 +-
 drivers/usb/host/whci/hw.c                   |    8 +-
 drivers/usb/host/whci/int.c                  |    1 -
 drivers/usb/host/whci/pzl.c                  |   49 +--
 drivers/usb/host/whci/qset.c                 |   40 --
 drivers/usb/host/whci/whcd.h                 |   11 +-
 drivers/usb/host/whci/whci-hc.h              |    2 +
 drivers/usb/host/whci/wusb.c                 |   43 +--
 drivers/usb/wusbcore/cbaf.c                  |    1 -
 drivers/usb/wusbcore/crypto.c                |   79 ++--
 drivers/usb/wusbcore/dev-sysfs.c             |    4 -
 drivers/usb/wusbcore/devconnect.c            |  233 +--------
 drivers/usb/wusbcore/mmc.c                   |  118 ++---
 drivers/usb/wusbcore/pal.c                   |   16 +-
 drivers/usb/wusbcore/reservation.c           |   21 +-
 drivers/usb/wusbcore/rh.c                    |  104 ++---
 drivers/usb/wusbcore/security.c              |   78 +---
 drivers/usb/wusbcore/wa-nep.c                |   16 +-
 drivers/usb/wusbcore/wa-rpipe.c              |   68 +--
 drivers/usb/wusbcore/wa-xfer.c               |  180 ++-----
 drivers/usb/wusbcore/wusbhc.h                |   36 +-
 drivers/uwb/Makefile                         |    3 +
 drivers/uwb/address.c                        |    2 +-
 drivers/uwb/allocator.c                      |  386 ++++++++++++++
 drivers/uwb/beacon.c                         |  134 ++---
 drivers/uwb/driver.c                         |    4 +-
 drivers/uwb/drp-avail.c                      |    4 +-
 drivers/uwb/drp-ie.c                         |  161 +++++--
 drivers/uwb/drp.c                            |  695
+++++++++++++++++++-------
 drivers/uwb/est.c                            |   14 +-
 drivers/uwb/hwa-rc.c                         |   53 ++-
 drivers/uwb/i1480/dfu/dfu.c                  |   10 +-
 drivers/uwb/i1480/dfu/mac.c                  |   18 -
 drivers/uwb/i1480/dfu/usb.c                  |   27 -
 drivers/uwb/i1480/i1480u-wlp/lc.c            |    5 +-
 drivers/uwb/i1480/i1480u-wlp/netdev.c        |   53 +--
 drivers/uwb/i1480/i1480u-wlp/rx.c            |   25 +-
 drivers/uwb/i1480/i1480u-wlp/sysfs.c         |    3 +-
 drivers/uwb/i1480/i1480u-wlp/tx.c            |   66 +---
 drivers/uwb/ie-rcv.c                         |   55 ++
 drivers/uwb/ie.c                             |  463 ++++++------------
 drivers/uwb/lc-dev.c                         |   23 +-
 drivers/uwb/lc-rc.c                          |   62 +--
 drivers/uwb/neh.c                            |   72 ++--
 drivers/uwb/pal.c                            |   25 +-
 drivers/uwb/radio.c                          |  202 ++++++++
 drivers/uwb/reset.c                          |   47 ++-
 drivers/uwb/rsv.c                            |  565 ++++++++++++++++-----
 drivers/uwb/umc-bus.c                        |   62 ++-
 drivers/uwb/umc-dev.c                        |   11 +-
 drivers/uwb/uwb-debug.c                      |  151 ++++--
 drivers/uwb/uwb-internal.h                   |  126 ++++-
 drivers/uwb/uwbd.c                           |  176 +++----
 drivers/uwb/whc-rc.c                         |  118 ++---
 drivers/uwb/whci.c                           |    6 +-
 drivers/uwb/wlp/eda.c                        |   19 +-
 drivers/uwb/wlp/messages.c                   |  181 +-------
 drivers/uwb/wlp/sysfs.c                      |    2 +-
 drivers/uwb/wlp/txrx.c                       |   37 +--
 drivers/uwb/wlp/wlp-internal.h               |    4 -
 drivers/uwb/wlp/wlp-lc.c                     |   80 +--
 drivers/uwb/wlp/wss-lc.c                     |  130 +----
 include/linux/usb/wusb-wa.h                  |    1 +
 include/linux/uwb.h                          |  123 ++++--
 include/linux/uwb/debug-cmd.h                |   13 +-
 include/linux/uwb/debug.h                    |   82 ---
 include/linux/uwb/spec.h                     |   53 ++
 include/linux/uwb/umc.h                      |    2 +
 include/linux/wlp.h                          |    3 +-
 75 files changed, 3252 insertions(+), 2837 deletions(-)
 create mode 100644 drivers/usb/host/whci/debug.c
 create mode 100644 drivers/uwb/allocator.c
 create mode 100644 drivers/uwb/ie-rcv.c
 create mode 100644 drivers/uwb/radio.c
 delete mode 100644 include/linux/uwb/debug.h

David Vrabel
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
