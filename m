Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbXLLB4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbXLLB4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXLLB4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:56:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37486 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbXLLB4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:56:39 -0500
Date: Tue, 11 Dec 2007 23:05:06 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB fixes
Message-Id: <1197424531.9563.6.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master

For the following:

   - several driver fixes at ivtv, em28xx, tvp5150, tda10086, saa7146, zl10353, 
     saa7134, saa7134-alsa, saa7134-dvb, cxusb, saa5246a and saa5249;

   - section fixes for bttv and ivtv;

   - Kconfig fixes for dib3000mc;

   - videobuf-core bad lock fixes;

   - memory leak fix at videobuf-vmalloc.

Cheers,
Mauro.

---

 drivers/media/common/saa7146_video.c          |   11 +-
 drivers/media/dvb/dvb-usb/Makefile            |    3 +
 drivers/media/dvb/dvb-usb/dibusb-common.c     |    4 +
 drivers/media/dvb/frontends/tda10086.c        |   14 +-
 drivers/media/dvb/frontends/zl10353.c         |    4 +-
 drivers/media/dvb/frontends/zl10353.h         |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c        |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c       |    9 +-
 drivers/media/video/cx88/cx88-blackbird.c     |    5 +-
 drivers/media/video/cx88/cx88-video.c         |    5 +-
 drivers/media/video/em28xx/em28xx-video.c     |    7 +-
 drivers/media/video/ivtv/ivtv-i2c.c           |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.h           |    2 +-
 drivers/media/video/ivtv/ivtv-streams.c       |    2 +-
 drivers/media/video/saa5246a.c                |   10 +-
 drivers/media/video/saa5249.c                 |    8 +-
 drivers/media/video/saa7134/saa7134-alsa.c    |   16 ++-
 drivers/media/video/saa7134/saa7134-cards.c   |    2 +-
 drivers/media/video/saa7134/saa7134-core.c    |   21 +-
 drivers/media/video/saa7134/saa7134-dvb.c     |    1 +
 drivers/media/video/saa7134/saa7134-empress.c |    5 +-
 drivers/media/video/saa7134/saa7134-video.c   |    5 +-
 drivers/media/video/tvp5150.c                 |   11 +
 drivers/media/video/videobuf-core.c           |  247 ++++++++++++++++---------
 drivers/media/video/videobuf-vmalloc.c        |    6 +-
 drivers/media/video/vivi.c                    |    1 +
 include/media/videobuf-core.h                 |    2 +
 27 files changed, 246 insertions(+), 161 deletions(-)

Adrian Bunk (2):
      V4L/DVB (6796): ivtv/ section fix
      V4L/DVB (6797): bt8xx/ section fixes

Benoit Istin (1):
      V4L/DVB (6746): saa7134-dvb: fix tuning for WinTV HVR-1110

Brandon Philips (4):
      V4L/DVB (6601): V4L: videobuf-core locking fixes and comments
      V4L/DVB (6602): V4L: Convert videobuf drivers to videobuf_stop
      V4L/DVB (6615): V4L: Fix VIDIOCGMBUF  locking in saa7146
      V4L/DVB (6751): V4L: Memory leak!  Fix count in videobuf-vmalloc mmap

Chris Pascoe (1):
      V4L/DVB (6629): zl10353: fix default adc_clock and TRL nominal rate calculation

Hans Verkuil (1):
      V4L/DVB (6485): ivtv: fix compile warning

Hartmut Hackmann (1):
      V4L/DVB (6579): Fix bug #8824: Correct support for Diseqc on tda10086

Heikki Lindholm (2):
      V4L/DVB (6666): saa7134-alsa: fix period handling
      V4L/DVB (6690): saa7134: fix ignored interrupts

Hermann Pitton (1):
      V4L/DVB (6686): saa7134: fix composite over s-video input on the Tevion MD 9717

Jiri Kosina (1):
      V4L/DVB (6733): DVB: Compile 3000MC-specific DIB code only for CONFIG_DVB_DIB3000MC

Mauro Carvalho Chehab (4):
      V4L/DVB (6542): Fix S-video mode on tvp5150
      V4L/DVB (6581): Fix: avoids negative vma usage count
      V4L/DVB (6750): Fix in-kernel compilation for cxusb
      V4L/DVB (6794): Fix compilation when dib3000mc is compiled as a module

Richard Knutsson (1):
      V4L/DVB (6684): Complement va_start() with va_end() + style fixes

Sascha Sommer (1):
      V4L/DVB (6540): em28xx: fix failing autodetection after the reboot

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

