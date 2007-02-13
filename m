Return-Path: <linux-kernel-owner+w=401wt.eu-S1751087AbXBMVYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087AbXBMVYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXBMVYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:24:12 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:4390 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751087AbXBMVYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:24:11 -0500
Date: Tue, 13 Feb 2007 22:24:33 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux I2C <i2c@lm-sensors.org>
Subject: [GIT PULL] i2c updates for 2.6.21
Message-Id: <20070213222433.aad81b1a.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem updates for Linux 2.6.21 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

There is one new i2c bus driver (i2c-pasemi), support for two new south
bridges (ATI SB600 and VIA CX700), and lots of small fixes and cleanups
all around the place.

 Documentation/i2c/busses/i2c-i801                 |   60 +++
 Documentation/i2c/busses/i2c-parport              |   15 +
 Documentation/i2c/busses/i2c-piix4                |    2 
 Documentation/i2c/busses/i2c-viapro               |    7 
 Documentation/i2c/porting-clients                 |    6 
 Documentation/i2c/smbus-protocol                  |    2 
 Documentation/i2c/writing-clients                 |   58 ++-
 MAINTAINERS                                       |    6 
 drivers/acpi/i2c_ec.c                             |    1 
 drivers/hwmon/vt8231.c                            |    1 
 drivers/i2c/busses/Kconfig                        |   13 +
 drivers/i2c/busses/Makefile                       |    1 
 drivers/i2c/busses/i2c-ali1535.c                  |    1 
 drivers/i2c/busses/i2c-ali1563.c                  |   58 +--
 drivers/i2c/busses/i2c-ali15x3.c                  |    1 
 drivers/i2c/busses/i2c-amd756-s4882.c             |    2 
 drivers/i2c/busses/i2c-amd756.c                   |    1 
 drivers/i2c/busses/i2c-amd8111.c                  |   71 ++--
 drivers/i2c/busses/i2c-i801.c                     |    3 
 drivers/i2c/busses/i2c-i810.c                     |    2 
 drivers/i2c/busses/i2c-ibm_iic.c                  |    1 
 drivers/i2c/busses/i2c-isa.c                      |    1 
 drivers/i2c/busses/i2c-mv64xxx.c                  |    1 
 drivers/i2c/busses/i2c-nforce2.c                  |    3 
 drivers/i2c/busses/i2c-parport.h                  |    8 
 drivers/i2c/busses/i2c-pasemi.c                   |  426 +++++++++++++++++++++
 drivers/i2c/busses/i2c-piix4.c                    |    4 
 drivers/i2c/busses/i2c-powermac.c                 |    1 
 drivers/i2c/busses/i2c-savage4.c                  |    1 
 drivers/i2c/busses/i2c-sis5595.c                  |    1 
 drivers/i2c/busses/i2c-sis630.c                   |    1 
 drivers/i2c/busses/i2c-sis96x.c                   |    1 
 drivers/i2c/busses/i2c-via.c                      |    1 
 drivers/i2c/busses/i2c-viapro.c                   |    7 
 drivers/i2c/busses/i2c-voodoo3.c                  |    2 
 drivers/i2c/busses/scx200_acb.c                   |    7 
 drivers/i2c/busses/scx200_i2c.c                   |    1 
 drivers/i2c/i2c-core.c                            |   71 ++--
 drivers/ieee1394/pcilynx.c                        |    1 
 drivers/media/dvb/b2c2/flexcop-i2c.c              |    1 
 drivers/media/dvb/dvb-usb/dvb-usb-i2c.c           |    1 
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    1 
 drivers/media/video/cafe_ccic.c                   |    1 
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c    |    1 
 drivers/media/video/usbvision/usbvision-i2c.c     |    1 
 drivers/media/video/w9968cf.c                     |    1 
 drivers/media/video/zoran_card.c                  |    1 
 drivers/rtc/rtc-ds1672.c                          |    2 
 drivers/rtc/rtc-pcf8563.c                         |    2 
 drivers/rtc/rtc-rs5c372.c                         |    2 
 drivers/rtc/rtc-x1205.c                           |    2 
 drivers/video/matrox/i2c-matroxfb.c               |    1 
 include/linux/i2c-id.h                            |    5 
 include/linux/i2c.h                               |    7 
 include/linux/pci_ids.h                           |    1 
 55 files changed, 764 insertions(+), 116 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-pasemi.c

---------------

David Brownell:
      i2c/vt8231: Remove superfluous initialization
      i2c: Add driver suspend/resume/shutdown support

Jean Delvare:
      i2c-ali1563: Improve the status messages
      i2c-ali1563: Fix device initialization
      i2c-nforce2: Drop unused reference to pci_dev
      i2c-piix4: Add support for the ATI SB600
      i2c-i801: Spelling fix
      i2c-i801: Document the SMBus unhiding quirk
      i2c: completion header cleanups
      i2c: Update the list of bus IDs
      i2c-viapro: Add support for the VIA CX700 south bridge
      i2c-amd8111: Proposed cleanups
      i2c: Declare more i2c_adapter parent devices
      i2c: Remove the warning on missing adapter device
      i2c: Stop using i2c_adapter.class_dev

Jonathan McDowell:
      i2c-parport: Add support for One For All remote JP1 interface

Mike Frysinger:
      i2c: Fix typo in SMBus Write Word Data description

Olof Johansson:
      i2c: PA Semi SMBus driver

Stephen Hemminger:
      i2c: Add IDs to adapters

Thanks,
-- 
Jean Delvare
