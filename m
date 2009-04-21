Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZDUBMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZDUBMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZDUBL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:11:26 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:58340 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZDUBLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:11:23 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, gregkh@suse.de, kay.sievers@vrfy.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 0/4] fix some improper uses of dev_set_name
Date: Mon, 20 Apr 2009 21:17:12 -0300
Message-Id: <1240273036-5995-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_set_name expects a format string. Many of its uses, however, blindly
call it with a string variable that comes from some external, perhaps
unreliable source. Some of those uses are safe, like those in the third
patch in the series and most of those not fixed by any of them. Some few
remaining uses may require some more attention to decide if a patch is
really required. Perhaps converting all of them for safeness is a good
compromise.

Thadeu Lima de Souza Cascardo (4):
  driver core: use string format when name is another device's name
  driver core: use string format when name is given to an exported
    function
  input: set the device's name and copy it to private version
  ARM: use put_device instead of kfree

 arch/arm/common/sa1111.c            |    3 +--
 arch/microblaze/kernel/of_device.c  |    2 +-
 arch/powerpc/kernel/of_device.c     |    2 +-
 drivers/base/attribute_container.c  |    2 +-
 drivers/base/core.c                 |    4 ++--
 drivers/base/firmware_class.c       |    2 +-
 drivers/base/platform.c             |    2 +-
 drivers/ide/ide-cd.c                |    2 +-
 drivers/ide/ide-gd.c                |    2 +-
 drivers/ide/ide-tape.c              |    2 +-
 drivers/input/evdev.c               |    4 ++--
 drivers/input/joydev.c              |    4 ++--
 drivers/input/mousedev.c            |    8 ++++----
 drivers/isdn/mISDN/dsp_pipeline.c   |    2 +-
 drivers/misc/enclosure.c            |    4 ++--
 drivers/scsi/sd.c                   |    2 +-
 drivers/video/backlight/backlight.c |    2 +-
 drivers/video/backlight/lcd.c       |    2 +-
 drivers/video/output.c              |    2 +-
 fs/partitions/check.c               |    2 +-
 20 files changed, 27 insertions(+), 28 deletions(-)

