Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZIDDf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZIDDf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 23:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZIDDf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 23:35:28 -0400
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:53860 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbZIDDf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 23:35:28 -0400
Date: Thu, 03 Sep 2009 23:35:29 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: [PULL] http://www.kernellabs.com/hg/~stoth/saa7164-merge
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Message-id: <4AA08B01.30705@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.1)
 Gecko/20090715 Thunderbird/3.0b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mauro,

This patch series adds support for the NXP SAA7164 PCIe A/V bridge used by the 
Hauppauge HVR-2200 and HVR-2250 series of products. Support is limited to DVB-T 
/ ATSC / QAM digital TV only. The driver has been in development (on and off) 
for around a year and the KernelLabs saa7164-stable tree (from which this patch 
set was prepared) has been in testing worldwide since approx May(?) 2009.

The project page including links for firmware downloads, MythTV and Wiki 
instructions is here: http://www.kernellabs.com/blog/?page_id=17

Two general observations with the tree:

1. The driver is a little verbose during initial module load, I need to trim a 
few lines of debug.
2. During 64bit compile I have one compile time warning to be addressed.

Both of these will be resolved shortly and should not stop the driver being 
merged and made available to a much wider range of testers.

So, please pull from http://www.kernellabs.com/hg/~stoth/saa7164-merge

    -  Add the SAA7164 I2C bus identifier
    -  SAA7164: Add support for the NXP SAA7164 silicon
    -  SAA7164: Fix some 32/64bit compile time warnings
    -  SAA7164: Adjust I/F's to the TDA10048 enabling DVB-T lock
    -  SAA7164: Email address change
    -  SAA7164: Remove volatiles for PCI writes (coding style violation)
    -  SAA7164: Increase firmware load tolerance
    -  SAA7164: OOPS avoidance during interrupt handling
    -  SAA7164: Removed spurious I2C errors during driver load with DVB-T boards.
    -  SAA7164: Fix the 88021 definition to work with production boards.
    -  SAA7164: Fixed the missing eeprom parse on a specific board.
    -  SAA7164: Fix IRQ related system hang when firmware is not found.
    -  SAA7164: Fix i2c eeprom read errors during load (some boards).
    -  SAA7164: Ensure we specify I/F's for all bandwidths
    -  SAA7164: Added waitsecs module parameter
    -  SAA7164: Cleanup a printk
    -  SAA7164: Increase the firmware command timeout to avoid firmware errors.
    -  SAA7164: Removed a duplicate call to address any PCI quirks.
    -  SAA7164: IRQ / message timeout related change
    -  SAA7164: Removed spurious debug
    -  SAA7164: HVR2250 changes related to attach time tuner configuration
    -  SAA7164: Remove meaningless if'0 code
    -  SAA7164: Minor i2c assignment cleanup
    -  SAA7164: Ensure the HVR-2200 second tuner is configured in slave mode.
    -  SAA7164: Add support for a new HVR-2250 hardware revision

  b/linux/Documentation/video4linux/CARDLIST.saa7164   |    8
  b/linux/drivers/media/video/saa7164/Kconfig          |   19
  b/linux/drivers/media/video/saa7164/Makefile         |   12
  b/linux/drivers/media/video/saa7164/saa7164-api.c    |  778 +++++++++
  b/linux/drivers/media/video/saa7164/saa7164-buffer.c |  162 ++
  b/linux/drivers/media/video/saa7164/saa7164-bus.c    |  448 +++++
  b/linux/drivers/media/video/saa7164/saa7164-cards.c  |  600 +++++++
  b/linux/drivers/media/video/saa7164/saa7164-cmd.c    |  529 ++++++
  b/linux/drivers/media/video/saa7164/saa7164-core.c   |  797 ++++++++++
  b/linux/drivers/media/video/saa7164/saa7164-dvb.c    |  594 +++++++
  b/linux/drivers/media/video/saa7164/saa7164-fw.c     |  632 +++++++
  b/linux/drivers/media/video/saa7164/saa7164-i2c.c    |  202 ++
  b/linux/drivers/media/video/saa7164/saa7164-reg.h    |  183 ++
  b/linux/drivers/media/video/saa7164/saa7164-types.h  |  287 +++
  b/linux/drivers/media/video/saa7164/saa7164.h        |  405 +++++
  b/v4l/scripts/saa7164.pl                             |   57
  linux/Documentation/video4linux/CARDLIST.saa7164     |    5
  linux/drivers/media/video/Kconfig                    |    2
  linux/drivers/media/video/Makefile                   |    1
  linux/drivers/media/video/saa7164/saa7164-api.c      |    6
  linux/drivers/media/video/saa7164/saa7164-buffer.c   |   15
  linux/drivers/media/video/saa7164/saa7164-bus.c      |    6
  linux/drivers/media/video/saa7164/saa7164-cards.c    |   74
  linux/drivers/media/video/saa7164/saa7164-cmd.c      |   47
  linux/drivers/media/video/saa7164/saa7164-core.c     |   98 -
  linux/drivers/media/video/saa7164/saa7164-dvb.c      |   70
  linux/drivers/media/video/saa7164/saa7164-fw.c       |   10
  linux/drivers/media/video/saa7164/saa7164.h          |   18
  linux/include/linux/i2c-id.h                         |    1
  v4l/scripts/cardlist                                 |    3
  v4l/scripts/fix_dvb_customise.pl                     |    3
  v4l/versions.txt                                     |    1
  32 files changed, 5956 insertions(+), 117 deletions(-)

Thanks,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
