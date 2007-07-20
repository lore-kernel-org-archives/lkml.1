Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXGTTx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXGTTx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXGTTxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:53:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39544 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbXGTTxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:53:51 -0400
Date: Fri, 20 Jul 2007 16:29:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB updates
Message-Id: <1184961046.25136.33.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:
   - Some cleanups on several drivers;
   - Some fixes on ivtv driver;
   - Remove some memory leaks on wm8775 and wm8739;
   - Add missing <sys/time.h> for userspace V4L2 API;
   - Add check for valid control ID to v4l2_ctrl_next.

Cheers,
Mauro.

---

 drivers/media/common/ir-functions.c      |    4 +-
 drivers/media/dvb/ttpci/av7110.c         |    2 +-
 drivers/media/radio/radio-aimslab.c      |    2 +-
 drivers/media/radio/radio-cadet.c        |    4 +-
 drivers/media/radio/radio-gemtek-pci.c   |    3 --
 drivers/media/video/bt866.c              |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c   |    2 +-
 drivers/media/video/bt8xx/bttv-input.c   |    2 +-
 drivers/media/video/bt8xx/bttvp.h        |    4 +-
 drivers/media/video/c-qcam.c             |    4 +-
 drivers/media/video/cx88/cx88-video.c    |    8 +++++-
 drivers/media/video/cx88/cx88.h          |    2 +-
 drivers/media/video/ivtv/Kconfig         |    5 ++-
 drivers/media/video/ivtv/ivtv-driver.c   |   43 ++++++++++++++----------------
 drivers/media/video/ivtv/ivtv-driver.h   |    2 +-
 drivers/media/video/ivtv/ivtv-fileops.c  |    6 ++--
 drivers/media/video/ivtv/ivtv-firmware.c |   25 ++++++++---------
 drivers/media/video/ivtv/ivtv-gpio.c     |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c      |   20 +++++++-------
 drivers/media/video/ivtv/ivtv-irq.c      |   11 +++++---
 drivers/media/video/ivtv/ivtv-mailbox.c  |   33 ++++++++++++++---------
 drivers/media/video/ivtv/ivtv-streams.c  |   12 +++++---
 drivers/media/video/saa5249.c            |    8 +++---
 drivers/media/video/saa7110.c            |    4 +-
 drivers/media/video/saa7134/saa7134.h    |    2 +-
 drivers/media/video/tvaudio.c            |    4 +-
 drivers/media/video/v4l2-common.c        |   19 +++++++++---
 drivers/media/video/vino.c               |    2 +-
 drivers/media/video/wm8739.c             |    2 +
 drivers/media/video/wm8775.c             |    2 +
 include/linux/videodev2.h                |    1 +
 31 files changed, 134 insertions(+), 108 deletions(-)

Alexey Dobriyan (1):
      V4L/DVB (5852): ivtv: don't recompile needlessly

Cyrill Gorcunov (1):
      V4L/DVB (5871): Conexant 2388x: check for kthread_run

Hans Verkuil (9):
      V4L/DVB (5850): ivtv: improve API command debugging
      V4L/DVB (5851): ivtv: fix missing I2C_ALGOBIT config option
      V4L/DVB (5853): ivtv: add support to suppress high volume i2c debug messages.
      V4L/DVB (5854): ivtv: cleanup of driver messages
      V4L/DVB (5855): ivtv: fix Kconfig typo and refer to the driver homepage.
      V4L/DVB (5866): ivtv: fix DMA timeout when capturing VBI + another stream
      V4L/DVB (5867): videodev2.h: add missing <sys/time.h> for userspace
      V4L/DVB (5869): Add check for valid control ID to v4l2_ctrl_next.
      V4L/DVB (5880): wm8775/wm8739: Fix memory leak when unloading module

Mauro Carvalho Chehab (6):
      V4L/DVB (5857): Use msecs_to_jiffies instead of HZ on radio drivers
      V4L/DVB (5858): Use msecs_to_jiffies instead of HZ on media/video I2C drivers
      V4L/DVB (5859): use msecs_to_jiffies on InfraRed RC5 timeout
      V4L/DVB (5860): Use msecs_to_jiffies instead of HZ on some webcam drivers
      V4L/DVB (5861): Use msecs_to_jiffies instead of HZ on bttv, cx88 and saa7134
      V4L/DVB (5865): Remove usage of HZ on ivtv driver, replacing by msecs_to_jiffies

Trent Piepho (1):
      V4L/DVB (5877): radio-gemtek-pci: remove unused structure member

Yoann Padioleau (1):
      V4L/DVB (5848): Av7110: fix typo

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

