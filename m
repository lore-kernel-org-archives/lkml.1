Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZCXVNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZCXVNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZCXVNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:10497 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZCXVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V9i3GTSOYUYMcBm09btjKs+C4rR5jQyzWwbZbCNuo/Yzpr56RdU0cipC7vUzhCAYys
         RnA9Yno55DUPF0EH8GFOzXpolkBKxSSkz/Qxedufgz5i9X+HztcW5kmyX1KkV3vxq5+d
         o1OPGauY2e9YcZWwcvTkCX1lsTXimYBLFcvBI=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 00/13] changes for ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:35 -0500
Message-Id: <1237929168-15341-1-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

This patch set changes some ioctl over to unlocked and adds all the necessary locks.

Stoyan Gaydarov (13):
  [staging] changed ioctls to unlocked
  [cris/arch-v10] changed ioctls to unlocked
  [oss] changed ioctls to unlocked
  [blackfin] changed ioctls to unlocked
  [s390] changed ioctls to unlocked
  [scsi] changed ioctls to unlocked
  [usb] changed ioctls to unlocked
  [watchdog] changed ioctls to unlocked
  [sbus] changed ioctls to unlocked
  [drivers/char] changed ioctls to unlocked
  [hwmon] changed ioctls to unlocked
  [drivers/media] changed ioctls to unlocked
  [drivers] changed ioctls to unlocked

 arch/blackfin/mach-bf561/coreb.c         |    8 +-
 arch/cris/arch-v10/drivers/ds1302.c      |   59 ++++++++++----
 arch/cris/arch-v10/drivers/gpio.c        |   28 ++++---
 arch/cris/arch-v10/drivers/pcf8563.c     |   33 ++++++--
 arch/cris/arch-v10/drivers/sync_serial.c |   18 +++--
 drivers/char/applicom.c                  |   16 +++-
 drivers/char/hpet.c                      |   12 ++-
 drivers/hwmon/fschmd.c                   |   15 +++-
 drivers/media/dvb/bt8xx/dst_ca.c         |    7 +-
 drivers/media/video/dabusb.c             |   11 ++-
 drivers/message/i2o/i2o_config.c         |   13 ++--
 drivers/parisc/eisa_eeprom.c             |    5 +-
 drivers/s390/char/tape_char.c            |   47 ++++++++----
 drivers/s390/char/vmwatchdog.c           |   57 +++++++++-----
 drivers/sbus/char/jsflash.c              |   15 +++-
 drivers/sbus/char/uctrl.c                |    7 +-
 drivers/scsi/osst.c                      |   12 ++-
 drivers/staging/epl/EplApiLinuxKernel.c  |   10 ++-
 drivers/staging/meilhaus/memain.c        |  124 ++++++++++++++++++++----------
 drivers/staging/poch/poch.c              |   25 +++++--
 drivers/usb/mon/mon_bin.c                |   53 +++++++++----
 drivers/watchdog/riowd.c                 |   37 +++++++---
 sound/oss/sh_dac_audio.c                 |   60 ++++++++++-----
 23 files changed, 454 insertions(+), 218 deletions(-)

